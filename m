Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1CPHvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 03:51:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:49869 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1CPHvb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:15:1>);
	Wed, 16 Mar 2011 03:51:31 -0400
Message-Id: <4D807A430200007800036BDF@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 16 Mar 2011 07:52:19 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Milton Miller" <miltonm@bga.com>
Cc: <xiaoguangrong@cn.fujitsu.com>, <mingo@elte.hu>, <jaxboe@fusionio.com>,
        <npiggin@gmail.com>, "Mike Galbraith" <efault@gmx.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Tony Luck" <tony.luck@intel.com>, <benh@kernel.crashing.org>,
        <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
        <paulmck@linux.vnet.ibm.com>, <rusty@rustcorp.com.au>,
        "Anton Blanchard" <anton@samba.org>,
        "Dimitri Sivanich" <sivanich@sgi.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4 v3] smp_call_function_many: handle concurrent
	 clearing of mask
References: <20110112150740.77dde58c@kryten>
 <1295288253.30950.280.camel@laptop>
 <smp-call-function-peter-reply@mdm.bga.com>
 <smp-call-function-move-writes@mdm.bga.com>
 <1296145360.15234.234.camel@laptop>
 <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com>
 <1296458482.7889.175.camel@marge.simson.net> <ipi-list-reply@mdm.bga.com>
 <smp-ipi-mask-clear-race-v3@mdm.bga.com>
In-Reply-To: <smp-ipi-mask-clear-race-v3@mdm.bga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.03.11 at 20:27, Milton Miller <miltonm@bga.com> wrote:
> Mike Galbraith reported finding a lockup ("perma-spin bug") where the
> cpumask passed to smp_call_function_many was cleared by other cpu(s)
> while a cpu was preparing its call_data block, resulting in no cpu to
> clear the last ref and unlock the block.
> 
> Having cpus clear their bit asynchronously could be useful on a mask of
> cpus that might have a translation context, or cpus that need a push to
> complete an rcu window.
> 
> Instead of adding a BUG_ON and requiring yet another cpumask copy, just
> detect the race and handle it.
> 
> Note: arch_send_call_function_ipi_mask must still handle an empty
> cpumask because the data block is globally visible before the that
> arch callback is made.  And (obviously) there are no guarantees to
> which cpus are notified if the mask is changed during the call;
> only cpus that were online and had their mask bit set during the
> whole call are guaranteed to be called.
> 
> Reported-by: Mike Galbraith <efault@gmx.de>
> Reported-by: Jan Beulich <JBeulich@novell.com>
> Signed-off-by: Milton Miller <miltonm@bga.com>

Acked-by: Jan Beulich <jbeulich@novell.com>

> ---
> v3: try to clarify which mask in comment
> v2: rediff for v2 of call_function_many: fix list delete vs add race
> 
> The arch code not expecting the race to empty the mask is the cause
> of https://bugzilla.kernel.org/show_bug.cgi?id=23042 that Andrew pointed
> out.
> 
> 
> Index: common/kernel/smp.c
> ===================================================================
> --- common.orig/kernel/smp.c	2011-03-15 05:22:26.000000000 -0500
> +++ common/kernel/smp.c	2011-03-15 06:22:26.000000000 -0500
> @@ -450,7 +450,7 @@ void smp_call_function_many(const struct
>  {
>  	struct call_function_data *data;
>  	unsigned long flags;
> -	int cpu, next_cpu, this_cpu = smp_processor_id();
> +	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
>  
>  	/*
>  	 * Can deadlock when called with interrupts disabled.
> @@ -461,7 +461,7 @@ void smp_call_function_many(const struct
>  	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>  		     && !oops_in_progress && !early_boot_irqs_disabled);
>  
> -	/* So, what's a CPU they want? Ignoring this one. */
> +	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
>  	cpu = cpumask_first_and(mask, cpu_online_mask);
>  	if (cpu == this_cpu)
>  		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
> @@ -519,6 +519,13 @@ void smp_call_function_many(const struct
>  	/* We rely on the "and" being processed before the store */
>  	cpumask_and(data->cpumask, mask, cpu_online_mask);
>  	cpumask_clear_cpu(this_cpu, data->cpumask);
> +	refs = cpumask_weight(data->cpumask);
> +
> +	/* Some callers race with other cpus changing the passed mask */
> +	if (unlikely(!refs)) {
> +		csd_unlock(&data->csd);
> +		return;
> +	}
>  
>  	raw_spin_lock_irqsave(&call_function.lock, flags);
>  	/*
> @@ -532,7 +539,7 @@ void smp_call_function_many(const struct
>  	 * to the cpumask before this write to refs, which indicates
>  	 * data is on the list and is ready to be processed.
>  	 */
> -	atomic_set(&data->refs, cpumask_weight(data->cpumask));
> +	atomic_set(&data->refs, refs);
>  	raw_spin_unlock_irqrestore(&call_function.lock, flags);
>  
>  	/*



