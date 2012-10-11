Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab2JKAuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:50:50 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34183 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757828Ab2JKAut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:50:49 -0400
Date: Wed, 10 Oct 2012 17:49:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2] rcu: Remove rcu_switch()
Message-ID: <20121011004943.GK2495@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1349912836-11780-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349912836-11780-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12101100-6078-0000-0000-0000108A5204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 01:47:16AM +0200, Frederic Weisbecker wrote:
> It's only there to call rcu_user_hooks_switch(). Let's
> just call rcu_user_hooks_switch() directly, we don't need this
> function in the middle.

Queued, thank you!

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Richard Weinberger <richard@nod.at>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  arch/um/drivers/mconsole_kern.c |    2 +-
>  include/linux/rcupdate.h        |    2 ++
>  include/linux/sched.h           |    8 --------
>  kernel/sched/core.c             |    2 +-
>  4 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
> index c17de0d..0b989af 100644
> --- a/arch/um/drivers/mconsole_kern.c
> +++ b/arch/um/drivers/mconsole_kern.c
> @@ -705,7 +705,7 @@ static void stack_proc(void *arg)
>  	struct task_struct *from = current, *to = arg;
> 
>  	to->thread.saved_task = from;
> -	rcu_switch(from, to);
> +	rcu_user_hooks_switch(from, to);
>  	switch_to(from, to, from);
>  }
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 7c968e4..5d009de 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -204,6 +204,8 @@ static inline void rcu_user_enter(void) { }
>  static inline void rcu_user_exit(void) { }
>  static inline void rcu_user_enter_after_irq(void) { }
>  static inline void rcu_user_exit_after_irq(void) { }
> +static inline void rcu_user_hooks_switch(struct task_struct *prev,
> +					 struct task_struct *next) { }
>  #endif /* CONFIG_RCU_USER_QS */
> 
>  extern void exit_rcu(void);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index fade317..c300c7c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1887,14 +1887,6 @@ static inline void rcu_copy_process(struct task_struct *p)
> 
>  #endif
> 
> -static inline void rcu_switch(struct task_struct *prev,
> -			      struct task_struct *next)
> -{
> -#ifdef CONFIG_RCU_USER_QS
> -	rcu_user_hooks_switch(prev, next);
> -#endif
> -}
> -
>  static inline void tsk_restore_flags(struct task_struct *task,
>  				unsigned long orig_flags, unsigned long flags)
>  {
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index dd036fe..b53a485 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2081,7 +2081,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
>  #endif
> 
>  	/* Here we just switch the register state and the stack. */
> -	rcu_switch(prev, next);
> +	rcu_user_hooks_switch(prev, next);
>  	switch_to(prev, next, prev);
> 
>  	barrier();
> -- 
> 1.7.5.4
> 

