Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2LYIiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 03:38:14 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1603 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2LYIiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 03:38:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 25 Dec 2012 00:35:09 -0800
Message-ID: <50D965F1.6000806@nvidia.com>
Date: Tue, 25 Dec 2012 16:38:09 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Durgadoss R <durgadoss.r@intel.com>
CC: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>
Subject: Re: [PATCH 8/8] Thermal: Dummy driver used for testing
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com> <1355822977-4804-9-git-send-email-durgadoss.r@intel.com>
In-Reply-To: <1355822977-4804-9-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 05:29 PM, Durgadoss R wrote:
> This patch has a dummy driver that can be used for
> testing purposes. This patch is not for merge.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> ---
>  drivers/thermal/Kconfig        |    5 +
>  drivers/thermal/Makefile       |    3 +
>  drivers/thermal/thermal_test.c |  315 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 323 insertions(+)
>  create mode 100644 drivers/thermal/thermal_test.c
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index c5ba3340..3b92a76 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -136,4 +136,9 @@ config DB8500_CPUFREQ_COOLING
>  	  bound cpufreq cooling device turns active to set CPU frequency low to
>  	  cool down the CPU.
>  
> +config THERMAL_TEST
> +	tristate "test driver"
> +	help
> +	  Enable this to test the thermal framework.
> +
>  endif
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index d8da683..02c3edb 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -18,3 +18,6 @@ obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
>  obj-$(CONFIG_EXYNOS_THERMAL)	+= exynos_thermal.o
>  obj-$(CONFIG_DB8500_THERMAL)	+= db8500_thermal.o
>  obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+= db8500_cpufreq_cooling.o
> +
> +# dummy driver for testing
> +obj-$(CONFIG_THERMAL_TEST)	+= thermal_test.o
> diff --git a/drivers/thermal/thermal_test.c b/drivers/thermal/thermal_test.c
> new file mode 100644
> index 0000000..5a11e34
> --- /dev/null
> +++ b/drivers/thermal/thermal_test.c
> @@ -0,0 +1,315 @@
> +/*
> + * thermal_test.c - This driver can be used to test Thermal
> + *			   Framework changes. Not specific to any
> + *			   platform. Fills the log buffer generously ;)
> + *
> + * Copyright (C) 2012 Intel Corporation
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + * Author: Durgadoss R <durgadoss.r@intel.com>
> + */
> +
> +#define pr_fmt(fmt)  "thermal_test: " fmt
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/param.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/pm.h>
> +#include <linux/platform_device.h>
> +#include <linux/thermal.h>
> +
> +#define MAX_THERMAL_ZONES	2
> +#define MAX_THERMAL_SENSORS	2
> +#define MAX_COOLING_DEVS	4
> +#define NUM_THRESHOLDS		3
> +
> +static struct ts_data {
> +	int curr_temp;
> +	int flag;
> +} ts_data;
> +
> +int active_trips[10] = {100, 90, 80, 70, 60, 50, 40, 30, 20, 10};
> +int passive_trips[5] = {100, 90, 60, 50, 40};
> +
> +static struct platform_device *pdev;
> +static unsigned long cur_cdev_state = 2;
> +static struct thermal_sensor *ts, *ts1;
> +static struct thermal_zone *tz;
> +static struct thermal_cooling_device *cdev;
> +
> +static long thermal_thresholds[NUM_THRESHOLDS] = {30000, 40000, 50000};
> +
> +static struct thermal_trip_point trip = {
> +	.hot = 90,
> +	.crit = 100,
> +	.num_passive_trips = 5,
> +	.passive_trips = passive_trips,
> +	.num_active_trips = 10,
> +	.active_trips = active_trips,
> +	.active_trip_mask = 0xCFF,
> +};
> +
> +static struct thermal_trip_point trip1 = {
> +	.hot = 95,
> +	.crit = 125,
> +	.num_passive_trips = 0,
> +	.passive_trips = passive_trips,
> +	.num_active_trips = 6,
> +	.active_trips = active_trips,
> +	.active_trip_mask = 0xFF,
> +};
> +
> +static int read_cur_state(struct thermal_cooling_device *cdev,
> +			unsigned long *state)
> +{
> +	*state = cur_cdev_state;
> +	return 0;
> +}
> +
> +static int write_cur_state(struct thermal_cooling_device *cdev,
> +			unsigned long state)
> +{
> +	cur_cdev_state = state;
> +	return 0;
> +}
> +
> +static int read_max_state(struct thermal_cooling_device *cdev,
> +			unsigned long *state)
> +{
> +	*state = 5;
> +	return 0;
> +}
> +
> +static int read_curr_temp(struct thermal_sensor *ts, long *temp)
> +{
> +	*temp = ts_data.curr_temp;
> +	return 0;
> +}
> +
> +static ssize_t
> +flag_show(struct device *dev, struct device_attribute *devattr, char *buf)
> +{
> +	return sprintf(buf, "%d\n", ts_data.flag);
> +}
> +
> +static ssize_t
> +flag_store(struct device *dev, struct device_attribute *attr,
> +		    const char *buf, size_t count)
> +{
> +	long flag;
> +
> +	if (kstrtol(buf, 10, &flag))
> +		return -EINVAL;
> +
> +	ts_data.flag = flag;
> +
> +	if (flag == 0) {
> +		thermal_sensor_unregister(ts);
> +		ts = NULL;
> +		pr_err("thermal_sensor_unregister (ts) done\n");
> +	} else if (flag == 1) {
> +		thermal_sensor_unregister(ts1);
> +		ts1 = NULL;
> +		pr_err("thermal_sensor_unregister (ts1) done\n");
> +	} else if (flag == 2) {
> +		thermal_cooling_device_unregister(cdev);
> +		cdev = NULL;
> +		pr_err("cdev unregister (cdev) done\n");
> +	} else if (flag == 3) {
> +		if (tz)
> +			remove_thermal_zone(tz);
> +		tz = NULL;
> +		pr_err("removed thermal zone\n");
> +	}
> +
> +	return count;
> +}

