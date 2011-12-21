Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1LUUxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:53:03 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50701 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1LUUw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:52:59 -0500
Message-ID: <1324500775.2621.9.camel@edumazet-laptop>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Boot <bootc@bootc.net>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Wed, 21 Dec 2011 21:52:55 +0100
In-Reply-To: <1324499332.2621.7.camel@edumazet-laptop>
References: <4EF200BB.7000209@bootc.net>
	 <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EF2117F.6000803@bootc.net>
	 <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EF23BF2.4000601@bootc.net> <1324499332.2621.7.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 21 décembre 2011 à 21:28 +0100, Eric Dumazet a écrit :
> Le mercredi 21 décembre 2011 à 20:05 +0000, Chris Boot a écrit :
> > On 21/12/2011 18:00, Eric Dumazet wrote:
> > > Le mercredi 21 décembre 2011 à 18:36 +0100, Eric Dumazet a écrit :
> > >
> > >> Good point, thats a different problem then, since 3.1 is not supposed to
> > >> have this bug.
> > >>
> > >> It seems rt->rt6i_peer points to invalid memory in your crash.
> > >>
> > >> (RBX=00000000000001f4)
> > >>
> > >> 8b 83 a4 00 00 00       mov    0xa4(%rbx),%eax    p->refcnt
> > >> 1f4+a4 ->  CR2=0000000000000298
> > >>
> > > It would help if you can confirm latest linux tree can reproduce the
> > > bug.
> > 
> > Hi Eric,
> > 
> > I just built a v3.2-rc6-140-gb9e26df with the same config as the Debian 
> > 3.1.0 kernel. I can reproduce the bug just as easily with this kernel as 
> > with the Debian kernel. Unfortunately I wasn't able to get an entire 
> > trace, for some reason it didn't appear to be printed to the serial port 
> > and hung after the (long) list of loaded kernel modules. The crash 
> > happens at the same offset:
> > 
> 
> Thanks !
> 
> Oh well, br_netfilter fake_rtable strikes again.
> 
> I'll cook a patch in a couple of minutes...
> 

Could you try following patch ?

Thanks !

 include/net/dst.h         |    1 +
 net/bridge/br_netfilter.c |    2 +-
 net/ipv4/route.c          |    4 ++--
 net/ipv6/ip6_output.c     |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 6faec1a..75766b4 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -53,6 +53,7 @@ struct dst_entry {
 #define DST_NOHASH		0x0008
 #define DST_NOCACHE		0x0010
 #define DST_NOCOUNT		0x0020
+#define DST_NOPEER		0x0040
 
 	short			error;
 	short			obsolete;
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index d6ec372..5693e5f 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -141,7 +141,7 @@ void br_netfilter_rtable_init(struct net_bridge *br)
 	rt->dst.dev = br->dev;
 	rt->dst.path = &rt->dst;
 	dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
-	rt->dst.flags	= DST_NOXFRM;
+	rt->dst.flags	= DST_NOXFRM | DST_NOPEER;
 	rt->dst.ops = &fake_dst_ops;
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 46af623..7720403 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1271,7 +1271,7 @@ void __ip_select_ident(struct iphdr *iph, struct dst_entry *dst, int more)
 {
 	struct rtable *rt = (struct rtable *) dst;
 
-	if (rt) {
+	if (rt && !(rt->dst.flags & DST_NOPEER)) {
 		if (rt->peer == NULL)
 			rt_bind_peer(rt, rt->rt_dst, 1);
 
@@ -1282,7 +1282,7 @@ void __ip_select_ident(struct iphdr *iph, struct dst_entry *dst, int more)
 			iph->id = htons(inet_getid(rt->peer, more));
 			return;
 		}
-	} else
+	} else if (!rt)
 		printk(KERN_DEBUG "rt_bind_peer(0) @%p\n",
 		       __builtin_return_address(0));
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 84d0bd5..ec56271 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -603,7 +603,7 @@ void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 	static atomic_t ipv6_fragmentation_id;
 	int old, new;
 
-	if (rt) {
+	if (rt && !(rt->dst.flags & DST_NOPEER)) {
 		struct inet_peer *peer;
 
 		if (!rt->rt6i_peer)


