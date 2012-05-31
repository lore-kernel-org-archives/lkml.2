Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab2EaXaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 19:30:15 -0400
Received: from nm25.access.bullet.mail.sp2.yahoo.com ([98.139.44.152]:31701
	"HELO nm25.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758647Ab2EaXaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 19:30:13 -0400
X-Yahoo-Newman-Id: 108775.40422.bm@omp1001.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: B3nIL44VM1nW38ThqIeSc8DNZy0kFQca_GKpNIsh4cV2LvO
 CURN4etarZwY6zO9s6Q4IOIsG7elMEc.j5uPWbF55JtpeBNGXrWJRrSZW9bg
 86J8cwKwvQwQYhZCyZpOY4Dsv0CfohkbUtExyM8tmqyLtma9ZkZO5aFprVQg
 p.WXZfLnuqhPntcX_Qf6Gfl3iy8qXhtk9D12gKx2Bumw0MUbOJJxYKfhcA_X
 OGz2kWJQtrerQIphpCp1RY1I1zxLoHqH95qc2i8Y5Tg8TVo6WsY6lHU3Gzzk
 02fGXOoSTNjIXAStHQS9VXJUqJp8MWAlUSmZeR1pBTUly81B45X4D.ktj_Vj
 NP7DI8Gla55l8V3oSVh2VZOhontmQQBlFPV82aLNjPSZlyyKouTjQYxJOITc
 zhZh5Ig--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FC7FF02.6050304@att.net>
Date: Thu, 31 May 2012 18:30:10 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Kent Overstreet <koverstreet@google.com>, tj@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, axboe@kernel.dk,
        paul.gortmaker@windriver.com, Andi Kleen <andi@firstfloor.org>,
        jack@suse.cz, Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH v2 3/3] [RFC] Generic Red-Black Trees
References: <4FC7FD23.6080800@att.net> <4FC7FE2F.6010600@att.net>
In-Reply-To: <4FC7FE2F.6010600@att.net>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------090901020503080700080508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090901020503080700080508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I've put a few performance notes in comments.  Specifically, I'm curious
if an inline function that expands to 128+ bytes like this should
possibly be wrapped in an __attribute__((flatten))
__attribute__((noinline)) function to force full expansion in one place
and then prevent it from getting inlined elsewhere (to keep the
generated code size down).

--------------090901020503080700080508
Content-Type: text/x-patch;
 name="0008-Use-generic-rbtree-impl-in-fair-scheduler.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0008-Use-generic-rbtree-impl-in-fair-scheduler.patch"

>From 599576c4f48c97fe5e6f0cfa4e31d9dbb22ea043 Mon Sep 17 00:00:00 2001
From: Daniel Santos <daniel.santos@pobox.com>
Date: Thu, 31 May 2012 17:49:53 -0500
Subject: Use generic rbtree impl in fair scheduler

---
 kernel/sched/fair.c |   76 +++++++++++++++++++++++---------------------------
 1 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e955364..64e8c29 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -447,6 +447,19 @@ static inline int entity_before(struct sched_entity *a,
 	return (s64)(a->vruntime - b->vruntime) < 0;
 }
 
+static inline long compare_vruntime(u64 *a, u64 *b)
+{
+#if __BITS_PER_LONG >= 64
+	return (long)((s64)*a - (s64)*b);
+#else
+/* this is hacky -- we wont use this for rbtree lookups, only inserts, and
+ * since our relationship is defined as non-unique, we only need to return
+ * positive if a > b and any other value means less than.
+ */
+	return (long)(*a > *b);
+#endif
+}
+
 static void update_min_vruntime(struct cfs_rq *cfs_rq)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
@@ -472,57 +485,38 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 #endif
 }
 
+RB_DEFINE_INTERFACE(
+	fair_tree,
+	struct cfs_rq, tasks_timeline, rb_leftmost, /* no rightmost */,
+	struct sched_entity, run_node, vruntime,
+	0, compare_vruntime, 0)
+
+#ifndef __flatten
+#define __flatten __attribute__((flatten))
+#endif
+
 /*
- * Enqueue an entity into the rb-tree:
+ * Enqueue an entity into the rb-tree:(these are wrappers so that inline
+ * expansion happens in only one place)
+ *
+ * NOTE: When compiling under gcc 4.5 and 4.6 (amd64), it decided to inline
+ * these anyway.  I would be interested in profiling this as-is and declaring
+ * each function __flatten noinline (forcing all in-lining in the function, but
+ * preventing them from being inlined themselves).  Also, it may not do this on
+ * other archs where the (not sure, gcc docs don't seem to say anything about
+ * arch influence).
  */
 static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
-	struct rb_node *parent = NULL;
-	struct sched_entity *entry;
-	int leftmost = 1;
-
-	/*
-	 * Find the right place in the rbtree:
-	 */
-	while (*link) {
-		parent = *link;
-		entry = rb_entry(parent, struct sched_entity, run_node);
-		/*
-		 * We dont care about collisions. Nodes with
-		 * the same key stay together.
-		 */
-		if (entity_before(se, entry)) {
-			link = &parent->rb_left;
-		} else {
-			link = &parent->rb_right;
-			leftmost = 0;
-		}
-	}
-
-	/*
-	 * Maintain a cache of leftmost tree entries (it is frequently
-	 * used):
-	 */
-	if (leftmost)
-		cfs_rq->rb_leftmost = &se->run_node;
-
-	rb_link_node(&se->run_node, parent, link);
-	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+	fair_tree_insert(cfs_rq, se);
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (cfs_rq->rb_leftmost == &se->run_node) {
-		struct rb_node *next_node;
-
-		next_node = rb_next(&se->run_node);
-		cfs_rq->rb_leftmost = next_node;
-	}
-
-	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	fair_tree_remove(cfs_rq, se);
 }
 
+
 struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
-- 
1.7.3.4


--------------090901020503080700080508--
