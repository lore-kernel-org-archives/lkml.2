Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1GVRw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 13:52:57 -0400
Received: from hofr.at ([212.69.189.236]:50149 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab1GVRwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 13:52:55 -0400
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jul 2011 13:52:55 EDT
Date: Fri, 22 Jul 2011 19:45:00 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>
Subject: Re: On migrate_disable() and latencies
Message-ID: <20110722174500.GB32014@opentech.at>
References: <1311329992.27400.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311329992.27400.23.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011, Peter Zijlstra wrote:

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
> From what I can tell it can induce a latency in the order of
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

+ something like sum of (interrupt rate [n] / max-migrate-disable-period * nr-cpus) * top-half handler [n]. if you go on with theoretical WCET analysis on multicore systems you will always end up at the conclusion that only UP is suitable for RT....

> 
> Currently we have no means of measuring these latencies, this is
> something we need to grow, I think Steven can fairly easy craft a
> migrate_disable runtime tracer -- it needs to use t->se.sum_exec_runtime
> for measure so as to only count the actual time spend on the task and
> ignore any time it was blocked.
> 
well this is a similar problem as with the WCET "calculations" - you can
calculate theoretical worst cases - but the question is what the actual
distribution of "stacking" is and thus what the probability is that you
manage to stack tasks in this way. A further issue here is the system 
design - if you have a RT system with M RT tasks, an unknown number
of non-RT tasks (dynamic) and N Cores then it would be a quite logical
system design to pin some of the RT tasks to CPUs and thus make such
stacking szenarios unlikely to impossible whilc at the same time retaining
the full load balancing of the non-rt tasks. If you want to ensure determinism
then relying on migration and availability of idle CPUs to migrate to is
in my opinion a design problem that needs to be resolved at the level of
the respective RT-task set.

If you are not talking about hard real-time guarantees then the question of
how probable such a szenario is most likely is a sufficient guarantee.

One could I guess put some relatively simple instrumentation in to monitor
this stacking problem - quit independant of actually measuring the times 

> Once we have this, its back to the old game of 'lock'-breaking.
>
if the stacking problem does not practically exist then it might not be worth
the effort to resolve it with elaborate lock breaking.

hofrat
