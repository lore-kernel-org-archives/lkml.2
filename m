Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab1FQRMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:12:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58269 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab1FQRM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:12:28 -0400
Date: Fri, 17 Jun 2011 11:12:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Micha Nelissen <micha@neli.hopto.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] Add support for multiple MSI on x86
Message-ID: <20110617171226.GB19693@parisc-linux.org>
References: <4D583E31.4070507@neli.hopto.org> <alpine.LFD.2.00.1102142106560.26192@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102142106560.26192@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, I missed this the first time through ... I've just been poked about it.

On Mon, Feb 14, 2011 at 09:55:33PM +0100, Thomas Gleixner wrote:
> On Sun, 13 Feb 2011, Micha Nelissen wrote:
> > +static int __assign_irq_vector_block(int irq, unsigned count, const struct cpumask *mask)
> > +{
> > +	static int current_vector = FIRST_EXTERNAL_VECTOR;
> 
> static ? What the hell is this for ?

You should probably have taken a look at __assign_irq_vector before
jumping in with the 'wth's.  It's heavily based on that.

> > +	unsigned int old_vector;
> > +	unsigned i, cpu;
> > +	int err;
> > +	struct irq_cfg *cfg;
> > +	cpumask_var_t tmp_mask;
> > +
> > +	BUG_ON(irq + count > NR_IRQS);
> 
> Why BUG if you can bail out with an error code ?
> 
> > +	BUG_ON(count & (count - 1));
> 
> Ditto

These should both have been taken care of by the caller.  So they are
genuine bugs if they happen.

> > +	for (i = 0; i < count; i++) {
> > +		cfg = irq_cfg(irq + i);
> > +		if (cfg->move_in_progress)
> > +			return -EBUSY;
> > +	}
> 
> What's this check for and why do we return EBUSY ? 

Ask the author of __assign_irq_vector

> > +	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
> > +		return -ENOMEM;
> 
> No way. We went great length to make this code do GFP_KERNEL
> allocations.

No.  No, you didn't.  Fix __assign_irq_vector, and we can talk.

> > +	cfg = irq_cfg(irq);
> > +	old_vector = cfg->vector;
> > +	if (old_vector) {
> > +		err = 0;
> > +		cpumask_and(tmp_mask, mask, cpu_online_mask);
> > +		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
> > +		if (!cpumask_empty(tmp_mask))
> > +			goto out;
> > +	}
> > +
> > +	/* Only try and allocate irqs on cpus that are present */
> > +	err = -ENOSPC;
> > +	for_each_cpu_and(cpu, mask, cpu_online_mask) {
> 
> No, we don't want to iterate over the world and some more with
> vector_lock held and interrupts disabled

... see __assign_irq_vector again.

> > +		int new_cpu;
> > +		int vector;
> > +
> > +		apic->vector_allocation_domain(cpu, tmp_mask);
> > +
> > +		vector = current_vector & ~(count - 1);
> > +next:
> > +		vector > += count;
> > +		if (vector > + count >= first_system_vector) {
> > +			vector = FIRST_EXTERNAL_VECTOR & ~(count - 1);
> > +			if (vector < FIRST_EXTERNAL_VECTOR)
> > +				vector > += count;
> > +		}
> > +		if (unlikely((current_vector & ~(count - 1)) == vector))
> > +			continue;
> > +
> > +		for (i = 0; i < count; i> +> +)
> > +			if (test_bit(vector > + i, used_vectors))
> > +				goto next;
> > +
> > +		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask) {
> > +			for (i = 0; i < count; i> +> +) {
> > +				if (per_cpu(vector_irq, new_cpu)[vector > + i] != -1)
> > +					goto next;
> > +			}
> > +		}
> 
> Yikes, loop in a loop ??? With interrupts disabled? Imagine what that
> means on a machine with 1k cores.

It's a very short inner loop.  MSI is limited to 32 interrupts.

> > +		/* Found one! */
> > +		current_vector = vector > + count - 1;
> > +		for (i = 0; i < count; i> +> +) {
> > +			cfg = irq_cfg(irq > + i);
> > +			if (old_vector) {
> > +				cfg->move_in_progress = 1;
> > +				cpumask_copy(cfg->old_domain, cfg->domain);
> > +			}
> > +			for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
> > +				per_cpu(vector_irq, new_cpu)[vector + i] = irq + i;
> 
> And some more .....
> 
> > +			cfg->vector = vector > + i;
> > +			cpumask_copy(cfg->domain, tmp_mask);
> > +		}
> > +		err = 0;
> > +		break;
> > +	}
> > +out:
> > +	free_cpumask_var(tmp_mask);
> > +	return err;
> > +}
> > +
> 
> > +/* Assumes that count is a power of two and aligns to that power of two */
> 
> If it assumes that, it'd better check it

Um ... see the BUG_ON above that you complained about ...

> @@ -3121,7 +3272,7 @@ void destroy_irq(unsigned int irq)
>   */
>  #ifdef CONFIG_PCI_MSI
>  static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
> -			   struct msi_msg *msg, u8 hpet_id)
> +			   unsigned count, struct msi_msg *msg, u8 hpet_id)
>  {
>  	struct irq_cfg *cfg;
>  	int err;
> @@ -3131,7 +3282,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
>  		return -ENXIO;
>  
>  	cfg = irq_cfg(irq);
> -	err = assign_irq_vector(irq, cfg, apic->target_cpus());
> +	if (count == 1)
> +		err = assign_irq_vector(irq, cfg, apic->target_cpus());
> +	else
> +		err = assign_irq_vector_block(irq, count, apic->target_cpus());
> 
> WTF? We have already changed the function to take a count argument,
> why don't we propagate that all the way through instead of having 
> 
>     if (bla == 1)
>         assign_irq_vector();
>     else
> 	assign_irq_vector_block();
> 
> all over the place ?

assign_irq_vector() has a different allocation scheme from
assign_irq_vector_block().  Merging the two functions seems hard ... but
maybe we can have separate __assign_irq_block() and __assign_irq_vector()
and have assign_irq_vector() call the appropriate one?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
