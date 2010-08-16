Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0HPPHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:07:40 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:55145 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411Ab0HPPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:07:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANDvaExGGN19/2dsb2JhbACgQXK8Q4U7BA
Date: Mon, 16 Aug 2010 11:07:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
Message-ID: <20100816150737.GB8320@Krystal>
References: <20100809221447.GA24358@linux.vnet.ibm.com> <1281392111-25060-8-git-send-email-paulmck@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1281392111-25060-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:51:11 up 131 days, 42 min,  3 users,  load average: 0.24,
	0.31, 0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
[...]
> +
> +/*
> + * Tiny-preemptible RCU implementation for rcu_read_unlock().
> + * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
> + * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
> + * invoke rcu_read_unlock_special() to clean up after a context switch
> + * in an RCU read-side critical section and other special cases.
> + */
> +void __rcu_read_unlock(void)
> +{
> +	struct task_struct *t = current;
> +
> +	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
> +	if (--t->rcu_read_lock_nesting == 0 &&
> +	    unlikely(t->rcu_read_unlock_special))

Hrm I think we discussed this in a past life, but would the following
sequence be possible and correct ?

CPU 0

read t->rcu_read_unlock_special
  interrupt comes in, preempts. sets t->rcu_read_unlock_special
  <preempted>
  <scheduled back>
  iret
decrement and read t->rcu_read_lock_nesting
test both old "special" value (which we have locally on the stack) and
detect that rcu_read_lock_nesting is 0.

We actually missed a reschedule.

I think we might need a barrier() between the t->rcu_read_lock_nesting
and t->rcu_read_unlock_special reads. We might need to audit
TREE PREEMPT RCU for the same kind of behavior.

But I might be (again ?) missing something. I've got the feeling you
already convinced me that this was OK for some reason, but I trip on
this every time I read the code.

[...]

> +/*
> + * Check for a task exiting while in a preemptible -RCU read-side
> + * critical section, clean up if so.  No need to issue warnings,
> + * as debug_check_no_locks_held() already does this if lockdep
> + * is enabled.
> + */
> +void exit_rcu(void)
> +{
> +	struct task_struct *t = current;
> +
> +	if (t->rcu_read_lock_nesting == 0)
> +		return;
> +	t->rcu_read_lock_nesting = 1;
> +	rcu_read_unlock();
> +}
> +

The interaction with preemption is unclear here. exit.c disables
preemption around the call to exit_rcu(), but if, for some reason,
rcu_read_unlock_special was set earlier by preemption, then the
rcu_read_unlock() code might block and cause problems.

Maybe we should consider clearing rcu_read_unlock_special here ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
