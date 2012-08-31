Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2HaXsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:48:47 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43405 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2HaXsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:48:45 -0400
X-Originating-IP: 217.70.178.151
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 16:48:36 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH tip/core/rcu 07/26] rcu: Switch task's syscall hooks on
 context switch
Message-ID: <20120831234836.GE11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-7-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-7-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:24PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Clear the syscalls hook of a task when it's scheduled out so that if
> the task migrates, it doesn't run the syscall slow path on a CPU
> that might not need it.
> 
> Also set the syscalls hook on the next task if needed.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/um/drivers/mconsole_kern.c |    1 +
>  include/linux/rcupdate.h        |    2 ++
>  include/linux/sched.h           |    8 ++++++++
>  kernel/rcutree.c                |   15 +++++++++++++++
>  kernel/sched/core.c             |    1 +
>  5 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
> index 664a60e..c17de0d 100644
> --- a/arch/um/drivers/mconsole_kern.c
> +++ b/arch/um/drivers/mconsole_kern.c
> @@ -705,6 +705,7 @@ static void stack_proc(void *arg)
>  	struct task_struct *from = current, *to = arg;
>  
>  	to->thread.saved_task = from;
> +	rcu_switch(from, to);
>  	switch_to(from, to, from);
>  }
>  
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index e411117..1fc0a0e 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -197,6 +197,8 @@ extern void rcu_user_enter(void);
>  extern void rcu_user_exit(void);
>  extern void rcu_user_enter_irq(void);
>  extern void rcu_user_exit_irq(void);
> +extern void rcu_user_hooks_switch(struct task_struct *prev,
> +				  struct task_struct *next);
>  #else
>  static inline void rcu_user_enter(void) { }
>  static inline void rcu_user_exit(void) { }
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c147e70..e4d5936 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1894,6 +1894,14 @@ static inline void rcu_copy_process(struct task_struct *p)
>  
>  #endif
>  
> +static inline void rcu_switch(struct task_struct *prev,
> +			      struct task_struct *next)
> +{
> +#ifdef CONFIG_RCU_USER_QS
> +	rcu_user_hooks_switch(prev, next);
> +#endif
> +}
> +
>  static inline void tsk_restore_flags(struct task_struct *task,
>  				unsigned long orig_flags, unsigned long flags)
>  {
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e2fd370..af92681 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -721,6 +721,21 @@ int rcu_is_cpu_idle(void)
>  }
>  EXPORT_SYMBOL(rcu_is_cpu_idle);
>  
> +#ifdef CONFIG_RCU_USER_QS
> +void rcu_user_hooks_switch(struct task_struct *prev,
> +			   struct task_struct *next)
> +{
> +	struct rcu_dynticks *rdtp;
> +
> +	/* Interrupts are disabled in context switch */
> +	rdtp = &__get_cpu_var(rcu_dynticks);
> +	if (!rdtp->ignore_user_qs) {
> +		clear_tsk_thread_flag(prev, TIF_NOHZ);
> +		set_tsk_thread_flag(next, TIF_NOHZ);
> +	}
> +}
> +#endif /* #ifdef CONFIG_RCU_USER_QS */
> +
>  #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
>  
>  /*
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index d325c4b..07c6d9a 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2081,6 +2081,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
>  #endif
>  
>  	/* Here we just switch the register state and the stack. */
> +	rcu_switch(prev, next);
>  	switch_to(prev, next, prev);
>  
>  	barrier();
> -- 
> 1.7.8
> 
