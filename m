Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461Ab2FGJQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:16:22 -0400
Received: from nm12-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.126]:28783
	"HELO nm12-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760429Ab2FGJQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:16:21 -0400
X-Yahoo-Newman-Id: 626829.85497.bm@omp1026.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ehKiyxYVM1kV08gENr85tHo2lQngDjUb8OCyd.LMshQXqYZ
 dYzUGBRJ.7Akc7buQj4_j4cZa.6bLVk3uZRm34RMEj_AK2dFnoqHLe5NSQnR
 wxor2_wjTQsbuyK9HT9jtfzsum8rUyKJpdZ88QyghdKGk7T8hfQxJXtCsNBZ
 xUu7VQ1ZJIyLYHYrkEmgrjZyATQUOAJkQ9SHwXeaGRHkJVBQQyWhMpN4ShE9
 igykcK6bxGxS9YtSU411rqJqWqn7e1ZM3H_SF3pcG7DINwlSbGuVYb5TcTMP
 7njcY2ArHviSzV0AHcBVv.ZSWfFfHNPXT82RbDXhT_MY.V1375nFwFCMGaco
 8ycDXMyPxkYja._X7BYubi8W2m73.IKQfA_XiVefme9NwZlCK0daR65GmvUd
 MZMYcQA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FD07168.2000907@att.net>
Date: Thu, 07 Jun 2012 04:16:24 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCHv3 6/6] [RFC] kernel/sched/fair.c: Use generic rbtree impl
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I'm running on my machine currently

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 kernel/sched/fair.c |   77 ++++++++++++++++++++++++---------------------------
 1 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 939fd63..093ae7f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -448,6 +448,20 @@ static inline int entity_before(struct sched_entity *a,
 	return (s64)(a->vruntime - b->vruntime) < 0;
 }
 +static inline long compare_vruntime(u64 *a, u64 *b)
+{
+#if __BITS_PER_LONG >= 64
+	return (long)((s64)*a - (s64)*b);
+#else
+/* This is hacky, but is done to reduce instructions -- we wont use this for
+ * rbtree lookups, only inserts, and since our relationship is defined as
+ * non-unique, we only need to return positive if a > b and any other value
+ * means less than.
+ */
+	return (long)(*a > *b);
+#endif
+}
+
 static void update_min_vruntime(struct cfs_rq *cfs_rq)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
@@ -473,57 +487,38 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
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

