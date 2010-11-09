Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0KINeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:34:06 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50616 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab0KINeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:34:03 -0500
Subject: Re: [bisected] Clocksource tsc unstable git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: markus@trippelsdorf.de, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, avi@redhat.com,
        mtosatti@redhat.com
In-Reply-To: <20101109125842.GA8636@osiris.boeblingen.de.ibm.com>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
	 <20101026131843.GC17852@aftab> <20101026135808.GB1672@arch.trippelsdorf.de>
	 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
	 <1288120736.2645.9.camel@localhost>
	 <20101027142622.GA1555@arch.trippelsdorf.de>
	 <20101027182608.GA1580@arch.trippelsdorf.de>
	 <1288208215.3673.16.camel@laptop>
	 <20101109125842.GA8636@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 14:33:56 +0100
Message-ID: <1289309637.2191.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 13:58 +0100, Heiko Carstens wrote:
> Does that make any sense or did I miss something obvious?

I'd write it as a PREEMPT_ACTIVE check, but yes I think you're right.

That said, I also have the below patch queued which should fix up the
wakeup-preemption.


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
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1288891946.2039.31.camel@laptop>
---
 kernel/sched.c          |   38 +++++++++++++++++++++++++++-----------
 kernel/sched_fair.c     |    6 ------
 kernel/sched_stoptask.c |    2 +-
 3 files changed, 28 insertions(+), 18 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -560,18 +560,8 @@ struct rq {
 
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
+static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
 
 static inline int cpu_of(struct rq *rq)
 {
@@ -9402,4 +9392,30 @@ void synchronize_sched_expedited(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
+static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
+{
+	const struct sched_class *class;
+
+	if (p->sched_class == rq->curr->sched_class) {
+		rq->curr->sched_class->check_preempt_curr(rq, p, flags);
+	} else {
+		for_each_class(class) {
+			if (class == rq->curr->sched_class)
+				break;
+			if (class == p->sched_class) {
+				resched_task(rq->curr);
+				break;
+			}
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

