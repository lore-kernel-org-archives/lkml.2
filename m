Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab1JRN1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:27:03 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:37025 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757915Ab1JRN1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:27:00 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 18 Oct 2011 21:33:55 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <patches@linaro.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <lrg@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 5/5] regulator: map consumer regulator based on device
 tree
Message-ID: <20111018133354.GE30703@S2100-06.ap.freescale.net>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-6-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1318263578-7407-6-git-send-email-rnayak@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 09:49:38PM +0530, Rajendra Nayak wrote:
> Device nodes in DT can associate themselves with one or more
> regulators/supply by providing a list of phandles (to regulator nodes)
> and corresponding supply names.
> 
> For Example:
> 	devicenode: node@0x0 {
> 		...
> 		...
> 		vmmc-supply = <&regulator1>;
> 		vpll-supply = <&regulator1>;

s/regulator1/regulator2

> 	};
> 
> The driver would then do a regulator_get(dev, "vmmc"); to get
> regulator1 and do a regulator_get(dev, "vpll"); to get
> regulator2.
> 
> of_get_regulator() extracts the regulator node for a given
> device, based on the supply name.
> 
> Use it to look up the regulator for a given consumer from device tree, during
> a regulator_get(). If not found fallback and lookup through
> the regulator_map_list instead.
> 
> Also, since the regulator dt nodes can use the same binding to
> associate with a parent regulator/supply, allow the drivers to
> specify a supply_name, which can then be used to lookup dt
> to find the parent phandle.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> ---
>  drivers/regulator/core.c         |   91 +++++++++++++++++++++++++++++++------
>  include/linux/regulator/driver.h |    2 +
>  2 files changed, 78 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index d8e6a42..9a5ebbe 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -25,9 +25,11 @@
>  #include <linux/mutex.h>
>  #include <linux/suspend.h>
>  #include <linux/delay.h>
> +#include <linux/of.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/regulator/driver.h>
>  #include <linux/regulator/machine.h>
> +#include <linux/regulator/of_regulator.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/regulator.h>
> @@ -131,6 +133,33 @@ static struct regulator *get_device_regulator(struct device *dev)
>  	return NULL;
>  }
>  
> +/**
> + * of_get_regulator - get a regulator device node based on supply name
> + * @dev: Device pointer for the consumer (of regulator) device
> + * @supply: regulator supply name
> + *
> + * Extract the regulator device node corresponding to the supply name.
> + * retruns the device node corresponding to the regulator if found, else
> + * returns NULL.
> + */
> +struct device_node *of_get_regulator(struct device *dev, const char *supply)
> +{
> +	struct device_node *regnode = NULL;
> +	char prop_name[32]; /* 32 is max size of property name */
> +
> +	dev_dbg(dev, "Looking up %s-supply from device tree\n", supply);
> +
> +	snprintf(prop_name, 32, "%s-supply", supply);
> +	regnode = of_parse_phandle(dev->of_node, prop_name, 0);
> +
> +	if (!regnode) {
> +		pr_warn("%s: %s property in node %s references invalid phandle",
> +			__func__, prop_name, dev->of_node->full_name);
> +		return NULL;
> +	}
> +	return regnode;
> +}
> +
>  /* Platform voltage constraint check */
>  static int regulator_check_voltage(struct regulator_dev *rdev,
>  				   int *min_uV, int *max_uV)
> @@ -1155,6 +1184,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  	struct regulator_map *map;
>  	struct regulator *regulator = ERR_PTR(-ENODEV);
>  	const char *devname = NULL;
> +	struct device_node *node;
>  	int ret;
>  
>  	if (id == NULL) {
> @@ -1167,6 +1197,23 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  
>  	mutex_lock(&regulator_list_mutex);
>  
> +	/*
> +	 * Lookup happens in 3 ways
> +	 * 1. If a dev and dev->of_node exist, look for a
> +	 * regulator mapping in dt node.
> +	 * 2. Check if a match can be found in regulator_map_list
> +	 * if regulator info is still passed in non-dt way
> +	 * 3. if !dev, then just look for a matching regulator name.
> +	 * Useful for dt builds using regulator_get() without specifying
> +	 * a device.
> +	 */
> +	if (dev && dev->of_node) {
> +		node = of_get_regulator(dev, id);
> +		if (node)
> +			list_for_each_entry(rdev, &regulator_list, list)
> +				if (node == rdev->dev.parent->of_node)

If we move DT parsing procedure into regulator core, we will be able to
find the of_node for given regulator and attach it to rdev->dev when
regulator_register() gets called by regulator drivers.  Then we will
have 'if (node == rdev->dev.of_node)' here which makes more sense to me.

Regards,
Shawn

> +					goto found;
> +	}
>  	list_for_each_entry(map, &regulator_map_list, list) {
>  		/* If the mapping has a device set up it must match */
>  		if (map->dev_name &&
> @@ -1178,6 +1225,10 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  			goto found;
>  		}
>  	}
> +	if (!dev)
> +		list_for_each_entry(rdev, &regulator_list, list)
> +			if (strcmp(rdev_get_name(rdev), id))
> +				goto found;
>  
>  	if (board_wants_dummy_regulator) {
>  		rdev = dummy_regulator_rdev;
> @@ -2579,6 +2630,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>  	static atomic_t regulator_no = ATOMIC_INIT(0);
>  	struct regulator_dev *rdev;
>  	int ret, i;
> +	const char *supply;
>  
>  	if (regulator_desc == NULL)
>  		return ERR_PTR(-EINVAL);
> @@ -2653,25 +2705,34 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>  	if (ret < 0)
>  		goto scrub;
>  
> -	if (init_data->supply_regulator) {
> -		struct regulator_dev *r;
> -		int found = 0;
> +	if (init_data->supply_regulator)
> +		supply = init_data->supply_regulator;
> +	else if (regulator_desc->supply_name);
> +		supply = regulator_desc->supply_name;
>  
> -		list_for_each_entry(r, &regulator_list, list) {
> -			if (strcmp(rdev_get_name(r),
> -				   init_data->supply_regulator) == 0) {
> -				found = 1;
> -				break;
> -			}
> +	if (supply) {
> +		struct regulator_dev *r;
> +		struct device_node *node;
> +
> +		/* first do a dt based lookup */
> +		if (dev) {
> +			node = of_get_regulator(dev, supply);
> +			if (node)
> +				list_for_each_entry(r, &regulator_list, list)
> +					if (node == r->dev.parent->of_node)
> +						goto found;
>  		}
>  
> -		if (!found) {
> -			dev_err(dev, "Failed to find supply %s\n",
> -				init_data->supply_regulator);
> -			ret = -ENODEV;
> -			goto scrub;
> -		}
> +		/* next try doing it non-dt way */
> +		list_for_each_entry(r, &regulator_list, list)
> +			if (strcmp(rdev_get_name(r), supply) == 0)
> +				goto found;
>  
> +		dev_err(dev, "Failed to find supply %s\n", supply);
> +		ret = -ENODEV;
> +		goto scrub;
> +
> +found:
>  		ret = set_supply(rdev, r);
>  		if (ret < 0)
>  			goto scrub;
> diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
> index 1a80bc7..65ca5ff 100644
> --- a/include/linux/regulator/driver.h
> +++ b/include/linux/regulator/driver.h
> @@ -153,6 +153,7 @@ enum regulator_type {
>   * this type.
>   *
>   * @name: Identifying name for the regulator.
> + * @supply_name: Identifying the regulator supply
>   * @id: Numerical identifier for the regulator.
>   * @n_voltages: Number of selectors available for ops.list_voltage().
>   * @ops: Regulator operations table.
> @@ -162,6 +163,7 @@ enum regulator_type {
>   */
>  struct regulator_desc {
>  	const char *name;
> +	const char *supply_name;
>  	int id;
>  	unsigned n_voltages;
>  	struct regulator_ops *ops;
> -- 
> 1.7.1
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

