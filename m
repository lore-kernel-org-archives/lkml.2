Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2LMVSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 16:18:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2LMVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 16:18:11 -0500
Date: Thu, 13 Dec 2012 13:18:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: [PATCH] context_tracking: Add comments on interface and
 internals
Message-Id: <20121213131809.122fdd61.akpm@linux-foundation.org>
In-Reply-To: <1355432225-5878-1-git-send-email-fweisbec@gmail.com>
References: <1355432225-5878-1-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012 21:57:05 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This subsystem lacks many explanations on its purpose and
> design. Add these missing comments.

Thanks, it helps.

> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -1,3 +1,19 @@
> +/*
> + * Context tracking: Probe on high level context boundaries such as kernel
> + * and userspace. This includes syscalls and exceptions entry/exit.
> + *
> + * This is used by RCU to remove its dependency to the timer tick while a CPU
> + * runs in userspace.

"on the timer tick"

> + *
> + *  Started by Frederic Weisbecker:
> + *
> + * Copyright (C) 2012 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
> + *
> + * Many thanks to Gilad Ben-Yossef, Paul McKenney, Ingo Molnar, Andrew Morton,
> + * Steven Rostedt, Peter Zijlstra for suggestions and improvements.
> + *
> + */
> +
>  #include <linux/context_tracking.h>
>  #include <linux/rcupdate.h>
>  #include <linux/sched.h>
> @@ -6,8 +22,8 @@
>  
>  struct context_tracking {
>  	/*
> -	 * When active is false, hooks are not set to
> -	 * minimize overhead: TIF flags are cleared
> +	 * When active is false, hooks are unset in order
> +	 * to minimize overhead: TIF flags are cleared
>  	 * and calls to user_enter/exit are ignored. This
>  	 * may be further optimized using static keys.
>  	 */
> @@ -24,6 +40,16 @@ static DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
>  #endif
>  };
>  
> +/**
> + * user_enter - Inform the context tracking that the CPU is going to
> + *              enter in userspace mode.

s/in //

> + *
> + * This function must be called right before we switch from the kernel
> + * to the user space, when the last remaining kernel instructions to execute

s/the user space/userspace/

> + * are low level arch code that perform the resuming to userspace.

This is a bit vague - what is "right before"?  What happens if this is
done a few instructions early?  I mean, what exactly is the requirement
here?  Might it be something like "after the last rcu_foo operation"?

IOW, if the call to user_enter() were moved earlier and earlier, at
what point would the kernel gain a bug?  What caused that bug?

> + * This call supports re-entrancy.

Presumably the explanation for user_exit() applies here.

> + */
>  void user_enter(void)
>  {
>  	unsigned long flags;
> @@ -39,40 +65,68 @@ void user_enter(void)
>  	if (in_interrupt())
>  		return;
>  
> +	/* Kernel thread aren't supposed to go to userspace */

s/thread/threads/

>  	WARN_ON_ONCE(!current->mm);
>  
>  	local_irq_save(flags);
>  	if (__this_cpu_read(context_tracking.active) &&
>  	    __this_cpu_read(context_tracking.state) != IN_USER) {
>  		__this_cpu_write(context_tracking.state, IN_USER);
> +		/*
> +		 * At this stage, only low level arch entry code remains and
> +		 * then we'll run in userspace. We can assume there won't we

s/we/be/

> +		 * any RCU read-side critical section until the next call to
> +		 * user_exit() or rcu_irq_enter(). Let's remove RCU's dependency
> +		 * on the tick.
> +		 */
>  		rcu_user_enter();
>  	}
>  	local_irq_restore(flags);
>  }
>  
> +
> +/**
> + * user_exit - Inform the context tracking that the CPU is
> + *             exiting userspace mode and entering the kernel.
> + *
> + * This function must be called right before we run any high level kernel
> + * code (ie: anything that is not low level arch entry code) after we entered
> + * the kernel from userspace.

Also a very vague spec.

> + * This call supports re-entrancy. This way it can be called from any exception
> + * handler without bothering to know if we come from userspace or not.

s/bothering/needing/

s/come/came/

> + */
>  void user_exit(void)
>  {
>  	unsigned long flags;
>  
> -	/*
> -	 * Some contexts may involve an exception occuring in an irq,
> -	 * leading to that nesting:
> -	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
> -	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
> -	 * helpers are enough to protect RCU uses inside the exception. So
> -	 * just return immediately if we detect we are in an IRQ.
> -	 */
>  	if (in_interrupt())
>  		return;
>  
>  	local_irq_save(flags);
>  	if (__this_cpu_read(context_tracking.state) == IN_USER) {
>  		__this_cpu_write(context_tracking.state, IN_KERNEL);
> +		/*
> +		 * We are going to run code that may use RCU. Inform
> +		 * RCU core about that (ie: we may need the tick again).
> +		 */
>  		rcu_user_exit();
>  	}
>  	local_irq_restore(flags);
>  }
>  
> +
> +/**
> + * context_tracking_task_switch - context switch the syscall hooks
> + *
> + * The context tracking uses the syscall slow path to implement its user-kernel
> + * boundaries hooks on syscalls. This way it doesn't impact the syscall fast
> + * path on CPUs that don't do context tracking.
> + *
> + * But we need to clear the flag on the previous task because it may later
> + * migrate to some CPU that doesn't do the context tracking. As such the TIF
> + * flag may not be desired there.
> + */
>  void context_tracking_task_switch(struct task_struct *prev,
>  			     struct task_struct *next)
>  {

It's mainly this bit which makes me wonder why the code is in lib/.  Is
there any conceivable prospect that any other subsystem will use this
code for anything?


