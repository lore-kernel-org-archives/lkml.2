Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1K1MmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:42:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:53707 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab1K1MmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:42:11 -0500
Message-ID: <1322484071.2921.115.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 24/28] rcu: Introduce bulk reference
 count
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Date: Mon, 28 Nov 2011 13:41:11 +0100
In-Reply-To: <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
	 <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 13:30 -0700, Paul E. McKenney wrote:
> The RCU implementations, including SRCU, are designed to be used in a
> lock-like fashion, so that the read-side lock and unlock primitives must
> execute in the same context for any given read-side critical section.
> This constraint is enforced by lockdep-RCU.  However, there is a need for
> something that acts more like a reference count than a lock, in order
> to allow (for example) the reference to be acquired within the context
> of an exception, while that same reference is released in the context of
> the task that encountered the exception.  The cost of this capability is
> that the read-side operations incur the overhead of disabling interrupts.
> Some optimization is possible, and will be carried out if warranted.
> 
> Note that although the current implementation allows a given reference to
> be acquired by one task and then released by another, all known possible
> implementations that allow this have scalability problems.  Therefore,
> a given reference must be released by the same task that acquired it,
> though perhaps from an interrupt or exception handler running within
> that task's context.

I'm having trouble with the naming as well as the need for an explicit
new API.

To me this looks like a regular (S)RCU variant, nothing to do with
references per-se (aside from the fact that SRCU is a refcounted rcu
variant). Also WTF is this bulk stuff about? Its still a single ref at a
time, not 10s or 100s or whatnot.

> +static inline int bulkref_get(bulkref_t *brp)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	local_irq_save(flags);
> +	ret =  __srcu_read_lock(brp);
> +	local_irq_restore(flags);
> +	return ret;
> +}
> +
> +static inline void bulkref_put(bulkref_t *brp, int idx)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__srcu_read_unlock(brp, idx);
> +	local_irq_restore(flags);
> +}

This seems to be the main gist of the patch, which to me sounds utterly
ridiculous. Why not document that srcu_read_{un,}lock() aren't IRQ safe
and if you want to use it from those contexts you have to fix it up
yourself.

RCU lockdep doesn't do the full validation so it won't actually catch it
if you mess up the irq states, but I guess if you want we could look at
adding that.

> diff --git a/kernel/srcu.c b/kernel/srcu.c
> index 73ce23f..10214c8 100644
> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -34,13 +34,14 @@
>  #include <linux/delay.h>
>  #include <linux/srcu.h>
>  
> -static int init_srcu_struct_fields(struct srcu_struct *sp)
> +int init_srcu_struct_fields(struct srcu_struct *sp)
>  {
>  	sp->completed = 0;
>  	mutex_init(&sp->mutex);
>  	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
>  	return sp->per_cpu_ref ? 0 : -ENOMEM;
>  }
> +EXPORT_SYMBOL_GPL(init_srcu_struct_fields);

What do we need this export for? Usually we don't add exports unless
there's a use-case. Since Srikar requested this nonsense, I guess the
user is uprobes, but that isn't a module, so no export needed.

