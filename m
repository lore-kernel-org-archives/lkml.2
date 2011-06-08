Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1FHTds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:33:48 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55041 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab1FHTaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH tip/core/rcu 28/28] net,rcu: Convert call_rcu(sk_filter_release_rcu) to kfree_rcu
Date: Wed,  8 Jun 2011 12:30:07 -0700
Message-Id: <1307561407-13809-28-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU callback sk_filter_release_rcu just calls kfree(), so we use
kfree_rcu() instead of call_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/net/sock.h |    4 +---
 net/core/filter.c  |   12 ------------
 2 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 01810a3..60caa06 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1179,8 +1179,6 @@ extern void sk_common_release(struct sock *sk);
 /* Initialise core socket variables */
 extern void sock_init_data(struct socket *sock, struct sock *sk);
 
-extern void sk_filter_release_rcu(struct rcu_head *rcu);
-
 /**
  *	sk_filter_release - release a socket filter
  *	@fp: filter to remove
@@ -1191,7 +1189,7 @@ extern void sk_filter_release_rcu(struct rcu_head *rcu);
 static inline void sk_filter_release(struct sk_filter *fp)
 {
 	if (atomic_dec_and_test(&fp->refcnt))
-		call_rcu(&fp->rcu, sk_filter_release_rcu);
+		kfree_rcu(fp, rcu);
 }
 
 static inline void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp)
diff --git a/net/core/filter.c b/net/core/filter.c
index afb8afb..7195ce0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -631,18 +631,6 @@ int sk_chk_filter(struct sock_filter *filter, int flen)
 EXPORT_SYMBOL(sk_chk_filter);
 
 /**
- * 	sk_filter_release_rcu - Release a socket filter by rcu_head
- *	@rcu: rcu_head that contains the sk_filter to free
- */
-void sk_filter_release_rcu(struct rcu_head *rcu)
-{
-	struct sk_filter *fp = container_of(rcu, struct sk_filter, rcu);
-
-	kfree(fp);
-}
-EXPORT_SYMBOL(sk_filter_release_rcu);
-
-/**
  *	sk_attach_filter - attach a socket filter
  *	@fprog: the filter program
  *	@sk: the socket to use
-- 
1.7.3.2

