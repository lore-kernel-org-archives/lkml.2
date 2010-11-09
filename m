Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab0KIM6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:58:55 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:33508 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0KIM6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:58:50 -0500
Date: Tue, 9 Nov 2010 13:58:42 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: markus@trippelsdorf.de, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, avi@redhat.com,
        mtosatti@redhat.com
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101109125842.GA8636@osiris.boeblingen.de.ibm.com>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
 <20101027142622.GA1555@arch.trippelsdorf.de>
 <20101027182608.GA1580@arch.trippelsdorf.de>
 <1288208215.3673.16.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288208215.3673.16.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 09:36:55PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-27 at 20:26 +0200, markus@trippelsdorf.de wrote:
> > 
> > 34f971f6f7988be4d014eec3e3526bee6d007ffa is the first bad commit
> > commit 34f971f6f7988be4d014eec3e3526bee6d007ffa
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Wed Sep 22 13:53:15 2010 +0200
> > 
> >     sched: Create special class for stop/migrate work
> > 
> >     In order to separate the stop/migrate work thread from the SCHED_FIFO
> >     implementation, create a special class for it that is of higher priority than
> >     SCHED_FIFO itself.
> > 
> >     This currently solves a problem where cpu-hotplug consumes so much cpu-time
> >     that the SCHED_FIFO class gets throttled, but has the bandwidth replenishment
> >     timer pending on the now dead cpu.
> > 
> >     It is also required for when we add the planned deadline scheduling class above
> >     SCHED_FIFO, as the stop/migrate thread still needs to transcent those tasks.
> > 
> >     Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     LKML-Reference: <1285165776.2275.1022.camel@laptop>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > Reverting the commit solves the kvm hang issue.
> > (If this issue is related to my original tsc problem is of course open for
> > debate, but I have a strong hunch it is.) 
> 
> Too weird,.. what does the hang look like?
> 
> Can you generate a sysrq-t dump? The thing I'm looking for is the
> migration/# thread being runnable but not being current.
> 
> How can I reproduce this?

I think there is a bug in pick_next_task_stop() in sched_stopclass.c:

If a stop-task scheduling class task (well... the migration thread ;) sets
its state to TASK_INTERRUPTIBLE and then gets preempted it will never
scheduled again, because pick_next_task_stop() ignores all tasks with a
state != TASK_RUNNING:

static struct task_struct *pick_next_task_stop(struct rq *rq)
{
	struct task_struct *stop = rq->stop;

	if (stop && stop->state == TASK_RUNNING)
		return stop;

	return NULL;
}

At least I have two dumps of machines where all cpus but one are running
the migration thread. Only the last one runs usual user space processes but
has a preempted migration thread:

>> trace 0x7e50cd40
================================================================
STACK TRACE FOR TASK: 0x7e50cd40 (migration/9)

 STACK:
 0 schedule+1204 [0x55f754]
 1 preempt_schedule+102 [0x56031e]
 2 _raw_spin_unlock_irq+118 [0x563fa6]
 3 cpu_stopper_thread+144 [0x1ad854]
 4 kthread+166 [0x1685aa]
 5 kernel_thread_starter+6 [0x106bea]
================================================================

struct task_struct {
        state = 0x1  /* TASK_INTERRUPTIBLE */
...

I would guess something like the below would probably fix it.
Does that make any sense or did I miss something obvious?

diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 45bddc0..d5cf344 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -26,7 +26,8 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->state == TASK_RUNNING)
+	/* got preempted if on_rq == 1 -- ignore */
+	if (stop && ((stop->state == TASK_RUNNING) || stop->se.on_rq))
 		return stop;
 
 	return NULL;
