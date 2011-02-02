Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1BBAoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:8119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab1BBAoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418140"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: eric.dumazet@gmail.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [65/139] filter: fix sk_filter rcu handling
Message-Id: <20110202004421.D1C9B3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 46bcf14f44d8f31ecfdc8b6708ec15a3b33316d9 ]

Pavel Emelyanov tried to fix a race between sk_filter_(de|at)tach and
sk_clone() in commit 47e958eac280c263397

Problem is we can have several clones sharing a common sk_filter, and
these clones might want to sk_filter_attach() their own filters at the
same time, and can overwrite old_filter->rcu, corrupting RCU queues.

We can not use filter->rcu without being sure no other thread could do
the same thing.

Switch code to a more conventional ref-counting technique : Do the
atomic decrement immediately and queue one rcu call back when last
reference is released.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/net/sock.h |    4 +++-
 net/core/filter.c  |   19 ++++++-------------
 2 files changed, 9 insertions(+), 14 deletions(-)

Index: linux-2.6.35.y/include/net/sock.h
===================================================================
--- linux-2.6.35.y.orig/include/net/sock.h
+++ linux-2.6.35.y/include/net/sock.h
@@ -1151,6 +1151,8 @@ extern void sk_common_release(struct soc
 /* Initialise core socket variables */
 extern void sock_init_data(struct socket *sock, struct sock *sk);
 
+extern void sk_filter_release_rcu(struct rcu_head *rcu);
+
 /**
  *	sk_filter_release - release a socket filter
  *	@fp: filter to remove
@@ -1161,7 +1163,7 @@ extern void sock_init_data(struct socket
 static inline void sk_filter_release(struct sk_filter *fp)
 {
 	if (atomic_dec_and_test(&fp->refcnt))
-		kfree(fp);
+		call_rcu_bh(&fp->rcu, sk_filter_release_rcu);
 }
 
 static inline void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp)
Index: linux-2.6.35.y/net/core/filter.c
===================================================================
--- linux-2.6.35.y.orig/net/core/filter.c
+++ linux-2.6.35.y/net/core/filter.c
@@ -589,23 +589,16 @@ int sk_chk_filter(struct sock_filter *fi
 EXPORT_SYMBOL(sk_chk_filter);
 
 /**
- * 	sk_filter_rcu_release: Release a socket filter by rcu_head
+ * 	sk_filter_release_rcu - Release a socket filter by rcu_head
  *	@rcu: rcu_head that contains the sk_filter to free
  */
-static void sk_filter_rcu_release(struct rcu_head *rcu)
+void sk_filter_release_rcu(struct rcu_head *rcu)
 {
 	struct sk_filter *fp = container_of(rcu, struct sk_filter, rcu);
 
-	sk_filter_release(fp);
-}
-
-static void sk_filter_delayed_uncharge(struct sock *sk, struct sk_filter *fp)
-{
-	unsigned int size = sk_filter_len(fp);
-
-	atomic_sub(size, &sk->sk_omem_alloc);
-	call_rcu_bh(&fp->rcu, sk_filter_rcu_release);
+	kfree(fp);
 }
+EXPORT_SYMBOL(sk_filter_release_rcu);
 
 /**
  *	sk_attach_filter - attach a socket filter
@@ -650,7 +643,7 @@ int sk_attach_filter(struct sock_fprog *
 	rcu_read_unlock_bh();
 
 	if (old_fp)
-		sk_filter_delayed_uncharge(sk, old_fp);
+		sk_filter_uncharge(sk, old_fp);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sk_attach_filter);
@@ -664,7 +657,7 @@ int sk_detach_filter(struct sock *sk)
 	filter = rcu_dereference_bh(sk->sk_filter);
 	if (filter) {
 		rcu_assign_pointer(sk->sk_filter, NULL);
-		sk_filter_delayed_uncharge(sk, filter);
+		sk_filter_uncharge(sk, filter);
 		ret = 0;
 	}
 	rcu_read_unlock_bh();
