Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab2EWOd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:33:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63006 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2EWOdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:33:55 -0400
Date: Wed, 23 May 2012 16:33:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 39/41] rcu: Switch to extended quiescent state in
 userspace from nohz cpuset
Message-ID: <20120523143344.GH1663@somewhere>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-40-git-send-email-fweisbec@gmail.com>
 <20120522183630.GF8087@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522183630.GF8087@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 11:36:30AM -0700, Paul E. McKenney wrote:
> On Tue, May 01, 2012 at 01:55:13AM +0200, Frederic Weisbecker wrote:
> > When we switch to adaptive nohz mode and we run in userspace,
> > we can still receive IPIs from the RCU core if a grace period
> > has been started by another CPU because we need to take part
> > of its completion.
> > 
> > However running in userspace is similar to that of running in
> > idle because we don't make use of RCU there, thus we can be
> > considered as running in RCU extended quiescent state. The
> > benefit when running into that mode is that we are not
> > anymore disturbed by needless IPIs coming from the RCU core.
> > 
> > To perform this, we just to use the RCU extended quiescent state
> > APIs on the following points:
> > 
> > - kernel exit or tick stop in userspace: here we switch to extended
> > quiescent state because we run in userspace without the tick.
> > 
> > - kernel entry or tick restart: here we exit the extended quiescent
> > state because either we enter the kernel and we may make use of RCU
> > read side critical section anytime, or we need the timer tick for some
> > reason and that takes care of RCU grace period in a traditional way.
> 
> One FIXME question below.
> 
> 							Thanx, Paul
> 
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
> >  include/linux/tick.h     |    3 +++
> >  kernel/time/tick-sched.c |   27 +++++++++++++++++++++++++--
> >  2 files changed, 28 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/tick.h b/include/linux/tick.h
> > index 3c31d6e..e2a49ad 100644
> > --- a/include/linux/tick.h
> > +++ b/include/linux/tick.h
> > @@ -153,6 +153,8 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
> >  # endif /* !NO_HZ */
> > 
> >  #ifdef CONFIG_CPUSETS_NO_HZ
> > +DECLARE_PER_CPU(int, nohz_task_ext_qs);
> > +
> >  extern void tick_nohz_enter_kernel(void);
> >  extern void tick_nohz_exit_kernel(void);
> >  extern void tick_nohz_enter_exception(struct pt_regs *regs);
> > @@ -160,6 +162,7 @@ extern void tick_nohz_exit_exception(struct pt_regs *regs);
> >  extern void tick_nohz_check_adaptive(void);
> >  extern void tick_nohz_pre_schedule(void);
> >  extern void tick_nohz_post_schedule(void);
> > +extern void tick_nohz_cpu_exit_qs(void);
> >  extern bool tick_nohz_account_tick(void);
> >  extern void tick_nohz_flush_current_times(bool restart_tick);
> >  #else /* !CPUSETS_NO_HZ */
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 8217409..b15ab5e 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -565,10 +565,13 @@ static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
> > 
> >  	if (!was_stopped && ts->tick_stopped) {
> >  		WARN_ON_ONCE(ts->saved_jiffies_whence != JIFFIES_SAVED_NONE);
> > -		if (user)
> > +		if (user) {
> >  			ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
> > -		else if (!current->mm)
> > +			__get_cpu_var(nohz_task_ext_qs) = 1;
> > +			rcu_user_enter_irq();
> > +		} else if (!current->mm) {
> >  			ts->saved_jiffies_whence = JIFFIES_SAVED_SYS;
> > +		}
> > 
> >  		ts->saved_jiffies = jiffies;
> >  		set_thread_flag(TIF_NOHZ);
> > @@ -899,6 +902,8 @@ void tick_check_idle(int cpu)
> >  }
> > 
> >  #ifdef CONFIG_CPUSETS_NO_HZ
> > +DEFINE_PER_CPU(int, nohz_task_ext_qs);
> > +
> >  void tick_nohz_exit_kernel(void)
> >  {
> >  	unsigned long flags;
> > @@ -922,6 +927,9 @@ void tick_nohz_exit_kernel(void)
> >  	ts->saved_jiffies = jiffies;
> >  	ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
> > 
> > +	__get_cpu_var(nohz_task_ext_qs) = 1;
> > +	rcu_user_enter();
> > +
> >  	local_irq_restore(flags);
> >  }
> > 
> > @@ -940,6 +948,11 @@ void tick_nohz_enter_kernel(void)
> >  		return;
> >  	}
> > 
> > +	if (__get_cpu_var(nohz_task_ext_qs) == 1) {
> > +		__get_cpu_var(nohz_task_ext_qs) = 0;
> > +		rcu_user_exit();
> > +	}
> > +
> >  	WARN_ON_ONCE(ts->saved_jiffies_whence != JIFFIES_SAVED_USER);
> > 
> >  	delta_jiffies = jiffies - ts->saved_jiffies;
> > @@ -951,6 +964,14 @@ void tick_nohz_enter_kernel(void)
> >  	local_irq_restore(flags);
> >  }
> > 
> > +void tick_nohz_cpu_exit_qs(void)
> > +{
> > +	if (__get_cpu_var(nohz_task_ext_qs)) {
> > +		rcu_user_exit_irq();
> > +		__get_cpu_var(nohz_task_ext_qs) = 0;
> > +	}
> > +}
> > +
> >  void tick_nohz_enter_exception(struct pt_regs *regs)
> >  {
> >  	if (user_mode(regs))
> > @@ -986,6 +1007,7 @@ static void tick_nohz_restart_adaptive(void)
> >  	tick_nohz_flush_current_times(true);
> >  	tick_nohz_restart_sched_tick();
> >  	clear_thread_flag(TIF_NOHZ);
> > +	tick_nohz_cpu_exit_qs();
> >  }
> > 
> >  void tick_nohz_check_adaptive(void)
> > @@ -1023,6 +1045,7 @@ void tick_nohz_pre_schedule(void)
> >  	if (ts->tick_stopped) {
> >  		tick_nohz_flush_current_times(true);
> >  		clear_thread_flag(TIF_NOHZ);
> > +		/* FIXME: warn if we are in RCU idle mode */
> 
> This would be WARN_ON_ONCE(rcu_is_cpu_idle()) or some such, correct?

Yeah indeed. I'll add that.

> 
> >  	}
> >  }
> > 
> > -- 
> > 1.7.5.4
> > 
> 
