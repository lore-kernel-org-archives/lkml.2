Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2EBKzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:55:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40613 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2EBKzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:55:43 -0400
Date: Wed, 2 May 2012 12:55:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 35/41] sched: Update rq clock before idle balancing
Message-ID: <20120502105532.GB22061@somewhere>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-36-git-send-email-fweisbec@gmail.com>
 <4FA0ABA7.10906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA0ABA7.10906@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:36:07AM +0800, Michael Wang wrote:
> On 05/01/2012 07:55 AM, Frederic Weisbecker wrote:
> 
> > idle_balance() is called from schedule() right before we schedule the
> > idle task. It needs to record the idle timestamp at that time and for
> > this the rq clock must be accurate. If the CPU is running tickless
> > we need to update the rq clock manually.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Alessio Igor Bogani <abogani@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Avi Kivity <avi@redhat.com>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Cc: Geoff Levand <geoff@infradead.org>
> > Cc: Gilad Ben Yossef <gilad@benyossef.com>
> > Cc: Hakan Akkan <hakanakkan@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: Max Krasnyansky <maxk@qualcomm.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Stephen Hemminger <shemminger@vyatta.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  kernel/sched/fair.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index eff80e0..cd871e7 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4638,6 +4638,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
> >  	int pulled_task = 0;
> >  	unsigned long next_balance = jiffies + HZ;
> > 
> > +	update_nohz_rq_clock(this_rq);
> 
> 
> I'm not sure but why we have to care nohz? if we really need an accurate
> clock, we should do the update anyway, don't we?

This concerns adaptive tickless CPUs only. So I wanted to keep the overhead
low for CPUs that are not in adaptive tickless mode. update_nohz_rq_clock()
takes care of that. It only updates the rq clock if the CPU is adaptive tickless.

> 
> Some thing also confused me is the description:
> "If the CPU is running tickless we need to update the rq clock manually."
> 
> I think the cpu will enter tickless mode only when the idle thread
> already switched in, then invoke
> tick_nohz_idle_enter->tick_nohz_stop_sched_tick, isn't it?

An adaptive tickless CPU tries to shutdown the tick even when the CPU
is not idle. By the time we are about to sleep and schedule the idle
task, we may be already tickless for a while.

> 
> And if we invoke idle_balance for a cpu, that means it hasn't enter
> idle(current task is not idle task), so how can such a cpu in tickless mode?
> 
> Regards,
> Michael Wang
> 
> >  	this_rq->idle_stamp = this_rq->clock;
> > 
> >  	if (this_rq->avg_idle < sysctl_sched_migration_cost)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
