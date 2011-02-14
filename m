Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1BNU4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:56:02 -0500
Received: from www.tglx.de ([62.245.132.106]:50700 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab1BNU4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:56:00 -0500
Date: Mon, 14 Feb 2011 21:55:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Micha Nelissen <micha@neli.hopto.org>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for multiple MSI on x86
In-Reply-To: <4D583E31.4070507@neli.hopto.org>
Message-ID: <alpine.LFD.2.00.1102142106560.26192@localhost6.localdomain6>
References: <4D583E31.4070507@neli.hopto.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Feb 2011, Micha Nelissen wrote:

> Patch is based on earlier patch from Matthew Wilcox.

Please do not attach patches. Send them inline.

> +/*
> + * The P6 family and Pentium processors (presumably also earlier processors),
> + * can queue no more than two interrupts per priority level, and will ignore
> + * other interrupts that are received within the same priority level (the
> + * priority level is the vector number shifted right by 4), so we try to
> + * spread these out a bit to avoid this happening.
> + *
> + * Pentium 4, Xeon and later processors do not have this limitation.
> + * It is unknown what limitations AMD, Cyrix, Transmeta, VIA, IDT and
> + * other manufacturers have.
> + */
> +static int many_vectors_per_prio(void)
> +{
> +	struct cpuinfo_x86 *c;
> +	static char init, result;

  char ? bool if at all. Same for the function itself

  And this should go into one of the alreay existing cpu checks and
  set a software feature flag and not hack another weird instance of
  cpu model checking into the code.

> +	if (init)
> +		return result;
> +
> +	c = &boot_cpu_data;
> +	switch (c->x86_vendor) {
> +	case X86_VENDOR_INTEL:
> +		if (c->x86 > 6 ||
> +		    ((c->x86 == 6) && (c->x86_model >= 13)))
> +			result = 1;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	init = 1;
> +	return result;
> +}
 
> +static int __assign_irq_vector_block(int irq, unsigned count, const struct cpumask *mask)
> +{
> +	static int current_vector = FIRST_EXTERNAL_VECTOR;

static ? What the hell is this for ?

> +	unsigned int old_vector;
> +	unsigned i, cpu;
> +	int err;
> +	struct irq_cfg *cfg;
> +	cpumask_var_t tmp_mask;
> +
> +	BUG_ON(irq + count > NR_IRQS);

Why BUG if you can bail out with an error code ?

> +	BUG_ON(count & (count - 1));

Ditto

> +	for (i = 0; i < count; i++) {
> +		cfg = irq_cfg(irq + i);
> +		if (cfg->move_in_progress)
> +			return -EBUSY;
> +	}

What's this check for and why do we return EBUSY ? 

> +	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
> +		return -ENOMEM;

No way. We went great length to make this code do GFP_KERNEL
allocations.

> +	cfg = irq_cfg(irq);
> +	old_vector = cfg->vector;
> +	if (old_vector) {
> +		err = 0;
> +		cpumask_and(tmp_mask, mask, cpu_online_mask);
> +		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
> +		if (!cpumask_empty(tmp_mask))
> +			goto out;
> +	}
> +
> +	/* Only try and allocate irqs on cpus that are present */
> +	err = -ENOSPC;
> +	for_each_cpu_and(cpu, mask, cpu_online_mask) {

No, we don't want to iterate over the world and some more with
vector_lock held and interrupts disabled

> +		int new_cpu;
> +		int vector;
> +
> +		apic->vector_allocation_domain(cpu, tmp_mask);
> +
> +		vector = current_vector & ~(count - 1);
> +next:
> +		vector > += count;
> +		if (vector > + count >= first_system_vector) {
> +			vector = FIRST_EXTERNAL_VECTOR & ~(count - 1);
> +			if (vector < FIRST_EXTERNAL_VECTOR)
> +				vector > += count;
> +		}
> +		if (unlikely((current_vector & ~(count - 1)) == vector))
> +			continue;
> +
> +		for (i = 0; i < count; i> +> +)
> +			if (test_bit(vector > + i, used_vectors))
> +				goto next;
> +
> +		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask) {
> +			for (i = 0; i < count; i> +> +) {
> +				if (per_cpu(vector_irq, new_cpu)[vector > + i] != -1)
> +					goto next;
> +			}
> +		}

Yikes, loop in a loop ??? With interrupts disabled? Imagine what that
means on a machine with 1k cores.

> +		/* Found one! */
> +		current_vector = vector > + count - 1;
> +		for (i = 0; i < count; i> +> +) {
> +			cfg = irq_cfg(irq > + i);
> +			if (old_vector) {
> +				cfg->move_in_progress = 1;
> +				cpumask_copy(cfg->old_domain, cfg->domain);
> +			}
> +			for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
> +				per_cpu(vector_irq, new_cpu)[vector + i] = irq + i;

And some more .....

> +			cfg->vector = vector > + i;
> +			cpumask_copy(cfg->domain, tmp_mask);
> +		}
> +		err = 0;
> +		break;
> +	}
> +out:
> +	free_cpumask_var(tmp_mask);
> +	return err;
> +}
> +

> +/* Assumes that count is a power of two and aligns to that power of two */

If it assumes that, it'd better check it

> +static int
> +assign_irq_vector_block(int irq, unsigned count, const struct cpumask *mask)

> @@ -2200,14 +2325,34 @@ int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
>  			  unsigned int *dest_id)
>  {
>  	struct irq_cfg *cfg = data->chip_data;
> +	unsigned irq;
>  
>  	if (!cpumask_intersects(mask, cpu_online_mask))
>  		return -1;
>  
> -	if (assign_irq_vector(data->irq, data->chip_data, mask))
> -		return -1;
> +	irq = data->irq;
> +	cfg = data->chip_data;

Assign it again ?
  
> -	cpumask_copy(data->affinity, mask);
> +	if (many_vectors_per_prio()) {
> +		struct msi_desc *msi_desc = data->msi_desc;
> +		unsigned i, count = 1;
> +
> +		if (msi_desc)
> +			count = 1 << msi_desc->msi_attrib.multiple;
> +
> +		/* Multiple MSIs all go to the same destination */
> +		if (assign_irq_vector_block(irq, count, mask))
> +			return -1;
> +		for (i = 0; i < count; i++) {
> +			data = &irq_to_desc(irq + i)->irq_data;
> +			cpumask_copy(data->affinity, mask);
> +		}
> +	} else {
> +		if (assign_irq_vector(irq, cfg, mask))
> +			return BAD_APICID;

So BAD_APICID is equivalent to -1 ?

> +
> +		cpumask_copy(data->affinity, mask);
> +	}
>  
>  	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
>  	return 0;

@@ -3121,7 +3272,7 @@ void destroy_irq(unsigned int irq)
  */
 #ifdef CONFIG_PCI_MSI
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
-			   struct msi_msg *msg, u8 hpet_id)
+			   unsigned count, struct msi_msg *msg, u8 hpet_id)
 {
 	struct irq_cfg *cfg;
 	int err;
@@ -3131,7 +3282,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (count == 1)
+		err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	else
+		err = assign_irq_vector_block(irq, count, apic->target_cpus());

WTF? We have already changed the function to take a count argument,
why don't we propagate that all the way through instead of having 

    if (bla == 1)
        assign_irq_vector();
    else
	assign_irq_vector_block();

all over the place ?

> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index abde252..842a8c4 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -322,7 +322,8 @@ static inline void set_irq_probe(unsigned int irq)
>  }
>  
>  /* Handle dynamic irq creation and destruction */
> -extern unsigned int create_irq_nr(unsigned int irq_want, int node);
> +extern unsigned int create_irq_nr(unsigned int irq_want, unsigned count,
> +				  int node);

And you think that compiles on anything else than with your .config ?

Sigh, this whole thing is total clusterf*ck.

The main horror is definitely not your fault. MSI is just broken.

Though I can understand why you want to implement this, but that does
not work that way at all.

1) Do not change global (non arch specific) interfaces when you do not
   fixup everything in one go. That does not work.

2) Provide a fine grained series of patches, which changes one thing
   each instead of a completely unrewieable monster patch

3) This needs a completely different approach:

   We can't do multivector MSI in a sensible way on x86. So instead of
   trying to fix that for your problem at hand, simply do the
   following:

   Implement a demultiplexing interrupt controller for your device.
   That needs one vector, works out of the box and the demux handler
   looks at the interrupt source and invokes the sub handlers via
   generic_handle_irq(irq_sub_source). You get all the usual stuff
   /proc/interrupts, separate request_irq() .....

Thanks,

	tglx
