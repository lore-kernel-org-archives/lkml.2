Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab2JUO71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 10:59:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58231 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2JUO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 10:59:25 -0400
Message-ID: <50840E3D.1060204@gmail.com>
Date: Sun, 21 Oct 2012 17:01:17 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
CC: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Subject: Re: [PATCH 5/5] Thermal: Add ST-Ericsson db8500 thermal dirver.
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com> <1350387889-15324-6-git-send-email-hongbo.zhang@linaro.com>
In-Reply-To: <1350387889-15324-6-git-send-email-hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hongbo,

On 10/16/2012 01:44 PM, hongbo.zhang wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
> 
> This diver is based on the thermal management framework in thermal_sys.c.
> A thermal zone device is created with the trip points to which cooling
> devices can be bound, the current cooling device is cpufreq, e.g. CPU
> frequency is clipped down to cool the CPU, and other cooling devices can
> be added and bound to the trip points dynamically.
> The platform specific PRCMU interrupts are used to active thermal update
> when trip points are reached.
[...]
> diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
> new file mode 100644
> index 0000000..bb065d4
> --- /dev/null
> +++ b/drivers/thermal/db8500_cpufreq_cooling.c
> @@ -0,0 +1,118 @@
> +/*
> + * db8500_cpufreq_cooling.c - db8500 cpufreq works as cooling device.
> + *
> + * Copyright (C) 2012 ST-Ericsson
> + * Copyright (C) 2012 Linaro Ltd.
> + *
> + * Author: Hongbo Zhang <hognbo.zhang@stericsson.com>

Your e-mail address is misspelled :)

[...]
> diff --git a/drivers/thermal/db8500_thermal.c b/drivers/thermal/db8500_thermal.c
> new file mode 100644
> index 0000000..34dcc52
> --- /dev/null
> +++ b/drivers/thermal/db8500_thermal.c
> @@ -0,0 +1,507 @@
> +/*
> + * db8500_thermal.c - db8500 Thermal Management Implementation
> + *
> + * Copyright (C) 2012 ST-Ericsson
> + * Copyright (C) 2012 Linaro Ltd.
> + *
> + * Author: Hongbo Zhang <hognbo.zhang@stericsson.com>

Misspelled address

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
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/thermal.h>
> +#include <linux/cpu_cooling.h>
> +#include <linux/mfd/dbx500-prcmu.h>
> +#include <linux/platform_data/db8500_thermal.h>
> +
> +#define PRCMU_DEFAULT_MEASURE_TIME 0xFFF
> +#define PRCMU_DEFAULT_LOW_TEMP 0
> +
> +struct db8500_thermal_zone {
> +	struct thermal_zone_device *therm_dev;
> +	struct mutex th_lock;
> +	struct platform_device *thsens_pdev;

This member is set in db8500_thermal_probe(), but is never used. I would
suggest removing it.

> +	struct work_struct therm_work;
> +	struct db8500_thsens_platform_data *trip_tab;
> +	enum thermal_device_mode mode;
> +	enum thermal_trend trend;
> +	unsigned long cur_temp_pseudo;
> +	unsigned int cur_index;
> +	int low_irq;
> +	int high_irq;

Same story as thsens_pdev, low_irq and high_irq are set in
db8500_thermal_probe(), but are never used. Should be removed.

> +};
> +
> +/* Callback to bind cooling device to thermal zone */
> +static int db8500_cdev_bind(struct thermal_zone_device *thermal,
> +			struct thermal_cooling_device *cdev)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	struct db8500_thsens_platform_data *ptrips;
> +	char *cdev_name;
> +	unsigned long max_state, upper, lower;
> +	int i, j, ret;
> +
> +	pzone = (struct db8500_thermal_zone *)thermal->devdata;
> +	ptrips = pzone->trip_tab;
> +
> +	if (!cdev->type)
> +		return -EINVAL;

cdev->type is an array, not a simple pointer, so it cannot be NULL.

> +
> +	ret = -ENODEV;
> +	for (i = 0; i < ptrips->num_trips; i++)
> +		for (j = 0; j < COOLING_DEV_MAX; j++) {
> +			cdev_name = ptrips->trip_points[i].cooling_dev_name[j];
> +			if (!cdev_name)
> +				continue;
> +
> +			if (strcmp(cdev_name, cdev->type))
> +				continue;
> +
> +			cdev->ops->get_max_state(cdev, &max_state);
> +			upper = (i > max_state) ? max_state : i;
> +			lower = (i > max_state) ? max_state : i;

You may want to merge these two lines: upper = lower = ...

> +
> +			ret = thermal_zone_bind_cooling_device(thermal, i,
> +				cdev, upper, lower);
> +			if (ret)
> +				pr_err("Error binding cooling device.\n");
> +			else
> +				pr_info("Cdev %s bound.\n", cdev->type);
> +		}
> +
> +	return ret;
> +}
> +
> +/* Callback to unbind cooling device from thermal zone */
> +static int db8500_cdev_unbind(struct thermal_zone_device *thermal,
> +			  struct thermal_cooling_device *cdev)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	struct db8500_thsens_platform_data *ptrips;
> +	char *cdev_name;
> +	int i, j, ret;
> +
> +	pzone = (struct db8500_thermal_zone *)thermal->devdata;
> +	ptrips = pzone->trip_tab;
> +
> +	if (!cdev->type)
> +		return -EINVAL;