What does this flag_show()/flag_store() mean?
I noticed that you didn't call xxx_unregister() in the remove callback.
Do you mean we need to provide these functions in the platform thermal
driver? or this is just for test?

Thanks.
Wei.

> +
> +static ssize_t
> +temp_show(struct device *dev, struct device_attribute *devattr, char *buf)
> +{
> +	return sprintf(buf, "%d\n", ts_data.curr_temp);
> +}
> +
> +static int read_threshold(struct thermal_sensor *ts, int indx, long *val)
> +{
> +	if (indx < 0 || indx >= NUM_THRESHOLDS)
> +		return -EINVAL;
> +
> +	*val = thermal_thresholds[indx];
> +	return 0;
> +}
> +
> +static int write_threshold(struct thermal_sensor *ts, int indx, long val)
> +{
> +	if (indx < 0 || indx >= NUM_THRESHOLDS)
> +		return -EINVAL;
> +
> +	thermal_thresholds[indx] = val;
> +	return 0;
> +}
> +
> +static ssize_t
> +temp_store(struct device *dev, struct device_attribute *attr,
> +		    const char *buf, size_t count)
> +{
> +	long temp;
> +
> +	if (kstrtol(buf, 10, &temp))
> +		return -EINVAL;
> +
> +	ts_data.curr_temp = temp;
> +	return count;
> +}
> +
> +static struct thermal_sensor_ops ts_ops = {
> +	.get_temp = read_curr_temp,
> +	.get_threshold = read_threshold,
> +	.set_threshold = write_threshold,
> +};
> +
> +static struct thermal_sensor_ops ts1_ops = {
> +	.get_temp = read_curr_temp,
> +	.get_threshold = read_threshold,
> +	.set_threshold = write_threshold,
> +};
> +
> +static struct thermal_cooling_device_ops cdev_ops = {
> +	.get_cur_state = read_cur_state,
> +	.set_cur_state = write_cur_state,
> +	.get_max_state = read_max_state,
> +};
> +
> +static DEVICE_ATTR(test_temp, S_IRUGO | S_IWUSR, temp_show, temp_store);
> +static DEVICE_ATTR(sensor_enable, S_IRUGO | S_IWUSR, flag_show, flag_store);
> +
> +static int thermal_test_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	ts_data.curr_temp = 30000;
> +	ts_data.flag = 1;
> +
> +	ts = thermal_sensor_register("ts", NUM_THRESHOLDS, &ts_ops, &ts_data);
> +	if (!ts) {
> +		pr_err("thermal_sensor_register failed:\n");
> +		return -EINVAL;
> +	}
> +
> +	ts1 = thermal_sensor_register("ts1", NUM_THRESHOLDS, &ts1_ops, NULL);
> +
> +	cdev = thermal_cooling_device_register("cdev", NULL, &cdev_ops);
> +	if (!cdev) {
> +		pr_err("cdev_register failed:\n");
> +		return -EINVAL;
> +	}
> +
> +	device_create_file(&pdev->dev, &dev_attr_test_temp);
> +	device_create_file(&pdev->dev, &dev_attr_sensor_enable);
> +
> +	/* Create a zone */
> +	tz = create_thermal_zone("myZone", NULL);
> +	if (!tz) {
> +		pr_err("create_thermal_zone failed:\n");
> +		return -EINVAL;
> +	}
> +
> +	pr_err("Zone created successfully..\n");
> +
> +	ret = add_sensor_to_zone(tz, ts);
> +	if (ret) {
> +		pr_err("add_sensor_to_zone failed:%d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = add_sensor_to_zone(tz, ts1);
> +	pr_err("add_sensor (ts1) ret_val: %d\n", ret);
> +
> +	ret = add_cdev_to_zone(tz, cdev);
> +	pr_err("add_cdev_to_zone (cdev) ret_val: %d\n", ret);
> +
> +	ret = add_sensor_trip_info(tz, ts, &trip);
> +	ret = add_sensor_trip_info(tz, ts1, &trip1);
> +	pr_err("add_sensor_trip_info (ts) ret_val: %d\n", ret);
> +	return 0;
> +}
> +
> +static int thermal_test_remove(struct platform_device *pdev)
> +{
> +	device_remove_file(&pdev->dev, &dev_attr_test_temp);
> +	device_remove_file(&pdev->dev, &dev_attr_sensor_enable);
> +
> +	return 0;
> +}
> +
> +/*********************************************************************
> + *		Driver initialization and finalization
> + *********************************************************************/
> +
> +#define DRIVER_NAME "thermal_test"
> +
> +static const struct platform_device_id therm_id_table[] = {
> +	{ DRIVER_NAME, 1 },
> +};
> +
> +static struct platform_driver thermal_test_driver = {
> +	.driver = {
> +		.name = DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = thermal_test_probe,
> +	.remove = __devexit_p(thermal_test_remove),
> +	.id_table = therm_id_table,
> +};
> +
> +static int __init thermal_test_init(void)
> +{
> +	int ret;
> +
> +	ret = platform_driver_register(&thermal_test_driver);
> +	if (ret) {
> +		pr_err("platform driver register failed:%d\n", ret);
> +		return ret;
> +	}
> +
> +	pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
> +	if (IS_ERR(pdev)) {
> +		ret = PTR_ERR(pdev);
> +		pr_err("platform device register failed:%d\n", ret);
> +		platform_driver_unregister(&thermal_test_driver);
> +	}
> +
> +	return ret;
> +}
> +
> +static void __exit thermal_test_exit(void)
> +{
> +	pr_err("in thermal_test_exit\n");
> +	platform_device_unregister(pdev);
> +	platform_driver_unregister(&thermal_test_driver);
> +}
> +
> +module_init(thermal_test_init);
> +module_exit(thermal_test_exit);
> +
> +MODULE_AUTHOR("Durgadoss R <durgadoss.r@intel.com>");
> +MODULE_DESCRIPTION("A dummy driver to test Thermal Framework");
> +MODULE_LICENSE("GPL");
> 

