Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab0ECOYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 10:24:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:42310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab0ECOYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 10:24:14 -0400
Subject: Re: [PATCH] smp_call_function_many SMP race
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       paulmck@linux.vnet.ibm.com, Milton Miller <miltonm@bga.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100323111556.GK24064@kryten>
References: <20100323111556.GK24064@kryten>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 16:24:08 +0200
Message-ID: <1272896648.1642.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 22:15 +1100, Anton Blanchard wrote:
> 
> My head hurts. This needs some serious analysis before we can be sure it
> fixes all the races. With all these memory barriers, maybe the previous
> spinlocks weren't so bad after all :)
> 
> 
> Index: linux-2.6/kernel/smp.c
> ===================================================================
> --- linux-2.6.orig/kernel/smp.c 2010-03-23 05:09:08.000000000 -0500
> +++ linux-2.6/kernel/smp.c      2010-03-23 06:12:40.000000000 -0500
> @@ -193,6 +193,31 @@ void generic_smp_call_function_interrupt
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

But the atomic_dec_return() implies a mb, which is before
list_del_rcu(), also, the next enqueue will have a wmb in
list_rcu_add(), so it seems to me that if we issue an rmb it would be
impossible to see a !zero ref of the previous enlisting.

> +               if (atomic_read(&data->refs) == 0)
> +                       continue;
> +
> +               smp_rmb();
> +
> +               if (!cpumask_test_cpu(cpu, data->cpumask))
> +                       continue;
> +
> +               smp_rmb();
> +
> +               if (atomic_read(&data->refs) == 0)
> +                       continue;
> +
>                 if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
>                         continue;
>  
> @@ -446,6 +471,14 @@ void smp_call_function_many(const struct
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

We could make this an actual atomic instruction of course..

>         raw_spin_lock_irqsave(&call_function.lock, flags);
> 
> 


