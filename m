Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab2EQXzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 19:55:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34657 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab2EQXzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 19:55:52 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/8 v2] mfd: tps65910: Add device-tree support
To: Rhyland Klein <rklein@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
In-Reply-To: <1335310570-12455-6-git-send-email-rklein@nvidia.com>
References: <1335310570-12455-1-git-send-email-rklein@nvidia.com> <1335310570-12455-6-git-send-email-rklein@nvidia.com>
Date: Thu, 17 May 2012 17:55:49 -0600
Message-Id: <20120517235549.A13E23E062C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012 16:36:07 -0700, Rhyland Klein <rklein@nvidia.com> wrote:
> Add device tree based initialization support for TI's tps65910 pmic.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>

Patch description is rather light. I like to see some more details
about what the patch changes and testing details are nice too, but
I'll ack it anyway:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  v2: split mfd portion into single change to add dt support
>      added of_node to config before calling regulator_register
>      removed passing pdata to mfd_cell child devices
>      removed use_dt_for_init_data flag
> 
>  drivers/mfd/tps65910.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 80 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 70a8079..248fe9f 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -23,6 +23,7 @@
>  #include <linux/mfd/core.h>
>  #include <linux/regmap.h>
>  #include <linux/mfd/tps65910.h>
> +#include <linux/of_device.h>
>  
>  static struct mfd_cell tps65910s[] = {
>  	{
> @@ -66,6 +67,78 @@ static const struct regmap_config tps65910_regmap_config = {
>  	.cache_type = REGCACHE_RBTREE,
>  };
>  
> +#ifdef CONFIG_OF
> +static struct of_device_id tps65910_of_match[] = {
> +	{ .compatible = "ti,tps65910", .data = (void *)TPS65910},
> +	{ .compatible = "ti,tps65911", .data = (void *)TPS65911},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, tps65910_of_match);
> +
> +static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
> +						int *chip_id)
> +{
> +	struct device_node *np = client->dev.of_node;
> +	struct tps65910_board *board_info;
> +	unsigned int prop;
> +	const struct of_device_id *match;
> +	unsigned int prop_array[TPS6591X_MAX_NUM_GPIO];
> +	int ret = 0;
> +	int idx;
> +
> +	match = of_match_device(tps65910_of_match, &client->dev);
> +	if (!match) {
> +		dev_err(&client->dev, "Failed to find matching dt id\n");
> +		return NULL;
> +	}
> +
> +	*chip_id  = (int)match->data;
> +
> +	board_info = devm_kzalloc(&client->dev, sizeof(*board_info),
> +			GFP_KERNEL);
> +	if (!board_info) {
> +		dev_err(&client->dev, "Failed to allocate pdata\n");
> +		return NULL;
> +	}
> +
> +	ret = of_property_read_u32(np, "ti,vmbch-threshold", &prop);
> +	if (!ret)
> +		board_info->vmbch_threshold = prop;
> +	else if (*chip_id == TPS65911)
> +		dev_warn(&client->dev, "VMBCH-Threshold not specified");
> +
> +	ret = of_property_read_u32(np, "ti,vmbch2-threshold", &prop);
> +	if (!ret)
> +		board_info->vmbch2_threshold = prop;
> +	else if (*chip_id == TPS65911)
> +		dev_warn(&client->dev, "VMBCH2-Threshold not specified");
> +
> +	ret = of_property_read_u32_array(np, "ti,en-gpio-sleep",
> +				   prop_array, TPS6591X_MAX_NUM_GPIO);
> +	if (!ret)
> +		for (idx = 0; idx < ARRAY_SIZE(prop_array); idx++)
> +			board_info->en_gpio_sleep[idx] = (prop_array[idx] != 0);
> +	else if (ret != -EINVAL) {
> +		dev_err(&client->dev,
> +			"error reading property ti,en-gpio-sleep: %d\n.", ret);
> +		return NULL;
> +	}
> +
> +
> +	board_info->irq = client->irq;
> +	board_info->irq_base = -1;
> +	board_info->gpio_base = -1;
> +
> +	return board_info;
> +}
> +#else
> +static inline struct tps65910_board *tps65910_parse_dt(
> +					struct i2c_client *client)
> +{
> +	return NULL;
> +}
> +#endif
> +
>  static int tps65910_i2c_probe(struct i2c_client *i2c,
>  			    const struct i2c_device_id *id)
>  {
> @@ -73,8 +146,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	struct tps65910_board *pmic_plat_data;
>  	struct tps65910_platform_data *init_data;
>  	int ret = 0;
> +	int chip_id = id->driver_data;
>  
>  	pmic_plat_data = dev_get_platdata(&i2c->dev);
> +
> +	if (!pmic_plat_data && i2c->dev.of_node)
> +		pmic_plat_data = tps65910_parse_dt(i2c, &chip_id);
> +
>  	if (!pmic_plat_data)
>  		return -EINVAL;
>  
> @@ -91,7 +169,7 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	i2c_set_clientdata(i2c, tps65910);
>  	tps65910->dev = &i2c->dev;
>  	tps65910->i2c_client = i2c;
> -	tps65910->id = id->driver_data;
> +	tps65910->id = chip_id;
>  	mutex_init(&tps65910->io_mutex);
>  
>  	tps65910->regmap = regmap_init_i2c(i2c, &tps65910_regmap_config);
> @@ -149,6 +227,7 @@ static struct i2c_driver tps65910_i2c_driver = {
>  	.driver = {
>  		   .name = "tps65910",
>  		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(tps65910_of_match),
>  	},
>  	.probe = tps65910_i2c_probe,
>  	.remove = tps65910_i2c_remove,
> -- 
> 1.7.0.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