cdev->type cannot be NULL.

> +
> +	ret = -ENODEV;
> +	for (i = 0; i < ptrips->num_trips; i++)
> +		for (j = 0; j < COOLING_DEV_MAX; j++) {
> +			cdev_name = ptrips->trip_points[i].cooling_dev_name[j];
> +			if (!cdev_name)
> +				continue;
> +
> +			if (strcmp(cdev_name, cdev->type))
> +				continue;
> +
> +			ret = thermal_zone_unbind_cooling_device(
> +				thermal, i, cdev);
> +			if (ret)
> +				pr_err("Error unbinding cooling device.\n");
> +			else
> +				pr_info("Cdev %s unbound.\n", cdev->type);
> +		}
> +
> +	return ret;
> +}
> +
> +/* Callback to get current temperature */
> +static int db8500_sys_get_temp(struct thermal_zone_device *thermal,
> +				  unsigned long *temp)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	pzone = (struct db8500_thermal_zone *)thermal->devdata;
> +
> +	/* TODO: There is no PRCMU interface to get temperature data currently,
> +	so a pseudo temperature is returned , it works for the thermal framework
> +	and this will be fixed when the PRCMU interface is available */
> +	*temp = pzone->cur_temp_pseudo;
> +
> +	return 0;
> +}
> +
> +/* Callback to get temperature changing trend */
> +static int db8500_sys_get_trend(struct thermal_zone_device *thermal,
> +			int trip, enum thermal_trend *trend)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	pzone = (struct db8500_thermal_zone *)thermal->devdata;
> +
> +	*trend = pzone->trend;
> +
> +	return 0;
> +}
> +
> +/* Callback to get thermal zone mode */
> +static int db8500_sys_get_mode(struct thermal_zone_device *thermal,
> +			    enum thermal_device_mode *mode)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	pzone = (struct db8500_thermal_zone *)thermal->devdata;
> +
> +	mutex_lock(&pzone->th_lock);
> +	*mode = pzone->mode;
> +	mutex_unlock(&pzone->th_lock);
> +
> +	return 0;
> +}
> +
> +/* Callback to set thermal zone mode */
> +static int db8500_sys_set_mode(struct thermal_zone_device *thermal,
> +			enum thermal_device_mode mode)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	struct thermal_zone_device *pthdev;
> +
> +	pzone = (struct db8500_thermal_zone *)thermal->devdata;
> +	pthdev = pzone->therm_dev;
> +
> +	if (!pthdev) {
> +		pr_err("Thermal zone not registered.\n");
> +		return 0;
> +	}

If this function is called, you are sure the thermal zone has been
registered.

