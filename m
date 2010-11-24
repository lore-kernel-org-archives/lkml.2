Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab0KXTyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:54:47 -0500
Received: from web63407.mail.re1.yahoo.com ([69.147.97.47]:45666 "HELO
	web63407.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932114Ab0KXTyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:54:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=iVwg90KclmH18jUHB8LecMaHGKWmGrxP6rBJlcqx+FLpSntjuqIkWvj+Kr48oQmqMPy0M7VO0z4OSq+bsGWkal5uqG0aWTyrOGS3vpaWbk2dqo6GSjHUYYotG4t9qeQN+S23DfBrm+w581qVaYblNSgfQWVccjwgIuGD0GPewn8=;
Message-ID: <242082.99180.qm@web63407.mail.re1.yahoo.com>
X-YMail-OSG: EnpjZGsVM1msRjzlgZ4SniA5MS1cdCoosV1KTDiZxihZ7lo
 0hGqrKhXx3RwYJheTaaEisT7zVfa4jMitAzWwFTG1wu_SmCTQQwLXYiAqsRk
 NXKJdR7xWXsyws1TdmiQS1XmwCg3rqcliEg2oO1Vh4Mprfzh7OWm71ES7x0N
 ima8_JpXAcWcbdCES2zu.qCPM2ldANhOX0yGkS4cyMm44PPM5vUq6w9f6ypf
 dv0yTVCC9ndOPQX6.LC8twVsjHiKiJ.w_WSIJN_5t1t4Aqw6Z6kUvsn5OehK
 DFN55UFY_Z16UgNRz4KOO8pnZjuNDC4rpaX2R4d8qbvYi.2_fYMh36S6HudD
 qTgWfbXdRTV5HXr4DeulUow--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Wed, 24 Nov 2010 11:48:03 -0800 (PST)
From: Mike Caoco <caoco2002@yahoo.com>
Subject: Unplug ethernet cable, the route persists.  Why?
To: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: caoco2002@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This may have been discussed, but all search engines couldn't give me a good answer...

I notice that when an interface is up/running, a local route is in the routing table:

$ ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 00:13:20:0e:2f:ed  
          inet addr:192.168.1.125  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::213:20ff:fe0e:2fed/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:35984995 errors:0 dropped:0 overruns:0 frame:0
          TX packets:7409151 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:3252413825 (3.2 GB)  TX bytes:1340077250 (1.3 GB)

$ ip route
192.168.20.0/24 dev eth0  proto kernel  scope link  src 192.168.20.120
192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.125 
default via 192.168.20.254 dev eth1  metric 100 

After I unplug the cable from eth1, the RUNNING flag disappears, but the route is still there:

$ ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 00:13:20:0e:2f:ed  
          inet addr:192.168.1.125  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::213:20ff:fe0e:2fed/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:35985023 errors:0 dropped:0 overruns:0 frame:0
          TX packets:7409151 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:3252415633 (3.2 GB)  TX bytes:1340077250 (1.3 GB)

$ ip route
192.168.20.0/24 dev eth0  proto kernel  scope link  src 192.168.20.120 
192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.125 
default via 192.168.20.254 dev eth1  metric 100 

And that *prevents* from using the default route to reach 192.168.1/24 subnet after eth1 is out.

I looked at the code, it seems the IFF_RUNNING flag change is ignored in dev_change_flags():

void __dev_notify_flags(struct net_device *dev, unsigned int old_flags)
{
        .....
        if (dev->flags & IFF_UP &&
            (changes & ~(IFF_UP | IFF_PROMISC | IFF_ALLMULTI | IFF_VOLATILE)))
                call_netdevice_notifiers(NETDEV_CHANGE, dev);
}

I searched in the Internet, and saw some people suggest using an application listener (eg, netplug) to remove the route. 

My question is why cannot the kernel remove the route automatically when the link becomes down?  Why should this complexity be pushed to the user to find a program to do that?

Thanks,
Joe


      
