Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916Ab2COJHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:07:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588Ab2COJHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:07:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9] mfd: Add anatop mfd driver
Date: Thu, 15 Mar 2012 09:07:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linaro-dev@lists.linaro.org, Samuel Ortiz <sameo@linux.intel.com>,
        patches@linaro.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Venu Byravarasu <vbyravarasu@nvidia.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
References: <1331797421-23731-1-git-send-email-paul.liu@linaro.org>
In-Reply-To: <1331797421-23731-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203150907.29895.arnd@arndb.de>
X-Provags-ID: V02:K0:hlcUMcuuQcN2i1wyUL3TckAyEyFclK0B2xhGniEW0Od
 k9YXzaGTLpGX47aSJBLorQkqTcP4t2RaRa8EeBWXSOoKkdY2Rs
 PqCtyxtJAMHi2X/T23yO4rC6qt4EDloapJ23nOBtRkxMstI7w3
 aEJHUgZEQCKvT7gJCU1y1MiOsChA4boLOVWMZSbLWmciOFJr5/
 D7DNojWF10CCbXrqe/+efPozk4zP2LdZ/aABBOdDymcsJsLpPs
 tQjbwYGkNNjFnlu8jyABVRake422Z2t94ApnMRR99gxinHmlYN
 eJtvtN2/2a4K0PoRBCeAPjrkfXUrPiH/8d7OrR1fOqhj6qPBdb
 E86gVs0Yc4XgkAJXJ2aI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2012, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop is a mfd chip embedded in Freescale i.MX6Q SoC.
> Anatop provides regulators and thermal.
> This driver handles the address space and the operation of the mfd device.

Hi Paul,

This looks like a very nice and clean driver, good work!

Very broadly speaking, I wonder whether we could use the regmap
infrastructure for these things in the future, but I would first
need to understand whether that is actually in the scope of regmap.

It seems that you just need a subset of what regmap provides,
so it could work, but it might not actually be better than what
you have now.

Mark, can you comment on that?

> +u32 anatop_get_bits(struct anatop *adata, u32 addr, int bit_shift,
> +		    int bit_width)
> +{
> +	u32 val, mask;
> +
> +	if (bit_width == 32)
> +		mask = ~0;
> +	else
> +		mask = (1 << bit_width) - 1;
> +
> +	val = readl(adata->ioreg + addr);
> +	val = (val >> bit_shift) & mask;
> +
> +	return val;
> +}
> +EXPORT_SYMBOL(anatop_get_bits);

I think the exports here should be EXPORT_SYMBOL_GPL. There is no reason
why an out of tree driver would ever use these.

> +static const struct of_device_id of_anatop_subdevice_match[] = {
> +	{ .compatible = "fsl,anatop-regulator", },
> +	{ .compatible = "fsl,anatop-thermal", },
> +	{ },
> +};
> +
> +static int __devinit of_anatop_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	void *ioreg;
> +	struct anatop *drvdata;
> +
> +	ioreg = of_iomap(np, 0);
> +	if (!ioreg)
> +		return -EADDRNOTAVAIL;
> +	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
> +	if (!drvdata)
> +		return -ENOMEM;
> +	drvdata->ioreg = ioreg;
> +	spin_lock_init(&drvdata->reglock);
> +	platform_set_drvdata(pdev, drvdata);
> +	of_platform_bus_probe(np, of_anatop_subdevice_match, dev);
> +
> +	return 0;
> +}

Why do you list the subdevices in of_anatop_subdevice_match()? I think you
should just use 

	of_platform_bus_probe(np, of_anatop_match, dev);

here, using the same match table that you have in the platform_driver.
That will automatically create platform devices for any children of this
device, so you don't have to update the list above when you get new
child drivers.

	Arnd
