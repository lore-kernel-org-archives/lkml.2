Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1DUSnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:43:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1DUSnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=knlvZpMbN1UZEFM+ov2dMvVCcTDPtQY8oTEFM/ORmO6MPVqgBaN4ieCo6tGRAGgvWc
         4rsDPmhBD5nogdsxL1OH0Eo3Ma40qFFXPSl9LP+GRw7pGG+UGoEnxNFg3FLJ7pEIQrRB
         LfM3XnMVfS34qYbaI9DH0alNerTTZneJ/LlIs=
Date: Thu, 21 Apr 2011 20:43:04 +0200
From: Tejun Heo <tj@kernel.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110421184304.GH15988@htj.dyndns.org>
References: <20110406130423.GE4142@mtj.dyndns.org>
 <20110406212611.GA5131@sucs.org>
 <20110406213718.GA14139@mtj.dyndns.org>
 <20110409093449.GA10016@sucs.org>
 <20110410145920.GA3408@sucs.org>
 <20110413200000.GG3987@mtj.dyndns.org>
 <20110415090118.GA3315@mtj.dyndns.org>
 <20110415182006.GA15916@mtj.dyndns.org>
 <20110415214140.GB1295@sucs.org>
 <20110421173845.GE15988@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421173845.GE15988@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 07:38:45PM +0200, Tejun Heo wrote:
> Hello,
> 
> On Fri, Apr 15, 2011 at 10:41:40PM +0100, Sitsofe Wheeler wrote:
> > I couldn't reproduce the problem with the very latest kernel but here's
> > the output that appeared with an older kernel with your patch:
> > 
> > ------------[ cut here ]------------
> > WARNING: at block/genhd.c:1561 disk_clear_events+0x164/0x170()
> 
> Hmmm... that's really weird.  It indicates that the workqueue command
> sequence there doesn't guarantee scheduling and completion of the work
> item, which means either there's a bug in workqueue itself or I'm
> confused about what's going on.  Hopefully, the latter.
> Unfortunately, even with physical setup, I'm having problem
> reproducing the problem.  Which kernel version are you using exactly?
> Can you please let me know the commit ID?

Also, please try the following patch.  It should show what's going on
with the flush machinery.

Thanks.

diff --git a/block/genhd.c b/block/genhd.c
index b364bd0..0add6d5 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1377,6 +1377,8 @@ struct disk_events {
 
 	long			poll_msecs;	/* interval, -1 for default */
 	struct delayed_work	dwork;
+	struct mutex		mutex;
+	atomic_t		cnt;
 };
 
 static const char *disk_events_strs[] = {
@@ -1540,6 +1542,9 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 		return 0;
 	}
 
+	WARN_ON_ONCE(atomic_add_return(1, &ev->cnt) != 1);
+	mutex_lock(&ev->mutex);
+
 	/* tell the workfn about the events being cleared */
 	spin_lock_irq(&ev->lock);
 	ev->clearing |= mask;
@@ -1548,7 +1553,9 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 	/* uncondtionally schedule event check and wait for it to finish */
 	__disk_block_events(disk, true);
 	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
-	flush_delayed_work(&ev->dwork);
+	if (!flush_delayed_work_dbg(&ev->dwork))
+		printk("disk_clear_events-%s: flush returned false\n",
+		       disk->disk_name);
 	__disk_unblock_events(disk, false);
 
 	/* then, fetch and clear pending events */
@@ -1558,6 +1565,9 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 	ev->pending &= ~mask;
 	spin_unlock_irq(&ev->lock);
 
+	WARN_ON_ONCE(atomic_add_return(-1, &ev->cnt) != 0);
+	mutex_unlock(&ev->mutex);
+
 	return pending;
 }
 
@@ -1749,6 +1759,8 @@ static void disk_add_events(struct gendisk *disk)
 	ev->block = 1;
 	ev->poll_msecs = -1;
 	INIT_DELAYED_WORK(&ev->dwork, disk_events_workfn);
