Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab2EIJ04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:26:56 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41710 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758941Ab2EIJ0x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:26:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120508131637.a2f59904.akpm@linux-foundation.org>
References: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-2-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-3-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-4-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-5-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-6-git-send-email-amit.kachhap@linaro.org>
	<20120508131637.a2f59904.akpm@linux-foundation.org>
Date: Wed, 9 May 2012 14:56:51 +0530
Message-ID: <CAK44p20481BR0QBmh=Hgkc-3A=AmFypdM1UpK95VHsaJcOuw7g@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] thermal: exynos: Register the tmu sensor with the
 kernel thermal layer
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm@lists.linux-foundation.org, durgadoss.r@intel.com,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2012 01:46, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue,  8 May 2012 21:48:17 +0530
> Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:
>
>> This code added creates a link between temperature sensors, linux thermal
>> framework and cooling devices for samsung exynos platform. This layer
>> monitors the temperature from the sensor and informs the generic thermal
>> layer to take the necessary cooling action.
>>
>>
>> ...
>>
>> +static void exynos_report_trigger(void)
>> +{
>> +     unsigned int i;
>> +     char data[2];
>> +     char *envp[] = { data, NULL };
>> +
>> +     if (!th_zone || !th_zone->therm_dev)
>> +             return;
>> +
>> +     thermal_zone_device_update(th_zone->therm_dev);
>> +
>> +     mutex_lock(&th_zone->therm_dev->lock);
>> +     /* Find the level for which trip happened */
>> +     for (i = 0; i < th_zone->sensor_conf->trip_data.trip_count; i++) {
>> +             if (th_zone->therm_dev->last_temperature <
>> +                     th_zone->sensor_conf->trip_data.trip_val[i] * 1000)
>> +                     break;
>> +     }
>> +
>> +     if (th_zone->mode == THERMAL_DEVICE_ENABLED) {
>> +             if (i > 0)
>> +                     th_zone->therm_dev->polling_delay = ACTIVE_INTERVAL;
>> +             else
>> +                     th_zone->therm_dev->polling_delay = IDLE_INTERVAL;
>> +     }
>> +
>> +     sprintf(data, "%u", i);
>
> yikes, if `i' exceeds 9, we have a stack scribble.  Please review this
> and at least use snprintf(...  sizeof(data)) to prevent accidents.
Ok
>
>
>> +     kobject_uevent_env(&th_zone->therm_dev->device.kobj, KOBJ_CHANGE, envp);
>> +     mutex_unlock(&th_zone->therm_dev->lock);
>> +}
>> +
>>
>> ...
>>
>> +/* Get trip temperature callback functions for thermal zone */
>> +static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>> +                             unsigned long *temp)
>> +{
>> +     if (trip < 0 || trip > 2)
>
> I don't know what `trip' does and I don't know the meaning of the
> values 0, 1 and 2.  Documentation, please.
Agreed will put their description.
>
>> +             return -EINVAL;
>> +
>> +     *temp = th_zone->sensor_conf->trip_data.trip_val[trip];
>> +     /* convert the temperature into millicelsius */
>> +     *temp = *temp * 1000;
>> +
>> +     return 0;
>> +}
>> +
>>
>> ...
>>
>> +/* Bind callback functions for thermal zone */
>> +static int exynos_bind(struct thermal_zone_device *thermal,
>> +                     struct thermal_cooling_device *cdev)
>> +{
>> +     int ret = 0;
>> +
>> +     /* if the cooling device is the one from exynos4 bind it */
>> +     if (cdev != th_zone->cool_dev[0])
>> +             return 0;
>> +
>> +     if (thermal_zone_bind_cooling_device(thermal, 0, cdev)) {
>> +             pr_err("error binding cooling dev inst 0\n");
>> +             return -EINVAL;
>> +     }
>> +     if (thermal_zone_bind_cooling_device(thermal, 1, cdev)) {
>> +             pr_err("error binding cooling dev inst 1\n");
>> +             ret = -EINVAL;
>> +             goto error_bind1;
>> +     }
>
> There can never be more than two instances?
As of now it is fixed as we register only 2 zones
>
>> +     return ret;
>> +error_bind1:
>> +     thermal_zone_unbind_cooling_device(thermal, 0, cdev);
>> +     return ret;
>> +}
>> +
>>
>> ...
>>
>> +/* Get temperature callback functions for thermal zone */
>> +static int exynos_get_temp(struct thermal_zone_device *thermal,
>> +                     unsigned long *temp)
>> +{
>> +     void *data;
>> +
>> +     if (!th_zone->sensor_conf) {
>> +             pr_info("Temperature sensor not initialised\n");
>> +             return -EINVAL;
>> +     }
>> +     data = th_zone->sensor_conf->private_data;
>> +     *temp = th_zone->sensor_conf->read_temperature(data);
>> +     /* convert the temperature into millicelsius */
>> +     *temp = *temp * 1000;
>> +     return 0;
>> +}
>> +
>> +/* Operation callback functions for thermal zone */
>> +static struct thermal_zone_device_ops exynos_dev_ops = {
>
> Can it be const?  That sometimes saves space, as the table doesn't need
> to be moved into writeable storage at runtime.
Yes it can be made const
>
>> +     .bind = exynos_bind,
>> +     .unbind = exynos_unbind,
>> +     .get_temp = exynos_get_temp,
>> +     .get_mode = exynos_get_mode,
>> +     .set_mode = exynos_set_mode,
>> +     .get_trip_type = exynos_get_trip_type,
>> +     .get_trip_temp = exynos_get_trip_temp,
>> +     .get_crit_temp = exynos_get_crit_temp,
>> +};
>> +
>> +/* Register with the in-kernel thermal management */
>> +static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
>> +{
>> +     int ret, count, tab_size;
>> +     struct freq_clip_table *tab_ptr;
>> +
>> +     if (!sensor_conf || !sensor_conf->read_temperature) {
>> +             pr_err("Temperature sensor not initialised\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     th_zone = kzalloc(sizeof(struct exynos_thermal_zone), GFP_KERNEL);
>> +     if (!th_zone) {
>> +             ret = -ENOMEM;
>> +             goto err_unregister;
>
> This seems wrong?  If we need to call exynos_unregister_thermal() on
> this error path then we needed to call it on the predecing one?
> Perhaps?
ok my fault.
>
>> +     }
>> +
>> +     th_zone->sensor_conf = sensor_conf;
>> +
>> +     tab_ptr = (struct freq_clip_table *)sensor_conf->cooling_data.freq_data;
>> +     tab_size = sensor_conf->cooling_data.freq_clip_count;
>> +
>> +     /* Register the cpufreq cooling device */
>> +     th_zone->cool_dev_size = 1;
>> +     count = 0;
>> +     th_zone->cool_dev[count] = cpufreq_cooling_register(
>> +                     (struct freq_clip_table *)&(tab_ptr[count]),
>> +                     tab_size, cpumask_of(0));
>> +
>> +     if (IS_ERR(th_zone->cool_dev[count])) {
>> +             pr_err("Failed to register cpufreq cooling device\n");
>> +             ret = -EINVAL;
>> +             th_zone->cool_dev_size = 0;
>> +             goto err_unregister;
>> +     }
>> +
>> +     th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
>> +                     3, NULL, &exynos_dev_ops, 0, 0, 0, IDLE_INTERVAL);
>> +
>> +     if (IS_ERR(th_zone->therm_dev)) {
>> +             pr_err("Failed to register thermal zone device\n");
>> +             ret = -EINVAL;
>> +             goto err_unregister;
>> +     }
>> +     th_zone->mode = THERMAL_DEVICE_ENABLED;
>> +
>> +     pr_info("Exynos: Kernel Thermal management registered\n");
>> +
>> +     return 0;
>> +
>> +err_unregister:
>> +     exynos_unregister_thermal();
>> +     return ret;
>> +}
>> +
>>
>> ...
>>
>
