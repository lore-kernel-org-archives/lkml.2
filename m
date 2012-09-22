Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2IVPUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 11:20:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50021 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2IVPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 11:20:35 -0400
Date: Sat, 22 Sep 2012 08:20:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
Message-ID: <20120922152029.GA9796@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <505AC6C8.9060706@linux.vnet.ibm.com>
 <505AC979.7000008@gmail.com>
 <20120920152341.GE2449@linux.vnet.ibm.com>
 <505C33B9.8000807@gmail.com>
 <20120921121346.GD2458@linux.vnet.ibm.com>
 <505C6B03.7020305@gmail.com>
 <20120921151203.GA2454@linux.vnet.ibm.com>
 <505C855F.3060301@gmail.com>
 <505D7621.4040505@gmail.com>
 <20120922150913.GA2934@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120922150913.GA2934@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092215-7606-0000-0000-000003E1E677
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 08:09:13AM -0700, Paul E. McKenney wrote:
> On Sat, Sep 22, 2012 at 10:26:09AM +0200, Sasha Levin wrote:
> > On 09/21/2012 05:18 PM, Sasha Levin wrote:
> > > On 09/21/2012 05:12 PM, Paul E. McKenney wrote:
> > >> On Fri, Sep 21, 2012 at 03:26:27PM +0200, Sasha Levin wrote:
> > >>> On 09/21/2012 02:13 PM, Paul E. McKenney wrote:
> > >>>>> This might be unrelated, but I got the following dump as well when trinity
> > >>>>>> decided it's time to reboot my guest:
> > >>>> OK, sounds like we should hold off until you reproduce, then.
> > >>>
> > >>> I'm not sure what you mean.
> > >>>
> > >>> There are basically two issues I'm seeing now, which reproduce pretty much every
> > >>> time:
> > >>>
> > >>>  1. The "using when idle" warning.
> > >>>  2. The rcu related hangs during shutdown.
> > >>>
> > >>> The first one appears early on when I start fuzzing, the other one happens when
> > >>> shutting down - so both of them are reproducible in the same session.
> > >>
> > >> Ah, I misunderstood the "reboot my guest" -- I thought that you were
> > >> doing something like repeated modprobe/rmmod cycles on rcutorture while
> > >> running the guest for an extended time period.  That will teach me not
> > >> to reply to email so soon after waking up.  ;-)
> > >>
> > >> That said, #2 is expected behavior given the RCU CPU stall warnings in
> > >> your Sept. 20 dmesg.  This is because rcutorture does rcu_barrier() on
> > >> the way out, which cannot complete if grace periods are not completing.
> > >> And the later soft lockup is also likely a consequence of the stall,
> > >> because CPU hotplug does a synchronize_sched() while holding the hotplug
> > >> lock, which will then cause get_online_cpus() to hang.
> > >>
> > >> Looking further down, there are hung tasks that are waiting for a
> > >> timeout, but this is also a consequence of the hang because they
> > >> are waiting for MAX_SCHEDULE_TIMEOUT -- in other words, they are
> > >> waiting to be killed at shutdown time.  I could suppress this by using
> > >> schedule_timeout_interruptible() in a loop in order to reduce the noise
> > >> in this case.
> > >>
> > >> The remaining traces in that email are also consequences of the stall.
> > >>
> > >> So why the stall?
> > >>
> > >> Using RCU from a CPU that RCU believes to be idle can cause arbitrary
> > >> bad behavior (possibly including stalls), but with very low probability.
> > >> The reason that things can go arbitrarily bad is that RCU is ignoring
> > >> the CPU, and thus not waiting for any RCU read-side critical sections.
> > >> This could of course result in abitrary corruption of memory.  The reason
> > >> for the low probability is that grace periods tend to be long and RCU
> > >> read-side critical sections tend to be short.
> > >>
> > >> It looks like you are running -next, which has RCU grace periods driven
> > >> by a kthread.  Is it possible that this kthread is not getting a chance
> > >> to run (in fact, the "Stall ended before state dump start" is consistent
> > >> with that possibility), but in that case I would expect to see a soft
> > >> lockup from it.  Furthermore, in that case, it would be expected to
> > >> start running again as soon as things started going idle during shutdown.
> > >>
> > >> Or did the system somehow manage to stay busy despite being in shutdown?
> > >> Or, for that matter, are you overcommitting the physical CPUs on your
> > >> trinity test setup?
> > > 
> > > Nope, I originally had 4 vcpus in the guest with the host running 4 physical
> > > cpus, but I've also tested it with just 2 vcpus and still see the warnings.
> > 
> > Some more info that might help, I'm also occasionally seeing:
> > 
> > [   42.389345] ------------[ cut here ]------------
> > [   42.389348] WARNING: at kernel/rcutree.c:375 rcu_eqs_enter+0x5c/0xc0()
> > [   42.389350] Pid: 0, comm: swapper/2 Tainted: G        W
> > 3.6.0-rc6-next-20120921-sasha-00002-ge9c9495-dirty #378
> 
> Hmmm...  So either RCU is losing count or some CPU that is already
> marked as idle from RCU's perspective is trying to re-enter idle.
> 
> This is helpful, thank you!  It fits in nicely with the splat that
> you got after applying Michael Wang's patch.  Could you please try the
> diagnostic patch below?

Also, could you please send me your full .config?

							Thanx, Paul

