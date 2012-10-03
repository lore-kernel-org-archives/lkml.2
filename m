Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2JCSsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:48:32 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46945 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab2JCSsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:48:30 -0400
Date: Wed, 3 Oct 2012 11:39:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] rcu: Remove rcu_switch()
Message-ID: <20121003183945.GP2527@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1349288512-2635-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349288512-2635-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12100318-8974-0000-0000-00000EE6A440
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00179474; UDB=6.00040648; UTC=2012-10-03
 18:48:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 08:21:52PM +0200, Frederic Weisbecker wrote:
> It's only there to call rcu_user_hooks_switch(). Let's
> just call rcu_user_hooks_switch() directly, we don't need this
> function in the middle.

Hello, Frederic!

Doesn't this also require an empty definition of rcu_user_hooks_switch()
to handle the CONFIG_RCU_USER_QS=n case?  Or is there already such
a definition that I am too blind to see?

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/rcupdate.h |    2 ++
>  include/linux/sched.h    |    8 --------
>  kernel/sched/core.c      |    2 +-
>  3 files changed, 3 insertions(+), 9 deletions(-)
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
> index 9d51e26..65e2694 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1886,14 +1886,6 @@ static inline void rcu_copy_process(struct task_struct *p)
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
> index c177472..a48bef7 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1887,7 +1887,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
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

