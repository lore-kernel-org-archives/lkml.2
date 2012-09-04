Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab2IDMSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:18:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50652 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab2IDMSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:18:15 -0400
Message-ID: <5045F13B.8060409@mvista.com>
Date: Tue, 04 Sep 2012 16:16:59 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Andi Shyti <andi@etezian.org>
CC: Dong Aisheng <b29396@freescale.com>, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        s.hauer@pengutronix.de, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, richard.zhao@freescale.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com
Subject: Re: [PATCH v5 1/4] mfd: add syscon driver based on regmap
References: <1346728811-25788-1-git-send-email-b29396@freescale.com> <1346728811-25788-2-git-send-email-b29396@freescale.com> <20120904113545.GD4657@jack.whiskey>
In-Reply-To: <20120904113545.GD4657@jack.whiskey>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04-09-2012 15:35, Andi Shyti wrote:

>> +static int __devinit syscon_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;

> Do we really need this variable? Anyway you are using it only
> once in the dev_info.

    But Dong definitely could use it more than once, so it seems useful.

>> +	struct device_node *np = dev->of_node;
>> +	struct syscon *syscon;
>> +	struct resource res;
>> +	int ret;
>> +
>> +	if (!np)
>> +		return -ENOENT;
>> +
>> +	syscon = devm_kzalloc(&pdev->dev, sizeof(struct syscon),
>> +			    GFP_KERNEL);
>> +	if (!syscon)
>> +		return -ENOMEM;
>> +
>> +	syscon->base = of_iomap(np, 0);
>> +	if (!syscon->base)
>> +		return -EADDRNOTAVAIL;
>> +
>> +	ret = of_address_to_resource(np, 0, &res);
>> +	if (ret)
>> +		return ret;
>> +
>> +	syscon_regmap_config.max_register = res.end - res.start - 3;
>> +	syscon->regmap = devm_regmap_init_mmio(&pdev->dev, syscon->base,
>> +					&syscon_regmap_config);
>> +	if (IS_ERR(syscon->regmap)) {
>> +		dev_err(&pdev->dev, "regmap init failed\n");
>> +		return PTR_ERR(syscon->regmap);
>> +	}
>> +
>> +	syscon->dev = &pdev->dev;
>> +	platform_set_drvdata(pdev, syscon);
>> +
>> +	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
>> +		res.start, res.end);
>> +
>> +	return 0;

> in case of error you are not freeing syscon.

    It's allocated using devm_kzalloc(), so is freed automaticelly upon probe 
error.

> Moreover, in my opinion, some dev_err more should not heart

    Hurt, you mean?

> Andi

WBR, Sergei

