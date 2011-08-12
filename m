Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1HNQJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:09:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab1HNQJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:57 2011
Message-Id: <20110812210557.370532056@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Kozlov <xeb@mail.ru>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [60/90] gre: fix improper error handling
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "xeb@mail.ru" <xeb@mail.ru>

[ Upstream commit 559fafb94ad9e4cd8774f39241917c57396f9fc5 ]

Fix improper protocol err_handler, current implementation is fully
unapplicable and may cause kernel crash due to double kfree_skb.

Signed-off-by: Dmitry Kozlov <xeb@mail.ru>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/gre.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/net/ipv4/gre.c
+++ b/net/ipv4/gre.c
@@ -15,6 +15,7 @@
 #include <linux/kmod.h>
 #include <linux/skbuff.h>
 #include <linux/in.h>
+#include <linux/ip.h>
 #include <linux/netdevice.h>
 #include <linux/version.h>
 #include <linux/spinlock.h>
@@ -97,27 +98,17 @@ drop:
 static void gre_err(struct sk_buff *skb, u32 info)
 {
 	const struct gre_protocol *proto;
-	u8 ver;
-
-	if (!pskb_may_pull(skb, 12))
-		goto drop;
+	const struct iphdr *iph = (const struct iphdr *)skb->data;
+	u8 ver = skb->data[(iph->ihl<<2) + 1]&0x7f;
 
-	ver = skb->data[1]&0x7f;
 	if (ver >= GREPROTO_MAX)
-		goto drop;
+		return;
 
 	rcu_read_lock();
 	proto = rcu_dereference(gre_proto[ver]);
-	if (!proto || !proto->err_handler)
-		goto drop_unlock;
-	proto->err_handler(skb, info);
-	rcu_read_unlock();
-	return;
-
-drop_unlock:
+	if (proto && proto->err_handler)
+		proto->err_handler(skb, info);
 	rcu_read_unlock();
-drop:
-	kfree_skb(skb);
 }
 
 static const struct net_protocol net_gre_protocol = {


