Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0LEIEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 03:04:05 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56997 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab0LEIEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 03:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jSKraeKQ2IVcaW5/RiZGdcDWFKyfATbuCeM9A47cvkHDPsYHy8aiHIZFLirmHt/r3x
         CP5z2L8wxXWoch4FniciI+8eAUGlyAC/wHKVgzTwBiZC0flLZhHigw2jz4dXOH2OpRCq
         w0C7ZuvPOatrvgrxRQtrEPwQBtgBuqSm/OvfY=
Subject: Re: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid not
 used
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michael Leun <lkml20101129@newton.leun.net>
Cc: David Miller <davem@davemloft.net>, Ben Greear <greearb@candelatech.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Gross <jesse@nicira.com>, stable@kernel.org
In-Reply-To: <20101205030712.36149bc2@xenia.leun.net>
References: <20101129201716.1d0257c4@xenia.leun.net>
	 <4CF442FA.4070701@candelatech.com> <20101130095944.41b5f7b6@xenia.leun.net>
	 <1291108809.2904.3.camel@edumazet-laptop>
	 <20101201111716.424fb771@xenia.leun.net>
	 <1291200914.2856.546.camel@edumazet-laptop>
	 <20101205030712.36149bc2@xenia.leun.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Dec 2010 09:03:53 +0100
Message-ID: <1291536233.2806.102.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 05 décembre 2010 à 03:07 +0100, Michael Leun a écrit :
> On Wed, 01 Dec 2010 11:55:14 +0100
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Le mercredi 01 décembre 2010 à 11:17 +0100, Michael Leun a écrit :
> > 
> > > Yup, from what I've tested this works (and tcpdump sees broadcast
> > > packets even for vlans not configured at the moment including vlan
> > > tag
> > > - yipee!).
> > >
> 
> This was tested on machine with
> root@tp_z61m:~/src/tcpdump-4.1.1# lspci|grep Eth
> 02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752M Gigabit Ethernet PCI Express (rev 02)
> 
> There it works as I said.
> 
> But on
> 
> hpdl320g5:/home/ml # lspci | grep Eth
> 03:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5714 Gigabit Ethernet (rev a3)
> 03:04.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5714 Gigabit Ethernet (rev a3)
> 
> the good message is that it also does not crash, but with tcpdump I see
> vlan tags when no vlan devices configured on the respective eth, if so
> I do not see tags anymore vlan tags on the trunk interface.
> 

For all these very specific needs, you'll have to try 2.6.37 I am
afraid. Jesse did huge changes to exactly make this working, we wont
backport this to 2.6.36, but only avoid crashes.


> hpdl320g5:/home/ml # ifconfig -a
> [...]
> eth1      Link encap:Ethernet  Hardware Adresse xx:xx:xx:xx:xx:xx  
>           UP BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 Sendewarteschlangenlänge:1000 
>           RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
>           Interrupt:17 
> [...]
> 
> hpdl320g5:/home/ml # tcpdump -i eth1 -n -e
> tcpdump: WARNING: eth1: no IPv4 address assigned
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on eth1, link-type EN10MB (Ethernet), capture size 96 bytes
> [...]
> 02:45:57.597640 xx:xx:xx:xx:xx:xx > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 64: vlan 1505, p 0, ethertype 802.1Q, vlan 99, p 3, ethertype ARP, arp who-has 10.0.0.1 tell 10.0.0.2
> 02:45:57.622654 xx:xx:xx:xx:xx:xx > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 64: vlan 1505, p 0, ethertype 802.1Q, vlan 99, p 3, ethertype ARP, arp who-has 10.0.0.1 tell 10.0.0.2
> [...]
> 
> hpdl320g5:/home/ml # vconfig add eth1 2
> WARNING:  Could not open /proc/net/vlan/config.  Maybe you need to load the 8021q module, or maybe you are not using PROCFS??
> Added VLAN with VID == 2 to IF -:eth1:-
> hpdl320g5:/home/ml # cat /proc/net/vlan/config 
> VLAN Dev name    | VLAN ID
> Name-Type: VLAN_NAME_TYPE_RAW_PLUS_VID_NO_PAD
> eth1.2         | 2  | eth1
> hpdl320g5:/home/ml # tcpdump -i eth1 -n -e
> tcpdump: WARNING: eth1: no IPv4 address assigned
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on eth1, link-type EN10MB (Ethernet), capture size 96 bytes
> [...]
> 02:50:18.095959 xx:xx:xx:xx:xx:xx > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 60: vlan 99, p 3, ethertype ARP, arp who-has 10.0.0.1 tell 10.0.0.2
> 02:50:18.120989 xx:xx:xx:xx:xx:xx > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 60: vlan 99, p 3, ethertype ARP, arp who-has 10.0.0.1 tell 10.0.0.2
> [...]
> 
> The same packages we saw double vlan tagged a few minutes ago now appear single vlan tagged (and of course, other packets that were shown single vlan tagged before are now shown without vlan tag / eth type 0x0800).
> 
> 
> On the other machine:
> 
> root@tp_z61m:~# cat /proc/net/vlan/config 
> VLAN Dev name    | VLAN ID
> Name-Type: VLAN_NAME_TYPE_RAW_PLUS_VID_NO_PAD
> eth0.741       | 741  | eth0
> eth0.2         | 2  | eth0
> root@tp_z61m:~/src/tcpdump-4.1.1# ./tcpdump -i eth0 -n -e not port 22
> tcpdump: WARNING: eth0: no IPv4 address assigned
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on eth0, link-type EN10MB (Ethernet), capture size 65535 bytes
> 03:06:51.859016 xx:xx:xx:xx:xx:xx > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 64: vlan 1505, p 0, ethertype 802.1Q, vlan 99, p 3, ethertype ARP, Request who-has 10.0.0.1 tell 10.0.0.2, length 42
> 03:06:51.883956 xx:xx:xx:xx:xx:xx > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 64: vlan 1505, p 0, ethertype 802.1Q, vlan 99, p 3, ethertype ARP, Request who-has 10.0.0.1 tell 10.0.0.2, length 42
> 
> 
> 
> [...]
> > Here is the revised patch again then for stable team, via David Miller
> > agreement.
> [...]
> 


