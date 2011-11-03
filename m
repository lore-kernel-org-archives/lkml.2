Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1KCOoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:44:18 -0400
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:51195 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755632Ab1KCOoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:44:17 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Nov 2011 10:44:16 EDT
Date: Thu, 3 Nov 2011 15:37:34 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: Route cache problem. 
Message-ID: <20111103143734.GA17218@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

My workstation has an incorrect route cache entry: 

assurancetourix:~> route -nC | head -2 ; route -nC | grep 234.34
Kernel IP routing cache
Source          Destination     Gateway         Flags Metric Ref    Use Iface
192.168.235.8   192.168.234.34  192.168.235.251       0      0        3 eth0
192.168.235.8   192.168.234.34  192.168.235.251       0      0        4 eth0
192.168.235.8   192.168.234.34  192.168.235.251       0      0        2 eth0

(I don't know why there are three). 

the correct routing cache entries would look something like this: 
(this one works):
assurancetourix:~> route -nC | head -2 ; route -nC | grep 234.20
Kernel IP routing cache
Source          Destination     Gateway         Flags Metric Ref    Use Iface
192.168.235.8   192.168.234.20  192.168.235.4         0      0        1 eth0
192.168.234.20  192.168.235.8   192.168.235.8   l     0      0        0 lo
192.168.235.8   192.168.234.20  192.168.235.4         0      0        0 eth0

The routing table is: 

Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.235.251 0.0.0.0         UG    0      0        0 eth0
169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 eth0
192.168.234.0   192.168.235.4   255.255.255.0   UG    0      0        0 eth0
192.168.235.0   0.0.0.0         255.255.255.0   U     1      0        0 eth0
192.168.235.2   192.168.235.4   255.255.255.255 UGH   0      0        0 eth0

It's the third line that is supposed to steer packets for '234.34 to 
the proper router that knows how to reach the 234.0 network. 

As a temporary workaround I've added the route to 192.168.235.2 which
is that same host, but not in the nameserver, so it's annoying. 
(the other host that I can't  reach due to this problem doesn't have
a second IP address (yet)). 

Oh... routing to 192.168.234.34 works on the router 192.168.235.4: 
PING 192.168.234.34 (192.168.234.34) 56(84) bytes of data.
64 bytes from 192.168.234.34: icmp_req=1 ttl=64 time=41.5 ms

Anyway, what would you suggest for me to try to get that invalid
route cache entry dropped?

Drop the default route? Ok. Done: 
# route del default
# ping 192.168.234.34
2 packets transmitted, 0 received, 100% packet loss, time 1007ms

I'm used to the default route being at the bottom, but deleting it should
be enough to prevent it from being found first, right? :-)

Add a host route to this host explicitly naming the router?

assurancetourix:~# route add 192.168.234.34 gw driepoot
assurancetourix:~# route -n 
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 eth0
192.168.234.0   192.168.235.4   255.255.255.0   UG    0      0        0 eth0
192.168.234.34  192.168.235.4   255.255.255.255 UGH   0      0        0 eth0
192.168.235.0   0.0.0.0         255.255.255.0   U     1      0        0 eth0
192.168.235.2   192.168.235.4   255.255.255.255 UGH   0      0        0 eth0
assurancetourix:~# ping 192.168.234.34 -c 2
....
2 packets transmitted, 0 received, 100% packet loss, time 1008ms

Still the packets end up on the ethernet with the 192.168.235.251 router's 
Ethernet address..... 

assurancetourix:~# route -nC | head -2 ; route -nC | grep 234.34
Kernel IP routing cache
Source          Destination     Gateway         Flags Metric Ref    Use Iface
192.168.235.8   192.168.234.34  192.168.235.251       0      0        0 eth0
192.168.235.8   192.168.234.34  192.168.235.251       0      0        0 eth0
192.168.235.8   192.168.234.34  192.168.235.251       0      0        5 eth0


# ifconfig eth0 down
# route -n 
<empty table> 
# ifconfig eth0 up
<old routing table is restored automatically??? apparently with the routing
cache entries as well....> 


I initially thought that this was a problem with the routing
cache entry being too persistent in the kernel. While documenting
this while writing this email, I've found that I can flush the whole routing
cache with "ip route flush cache"  . 

However the routing cache entry springs back to life when I first
ping the 234.34 host. Even when the problem machine doesn't have a
default route, so it shouldn't know about the 235.251 default router. 

This is getting weirder and weirder. 

During all this I have
# tcpdump -nei eth0 net 192.168.234.0/24
running. If my machine were to get an ICMP redirect from somewhere
I'd see it, right? 

It could be that the 192.168.235.251 router is proxy-arping (incorreclty)
for the problem hosts. But then my workstation would have to be
ARPing in the first place. 

# route add 192.168.234.200 eth0
# ping 192.168.234.200
gives: 
15:31:33.857343 00:23:54:15:1f:a9 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 42: Request who-has 192.168.234.200 tell 192.168.235.8, length 28
in the TCPDUMP, so my machine is not arping for 192.168.234.34. 

Any suggestions? Any at all?

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
The plan was simple, like my brother-in-law Phil. But unlike
Phil, this plan just might work.
