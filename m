Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1AQSRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:17:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:44351 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1AQSRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:17:32 -0500
Subject: RE: [PATCH] smp_call_function_many SMP race
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        miltonm@bga.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110112150740.77dde58c@kryten>
References: <20110112150740.77dde58c@kryten>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 19:17:33 +0100
Message-ID: <1295288253.30950.280.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 15:07 +1100, Anton Blanchard wrote:

> I managed to forget all about this bug, probably because of how much it
> makes my brain hurt.

Agreed.


> I tried to fix it by ordering the read and the write of ->cpumask and
> ->refs. In doing so I missed a critical case but Paul McKenney was able
> to spot my bug thankfully :) To ensure we arent viewing previous
> iterations the interrupt handler needs to read ->refs then ->cpumask
> then ->refs _again_.

> ---
> 
> Index: linux-2.6/kernel/smp.c
> ===================================================================
> --- linux-2.6.orig/kernel/smp.c 2010-12-22 17:19:11.262835785 +1100
> +++ linux-2.6/kernel/smp.c      2011-01-12 15:03:08.793324402 +1100
> @@ -194,6 +194,31 @@ void generic_smp_call_function_interrupt
>         list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
>                 int refs;
>  
> +               /*
> +                * Since we walk the list without any locks, we might
> +                * see an entry that was completed, removed from the
> +                * list and is in the process of being reused.
> +                *
> +                * Just checking data->refs then data->cpumask is not good
> +                * enough because we could see a non zero data->refs from a
> +                * previous iteration. We need to check data->refs, then
> +                * data->cpumask then data->refs again. Talk about
> +                * complicated!
> +                */
> +
> +               if (atomic_read(&data->refs) == 0)
> +                       continue;
> +

So here we might see the old ref

> +               smp_rmb();
> +
> +               if (!cpumask_test_cpu(cpu, data->cpumask))
> +                       continue;

Here we might see the new cpumask

> +               smp_rmb();
> +
> +               if (atomic_read(&data->refs) == 0)
> +                       continue;
> +

But then still see a 0 ref, at which point we skip this entry and rely
on the fact that arch_send_call_function_ipi_mask() will simply latch
our IPI line and cause a back-to-back IPI such that we can process the
data on the second go-round?

>                 if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
>                         continue;

And finally, once we observe a valid ->refs, do we test the ->cpumask
again so we cross with the store order (->cpumask first, then ->refs).

> @@ -458,6 +483,14 @@ void smp_call_function_many(const struct
>         data->csd.info = info;
>         cpumask_and(data->cpumask, mask, cpu_online_mask);
>         cpumask_clear_cpu(this_cpu, data->cpumask);
> +
> +       /*
> +        * To ensure the interrupt handler gets an up to date view
> +        * we order the cpumask and refs writes and order the
> +        * read of them in the interrupt handler.
> +        */
> +       smp_wmb();
> +
>         atomic_set(&data->refs, cpumask_weight(data->cpumask));
>  
>         raw_spin_lock_irqsave(&call_function.lock, flags); 

Read side:			Write side:

list_for_each_rcu()
  !->refs, continue		  ->cpumask = 
rmb				wmb
  !->cpumask, continue		  ->refs = 
rmb				wmb
  !->refs, continue		  list_add_rcu()
mb
  !->cpumask, continue



Wouldn't something like:

list_for_each_rcu()
  !->cpumask, continue		  ->refs =
rmb				wmb
  !->refs, continue		  ->cpumask =
mb				wmb
  !->cpumask, continue		  list_add_rcu()


Suffice? There we can observe the old ->cpumask, new ->refs and new
->cpumask in crossed order, so we filter out the old, and cross the new,
and have one rmb and conditional less.

Or am I totally missing something here,.. like said, this stuff hurts
brains.
