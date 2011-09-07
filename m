Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1IGMT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 08:19:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:49401 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1IGMTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 08:19:25 -0400
Date: Wed, 7 Sep 2011 11:25:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frank Rowand <frank.rowand@am.sony.com>
cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@tglx.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
In-Reply-To: <4E66DCAB.8090801@am.sony.com>
Message-ID: <alpine.LFD.2.02.1109071115410.2723@ionos>
References: <1313232790.25267.7.camel@twins> <4E559039.8060209@am.sony.com> <20110826235507.GJ2342@linux.vnet.ibm.com> <4E66DCAB.8090801@am.sony.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011, Frank Rowand wrote:

> On 08/26/11 16:55, Paul E. McKenney wrote:
> > On Wed, Aug 24, 2011 at 04:58:49PM -0700, Frank Rowand wrote:
> >> On 08/13/11 03:53, Peter Zijlstra wrote:
> >>>
> >>> Whee, I can skip release announcements too!
> >>>
> >>> So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
> >>> grabs.
> 
> < snip >
> 
> >> I have a consistent (every boot) hang on boot.  With a few
> >> hacks to get console output, I get the
> >>
> >>   rcu_preempt_state detected stalls on CPUs/tasks
> 
> < snip >
> 
> >> This is an ARM NaviEngine (out of tree, so I also have applied
> >> a series of pages for platform support).
> >>
> >> CONFIG_PREEMPT_RT_FULL is set.  Full config is attached.
> 
> I have also replicated the problem on the ARM RealView (in tree) and
> without the RT patches.
> 
> > 
> > Hmmm...  The last few that I have seen that looked like this were
> > due to my messing up rcutorture so that the RCU-boost testing kthreads
> > ran CPU-bound at real-time priority.
> > 
> > Is it possible that something similar is happening on your system?
> > 
> >                                                         Thanx, Paul
> 
> The problem ended up being caused by the allowed cpus mask being set
> to all possible cpus for the ksoftirqd on the secondary processors.
> So the RCU softirq was never executing on cpu 2.
> 
> I'll test the following patch on 3.1 tomorrow.
> 
> -Frank Rowand
> 
> 
> Symptom: rcu stall
> 
> The problem was that ksoftirqd was woken on the secondary processors before
> the secondary processors were online.  This led to allowed cpus being set
> to all cpus.
> 
>    wake_up_process()
>       try_to_wake_up()
>          select_task_rq()
>             if (... || !cpu_online(cpu))
>                select_fallback_rq(task_cpu(p), p)
>                   ...
>                   /* No more Mr. Nice Guy. */
>                   dest_cpu = cpuset_cpus_allowed_fallback(p)
>                      do_set_cpus_allowed(p, cpu_possible_mask)
>                         #  Thus ksoftirqd can now run on any cpu...

This smells badly like the problem we've seen on x86 before. And
looking at the arm SMP boot code:

asmlinkage void __cpuinit secondary_start_kernel(void)
{
	.....

	/*
	 * Give the platform a chance to do its own initialisation.
	 */
	platform_secondary_init(cpu);

	/*
	 * Enable local interrupts.
	 */
	notify_cpu_starting(cpu);
	local_irq_enable();

Here we enable interrupts, but the CPU is neither online nor active.

	local_fiq_enable();

	/*
	 * Setup the percpu timer for this CPU.
	 */
	percpu_timer_setup();

	calibrate_delay();

	smp_store_cpu_info(cpu);

	/*
	 * OK, now it's safe to let the boot CPU continue.  Wait for
	 * the CPU migration code to notice that the CPU is online
	 * before we continue.
	 */
	set_cpu_online(cpu, true);
	while (!cpu_active(cpu))
		cpu_relax();

That's the same thing as x86 is doing, just with interrupts enabled
and therefor it does not help. And the softirq is only part of the
problem, the same can happen with worker threads and other cpu bound
nasties.

	/*
	 * OK, it's off to the idle thread for us
	 */
	cpu_idle();
}

So that wants to be ordered differently. Patch below.

Thanks,

	tglx

Index: linux-2.6/arch/arm/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/smp.c
+++ linux-2.6/arch/arm/kernel/smp.c
@@ -305,6 +305,16 @@ asmlinkage void __cpuinit secondary_star
 	 * Enable local interrupts.
 	 */
 	notify_cpu_starting(cpu);
+
+	/*
+	 * OK, now it's safe to let the boot CPU continue.  Wait for
+	 * the CPU migration code to notice that the CPU is online
+	 * before we continue.
+	 */
+	set_cpu_online(cpu, true);
+	while (!cpu_active(cpu))
+		cpu_relax();
+
 	local_irq_enable();
 	local_fiq_enable();
 
@@ -318,15 +328,6 @@ asmlinkage void __cpuinit secondary_star
 	smp_store_cpu_info(cpu);
 
 	/*
-	 * OK, now it's safe to let the boot CPU continue.  Wait for
-	 * the CPU migration code to notice that the CPU is online
-	 * before we continue.
-	 */
-	set_cpu_online(cpu, true);
-	while (!cpu_active(cpu))
-		cpu_relax();
-
-	/*
 	 * OK, it's off to the idle thread for us
 	 */
 	cpu_idle();