> +
> +	mutex_lock(&pzone->th_lock);
> +
> +	pzone->mode = mode;
> +
> +	if (mode == THERMAL_DEVICE_ENABLED)
> +		schedule_work(&pzone->therm_work);
> +
> +	mutex_unlock(&pzone->th_lock);
> +
> +	return 0;
> +}
> +
> +/* Callback to get trip point type */
> +static int db8500_sys_get_trip_type(struct thermal_zone_device *thermal,
> +				 int trip, enum thermal_trip_type *type)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	struct db8500_thsens_platform_data *ptrips;
> +
> +	pzone = (struct db8500_thermal_zone *)thermal->devdata;
> +	ptrips = pzone->trip_tab;
> +
> +	if (trip >= ptrips->num_trips)
> +		return -EINVAL;
> +
> +	*type = ptrips->trip_points[trip].type;
> +
> +	return 0;
> +}
> +
> +/* Callback to get trip point temperature */
> +static int db8500_sys_get_trip_temp(struct thermal_zone_device *thermal,
> +				 int trip, unsigned long *temp)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	struct db8500_thsens_platform_data *ptrips;
> +
> +	pzone = (struct db8500_thermal_zone *)thermal->devdata;
> +	ptrips = pzone->trip_tab;
> +
> +	if (trip >= ptrips->num_trips)
> +		return -EINVAL;
> +
> +	*temp = ptrips->trip_points[trip].temp;
> +
> +	return 0;
> +}
> +
> +/* Callback to get critical trip point temperature */
> +static int db8500_sys_get_crit_temp(struct thermal_zone_device *thermal,
> +				 unsigned long *temp)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	struct db8500_thsens_platform_data *ptrips;
> +	int i;
> +
> +	pzone = (struct db8500_thermal_zone *)thermal->devdata;
> +	ptrips = pzone->trip_tab;
> +
> +	for (i = (ptrips->num_trips - 1); i > 0; i--) {
> +		if (ptrips->trip_points[i].type == THERMAL_TRIP_CRITICAL) {
> +			*temp = ptrips->trip_points[i].temp;
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static struct thermal_zone_device_ops thdev_ops = {
> +	.bind = db8500_cdev_bind,
> +	.unbind = db8500_cdev_unbind,
> +	.get_temp = db8500_sys_get_temp,
> +	.get_trend = db8500_sys_get_trend,
> +	.get_mode = db8500_sys_get_mode,
> +	.set_mode = db8500_sys_set_mode,
> +	.get_trip_type = db8500_sys_get_trip_type,
> +	.get_trip_temp = db8500_sys_get_trip_temp,
> +	.get_crit_temp = db8500_sys_get_crit_temp,
> +};
> +
> +static irqreturn_t prcmu_low_irq_handler(int irq, void *irq_data)
> +{
> +	struct db8500_thermal_zone *pzone = irq_data;
> +	struct db8500_thsens_platform_data *ptrips;
> +	unsigned long next_low, next_high;
> +	unsigned int idx;
> +
> +	ptrips = pzone->trip_tab;
> +	idx = pzone->cur_index;
> +	if (unlikely(idx == 0))
> +		/* Meaningless for thermal management, ignoring it */
> +		return IRQ_HANDLED;
> +
> +	if (idx == 1) {
> +		next_high = ptrips->trip_points[0].temp;
> +		next_low = PRCMU_DEFAULT_LOW_TEMP;
> +	} else {
> +		next_high = ptrips->trip_points[idx-1].temp;
> +		next_low = ptrips->trip_points[idx-2].temp;
> +	}
> +
> +	pzone->cur_index -= 1;
> +	pzone->cur_temp_pseudo = (next_high + next_low)/2;
> +
> +	prcmu_stop_temp_sense();
> +	prcmu_config_hotmon((u8)(next_low/1000), (u8)(next_high/1000));
> +	prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
> +
> +	pr_debug("PRCMU set max %ld, set min %ld\n", next_high, next_low);
> +
> +	pzone->trend = THERMAL_TREND_DROPPING;
> +	schedule_work(&pzone->therm_work);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t prcmu_high_irq_handler(int irq, void *irq_data)
> +{
> +	struct db8500_thermal_zone *pzone = irq_data;
> +	struct db8500_thsens_platform_data *ptrips;
> +	unsigned long next_low, next_high;
> +	unsigned int idx;
> +
> +	ptrips = pzone->trip_tab;
> +	idx = pzone->cur_index;
> +
> +	if (idx < ptrips->num_trips - 1) {
> +		next_high = ptrips->trip_points[idx+1].temp;
> +		next_low = ptrips->trip_points[idx].temp;
> +
> +		pzone->cur_index += 1;
> +		pzone->cur_temp_pseudo = (next_high + next_low)/2;
> +
> +		prcmu_stop_temp_sense();
> +		prcmu_config_hotmon((u8)(next_low/1000), (u8)(next_high/1000));
> +		prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
> +
> +		pr_debug("PRCMU set max %ld, min %ld\n", next_high, next_low);
> +	}
> +
> +	if (idx == ptrips->num_trips - 1)

} else if ()

> +		pzone->cur_temp_pseudo = ptrips->trip_points[idx].temp + 1;
> +
> +	pzone->trend = THERMAL_TREND_RAISING;
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
> +	if (cur_mode == THERMAL_DEVICE_DISABLED) {
> +		pr_warn("Warning: thermal function disabled.\n");
> +		return;
> +	}
> +
> +	thermal_zone_device_update(pzone->therm_dev);
> +	pr_debug("db8500_thermal_work finished.\n");
> +}
> +
> +static int __devinit db8500_thermal_probe(struct platform_device *pdev)
> +{
> +	struct db8500_thermal_zone *pzone = NULL;
> +	struct db8500_thsens_platform_data *ptrips;
> +	int low_irq, high_irq, ret = 0;
> +	unsigned long dft_low, dft_high;
> +
> +	pzone = devm_kzalloc(&pdev->dev,
> +			sizeof(struct db8500_thermal_zone), GFP_KERNEL);
> +	if (!pzone)
> +		return -ENOMEM;
> +
> +	pzone->thsens_pdev = pdev;
> +
> +	low_irq = platform_get_irq_byname(pdev, "IRQ_HOTMON_LOW");
> +	if (low_irq < 0) {
> +		pr_err("Get IRQ_HOTMON_LOW failed.\n");
> +		return low_irq;
> +	}
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, low_irq, NULL,
> +		prcmu_low_irq_handler,
> +		IRQF_NO_SUSPEND | IRQF_ONESHOT, "dbx500_temp_low", pzone);
> +	if (ret < 0) {
> +		pr_err("Failed to allocate temp low irq.\n");
> +		return ret;
> +	}
> +
> +	high_irq = platform_get_irq_byname(pdev, "IRQ_HOTMON_HIGH");
> +	if (high_irq < 0) {
> +		pr_err("Get IRQ_HOTMON_HIGH failed.\n");
> +		return high_irq;
> +	}
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, high_irq, NULL,
> +		prcmu_high_irq_handler,
> +		IRQF_NO_SUSPEND | IRQF_ONESHOT, "dbx500_temp_high", pzone);
> +	if (ret < 0) {
> +		pr_err("Failed to allocate temp high irq.\n");
> +		return ret;
> +	}
> +
> +	pzone->low_irq = low_irq;
> +	pzone->high_irq = high_irq;
> +
> +	pzone->mode = THERMAL_DEVICE_DISABLED;
> +
> +	mutex_init(&pzone->th_lock);
> +
> +	INIT_WORK(&pzone->therm_work, db8500_thermal_work);
> +
> +	ptrips = pdev->dev.platform_data;
> +	pzone->trip_tab = ptrips;
> +
> +	pzone->therm_dev = thermal_zone_device_register("db8500_thermal_zone",
> +		ptrips->num_trips, 0, pzone, &thdev_ops, 0, 0);
> +
> +	if (IS_ERR(pzone->therm_dev)) {
> +		pr_err("Failed to register thermal zone device\n");
> +		return PTR_ERR(pzone->therm_dev);
> +	}
> +
> +	dft_low = PRCMU_DEFAULT_LOW_TEMP;
> +	dft_high = ptrips->trip_points[0].temp;
> +
> +	prcmu_stop_temp_sense();
> +	prcmu_config_hotmon((u8)(dft_low/1000), (u8)(dft_high/1000));
> +	prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
> +
> +	pzone->cur_index = 0;
> +	pzone->cur_temp_pseudo = (dft_low + dft_high)/2;
> +	pzone->trend = THERMAL_TREND_STABLE;

All the stuff from prcmu_stop_temp_sense() up to this line can race with
the irq handlers, I would suggest doing it before requesting the irqs.

> +	pzone->mode = THERMAL_DEVICE_ENABLED;

Shouldn't this be protected by pzone->th_lock? Otherwise it should be
set before the thermal zone is registered.

> +
> +	platform_set_drvdata(pdev, pzone);
> +
> +	return 0;
> +}
> +
> +static int __devexit db8500_thermal_remove(struct platform_device *pdev)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	pzone = platform_get_drvdata(pdev);
> +
> +	cancel_work_sync(&pzone->therm_work);
> +
> +	if (pzone->therm_dev)
> +		thermal_zone_device_unregister(pzone->therm_dev);
> +
> +	return 0;
> +}

