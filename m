Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1GWAjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 20:39:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50498 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1GWAji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 20:39:38 -0400
Date: Fri, 22 Jul 2011 17:39:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>
Subject: Re: On migrate_disable() and latencies
Message-ID: <20110723003934.GP2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1311329992.27400.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311329992.27400.23.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 12:19:52PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-07-20 at 02:37 +0200, Thomas Gleixner wrote:
> >    - Twist your brain around the schedulability impact of the
> >      migrate_disable() approach.
> > 
> >      A really interesting research topic for our friends from the
> >      academic universe. Relevant and conclusive (even short notice)
> >      papers and/or talks on that topic have a reserved slot in the
> >      Kernel developers track at the Realtime Linux Workshop in Prague
> >      in October this year. 
> 
> >From what I can tell it can induce a latency in the order of
> max-migrate-disable-period * nr-cpus.
> 
> The scenario is on where you stack N migrate-disable tasks on a run
> queue (necessarily of increasing priority). Doing this requires all cpus
> in the system to be as busy, for otherwise the task would simply be
> moved to another cpu.
> 
> Anyway, once you manage to stack these migrate-disable tasks, all other
> tasks go to sleep, leaving a vacuum. Normally we would migrate tasks to
> fill the vacuum left by the tasks going to sleep, but clearly
> migrate-disable prohibits this.
> 
> So we have this stack of migrate-disable tasks and M-1 idle cpus (loss
> of utilization). Now it takes the length of the migrate-disable region
> of the highest priority task on the stack (the one running) to complete
> and enable migration again. This will instantly move the task away to an
> idle cpu. This will then need to happen min(N-1, M-1) times before the
> lowest priority migrate_disable task can run again or all cpus are busy.
> 
> Therefore the worst case latency is in the order of
> max-migrate-disable-period * nr-cpus.

OK, but wouldn't that be the latency as seen be the lowest-priority
task?  Or are migrate-disable tasks given preferential treatment?
If not, a prio-99 task would get the same latency either way, right?

Migration-disable can magnify the latency seen by low-priority tasks, if
I understand correctly.  If you disabled preemption, when a low-priority
task became runnable, it would find an idle CPU.  But with migration
disable, the lowest-priority task might enter a migration-disable region,
then be preempted by a marginally higher-priority task that also enters
a migration-diable region, and is also preempted, and so on.  The
lowest-priority task cannot run on the current CPU because of all
the higher-priority tasks, and cannot migrate due to being in a
migration-disable section.

In other words, as is often the case, better worst-case service to
the high-priority tasks can multiply the latency seen by the
low-priority tasks.

So is the topic to quantify this?  If so, my take is that the latency
to the highest-priority task decreases by an amount roughly equal to
the duration of the longest preempt_disable() region that turned into a
migration-disable region, while that to the lowest-priority task increases
by N-1 times the CPU overhead of the longest migration-disable region,
plus context switches.  (Yes, this is a very crude rule-of-thumb model.
A real model would have much higher mathematics and might use a more
detailed understanding of the workload.)

Or am I misunderstanding how all this works?

							Thanx, Paul

> Currently we have no means of measuring these latencies, this is
> something we need to grow, I think Steven can fairly easy craft a
> migrate_disable runtime tracer -- it needs to use t->se.sum_exec_runtime
> for measure so as to only count the actual time spend on the task and
> ignore any time it was blocked.
> 
> Once we have this, its back to the old game of 'lock'-breaking.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
