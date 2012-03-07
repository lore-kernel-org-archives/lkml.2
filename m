Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2CGLpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:45:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61236 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2CGLpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:45:22 -0500
Date: Wed, 7 Mar 2012 14:44:10 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Andre@jasper.es
Subject: Re: [GIT PULL] RCU changes for v3.3
Message-ID: <20120307114410.GA4214@swordfish.minsk.epam.com>
References: <20120105135432.GA31450@elte.hu>
 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124165312.GG2531@linux.vnet.ibm.com>
 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124194140.GB2381@linux.vnet.ibm.com>
 <20120124232911.GA11327@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120124232911.GA11327@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/24/12 15:29), Paul E. McKenney wrote:
> On Tue, Jan 24, 2012 at 01:11:37PM -0800, Paul E. McKenney wrote:
> > On Tue, Jan 24, 2012 at 08:57:49PM +0100, Eric Dumazet wrote:
> > > Le mardi 24 janvier 2012 à 11:41 -0800, Paul E. McKenney a écrit :
> > > 
> > > > Ah, I see...  I need to find one of trace_power_start(),
> > > > trace_power_frequency(), or trace_power_end().  I would have to guess
> > > > that this is either the trace_power_start() or the trace_power_end()
> > > > called from drivers/cpuidle/cpuidle.c lines 97 and 102.  Those are
> > > > within cpuidle_idle_call(), which are called from cpu_idle() in
> > > > arch/x86/kernel/process_32.c and arch/x86/kernel/process_64.c, so this
> > > > sounds plausible.
> > > > 
> > > > And they are indeed busted -- RCU believes the CPU is idle at the point
> > > > that cpuidle_idle_call() is invoked.
> > > > 
> > > > A hacky patch is below.  Here are some of my concerns with it:
> > > > 
> > > > 1.	Is there a configuration in which the scheduler clock gets
> > > > 	turned off, but in which cpuidle_idle_call() always returns
> > > > 	zero?  If so, we either really need RCU to consider the entire
> > > > 	inner loop to be idle (thus needing to snapshot the value of
> > > > 	cpuidle_idle_call() in the outer loop) or we need explicit calls
> > > > 	to rcu_sched_qs() and friends.
> > > > 
> > > > 	Yes, we could momentarily exit RCU idleness mode, but I would
> > > > 	need to think that one through...
> > > > 
> > > > 2.	I am not totally confident that I have the order of operations
> > > > 	surrounding the call to pm_idle() correct.
> > > > 
> > > > 3.	This only addresses x86, and it looks like a few other architectures
> > > > 	have this same problem.
> > > > 
> > > > 4.	Probably other things that I haven't thought of.
> > > > 
> > > > That said, the patch does seem to compile, at least on my 32-bit
> > > > laptop...
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > > > ------------------------------------------------------------------------
> > > > 
> > > > idle: Avoid using RCU when RCU thinks the CPU is idle
> > > > 
> > > > The x86 idle loops invoke cpuidle_idle_call() which uses tracing
> > > > which uses RCU.  Unfortunately, these idle loops have already
> > > > told RCU to ignore this CPU when they call it.  This patch hacks
> > > > the idle loops to avoid this problem, but probably causing several
> > > > other problems in the process.
> > > > 
> > > > Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > ---
> > > 
> > > Hi Paul
> > > 
> > > Just tested it on my x86_64 machine, but warnings are still here
> > > 
> > > Thanks !
> > 
> > Gah!!!  The mwait_idle() function itself (which is the default value of
> > the pm_idle function pointer) uses tracing and thus RCU!  What part of
> > "don't use RCU from idle CPUs" was unclear, one wonders?
> > 
> > Ah well, the good news is that we can now detect such abuse and fix it.
> > 
> > But fixing it appears to require pushing rcu_idle_enter() and
> > rcu_idle_exit() pairs down to the bottom of each and every idle loop
> > and governor.
> > 
> > So...  The cpuidle_idle_call() function has an idle loop inside of itself,
> > namely the ->enter() call for the desired target state.  It does tracing
> > on both sides of that call.  Should the ->enter() calls actually avoid
> > use of tracing, I could push the rcu_idle_enter() and rcu_idle_exit()
> > down into cpuidle_idle_call().  We seem to have a ladder_governor and
> > a menu_governor in 3.2, and these have states, which in turn have ->enter
> > functions.
> > 
> > Hmmm...  Residual power dissipation is given in milliwatts.  I could
> > imagine some heartburn from many of the more aggressive embedded folks,
> > given that they might prefer microwatts -- or maybe even nanowatts,
> > for all I know.
> > 
> > There are a bunch of states defined in drivers/idle/intel_idle.c,
> > and these use intel_idle() as their ->enter() states.  This one looks
> > to have a nice place for rcu_idle_enter() and rcu_idle_exit().
> > 
> > But I also need to push rcu_idle_enter() and rcu_idle_exit() into any
> > function that can be assigned to pm_idle():  default_idle(), poll_idle(),
> > mwait_idle(), and amd_e400_idle().  OK, that is not all -that- bad,
> > though this must also be done for a number of other architectures as well.
> > 
> > OK, will post a patch.  I will need testing -- clearly my testing on KVM
> > is missing a few important code paths...
> 
> And here is another version of the patch.
> 
> 							Thanx, Paul
>


