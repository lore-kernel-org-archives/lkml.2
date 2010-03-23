Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0CWQle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:41:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51042 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab0CWQlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:41:32 -0400
Date: Tue, 23 Mar 2010 09:41:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Anton Blanchard <anton@samba.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Milton Miller <miltonm@bga.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smp_call_function_many SMP race
Message-ID: <20100323164124.GN2517@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100323111556.GK24064@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323111556.GK24064@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 10:15:56PM +1100, Anton Blanchard wrote:
> 
> I noticed a failure where we hit the following WARN_ON in
> generic_smp_call_function_interrupt:
> 
>                 if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
>                         continue;
> 
>                 data->csd.func(data->csd.info);
> 
>                 refs = atomic_dec_return(&data->refs);
>                 WARN_ON(refs < 0);      <-------------------------
> 
> We atomically tested and cleared our bit in the cpumask, and yet the number
> of cpus left (ie refs) was 0. How can this be?
> 
> It turns out commit c0f68c2fab4898bcc4671a8fb941f428856b4ad5 (generic-ipi:
> cleanup for generic_smp_call_function_interrupt()) is at fault. It removes
> locking from smp_call_function_many and in doing so creates a rather
> complicated race.
> 
> The problem comes about because:
> 
> - The smp_call_function_many interrupt handler walks call_function.queue
>   without any locking.
> - We reuse a percpu data structure in smp_call_function_many.
> - We do not wait for any RCU grace period before starting the next
>   smp_call_function_many.
> 
> Imagine a scenario where CPU A does two smp_call_functions back to back, and
> CPU B does an smp_call_function in between. We concentrate on how CPU C handles
> the calls:
> 
> 
> CPU A                  CPU B                  CPU C
> 
> smp_call_function
>                                               smp_call_function_interrupt
>                                                 walks call_function.queue
>                                                 sees CPU A on list
> 
>                          smp_call_function
> 
>                                               smp_call_function_interrupt
>                                                 walks call_function.queue
>                                                 sees (stale) CPU A on list
> smp_call_function
>   reuses percpu *data
>   set data->cpumask
>                                                 sees and clears bit in cpumask!
>                                                 sees data->refs is 0!
> 
>   set data->refs (too late!)
> 
> 
> The important thing to note is since the interrupt handler walks a potentially
> stale call_function.queue without any locking, then another cpu can view the
> percpu *data structure at any time, even when the owner is in the process
> of initialising it.
> 
> The following test case hits the WARN_ON 100% of the time on my PowerPC box
> (having 128 threads does help :)
> 
> 
> #include <linux/module.h>
> #include <linux/init.h>
> 
> #define ITERATIONS 100
> 
> static void do_nothing_ipi(void *dummy)
> {
> }
> 
> static void do_ipis(struct work_struct *dummy)
> {
> 	int i;
> 
> 	for (i = 0; i < ITERATIONS; i++)
> 		smp_call_function(do_nothing_ipi, NULL, 1);
> 
> 	printk(KERN_DEBUG "cpu %d finished\n", smp_processor_id());
> }
> 
> static struct work_struct work[NR_CPUS];
> 
> static int __init testcase_init(void)
> {
> 	int cpu;
> 
> 	for_each_online_cpu(cpu) {
> 		INIT_WORK(&work[cpu], do_ipis);
> 		schedule_work_on(cpu, &work[cpu]);
> 	}
> 
> 	return 0;
> }
> 
> static void __exit testcase_exit(void)
> {
> }
> 
> module_init(testcase_init)
> module_exit(testcase_exit)
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Anton Blanchard");
> 
> 
> I tried to fix it by ordering the read and the write of ->cpumask and ->refs.
> In doing so I missed a critical case but Paul McKenney was able to spot
> my bug thankfully :) To ensure we arent viewing previous iterations the
> interrupt handler needs to read ->refs then ->cpumask then ->refs _again_.
> 
> Thanks to Milton Miller and Paul McKenney for helping to debug this issue.
> 
> ---
> 
> My head hurts. This needs some serious analysis before we can be sure it
> fixes all the races. With all these memory barriers, maybe the previous
> spinlocks weren't so bad after all :)

;-)

Does this patch appear to have fixed things, or do you still have a
failure rate?  In other words, should I be working on a proof of
(in)correctness, or should I be looking for further bugs?

							Thanx, Paul

> Index: linux-2.6/kernel/smp.c
> ===================================================================
> --- linux-2.6.orig/kernel/smp.c	2010-03-23 05:09:08.000000000 -0500
> +++ linux-2.6/kernel/smp.c	2010-03-23 06:12:40.000000000 -0500
> @@ -193,6 +193,31 @@ void generic_smp_call_function_interrupt
>  	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
>  		int refs;
> 
> +		/*
> +		 * Since we walk the list without any locks, we might
> +		 * see an entry that was completed, removed from the
> +		 * list and is in the process of being reused.
> +		 *
> +		 * Just checking data->refs then data->cpumask is not good
> +		 * enough because we could see a non zero data->refs from a
> +		 * previous iteration. We need to check data->refs, then
> +		 * data->cpumask then data->refs again. Talk about
> +		 * complicated!
> +		 */
> +
> +		if (atomic_read(&data->refs) == 0)
> +			continue;
> +
> +		smp_rmb();
> +
> +		if (!cpumask_test_cpu(cpu, data->cpumask))
> +			continue;
> +
> +		smp_rmb();
> +
> +		if (atomic_read(&data->refs) == 0)
> +			continue;
> +
>  		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
>  			continue;
> 
> @@ -446,6 +471,14 @@ void smp_call_function_many(const struct
>  	data->csd.info = info;
>  	cpumask_and(data->cpumask, mask, cpu_online_mask);
>  	cpumask_clear_cpu(this_cpu, data->cpumask);
> +
> +	/*
> +	 * To ensure the interrupt handler gets an up to date view
> +	 * we order the cpumask and refs writes and order the
> +	 * read of them in the interrupt handler.
> +	 */
> +	smp_wmb();
> +
>  	atomic_set(&data->refs, cpumask_weight(data->cpumask));
> 
>  	raw_spin_lock_irqsave(&call_function.lock, flags);
