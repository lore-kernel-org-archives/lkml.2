Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964992Ab1DNSRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:17:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:41813 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964857Ab1DNR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 147/209] filter: fix sk_filter rcu handling
Date: Thu, 14 Apr 2011 13:55:05 -0400
Message-Id: <1302803767-9715-34-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 46bcf14f44d8f31ecfdc8b6708ec15a3b33316d9 upstream

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/sock.h |    4 +++-
 net/core/filter.c  |   19 ++++++-------------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index dc251e0..721c7b3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1073,6 +1073,8 @@ extern void sk_common_release(struct sock *sk);
 /* Initialise core socket variables */
 extern void sock_init_data(struct socket *sock, struct sock *sk);
 
+extern void sk_filter_release_rcu(struct rcu_head *rcu);
+
 /**
  *	sk_filter_release - release a socket filter
  *	@fp: filter to remove
@@ -1083,7 +1085,7 @@ extern void sock_init_data(struct socket *sock, struct sock *sk);
 static inline void sk_filter_release(struct sk_filter *fp)
 {
 	if (atomic_dec_and_test(&fp->refcnt))
-		kfree(fp);
+		call_rcu_bh(&fp->rcu, sk_filter_release_rcu);
 }
 
 static inline void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp)
diff --git a/net/core/filter.c b/net/core/filter.c
index 3462e9d..2bc5376 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -472,23 +472,16 @@ int sk_chk_filter(struct sock_filter *filter, int flen)
 EXPORT_SYMBOL(sk_chk_filter);
 
 /**
- * 	sk_filter_rcu_release: Release a socket filter by rcu_head
+ * 	sk_filter_release_rcu: Release a socket filter by rcu_head
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
@@ -533,7 +526,7 @@ int sk_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 	rcu_read_unlock_bh();
 
 	if (old_fp)
-		sk_filter_delayed_uncharge(sk, old_fp);
+		sk_filter_uncharge(sk, old_fp);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sk_attach_filter);
@@ -547,7 +540,7 @@ int sk_detach_filter(struct sock *sk)
 	filter = rcu_dereference_bh(sk->sk_filter);
 	if (filter) {
 		rcu_assign_pointer(sk->sk_filter, NULL);
-		sk_filter_delayed_uncharge(sk, filter);
+		sk_filter_uncharge(sk, filter);
 		ret = 0;
 	}
 	rcu_read_unlock_bh();
-- 
1.7.4.4

