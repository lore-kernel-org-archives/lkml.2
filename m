Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab1EZORn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:17:43 -0400
Received: from imr4.ericy.com ([198.24.6.8]:41318 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372Ab1EZORm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:17:42 -0400
Date: Thu, 26 May 2011 07:16:52 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Dajun Chen <Dajun.Chen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCHv3 6/11] HWMON: Support of fixed point conversion for
 bat temperature
Message-ID: <20110526141652.GA29634@ericsson.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BF303C2@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BF303C2@KCINPUNHJCMS01.kpit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:19:12AM -0400, Ashish Jangam wrote:
> Hi Guenter,
> 
> Existing fixed point conversion logic is modified to support battery temperature. This modified logic was compiled, linked & tested successfully.
> 
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> --
> diff --git a/Documentation/hwmon/da9052 b/Documentation/hwmon/da9052
> new file mode 100755
> index 0000000..aab7318
> --- /dev/null
> +++ b/Documentation/hwmon/da9052
> @@ -0,0 +1,61 @@
> +Kernel driver da9052-hwmon
> +==========================
> +
> +Supported chips:
> +  * Dialog Semiconductors DA9052 PMICs
> +    Prefix: 'da9052'
> +    Datasheet: Kindly visit www.dialog-semiconductor.com and request for the
> +               official datasheet.
> +
> +Authors: David Dajun Chen <dchen@diasemi.com>
> +
> +Description
> +-----------
> +
> +The DA9052 provides an Analogue to Digital Converter (ADC) with 10 bits
> +resolution and track and hold circuitry combined with an analogue input
> +multiplexer. The analogue input multiplexer will allow conversion of up to 10
> +different inputs. The track and hold circuit ensures stable input voltages at
> +the input of the ADC during the conversion.
> +
> +The ADC is used to measure the following inputs:
> +Channel 0: VDDOUT - measurement of the system voltage
> +Channel 1: ICH - internal battery charger current measurement
> +Channel 2: TBAT - output from the battery NTC
> +Channel 3: VBAT - measurement of the battery voltage
> +Channel 4: ADC_IN4 - high impedance input (0 - 2.5V)
> +Channel 5: ADC_IN5 - high impedance input (0 - 2.5V)
> +Channel 6: ADC_IN6 - high impedance input (0 - 2.5V)
> +Channel 7: XY - TSI interface to measure the X and Y voltage of the touch
> +screen resistive potentiometers
> +Channel 8: Internal Tjunc. - sense (internal temp. sensor)
> +Channel 9: VBBAT - measurement of the backup battery voltage
> +
> +By using sysfs attributes we can measure the system voltage VDDOUT, the battery
> +charging current ICH, battery temperature TBAT, battery junction temperature
> +TJUNC, battery voltage VBAT and the back up battery voltage VBBAT.
> +
> +Voltage Monitoring
> +------------------
> +
> +Voltages are sampled by a 10 bit ADC.  Voltages in millivolts are 1.465
> +times the ADC value.
> +
> +Temperature Monitoring
> +----------------------
> +
> +Temperatures are sampled by a 10 bit ADC.  Junction and battery temperatures
> +are monitored by the ADC channels.
> +
> +The junction temperature is calculated:
> +       Degrees celsius = 1.708 * (TJUNC_RES - T_OFFSET) - 108.8
> +The junction temperature attribute is supported by the driver.
> +
> +The battery temperature is calculated:
> +       Degree Celcius = 1 / (t1 + 1/298)- 273
> +where t1 = (1/B)* ln(( ADCval * 2.5)/(R25*ITBAT*255))
> +Default values of R25, B, ITBAT are 10e3, 3380 and 50e-6 respectively.
> +As the battery temperature computation depends on floating point
> +computation and taking natural log the battery temperature attribute is
> +not supported by the driver.
> +
The last three lines no longer apply.

> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 3236a45..da5ff6d 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -303,6 +303,16 @@ config SENSORS_DS1621
>           This driver can also be built as a module.  If so, the module
>           will be called ds1621.
> 
> +config SENSORS_DA9052_ADC
> +        tristate "Dialog DA9052 HWMON"
> +        depends on PMIC_DA9052
> +        help
> +          Say y here to support the ADC found on
> +          Dialog Semiconductor DA9052 PMIC.
> +
> +          This driver can also be built as module. If so, the module
> +          will be called da9052-hwmon.
> +
>  config SENSORS_I5K_AMB
>         tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
>         depends on PCI && EXPERIMENTAL
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index f7c0c28..88b81ca 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -42,6 +42,7 @@ obj-$(CONFIG_SENSORS_ASC7621) += asc7621.o
>  obj-$(CONFIG_SENSORS_ATXP1)    += atxp1.o
>  obj-$(CONFIG_SENSORS_CORETEMP) += coretemp.o
>  obj-$(CONFIG_SENSORS_PKGTEMP)  += pkgtemp.o
> +obj-$(CONFIG_SENSORS_DA9052_ADC)       += da9052-hwmon.o
>  obj-$(CONFIG_SENSORS_DME1737)  += dme1737.o
>  obj-$(CONFIG_SENSORS_DS620)    += ds620.o
>  obj-$(CONFIG_SENSORS_DS1621)   += ds1621.o
> diff --git a/drivers/hwmon/da9052-hwmon.c b/drivers/hwmon/da9052-hwmon.c
> new file mode 100755
> index 0000000..f961d0b
> --- /dev/null
> +++ b/drivers/hwmon/da9052-hwmon.c
> @@ -0,0 +1,379 @@
> +/*
> + * HWMON Driver for Dialog DA9052
> + *
> + * Copyright(c) 2011 Dialog Semiconductor Ltd.
> + *
> + * Author: David Dajun Chen <dchen@diasemi.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/log2.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/reg.h>
> +
> +struct da9052_hwmon {
> +       struct da9052   *da9052;
> +       struct device   *class_device;
> +       struct mutex    hwmon_lock;
> +};
> +static const char * const input_names[] = {
> +       [DA9052_ADC_VDDOUT]     =       "VDDOUT",
> +       [DA9052_ADC_ICH]        =       "CHARGING CURRENT",
> +       [DA9052_ADC_TBAT]       =       "BATTERY TEMP",
> +       [DA9052_ADC_VBAT]       =       "BATTERY VOLTAGE",
> +       [DA9052_ADC_IN4]        =       "ADC IN4",
> +       [DA9052_ADC_IN5]        =       "ADC IN5",
> +       [DA9052_ADC_IN6]        =       "ADC IN6",
> +       [DA9052_ADC_TJUNC]      =       "BATTERY JUNCTION TEMP",
> +       [DA9052_ADC_VBBAT]      =       "BACK-UP BATTERY VOLTAGE",
> +};
> +
> +static int da9052_enable_vddout_channel(struct da9052 *da9052)
> +{
> +       int ret;
> +
> +       ret = da9052_reg_read(da9052, DA9052_ADC_CONT_REG);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret |= DA9052_ADCCONT_AUTOVDDEN;
> +       return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
> +}
> +
> +static int da9052_disable_vddout_channel(struct da9052 *da9052)
> +{
> +       int ret;
> +
> +       ret = da9052_reg_read(da9052, DA9052_ADC_CONT_REG);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret &= ~DA9052_ADCCONT_AUTOVDDEN;
> +       return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
> +
> +}
> +
> +static ssize_t da9052_read_vddout(struct device *dev,
> +       struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret;
> +       int vdd = -1;
> +
> +       mutex_lock(&hwmon->hwmon_lock);
> +
> +       ret = da9052_enable_vddout_channel(hwmon->da9052);
> +       if (ret < 0)
> +               goto hwmon_err;
> +
> +       ret = da9052_reg_read(hwmon->da9052, DA9052_VDD_RES_REG);
> +       if (ret < 0)
> +               pr_err("failed to read VDD_RES_REG\n");
> +       else
> +               vdd = ret;
> +
This is a bit misleading, and wrong. There are other cases where you don't
actually read VDD (if you fail to enable the channel), but then you actually return
an error. I think you should just go with

	if (ret < 0)
		goto hwmon_err;
	vdd = ret;

and, if you really want to be noisy, add the pr_err() into the error path.

> +       ret = da9052_disable_vddout_channel(hwmon->da9052);
> +       if (ret < 0)
> +               goto hwmon_err;
> +
> +       if (vdd) {
> +               mutex_unlock(&hwmon->hwmon_lock);
> +               return sprintf(buf, "%d\n", vdd);
> +       }

No good. You end up returning 0 (because ret == 0), ie no error, but don't 
display a value. You would have to set ret = -ESOMETHING here. But is VDD==0
really an error, or does it just mean that the voltage is zero ?

> +hwmon_err:
> +       mutex_unlock(&hwmon->hwmon_lock);
> +       return ret;
> +}
> +
> +static ssize_t da9052_read_ich(struct device *dev,
> +       struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret;
> +
> +       ret = da9052_reg_read(hwmon->da9052, DA9052_ICHG_AV_REG);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* Equivalent to 3.9mA/bit in register ICHG_AV */
> +       ret = DIV_ROUND_CLOSEST(ret * 39, 10);
> +       return sprintf(buf, "%d\n", ret);
> +}
> +
> +#define BCONST         3
> +#define TBAT           3355705
> +#define CAL_LOG2(nr) ((int)((ilog2(nr) - ilog2(100)) * 693147181LL))
> +/*
> +       The battery temperature is calculated:
> +       Degree Celcius = 1 / (t1 + 1/298)- 273
> +       where t1 = (1/B)* ln((ADCval * 2.5)/(R25*ITBAT*255))
> +       And R25 = 10e3, B = 3380 and ITBAT = 50e-6
> +*/

