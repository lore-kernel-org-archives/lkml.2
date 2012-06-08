Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626Ab2FHFJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:09:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43357 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761433Ab2FHFHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:35 -0400
Message-Id: <20120608041849.557697900@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Peter Huang (Peng)" <peter.huangpeng@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 65/82] set fake_rtables dst to NULL to avoid kernel Oops
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Peter Huang (Peng)" <peter.huangpeng@huawei.com>

[ Upstream commit a881e963c7fe1f226e991ee9bbe8907acda93294 ]

bridge: set fake_rtable's dst to NULL to avoid kernel Oops

when bridge is deleted before tap/vif device's delete, kernel may
encounter an oops because of NULL reference to fake_rtable's dst.
Set fake_rtable's dst to NULL before sending packets out can solve
this problem.

v4 reformat, change br_drop_fake_rtable(skb) to {}

v3 enrich commit header

v2 introducing new flag DST_FAKE_RTABLE to dst_entry struct.

[ Use "do { } while (0)" for nop br_drop_fake_rtable()
  implementation -DaveM ]

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Peter Huang <peter.huangpeng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/netfilter_bridge.h |    9 +++++++++
 include/net/dst.h                |    1 +
 net/bridge/br_forward.c          |    1 +
 net/bridge/br_netfilter.c        |    8 ++------
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 0ddd161..31d2844 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -104,9 +104,18 @@ struct bridge_skb_cb {
 	} daddr;
 };
 
+static inline void br_drop_fake_rtable(struct sk_buff *skb)
+{
+	struct dst_entry *dst = skb_dst(skb);
+
+	if (dst && (dst->flags & DST_FAKE_RTABLE))
+		skb_dst_drop(skb);
+}
+
 #else
 #define nf_bridge_maybe_copy_header(skb)	(0)
 #define nf_bridge_pad(skb)			(0)
+#define br_drop_fake_rtable(skb)	        do { } while (0)
 #endif /* CONFIG_BRIDGE_NETFILTER */
 
 #endif /* __KERNEL__ */
diff --git a/include/net/dst.h b/include/net/dst.h
index 75766b4..65bca65 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -54,6 +54,7 @@ struct dst_entry {
 #define DST_NOCACHE		0x0010
 #define DST_NOCOUNT		0x0020
 #define DST_NOPEER		0x0040
+#define DST_FAKE_RTABLE		0x0080
 
 	short			error;
 	short			obsolete;
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index ee64287..e221f88 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -47,6 +47,7 @@ int br_dev_queue_push_xmit(struct sk_buff *skb)
 		kfree_skb(skb);
 	} else {
 		skb_push(skb, ETH_HLEN);
+		br_drop_fake_rtable(skb);
 		dev_queue_xmit(skb);
 	}
 
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index fa8b8f7..577ea5d 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -147,7 +147,7 @@ void br_netfilter_rtable_init(struct net_bridge *br)
 	rt->dst.dev = br->dev;
 	rt->dst.path = &rt->dst;
 	dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
-	rt->dst.flags	= DST_NOXFRM | DST_NOPEER;
+	rt->dst.flags	= DST_NOXFRM | DST_NOPEER | DST_FAKE_RTABLE;
 	rt->dst.ops = &fake_dst_ops;
 }
 
@@ -687,11 +687,7 @@ static unsigned int br_nf_local_in(unsigned int hook, struct sk_buff *skb,
 				   const struct net_device *out,
 				   int (*okfn)(struct sk_buff *))
 {
-	struct rtable *rt = skb_rtable(skb);
-
-	if (rt && rt == bridge_parent_rtable(in))
-		skb_dst_drop(skb);
-
+	br_drop_fake_rtable(skb);
 	return NF_ACCEPT;
 }
 


