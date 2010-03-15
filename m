Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936919Ab0COVxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:53:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:44083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936880Ab0COVxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:53:32 -0400
Message-ID: <4B9EABE8.1020203@kernel.org>
Date: Mon, 15 Mar 2010 14:51:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch] x86: handle legacy PIC interrupts on all the cpu's
References: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 03:33 PM, Suresh Siddha wrote:
> Ingo Molnar reported that with the recent changes of not statically blocking
> IRQ0_VECTOR..IRQ15_VECTOR's on all the cpu's, broke an AMD platform
> (with Nvidia chipset) boot when "noapic" boot option is used.
> 
> On this platform, legacy PIC interrupts are getting delivered to all the
> cpu's instead of just the boot cpu. Thus not initializing the vector to irq
> mapping for the legacy irq's resulted in not handling certain interrupts
> causing boot hang.
> 
> Fix this by initializing the vector to irq mapping on all the logical cpu's,
> if the legacy IRQ is handled by the legacy PIC.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> index a929c9e..46c0fe0 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -133,6 +133,7 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
>  
>  typedef int vector_irq_t[NR_VECTORS];
>  DECLARE_PER_CPU(vector_irq_t, vector_irq);
> +extern void setup_vector_irq(int cpu);
>  
>  #ifdef CONFIG_X86_IO_APIC
>  extern void lock_vector_lock(void);
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index e4e0ddc..10f0a1a 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1268,6 +1268,14 @@ void __setup_vector_irq(int cpu)
>  	/* Mark the inuse vectors */
>  	for_each_irq_desc(irq, desc) {
>  		cfg = desc->chip_data;
> +
> +		/*
> +		 * If it is a legacy IRQ handled by the legacy PIC, this cpu
> +		 * will be part of the irq_cfg's domain.
> +		 */
> +		if (irq < legacy_pic->nr_legacy_irqs && !IO_APIC_IRQ(irq))
> +			cpumask_set_cpu(cpu, cfg->domain);
> +
>  		if (!cpumask_test_cpu(cpu, cfg->domain))
>  			continue;
>  		vector = cfg->vector;
> diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
> index ef257fc..daaf413 100644
> --- a/arch/x86/kernel/irqinit.c
> +++ b/arch/x86/kernel/irqinit.c
> @@ -141,6 +141,27 @@ void __init init_IRQ(void)
>  	x86_init.irqs.intr_init();
>  }
>  
> +/*
> + * Setup the vector to irq mappings.
	> + */
> +void setup_vector_irq(int cpu)
> +{
> +	int irq;
> +
> +	/*
> +	 * On most of the platforms, legacy PIC delivers the interrupts on the
> +	 * boot cpu. But there are certain platforms where PIC interrupts are
> +	 * delivered to multiple cpu's. If the legacy IRQ is handled by the
> +	 * legacy PIC, for the new cpu that is coming online, setup the static
> +	 * legacy vector to irq mapping.
> +	 */
> +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
> +		if (!IO_APIC_IRQ(irq))
> +			per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;

seems those three lines are not needed...



YH
