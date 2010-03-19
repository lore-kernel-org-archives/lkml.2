Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab0CSUv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:51:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab0CSUv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:51:56 -0400
Date: Fri, 19 Mar 2010 13:51:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
       Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/4 v2] GPIO: add support for RDC321x GPIO controller
Message-Id: <20100319135140.7d645a7c.akpm@linux-foundation.org>
In-Reply-To: <201003110942.13093.florian@openwrt.org>
References: <201003110942.13093.florian@openwrt.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 09:42:13 +0100
Florian Fainelli <florian@openwrt.org> wrote:

> This patch adds a new GPIO driver for the RDC321x SoC GPIO controller.
> 

Minor points:

>
> +static int rdc_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
> +{
> +	struct rdc321x_gpio *gpch =
> +				container_of(chip, struct rdc321x_gpio, chip);
> +	u32 value = 0;
> +	int reg;

erk, ugly trick to make checkpatch shut up.  This is better:

	struct rdc321x_gpio *gpch;
	u32 value = 0;
	int reg;

	gpch = container_of(chip, struct rdc321x_gpio, chip);


> +/*
> + * Cache the initial value of both GPIO data registers
> + */
> +static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
> +{
> +	int err;
> +	struct resource *r;
> +	struct rdc321x_gpio *rdc321x_gpio_dev;
> +	struct rdc321x_gpio_pdata *pdata;
> +
> +	pdata = pdev->dev.platform_data;
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "no platform data supplied\n");
> +		return -ENODEV;
> +	}
> +
> +	rdc321x_gpio_dev = kzalloc(sizeof(struct rdc321x_gpio), GFP_KERNEL);
> +	if (!rdc321x_gpio_dev) {
> +		dev_err(&pdev->dev, "failed to allocate private data\n");
> +		return -ENOMEM;
> +	}
> +
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gpio-reg1");
> +	if (!r) {
> +		dev_err(&pdev->dev, "failed to get gpio-reg1 resource\n");
> +		err = -ENODEV;
> +		goto out_free;
> +	}
> +
> +	rdc321x_gpio_dev->reg1_ctrl_base = r->start;
> +	rdc321x_gpio_dev->reg1_data_base = r->start + 0x4;
> +
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gpio-reg2");
> +	if (!r) {
> +		dev_err(&pdev->dev, "failed to get gpio-reg2 resource\n");
> +		err = -ENODEV;
> +		goto out_free;
> +	}
> +
> +	rdc321x_gpio_dev->reg2_ctrl_base = r->start;
> +	rdc321x_gpio_dev->reg2_data_base = r->start + 0x4;
> +
> +	rdc321x_gpio_dev->chip.label = "rdc321x-gpio";
> +	rdc321x_gpio_dev->chip.direction_input = rdc_gpio_direction_input;
> +	rdc321x_gpio_dev->chip.direction_output = rdc_gpio_config;
> +	rdc321x_gpio_dev->chip.get = rdc_gpio_get_value;
> +	rdc321x_gpio_dev->chip.set = rdc_gpio_set_value;
> +	rdc321x_gpio_dev->chip.base = 0;
> +	rdc321x_gpio_dev->chip.ngpio = pdata->max_gpios;
> +
> +	platform_set_drvdata(pdev, rdc321x_gpio_dev);
> +
> +	/* This might not be, what others (BIOS, bootloader, etc.)
> +	   wrote to these registers before, but it's a good guess. Still
> +	   better than just using 0xffffffff. */
> +	err = rdc321x_pci_read(rdc321x_gpio_dev->reg1_data_base,
> +					&rdc321x_gpio_dev->data_reg[0]);
> +	if (err)
> +		goto out_drvdata;
> +
> +	err = rdc321x_pci_read(rdc321x_gpio_dev->reg2_data_base,
> +					&rdc321x_gpio_dev->data_reg[1]);
> +	if (err)
> +		goto out_drvdata;
> +
> +	spin_lock_init(&rdc321x_gpio_dev->lock);

>From a robustness/defensiveness point of view, it would be better to
initialise this lock as soon as possible.  This reduces the possibility
that someone will later insert code here which takes that lock, but
they only test the code on UP, or on setups where it happens-to-work.

> +	printk(KERN_INFO "rdc321x-gpio: registering %d GPIOs\n",
> +					rdc321x_gpio_dev->chip.ngpio);
> +	return gpiochip_add(&rdc321x_gpio_dev->chip);
> +
> +out_drvdata:
> +	platform_set_drvdata(pdev, NULL);
> +out_free:
> +	kfree(rdc321x_gpio_dev);
> +	return err;
> +}
> ...
