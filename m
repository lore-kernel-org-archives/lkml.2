Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2GISmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:42:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2GISmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:42:06 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, joshhunt00@gmail.com, axboe@kernel.dk,
        rni@google.com, vgoyal@redhat.com, vwadekar@nvidia.com,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
        elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] workqueue: don't use WQ_HIGHPRI for unbound workqueues
Date: Mon,  9 Jul 2012 11:41:50 -0700
Message-Id: <1341859315-17759-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341859315-17759-1-git-send-email-tj@kernel.org>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbound wqs aren't concurrency-managed and try to execute work items
as soon as possible.  This is currently achieved by implicitly setting
%WQ_HIGHPRI on all unbound workqueues; however, WQ_HIGHPRI
implementation is about to be restructured and this usage won't be
valid anymore.

Add an explicit chain-wakeup path for unbound workqueues in
process_one_work() instead of piggy backing on %WQ_HIGHPRI.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9a3128d..27637c2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -580,6 +580,10 @@ static bool __need_more_worker(struct global_cwq *gcwq)
 /*
  * Need to wake up a worker?  Called from anything but currently
  * running workers.
+ *
+ * Note that, because unbound workers never contribute to nr_running, this
+ * function will always return %true for unbound gcwq as long as the
+ * worklist isn't empty.
  */
 static bool need_more_worker(struct global_cwq *gcwq)
 {
@@ -1867,6 +1871,13 @@ __acquires(&gcwq->lock)
 	if (unlikely(cpu_intensive))
 		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
 
+	/*
+	 * Unbound gcwq isn't concurrency managed and work items should be
+	 * executed ASAP.  Wake up another worker if necessary.
+	 */
+	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(gcwq))
+		wake_up_worker(gcwq);
+
 	spin_unlock_irq(&gcwq->lock);
 
 	work_clear_pending(work);
@@ -2984,13 +2995,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	if (flags & WQ_MEM_RECLAIM)
 		flags |= WQ_RESCUER;
 
-	/*
-	 * Unbound workqueues aren't concurrency managed and should be
-	 * dispatched to workers immediately.
-	 */
-	if (flags & WQ_UNBOUND)
-		flags |= WQ_HIGHPRI;
-
 	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 
-- 
1.7.7.3

