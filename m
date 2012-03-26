Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2CZHzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 03:55:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:55885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2CZHzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 03:55:14 -0400
Message-ID: <1332748484.16159.61.camel@twins>
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org
Date: Mon, 26 Mar 2012 09:54:44 +0200
In-Reply-To: <20120325205249.GA29528@linux.vnet.ibm.com>
References: <20120325205249.GA29528@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-03-25 at 13:52 -0700, Paul E. McKenney wrote:
> The preemptible-RCU implementations of __rcu_read_lock() have not been
> inlinable due to task_struct references that ran afoul of include-file
> dependencies.  Fix this (as suggested by Linus) by moving the task_struct
> ->rcu_read_lock_nesting field to a per-CPU variable that is saved and
> restored at context-switch time.  With this change, __rcu_read_lock()
> references only that new per-CPU variable, and so may be safely
> inlined.  This change also allows some code that was duplicated in
> kernel/rcutree_plugin.h and kernel/rcutiny_plugin.h to be merged into
> include/linux/rcupdate.h.
> 
> This same approach unfortunately cannot be used on __rcu_read_unlock()
> because it also references the task_struct ->rcu_read_unlock_special
> field, to which cross-task access is required by rcu_boost().  This
> function will be handled in a separate commit, if need be.
> 
> The TREE_RCU variant passes modest rcutorture runs, while TINY_RCU still
> has a few bugs.  Peter Zijlstra might have some thoughts on hooking into
> the scheduler.  Disallows use of RCU from within the architecture-specific
> switch_to() function, which probably runs afoul of tracing for at least
> some architectures.  There probably are still a few other bugs, as well.
> 
> TREE_RCU should be OK for experimental usage.

Right, so I really dislike adding this cache-miss to the context switch
path, that said, rcu is used often enough that the savings on
rcu_read_lock() might just come out in favour of this.. but it would be
very nice to have some numbers.

Also,

>  /*
> + * Save the incoming task's value for rcu_read_lock_nesting at the
> + * end of a context switch.  There can be no process-state RCU read-side
> + * critical sections between the call to rcu_switch_from() and to
> + * rcu_switch_to().  Interrupt-level RCU read-side critical sections are
> + * OK because rcu_read_unlock_special() takes early exits when called
> + * at interrupt level.
> + */
> +void rcu_switch_from(void)
> +{
> +	current->rcu_read_lock_nesting_save =
> +		__this_cpu_read(rcu_read_lock_nesting);
> +	barrier();
> +	__this_cpu_write(rcu_read_lock_nesting, 0);
> +}

Since rcu_switch_to() will again write rcu_read_lock_nesting, what's the
point of setting it to zero?

Also, that barrier(), there's a clear dependency between the operations
how can the compiler mess that up?

> +/*
> + * Restore the incoming task's value for rcu_read_lock_nesting at the
> + * end of a context switch.
>   */
> +void rcu_switch_to(void)
>  {
> +	__this_cpu_write(rcu_read_lock_nesting,
> +			 current->rcu_read_lock_nesting_save);
> +	barrier();
> +	current->rcu_read_lock_nesting_save = 0;
>  }

Similar, a future rcu_switch_from() will again over-write
current->rcu_read_lock_nesting_save, what's the point of clearing it?


> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2051,7 +2051,9 @@ context_switch(struct rq *rq, struct task_struct *prev,
>  #endif
>  
>  	/* Here we just switch the register state and the stack. */
> +	rcu_switch_from();
>  	switch_to(prev, next, prev);
> +	rcu_switch_to();
>  
>  	barrier();
>  	/*

So why not save one call and do:

	switch_to(prev, next, prev);
 	rcu_switch_to(prev, next);

and have

void rcu_switch_to(struct task_struct *prev, struct task_struct *next)
{
	prev->rcu_read_lock_nesting_save = __this_cpu_read(rcu_read_lock_nesting);
	__this_cpu_write(rcu_read_lock_nesting) = next->rcu_read_lock_nesting_save;
}

preferably as an inline function so we can avoid all calls.
