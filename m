Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1IQRQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 13:16:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51268 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1IQRQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 13:16:34 -0400
Date: Sat, 17 Sep 2011 11:16:30 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] power: bq20z75: devicetree init support
Message-ID: <20110917171630.GY3523@ponder.secretlab.ca>
References: <1316023462-3287-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316023462-3287-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 11:04:22AM -0700, Rhyland Klein wrote:
> Adding support to generate platform data when kernel is configured
> through device tree.
> 
> Also adding the binding for the TI bq20z75 fuel gadge and the
> bq20z75 driver.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
> 	v2: Fixed typo in binding description
> 	v3: Changed to use "ti," for properties
> 	    Changed to use single gpio entry for battery detect info.
> 	    Removed unnecessary call to of_match_device.
> 	v4: squashed bindings and drivers changes together.
> 	    fixed case where CONFIG_OF is not selected, to return existing
> 	    pdata pointer if it exists.
> 
>  .../bindings/power_supply/ti_bq20z75.txt           |   23 ++++++
>  drivers/power/bq20z75.c                            |   75 ++++++++++++++++++++
>  2 files changed, 98 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
> 
> diff --git a/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt b/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
> new file mode 100644
> index 0000000..7571294
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
> @@ -0,0 +1,23 @@
> +TI bq20z75
> +~~~~~~~~~~
> +
> +Required properties :
> + - compatible : "ti,bq20z75"
> +
> +Optional properties :
> + - ti,i2c-retry-count : The number of times to retry i2c transactions on i2c
> +   IO failure.
> + - ti,poll-retry-count : The number of times to try looking for new status
> +   after an external change notification.
> + - ti,battery-detect-gpios : The gpio which signals battery detection and
> +   a flag specifying its polarity.
> +
> +Example:
> +
> +	bq20z75@b {
> +		compatible = "ti,bq20z75";
> +		reg = < 0xb >;
> +		ti,i2c-retry-count = <2>;
> +		ti,poll-retry-count = <10>;
> +		ti,battery-detect-gpios = <&gpio-controller 122 1>;
> +	}
> diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
> index 9c5e5be..4c4669e 100644
> --- a/drivers/power/bq20z75.c
> +++ b/drivers/power/bq20z75.c
> @@ -613,6 +613,78 @@ static void bq20z75_delayed_work(struct work_struct *work)
>  	}
>  }
>  
> +#if defined(CONFIG_OF)
> +#include <linux/of_device.h>
> +static const struct of_device_id bq20z75_dt_ids[] = {
> +	{ .compatible = "ti,bq20z75" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(platform, bq20z75_dt_ids);
> +
> +static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
> +	struct i2c_client *client)
> +{
> +	const struct of_device_id *dtid;
> +	struct device_node *of_node = client->dev.of_node;
> +	struct bq20z75_platform_data *pdata = client->dev.platform_data;
> +	enum of_gpio_flags gpio_flags;
> +	int rc;
> +	u32 prop;
> +
> +	/* verify this driver matches this device */
> +	if (!of_node)
> +		return NULL;
> +
> +	/* if platform data is set, honor it */
> +	if (pdata)
> +		return pdata;
> +
> +	/* first make sure at least one property is set, otherwise
> +	 * it won't change behavior from running without pdata.
> +	 */
> +	if (!of_get_property(of_node, "ti,i2c-retry-count", NULL) &&
> +		!of_get_property(of_node, "ti,poll-retry-count", NULL) &&
> +		!of_get_property(of_node, "ti,battery-detect-gpios", NULL))
> +		goto of_out;
> +
> +	pdata = devm_kzalloc(&client->dev, sizeof(struct bq20z75_platform_data),
> +				GFP_KERNEL);
> +	if (!pdata)
> +		goto of_out;
> +
> +	rc = of_property_read_u32(of_node, "ti,i2c-retry-count", &prop);
> +	if (!rc)
> +		pdata->i2c_retry_count = prop;
> +
> +	rc = of_property_read_u32(of_node, "ti,poll-retry-count", &prop);
> +	if (!rc)
> +		pdata->poll_retry_count = prop;
> +
> +	if (!of_get_property(of_node, "ti,battery-detect-gpios", NULL)) {
> +		pdata->battery_detect = -1;
> +		goto of_out;
> +	}
> +
> +	pdata->battery_detect = of_get_named_gpio_flags(of_node,
> +			"ti,battery-detect-gpios", 0, &gpio_flags);
> +
> +	if (gpio_flags & OF_GPIO_ACTIVE_LOW)
> +		pdata->battery_detect_present = 0;
> +	else
> +		pdata->battery_detect_present = 1;
> +
> +of_out:
> +	return pdata;
> +}
> +#else
> +#define bq20z75_dt_ids NULL
> +static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
> +	struct i2c_client *client)
> +{
> +	return client->dev.platform_data;
> +}
> +#endif
> +
>  static int __devinit bq20z75_probe(struct i2c_client *client,
>  	const struct i2c_device_id *id)
>  {
> @@ -642,6 +714,8 @@ static int __devinit bq20z75_probe(struct i2c_client *client,
>  	bq20z75_device->power_supply.external_power_changed =
>  		bq20z75_external_power_changed;
>  
> +	pdata = bq20z75_of_populate_pdata(client);
> +
>  	if (pdata) {
>  		bq20z75_device->gpio_detect =
>  			gpio_is_valid(pdata->battery_detect);
> @@ -775,6 +849,7 @@ static struct i2c_driver bq20z75_battery_driver = {
>  	.id_table	= bq20z75_id,
>  	.driver = {
>  		.name	= "bq20z75-battery",
> +		.of_match_table = bq20z75_dt_ids,
>  	},
>  };
>  
> -- 
> 1.7.6
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