+	mutex_init(&ev->mutex);
+	atomic_set(&ev->cnt, 0);
 
 	mutex_lock(&disk_events_mutex);
 	list_add_tail(&ev->node, &disk_events);
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f584aba..eade076 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -372,6 +372,7 @@ extern bool flush_work_sync(struct work_struct *work);
 extern bool cancel_work_sync(struct work_struct *work);
 
 extern bool flush_delayed_work(struct delayed_work *dwork);
+extern bool flush_delayed_work_dbg(struct delayed_work *dwork);
 extern bool flush_delayed_work_sync(struct delayed_work *work);
 extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8859a41..20ac7d1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2376,7 +2376,7 @@ out_unlock:
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
 static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
-			     bool wait_executing)
+			     bool wait_executing, bool dbg)
 {
 	struct worker *worker = NULL;
 	struct global_cwq *gcwq;
@@ -2384,8 +2384,11 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 
 	might_sleep();
 	gcwq = get_work_gcwq(work);
-	if (!gcwq)
+	if (!gcwq) {
+		if (dbg)
+			printk("flush_work-%p: doesn't have gcwq set\n", work);
 		return false;
+	}
 
 	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
@@ -2396,15 +2399,26 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 		 */
 		smp_rmb();
 		cwq = get_work_cwq(work);
-		if (unlikely(!cwq || gcwq != cwq->gcwq))
+		if (unlikely(!cwq || gcwq != cwq->gcwq)) {
+			if (dbg)
+				printk("flush_work-%p: cwq=%p gcwq@%d cwq->gcwq@%d\n",
+				       work, cwq, gcwq->cpu, cwq ? cwq->gcwq->cpu : -1);
 			goto already_gone;
+		}
 	} else if (wait_executing) {
 		worker = find_worker_executing_work(gcwq, work);
-		if (!worker)
+		if (!worker) {
+			if (dbg)
+				printk("flush_work-%p: wait_executing but not executing on %d\n",
+				       work, gcwq->cpu);
 			goto already_gone;
+		}
 		cwq = worker->current_cwq;
-	} else
+	} else {
+		if (dbg)
+			printk("flush_work-%p: idle, cpu=%d\n", work, gcwq->cpu);
 		goto already_gone;
+	}
 
 	insert_wq_barrier(cwq, barr, work, worker);
 	spin_unlock_irq(&gcwq->lock);
@@ -2449,7 +2463,7 @@ bool flush_work(struct work_struct *work)
 {
 	struct wq_barrier barr;
 
-	if (start_flush_work(work, &barr, true)) {
+	if (start_flush_work(work, &barr, true, false)) {
 		wait_for_completion(&barr.done);
 		destroy_work_on_stack(&barr.work);
 		return true;
@@ -2458,6 +2472,18 @@ bool flush_work(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
+static bool flush_work_dbg(struct work_struct *work)
+{
+	struct wq_barrier barr;
+
+	if (start_flush_work(work, &barr, true, true)) {
+		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+		return true;
+	} else
+		return false;
+}
+
 static bool wait_on_cpu_work(struct global_cwq *gcwq, struct work_struct *work)
 {
 	struct wq_barrier barr;
@@ -2514,7 +2540,7 @@ bool flush_work_sync(struct work_struct *work)
 	bool pending, waited;
 
 	/* we'll wait for executions separately, queue barr only if pending */
-	pending = start_flush_work(work, &barr, false);
+	pending = start_flush_work(work, &barr, false, false);
 
 	/* wait for executions to finish */
 	waited = wait_on_work(work);
@@ -2632,6 +2658,15 @@ bool flush_delayed_work(struct delayed_work *dwork)
 }
 EXPORT_SYMBOL(flush_delayed_work);
 
+bool flush_delayed_work_dbg(struct delayed_work *dwork)
+{
+	if (del_timer_sync(&dwork->timer))
+		__queue_work(raw_smp_processor_id(),
+			     get_work_cwq(&dwork->work)->wq, &dwork->work);
+	return flush_work_dbg(&dwork->work);
+}
+EXPORT_SYMBOL(flush_delayed_work_dbg);
+
 /**
  * flush_delayed_work_sync - wait for a dwork to finish
  * @dwork: the delayed work to flush
