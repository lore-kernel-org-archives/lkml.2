Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1C1IOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:14:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60308 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1C1IOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=B4XkvIF/SxfK7I4hGi0Y5RfrOSPce07Il0O/H+NWfv/gHM6lQwxEvqcGKPYqALl+O0
         hdvL+mzNOsMoWin2tWCrzIAnhV38j1Lq7liPaDJH0W+107c+GelCdYx4H9cHazCTL7kE
         djCSzLUtCYvNfCHYkxIQOC+HuFLpfLimMY0pc=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] vlynq: Convert irq functions
Date: Mon, 28 Mar 2011 10:15:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-server; KDE/4.5.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.2.00.1103251223240.31464@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103251223240.31464@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103281015.02968.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 March 2011 12:28:27 Thomas Gleixner wrote:
> Convert to the new irq_chip functions and the new namespace.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Florian Fainelli <florian@openwrt.org>

> ---
>  drivers/vlynq/vlynq.c |   64
> ++++++++++++++++++++++++-------------------------- 1 file changed, 31
> insertions(+), 33 deletions(-)
> 
> Index: linux-2.6-tip/drivers/vlynq/vlynq.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/vlynq/vlynq.c
> +++ linux-2.6-tip/drivers/vlynq/vlynq.c
> @@ -135,40 +135,40 @@ static void vlynq_reset(struct vlynq_dev
>  	msleep(5);
>  }
> 
> -static void vlynq_irq_unmask(unsigned int irq)
> +static void vlynq_irq_unmask(struct irq_data *d)
>  {
> -	u32 val;
> -	struct vlynq_device *dev = get_irq_chip_data(irq);
> +	struct vlynq_device *dev = irq_data_get_chip_data(d);
>  	int virq;
> +	u32 val;
> 
>  	BUG_ON(!dev);
> -	virq = irq - dev->irq_start;
> +	virq = d->irq - dev->irq_start;
>  	val = readl(&dev->remote->int_device[virq >> 2]);
>  	val |= (VINT_ENABLE | virq) << VINT_OFFSET(virq);
>  	writel(val, &dev->remote->int_device[virq >> 2]);
>  }
> 
> -static void vlynq_irq_mask(unsigned int irq)
> +static void vlynq_irq_mask(struct irq_data *d)
>  {
> -	u32 val;
> -	struct vlynq_device *dev = get_irq_chip_data(irq);
> +	struct vlynq_device *dev = irq_data_get_chip_data(d);
>  	int virq;
> +	u32 val;
> 
>  	BUG_ON(!dev);
> -	virq = irq - dev->irq_start;
> +	virq = d->irq - dev->irq_start;
>  	val = readl(&dev->remote->int_device[virq >> 2]);
>  	val &= ~(VINT_ENABLE << VINT_OFFSET(virq));
>  	writel(val, &dev->remote->int_device[virq >> 2]);
>  }
> 
> -static int vlynq_irq_type(unsigned int irq, unsigned int flow_type)
> +static int vlynq_irq_type(struct irq_data *d, unsigned int flow_type)
>  {
> -	u32 val;
> -	struct vlynq_device *dev = get_irq_chip_data(irq);
> +	struct vlynq_device *dev = irq_data_get_chip_data(d);
>  	int virq;
> +	u32 val;
> 
>  	BUG_ON(!dev);
> -	virq = irq - dev->irq_start;
> +	virq = d->irq - dev->irq_start;
>  	val = readl(&dev->remote->int_device[virq >> 2]);
>  	switch (flow_type & IRQ_TYPE_SENSE_MASK) {
>  	case IRQ_TYPE_EDGE_RISING:
> @@ -192,10 +192,9 @@ static int vlynq_irq_type(unsigned int i
>  	return 0;
>  }
> 
> -static void vlynq_local_ack(unsigned int irq)
> +static void vlynq_local_ack(struct irq_data *d)
>  {
> -	struct vlynq_device *dev = get_irq_chip_data(irq);
> -
> +	struct vlynq_device *dev = irq_data_get_chip_data(d);
>  	u32 status = readl(&dev->local->status);
> 
>  	pr_debug("%s: local status: 0x%08x\n",
> @@ -203,10 +202,9 @@ static void vlynq_local_ack(unsigned int
>  	writel(status, &dev->local->status);
>  }
> 
> -static void vlynq_remote_ack(unsigned int irq)
> +static void vlynq_remote_ack(struct irq_data *d)
>  {
> -	struct vlynq_device *dev = get_irq_chip_data(irq);
> -
> +	struct vlynq_device *dev = irq_data_get_chip_data(d);
>  	u32 status = readl(&dev->remote->status);
> 
>  	pr_debug("%s: remote status: 0x%08x\n",
> @@ -238,23 +236,23 @@ static irqreturn_t vlynq_irq(int irq, vo
> 
>  static struct irq_chip vlynq_irq_chip = {
>  	.name = "vlynq",
> -	.unmask = vlynq_irq_unmask,
> -	.mask = vlynq_irq_mask,
> -	.set_type = vlynq_irq_type,
> +	.irq_unmask = vlynq_irq_unmask,
> +	.irq_mask = vlynq_irq_mask,
> +	.irq_set_type = vlynq_irq_type,
>  };
> 
>  static struct irq_chip vlynq_local_chip = {
>  	.name = "vlynq local error",
> -	.unmask = vlynq_irq_unmask,
> -	.mask = vlynq_irq_mask,
> -	.ack = vlynq_local_ack,
> +	.irq_unmask = vlynq_irq_unmask,
> +	.irq_mask = vlynq_irq_mask,
> +	.irq_ack = vlynq_local_ack,
>  };
> 
>  static struct irq_chip vlynq_remote_chip = {
>  	.name = "vlynq local error",
> -	.unmask = vlynq_irq_unmask,
> -	.mask = vlynq_irq_mask,
> -	.ack = vlynq_remote_ack,
> +	.irq_unmask = vlynq_irq_unmask,
> +	.irq_mask = vlynq_irq_mask,
> +	.irq_ack = vlynq_remote_ack,
>  };
> 
>  static int vlynq_setup_irq(struct vlynq_device *dev)
> @@ -291,17 +289,17 @@ static int vlynq_setup_irq(struct vlynq_
>  	for (i = dev->irq_start; i <= dev->irq_end; i++) {
>  		virq = i - dev->irq_start;
>  		if (virq == dev->local_irq) {
> -			set_irq_chip_and_handler(i, &vlynq_local_chip,
> +			irq_set_chip_and_handler(i, &vlynq_local_chip,
>  						 handle_level_irq);
> -			set_irq_chip_data(i, dev);
> +			irq_set_chip_data(i, dev);
>  		} else if (virq == dev->remote_irq) {
> -			set_irq_chip_and_handler(i, &vlynq_remote_chip,
> +			irq_set_chip_and_handler(i, &vlynq_remote_chip,
>  						 handle_level_irq);
> -			set_irq_chip_data(i, dev);
> +			irq_set_chip_data(i, dev);
>  		} else {
> -			set_irq_chip_and_handler(i, &vlynq_irq_chip,
> +			irq_set_chip_and_handler(i, &vlynq_irq_chip,
>  						 handle_simple_irq);
> -			set_irq_chip_data(i, dev);
> +			irq_set_chip_data(i, dev);
>  			writel(0, &dev->remote->int_device[virq >> 2]);
>  		}
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
