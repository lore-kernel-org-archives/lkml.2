Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1BRJ5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:57:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51775 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1BRJ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MuyN6jn3PKe2sEStJorxIgF+4SGIUjybBI/QxHpwpPlZ/23n735KYUxnC4xoeZRHog
         mn7vsXh6jGxl+uRcQEC6gBbWQfdSRUaGMiv+GG3gDoKp+goYBMqdoOeOIrZzxEfgCQy4
         LHCSPvFDpeDZFxYDNVf7jMnWKKwtT9aq7cdR0=
Subject: [PATCH] net: Add default_advmss() methods to blackhole dst_ops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: George Spelvin <linux@horizon.com>, David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>
In-Reply-To: <1298010735.2642.9.camel@edumazet-laptop>
References: <20110218050321.10415.qmail@science.horizon.com>
	 <1298010735.2642.9.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 10:57:03 +0100
Message-ID: <1298023023.2595.170.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 18 février 2011 à 07:32 +0100, Eric Dumazet a écrit :
> Le vendredi 18 février 2011 à 00:03 -0500, George Spelvin a écrit :
> > But wonder of wonders, kernel mode switching worked so I got to see the
> > oops on the text-mode console.  It happened just as I tried to ssh out.
> > 
> 
> CC netdev (removed linux-netdev)
> 
> I'll take a look this morning, thanks for the report.
> 
> > It's a Core 2 duo laptop (Dell E1405), 2 GB RAM, running a 32-bit kernel.
> > It's worth noting that I was using wired internet (b44 driver) and
> > not wireless.
> > 
> > I've been having a lot of weird lockups with 2.6.38-rcX, quite a change
> > from the very stable 2.6.36, but this is the first time I booted -rc5.
> > Also, the symptoms are very different; before the lockup did not seen
> > correlated with any particular activity, but the "lockup" was more like
> > something getting wedged in the kernel that more and more tasks would
> > get stuck on until everything stopped responding.
> > 
> > I should mention that this is transcribed by hand from the screen.
> > Oh, and also, it is far from the first time I ran ssh this boot.
> > (I re-tested it ater rebooting, just to be sure.  Not a consistent
> > crash.)
> > 
> > Anyway, jumping to address 0 looks "interesting", so it seems worth reporting.
> > 
> > BUG: unable to handle kernel NULL pointer dereference at   (null)
> > IP: [<  (null)>]   (null)
> > *pde = 00000000
> > Oops: 0000 [#1] SMP
> > last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/uevent
> > Modules linked in: rfcomm btusb sco l2cap crc16 bluetooth b43 mac80211 cfg80211 [last unloaded: sha256_generic]
> > 
> > Pid: 12178, comm: ssh Not tainted 2.6.38-rc5 #227 Dell Inc. MXC061                          /0MG532
> > EIP: 0060:[<00000000>] EFLAGS: 0021246 CPU: 0
> > EIP is at 0x0
> > EAX: f5947e00 EBX: f5982f80 ECX: 00000024 EDX: c148fe00
> > ESI: f5947e00 EDI: ebf29e54 EBP: ebf29ee0 ESP: ebf29dd0
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > Process ssh (pid: 12178, ti=ebf28000 task=ebefc6c0 task.ti = ebef28000)
> > Stack:
> >  c12c83ea 07e2427d 02000000 7b018f79 c117b827 0b996609 7b018f79 5f5f6644
> >  f5982f80 00000000 ebf29e58 ebf29ee0 c12cc0e0 00001600 00000000 00000001
> >  03641600 00000000 00000000 00000000 00000000 036423c0 3e6423c0 00000000
> > Call Trace:
> >  [<c12c83ea>] ? tcp_connect+0xdd/0x3fd
> >  [<c117b827>] ? secure_tcp_sequence_number+0x4f/0x65
> >  [<c12cc0e0>] ? tcp_v4_connect+0x3c1/0x417
> >  [<c12d6726>] ? inet_stream_connect+0x88/0x1fc
> >  [<c1110705>] ? _copy_from_user+0x2b/0x10e
> >  [<c129307d>] ? sys_connect+0x70/0x98
> >  [<c108df0f>] ? get_empty_filp+0x9f/0x121
> >  [<c108dfa0>] ? alloc_file+0xf/0x85
> >  [<c1293287>] ? sock_alloc_file+0x97/0xeb
> >  [<c108b758>] ? fd_install+0x1b/0x38
> >  [<c12932f6>] ? sock_map_fd+0x1b/0x20
> >  [<c1293bdf>] ? sys_socketcall+0x9d/0x291
> >  [<c1002750>] ? sysenter_do_call+0x12/0x26
> > Code:  Bad EIP value
> > EIP: [<00000000>] 0x0 SS:ESP 0068:ebf29dd0
> > CR2: 0000000000000000


I suspect following patch is needed

CC Roland Dreier <roland@purestorage.com> because he fixed the
default_mtu problem in commit ec831ea72ee5d7d47
(net: Add default_mtu() methods to blackhole dst_ops)

Thanks !

[PATCH] net: Add default_advmss() methods to blackhole dst_ops

Commit 0dbaee3b37e118a (net: Abstract default ADVMSS behind an
accessor.) introduced a possible crash in tcp_connect_init(), when
dst->default_advmss() is called from dst_metric_advmss()

Reported-by: George Spelvin <linux@horizon.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Roland Dreier <roland@purestorage.com>
---
 net/ipv4/route.c |    7 +++++++
 net/ipv6/route.c |    6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 788a3e7..5edb605 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2712,6 +2712,12 @@ static unsigned int ipv4_blackhole_default_mtu(const struct dst_entry *dst)
 	return 0;
 }
 
+static unsigned int ipv4_blackhole_default_advmss(const struct dst_entry *dst)
+{
+	return 256;
+}
+
+
 static void ipv4_rt_blackhole_update_pmtu(struct dst_entry *dst, u32 mtu)
 {
 }
@@ -2722,6 +2728,7 @@ static struct dst_ops ipv4_dst_blackhole_ops = {
 	.destroy		=	ipv4_dst_destroy,
 	.check			=	ipv4_blackhole_dst_check,
 	.default_mtu		=	ipv4_blackhole_default_mtu,
+	.default_advmss		=	ipv4_blackhole_default_advmss,
 	.update_pmtu		=	ipv4_rt_blackhole_update_pmtu,
 };
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1c29f95..2eeeabb 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -118,6 +118,11 @@ static unsigned int ip6_blackhole_default_mtu(const struct dst_entry *dst)
 	return 0;
 }
 
+static unsigned int ip6_blackhole_default_advmss(const struct dst_entry *dst)
+{
+	return 256;
+}
+
 static void ip6_rt_blackhole_update_pmtu(struct dst_entry *dst, u32 mtu)
 {
 }
@@ -128,6 +133,7 @@ static struct dst_ops ip6_dst_blackhole_ops = {
 	.destroy		=	ip6_dst_destroy,
 	.check			=	ip6_dst_check,
 	.default_mtu		=	ip6_blackhole_default_mtu,
+	.default_advmss		=	ip6_blackhole_default_advmss,
 	.update_pmtu		=	ip6_rt_blackhole_update_pmtu,
 };
 


