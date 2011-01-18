Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1ARWEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:04:07 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33223 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1ARWEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V4MP7IOUoBqgXxeJZu0EgSqxBAvusBO8/NRm23BloVkc7G7T0jW76nF0NreHr0E6Fj
         cYFXwORy/yhmMi1lhb5/IRhD36IuHvtiG8py/5t+450H0kEgbByTpCikgjU2JxdHrTeM
         8GjS/N/38ymyN6grGX1UhsgAMo/X7A5uL1dQ8=
Subject: Re: [regression] 2.6.37+ commit 0363466866d9.... breaks tcp ipv6
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hans de Bruin <jmdebruin@xmsnet.nl>
Cc: Jesse Gross <jesse@nicira.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <4D36092B.1090406@xmsnet.nl>
References: <4D335417.80704@xmsnet.nl>	<4D35EF64.1040906@xmsnet.nl>
	 <AANLkTinejKw0pY5HncB2e0ocjqYuCwTBUwd2xkroWu+E@mail.gmail.com>
	 <4D36092B.1090406@xmsnet.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 23:03:58 +0100
Message-ID: <1295388238.8449.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 janvier 2011 à 22:42 +0100, Hans de Bruin a écrit :
> On 01/18/2011 09:06 PM, Jesse Gross wrote:
> > On Tue, Jan 18, 2011 at 11:52 AM, Hans de Bruin<jmdebruin@xmsnet.nl>  wrote:
> >> On 01/16/2011 09:24 PM, Hans de Bruin wrote:
> >>>
> >>> After last nights compile i lost the possibility to connect to ssh and
> >>> http over ipv6. The connection stops at syn_sent. connections to my
> >>> machine end in syn_recv. ping6 still works.
> >>>
> >>
> >> The bisect ended in:
> >>
> >> 0363466866d901fbc658f4e63dd61e7cc93dd0af is the first bad commit
> >> commit 0363466866d901fbc658f4e63dd61e7cc93dd0af
> >> Author: Jesse Gross<jesse@nicira.com>
> >> Date:   Sun Jan 9 06:23:35 2011 +0000
> >>
> >>     net offloading: Convert checksums to use centrally computed features.
> >>
> >>     In order to compute the features for other offloads (primarily
> >>     scatter/gather), we need to first check the ability of the NIC to
> >>     offload the checksum for the packet.  Since we have already computed
> >>     this, we can directly use the result instead of figuring it out
> >>     again.
> >>
> >>     Signed-off-by: Jesse Gross<jesse@nicira.com>
> >>     Signed-off-by: David S. Miller<davem@davemloft.net>
> >>
> >>
> >> ssh ::1  still works. And since dns still works I guess udp is not affected.
> >> My nic is a:
> >>
> >> 09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 Gigabit
> >> Ethernet PCI Express (rev 02)
> >
> > Are you using vlans?  If so, can you please test this patch?
> > http://patchwork.ozlabs.org/patch/79264/
> >
> 
> No I am not using vlans. The option is even not set in the config file. 
> Except for the disk less bit is a straightforward setup:
> 
>    bash-4.1# ip addr show
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
>      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>      inet 127.0.0.1/8 scope host lo
>      inet6 ::1/128 scope host
>         valid_lft forever preferred_lft forever
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP 
> qlen 1000
>      link/ether 00:1c:23:2d:73:87 brd ff:ff:ff:ff:ff:ff
>      inet 10.10.0.6/16 brd 10.10.255.255 scope global eth0
>      inet6 2001:610:76e:0:21c:23ff:fe2d:7387/64 scope global dynamic
>         valid_lft 86399sec preferred_lft 14399sec
>      inet6 fe80::21c:23ff:fe2d:7387/64 scope link
>         valid_lft forever preferred_lft forever
> 3: sit0: <NOARP> mtu 1480 qdisc noop state DOWN
>      link/sit 0.0.0.0 brd 0.0.0.0
> bash-4.1# ip route show
> 10.10.0.0/16 dev eth0  proto kernel  scope link  src 10.10.0.6
> default via 10.10.0.1 dev eth0
> bash-4.1# ip -6 route show
> 2001:610:76e::/64 dev eth0  proto kernel  metric 256  expires 86404sec
> fe80::/64 dev eth0  proto kernel  metric 256
> ff00::/8 dev eth0  metric 256
> default via fe80::230:18ff:feae:75d8 dev eth0  proto kernel  metric 1024 
>   expires 29sec hoplimit 64
> bash-4.1# iptables -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain OUTPUT (policy ACCEPT)
> target     prot opt source               destination
> bash-4.1# ip6tables -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain OUTPUT (policy ACCEPT)
> target     prot opt source               destination
> bash-4.1# brctl show
> bridge name     bridge id               STP enabled     interfaces
> bash-4.1# cat /proc/cmdline
> root=/dev/nfs nfsroot=10.10.0.2:/nfs/root/psion/,v3,tcp ro ip=::: ::dhcp 
> BOOT_IMAGE=nightlybuild-psion
> 


You could try "tcpdump -i eth0 ip6 -v"

I guess you receive frames with bad checksums

You can ask other system to not offload tx checksums

ethtool -K eth0 tx off

Please give result of (on both machines)
lspci -v


