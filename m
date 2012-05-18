Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310Ab2ERW55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:57:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36808 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759722Ab2ERW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:57:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        olof@lixom.net
In-Reply-To: <20120516072927.GN7988@linux-sh.org>
References: <20120515154333.6659.66479.sendpatchset@w520> <20120516072927.GN7988@linux-sh.org>
Date: Fri, 18 May 2012 16:57:47 -0600
Message-Id: <20120518225747.893F33E07C8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012 16:29:28 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, May 16, 2012 at 12:43:33AM +0900, Magnus Damm wrote:
> > +static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
> > +{
> > +	struct platform_device *pdev = p->pdev;
> > +	struct gpio_em_config *pdata = pdev->dev.platform_data;
> > +
> > +	p->irq_base = irq_alloc_descs(pdata->irq_base, 0,
> > +				      pdata->number_of_pins, numa_node_id());
> > +	if (IS_ERR_VALUE(p->irq_base)) {
> > +		dev_err(&pdev->dev, "cannot get irq_desc\n");
> > +		return -ENXIO;
> > +	}
> > +	pr_debug("gio: hw base = %d, nr = %d, sw base = %d\n",
> > +		 pdata->gpio_base, pdata->number_of_pins, p->irq_base);
> > +
> > +	p->irq_domain = irq_domain_add_legacy(pdev->dev.of_node,
> > +					      pdata->number_of_pins,
> > +					      p->irq_base, 0,
> > +					      &em_gio_irq_domain_ops, p);
> > +	if (!p->irq_domain) {
> > +		irq_free_descs(p->irq_base, pdata->number_of_pins);
> > +		return -ENXIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> There's no reason to use a legacy domain here, this is a pretty
> straightforward candidate for a linear map. You can use ->to_irq() for
> the irq_create_mapping() invocation and then later look up the IRQ with
> irq_linear_revmap().
> 
> irq_domain_add_legacy() exists for existing static ranges, which there is
> really no reason to be adding in new board/platform support. You don't
> have to worry about virq overlap since irq_create_mapping() already wraps
> on top of irq_alloc_desc_xxx() for lookup.
> 
> > +static void __devexit em_gio_irq_domain_cleanup(struct em_gio_priv *p)
> > +{
> > +	struct gpio_em_config *pdata = p->pdev->dev.platform_data;
> > +
> > +	irq_free_descs(p->irq_base, pdata->number_of_pins);
> > +	/* FIXME: irq domain wants to be freed! */
> > +}
> > +
> After which point you can iterate and dispose of the virq mappings with
> irq_dispose_mapping(). The lack of irq domain teardown functionality does
> need to be addressed though.

Yes, that falls firmly in the "that's a bug" category.  I need to get
some time to fix it if someone doesn't beat me to it.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
