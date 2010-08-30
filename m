Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab0H3M5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:57:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:54550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0H3M5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:57:30 -0400
Message-ID: <4C7BA918.60707@kernel.org>
Date: Mon, 30 Aug 2010 14:50:32 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdump regression compared to v2.6.35
References: <1633441528.1498131283163868227.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1633441528.1498131283163868227.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 12:57:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 12:24 PM, CAI Qian wrote:
> Can't see any difference with hangcheck timer enabled.

Hmm, odd.  So, here's the said debug patch.  It will periodically
check all works and report if any work is being delayed for too long.
If the max wait goes over 30secs, it will dump all task states and
disable itself.  Can you please apply the patch on top of rc2 +
wq#for-linus and report the output?  It should tell us who's stuck
where.

Thanks.

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f11100f..282322c 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -83,6 +83,8 @@ struct work_struct {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
+	unsigned long queued_on;
+	unsigned long activated_on;
 };

 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_NO_CPU)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a2dccfc..9f95169 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -913,6 +913,8 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 {
 	struct global_cwq *gcwq = cwq->gcwq;

+	work->queued_on = work->activated_on = jiffies;
+
 	/* we own @work, set data and link */
 	set_work_cwq(work, cwq, extra_flags);

@@ -996,13 +998,14 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	if (likely(cwq->nr_active < cwq->max_active)) {
 		cwq->nr_active++;
 		worklist = gcwq_determine_ins_pos(gcwq, cwq);
+		insert_work(cwq, work, worklist, work_flags);
 	} else {
 		work_flags |= WORK_STRUCT_DELAYED;
 		worklist = &cwq->delayed_works;
+		insert_work(cwq, work, worklist, work_flags);
+		work->activated_on--;
 	}

-	insert_work(cwq, work, worklist, work_flags);
-
 	spin_unlock_irqrestore(&gcwq->lock, flags);
 }

@@ -1669,6 +1672,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 						    struct work_struct, entry);
 	struct list_head *pos = gcwq_determine_ins_pos(cwq->gcwq, cwq);

+	work->activated_on = jiffies;
 	move_linked_works(work, pos, NULL);
 	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
 	cwq->nr_active++;
@@ -2810,7 +2814,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	 * list.  Grab it, set max_active accordingly and add the new
 	 * workqueue to workqueues list.
 	 */
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);

 	if (workqueue_freezing && wq->flags & WQ_FREEZEABLE)
 		for_each_cwq_cpu(cpu, wq)
@@ -2818,7 +2822,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,

 	list_add(&wq->list, &workqueues);

-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);

 	return wq;
 err:
@@ -2849,9 +2853,9 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
 	 */
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 	list_del(&wq->list);
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);

 	/* sanity check */
 	for_each_cwq_cpu(cpu, wq) {
@@ -2891,23 +2895,23 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)

 	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);

-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);

 	wq->saved_max_active = max_active;

 	for_each_cwq_cpu(cpu, wq) {
 		struct global_cwq *gcwq = get_gcwq(cpu);

-		spin_lock_irq(&gcwq->lock);
+		spin_lock(&gcwq->lock);

 		if (!(wq->flags & WQ_FREEZEABLE) ||
 		    !(gcwq->flags & GCWQ_FREEZING))
 			get_cwq(gcwq->cpu, wq)->max_active = max_active;

-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock(&gcwq->lock);
 	}

-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 EXPORT_SYMBOL_GPL(workqueue_set_max_active);

@@ -3419,7 +3423,7 @@ void freeze_workqueues_begin(void)
 {
 	unsigned int cpu;

-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);

 	BUG_ON(workqueue_freezing);
 	workqueue_freezing = true;
@@ -3428,7 +3432,7 @@ void freeze_workqueues_begin(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct workqueue_struct *wq;

-		spin_lock_irq(&gcwq->lock);
+		spin_lock(&gcwq->lock);

 		BUG_ON(gcwq->flags & GCWQ_FREEZING);
 		gcwq->flags |= GCWQ_FREEZING;
@@ -3440,10 +3444,10 @@ void freeze_workqueues_begin(void)
 				cwq->max_active = 0;
 		}

