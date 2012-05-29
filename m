Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2E2JgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:36:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:47255 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2E2JgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:36:13 -0400
Date: Tue, 29 May 2012 11:36:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sundar Iyer <sundar.iyer@intel.com>
cc: linux-kernel@vger.kernel.org, arjan.van.de.ven@intel.com,
        german.monroy@intel.com
Subject: Re: [PATCH] x86/irq: handle chained interrupts during IRQ
 migration
In-Reply-To: <1338208817-3673-1-git-send-email-sundar.iyer@intel.com>
Message-ID: <alpine.LFD.2.02.1205291135000.3231@ionos>
References: <1338208817-3673-1-git-send-email-sundar.iyer@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012, Sundar Iyer wrote:

> chained interrupt handlers dont have an irqaction and hence
> are not handled during migrating interrupts when some cores
> go offline.
> 
> Handle this by introducing a new flag is_chained in the irq
> descriptor; fixup_irq() can then handle such interrupts and not
> skip them over.
> 
> Signed-off-by: Sundar Iyer <sundar.iyer@intel.com>
> ---
>  arch/x86/kernel/irq.c   |    5 +++--
>  include/linux/irqdesc.h |    8 ++++++++
>  kernel/irq/chip.c       |    1 +
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 6c0802e..29f2f63 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -249,8 +249,9 @@ void fixup_irqs(void)
>  
>  		data = irq_desc_get_irq_data(desc);
>  		affinity = data->affinity;
> -		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
> -		    cpumask_subset(affinity, cpu_online_mask)) {
> +		if ((!irq_has_action(irq) && !irq_is_chained(irq)) ||
> +			irqd_is_per_cpu(data) ||
> +			cpumask_subset(affinity, cpu_online_mask)) {
>  			raw_spin_unlock(&desc->lock);
>  			continue;
>  		}
> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
> index 2d921b3..0c7b474 100644
> --- a/include/linux/irqdesc.h
> +++ b/include/linux/irqdesc.h
> @@ -50,6 +50,7 @@ struct irq_desc {
>  	unsigned int		depth;		/* nested irq disables */
>  	unsigned int		wake_depth;	/* nested wake enables */
>  	unsigned int		irq_count;	/* For detecting broken IRQs */
> +	bool			is_chained;	/* for chained handlers */

No. We have flags and properties already. Please follow the existing
mechanisms instead of adding random fields to irq_desc.

Thanks,

	tglx
