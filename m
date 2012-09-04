Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2IDLpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:45:11 -0400
Received: from etezian.org ([198.101.225.253]:57507 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2IDLpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:45:10 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 07:45:10 EDT
Date: Tue, 4 Sep 2012 13:35:45 +0200
From: Andi Shyti <andi@etezian.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@linaro.org, kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sameo@linux.intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, richard.zhao@freescale.com,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org
Subject: Re: [PATCH v5 1/4] mfd: add syscon driver based on regmap
Message-ID: <20120904113545.GD4657@jack.whiskey>
References: <1346728811-25788-1-git-send-email-b29396@freescale.com>
 <1346728811-25788-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346728811-25788-2-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong,

On Tue, Sep 04, 2012 at 11:20:08AM +0800, Dong Aisheng wrote:
> +static int __devinit syscon_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;

Do we really need this variable? Anyway you are using it only
once in the dev_info.

> +	struct device_node *np = dev->of_node;
> +	struct syscon *syscon;
> +	struct resource res;
> +	int ret;
> +
> +	if (!np)
> +		return -ENOENT;
> +
> +	syscon = devm_kzalloc(&pdev->dev, sizeof(struct syscon),
> +			    GFP_KERNEL);
> +	if (!syscon)
> +		return -ENOMEM;
> +
> +	syscon->base = of_iomap(np, 0);
> +	if (!syscon->base)
> +		return -EADDRNOTAVAIL;
> +
> +	ret = of_address_to_resource(np, 0, &res);
> +	if (ret)
> +		return ret;
> +
> +	syscon_regmap_config.max_register = res.end - res.start - 3;
> +	syscon->regmap = devm_regmap_init_mmio(&pdev->dev, syscon->base,
> +					&syscon_regmap_config);
> +	if (IS_ERR(syscon->regmap)) {
> +		dev_err(&pdev->dev, "regmap init failed\n");
> +		return PTR_ERR(syscon->regmap);
> +	}
> +
> +	syscon->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, syscon);
> +
> +	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
> +		res.start, res.end);
> +
> +	return 0;

in case of error you are not freeing syscon.
Moreover, in my opinion, some dev_err more should not heart

Andi
