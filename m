Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0K3PmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:42:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59753 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0K3PmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:42:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6182"; a="64871472"
Message-ID: <4CF51B5A.9040307@codeaurora.org>
Date: Tue, 30 Nov 2010 10:42:18 -0500
From: Stephen Caudle <scaudle@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11pre) Gecko/20100922 Shredder/3.1.5pre
MIME-Version: 1.0
To: linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwalker@codeaurora.org,
        adharmap@codeaurora.org, miltonm@bga.com
Subject: Re: [PATCH v2] [ARM] gic: Unmask private interrupts on all cores
 during IRQ enable
References: <1288820762-16077-1-git-send-email-scaudle@codeaurora.org>
In-Reply-To: <1288820762-16077-1-git-send-email-scaudle@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

Can you pull in this patch or let me know if you want something changed 
with it?

Thanks,
Stephen

On 11/03/2010 05:46 PM, Stephen Caudle wrote:
> Some multi-core ARM chips designate a unique IRQ number for each core for
> private peripheral interrupts (PPIs). Others designate a common IRQ number
> for all cores. In the latter case, requesting/freeing private peripheral
> interrupts currently unmasks/masks the interrupt for only the
> executing core, respectively.
>
> With this change, request_irq will unmask a PPI on all cores so a separate
> call to enable_irq on the other cores is not required. Likewise, free_irq
> will mask a PPI on the other cores. Also, shutdown is implemented instead
> of disable to allow for lazy IRQ disabling.
>
> Signed-off-by: Stephen Caudle<scaudle@codeaurora.org>
> ---
>   arch/arm/Kconfig      |    5 +++
>   arch/arm/common/gic.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 91 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 30ddd06..7f11e31 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1153,6 +1153,11 @@ config SMP
>
>   	  If you don't know what to do here, say N.
>
> +config IRQ_PER_CPU
> +	bool
> +	depends on SMP
> +	default n
> +
>   config HAVE_ARM_SCU
>   	bool
>   	depends on SMP
> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
> index 886daaf..937a33a 100644
> --- a/arch/arm/common/gic.c
> +++ b/arch/arm/common/gic.c
> @@ -44,12 +44,25 @@ struct gic_chip_data {
>   	unsigned int wakeup_irqs[32];
>   	unsigned int enabled_irqs[32];
>   #endif
> +#ifdef CONFIG_IRQ_PER_CPU
> +	struct call_single_data ppi_data[NR_CPUS];
> +#endif
>   };
>
>   #ifndef MAX_GIC_NR
>   #define MAX_GIC_NR	1
>   #endif
>
> +#ifdef CONFIG_IRQ_PER_CPU
> +#ifndef GIC_PPI_FIRST
> +#define GIC_PPI_FIRST	16
> +#endif
> +
> +#ifndef GIC_PPI_LAST
> +#define GIC_PPI_LAST	31
> +#endif
> +#endif
> +
>   static struct gic_chip_data gic_data[MAX_GIC_NR];
>
>   static inline void __iomem *gic_dist_base(unsigned int irq)
> @@ -272,6 +285,75 @@ static int gic_set_type(unsigned int irq, unsigned int type)
>   	return 0;
>   }
>
> +#ifdef CONFIG_IRQ_PER_CPU
> +static inline void gic_smp_call_function(struct call_single_data *data)
> +{
> +	int cpu;
> +
> +	/* Make sure data is visible */
> +	smp_mb();
> +
> +	/*
> +	 * Since this function is called with interrupts disabled,
> +	 * smp_call_function can't be used here because it warns (even
> +	 * if wait = 0) when interrupts are disabled.
> +	 *
> +	 * __smp_call_function_single doesn't warn when interrupts are
> +	 * disabled and not waiting, so use it instead.
> +	 */
> +	for_each_online_cpu(cpu)
> +		if (cpu != smp_processor_id())
> +			__smp_call_function_single(cpu, data, 0);
> +}
> +
> +static void gic_mask_ppi(void *info)
> +{
> +	struct irq_desc *desc = info;
> +	gic_mask_irq(desc->irq);
> +}
> +
> +static void gic_unmask_ppi(void *info)
> +{
> +	struct irq_desc *desc = info;
> +	gic_unmask_irq(desc->irq);
> +}
> +
> +static void gic_enable_irq(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +	struct gic_chip_data *gic_data = get_irq_chip_data(irq);
> +	int cpu = smp_processor_id();
> +
> +	if (irq>= GIC_PPI_FIRST&&  irq<= GIC_PPI_LAST) {
> +		gic_data->ppi_data[cpu].func = gic_unmask_ppi;
> +		gic_data->ppi_data[cpu].info = desc;
> +
> +		/* Unmask PPIs on all cores during enable. */
> +		gic_smp_call_function(&gic_data->ppi_data[cpu]);
> +	}
> +
> +	desc->chip->unmask(irq);
> +	desc->status&= ~IRQ_MASKED;
> +}
> +
> +static void gic_shutdown_irq(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +	struct gic_chip_data *gic_data = get_irq_chip_data(irq);
> +	int cpu = smp_processor_id();
> +
> +	if (irq>= GIC_PPI_FIRST&&  irq<= GIC_PPI_LAST) {
> +		gic_data->ppi_data[cpu].func = gic_mask_ppi;
> +		gic_data->ppi_data[cpu].info = desc;
> +
> +		/* Mask PPIs on all cores during disable. */
> +		gic_smp_call_function(&gic_data->ppi_data[cpu]);
> +	}
> +
> +	desc->chip->mask(irq);
> +	desc->status |= IRQ_MASKED;
> +}
> +#endif
>
>   static struct irq_chip gic_chip = {
>   	.name		= "GIC",
> @@ -283,6 +365,10 @@ static struct irq_chip gic_chip = {
>   #endif
>   	.set_type	= gic_set_type,
>   	.set_wake	= gic_set_wake,
> +#ifdef CONFIG_IRQ_PER_CPU
> +	.enable		= gic_enable_irq,
> +	.shutdown	= gic_shutdown_irq,
> +#endif
>   };
>
>   void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
