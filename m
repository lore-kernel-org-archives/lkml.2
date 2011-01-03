Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1ACVnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:43:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762Ab1ACVnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:43:04 -0500
Date: Mon, 3 Jan 2011 13:40:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Marc Zyngier <maz@misterjones.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH] gpio/ml_ioh_gpio: ML7213 GPIO driver
Message-Id: <20110103134004.04814deb.akpm@linux-foundation.org>
In-Reply-To: <1293105524-3250-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1293105524-3250-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010 20:58:44 +0900
Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com> wrote:

> ML7213 is companion chip for Intel Atom E6xx series.
> This driver can be used for OKI SEMICONDUCTOR ML7213 IOH(Input/Output Hub) which
> is for IVI(In-Vehicle Infotainment) use.
> This driver can access the IOH's GPIO device.
> 
>
> ...
>
> +static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
> +				    const struct pci_device_id *id)
> +{
> +	int ret;
> +	int i;
> +	struct ioh_gpio *chip;
> +	void __iomem *base;
> +	void __iomem *chip_save;
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "%s : pci_enable_device failed", __func__);
> +		goto err_pci_enable;
> +	}
> +
> +	ret = pci_request_regions(pdev, KBUILD_MODNAME);
> +	if (ret) {
> +		dev_err(&pdev->dev, "pci_request_regions failed-%d", ret);
> +		goto err_request_regions;
> +	}
> +
> +	base = pci_iomap(pdev, 1, 0);
> +	if (base == 0) {
> +		dev_err(&pdev->dev, "%s : pci_iomap failed", __func__);
> +		ret = -ENOMEM;
> +		goto err_iomap;
> +	}
> +
> +	chip_save = kzalloc(sizeof(*chip) * 8, GFP_KERNEL);
> +	if (chip_save == NULL) {
> +		dev_err(&pdev->dev, "%s : kzalloc failed", __func__);
> +		ret = -ENOMEM;
> +		goto err_kzalloc;
> +	}
> +
> +	for (i = 0, chip = chip_save; i < 8; i++, chip++) {

	chip = chip_save;
	for (i = 0; i < 8; i++, chip++) {

is simpler, and simpler is better.

> +		chip->dev = &pdev->dev;
> +		chip->base = base;
> +		chip->reg = chip->base;
> +		chip->ch = i;
> +		mutex_init(&chip->lock);
> +		ioh_gpio_setup(chip, num_ports[i]);
> +		ret = gpiochip_add(&chip->gpio);
> +		if (ret) {
> +			dev_err(&pdev->dev, "IOH gpio: Failed to register GPIO\n");
> +			goto err_gpiochip_add;

Here we should run gpiochip_remove() against chips 0 .. i-1, no?

> +		}
> +	}
> +
> +	chip = chip_save;
> +	pci_set_drvdata(pdev, chip);
> +
> +	return 0;
> +
> +err_gpiochip_add:
> +	kfree(chip_save);
> +
> +err_kzalloc:
> +	pci_iounmap(pdev, base);
> +
> +err_iomap:
> +	pci_release_regions(pdev);
> +
> +err_request_regions:
> +	pci_disable_device(pdev);
> +
> +err_pci_enable:
> +
> +	dev_err(&pdev->dev, "%s Failed returns %d\n", __func__, ret);
> +	return ret;
> +}

