FROM ubuntu:14.04

MAINTAINER Victor Y. Sklyar <vinnitu@gmail.com>

#RUN apt-get update -y
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget supervisor unzip ca-certificates

#RUN echo 'deb http://repo.acestream.org/ubuntu/ precise main' > /etc/apt/sources.list.d/acestream.list
#RUN wget -q -O - http://repo.acestream.org/keys/acestream.public.key | apt-key add -
#RUN DEBIAN_FRONTEND=noninteractive apt-get update -y

#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y acestream-engine vlc-nox python-gevent

#RUN mkdir -p /var/run/sshd
#RUN mkdir -p /var/log/supervisor

#RUN adduser --disabled-password --gecos "" tv

#RUN cd /tmp/ && wget https://github.com/ValdikSS/aceproxy/archive/6dff4771c3.zip -O master.zip
#RUN cd /tmp/ && unzip master.zip -d /home/tv/
#RUN mv /home/tv/aceproxy-* /home/tv/aceproxy-master

#RUN echo 'root:password' |chpasswd

#ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#ADD start.sh /start.sh
#RUN chmod +x /start.sh

#EXPOSE 22 8000 62062

#ENTRYPOINT ["/start.sh"]

#--------------------

#ENV build_date 2014-10-02

#RUN apt-get install kernel-headers gcc gcc-c++ cpp ncurses ncurses-devel libxml2 libxml2-devel sqlite sqlite-devel openssl-devel newt-devel kernel-devel libuuid-devel net-snmp-devel xinetd tar -y

#ENV AUTOBUILD_UNIXTIME 1418234402

# Download asterisk.
# Currently Certified Asterisk 11.6 cert 6.
RUN curl -sf -o /tmp/asterisk.tar.gz -L http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-11.6-current.tar.gz

# gunzip asterisk
RUN mkdir /tmp/asterisk
RUN tar -xzf /tmp/asterisk.tar.gz -C /tmp/asterisk --strip-components=1
WORKDIR /tmp/asterisk

# make asterisk.
ENV rebuild_date 2014-10-07
# Configure
RUN ./configure --libdir=/usr/lib64 1> /dev/null
# Remove the native build option
RUN make menuselect.makeopts
RUN sed -i "s/BUILD_NATIVE//" menuselect.makeopts
# Continue with a standard make.
RUN make 1> /dev/null
RUN make install 1> /dev/null
RUN make samples 1> /dev/null
WORKDIR /

#RUN mkdir -p /etc/asterisk
## ADD modules.conf /etc/asterisk/
#ADD iax.conf /etc/asterisk/
#ADD extensions.conf /etc/asterisk/

#CMD asterisk -f