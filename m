Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab0LJKzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:55:25 -0500
Received: from www.tglx.de ([62.245.132.106]:37791 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab0LJKzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:55:22 -0500
Date: Fri, 10 Dec 2010 11:55:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arthur Kepner <akepner@sgi.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/irq: assign vectors from numa_node
In-Reply-To: <20101203205348.GI20481@sgi.com>
Message-ID: <alpine.LFD.2.00.1012101051290.2653@localhost6.localdomain6>
References: <20101203205348.GI20481@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010, Arthur Kepner wrote:
> 
> Several drivers (e.g., mlx4_core) do something similar to:
> 
> 	err = pci_enable_msix(pdev, entries, num_possible_cpus());

Which is the main problem and this patch just addresses the
symptoms. As Eric pointed out earlier, this needs to be solved
differently.

There is absolutely no point assigning 4096 interrupts to a single
node in the first place. Especially not, if we end up using only a few
of them in the end. And those you use are not necessarily on that very
node.

I understand, that you want to work around your problem at hand, but
I'm pushing back on it, as it's a crappy solution which just ignores
the underlying problem. You don't even mention it in your changelog
that this is a work around and not a solution.

No, you just ignore that fact and the requests to look at the
underlying problem.

> which takes us down this code path:
> 
> 	pci_enable_msix
> 	native_setup_msi_irqs
> 	create_irq_nr
> 	__assign_irq_vector
> 
> __assign_irq_vector() preferentially uses vectors from low-numbered 
> CPUs. On a system with a large number (>256) CPUs this can result in 
> a CPU running out of vectors, and subsequent attempts to assign an 
> interrupt to that CPU will fail.

I agree, that __assign_irq_vector() should honour the request for a
node, but I don't agree, that we should magically spread stuff on
whatever node we find, when the node ran out of vectors.

There is probably a reason, why you want an interrupt on a specific
node and just silently pushing it somewhere else feels very wrong.

This needs to be solved from ground up with proper rules about failure
modes and fallback decisions.

> +static int
> +__assign_irq_vector_node(int irq, struct irq_cfg *cfg,
> +			 const struct cpumask *mask, int node)
> +{
> +	int err = -EAGAIN;
> +	int cpu, best_cpu = -1, min_vector_count = NR_VECTORS;
> +
> +	for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
> +		/* find the 'best' CPU to take this vector -
> +		 * the one with the fewest assigned vectors is
> +		 * considered 'best' */
> +		int i, vector_count = 0;
> +
> +		if (!cpu_online(cpu))
> +			continue;
> +
> +		for (i = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
> +		     i < NR_VECTORS ; i++)
> +			if (per_cpu(vector_irq, cpu)[i] != -1)
> +				vector_count++;

Instead of having proper book keeping of vectors, we loop through nvec
* ncpus to figure that out ? And of course we run that loop with
interrupts disabled and vector lock held.

> +		if (vector_count < min_vector_count) {
> +			min_vector_count = vector_count;
> +			best_cpu = cpu;
> +		}
> +	}
> +
> +	if (best_cpu >= 0) {
> +		cpumask_var_t tmp_mask;
> +
> +		if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))

Bah. I made create_irq_nr() atomic region small with lots of effort
and got rid of all GFP_ATOMIC allocations.

> +			return -ENOMEM;
> +
> +		cpumask_clear(tmp_mask);
> +		cpumask_set_cpu(best_cpu, tmp_mask);
> +		err = __assign_irq_vector(irq, cfg, tmp_mask);
> +
> +		free_cpumask_var(tmp_mask);
> +	}
> +
> +	return err;
> +}
> +
>  int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  {
>  	int err;
> @@ -1128,6 +1171,39 @@ int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  	return err;
>  }
>  
> +static int
> +assign_irq_vector_node(int irq, struct irq_cfg *cfg,
> +		       const struct cpumask *mask, int node)
> +{
> +	int err;
> +	unsigned long flags;
> +
> +	if (node == NUMA_NO_NODE)
> +		return assign_irq_vector(irq, cfg, mask);
> +
> +	raw_spin_lock_irqsave(&vector_lock, flags);
> +	err = __assign_irq_vector_node(irq, cfg, mask, node);
> +	raw_spin_unlock_irqrestore(&vector_lock, flags);
> +
> +	if (err != 0)
> +		/* uh oh - try again w/o specifying a node */
> +		return assign_irq_vector(irq, cfg, mask);
> +	else {
> +		/* and set the affinity mask so that only
> +		 * CPUs on 'node' will be used */
> +		struct irq_desc *desc = irq_to_desc(irq);
> +		unsigned long flags;
> +
> +		raw_spin_lock_irqsave(&desc->lock, flags);
> +		cpumask_and(desc->irq_data.affinity, cpu_online_mask,
> +			    cpumask_of_node(node));

Which leaves us with an empty affinity mask, when the last cpu of that
node just went offline before locking desc->lock. Brilliant.

> +		desc->status |= IRQ_AFFINITY_SET;
> +		raw_spin_unlock_irqrestore(&desc->lock, flags);

Aside of that low level arch code is not supposed to fiddle in
irq_desc at will excatly for such reasons. 

As you might have noticed, i'm working on removing access to irq_desc
from random places and I spent quite some effort to clean up the whole
irq mess. No way to put crap like this in again, so I can twist my
brain around it next week how to clean it up.

Thanks,

	tglx
