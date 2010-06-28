Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0F1VGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:06:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:42826 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab0F1VGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:06:05 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 32/35] workqueue: implement cpu intensive workqueue
Date: Mon, 28 Jun 2010 23:04:20 +0200
Message-Id: <1277759063-24607-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:05:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements cpu intensive workqueue which can be specified
with WQ_CPU_INTENSIVE flag on creation.  Works queued to a cpu
intensive workqueue don't participate in concurrency management.  IOW,
it doesn't contribute to gcwq->nr_running and thus doesn't delay
excution of other works.

Note that although cpu intensive works won't delay other works, they
can be delayed by other works.  Combine with WQ_HIGHPRI to avoid being
delayed by other works too.

As the name suggests this is useful when using workqueue for cpu
intensive works.  Workers executing cpu intensive works are not
considered for workqueue concurrency management and left for the
scheduler to manage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 006dcf7..3f36d37 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -232,6 +232,7 @@ enum {
 	WQ_NON_REENTRANT	= 1 << 2, /* guarantee non-reentrance */
 	WQ_RESCUER		= 1 << 3, /* has an rescue worker */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
+	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_DFL_ACTIVE		= WQ_MAX_ACTIVE / 2,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e12f9aa..25dce40 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -52,8 +52,10 @@ enum {
 	WORKER_PREP		= 1 << 3,	/* preparing to run works */
 	WORKER_ROGUE		= 1 << 4,	/* not bound to any cpu */
 	WORKER_REBIND		= 1 << 5,	/* mom is home, come back */
+	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
 
-	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_ROGUE | WORKER_REBIND,
+	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_ROGUE | WORKER_REBIND |
+				  WORKER_CPU_INTENSIVE,
 
 	/* gcwq->trustee_state */
 	TRUSTEE_START		= 0,		/* start */
@@ -1641,6 +1643,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 	struct global_cwq *gcwq = cwq->gcwq;
 	struct hlist_head *bwh = busy_worker_head(gcwq, work);
+	bool cpu_intensive = cwq->wq->flags & WQ_CPU_INTENSIVE;
 	work_func_t f = work->func;
 	int work_color;
 	struct worker *collision;
@@ -1692,6 +1695,13 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 			gcwq->flags &= ~GCWQ_HIGHPRI_PENDING;
 	}
 
+	/*
+	 * CPU intensive works don't participate in concurrency
+	 * management.  They're the scheduler's responsibility.
+	 */
+	if (unlikely(cpu_intensive))
+		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
+
 	spin_unlock_irq(&gcwq->lock);
 
 	work_clear_pending(work);
@@ -1713,6 +1723,10 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 
 	spin_lock_irq(&gcwq->lock);
 
+	/* clear cpu intensive status */
+	if (unlikely(cpu_intensive))
+		worker_clr_flags(worker, WORKER_CPU_INTENSIVE);
+
 	/* we're done with it, release */
 	hlist_del_init(&worker->hentry);
 	worker->current_work = NULL;
-- 
1.6.4.2

