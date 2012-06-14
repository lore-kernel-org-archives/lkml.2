Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab2FNGPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 02:15:32 -0400
Received: from linux-sh.org ([111.68.239.195]:39183 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab2FNGPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 02:15:31 -0400
Date: Thu, 14 Jun 2012 15:15:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2][resend] gpio: pcf857x: enable gpio_to_irq() support
Message-ID: <20120614061519.GB22007@linux-sh.org>
References: <877gw2uis5.wl%kuninori.morimoto.gx@renesas.com>
 <87d352qymy.wl%kuninori.morimoto.gx@renesas.com>
 <87aa06qykw.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa06qykw.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 09:58:26PM -0700, Kuninori Morimoto wrote:
> +static void pcf857x_nothing(struct irq_data *data)
> +{
> +	/* do nothing */
> +}
> +
> +static struct irq_chip pcf857x_irq_chip = {
> +	.name		= "pcf857x cascade",
> +	.irq_mask	= pcf857x_nothing,
> +	.irq_unmask	= pcf857x_nothing,
> +};
> +
Just use dummy_irq_chip.

> +static int pcf857x_irq_domain_init(struct pcf857x *gpio,
> +				   struct pcf857x_platform_data *pdata,
> +				   struct device *dev)
> +{
> +	int status;
> +
> +	/* create demuxed irq */
> +	gpio->irq_demux_base = irq_alloc_descs(-1, 0, gpio->chip.ngpio, 0);
> +	if (gpio->irq_demux_base < 0)
> +		return -ENODEV;
> +
> +	gpio->irq_domain = irq_domain_add_legacy(dev->of_node,
> +						 gpio->chip.ngpio,
> +						 gpio->irq_demux_base,
> +						 0,
> +						 &pcf857x_irq_domain_ops,
> +						 NULL);

Given that you don't actually care where the IRQs are mapped there's no
need to bother with a legacy domain here, you can just use a linear one
outright. At which point you can drop your separate irq_desc
allocation/management.
