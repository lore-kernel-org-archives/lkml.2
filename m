Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab1LOPiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:38:16 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:50771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab1LOPiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:38:14 -0500
Subject: Re: workqueue_set_max_active(wq, 0)?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111209165702.GD12108@google.com> (sfid-20111209_175740_727764_F62FADDC)
References: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
	 <20111209165702.GD12108@google.com> (sfid-20111209_175740_727764_F62FADDC)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 16:38:12 +0100
Message-ID: <1323963492.23550.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,


> > Before I dive in more deeply I figured I'd ask if you think what a good
> > way of doing this would be (and whether I'm completely insane) :-)
> 
> Hmmm... yeah, actually, that's what wq uses internally to implement
> freezable workqueues.  It sets max_active to 0 temporarily and waits
> for all in-flight works to finish.  On thaw, the original value is
> restored.
> 
> Updating workqueue_set_max_active() to return the old value would be a
> nice API update which goes together, I think.

So I looked at set_max_active() but I think it can also be called in
atomic contexts but I would want this to wait I think ... Does the below
look like a reasonable first cut (never mind that it's not really
exported in header files yet, I haven't even tested it yet but the
interaction with other code is interesting)

johannes


---
 kernel/workqueue.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c	2011-12-10 17:32:26.000000000 +0100
+++ b/kernel/workqueue.c	2011-12-15 16:36:06.000000000 +0100
@@ -51,6 +51,7 @@ enum {
 	GCWQ_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 	GCWQ_FREEZING		= 1 << 3,	/* freeze in progress */
 	GCWQ_HIGHPRI_PENDING	= 1 << 4,	/* highpri works on queue */
+	GCWQ_PAUSING		= 1 << 5,
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -246,6 +247,7 @@ struct workqueue_struct {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
+	wait_queue_head_t	waitq;
 };
 
 struct workqueue_struct *system_wq __read_mostly;
@@ -1759,6 +1761,8 @@ static void cwq_dec_nr_in_flight(struct
 			if (cwq->nr_active < cwq->max_active)
 				cwq_activate_first_delayed(cwq);
 		}
+		if (cwq->nr_active == 0 && cwq->max_active == 0)
+			wake_up(&cwq->wq->waitq);
 	}
 
 	/* is flush in progress and are we at the flushing tip? */
@@ -2990,6 +2994,7 @@ struct workqueue_struct *__alloc_workque
 	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
+	init_waitqueue_head(&wq->waitq);
 
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
@@ -3124,7 +3129,7 @@ void workqueue_set_max_active(struct wor
 		spin_lock_irq(&gcwq->lock);
 
 		if (!(wq->flags & WQ_FREEZABLE) ||
-		    !(gcwq->flags & GCWQ_FREEZING))
+		    !(gcwq->flags & (GCWQ_FREEZING | GCWQ_PAUSING)))
 			get_cwq(gcwq->cpu, wq)->max_active = max_active;
 
 		spin_unlock_irq(&gcwq->lock);
@@ -3377,7 +3382,7 @@ static int __cpuinit trustee_thread(void
 	 * completion while frozen.
 	 */
 	while (gcwq->nr_workers != gcwq->nr_idle ||
-	       gcwq->flags & GCWQ_FREEZING ||
+	       gcwq->flags & (GCWQ_FREEZING | GCWQ_PAUSING) ||
 	       gcwq->trustee_state == TRUSTEE_IN_CHARGE) {
 		int nr_works = 0;
 
@@ -3767,6 +3772,65 @@ out_unlock:
 }
 #endif /* CONFIG_FREEZER */
 
+static unsigned int count_active(struct workqueue_struct *wq)
+{
+	unsigned int cpu, active = 0;
+
+	for_each_cwq_cpu(cpu, wq) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = cwq->gcwq;
+
+		spin_lock_irq(&gcwq->lock);
+		active += cwq->nr_active;
+		spin_unlock_irq(&gcwq->lock);
+	}
+
+	return active;
+}
+
+void pause_workqueue(struct workqueue_struct *wq)
+{
+	unsigned int cpu;
+
+	for_each_cwq_cpu(cpu, wq) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = cwq->gcwq;
+
+		spin_lock_irq(&gcwq->lock);
+
+		WARN_ON(gcwq->flags & GCWQ_PAUSING);
+		gcwq->flags |= GCWQ_PAUSING;
+
+		cwq->max_active = 0;
+
+		spin_unlock_irq(&gcwq->lock);
+	}
+
+	wait_event(wq->waitq, count_active(wq) == 0);
+}
+EXPORT_SYMBOL(pause_workqueue);
+
+void resume_workqueue(struct workqueue_struct *wq)
+{
+	unsigned int cpu;
+
+	for_each_cwq_cpu(cpu, wq) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = cwq->gcwq;
+
+		spin_lock_irq(&gcwq->lock);
+
+		WARN_ON(!(gcwq->flags & GCWQ_PAUSING));
+		gcwq->flags &= ~GCWQ_PAUSING;
+
+		cwq->max_active = wq->saved_max_active;
+
+		wake_up_worker(gcwq);
+		spin_unlock_irq(&gcwq->lock);
+	}
+}
+EXPORT_SYMBOL(resume_workqueue);
+
 static int __init init_workqueues(void)
 {
 	unsigned int cpu;