Please use
	/*
	 *
	 */
for multi-line comments.

> +static int cal_temperature(int adc_val)
> +{
> +
> +       int log_val;
> +       unsigned int temp, deg_celcius;
> +
> +       /* Formula 2.5/(R25*ITBAT*255) gets reduced to 0.02
> +        Convert float value to fixed point using a multiplier */
> +       log_val = adc_val * 2;
> +
> +       temp = BCONST * (CAL_LOG2(log_val) * 10000) + TBAT;

This doesn't look good.

As written, CAL_LOG2 together with the additional multiplication
by 10,000 and by 3 must result in an integer overflow.
	693,147,181 * 10,000 * 3 = 20,794,415,430,000
which is way too large for an int.

> +
> +       /* ln(x) = log2(x) * ln(2) = log2(x) * 0.693147181
> +       log2(float) is converted to fixed point as log2(nr) - log2(dr) */

Please use 
	/*
	 *
	 */
for multi-line comments.

> +       deg_celcius = ((1000000000/temp) - 273);
> +
> +       /* Battery temperature in degree celcius */
> +       return deg_celcius;
> +}
> +
> +static ssize_t da9052_read_tbat(struct device *dev,
> +                       struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret;
> +       int tbat;
> +
> +       ret = da9052_reg_read(hwmon->da9052, DA9052_TBAT_RES_REG);
> +       if (ret < 0)
> +               return ret;
> +
> +       tbat = cal_temperature(ret);
> +
> +       return sprintf(buf, "%d\n", (tbat*1000));
> +}
> +
> +static ssize_t da9052_read_vbat(struct device *dev,
> +       struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret;
> +
> +       ret = da9052_adc_manual_read(hwmon->da9052, DA9052_ADC_VBAT);
> +       if (ret < 0)
> +               return ret;
> +
> +       return sprintf(buf, "%d\n", ret);
> +}
> +
> +static ssize_t da9052_read_misc_channel(struct device *dev,
> +       struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int channel = to_sensor_dev_attr(devattr)->index;
> +       int ret;
> +
> +       ret = da9052_adc_manual_read(hwmon->da9052, channel);
> +       if (ret < 0)
> +               return ret;
> +
> +       return sprintf(buf, "%d\n", ret);
> +}
> +
> +static ssize_t da9052_read_tjunc(struct device *dev,
> +       struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int temp;
> +       int ret;
> +
> +       ret = da9052_reg_read(hwmon->da9052, DA9052_TJUNC_RES_REG);
> +       if (ret < 0)
> +               return ret;
> +
> +       temp = ret;
> +
> +       ret = da9052_reg_read(hwmon->da9052, DA9052_T_OFFSET_REG);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* Degrees celsius = 1.708 * (TJUNC_RES - T_OFFSET) - 108.8 */
> +       ret = 1708 * (temp - ret) - 108800;
> +       return sprintf(buf, "%d\n", ret);
> +}
> +
> +static ssize_t da9052_read_vbbat(struct device *dev,
> +       struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret;
> +
> +       ret = da9052_adc_manual_read(hwmon->da9052, DA9052_ADC_VBBAT);
> +       if (ret < 0)
> +               return ret;
> +
> +       return sprintf(buf, "%d\n", ret);
> +
> +}
> +
> +static ssize_t da9052_hwmon_show_name(struct device *dev,
> +               struct device_attribute *devattr, char *buf)
> +{
> +       return sprintf(buf, "da9052-hwmon\n");
> +}
> +
> +static ssize_t show_label(struct device *dev,
> +                         struct device_attribute *devattr, char *buf)
> +{
> +       return sprintf(buf, "%s\n",
> +                       input_names[to_sensor_dev_attr(devattr)->index]);
> +}
> +
> +static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, da9052_read_vddout, NULL,
> +                               DA9052_ADC_ICH);
> +static SENSOR_DEVICE_ATTR(in0_label, S_IRUGO, show_label, NULL,
> +                               DA9052_ADC_ICH);
> +static SENSOR_DEVICE_ATTR(in3_input, S_IRUGO, da9052_read_vbat, NULL,
> +                               DA9052_ADC_VBAT);
> +static SENSOR_DEVICE_ATTR(in3_label, S_IRUGO, show_label, NULL,
> +                               DA9052_ADC_VBAT);
> +static SENSOR_DEVICE_ATTR(in4_input, S_IRUGO, da9052_read_misc_channel, NULL,
> +                               DA9052_ADC_IN4);
> +static SENSOR_DEVICE_ATTR(in4_label, S_IRUGO, show_label, NULL,
> +                               DA9052_ADC_IN4);
> +static SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, da9052_read_misc_channel, NULL,
> +                               DA9052_ADC_IN5);
> +static SENSOR_DEVICE_ATTR(in5_label, S_IRUGO, show_label, NULL,
> +                               DA9052_ADC_IN5);
> +static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, da9052_read_misc_channel, NULL,
> +                               DA9052_ADC_IN6);
> +static SENSOR_DEVICE_ATTR(in6_label, S_IRUGO, show_label, NULL,
> +                               DA9052_ADC_IN6);
> +static SENSOR_DEVICE_ATTR(in9_input, S_IRUGO, da9052_read_vbbat, NULL,
> +                               DA9052_ADC_VBBAT);
> +static SENSOR_DEVICE_ATTR(in9_label, S_IRUGO, show_label, NULL,
> +                               DA9052_ADC_VBBAT);
> +static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, da9052_read_ich, NULL,
> +                               DA9052_ADC_ICH);
> +static SENSOR_DEVICE_ATTR(curr1_label, S_IRUGO, show_label, NULL,
> +                               DA9052_ADC_ICH);
> +
> +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, da9052_read_tbat, NULL,
> +                               DA9052_ADC_TBAT);
> +static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_label, NULL,
> +                               DA9052_ADC_TBAT);
> +
> +static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, da9052_read_tjunc, NULL,
> +                               DA9052_ADC_TJUNC);
> +static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, show_label, NULL,
> +                               DA9052_ADC_TJUNC);
> +
> +static DEVICE_ATTR(name, S_IRUGO, da9052_hwmon_show_name, NULL);
> +
> +static struct attribute *da9052_attr[] = {
> +       &dev_attr_name.attr,
> +
> +       &sensor_dev_attr_in0_input.dev_attr.attr,
> +       &sensor_dev_attr_in0_label.dev_attr.attr,
> +       &sensor_dev_attr_curr1_input.dev_attr.attr,
> +       &sensor_dev_attr_curr1_label.dev_attr.attr,
> +       &sensor_dev_attr_temp1_input.dev_attr.attr,
> +       &sensor_dev_attr_temp1_label.dev_attr.attr,
> +       &sensor_dev_attr_in3_input.dev_attr.attr,
> +       &sensor_dev_attr_in3_label.dev_attr.attr,
> +       &sensor_dev_attr_in4_input.dev_attr.attr,
> +       &sensor_dev_attr_in4_label.dev_attr.attr,
> +       &sensor_dev_attr_in5_input.dev_attr.attr,
> +       &sensor_dev_attr_in5_label.dev_attr.attr,
> +       &sensor_dev_attr_in6_input.dev_attr.attr,
> +       &sensor_dev_attr_in6_label.dev_attr.attr,
> +       &sensor_dev_attr_temp1_input.dev_attr.attr,
> +       &sensor_dev_attr_temp1_label.dev_attr.attr,
> +       &sensor_dev_attr_temp2_input.dev_attr.attr,
> +       &sensor_dev_attr_temp2_label.dev_attr.attr,
> +       &sensor_dev_attr_in9_input.dev_attr.attr,
> +       &sensor_dev_attr_in9_label.dev_attr.attr,
> +       NULL
> +};
> +
> +static const struct attribute_group da9052_attr_group = {.attrs = da9052_attr};
> +
> +static int __init da9052_hwmon_probe(struct platform_device *pdev)
> +{
> +       struct da9052_hwmon *hwmon;
> +       int ret;
> +
> +       hwmon = kzalloc(sizeof(struct da9052_hwmon), GFP_KERNEL);
> +       if (!hwmon)
> +               return -ENOMEM;
> +
> +       mutex_init(&hwmon->hwmon_lock);
> +       hwmon->da9052 = dev_get_drvdata(pdev->dev.parent);
> +
> +       platform_set_drvdata(pdev, hwmon);
> +
> +       ret = sysfs_create_group(&pdev->dev.kobj, &da9052_attr_group);
> +       if (ret)
> +               goto err_mem;
> +
> +       hwmon->class_device = hwmon_device_register(&pdev->dev);
> +       if (IS_ERR(hwmon->class_device)) {
> +               ret = PTR_ERR(hwmon->class_device);
> +               sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
> +               goto err_mem;

usually you would do
               ret = PTR_ERR(hwmon->class_device);
               goto err_sysfs;

> +       }
> +
> +       return 0;
> +
and:

err_sysfs:
	sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);

