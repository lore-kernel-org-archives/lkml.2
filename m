Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1A0QWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:22:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1A0QWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:22:07 -0500
Subject: Re: [PATCH 2/2] consolidate writes in smp_call_funtion_interrupt
From: Peter Zijlstra <peterz@infradead.org>
To: Milton Miller <miltonm@bga.com>
Cc: Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org
In-Reply-To: <smp-call-function-move-writes@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 17:22:40 +0100
Message-ID: <1296145360.15234.234.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 15:06 -0600, Milton Miller wrote:

> Index: common/kernel/smp.c
> ===================================================================
> --- common.orig/kernel/smp.c	2011-01-17 20:16:18.000000000 -0600
> +++ common/kernel/smp.c	2011-01-17 20:17:50.000000000 -0600
> @@ -193,6 +193,7 @@ void generic_smp_call_function_interrupt
>  	 */
>  	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
>  		int refs;
> +		void (*func) (void *info);
>  
>  		/*
>  		 * Since we walk the list without any locks, we might
> @@ -212,24 +213,32 @@ void generic_smp_call_function_interrupt
>  		if (atomic_read(&data->refs) == 0)
>  			continue;
>  
> +		func = data->csd.func;			/* for later warn */
>  		data->csd.func(data->csd.info);
>  
> +		/*
> +		 * If the cpu mask is not still set then it enabled interrupts,
> +		 * we took another smp interrupt, and executed the function
> +		 * twice on this cpu.  In theory that copy decremented refs.
> +		 */
> +		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask)) {
> +			WARN(1, "%pS enabled interrupts and double executed\n",
> +			     func);
> +			continue;
> +		}
> +
>  		refs = atomic_dec_return(&data->refs);
>  		WARN_ON(refs < 0);
>  
>  		if (refs)
>  			continue;
>  
> +		WARN_ON(!cpumask_empty(data->cpumask));
> +
> +		raw_spin_lock(&call_function.lock);
> +		list_del_rcu(&data->csd.list);
> +		raw_spin_unlock(&call_function.lock);
> +
>  		csd_unlock(&data->csd);
>  	}
>  


So after this we have:

list_for_each_entry_rcu()
rbd
  !->cpumask			  ->cpumask = 
rmb				wmb
  !->refs			  ->refs =
  ->func()			wmb
mb				  list_add_rcu()
  ->refs--
  if (!->refs)
    list_del_rcu()

So even if we see it as an old-ref, when we see a valid cpumask, valid
ref, we execute the function clear our cpumask bit and decrement the ref
and delete the entry, even though it might not yet be added?


(old-ref)
				->cpumask =
  if (!->cpumask)
				->refs = 
  if (!->refs)

  ->func()
  ->refs--
  if (!->refs)
    list_del_rcu()
				list_add_rcu()

Then what happens?
