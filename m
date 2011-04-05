Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1DEOf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:35:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34477 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1DEOf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=p2a9p40zjnwc+rtGCT/z0a+yGbupnrWLaVI+DW2tuHD59xDgzsU8bkJOjMw9wlSMAk
         i0fwNFGvqj8jqBpzzd5w+TMiGuufVM6ur6y0OaSITCuwgMm6wLRgEbu1tEqiAlp3eXmJ
         zzsuHJ6Plr0dUgLX6bs4cn/9ONAiZI/435kwA=
Date: Tue, 5 Apr 2011 07:35:22 -0700
From: Tejun Heo <tj@kernel.org>
To: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: Separate out drain_workqueue() from
 destroy_workqueue()
Message-ID: <20110405143522.GA9621@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are users which want to drain workqueues without destroying it.
Separate out drain functionality from destroy_workqueue() into
drain_workqueue() and make it accessible to workqueue users.

To guarantee forward-progress, only chain queueing is allowed while
drain is in progress.  If a new work item which isn't chained from the
running or pending work items is queued while draining is in progress,
WARN_ON_ONCE() is triggered.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
---
James, does this seem to fit your use cases?

Thanks.

 include/linux/workqueue.h |    3 +
 kernel/workqueue.c        |   86 +++++++++++++++++++++++++++++++---------------
 2 files changed, 60 insertions(+), 29 deletions(-)
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f7998a3..b5ba4ba 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -255,7 +255,7 @@ enum {
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 
-	WQ_DYING		= 1 << 6, /* internal: workqueue is dying */
+	WQ_DRAINING		= 1 << 6, /* internal: workqueue is draining */
 	WQ_RESCUER		= 1 << 7, /* internal: workqueue has rescuer */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
@@ -351,6 +351,7 @@ extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 
 extern void flush_workqueue(struct workqueue_struct *wq);
+extern void drain_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
 
 extern int schedule_work(struct work_struct *work);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ee6578b..909a01b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -221,7 +221,7 @@ typedef unsigned long mayday_mask_t;
  * per-CPU workqueues:
  */
 struct workqueue_struct {
-	unsigned int		flags;		/* I: WQ_* flags */
+	unsigned int		flags;		/* W: WQ_* flags */
 	union {
 		struct cpu_workqueue_struct __percpu	*pcpu;
 		struct cpu_workqueue_struct		*single;
@@ -240,6 +240,8 @@ struct workqueue_struct {
 	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
+	atomic_t		nr_drainers;	/* drain in progress */
+
 	int			saved_max_active; /* W: saved cwq max_active */
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
@@ -982,7 +984,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	debug_work_activate(work);
 
 	/* if dying, only works from the same workqueue are allowed */
-	if (unlikely(wq->flags & WQ_DYING) &&
+	if (unlikely(wq->flags & WQ_DRAINING) &&
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
 
@@ -2365,6 +2367,57 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
+/**
+ * drain_workqueue - drain a workqueue
+ * @wq: workqueue to drain
+ *
+ * Wait until the workqueue becomes empty.  While draining is in progress,
+ * only chain queueing is allowed.  IOW, only currently pending or running
+ * work items on @wq can queue further work items on it.  @wq is flushed
+ * repeatedly until it becomes empty.  The number of flushing is detemined
+ * by the depth of chaining and should be relatively short.  Whine if it
+ * takes too long.
+ */
+void drain_workqueue(struct workqueue_struct *wq)
+{
+	unsigned int flush_cnt = 0;
+	unsigned int cpu;
+
+	/*
+	 * __queue_work() needs to test whether there are drainers, is much
+	 * hotter than drain_workqueue() and already looks at @wq->flags.
+	 * Use WQ_DRAINING so that queue doesn't have to check nr_drainers.
+	 */
+	if (atomic_inc_and_test(&wq->nr_drainers)) {
+		spin_lock(&workqueue_lock);
+		wq->flags |= WQ_DRAINING;
+		spin_unlock(&workqueue_lock);
+	}
+reflush:
+	flush_workqueue(wq);
+
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
+	if (atomic_add_negative(-1, &wq->nr_drainers)) {
+		spin_lock(&workqueue_lock);
+		wq->flags &= ~WQ_DRAINING;
+		spin_unlock(&workqueue_lock);
+	}
+}
+EXPORT_SYMBOL_GPL(drain_workqueue);
+
 static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 			     bool wait_executing)
 {
@@ -2920,6 +2973,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
 	atomic_set(&wq->nr_cwqs_to_flush, 0);
+	atomic_set(&wq->nr_drainers, -1);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
 
@@ -2995,34 +3049,10 @@ EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	unsigned int flush_cnt = 0;
 	unsigned int cpu;
 
-	/*
-	 * Mark @wq dying and drain all pending works.  Once WQ_DYING is
-	 * set, only chain queueing is allowed.  IOW, only currently
-	 * pending or running work items on @wq can queue further work
-	 * items on it.  @wq is flushed repeatedly until it becomes empty.
-	 * The number of flushing is detemined by the depth of chaining and
-	 * should be relatively short.  Whine if it takes too long.
-	 */
-	wq->flags |= WQ_DYING;
-reflush:
-	flush_workqueue(wq);
-
-	for_each_cwq_cpu(cpu, wq) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-
-		if (!cwq->nr_active && list_empty(&cwq->delayed_works))
-			continue;
-
-		if (++flush_cnt == 10 ||
-		    (flush_cnt % 100 == 0 && flush_cnt <= 1000))
-			printk(KERN_WARNING "workqueue %s: flush on "
-			       "destruction isn't complete after %u tries\n",
-			       wq->name, flush_cnt);
-		goto reflush;
-	}
+	/* drain it before proceeding with destruction */
+	drain_workqueue(wq);
 
 	/*
 	 * wq list is used to freeze wq, remove from list after