mutex_destroy() should be called on pzone->th_lock

> +
> +static int db8500_thermal_suspend(struct platform_device *pdev,
> +		pm_message_t state)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	pzone = platform_get_drvdata(pdev);
> +
> +	flush_work_sync(&pzone->therm_work);
> +	prcmu_stop_temp_sense();
> +
> +	return 0;
> +}
> +
> +static int db8500_thermal_resume(struct platform_device *pdev)
> +{
> +	struct db8500_thermal_zone *pzone;
> +	struct db8500_thsens_platform_data *ptrips;
> +	unsigned long dft_low, dft_high;
> +
> +	pzone = platform_get_drvdata(pdev);
> +	ptrips = pzone->trip_tab;
> +	dft_low = PRCMU_DEFAULT_LOW_TEMP;
> +	dft_high = ptrips->trip_points[0].temp;
> +
> +	prcmu_config_hotmon((u8)(dft_low/1000), (u8)(dft_high/1000));
> +	prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);

Shouldn't cur_index and cur_temp_pseudo be updated as well? You may want
to define a helper function with all the code shared by irq handlers
(both high and low), probe and resume.

> +
> +	return 0;
> +}
[...]
> diff --git a/include/linux/platform_data/db8500_thermal.h b/include/linux/platform_data/db8500_thermal.h
> new file mode 100644
> index 0000000..0b6d164
> --- /dev/null
> +++ b/include/linux/platform_data/db8500_thermal.h
> @@ -0,0 +1,39 @@
> +/*
> + * db8500_thermal.h - db8500 Thermal Management Implementation
> + *
> + * Copyright (C) 2012 ST-Ericsson
> + * Copyright (C) 2012 Linaro Ltd.
> + *
> + * Author: Hongbo Zhang <hognbo.zhang@stericsson.com>

Misspelled address

--
Francesco
