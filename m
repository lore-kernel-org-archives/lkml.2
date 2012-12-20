Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2LTB05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:26:57 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50851 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab2LTB0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:26:52 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] gpio-langwell: implement irq shutdown interface
To: David Cohen <david.a.cohen@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        "Li, Ning" <ning.li@intel.com>, David Cohen <david.a.cohen@intel.com>
In-Reply-To: <1355881933-15182-4-git-send-email-david.a.cohen@intel.com>
References: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com> <1355881933-15182-4-git-send-email-david.a.cohen@intel.com>
Date: Thu, 20 Dec 2012 01:26:46 +0000
Message-Id: <20121220012646.E54AE3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012 17:52:13 -0800, David Cohen <david.a.cohen@intel.com> wrote:
> From: "Li, Ning" <ning.li@intel.com>
> 
> Signed-off-by: David Cohen <david.a.cohen@intel.com>
> Signed-off-by: Li, Ning <ning.li@intel.com>

I could use some help interpreting this patch since it doesn't have any
commit text describing why this patch is needed, nor does it have any
comments in the code describing what it is doing.

Having good commit text is important. Use it to tell me and future
readers why this patch is important. What it does and how it was tested.
Otherwise I end up trying to read your mind.

(The patch does actually look fine to me, but it isn't okay to neglect
a patch descirption on anything other than the most trivial of
patches... and even then it triggers severe eyebrow raising)

g.

> ---
>  drivers/gpio/gpio-langwell.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> index dc534a9..c702d3d 100644
> --- a/drivers/gpio/gpio-langwell.c
> +++ b/drivers/gpio/gpio-langwell.c
> @@ -219,12 +219,30 @@ static int lnw_irq_type(struct irq_data *d, unsigned type)
>  
>  static void lnw_irq_noop(struct irq_data *d) {}
>  
> +static void lnw_irq_shutdown(struct irq_data *d)
> +{
> +	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
> +	u32 gpio = irqd_to_hwirq(d);
> +	unsigned long flags;
> +	u32 value;
> +	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
> +	void __iomem *gfer = gpio_reg(&lnw->chip, gpio, GFER);
> +
> +	spin_lock_irqsave(&lnw->lock, flags);
> +	value = readl(grer) & ~BIT(gpio % 32);
> +	writel(value, grer);
> +	value = readl(gfer) & ~BIT(gpio % 32);
> +	writel(value, gfer);
> +	spin_unlock_irqrestore(&lnw->lock, flags);
> +};
> +
>  static struct irq_chip lnw_irqchip = {
>  	.name		= "LNW-GPIO",
>  	.irq_mask	= lnw_irq_noop,
>  	.irq_unmask	= lnw_irq_noop,
>  	.irq_set_type	= lnw_irq_type,
>  	.irq_ack	= lnw_irq_noop,
> +	.irq_shutdown	= lnw_irq_shutdown,
>  };
>  
>  static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
> -- 
> 1.7.10.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