> +err_mem:
> +       kfree(hwmon);
> +       return ret;
> +}
> +
> +static int __devexit da9052_hwmon_remove(struct platform_device *pdev)
> +{
> +       struct da9052_hwmon *hwmon = platform_get_drvdata(pdev);
> +
> +       hwmon_device_unregister(hwmon->class_device);
> +       sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
> +       mutex_destroy(&hwmon->hwmon_lock);
> +       kfree(hwmon);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver da9052_hwmon_driver = {
> +       .driver = {
> +               .name           = "da9052-hwmon",
> +               .owner  = THIS_MODULE,
> +       },
> +       .probe  = da9052_hwmon_probe,
> +       .remove = __devexit_p(da9052_hwmon_remove),
> +
> +};
> +
> +static int __init da9052_hwmon_init(void)
> +{
> +
> +       return platform_driver_register(&da9052_hwmon_driver);
> +}
> +module_init(da9052_hwmon_init);
> +
> +static void __exit da9052_hwmon_exit(void)
> +{
> +       platform_driver_unregister(&da9052_hwmon_driver);
> +}
> +module_exit(da9052_hwmon_exit);
> +
> +MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("DA9052 HWMON driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:da9052-hwmon");
> 
> 
> Regards,
> Ashish
> 
> 
