Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2J0KvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 06:51:06 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60561 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2J0KvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 06:51:02 -0400
Message-ID: <508BBD13.5050904@gmail.com>
Date: Sat, 27 Oct 2012 12:53:07 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "hongbo.zhang" <hongbo.zhang@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
CC: STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org, Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH V2 5/6] Thermal: Add ST-Ericsson DB8500 thermal driver.
In-Reply-To: <1351163639-29304-1-git-send-email-hongbo.zhang@linaro.com>
References: <1351079900-32236-6-git-send-email-hongbo.zhang@linaro.com>, <1351163639-29304-1-git-send-email-hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Oct 25 11:13:59 2012, Hongbo Zhang wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
> 
> This diver is based on the thermal management framework in thermal_sys.c. A
> thermal zone device is created with the trip points to which cooling devices
> can be bound, the current cooling device is cpufreq, e.g. CPU frequency is
> clipped down to cool the CPU, and other cooling devices can be added and bound
> to the trip points dynamically.  The platform specific PRCMU interrupts are
> used to active thermal update when trip points are reached.
> 
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> ---
>  .../devicetree/bindings/thermal/db8500-thermal.txt |  40 ++
>  drivers/thermal/Kconfig                            |  20 +
>  drivers/thermal/Makefile                           |   2 +
>  drivers/thermal/db8500_cpufreq_cooling.c           | 121 +++++
>  drivers/thermal/db8500_thermal.c                   | 523 +++++++++++++++++++++
>  include/linux/platform_data/db8500_thermal.h       |  38 ++
>  6 files changed, 744 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/db8500-thermal.txt
>  create mode 100644 drivers/thermal/db8500_cpufreq_cooling.c
>  create mode 100644 drivers/thermal/db8500_thermal.c
>  create mode 100644 include/linux/platform_data/db8500_thermal.h
> 
> diff --git a/Documentation/devicetree/bindings/thermal/db8500-thermal.txt b/Documentation/devicetree/bindings/thermal/db8500-thermal.txt
> new file mode 100644
> index 0000000..abe08d7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/db8500-thermal.txt
> @@ -0,0 +1,40 @@
> +* ST-Ericsson DB8500 Thermal
> +
> +** Thermal node properties:
> +
> +- compatible : "stericsson,db8500-thermal";
> +- reg : address range of the thermal sensor registers;
> +- interrupts : interrupts generated form PRCMU;

s/form/from

