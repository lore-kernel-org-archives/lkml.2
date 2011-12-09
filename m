Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1LILpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:45:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41889 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab1LILpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:45:40 -0500
Message-ID: <4EE1F4E0.30708@monstr.eu>
Date: Fri, 09 Dec 2011 12:45:36 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: John Linn <John.Linn@xilinx.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ingo Molnar <mingo@elte.hu>,
        Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [RFC PATCH] microblaze/irq: Change NO_IRQ to 0
References: <4EDEE2B2.7080606@gmail.com> <1323268911-6104-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1323268911-6104-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Herring wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> As has been discussed many times[1], Using NO_IRQ set to anything other
> than 0 is bug waiting to happen since many drivers follow the pattern
> "if (!irq)" for testing whether or not an irq has been set.
> 
> This patch changes the Microblaze NO_IRQ setting from -1 to 0 to bring
> it in line with most of the rest of the kernel.  It also prepares for
> Microblaze eventually supporting multiple interrupt controllers by
> breaking the assumption that hwirq# == Linux IRQ#.  The Linux IRQ
> number is just a cookie with no guarantee of a direct relationship
> with the hardware irq arrangement.
> 
> At this point, Microblaze interrupt handling only supports only one
> instance of one kind of interrupt controller (xilinx_intc).  This change
> shouldn't affect any architecture code outside of the interrupt
> controller driver and the irq_of mapping.
> 
> Updated to 3.2 and to use irq_data.hwirq by Rob Herring.
> 
> Completely untested.
> 
> [1] http://lkml.org/lkml/2005/11/21/221
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
> 
> The main complaint with the prior version was Michal's complaint about the
> +1 / -1 conversion in every function. This is now solved with the use of
> irq_data.hwirq to store the h/w irq numbers.
> 
> I also fixed some errors around nr_irq.

I have looked at your patch and fix some things.

> 
> Rob
> 
>  arch/microblaze/include/asm/irq.h |    4 ++--
>  arch/microblaze/kernel/intc.c     |   18 ++++++++++--------
>  arch/microblaze/kernel/irq.c      |   10 ++++++----
>  3 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
> index cc54187..b07c179 100644
> --- a/arch/microblaze/include/asm/irq.h
> +++ b/arch/microblaze/include/asm/irq.h
> @@ -9,7 +9,7 @@
>  #ifndef _ASM_MICROBLAZE_IRQ_H
>  #define _ASM_MICROBLAZE_IRQ_H
>  
> -#define NR_IRQS 32
> +#define NR_IRQS (32 + 1)	/* Add 1 to skip over IRQ0 */
>  #include <asm-generic/irq.h>
>  
>  /* This type is the placeholder for a hardware interrupt number. It has to
> @@ -20,7 +20,7 @@ typedef unsigned long irq_hw_number_t;
>  
>  extern unsigned int nr_irq;
>  
> -#define NO_IRQ (-1)
> +#define NO_IRQ 0
>  
>  struct pt_regs;
>  extern void do_IRQ(struct pt_regs *regs);
> diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
> index eb41441..ed65aac 100644
> --- a/arch/microblaze/kernel/intc.c
> +++ b/arch/microblaze/kernel/intc.c
> @@ -42,7 +42,7 @@ unsigned int nr_irq;
>  
>  static void intc_enable_or_unmask(struct irq_data *d)
>  {
> -	unsigned long mask = 1 << d->irq;
> +	unsigned long mask = 1 << d->hwirq;
>  	pr_debug("enable_or_unmask: %d\n", d->irq);
>  	out_be32(INTC_BASE + SIE, mask);
>  
> @@ -57,18 +57,18 @@ static void intc_enable_or_unmask(struct irq_data *d)
>  static void intc_disable_or_mask(struct irq_data *d)
>  {
>  	pr_debug("disable: %d\n", d->irq);
> -	out_be32(INTC_BASE + CIE, 1 << d->irq);
> +	out_be32(INTC_BASE + CIE, 1 << d->hwirq);
>  }
>  
>  static void intc_ack(struct irq_data *d)
>  {
>  	pr_debug("ack: %d\n", d->irq);
> -	out_be32(INTC_BASE + IAR, 1 << d->irq);
> +	out_be32(INTC_BASE + IAR, 1 << d->hwirq);
>  }
>  
>  static void intc_mask_ack(struct irq_data *d)
>  {
> -	unsigned long mask = 1 << d->irq;
> +	unsigned long mask = 1 << d->hwirq;
>  	pr_debug("disable_and_ack: %d\n", d->irq);
>  	out_be32(INTC_BASE + CIE, mask);
>  	out_be32(INTC_BASE + IAR, mask);
> @@ -90,8 +90,11 @@ unsigned int get_irq(struct pt_regs *regs)
>  	 * NOTE: This function is the one that needs to be improved in
>  	 * order to handle multiple interrupt controllers. It currently
>  	 * is hardcoded to check for interrupts only on the first INTC.
> +	 *
> +	 * Linux IRQ# is currently offset by one to map to the hardware
> +	 * irq number.  So hardware IRQ0 maps to Linux irq 1.
>  	 */
> -	irq = in_be32(INTC_BASE + IVR);
> +	irq = in_be32(INTC_BASE + IVR) + 1;
>  	pr_debug("get_irq: %d\n", irq);
>  
>  	return irq;
> @@ -134,8 +137,6 @@ void __init init_IRQ(void)
>  	intr_type =
>  		be32_to_cpup(of_get_property(intc,
>  						"xlnx,kind-of-intr", NULL));
> -	if (intr_type > (u32)((1ULL << nr_irq) - 1))
> -		printk(KERN_INFO " ERROR: Mismatch in kind-of-intr param\n");

