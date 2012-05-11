Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2EKXeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:34:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51681 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab2EKXeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:34:06 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
To: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, sameo@linux.intel.com,
        linus.walleij@stericsson.com
In-Reply-To: <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
References: <cover.1334219873.git.rubini@gnudd.com> <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
Date: Fri, 11 May 2012 17:34:02 -0600
Message-Id: <20120511233402.43D813E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 10:48:55 +0200, Alessandro Rubini <rubini@gnudd.com> wrote:
> This introduces 128 gpio bits (for each PCI device installed) with
> working interrupt support.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
[...]
> +/* The platform device used here is instantiated by the MFD device */
> +static int __devinit gsta_probe(struct platform_device *dev)
> +{
> +	int i, err;
> +	struct pci_dev *pdev;
> +	struct sta2x11_gpio_pdata *gpio_pdata;
> +	struct gsta_gpio *chip;
> +	struct resource *res;
> +
> +	pdev = *(struct pci_dev **)(dev->dev.platform_data);
> +	gpio_pdata = dev_get_platdata(&pdev->dev);
> +
> +	if (gpio_pdata == NULL)
> +		dev_err(&dev->dev, "no gpio config\n");
> +	pr_debug("gpio config: %p\n", gpio_pdata);
> +
> +	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +
> +	chip = devm_kzalloc(&dev->dev, sizeof(*chip), GFP_KERNEL);
> +	chip->dev = &dev->dev;
> +	chip->reg_base = devm_request_and_ioremap(&dev->dev, res);
> +
> +	for (i = 0; i < GSTA_NR_BLOCKS; i++) {
> +		chip->regs[i] = chip->reg_base + i * 4096;
> +		/* disable all irqs */
> +		writel(0, &chip->regs[i]->rimsc);
> +		writel(0, &chip->regs[i]->fimsc);
> +		writel(~0, &chip->regs[i]->ic);
> +	}
> +	spin_lock_init(&chip->lock);
> +	gsta_gpio_setup(chip);
> +	for (i = 0; i < GSTA_NR_GPIO; i++)
> +		gsta_set_config(chip, i, gpio_pdata->pinconfig[i]);
> +
> +	/* 384 was used in previous code: be compatible for other drivers */
> +	err = irq_alloc_descs(-1, 384, GSTA_NR_GPIO, NUMA_NO_NODE);
> +	if (err < 0) {
> +		dev_warn(&dev->dev, "sta2x11 gpio: Can't get irq base (%i)\n",
> +			 -err);
> +		return err;
> +	}
> +	chip->irq_base = err;

Where does the number 384 come from?  It looks like the driver only
needs to allocate a range of irqs and that it doesn't actually matter
what the real numbers are.  Can 0 be used instead?

Actually, I'd rather see this driver switched to using
irq_domain_add_linear so that irq_descs can be allocated on demand
instead of all at once.  That way only gpios actually used for irqs
get setup.

To convert, use irq_domain_add_linear() and then irq_data->hwirq gets
populated with the gpio number automatically for you and
irq_find_mapping takes care of the hwirq->irq reverse lookup.
