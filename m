Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2IZRAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:00:01 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50623 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab2IZQ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:59:58 -0400
Date: Wed, 26 Sep 2012 09:59:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
Message-ID: <20120926165943.GE2467@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <505EA09B.6040105@gmail.com>
 <CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
 <5060E31B.3070203@gmail.com>
 <5060E498.7030003@gmail.com>
 <CAFTL4hzVSBkcDRnzvpmXyBHqydqy=nJxdMtjUHrvR8MwN_M0jQ@mail.gmail.com>
 <5060E863.6020006@gmail.com>
 <20120925120549.GC2310@somewhere.redhat.com>
 <5061F7C7.7060107@gmail.com>
 <20120925183654.GI2502@linux.vnet.ibm.com>
 <20120926154601.GB6928@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926154601.GB6928@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092616-2398-0000-0000-00000B71E6E4
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00177500; UDB=6.00040192; UTC=2012-09-26
 16:59:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 05:46:13PM +0200, Frederic Weisbecker wrote:
> On Tue, Sep 25, 2012 at 11:36:54AM -0700, Paul E. McKenney wrote:
> > On Tue, Sep 25, 2012 at 08:28:23PM +0200, Sasha Levin wrote:
> > > On 09/25/2012 02:06 PM, Frederic Weisbecker wrote:
> > > > Sasha, sorry to burden you with more testing request.
> > > > Could you please try out this new branch? It includes some fixes after Wu Fenguang and
> > > > Dan Carpenter reports (not related to your warnings though) and a patch on the top
> > > > of the pile to ensure I diagnosed well the problem, which return immediately from
> > > > rcu_user_*() APIs if we are in an interrupt.
> > > > 
> > > > This way we'll have a clearer view. I also would like to know if there are other
> > > > problems with the rcu user mode.
> > > > 
> > > > Thanks!
> > > 
> > > Alrighty, I don't see any warnings anymore.
> > > 
> > > I'll keep everything running just in case.
> > 
> > Very good news!!!  Thank you both!!!
> 
> So, I've pushed the fixes in a new branch.
> 
> Changes are:
> 
> * Added in_interrupt() checks in "rcu: New rcu_user_enter() and rcu_user_exit() APIs"
> so that rcu_user_enter/exit() don't nest in rcu_irq_enter/exit().
> 
> We'll need a longer term solution I guess because of:
> 	- Irq bad nesting
> 	- An exception could happen in the middle of irq_exit(), although that's quite
> 	  unlikely (ie: between sub_preempt_count(HARDIRQ) and add_preempt_count(SOFTIRQ) or between
> 	  sub_preempt_count(SOFTIRQ or HARDIRQ) and rcu_irq_exit().
> 	  May be I should rather check for (rdtp->dynticks_nesting & (DYNTICK_TASK_FLAG -1))
> 	  to find out if we are in the middle of an irq from an RCU POV.
> 
> 
> * Fix the !notifie_die(...) == NOTIFY_STOP to become notifie_die(...) != NOTIFY_STOP.
> Reported by Wu Fenguang and Dan Carpenter. Fixes are folded inside:
> "x86: Exception hooks for userspace RCU extended QS".
> 
> The branch (rebase on top of your rcu/idle) is:
> 
> git://github.com/fweisbec/linux-dynticks.git
> 	rcu/idle-for-v3.7-take5

Thank you, Frederic!  I have pushed this to rcu/idle in -rcu, and am
testing in parallel.

							Thanx, Paul

> Diff against your rcu/idle:
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index cb20776..3789675 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -232,8 +232,8 @@ DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
>  dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
>  {
>  	exception_enter(regs);
> -	if (!notify_die(DIE_TRAP, "stack segment", regs, error_code,
> -		       X86_TRAP_SS, SIGBUS) == NOTIFY_STOP) {
> +	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
> +		       X86_TRAP_SS, SIGBUS) != NOTIFY_STOP) {
>  		preempt_conditional_sti(regs);
>  		do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
>  		preempt_conditional_cli(regs);
> @@ -285,8 +285,8 @@ do_general_protection(struct pt_regs *regs, long error_code)
> 
>  		tsk->thread.error_code = error_code;
>  		tsk->thread.trap_nr = X86_TRAP_GP;
> -		if (!notify_die(DIE_GPF, "general protection fault", regs, error_code,
> -			       X86_TRAP_GP, SIGSEGV) == NOTIFY_STOP)
> +		if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
> +			       X86_TRAP_GP, SIGSEGV) != NOTIFY_STOP)
>  			die("general protection fault", regs, error_code);
>  		goto exit;
>  	}
> @@ -678,8 +678,8 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
>  	info.si_errno = 0;
>  	info.si_code = ILL_BADSTK;
>  	info.si_addr = NULL;
> -	if (!notify_die(DIE_TRAP, "iret exception", regs, error_code,
> -			X86_TRAP_IRET, SIGILL) == NOTIFY_STOP) {
> +	if (notify_die(DIE_TRAP, "iret exception", regs, error_code,
> +			X86_TRAP_IRET, SIGILL) != NOTIFY_STOP) {
>  		do_trap(X86_TRAP_IRET, SIGILL, "iret exception", regs, error_code,
>  			&info);
>  	}
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 72453cf..4fb2376 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -418,6 +418,17 @@ void rcu_user_enter(void)
>  	unsigned long flags;
>  	struct rcu_dynticks *rdtp;
> 
> +	/*
> +	 * Some contexts may involve an exception occuring in an irq,
> +	 * leading to that nesting:
> +	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
> +	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
> +	 * helpers are enough to protect RCU uses inside the exception. So
> +	 * just return immediately if we detect we are in an IRQ.
> +	 */
> +	if (in_interrupt())
> +		return;
> +
>  	WARN_ON_ONCE(!current->mm);
> 
>  	local_irq_save(flags);
> @@ -566,6 +577,17 @@ void rcu_user_exit(void)
>  	unsigned long flags;
>  	struct rcu_dynticks *rdtp;
> 
> +	/*
> +	 * Some contexts may involve an exception occuring in an irq,
> +	 * leading to that nesting:
> +	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
> +	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
> +	 * helpers are enough to protect RCU uses inside the exception. So
> +	 * just return immediately if we detect we are in an IRQ.
> +	 */
> +	if (in_interrupt())
> +		return;
> +
>  	local_irq_save(flags);
>  	rdtp = &__get_cpu_var(rcu_dynticks);
>  	if (rdtp->in_user) {
> 

