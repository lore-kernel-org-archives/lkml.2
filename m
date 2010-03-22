Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0CVN7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:59:07 -0400
Received: from www.tglx.de ([62.245.132.106]:44071 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab0CVN7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:59:03 -0400
Date: Mon, 22 Mar 2010 14:58:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] x86: use vector_desc instead of vector_irq
In-Reply-To: <1269221770-9667-6-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1003221435480.3147@localhost.localdomain>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org> <1269221770-9667-6-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, Yinghai Lu wrote:

> Eric pointed out that radix tree version of irq_to_desc will magnify delay on
> the path of handle_irq.
> 
> use vector_desc to reduce the calling of irq_to_desc.
> 
> next step: need to change all ack, mask, umask, eoi for all irq_chip to take irq_desc

That's not relevant for this change.
 
>  
> -typedef int vector_irq_t[NR_VECTORS];
> -DECLARE_PER_CPU(vector_irq_t, vector_irq);
> -extern void setup_vector_irq(int cpu);
> +typedef struct irq_desc *vector_desc_t[NR_VECTORS];

  Why do we need that typedef ? Please use plain struct irq_desc *

> +DECLARE_PER_CPU(vector_desc_t, vector_desc);
> +extern void setup_vector_desc(int cpu);
...
>  void destroy_irq(unsigned int irq)
>  {
>  	unsigned long flags;
> +	struct irq_desc *desc;
> +	struct irq_cfg *cfg;
>  
>  	dynamic_irq_cleanup_keep_chip_data(irq);
>  
>  	free_irte(irq);
>  	raw_spin_lock_irqsave(&vector_lock, flags);
> -	__clear_irq_vector(irq, get_irq_chip_data(irq));
> +	desc = irq_to_desc(irq);
> +	cfg = desc->chip_data;
> +	__clear_irq_vector(desc, cfg);

	__clear_irq_vector(desc, desc->chip_data);

 should be sufficient, right ?

>  	raw_spin_unlock_irqrestore(&vector_lock, flags);
>  }
>  
> @@ -3377,6 +3376,7 @@ void destroy_irq(unsigned int irq)
>  static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
>  			   struct msi_msg *msg, u8 hpet_id)
>  {
> +	struct irq_desc *desc;
>  	struct irq_cfg *cfg;
>  	int err;
>  	unsigned dest;
> @@ -3384,8 +3384,9 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
>  	if (disable_apic)
>  		return -ENXIO;
>  
> -	cfg = irq_cfg(irq);
> -	err = assign_irq_vector(irq, cfg, apic->target_cpus());
> +	desc = irq_to_desc(irq);
> +	cfg = desc->chip_data;
> +	err = assign_irq_vector(desc, cfg, apic->target_cpus());

  Ditto

>  	if (err)
>  		return err;
>  
> @@ -3876,14 +3877,16 @@ static struct irq_chip ht_irq_chip = {
>  
>  int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
>  {
> +	struct irq_desc *desc;
>  	struct irq_cfg *cfg;
>  	int err;
>  
>  	if (disable_apic)
>  		return -ENXIO;
>  
> -	cfg = irq_cfg(irq);
> -	err = assign_irq_vector(irq, cfg, apic->target_cpus());
> +	desc = irq_to_desc(irq);
> +	cfg = desc->chip_data;
> +	err = assign_irq_vector(desc, cfg, apic->target_cpus());

  Ditto

>  	if (!err) {
>  		struct ht_irq_msg msg;
>  		unsigned dest;
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 91fd0c7..f71625c 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -229,19 +229,19 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
>  
>  	/* high bit used in ret_from_ code  */
>  	unsigned vector = ~regs->orig_ax;
> -	unsigned irq;
> +	struct irq_desc *desc;
>  
>  	exit_idle();
>  	irq_enter();
>  
> -	irq = __get_cpu_var(vector_irq)[vector];
> +	desc = __get_cpu_var(vector_desc)[vector];
>  
> -	if (!handle_irq(irq, regs)) {
> +	if (!handle_irq(desc, regs)) {
>  		ack_APIC_irq();
>  
>  		if (printk_ratelimit())
> -			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
> -				__func__, smp_processor_id(), vector, irq);
> +			pr_emerg("%s: %d.%d No irq handler for vector\n",

  That printk is confusing. It's not lacking an irq handler. The
  vector is simply not assigned.

Thanks,

	tglx
