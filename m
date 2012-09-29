Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab2I2OFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 10:05:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46065 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2I2OFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 10:05:36 -0400
Date: Sat, 29 Sep 2012 07:05:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: eqs related warnings in linux-next
Message-ID: <20120929140500.GD2551@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50659D37.2020206@gmail.com>
 <20120928133633.GC12843@somewhere.redhat.com>
 <20120928173133.GB2498@linux.vnet.ibm.com>
 <50669952.1000805@gmail.com>
 <CAFTL4hzuh+iXPpKpyHWvpx3-Dwy9aq+poJLF_u=xcVfJPiaQVw@mail.gmail.com>
 <20120929133737.GB2551@linux.vnet.ibm.com>
 <20120929134957.GA30257@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120929134957.GA30257@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092914-2876-0000-0000-000000978E75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 03:50:07PM +0200, Frederic Weisbecker wrote:
> On Sat, Sep 29, 2012 at 06:37:37AM -0700, Paul E. McKenney wrote:
> > On Sat, Sep 29, 2012 at 02:25:04PM +0200, Frederic Weisbecker wrote:
> > > 2012/9/29 Sasha Levin <levinsasha928@gmail.com>:
> > > > Maybe I could help here a bit.
> > > >
> > > > lappy linux # addr2line -i -e vmlinux ffffffff8111d45f
> > > > /usr/src/linux/kernel/timer.c:549
> > > > /usr/src/linux/include/linux/jump_label.h:101
> > > > /usr/src/linux/include/trace/events/timer.h:44
> > > > /usr/src/linux/kernel/timer.c:601
> > > > /usr/src/linux/kernel/timer.c:734
> > > > /usr/src/linux/kernel/timer.c:886
> > > >
> > > > Which means that it was about to:
> > > >
> > > >         debug_object_activate(timer, &timer_debug_descr);
> > 
> > Understood and agreed, hence my severe diagnostic patch.
> > 
> > > I can't find anything in the debug object code that might fault.
> > > I was suspecting some per cpu allocated memory: per cpu allocation
> > > sometimes use vmalloc
> > > which uses lazy paging using faults. But I can't find such thing there.
> > > 
> > > May be there is some faulting specific to KVM...
> > 
> > Sasha, is the easily reproducible?  If so, could you please try the
> > previous patch?  It will likely give us more information on where
> > this bug really lives.  (Yes, it might totally obscure the bug, but
> > in that case we will just need to try some other perturbation.)
> 
> Isn't your patch actually removing the timer? But if so, we won't fault
> anymore, or may be you want to check if we fault also outside the timer?

Yep, mainly to see if we are getting hammered by something else.

The other motivation for this patch is a theory I have that the timer is
actually superfluous -- the hrtimer that the dyntick-idle code programs
actually does the work.  So I might be using the code either way.

> Just in case, I'm posting a second patch that dumps the regs when we
> fault in the middle of an RCU user mode API. This way we can find
> the precise rip where we fault:

This looks like a good thing to try as well.

							Thanx, Paul

> ---
> >From db4ef9708e606754ac8a3f83b9f293383d263108 Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Sat, 29 Sep 2012 14:16:09 +0200
> Subject: [PATCH] rcu: Debug nasty rcu user mode API recursion
> 
> Add some debug code to chase down the origin of the fault.
> 
> Not-Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/mm/fault.c      |    1 +
>  include/linux/rcupdate.h |    1 +
>  kernel/rcutree.c         |   32 ++++++++++++++++++++++++++++++++
>  kernel/rcutree.h         |    1 +
>  4 files changed, 35 insertions(+)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index a530b23..a5f0eb5 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1232,6 +1232,7 @@ good_area:
>  dotraplinkage void __kprobes
>  do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  {
> +	rcu_check_user_recursion(regs);
>  	exception_enter(regs);
>  	__do_page_fault(regs, error_code);
>  	exception_exit(regs);
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 7c968e4..14ba908 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -199,6 +199,7 @@ extern void rcu_user_enter_after_irq(void);
>  extern void rcu_user_exit_after_irq(void);
>  extern void rcu_user_hooks_switch(struct task_struct *prev,
>  				  struct task_struct *next);
> +extern void rcu_check_user_recursion(struct pt_regs *regs);
>  #else
>  static inline void rcu_user_enter(void) { }
>  static inline void rcu_user_exit(void) { }
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 4fb2376..63b84f5 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -405,6 +405,20 @@ void rcu_idle_enter(void)
>  EXPORT_SYMBOL_GPL(rcu_idle_enter);
> 
>  #ifdef CONFIG_RCU_USER_QS
> +void rcu_check_user_recursion(struct pt_regs *regs)
> +{
> +	unsigned long flags;
> +	static int printed;
> +
> +	local_irq_save(flags);
> +	if (__this_cpu_read(rcu_dynticks.recursion) && !printed) {
> +		printed = 1;
> +		printk("Found recursion\n");
> +		show_regs(regs);
> +	}
> +	local_irq_restore(flags);
> +}
> +
>  /**
>   * rcu_user_enter - inform RCU that we are resuming userspace.
>   *
> @@ -433,10 +447,20 @@ void rcu_user_enter(void)
> 
>  	local_irq_save(flags);
>  	rdtp = &__get_cpu_var(rcu_dynticks);
> +	if (WARN_ON_ONCE(rdtp->recursion)) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
> +	rdtp->recursion = true;
> +	barrier();
> +
>  	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
>  		rdtp->in_user = true;
>  		rcu_eqs_enter(true);
>  	}
> +	rdtp->recursion = false;
> +
>  	local_irq_restore(flags);
>  }
> 
> @@ -590,10 +614,18 @@ void rcu_user_exit(void)
> 
>  	local_irq_save(flags);
>  	rdtp = &__get_cpu_var(rcu_dynticks);
> +	if (WARN_ON_ONCE(rdtp->recursion)) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
> +	rdtp->recursion = true;
> +	barrier();
>  	if (rdtp->in_user) {
>  		rdtp->in_user = false;
>  		rcu_eqs_exit(true);
>  	}
> +	rdtp->recursion = false;
>  	local_irq_restore(flags);
>  }
> 
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 5faf05d..1bde9d5 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -103,6 +103,7 @@ struct rcu_dynticks {
>  	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
>  #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
>  #ifdef CONFIG_RCU_USER_QS
> +	bool recursion;
>  	bool ignore_user_qs;	    /* Treat userspace as extended QS or not */
>  	bool in_user;		    /* Is the CPU in userland from RCU POV? */
>  #endif
> -- 
> 1.7.9.5
> 