This is necessary to keep it because some older versions had a bug.
It is just checking mechanism and not NO_IRQ related change.

>  
>  #ifdef CONFIG_SELFMOD_INTC
>  	selfmod_function((int *) arr_func, intc_baseaddr);
> @@ -155,7 +156,7 @@ void __init init_IRQ(void)
>  	/* Turn on the Master Enable. */
>  	out_be32(intc_baseaddr + MER, MER_HIE | MER_ME);
>  
> -	for (i = 0; i < nr_irq; ++i) {
> +	for (i = 1; i < nr_irq; ++i) {
>  		if (intr_type & (0x00000001 << i)) {

intr_type should be called intr_mask because it is used as mask.
Which means that this should be (i - 1) because of shift.

>  			irq_set_chip_and_handler_name(i, &intc_dev,
>  				handle_edge_irq, "edge");
> @@ -165,5 +166,6 @@ void __init init_IRQ(void)
>  				handle_level_irq, "level");
>  			irq_set_status_flags(i, IRQ_LEVEL);
>  		}
> +		irq_get_irq_data(i)->hwirq = i - 1;
>  	}
>  }
> diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
> index e5d63a8..ac1b463 100644
> --- a/arch/microblaze/kernel/irq.c
> +++ b/arch/microblaze/kernel/irq.c
> @@ -33,11 +33,11 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
>  	irq_enter();
>  	irq = get_irq(regs);
>  next_irq:
> -	BUG_ON(irq == -1U);
> +	BUG_ON(!irq);
>  	generic_handle_irq(irq);
>  
>  	irq = get_irq(regs);
> -	if (irq != -1U) {
> +	if (irq) {
>  		pr_debug("next irq: %d\n", irq);
>  		++concurrent_irq;
>  		goto next_irq;
> @@ -52,13 +52,15 @@ next_irq:
>    intc without any cascades or any connection that's why mapping is 1:1 */
>  unsigned int irq_create_mapping(struct irq_host *host, irq_hw_number_t hwirq)
>  {
> -	return hwirq;
> +	return hwirq + 1;
>  }
>  EXPORT_SYMBOL_GPL(irq_create_mapping);
>  
>  unsigned int irq_create_of_mapping(struct device_node *controller,
>  				   const u32 *intspec, unsigned int intsize)
>  {
> -	return intspec[0];
> +	/* Hardware irq is mapped to Linux IRQ# by a 1 offset. Linux irq
> +	 * 0 means no IRQ. */
> +	return intspec[0] + 1;
>  }
>  EXPORT_SYMBOL_GPL(irq_create_of_mapping);

I have created 5 patches to fix interrupt and timer code with changes to get NO_IRQ
to work.
I don't like one thing which is magic + 1 offset on some places with the same comment
which explain that it is because of NO_IRQ. I have created macros to solve this
(IRQ_SW_OFFSET and IRQ_OFFSET). Please comment it.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
