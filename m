Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab0FNVqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:46:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:46903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab0FNVjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:15 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/30] workqueue: implement WQ_NON_REENTRANT
Date: Mon, 14 Jun 2010 23:37:39 +0200
Message-Id: <1276551467-21246-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcwq managing all the workers and work->data pointing to the last
gcwq it was on, non-reentrance can be easily implemented by checking
whether the work is still running on the previous gcwq on queueing.
Implement it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   32 +++++++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 0a78141..07cf5e5 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -225,6 +225,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
 	WQ_SINGLE_CPU		= 1 << 1, /* only single cpu at a time */
+	WQ_NON_REENTRANT	= 1 << 2, /* guarantee non-reentrance */
 };
 
 extern struct workqueue_struct *
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f606c44..7994edb 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -534,11 +534,37 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	debug_work_activate(work);
 
-	/* determine gcwq to use */
+	/*
+	 * Determine gcwq to use.  SINGLE_CPU is inherently
+	 * NON_REENTRANT, so test it first.
+	 */
 	if (!(wq->flags & WQ_SINGLE_CPU)) {
-		/* just use the requested cpu for multicpu workqueues */
+		struct global_cwq *last_gcwq;
+
+		/*
+		 * It's multi cpu.  If @wq is non-reentrant and @work
+		 * was previously on a different cpu, it might still
+		 * be running there, in which case the work needs to
+		 * be queued on that cpu to guarantee non-reentrance.
+		 */
 		gcwq = get_gcwq(cpu);
-		spin_lock_irqsave(&gcwq->lock, flags);
+		if (wq->flags & WQ_NON_REENTRANT &&
+		    (last_gcwq = get_work_gcwq(work)) && last_gcwq != gcwq) {
+			struct worker *worker;
+
+			spin_lock_irqsave(&last_gcwq->lock, flags);
+
+			worker = find_worker_executing_work(last_gcwq, work);
+
+			if (worker && worker->current_cwq->wq == wq)
+				gcwq = last_gcwq;
+			else {
+				/* meh... not running there, queue here */
+				spin_unlock_irqrestore(&last_gcwq->lock, flags);
+				spin_lock_irqsave(&gcwq->lock, flags);
+			}
+		} else
+			spin_lock_irqsave(&gcwq->lock, flags);
 	} else {
 		unsigned int req_cpu = cpu;
 
-- 
1.6.4.2