> > [   42.389351] Call Trace:
> > [   42.389354]  [<ffffffff811c653c>] ? rcu_eqs_enter+0x5c/0xc0
> > [   42.389356]  [<ffffffff81106886>] warn_slowpath_common+0x86/0xb0
> > [   42.389359]  [<ffffffff81106975>] warn_slowpath_null+0x15/0x20
> > [   42.389361]  [<ffffffff811c653c>] rcu_eqs_enter+0x5c/0xc0
> > [   42.389364]  [<ffffffff811c66f3>] rcu_idle_enter+0x43/0xa0
> > [   42.389366]  [<ffffffff81078956>] cpu_idle+0x126/0x160
> > [   42.389369]  [<ffffffff83985a64>] start_secondary+0x26e/0x276
> > [   42.389370] ---[ end trace 04c11301284d64ee ]---
> > [   42.389394] ------------[ cut here ]------------
> > [   42.389396] WARNING: at kernel/rcutree.c:350 rcu_eqs_enter_common+0x709/0x970()
> > [   42.389398] Pid: 0, comm: swapper/2 Tainted: G        W
> > 3.6.0-rc6-next-20120921-sasha-00002-ge9c9495-dirty #378
> > [   42.389399] Call Trace:
> > [   42.389402]  [<ffffffff811c6019>] ? rcu_eqs_enter_common+0x709/0x970
> > [   42.389405]  [<ffffffff81106886>] warn_slowpath_common+0x86/0xb0
> > [   42.389407]  [<ffffffff81106975>] warn_slowpath_null+0x15/0x20
> > [   42.389410]  [<ffffffff811c6019>] rcu_eqs_enter_common+0x709/0x970
> > [   42.389412]  [<ffffffff811c658f>] rcu_eqs_enter+0xaf/0xc0
> > [   42.389414]  [<ffffffff811c66f3>] rcu_idle_enter+0x43/0xa0
> > [   42.389417]  [<ffffffff81078956>] cpu_idle+0x126/0x160
> > [   42.389420]  [<ffffffff83985a64>] start_secondary+0x26e/0x276
> > [   42.389421] ---[ end trace 04c11301284d64ef ]---
> > [   42.389424] ------------[ cut here ]------------
> > [   42.389426] WARNING: at kernel/rcutree.c:527 rcu_eqs_exit+0x4f/0xb0()
> > [   42.389427] Pid: 0, comm: swapper/2 Tainted: G        W
> > 3.6.0-rc6-next-20120921-sasha-00002-ge9c9495-dirty #378
> > [   42.389428] Call Trace:
> > [   42.389431]  [<ffffffff811c6d9f>] ? rcu_eqs_exit+0x4f/0xb0
> > [   42.389433]  [<ffffffff81106886>] warn_slowpath_common+0x86/0xb0
> > [   42.389436]  [<ffffffff81106975>] warn_slowpath_null+0x15/0x20
> > [   42.389438]  [<ffffffff811c6d9f>] rcu_eqs_exit+0x4f/0xb0
> > [   42.389441]  [<ffffffff811c6f13>] rcu_idle_exit+0x43/0xa0
> > [   42.389443]  [<ffffffff8107896d>] cpu_idle+0x13d/0x160
> > [   42.389445]  [<ffffffff83985a64>] start_secondary+0x26e/0x276
> > [   42.389447] ---[ end trace 04c11301284d64f0 ]---
> > [   42.389448] ------------[ cut here ]------------
> > [   42.389450] WARNING: at kernel/rcutree.c:501 rcu_eqs_exit_common+0x4a/0x3a0()
> > [   42.389451] Pid: 0, comm: swapper/2 Tainted: G        W
> > 3.6.0-rc6-next-20120921-sasha-00002-ge9c9495-dirty #378
> > [   42.389452] Call Trace:
> > [   42.389455]  [<ffffffff811c679a>] ? rcu_eqs_exit_common+0x4a/0x3a0
> > [   42.389458]  [<ffffffff81106886>] warn_slowpath_common+0x86/0xb0
> > [   42.389460]  [<ffffffff81106975>] warn_slowpath_null+0x15/0x20
> > [   42.389462]  [<ffffffff811c679a>] rcu_eqs_exit_common+0x4a/0x3a0
> > [   42.389465]  [<ffffffff811c6dec>] rcu_eqs_exit+0x9c/0xb0
> > [   42.389467]  [<ffffffff811c6f13>] rcu_idle_exit+0x43/0xa0
> > [   42.389470]  [<ffffffff8107896d>] cpu_idle+0x13d/0x160
> > [   42.389472]  [<ffffffff83985a64>] start_secondary+0x26e/0x276
> > [   42.389474] ---[ end trace 04c11301284d64f1 ]---
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index da14e5c..39d0aec 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -418,16 +418,22 @@ void cpu_idle(void)
>  				pm_idle();
>  
>  			rcu_idle_exit();
> +			WARN_ON(rcu_is_cpu_idle());
>  			start_critical_timings();
>  
>  			/* In many cases the interrupt that ended idle
>  			   has already called exit_idle. But some idle
>  			   loops can be woken up without interrupt. */
> +			WARN_ON(rcu_is_cpu_idle());
>  			__exit_idle();
> +			WARN_ON(rcu_is_cpu_idle());
>  		}
>  
> +		WARN_ON(rcu_is_cpu_idle());
>  		tick_nohz_idle_exit();
> +		WARN_ON(rcu_is_cpu_idle());
>  		preempt_enable_no_resched();
> +		WARN_ON(rcu_is_cpu_idle());
>  		schedule();
>  		preempt_disable();
>  	}

