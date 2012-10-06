Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2JFOAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 10:00:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48303 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2JFOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 10:00:20 -0400
Message-ID: <507039D1.3010307@gmail.com>
Date: Sat, 06 Oct 2012 16:01:53 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
CC: lee.jones@linaro.org, arnd@arndb.de, anton.vorontsov@linaro.org,
        linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
References: <1349064513-31301-1-git-send-email-rajanikanth.hv@stericsson.com> <1349064513-31301-2-git-send-email-rajanikanth.hv@stericsson.com>
In-Reply-To: <1349064513-31301-2-git-send-email-rajanikanth.hv@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/01/2012 06:08 AM, Rajanikanth H.V wrote:
> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> - This patch adds device tree support for fuelguage driver
> - optimize bm devices platform_data usage and of_probe(...)
>   Note: of_probe() routine for battery managed devices is made
>   common across all bm drivers.
[...]
> +int __devinit
> +bmdevs_of_probe(struct device *dev,
> +		struct device_node *np,
> +		struct abx500_bm_plat_data *pdata)
> +{
> +	int	i, ret = 0, thermistor = NTC_INTERNAL;
> +	const	__be32 *ph;
> +	const	char *bat_tech;
> +	struct	abx500_bm_data		 *bat;
> +	struct	abx500_battery_type	 *btype;
> +	struct  device_node		 *np_bat_supply;
> +	struct  abx500_bmdevs_plat_data  *plat_data = pdata->bmdev_pdata;
> +
> +	/* get phandle to 'supplied-to' node */
> +	ph = of_get_property(np, "supplied-to", &plat_data->num_supplicants);
> +	if (ph == NULL) {
> +		dev_err(dev, "no supplied_to property specified\n");
> +		return -EINVAL;
> +	}
> +	plat_data->num_supplicants /= sizeof(int);
> +	plat_data->supplied_to =
> +		devm_kzalloc(dev, plat_data->num_supplicants *
> +			sizeof(const char *), GFP_KERNEL);
> +	if (plat_data->supplied_to == NULL) {
> +		dev_err(dev, "%s no mem for supplied-to\n", __func__);
> +		return -ENOMEM;
> +	}
> +	for (i = 0; i < plat_data->num_supplicants; ++i) {
> +		np_bat_supply = of_find_node_by_phandle(be32_to_cpup(ph) + i);
> +		if (np_bat_supply == NULL) {
> +			dev_err(dev, "invalid supplied_to property\n");
> +			return -EINVAL;
> +		}
> +		ret = of_property_read_string(np_bat_supply, "interface-name",
> +				(const char **)(plat_data->supplied_to + i));
> +		if (ret < 0) {
> +			of_node_put(np_bat_supply);
> +			dev_err(dev, "supply/interface name not found\n");
> +			return ret;
> +		}

If an error is encountered here, of_node_put() should be called for all
nodes previously referenced with of_find_node_by_phandle (or
of_parse_phandle, as Lee suggested).
Also, if I'm not mistaken we have a leak here, because the refcount of
these nodes is never decremented, not even in the driver remove routine.

[...]
> @@ -2446,18 +2444,47 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>  {
>  	int i, irq;
>  	int ret = 0;
> -	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
> +	struct abx500_bm_plat_data *plat_data
> +				= pdev->dev.platform_data;
> +	struct device_node *np	= pdev->dev.of_node;
>  	struct ab8500_fg *di;
>  
> +	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
> +	if (!di) {
> +		dev_err(&pdev->dev, "%s no mem for ab8500_fg\n", __func__);
> +		return -ENOMEM;
> +	}
> +	if (np) {
> +		if (!plat_data) {
> +			plat_data =
> +			devm_kzalloc(&pdev->dev, sizeof(*plat_data),
> +					GFP_KERNEL);
> +			if (!plat_data) {
> +				dev_err(&pdev->dev,
> +					"%s no mem for plat_data\n", __func__);
> +				return -ENOMEM;
> +			}
> +			plat_data->bmdev_pdata = devm_kzalloc(&pdev->dev,
> +				sizeof(*plat_data->bmdev_pdata), GFP_KERNEL);
> +			if (!plat_data->bmdev_pdata) {
> +				dev_err(&pdev->dev,
> +					"%s no mem for pdata->fg\n",
> +					__func__);
> +				return -ENOMEM;
> +			}
> +		}
> +		ret = bmdevs_of_probe(&pdev->dev, np, plat_data);

I think it's better to move allocation of bmdev_pdata and corresponding
error check to bmdevs_of_probe(), because this code is shared by all
battery management drivers.

--
Francesco
