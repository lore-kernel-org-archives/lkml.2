Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1BHDZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:25:33 -0500
Received: from dalsmrelay2.nai.com ([205.227.136.216]:30754 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1BHDZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:25:32 -0500
Message-ID: <4D50B773.2070507@snapgear.com>
Date: Tue, 8 Feb 2011 13:24:35 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [patch 07/10] m68knommu: Convert 5272 intc irq_chip to new functions
References: <20110206233845.480884215@linutronix.de> <20110206233904.777004540@linutronix.de>
In-Reply-To: <20110206233904.777004540@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2011 03:25:29.0895 (UTC) FILETIME=[D617EB70:01CBC73F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

On 07/02/11 09:39, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/m68knommu/platform/5272/intc.c |   28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
>
> Index: linux-next/arch/m68knommu/platform/5272/intc.c
> ===================================================================
> --- linux-next.orig/arch/m68knommu/platform/5272/intc.c
> +++ linux-next/arch/m68knommu/platform/5272/intc.c
> @@ -78,8 +78,10 @@ static struct irqmap intc_irqmap[MCFINT_
>   * an interrupt on this irq (for the external irqs). So this mask function
>   * is also an ack_mask function.
>   */
> -static void intc_irq_mask(unsigned int irq)
> +static void intc_irq_mask(struct irq_data *d)
>  {
> +	unsigned int irq = d->irq;
> +
>  	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
>  		u32 v;
>  		irq -= MCFINT_VECBASE;
> @@ -88,8 +90,10 @@ static void intc_irq_mask(unsigned int i
>  	}
>  }
>
> -static void intc_irq_unmask(unsigned int irq)
> +static void intc_irq_unmask(struct irq_data *d)
>  {
> +	unsigned int irq = d->irq;
> +
>  	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
>  		u32 v;
>  		irq -= MCFINT_VECBASE;
> @@ -98,8 +102,10 @@ static void intc_irq_unmask(unsigned int
>  	}
>  }
>
> -static void intc_irq_ack(unsigned int irq)
> +static void intc_irq_ack(struct irq_data *d)
>  {
> +	unsigned int irq = d->irq;
> +
>  	/* Only external interrupts are acked */
>  	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
>  		irq -= MCFINT_VECBASE;
> @@ -113,8 +119,10 @@ static void intc_irq_ack(unsigned int ir
>  	}
>  }
>
> -static int intc_irq_set_type(unsigned int irq, unsigned int type)
> +static int intc_irq_set_type(struct irq_data *d, unsigned int type)
>  {
> +	unsigned int irq = d->irq;
> +
>  	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
>  		irq -= MCFINT_VECBASE;
>  		if (intc_irqmap[irq].ack) {
> @@ -137,17 +145,17 @@ static int intc_irq_set_type(unsigned in
>   */
>  static void intc_external_irq(unsigned int irq, struct irq_desc *desc)
>  {
> -	desc->chip->ack(irq);
> +	get_irq_desc_chip(i)->irq_ack(desc->irq_data);
                          ^^^         ^^^
should this be:

         get_irq_desc_chip(desc)->irq_ack(&desc->irq_data)

I can't runtime test this right at the moment, but otherwise:

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg



>  	handle_simple_irq(irq, desc);
>  }
>
>  static struct irq_chip intc_irq_chip = {
>  	.name		= "CF-INTC",
> -	.mask		= intc_irq_mask,
> -	.unmask		= intc_irq_unmask,
> -	.mask_ack	= intc_irq_mask,
> -	.ack		= intc_irq_ack,
> -	.set_type	= intc_irq_set_type,
> +	.irq_mask	= intc_irq_mask,
> +	.irq_unmask	= intc_irq_unmask,
> +	.irq_mask_ack	= intc_irq_mask,
> +	.irq_ack	= intc_irq_ack,
> +	.irq_set_type	= intc_irq_set_type,
>  };
>
>  void __init init_IRQ(void)

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
