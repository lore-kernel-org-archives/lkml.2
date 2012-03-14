Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030530Ab2CNGTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:19:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47281 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030314Ab2CNGTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAB5soqGtXR_UyF6kaP9efwma=YBw99=A7OMN-MpD3QbnriVpfg@mail.gmail.com>
References: <CAB5soqGtXR_UyF6kaP9efwma=YBw99=A7OMN-MpD3QbnriVpfg@mail.gmail.com>
Date: Wed, 14 Mar 2012 14:19:13 +0800
Message-ID: <CAB5soqHPthgE_+AYqEbVin8G3O_fznjf_=muuVpOuJn4R4apng@mail.gmail.com>
Subject: 6to4 tunnel does NOT accept packet whose next-hop with 0x2002 prefix
From: Bin Tang <tb.bingel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sorry to bother you!

I found the source codes of net/ipv6/sit.c about 6to4 tunnel only
accepted packet with:
1> destination-address with 0x2002 as prefix
or
2> ip-address of next-hop is an IPv4-Compatible IPv6 address

and did NOT accept the packet whose ip-address of next-hop with 0x2002 prefix.

I'm wondering is this a bug for Linux kernel, because refer to
RFC4291, IPv4-Compatible IPv6 address
 is deprecated, so under most cases, the next-hop will be with 0x2002
prefix for the 6to4 tunnel.

Q: Can we change the code  to support to accept packet whose
ip-address of next-hop with
   0x2002 prefix?

The related source codes are as the followings:

http://lxr.linux.no/linux+v2.6.32/net/ipv6/sit.c#L597

******************************************************
 597  if (!dst)
 598     dst = try_6to4(&iph6->daddr);  <<<<<<<< Note (1)

 599
 600  if (!dst) {
 601     struct neighbour *neigh = NULL;
 602
 603     if (skb_dst(skb))
 604        neigh = skb_dst(skb)->neighbour;
.....
 612       addr6 = (struct in6_addr*)&neigh->primary_key;

+          dst = try_6to4(addr6);  <<<<<< add this line to check if
next-hop with 0x2002 prefix
+          if (!dst) {

 613       addr_type = ipv6_addr_type(addr6);
....
 620       if ((addr_type & IPV6_ADDR_COMPATv4) == 0) <<<<< Note (2)
 621         goto tx_error_icmp;   <<<<<<< Note (3)

 622
 623         dst = addr6->s6_addr32[3];
 624  }
+     }
******************************************************

Refer to Note(1):
The destination address of packet on tunnel interface should be
prefixed with "0x2002"

or [Refer to Note(2)] :
the address of its nexthop should be an IPv4-Compatible IPv6
Address(such as ::ipv4-addr).
otherwise, it will return from (Note (3)).

Let me take an example:

******************************************************

1. Setup 6to4 tunnel

bingel@binHTC:~$ sudo /sbin/ip tunnel add tun6to4 mode sit ttl 128 remote any
local 10.67.9.23
bingel@binHTC:~$ sudo /sbin/ip link set dev tun6to4 up
bingel@binHTC:~$ sudo /sbin/ip -6 addr add 2002:a43:917::1/16 dev tun6to4


2. Add route (next-hop is with 2002 prefix)
bingel@binHTC:~$ sudo /sbin/ip -6 route add 2000::/3 via 2002:c058:6301::1 dev
tun6to4 metric 1


3. open session and tcpdump the eth0 interface
bingel@binHTC:~$ sudo tcpdump -i eth0 | grep IP6
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
<<<<< no output when we did step 4

4. ping6 ipv6.google.com
bingel@binHTC:~$ sudo ping6 ipv6.google.com
PING ipv6.google.com(2404:6800:8005::68) 56 data bytes
>From 2002:a43:917::1 icmp_seq=1 Destination unreachable: Address unreachable
>From 2002:a43:917::1 icmp_seq=2 Destination unreachable: Address unreachable
>From 2002:a43:917::1 icmp_seq=3 Destination unreachable: Address unreachable
>From 2002:a43:917::1 icmp_seq=4 Destination unreachable: Address unreachable
>From 2002:a43:917::1 icmp_seq=5 Destination unreachable: Address unreachable
>From 2002:a43:917::1 icmp_seq=6 Destination unreachable: Address unreachable


5. Change route to an IPv4 compatible IPv6 address
<<<< first delete the previous route
bingel@binHTC:~$ sudo /sbin/ip -6 route del 2000::/3 via 2002:c058:6301::1 dev
tun6to4 metric 1
<<<<< add new route with nexthop using IPv4 compatible address
bingel@binHTC:~$ sudo /sbin/ip -6 route add 2000::/3 via ::192.88.99.1 dev
tun6to4 metric 1

6. open another session and tcpdump the eth0 interface
bingel@binHTC:~$ sudo tcpdump -i eth0 | grep IP6
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
14:05:46.759000 IP binHTC > 192.88.99.1: IP6 2002:a43:917::1 >
2404:6800:8005::68: ICMP6, echo request, seq 1, length 64
14:05:47.767683 IP binHTC > 192.88.99.1: IP6 2002:a43:917::1 >
2404:6800:8005::68: ICMP6, echo request, seq 2, length 64
14:05:48.775663 IP binHTC > 192.88.99.1: IP6 2002:a43:917::1 >
2404:6800:8005::68: ICMP6, echo request, seq 3, length 64
<<<<< Dumped the packets when we did step 7

7. ping6 ipv6.google.com
bingel@binHTC:~$ sudo ping6 ipv6.google.com -c 3
PING ipv6.google.com(2404:6800:8005::68) 56 data bytes

--- ipv6.google.com ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2016ms

bingel@binHTC:~$

******************************************************

Looking forward to your replies!

Thanks!

Best Wished!
--------------------
   Bin Tang