-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock(&gcwq->lock);
 	}

-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }

 /**
@@ -3464,7 +3468,7 @@ bool freeze_workqueues_busy(void)
 	unsigned int cpu;
 	bool busy = false;

-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);

 	BUG_ON(!workqueue_freezing);

@@ -3488,7 +3492,7 @@ bool freeze_workqueues_busy(void)
 		}
 	}
 out_unlock:
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 	return busy;
 }

@@ -3505,7 +3509,7 @@ void thaw_workqueues(void)
 {
 	unsigned int cpu;

-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);

 	if (!workqueue_freezing)
 		goto out_unlock;
@@ -3514,7 +3518,7 @@ void thaw_workqueues(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct workqueue_struct *wq;

-		spin_lock_irq(&gcwq->lock);
+		spin_lock(&gcwq->lock);

 		BUG_ON(!(gcwq->flags & GCWQ_FREEZING));
 		gcwq->flags &= ~GCWQ_FREEZING;
@@ -3535,15 +3539,82 @@ void thaw_workqueues(void)

 		wake_up_worker(gcwq);

-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock(&gcwq->lock);
 	}

 	workqueue_freezing = false;
 out_unlock:
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 #endif /* CONFIG_FREEZER */

+#define WQ_CHECK_INTERVAL	(10 * HZ)
+static void workqueue_check_timer_fn(unsigned long data);
+static DEFINE_TIMER(workqueue_check_timer, workqueue_check_timer_fn, 0, 0);
+
+static void workqueue_check_timer_fn(unsigned long data)
+{
+	unsigned long now = jiffies;
+	unsigned long wait, max_wait = 0;
+	unsigned int cpu;
+	unsigned long flags;
+
+	spin_lock_irqsave(&workqueue_lock, flags);
+
+	for_each_gcwq_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct workqueue_struct *wq;
+		struct work_struct *work;
+
+		spin_lock(&gcwq->lock);
+
+		list_for_each_entry(wq, &workqueues, list) {
+			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+			if (!cwq)
+				continue;
+
+			list_for_each_entry(work, &cwq->delayed_works, entry) {
+				WARN_ON_ONCE(!time_before(work->activated_on,
+							  work->queued_on));
+				wait = now - work->queued_on;
+				if (wait < WQ_CHECK_INTERVAL)
+					continue;
+				max_wait = max(max_wait, wait);
+				printk("XXX %s/%d %p:%pf delayed for %ums\n",
+				       wq->name,
+				       gcwq->cpu != WORK_CPU_UNBOUND ? gcwq->cpu : -1,
+				       work, work->func, jiffies_to_msecs(wait));
+			}
+		}
+
+		list_for_each_entry(work, &gcwq->worklist, entry) {
+			WARN_ON_ONCE(time_before(work->activated_on,
+						 work->queued_on));
+			wait = now - work->activated_on;
+			if (wait < WQ_CHECK_INTERVAL)
+				continue;
+			max_wait = max(max_wait, wait);
+			printk("XXX %s/%d %p:%pf pending for %ums after delayed %ums\n",
+			       get_work_cwq(work)->wq->name,
+			       gcwq->cpu != WORK_CPU_UNBOUND ? gcwq->cpu : -1,
+			       work, work->func,
+			       jiffies_to_msecs(wait),
+			       jiffies_to_msecs(work->activated_on - work->queued_on));
+		}
+
+		spin_unlock(&gcwq->lock);
+	}
+
+	spin_unlock_irqrestore(&workqueue_lock, flags);
+
+	if (max_wait > 20 * HZ) {
+		printk("XXX max_wait over 30secs, dumping tasks\n");
+		show_state();
+	} else
+		mod_timer(&workqueue_check_timer, now + WQ_CHECK_INTERVAL / 2);
+}
+
 static int __init init_workqueues(void)
 {
 	unsigned int cpu;
@@ -3596,6 +3667,7 @@ static int __init init_workqueues(void)
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
 					    WQ_UNBOUND_MAX_ACTIVE);
 	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
+	mod_timer(&workqueue_check_timer, jiffies + WQ_CHECK_INTERVAL / 2);
 	return 0;
 }
 early_initcall(init_workqueues);

