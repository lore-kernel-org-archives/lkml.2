Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0HGVRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 17:17:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35238 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab0HGVRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 17:17:31 -0400
Date: Sat, 7 Aug 2010 14:17:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: linux-next: manual merge of the kgdb tree with Linus' tree
Message-ID: <20100807211728.GA28829@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100807140542.bea61032.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807140542.bea61032.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 02:05:42PM +1000, Stephen Rothwell wrote:
> Hi Jason,
> 
> Today's linux-next merge of the kgdb tree got a conflict in
> include/linux/rcupdate.h between commits
> 551d55a944b143ef26fbd482d1c463199d6f65cf ("tree/tiny rcu: Add debug RCU
> head objects") and f5155b33277c9678041a27869165619bb34f722f ("rcu: add an
> rcu_dereference_index_check()") from Linus' tree and commit
> 9e213357d0aeaeb81e213cfd3b9415db5fccc1b5 ("rcu,debug_core: allow the
> kernel debugger to reset the rcu stall timer") from the kgdb tree.

Hello, Jason,

Just trying to make sure I understand this...

This cannot be a "stop the machine" debugger, because otherwise the
jiffies counter would stop and you would not get RCU CPU stall warnings.

It might be a "stop the machine" debugger, but where the jiffies counter
catches up quickly as soon as the machine restarts.  In this case,
your patch would be a reasonable approach, but RCU CPU stall warnings
are going to be the least of your problems.  Actually, I have only seen
one piece of your patch.  Could you please send me the rest of it?

If you are permitting some tasks to run while others are halted,
then the RCU CPU stall is simply a symptom of an underlying problem,
namely that if you halt a task in an RCU read-side critical section
for long enough, you will OOM the system.

							Thanx, Paul

> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix for a while.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc include/linux/rcupdate.h
> index 9fbc54a,585efef..0000000
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@@ -529,74 -517,12 +529,82 @@@ extern void call_rcu(struct rcu_head *h
>   extern void call_rcu_bh(struct rcu_head *head,
>   			void (*func)(struct rcu_head *head));
>   
>  +/*
>  + * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
>  + * by call_rcu() and rcu callback execution, and are therefore not part of the
>  + * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
>  + */
>  +
>  +#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
>  +# define STATE_RCU_HEAD_READY	0
>  +# define STATE_RCU_HEAD_QUEUED	1
>  +
>  +extern struct debug_obj_descr rcuhead_debug_descr;
>  +
>  +static inline void debug_rcu_head_queue(struct rcu_head *head)
>  +{
>  +	debug_object_activate(head, &rcuhead_debug_descr);
>  +	debug_object_active_state(head, &rcuhead_debug_descr,
>  +				  STATE_RCU_HEAD_READY,
>  +				  STATE_RCU_HEAD_QUEUED);
>  +}
>  +
>  +static inline void debug_rcu_head_unqueue(struct rcu_head *head)
>  +{
>  +	debug_object_active_state(head, &rcuhead_debug_descr,
>  +				  STATE_RCU_HEAD_QUEUED,
>  +				  STATE_RCU_HEAD_READY);
>  +	debug_object_deactivate(head, &rcuhead_debug_descr);
>  +}
>  +#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
>  +static inline void debug_rcu_head_queue(struct rcu_head *head)
>  +{
>  +}
>  +
>  +static inline void debug_rcu_head_unqueue(struct rcu_head *head)
>  +{
>  +}
>  +#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
>  +
>  +#ifndef CONFIG_PROVE_RCU
>  +#define __do_rcu_dereference_check(c) do { } while (0)
>  +#endif /* #ifdef CONFIG_PROVE_RCU */
>  +
>  +#define __rcu_dereference_index_check(p, c) \
>  +	({ \
>  +		typeof(p) _________p1 = ACCESS_ONCE(p); \
>  +		__do_rcu_dereference_check(c); \
>  +		smp_read_barrier_depends(); \
>  +		(_________p1); \
>  +	})
>  +
>  +/**
>  + * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
>  + * @p: The pointer to read, prior to dereferencing
>  + * @c: The conditions under which the dereference will take place
>  + *
>  + * Similar to rcu_dereference_check(), but omits the sparse checking.
>  + * This allows rcu_dereference_index_check() to be used on integers,
>  + * which can then be used as array indices.  Attempting to use
>  + * rcu_dereference_check() on an integer will give compiler warnings
>  + * because the sparse address-space mechanism relies on dereferencing
>  + * the RCU-protected pointer.  Dereferencing integers is not something
>  + * that even gcc will put up with.
>  + *
>  + * Note that this function does not implicitly check for RCU read-side
>  + * critical sections.  If this function gains lots of uses, it might
>  + * make sense to provide versions for each flavor of RCU, but it does
>  + * not make sense as of early 2010.
>  + */
>  +#define rcu_dereference_index_check(p, c) \
>  +	__rcu_dereference_index_check((p), (c))
>  +
> + #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> + extern void rcu_cpu_stall_reset(void);
> + #else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> + static void rcu_cpu_stall_reset()
> + {
> + }
> + #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> + 
>   #endif /* __LINUX_RCUPDATE_H */
