Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0FNVnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:43:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:46936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695Ab0FNVjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:21 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/30] workqueue: add find_worker_executing_work() and track current_cwq
Date: Mon, 14 Jun 2010 23:37:37 +0200
Message-Id: <1276551467-21246-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all the workers are tracked by gcwq, we can find which worker
is executing a work from gcwq.  Implement find_worker_executing_work()
and make worker track its current_cwq so that we can find things the
other way around.  This will be used to implement non-reentrant wqs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2ce895e..7111683 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -82,6 +82,7 @@ struct worker {
 	};
 
 	struct work_struct	*current_work;	/* L: work being processed */
+	struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
 	struct global_cwq	*gcwq;		/* I: the associated gcwq */
@@ -373,6 +374,59 @@ static struct hlist_head *busy_worker_head(struct global_cwq *gcwq,
 }
 
 /**
+ * __find_worker_executing_work - find worker which is executing a work
+ * @gcwq: gcwq of interest
+ * @bwh: hash head as returned by busy_worker_head()
+ * @work: work to find worker for
+ *
+ * Find a worker which is executing @work on @gcwq.  @bwh should be
+ * the hash head obtained by calling busy_worker_head() with the same
+ * work.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ *
+ * RETURNS:
+ * Pointer to worker which is executing @work if found, NULL
+ * otherwise.
+ */
+static struct worker *__find_worker_executing_work(struct global_cwq *gcwq,
+						   struct hlist_head *bwh,
+						   struct work_struct *work)
+{
+	struct worker *worker;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry(worker, tmp, bwh, hentry)
+		if (worker->current_work == work)
+			return worker;
+	return NULL;
+}
+
+/**
+ * find_worker_executing_work - find worker which is executing a work
+ * @gcwq: gcwq of interest
+ * @work: work to find worker for
+ *
+ * Find a worker which is executing @work on @gcwq.  This function is
+ * identical to __find_worker_executing_work() except that this
+ * function calculates @bwh itself.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ *
+ * RETURNS:
+ * Pointer to worker which is executing @work if found, NULL
+ * otherwise.
+ */
+static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
+						 struct work_struct *work)
+{
+	return __find_worker_executing_work(gcwq, busy_worker_head(gcwq, work),
+					    work);
+}
+
+/**
  * insert_work - insert a work into cwq
  * @cwq: cwq @work belongs to
  * @work: work to insert
@@ -914,6 +968,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	debug_work_deactivate(work);
 	hlist_add_head(&worker->hentry, bwh);
 	worker->current_work = work;
+	worker->current_cwq = cwq;
 	work_color = get_work_color(work);
 	list_del_init(&work->entry);
 
@@ -942,6 +997,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	/* we're done with it, release */
 	hlist_del_init(&worker->hentry);
 	worker->current_work = NULL;
+	worker->current_cwq = NULL;
 	cwq_dec_nr_in_flight(cwq, work_color);
 }
 
-- 
1.6.4.2