[...]
> diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
> new file mode 100644
> index 0000000..f6a8d24
> --- /dev/null
> +++ b/drivers/thermal/db8500_cpufreq_cooling.c
> @@ -0,0 +1,121 @@
> +/*
> + * db8500_cpufreq_cooling.c - db8500 cpufreq works as cooling device.
> + *
> + * Copyright (C) 2012 ST-Ericsson
> + * Copyright (C) 2012 Linaro Ltd.
> + *
> + * Author: Hongbo Zhang <hognbo.zhang@linaro.com>

Why do you keep writing an incorrect email address? :)
I'm referring to the spelling "hognbo" instead of "hongbo".

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/cpu_cooling.h>
> +#include <linux/cpufreq.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +static LIST_HEAD(db8500_cpufreq_cdev_list);
> +
> +struct db8500_cpufreq_cdev {
> +	struct thermal_cooling_device *cdev;
> +	struct list_head node;
> +};
> +
> +static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
> +{
> +	struct db8500_cpufreq_cdev *cooling_dev;
> +	struct cpumask mask_val;
> +
> +	cooling_dev = devm_kzalloc(&pdev->dev, sizeof(*cooling_dev),
> +		GFP_KERNEL);
> +	if (!cooling_dev)
> +		return -ENOMEM;
> +
> +	cpumask_set_cpu(0, &mask_val);
> +	cooling_dev->cdev = cpufreq_cooling_register(&mask_val);
> +
> +	if (IS_ERR_OR_NULL(cooling_dev->cdev)) {
> +		dev_err(&pdev->dev, "Failed to register cooling device\n");
> +		return PTR_ERR(cooling_dev->cdev);
> +	}
> +
> +	platform_set_drvdata(pdev, cooling_dev->cdev);
> +	list_add_tail(&cooling_dev->node, &db8500_cpufreq_cdev_list);
> +	dev_info(&pdev->dev, "Cooling device registered: %s\n",
> +		cooling_dev->cdev->type);
> +
> +	return 0;
> +}
> +
> +static int db8500_cpufreq_cooling_remove(struct platform_device *pdev)
> +{
> +	struct db8500_cpufreq_cdev *cooling_dev;
> +
> +	list_for_each_entry(cooling_dev, &db8500_cpufreq_cdev_list, node)
> +		if (cooling_dev->cdev == platform_get_drvdata(pdev)) {
> +			cpufreq_cooling_unregister(cooling_dev->cdev);
> +			list_del(&cooling_dev->node);
> +		}
> +
> +	return 0;
> +}

There is no need to keep an internal list of cooling devices, and the
struct db8500_cpufreq_cdev definition is not needed either.
In probe() you can simply call platform_set_drvdata() with the pointer
returned by cpufreq_cooling_register(); conversely, in remove() you can
simply call cpufreq_cooling_unregister() with the pointer returned by
platform_get_drvdata().

> +
> +static int db8500_cpufreq_cooling_suspend(struct platform_device *pdev,
> +		pm_message_t state)
> +{
> +	return -ENOSYS;
> +}
> +
> +static int db8500_cpufreq_cooling_resume(struct platform_device *pdev)
> +{
> +	return -ENOSYS;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id db8500_cpufreq_cooling_match[] = {
> +	{ .compatible = "stericsson,db8500-cpufreq-cooling" },
> +	{},
> +};
> +#else
> +#define db8500_cpufreq_cooling_match NULL
> +#endif
> +
> +static struct platform_driver db8500_cpufreq_cooling_driver = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = "db8500-cpufreq-cooling",
> +		.of_match_table = db8500_cpufreq_cooling_match,
> +	},
> +	.probe = db8500_cpufreq_cooling_probe,
> +	.suspend = db8500_cpufreq_cooling_suspend,
> +	.resume = db8500_cpufreq_cooling_resume,
> +	.remove = __devexit_p(db8500_cpufreq_cooling_remove),

Since db8500_cpufreq_cooling_remove is not __devexit anymore,
__devexit_p() should be removed.

> +};
> +
> +static int __init db8500_cpufreq_cooling_init(void)
> +{
> +	return platform_driver_register(&db8500_cpufreq_cooling_driver);
> +}
> +
> +static void __exit db8500_cpufreq_cooling_exit(void)
> +{
> +	platform_driver_unregister(&db8500_cpufreq_cooling_driver);
> +}
> +
> +/* Should be later than db8500_cpufreq_register */
> +late_initcall(db8500_cpufreq_cooling_init);
> +module_exit(db8500_cpufreq_cooling_exit);
> +
> +MODULE_AUTHOR("Hongbo Zhang <hongbo.zhang@stericsson.com>");
> +MODULE_DESCRIPTION("DB8500 cpufreq cooling driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/thermal/db8500_thermal.c b/drivers/thermal/db8500_thermal.c
> new file mode 100644
> index 0000000..d12bf9b
> --- /dev/null
> +++ b/drivers/thermal/db8500_thermal.c
> @@ -0,0 +1,523 @@
> +/*
> + * db8500_thermal.c - db8500 Thermal Management Implementation
> + *
> + * Copyright (C) 2012 ST-Ericsson
> + * Copyright (C) 2012 Linaro Ltd.
> + *
> + * Author: Hongbo Zhang <hognbo.zhang@linaro.com>

s/hognbo/hongbo

[...]
> +static irqreturn_t prcmu_high_irq_handler(int irq, void *irq_data)
> +{
> +	struct db8500_thermal_zone *pzone = irq_data;
> +	struct db8500_thsens_platform_data *ptrips = pzone->trip_tab;
> +	unsigned int idx = pzone->cur_index;
> +	unsigned long next_low, next_high;
> +
> +	if (idx < ptrips->num_trips - 1) {
> +		next_high = ptrips->trip_points[idx+1].temp;
> +		next_low = ptrips->trip_points[idx].temp;
> +		idx += 1;
> +
> +		db8500_thermal_update_config(pzone, idx, THERMAL_TREND_RAISING,
> +			next_low, next_high);
> +
> +		dev_dbg(&pzone->therm_dev->device,
> +		"PRCMU set max %ld, min %ld\n", next_high, next_low);
> +	}
> +
> +	else if (idx == ptrips->num_trips - 1)

As per kernel coding style, the else clause should be in the same line
as the closing brace of the if block:
} else if ()

> +		pzone->cur_temp_pseudo = ptrips->trip_points[idx].temp + 1;
> +
> +	schedule_work(&pzone->therm_work);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void db8500_thermal_work(struct work_struct *work)
> +{
> +	enum thermal_device_mode cur_mode;
> +	struct db8500_thermal_zone *pzone;
> +
> +	pzone = container_of(work, struct db8500_thermal_zone, therm_work);
> +
> +	mutex_lock(&pzone->th_lock);
> +	cur_mode = pzone->mode;
> +	mutex_unlock(&pzone->th_lock);
> +
> +	if (cur_mode == THERMAL_DEVICE_DISABLED)
> +		return;
> +
> +	thermal_zone_device_update(pzone->therm_dev);
> +	dev_dbg(&pzone->therm_dev->device, "thermal work finished.\n");
> +}
> +
> +#ifdef CONFIG_OF
> +static struct db8500_thsens_platform_data*
> +		db8500_thermal_parse_dt(struct platform_device *pdev)
> +{
> +	struct db8500_thsens_platform_data *ptrips;
> +	struct device_node *np = pdev->dev.of_node;
> +	char prop_name[32];
> +	const char *tmp_str;
> +	u32 tmp_data;
> +	int i, j;
> +
> +	ptrips = devm_kzalloc(&pdev->dev, sizeof(*ptrips), GFP_KERNEL);
> +	if (!ptrips)
> +		return NULL;
> +
> +	if (of_property_read_u32(np, "num-trips", &tmp_data))
> +		goto err_parse_dt;
> +
> +	ptrips->num_trips = tmp_data;

There should be a check against tmp_data exceeding the size of the
trip_points array.

> +
> +	for (i = 0; i < ptrips->num_trips; i++) {
> +		sprintf(prop_name, "trip%d-temp", i);
> +		if (of_property_read_u32(np, prop_name, &tmp_data))
> +			goto err_parse_dt;
> +
> +		ptrips->trip_points[i].temp = tmp_data;
> +
> +		sprintf(prop_name, "trip%d-type", i);
> +		if (of_property_read_string(np, prop_name, &tmp_str))
> +			goto err_parse_dt;
> +
> +		if (!strcmp(tmp_str, "active"))
> +			ptrips->trip_points[i].type = THERMAL_TRIP_ACTIVE;
> +		else if (!strcmp(tmp_str, "passive"))
> +			ptrips->trip_points[i].type = THERMAL_TRIP_PASSIVE;
> +		else if (!strcmp(tmp_str, "hot"))
> +			ptrips->trip_points[i].type = THERMAL_TRIP_HOT;
> +		else if (!strcmp(tmp_str, "critical"))
> +			ptrips->trip_points[i].type = THERMAL_TRIP_CRITICAL;
> +		else
> +			goto err_parse_dt;
> +
> +		sprintf(prop_name, "trip%d-cdev-num", i);
> +		if (of_property_read_u32(np, prop_name, &tmp_data))
> +			goto err_parse_dt;
> +
> +		for (j = 0; j < tmp_data; j++) {
> +			sprintf(prop_name, "trip%d-cdev-name%d", i, j);
> +			if (of_property_read_string(np, prop_name, &tmp_str))
> +				goto err_parse_dt;
> +			strcpy(ptrips->trip_points[i].cdev_name[j], tmp_str);

You should check that tmp_data doesn't exceed the size of the cdev_name
array, and that the length of the tmp_str string doesn't exceed the size
of each element of the cdev_name array.

[...]
> +static struct platform_driver db8500_thermal_driver = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = "db8500-thermal",
> +		.of_match_table = db8500_thermal_match,
> +	},
> +	.probe = db8500_thermal_probe,
> +	.suspend = db8500_thermal_suspend,
> +	.resume = db8500_thermal_resume,
> +	.remove = __devexit_p(db8500_thermal_remove),

__devexit_p() should be removed.

> +};
> +
> +module_platform_driver(db8500_thermal_driver);
> +
> +MODULE_AUTHOR("Hongbo Zhang <hongbo.zhang@stericsson.com>");
> +MODULE_DESCRIPTION("DB8500 thermal driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/platform_data/db8500_thermal.h b/include/linux/platform_data/db8500_thermal.h
> new file mode 100644
> index 0000000..aad98f8
> --- /dev/null
> +++ b/include/linux/platform_data/db8500_thermal.h
> @@ -0,0 +1,38 @@
> +/*
> + * db8500_thermal.h - db8500 Thermal Management Implementation
> + *
> + * Copyright (C) 2012 ST-Ericsson
> + * Copyright (C) 2012 Linaro Ltd.
> + *
> + * Author: Hongbo Zhang <hognbo.zhang@linaro.com>

s/hognbo/hongbo

PS: When re-sending the patch, I'd suggest you re-send the entire patch
series as V3.

Thanks,
Francesco
