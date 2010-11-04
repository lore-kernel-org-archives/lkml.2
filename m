Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0KDRcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:32:45 -0400
Received: from canuck.infradead.org ([134.117.69.58]:34496 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0KDRcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:32:43 -0400
Subject: Re: task blocked for more than 120 seconds
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101104161943.GA6520@arch.trippelsdorf.de>
References: <20101104155826.GC13818@swordfish.minsk.epam.com>
	 <20101104161943.GA6520@arch.trippelsdorf.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Nov 2010 18:32:26 +0100
Message-ID: <1288891946.2039.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 17:19 +0100, Markus Trippelsdorf wrote:
> On Thu, Nov 04, 2010 at 05:58:26PM +0200, Sergey Senozhatsky wrote:
> > Hello,
> > Got the following traces:
> > 
> > [42001.449295] INFO: task openbox:17761 blocked for more than 120 seconds.
> > [42001.449303] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [42001.449311] openbox       D 0000000000000003     0 17761   3723 0x00000000
> > [42001.449321]  ffff88004ce8dc38 0000000000000046 0000000000000000 ffff88004ce8c000
> > [42001.449333]  ffff88004ce8dfd8 0000000000012040 ffff880133010000 ffff88004ce8dfd8
> > [42001.449343]  0000000000012040 0000000000012040 ffff88004ce8dfd8 0000000000012040
> > [42001.449354] Call Trace:
> > [42001.449369]  [<ffffffff814212ff>] schedule_timeout+0x38/0x220
> > [42001.449381]  [<ffffffff81066f21>] ? mark_held_locks+0x50/0x72
> > [42001.449389]  [<ffffffff81423dae>] ? _raw_spin_unlock_irq+0x2b/0x59
> > [42001.449398]  [<ffffffff81036070>] ? get_parent_ip+0x11/0x41
> > [42001.449406]  [<ffffffff81036132>] ? sub_preempt_count+0x92/0xa5
> > [42001.449413]  [<ffffffff8142057e>] wait_for_common+0xca/0x144
> > [42001.449421]  [<ffffffff81038b13>] ? default_wake_function+0x0/0xf
> > [42001.449429]  [<ffffffff81423e4b>] ? _raw_spin_unlock_irqrestore+0x6f/0x74
> > [42001.449436]  [<ffffffff81420692>] wait_for_completion+0x18/0x1a
> > [42001.449445]  [<ffffffff81084808>] stop_one_cpu+0x8c/0xba
> 
> These traces look related to:
> http://article.gmane.org/gmane.linux.kernel/1055100
> 
> Does reverting 34f971f6f7988be4d014eec3e3526bee6d007ffa help in your
> case?


---
Subject: sched: Fixup cross sched_class wakeup preemption
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sun Oct 31 12:37:04 CET 2010

Instead of dealing with sched classes inside each check_preempt_curr()
implementation, pull out this logic into the generic wakeup preemption
path.

This fixes a hang in KVM (and others) where we are waiting for the
stop machine thread to run..

Tested-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c          |   39 ++++++++++++++++++++++++++++-----------
 kernel/sched_fair.c     |    6 ------
 kernel/sched_stoptask.c |    2 +-
 3 files changed, 29 insertions(+), 18 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -560,18 +560,9 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline
-void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
-{
-	rq->curr->sched_class->check_preempt_curr(rq, p, flags);
 
-	/*
-	 * A queue event has occurred, and we're going to schedule.  In
-	 * this case, we can save a useless back to back clock update.
-	 */
-	if (test_tsk_need_resched(p))
-		rq->skip_clock_update = 1;
-}
+static inline
+void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
 
 static inline int cpu_of(struct rq *rq)
 {
@@ -9400,4 +9391,30 @@ void synchronize_sched_expedited(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
+static inline
+void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
+{
+	const struct sched_class *class;
+
+	if (p->sched_class == rq->curr->sched_class)
+		rq->curr->sched_class->check_preempt_curr(rq, p, flags);
+
+	for_each_class(class) {
+		if (class == rq->curr->sched_class)
+			break;
+		if (class == p->sched_class) {
+			resched_task(rq->curr);
+			break;
+		}
+	}
+
+	/*
+	 * A queue event has occurred, and we're going to schedule.  In
+	 * this case, we can save a useless back to back clock update.
+	 */
+	if (test_tsk_need_resched(rq->curr))
+		rq->skip_clock_update = 1;
+}
+
+
 #endif /* #else #ifndef CONFIG_SMP */
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1654,12 +1654,6 @@ static void check_preempt_wakeup(struct
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
-	if (unlikely(rt_prio(p->prio)))
-		goto preempt;
-
-	if (unlikely(p->sched_class != &fair_sched_class))
-		return;
-
 	if (unlikely(se == pse))
 		return;
 
Index: linux-2.6/kernel/sched_stoptask.c
===================================================================
--- linux-2.6.orig/kernel/sched_stoptask.c
+++ linux-2.6/kernel/sched_stoptask.c
@@ -19,7 +19,7 @@ select_task_rq_stop(struct rq *rq, struc
 static void
 check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
 {
-	resched_task(rq->curr); /* we preempt everything */
+	/* we're never preempted */
 }
 
 static struct task_struct *pick_next_task_stop(struct rq *rq)

