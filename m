Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab0HQOej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:34:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48140 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab0HQOeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JInYqSgL7vKtIcbJfdua4RPn7vjZ4psLZcAjTKG7Dk2CXXT3YfU5hB6HNk+Cn+IRW2
         Sm3BQOWf5IyN0E7UsffqhliKKq6U7FkFcbNzWe7sdYN5fWAe8CPfJq7nlmuInjqyY5kH
         r3D77uiKeHTw4sgi8hgSaOFbnpb/YXiFw9Db8=
Subject: Re: BUG: IPv6 stops working after a while, needs ip ne del command
 to reset
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Habets <thomas@habets.pp.se>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
In-Reply-To: <alpine.DEB.1.10.1008171547090.21857@red.crap.retrofitta.se>
References: <alpine.DEB.1.10.1008131952470.19570@red.crap.retrofitta.se>
	 <1281953960.2524.23.camel@edumazet-laptop>
	 <alpine.DEB.1.10.1008161224510.13728@red.crap.retrofitta.se>
	 <alpine.DEB.1.10.1008170719180.21857@red.crap.retrofitta.se>
	 <1282024802.2487.687.camel@edumazet-laptop>
	 <alpine.DEB.1.10.1008171053230.21857@red.crap.retrofitta.se>
	 <1282050920.2448.47.camel@edumazet-laptop>
	 <alpine.DEB.1.10.1008171547090.21857@red.crap.retrofitta.se>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 16:34:19 +0200
Message-ID: <1282055659.2448.58.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 août 2010 à 16:09 +0200, Thomas Habets a écrit :
> On Tue, 17 Aug 2010, Eric Dumazet wrote:
> > Can you try : "ifconfig eth0 allmulti"
> 
> That didn't help. "ifconfig eth0" and "ip l" shows that allmulti is now 
> set, but no other difference. Can't ping router, and router gets no answer 
> when pinging ff02::1. No message in dmesg saying allmulti isn't supported 
> or anything like that either.
> 
> > If you let a "tcpdump" running with -p option, do you receive the packet
> > sent to ethernet dest 33:33:ff:5c:00:02 ?
> 
> No. Commented tcpdump output below.
> 
> > If you can see it with tcpdump, then NIC gave the frame to us.
> 
> Seems to be invisible unless I or tcpdump set promisc mode. But when 
> promisc mode is set I can immediately see the 33:33:ff:5c:00:02 packet 
> (ND solicitation) and I see that Linux is answering it.
> 
> Here's a tcpdump from the Linux host. It's slightliy trimmed to fit in
> an email, but the full dump is at http://www.habets.pp.se/tmp/ipv6.pcap
> 
> $ sudo tcpdump -pnli eth0 -s0 -w ipv6.pcap ip6
> [...]
> 
> $ tcpdump -nlr ipv6.pcap
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:1 > 2a00:800:752:1::5c:2: ICMP6, echo reply
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:1 > 2a00:800:752:1::5c:2: ICMP6, echo reply
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:1 > 2a00:800:752:1::5c:2: ICMP6, echo reply
> 
> [ here I run "clear ipv6 neighbors" on the Cisco router ]
> 
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> [ ... more repeated echo requests, no reply ... ]
> 
> [ here i run "ip l set promisc on eth0" ]
> 
> 2a00:800:752:1::5c:1 > ff02::1:ff5c:2: ICMP6, neighbor solicitation, who 
> has 2a00:800:752:1::5c:2
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6,neighbor advertisement,
> tgt is 2a00:800:752:1::5c:2
> 2a00:800:752:1::5c:1 > 2a00:800:752:1::5c:2: ICMP6, echo reply
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:1 > 2a00:800:752:1::5c:2: ICMP6, echo reply
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:1 > 2a00:800:752:1::5c:2: ICMP6, echo reply
> 
> [ here I run "clear ipv6 neigbors" again ]
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request

I suspect its time to ask broadcom guys some help :)

I have same adapter here (Hewlett-Packard Company NC326m PCIe Dual Port
Adapter) and could not reproduce the problem.

Try following patch to check tg3 receives correct multicast list (its OK
for me, seen on dmesg output)

[17162.120238]  add mc_addr(ha->addr=33:33:00:00:00:01)
[17162.120270]  add mc_addr(ha->addr=01:00:5e:00:00:01)
[17162.120298]  add mc_addr(ha->addr=33:33:ff:87:96:ce)
[17162.120326]  add mc_addr(ha->addr=33:33:ff:5c:00:02)
[17162.120355] filters=80000001 00000000 00400000 40000000


But if problem remains even with "ifconfig eth0 allmulti" I suspect a
NIC firmware problem. (allmulti set to 1 all the 128 bits of filters)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index bc3af78..34510f5 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -9317,12 +9317,14 @@ static void __tg3_set_rx_mode(struct net_device *dev)
 		u32 crc;
 
 		netdev_for_each_mc_addr(ha, dev) {
+			pr_err("add mc_addr(ha->addr=%pM)\n", ha->addr);
 			crc = calc_crc(ha->addr, ETH_ALEN);
 			bit = ~crc & 0x7f;
 			regidx = (bit & 0x60) >> 5;
 			bit &= 0x1f;
 			mc_filter[regidx] |= (1 << bit);
 		}
+		pr_err("filters=%08X %08x %08x %08x\n", mc_filter[0], mc_filter[1], mc_filter[2], mc_filter[3]);
 
 		tw32(MAC_HASH_REG_0, mc_filter[0]);
 		tw32(MAC_HASH_REG_1, mc_filter[1]);


