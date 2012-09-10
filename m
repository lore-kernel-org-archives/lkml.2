Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab2IJOKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:10:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2IJOKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:10:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rajanikanth HV <rajanikanth.hv@linaro.org>
Subject: Re: [PATCH] mfd: Implement devicetree support for AB8500 fg
Date: Mon, 10 Sep 2012 14:10:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        linus.walleij@stericsson.com, STEricsson_nomadik_linux@list.st.com,
        linaro-dev@lists.linaro.org, Patch Tracking <patches@linaro.org>
References: <CAB4BAkvdwEDViLGXfHHzYjkoL6qPZca2dzOin3GhBrqRJ3xNAg@mail.gmail.com>
In-Reply-To: <CAB4BAkvdwEDViLGXfHHzYjkoL6qPZca2dzOin3GhBrqRJ3xNAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209101410.11793.arnd@arndb.de>
X-Provags-ID: V02:K0:ob4Xa6Gx6FqXz66VejcZeBevrD2WZDdWzc/4TmTmac5
 8pz23dAOER4pF+wAfAQZGEh+OgkNwW7F+DZD7YjySEpVl4WO0w
 +1fi2bP2EiJBJZsP2eveK2GLO+VmmHGhzFgwQ5qYgrFLn52Cy6
 kQKnccnVY2KGuLAOYMQH8PfSS74iXQdob9kej0k9YkrhZ2BLwS
 wrqWOAm+lV1IHlgbK8Fjz4Hs6WwkTOk0aaUmPRkUZuusDN+f5k
 AtfUgtWqR3MI7StHcVGpYvyh27KdgJAT3Y7jOl283ntpRWCteH
 5vlCoMtSBKAjMQ9CVmph4V3iWXQwEQOqt3GP4i5ethvLwv0+aV
 TBERRCGWF0HdRcOGFD2Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2012, Rajanikanth HV wrote:

> +Required Properties:
> +- compatible = "stericsson,ab8500-fg"
> +
> +supplied-to:
> +	This is a logical binding w.r.t power supply event change
> +	across energy-management-module drivers where in the
> +	runtime battery properties are shared along with uevent
> +	notification.
> +	ref: di->fg.external_power_changed =
> +		ab8500_fg_external_power_changed;
> +		ab8500_fg.c
> +
> +	Need for this property:
> +		btemp, fg and charger updates power-supply properties
> +		based on the events listed above.
> +		Event handler invokes power supply change notifier
> +		which in-turn invokes registered power supply class call-back
> +		based on the 'supplied_to' string.
> +		ref:
> +		power_supply_changed_work(..) ./drivers/power/power_supply_core.c
> +
> +	example:
> +	ab8500-fg {
> +		/* Other enery management module */
> +		supplied_to = "ab8500_chargalg", "ab8500_usb";
> +		num_supplicants = <2>;
> +	};

same comments as for the btemp driver.

> diff --git a/drivers/power/ab8500_bmdata.h b/drivers/power/ab8500_bmdata.h
> new file mode 100644
> index 0000000..748334a
> --- /dev/null
> +++ b/drivers/power/ab8500_bmdata.h
> @@ -0,0 +1,442 @@
> +static struct abx500_res_to_temp temp_tbl_A_thermister[] = {
> +	{-5, 53407},
> +	{ 0, 48594},
> +	{ 5, 43804},
> +	{10, 39188},
> +	{15, 34870},

Static variable definitions never belong in a header file. If you want to
share these between multiple drivers, put a single copy in one file and
make the symbols extern (or even exported).

If they are used in only one driver, just put the tables into that driver.
You probably want to make them 'const' as well.

>  static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>  {
>  	int i, irq;
>  	int ret = 0;
>  	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
> +	struct device_node *np = pdev->dev.of_node;
>  	struct ab8500_fg *di;
> 
> +	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
> +	if (!di) {
> +		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
> +		ret = -ENOMEM;
> +		goto err_no_mem;
> +	}
> +	if (np) {
> +		if (!plat_data) {
> +			plat_data =
> +			devm_kzalloc(&pdev->dev, sizeof(*plat_data), GFP_KERNEL);
> +			if (!plat_data) {
> +				dev_err(&pdev->dev,
> +					"%s no mem for plat_data\n", __func__);
> +				ret = -ENOMEM;
> +				goto free_device_info;
> +			}
> +			plat_data->fg = devm_kzalloc(&pdev->dev,
> +					sizeof(*plat_data->fg), GFP_KERNEL);
> +			if (!plat_data->fg) {
> +				devm_kfree(&pdev->dev, plat_data);
> +				dev_err(&pdev->dev,
> +					"%s no mem for pdata->fg\n",
> +					__func__);
> +				ret = -ENOMEM;
> +				goto free_device_info;
> +			}
> +		}
> +		/* get battery specific platform data */
> +		ret = fg_of_probe(&pdev->dev, np, plat_data);
> +		if (ret) {
> +			devm_kfree(&pdev->dev, plat_data->fg);
> +			devm_kfree(&pdev->dev, plat_data);
> +			goto free_device_info;
> +		}
> +	}

I think for this driver it makes more sense to put all the information into
the struct ab8500_fg rather than having some of it in abx500_bm_plat_data,
so you can skip the allocation part here. In case of static platform
definitions, just copy the pointers from the platform data into the
ab8500_fg data.

	Arnd
