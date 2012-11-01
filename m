Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952Ab2KAPNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:13:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63750 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761859Ab2KAPM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:12:57 -0400
Message-ID: <509291FF.6090500@gmail.com>
Date: Thu, 01 Nov 2012 16:15:11 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
CC: rob.herring@calxeda.com, lee.jones@linaro.org, arnd@arndb.de,
        anton.vorontsov@linaro.org, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
References: <1351698033-8980-1-git-send-email-rajanikanth.hv@linaro.org> <1351698033-8980-2-git-send-email-rajanikanth.hv@linaro.org>
In-Reply-To: <1351698033-8980-2-git-send-email-rajanikanth.hv@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 04:40 PM, Rajanikanth H.V wrote:
> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> - This patch adds device tree support for fuelgauge driver
> - optimize bm devices platform_data usage and of_probe(...)
>   Note: of_probe() routine for battery managed devices is made
>   common across all bm drivers.
> - test status:
>   - interrupt numbers assigned differs between legacy and FDT mode.
> 
> Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
[...]
> +int __devinit
> +bmdevs_of_probe(struct device *dev,
> +		struct device_node *np,
> +		struct abx500_bm_data **battery)
> +{
> +	struct	abx500_battery_type *btype;
> +	struct  device_node *np_bat_supply;
> +	struct	abx500_bm_data *bat;
> +	const char *btech;
> +	char bat_tech[8];
> +	int i, thermistor;
> +
> +	*battery = &ab8500_bm_data;
> +
> +	/* get phandle to 'battery-info' node */
> +	np_bat_supply = of_parse_phandle(np, "battery", 0);
> +	if (!np_bat_supply) {
> +		dev_err(dev, "missing property battery\n");
> +		return -EINVAL;
> +	}
> +	if (of_property_read_bool(np_bat_supply,
> +			"thermistor-on-batctrl"))
> +		thermistor = NTC_INTERNAL;
> +	else
> +		thermistor = NTC_EXTERNAL;
> +
> +	bat = *battery;
> +	if (thermistor == NTC_EXTERNAL) {
> +		bat->n_btypes  = 4;
> +		bat->bat_type  = bat_type_ext_thermistor;
> +		bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
> +	}
> +	btech = of_get_property(np_bat_supply,
> +		"stericsson,battery-type", NULL);
> +	if (!btech) {
> +		dev_warn(dev, "missing property battery-name/type\n");
> +		strcpy(bat_tech, "UNKNOWN");
> +	} else {
> +		strcpy(bat_tech, btech);
> +	}

I don't get the point of declaring the char array and copying the string
in it, when you could simply use just the pointer returned by
of_get_property().
Anyway, if the string property is longer than 8 characters, you are
writing past the size of the destination array.
