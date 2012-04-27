Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183Ab2D0SaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:30:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53226 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761122Ab2D0SaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:30:02 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: netdev@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 2/2] netfilter: conntrack: replace mutex with cmpxchg
Date: Fri, 27 Apr 2012 14:28:53 -0400
Message-Id: <1335551333-6103-2-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335551333-6103-1-git-send-email-bpoirier@suse.de>
References: <1335551333-6103-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mutex protects a single pointer.
---
 net/netfilter/nf_conntrack_ecache.c |   38 +++++++++-------------------------
 1 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 0134009..603eb69 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -25,8 +25,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
-static DEFINE_MUTEX(nf_ct_ecache_mutex);
-
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
 void nf_ct_deliver_cached_events(struct nf_conn *ct)
@@ -80,52 +78,36 @@ EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 int nf_conntrack_register_notifier(struct net *net,
 				   struct nf_ct_event_notifier *new)
 {
-	int ret = 0;
-
-	mutex_lock(&nf_ct_ecache_mutex);
-	if (net->ct.nf_conntrack_event_cb != NULL)
-		ret = -EBUSY;
+	if (cmpxchg(&net->ct.nf_conntrack_event_cb, NULL, new) != NULL)
+		return -EBUSY;
 	else
-		net->ct.nf_conntrack_event_cb = new;
-	mutex_unlock(&nf_ct_ecache_mutex);
-
-	return ret;
+		return 0;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
 
 void nf_conntrack_unregister_notifier(struct net *net,
 				      struct nf_ct_event_notifier *new)
 {
-	mutex_lock(&nf_ct_ecache_mutex);
-	BUG_ON(net->ct.nf_conntrack_event_cb != new);
-	net->ct.nf_conntrack_event_cb = NULL;
-	mutex_unlock(&nf_ct_ecache_mutex);
+	if (xchg(&net->ct.nf_conntrack_event_cb, NULL) != new)
+		BUG();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
 
 int nf_ct_expect_register_notifier(struct net *net,
 				   struct nf_exp_event_notifier *new)
 {
-	int ret = 0;
-
-	mutex_lock(&nf_ct_ecache_mutex);
-	if (net->ct.nf_expect_event_cb != NULL)
-		ret = -EBUSY;
+	if (cmpxchg(&net->ct.nf_expect_event_cb, NULL, new) != NULL)
+		return -EBUSY;
 	else
-		net->ct.nf_expect_event_cb = new;
-	mutex_unlock(&nf_ct_ecache_mutex);
-
-	return ret;
+		return 0;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_register_notifier);
 
 void nf_ct_expect_unregister_notifier(struct net *net,
 				      struct nf_exp_event_notifier *new)
 {
-	mutex_lock(&nf_ct_ecache_mutex);
-	BUG_ON(net->ct.nf_expect_event_cb != new);
-	net->ct.nf_expect_event_cb = NULL;
-	mutex_unlock(&nf_ct_ecache_mutex);
+	if (xchg(&net->ct.nf_expect_event_cb, NULL) != new)
+		BUG();
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 
-- 
1.7.7

