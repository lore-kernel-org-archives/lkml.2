Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1AFAtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:49:46 -0500
Received: from kroah.org ([198.145.64.141]:35752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1AFAaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:00 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:03 2011
Message-Id: <20110106002303.050907181@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [068/152] filter: fix sk_filter rcu handling
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
---
 include/net/sock.h |    4 +++-
 net/core/filter.c  |   19 ++++++-------------
 2 files changed, 9 insertions(+), 14 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1155,6 +1155,8 @@ extern void sk_common_release(struct soc
 /* Initialise core socket variables */
 extern void sock_init_data(struct socket *sock, struct sock *sk);
 
+extern void sk_filter_release_rcu(struct rcu_head *rcu);
+
 /**
  *	sk_filter_release - release a socket filter
  *	@fp: filter to remove
@@ -1165,7 +1167,7 @@ extern void sock_init_data(struct socket
 static inline void sk_filter_release(struct sk_filter *fp)
 {
 	if (atomic_dec_and_test(&fp->refcnt))
-		kfree(fp);
+		call_rcu_bh(&fp->rcu, sk_filter_release_rcu);
 }
 
 static inline void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp)
--- a/net/core/filter.c
+++ b/net/core/filter.c
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