Hello,
I just hit the same problem.

Is this patch scheduled for 3.3 until release or will land during 3.4
merge window?


	-ss
 
> ------------------------------------------------------------------------
> 
> x86: Avoid invoking RCU when CPU is idle
> 
> The idle loop is a quiscent state for RCU, which means that RCU ignores
> CPUs that have told RCU that they are idle via rcu_idle_enter().  There
> are nevertheless quite a few places where idle CPUs use RCU, most commonly
> indirectly via tracing.  This patch fixes these problems for x86.
> 
> Many of these bugs have been in the kernel for quite some time, but
> Frederic's recent change now gives warnings.
> 
> This patch takes the straightforward approach of pushing the
> rcu_idle_enter()/rcu_idle_exit() pair further down into the core
> of the idle loop.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 15763af..f6978b0 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -386,17 +386,21 @@ void default_idle(void)
>  		 */
>  		smp_mb();
>  
> +		rcu_idle_enter();
>  		if (!need_resched())
>  			safe_halt();	/* enables interrupts racelessly */
>  		else
>  			local_irq_enable();
> +		rcu_idle_exit();
>  		current_thread_info()->status |= TS_POLLING;
>  		trace_power_end(smp_processor_id());
>  		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
>  	} else {
>  		local_irq_enable();
>  		/* loop is done by the caller */
> +		rcu_idle_enter();
>  		cpu_relax();
> +		rcu_idle_exit();
>  	}
>  }
>  #ifdef CONFIG_APM_MODULE
> @@ -457,14 +461,19 @@ static void mwait_idle(void)
>  
>  		__monitor((void *)&current_thread_info()->flags, 0, 0);
>  		smp_mb();
> +		rcu_idle_enter();
>  		if (!need_resched())
>  			__sti_mwait(0, 0);
>  		else
>  			local_irq_enable();
> +		rcu_idle_exit();
>  		trace_power_end(smp_processor_id());
>  		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
> -	} else
> +	} else {
>  		local_irq_enable();
> +		rcu_idle_enter();
> +		rcu_idle_exit();
> +	}
>  }
>  
>  /*
> @@ -477,8 +486,10 @@ static void poll_idle(void)
>  	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
>  	trace_cpu_idle(0, smp_processor_id());
>  	local_irq_enable();
> +	rcu_idle_enter();
>  	while (!need_resched())
>  		cpu_relax();
> +	rcu_idle_exit();
>  	trace_power_end(smp_processor_id());
>  	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
>  }
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index 485204f..6d9d4d5 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -100,7 +100,6 @@ void cpu_idle(void)
>  	/* endless idle loop with no priority at all */
>  	while (1) {
>  		tick_nohz_idle_enter();
> -		rcu_idle_enter();
>  		while (!need_resched()) {
>  
>  			check_pgt_cache();
> @@ -117,7 +116,6 @@ void cpu_idle(void)
>  				pm_idle();
>  			start_critical_timings();
>  		}
> -		rcu_idle_exit();
>  		tick_nohz_idle_exit();
>  		preempt_enable_no_resched();
>  		schedule();
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index 9b9fe4a..55a1a35 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -140,13 +140,9 @@ void cpu_idle(void)
>  			/* Don't trace irqs off for idle */
>  			stop_critical_timings();
>  
> -			/* enter_idle() needs rcu for notifiers */
> -			rcu_idle_enter();
> -
>  			if (cpuidle_idle_call())
>  				pm_idle();
>  
> -			rcu_idle_exit();
>  			start_critical_timings();
>  
>  			/* In many cases the interrupt that ended idle
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 20bce51..a9ddab8 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -261,6 +261,7 @@ static int intel_idle(struct cpuidle_device *dev,
>  	kt_before = ktime_get_real();
>  
>  	stop_critical_timings();
> +	rcu_idle_enter();
>  	if (!need_resched()) {
>  
>  		__monitor((void *)&current_thread_info()->flags, 0, 0);
> @@ -268,6 +269,7 @@ static int intel_idle(struct cpuidle_device *dev,
>  		if (!need_resched())
>  			__mwait(eax, ecx);
>  	}
> +	rcu_idle_exit();
>  
>  	start_critical_timings();
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
