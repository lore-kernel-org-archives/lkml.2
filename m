Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab1CVXJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:09:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1CVXJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:09:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=WkH2bnjC4fYPYg0QPD8GPNOT79sZnlXcrgYBbz8yYocr0B+p0n+PtmAZ3wQlKlwSq
	YDf2of62XG0Lr0SLEqcTQ==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH v2 3/8] cfq-iosched: Make async queues per cgroup
Date: Tue, 22 Mar 2011 16:08:50 -0700
Message-Id: <1300835335-2777-4-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300835335-2777-1-git-send-email-teravest@google.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently only one set of async queues. This patch moves them
to a per cgroup data structure. Changes are done to make sure per
cgroup async queue references are dropped when the cgroup goes away.

TESTED:
Verified by creating multiple cgroups that async queues were getting
created properly. Also made sure that the references are getting
dropped and queues getting deallocated properly in the two situations:
- Cgroup goes away first, while IOs are still being done.
- IOs stop getting done and then cgroup goes away.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |   57 +++++++++++++++++++++++++--------------------------
 1 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 74510f5..011d268 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -202,6 +202,12 @@ struct cfq_group {
 	struct cfq_rb_root service_trees[2][3];
 	struct cfq_rb_root service_tree_idle;
 
+	/*
+	 * async queue for each priority case
+	 */
+	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
+	struct cfq_queue *async_idle_cfqq;
+
 	unsigned long saved_workload_slice;
 	enum wl_type_t saved_workload;
 	enum wl_prio_t saved_serving_prio;
@@ -267,12 +273,6 @@ struct cfq_data {
 	struct cfq_queue *active_queue;
 	struct cfq_io_context *active_cic;
 
-	/*
-	 * async queue for each priority case
-	 */
-	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
-	struct cfq_queue *async_idle_cfqq;
-
 	sector_t last_position;
 
 	/*
@@ -455,6 +455,7 @@ static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 				       struct io_context *, gfp_t);
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
 						struct io_context *);
+static void cfq_put_async_queues(struct cfq_group *cfqg);
 
 static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_context *cic,
 					    bool is_sync)
@@ -1117,10 +1118,6 @@ static void cfq_put_group_ref(struct cfq_group *cfqg)
 
 static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 {
-	/* Currently, all async queues are mapped to root group */
-	if (!cfq_cfqq_sync(cfqq))
-		cfqg = &cfqq->cfqd->root_group;
-
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
 	cfq_get_group_ref(cfqq->cfqg);
@@ -1132,6 +1129,7 @@ static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	BUG_ON(hlist_unhashed(&cfqg->cfqd_node));
 
 	hlist_del_init(&cfqg->cfqd_node);
+	cfq_put_async_queues(cfqg);
 
 	/*
 	 * Put the reference taken at the time of creation so that when all
@@ -2929,15 +2927,13 @@ static void cfq_ioc_set_cgroup(struct io_context *ioc)
 #endif  /* CONFIG_CFQ_GROUP_IOSCHED */
 
 static struct cfq_queue *
-cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
-		     struct io_context *ioc, gfp_t gfp_mask)
+cfq_find_alloc_queue(struct cfq_data *cfqd, struct cfq_group *cfqg,
+		     bool is_sync, struct io_context *ioc, gfp_t gfp_mask)
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
 	struct cfq_io_context *cic;
-	struct cfq_group *cfqg;
 
 retry:
-	cfqg = cfq_get_cfqg(cfqd, 1);
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
@@ -2981,15 +2977,15 @@ retry:
 }
 
 static struct cfq_queue **
-cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
+cfq_async_queue_prio(struct cfq_group *cfqg, int ioprio_class, int ioprio)
 {
 	switch (ioprio_class) {
 	case IOPRIO_CLASS_RT:
-		return &cfqd->async_cfqq[0][ioprio];
+		return &cfqg->async_cfqq[0][ioprio];
 	case IOPRIO_CLASS_BE:
-		return &cfqd->async_cfqq[1][ioprio];
+		return &cfqg->async_cfqq[1][ioprio];
 	case IOPRIO_CLASS_IDLE:
-		return &cfqd->async_idle_cfqq;
+		return &cfqg->async_idle_cfqq;
 	default:
 		BUG();
 	}
@@ -3003,17 +2999,19 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 	const int ioprio_class = task_ioprio_class(ioc);
 	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
+	struct cfq_group *cfqg = cfq_get_cfqg(cfqd, 1);
 
 	if (!is_sync) {
-		async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class, ioprio);
+		async_cfqq = cfq_async_queue_prio(cfqg, ioprio_class,
+						  ioprio);
 		cfqq = *async_cfqq;
 	}
 
 	if (!cfqq)
-		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
+		cfqq = cfq_find_alloc_queue(cfqd, cfqg, is_sync, ioc, gfp_mask);
 
 	/*
-	 * pin the queue now that it's allocated, scheduler exit will prune it
+	 * pin the queue now that it's allocated, cgroup deletion will prune it
 	 */
 	if (!is_sync && !(*async_cfqq)) {
 		cfq_get_queue_ref(cfqq);
@@ -3826,19 +3824,19 @@ static void cfq_shutdown_timer_wq(struct cfq_data *cfqd)
 	cancel_work_sync(&cfqd->unplug_work);
 }
 
-static void cfq_put_async_queues(struct cfq_data *cfqd)
+static void cfq_put_async_queues(struct cfq_group *cfqg)
 {
 	int i;
 
 	for (i = 0; i < IOPRIO_BE_NR; i++) {
-		if (cfqd->async_cfqq[0][i])
-			cfq_put_queue_ref(cfqd->async_cfqq[0][i]);
-		if (cfqd->async_cfqq[1][i])
-			cfq_put_queue_ref(cfqd->async_cfqq[1][i]);
+		if (cfqg->async_cfqq[0][i])
+			cfq_put_queue_ref(cfqg->async_cfqq[0][i]);
+		if (cfqg->async_cfqq[1][i])
+			cfq_put_queue_ref(cfqg->async_cfqq[1][i]);
 	}
 
-	if (cfqd->async_idle_cfqq)
-		cfq_put_queue_ref(cfqd->async_idle_cfqq);
+	if (cfqg->async_idle_cfqq)
+		cfq_put_queue_ref(cfqg->async_idle_cfqq);
 }
 
 static void cfq_cfqd_free(struct rcu_head *head)
@@ -3866,8 +3864,9 @@ static void cfq_exit_queue(struct elevator_queue *e)
 		__cfq_exit_single_io_context(cfqd, cic);
 	}
 
-	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);
+	/* Release the queues of root group. */
+	cfq_put_async_queues(&cfqd->root_group);
 	cfq_blkiocg_del_blkio_group(&cfqd->root_group.blkg);
 
 	spin_unlock_irq(q->queue_lock);
-- 
1.7.3.1

