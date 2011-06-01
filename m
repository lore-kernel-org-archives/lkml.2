Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab1FAA6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:58:16 -0400
Received: from outmail008.snc4.facebook.com ([66.220.144.140]:54165 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932638Ab1FAA6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:58:14 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] atomic: generalize atomic_add_unless_return
Date: Tue, 31 May 2011 17:57:56 -0700
Message-Id: <1306889876-5327-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 686a7e3 added this primitive to get something going
for the stable branch.

Move the primitive to <linux/atomic.h>

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <20110531105019.GF24172@elte.hu>
---
 include/linux/atomic.h |   14 ++++++++++++++
 net/ipv4/inetpeer.c    |   17 ++---------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index fc31190..4e2c272 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -17,6 +17,20 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 }
 
 /**
+ * atomic_add_unless - add unless the number is already a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as @v was not already @u.
+ * Returns the old value of @v + @a.
+ */
+static inline int atomic_add_unless_return(atomic_t *v, int a, int u)
+{
+	return __atomic_add_unless(v, a, u) + a;
+}
+
+/**
  * atomic_inc_not_zero - increment unless the number is zero
  * @v: pointer of type atomic_t
  *
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index ce616d9..d4190ae 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -203,20 +203,6 @@ static int addr_compare(const struct inetpeer_addr *a,
 	u;							\
 })
 
-static bool atomic_add_unless_return(atomic_t *ptr, int a, int u, int *newv)
-{
-	int cur, old = atomic_read(ptr);
-
-	while (old != u) {
-		*newv = old + a;
-		cur = atomic_cmpxchg(ptr, old, *newv);
-		if (cur == old)
-			return true;
-		old = cur;
-	}
-	return false;
-}
-
 /*
  * Called with rcu_read_lock()
  * Because we hold no lock against a writer, its quite possible we fall
@@ -239,7 +225,8 @@ static struct inet_peer *lookup_rcu(const struct inetpeer_addr *daddr,
 			 * distinction between an unused entry (refcnt=0) and
 			 * a freed one.
 			 */
-			if (!atomic_add_unless_return(&u->refcnt, 1, -1, newrefcnt))
+			*newrefcnt = atomic_add_unless_return(&u->refcnt, 1, -1);
+			if (*newrefcnt == 0)
 				u = NULL;
 			return u;
 		}
-- 
1.7.4

