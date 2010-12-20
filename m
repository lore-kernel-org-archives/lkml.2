Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab0LTSsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:48:46 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:38271 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab0LTSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:48:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ujCZjv1Yfrwwb/E/QScWcXiSMWTT3pP9sB7FJ62gHxfsb4Ozeq3FVwbS7EVtQM1/SP
         qsuK4Dz6BVLCDH+71Sgu3CwVYGdqJtITBKrqbRDfnsBC3LflFQ97zRwfcvLwiXQhwNi0
         s1yWlF0B+KA5GRNb+1oqa10ux10EjuWmeNek8=
Message-ID: <4D0FA509.50205@kernel.org>
Date: Mon, 20 Dec 2010 19:48:41 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH wq#for-next] workqueue: allow chained queueing during destruction
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, destroy_workqueue() makes the workqueue deny all new
queueing by setting WQ_DYING and flushes the workqueue once before
proceeding with destruction; however, there are cases where work items
queue more related work items.  Currently, such users need to
explicitly flush the workqueue multiple times depending on the
possible depth of such chained queueing.

This patch updates the queueing path such that a work item can queue
further work items on the same workqueue even when WQ_DYING is set.
The flush on destruction is automatically retried until the workqueue
is empty.  This guarantees that the workqueue is empty on destruction
while allowing chained queueing.

The flush retry logic whines if it takes too many retries to drain the
workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
James, I'm committing this to wq#for-next.  This should make
release-from-work cases easier to manage, including the discussed ew
replacement and fcoe which currently does double flush before
unloading.

Thanks.

 kernel/workqueue.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e785b0f..8ee6ec8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -932,6 +932,38 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 		wake_up_worker(gcwq);
 }

+/*
+ * Test whether @work is being queued from another work executing on the
+ * same workqueue.  This is rather expensive and should only be used from
+ * cold paths.
+ */
+static bool is_chained_work(struct workqueue_struct *wq)
+{
+	unsigned long flags;
+	unsigned int cpu;
+
+	for_each_gcwq_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker *worker;
+		struct hlist_node *pos;
+		int i;
+
+		spin_lock_irqsave(&gcwq->lock, flags);
+		for_each_busy_worker(worker, i, pos, gcwq) {
+			if (worker->task != current)
+				continue;
+			spin_unlock_irqrestore(&gcwq->lock, flags);
+			/*
+			 * I'm @worker, no locking necessary.  See if @work
+			 * is headed to the same workqueue.
+			 */
+			return worker->current_cwq->wq == wq;
+		}
+		spin_unlock_irqrestore(&gcwq->lock, flags);
+	}
+	return false;
+}
+
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
@@ -943,7 +975,9 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,

 	debug_work_activate(work);

-	if (WARN_ON_ONCE(wq->flags & WQ_DYING))
+	/* if dying, only works from the same workqueue are allowed */
+	if (unlikely(wq->flags & WQ_DYING) &&
+	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;

 	/* determine gcwq to use */
@@ -2936,11 +2970,35 @@ EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
+	unsigned int flush_cnt = 0;
 	unsigned int cpu;

+	/*
+	 * Mark @wq dying and drain all pending works.  Once WQ_DYING is
+	 * set, only chain queueing is allowed.  IOW, only currently
+	 * pending or running work items on @wq can queue further work
+	 * items on it.  @wq is flushed repeatedly until it becomes empty.
+	 * The number of flushing is detemined by the depth of chaining and
+	 * should be relatively short.  Whine if it takes too long.
+	 */
 	wq->flags |= WQ_DYING;
+reflush:
 	flush_workqueue(wq);

+	for_each_cwq_cpu(cpu, wq) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+		if (!cwq->nr_active && list_empty(&cwq->delayed_works))
+			continue;
+
+		if (++flush_cnt == 10 ||
+		    (flush_cnt % 100 == 0 && flush_cnt <= 1000))
+			printk(KERN_WARNING "workqueue %s: flush on "
+			       "destruction isn't complete after %u tries\n",
+			       wq->name, flush_cnt);
+		goto reflush;
+	}
+
 	/*
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
-- 
1.7.1

