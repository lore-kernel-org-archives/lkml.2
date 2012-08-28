Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2H1OSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:18:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36439 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2H1OSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:18:09 -0400
Message-ID: <503CD31E.6050207@wwwdotorg.org>
Date: Tue, 28 Aug 2012 07:18:06 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com, lrg@ti.com,
        swarren@wwwdotorg.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: register regulator even if no init
 data
References: <1346149767-31602-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1346149767-31602-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 03:29 AM, Laxman Dewangan wrote:
> Register all TPS6586x regulators even if there is no regulator
> init data for platform i.e. without any user-supplied constraints.

> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c

> @@ -396,19 +396,19 @@ static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *clien
>  	for (i = 0, j = 0; i < num && j < count; i++) {
>  		struct regulator_init_data *reg_idata;
>  
> -		if (!tps6586x_matches[i].init_data)
> -			continue;
> -
>  		reg_idata  = tps6586x_matches[i].init_data;
>  		devs[j].name = "tps6586x-regulator";
>  		devs[j].platform_data = tps6586x_matches[i].init_data;
>  		devs[j].id = (int)tps6586x_matches[i].driver_data;
> -		if (devs[j].id == TPS6586X_ID_SYS)
> -			sys_rail_name = reg_idata->constraints.name;
>  
> -		if ((devs[j].id == TPS6586X_ID_LDO_5) ||
> -			(devs[j].id == TPS6586X_ID_LDO_RTC))
> -			reg_idata->supply_regulator = sys_rail_name;
> +		if (tps6586x_matches[i].init_data) {

The variable that's being used inside this block is reg_idata.
Admittedly the value of that variable is tps6586x_matches[i].init_data,
but I think it'd be much cleaner if the if statement checked reg_idata
directly; that way, someone reading the code wouldn't have to look above
to find out that reg_idata and tps6586x_matches[i].init_data are related.

> +			if (devs[j].id == TPS6586X_ID_SYS)
> +				sys_rail_name = reg_idata->constraints.name;

In the MAX8907 patch this attempts to duplicate; if there is no init
data where the user gives an explicit name, the name from the descriptor
is used:

if (idata && idata->constraints.name)
    mbatt_rail_name = idata->constraints.name;
else
    mbatt_rail_name = pmic->desc[i].name;

Shouldn't that same algorithm be used here?

> diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c

> @@ -332,6 +332,9 @@ static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, rdev);
>  
> +	if (!pdev->dev.platform_data)
> +		return 0;
> +
>  	return tps6586x_regulator_set_slew_rate(pdev);
>  }

Sorry, I don't immediately see why that's related?
