Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2BTVRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:17:30 -0500
Received: from imr4.ericy.com ([198.24.6.9]:52926 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab2BTVR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:17:27 -0500
Message-ID: <1329772507.23014.30.camel@groeck-laptop>
Subject: Re: [PATCH] HWMON: DA9052/53 hwmon driver v2
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
CC: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "dchen@diasemi.com" <dchen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Mon, 20 Feb 2012 13:15:07 -0800
In-Reply-To: <1328878702.30549.155.camel@dhruva>
References: <1328878702.30549.155.camel@dhruva>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 07:58 -0500, Ashish Jangam wrote:
> The DA9052 PMIC provides an Analogue to Digital Converter with 10 bits
> resolution and 10 channels.
> 
> This patch montiors the DA9052 PMIC's ADC channels mostly for battery

s/montiors/monitors/

> parameters like battery temperature, junction temperature, battery
> current etc.
> 
> This patch is functionally tested on Samsung SMDKV6410.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
> Changes since v1
> - Update documentation file for url
> - Modify the entry in Kconfig file
> - Correct reporting of junction temperature
> - Add conversion function for backup battery voltage
> - Change labels for temperatures in the device attributes to follow
> sensor index
> ---
>  Documentation/hwmon/da9052   |   62 ++++++++
>  drivers/hwmon/Kconfig        |   10 ++
>  drivers/hwmon/Makefile       |    1 +
>  drivers/hwmon/da9052-hwmon.c |  344 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 417 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/hwmon/da9052
>  create mode 100644 drivers/hwmon/da9052-hwmon.c
> diff --git a/Documentation/hwmon/da9052 b/Documentation/hwmon/da9052
> new file mode 100644
> index 0000000..7caa066
> --- /dev/null
> +++ b/Documentation/hwmon/da9052
> @@ -0,0 +1,62 @@
> +Supported chips:
> +  * Dialog Semiconductors DA9052-BC and DA9053-AA/Bx PMICs
> +    Prefix: 'da9052'
> +    Datasheet: Kindly visit www.dialog-semiconductor.com/product_table.php
> +              and request for the official datasheet.
> +
Not really. From practical experience, the datasheet is not available
except for Dialog Semiconductor customers - not even for me to review
the driver (and that appears to be independent of my employer's
relationship with Dialog Semiconductor). I think this should read "not
publicly available". It is a bit misleading to suggest that it would be
available if that is not the case.

> +Authors: David Dajun Chen <dchen@diasemi.com>
> +
> +Description
> +-----------
> +
> +The DA9052/53 provides an Analogue to Digital Converter (ADC) with 10 bits
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

Formatting is a bit off here.

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
> +Voltages are sampled by a 10 bit ADC.
> +
> +The battery voltage is calculated as:
> +       Milli volt = ((ADC value * 1000) / 512) + 2500
> +
> +The backup battery voltage is calculated as:
> +       Milli volt = (ADC value * 2500) / 512;
> +
> +The voltages on ADC channels 4, 5 and 6 are calculated as:
> +       Milli volt = (ADC value * 2500) / 1023
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
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 24d584a..42b5f1a 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -313,6 +313,16 @@ config SENSORS_DS1621
>           This driver can also be built as a module.  If so, the module
>           will be called ds1621.
> 
> +config SENSORS_DA9052_ADC
> +       tristate "Dialog DA9052/DA9053 ADC"
> +       depends on PMIC_DA9052
> +       help
> +         Say y here to support the ADC found on Dialog Semiconductor
> +         DA9052-BC and DA9053-AA/Bx PMICs.
> +
> +         This driver can also be built as module. If so, the module
> +         will be called da9052-hwmon.
> +
>  config SENSORS_EXYNOS4_TMU
>         tristate "Temperature sensor on Samsung EXYNOS4"
>         depends on ARCH_EXYNOS4
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 8251ce8..5fe96e5 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -42,6 +42,7 @@ obj-$(CONFIG_SENSORS_APPLESMC)        += applesmc.o
>  obj-$(CONFIG_SENSORS_ASC7621)  += asc7621.o
>  obj-$(CONFIG_SENSORS_ATXP1)    += atxp1.o
>  obj-$(CONFIG_SENSORS_CORETEMP) += coretemp.o
> +obj-$(CONFIG_SENSORS_DA9052_ADC)+= da9052-hwmon.o
>  obj-$(CONFIG_SENSORS_DME1737)  += dme1737.o
>  obj-$(CONFIG_SENSORS_DS620)    += ds620.o
>  obj-$(CONFIG_SENSORS_DS1621)   += ds1621.o
> diff --git a/drivers/hwmon/da9052-hwmon.c b/drivers/hwmon/da9052-hwmon.c
> new file mode 100644
> index 0000000..9bef6ab
> --- /dev/null
> +++ b/drivers/hwmon/da9052-hwmon.c
> @@ -0,0 +1,344 @@
> +/*
> + * HWMON Driver for Dialog DA9052
> + *
> + * Copyright(c) 2012 Dialog Semiconductor Ltd.
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
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/reg.h>
> +
> +struct da9052_hwmon {
> +       struct da9052   *da9052;
> +       struct device   *class_device;
> +       struct mutex    hwmon_lock;
> +};
> +
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
Where are those defines, or, in other words, which repository/branch is
your patch based on ? I don't see it in the current mainline kernel.

> +/* Conversion function for VDDOUT and VBAT */
> +static inline int volt_reg_to_mV(int value)
> +{
> +       return ((value * 1000) / 512) + 2500;
> +}
> +
> +/* Conversion function for ADC channels 4, 5 and 6 */
> +static inline int input_reg_to_mV(int value)
> +{
> +       return (value * 2500) / 1023;
> +}
> +
> +/* Conversion function for VBBAT */
> +static inline int vbbat_reg_to_mV(int value)
> +{
> +       return (value * 2500) / 512;
> +}
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
> +
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
> +
> +       return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
> +}
> +
> +static ssize_t da9052_read_vddout(struct device *dev,
> +                                 struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret, vdd;
> +
> +       mutex_lock(&hwmon->hwmon_lock);
> +
> +       ret = da9052_enable_vddout_channel(hwmon->da9052);
> +       if (ret < 0)
> +               goto hwmon_err;
> +
> +       vdd = da9052_reg_read(hwmon->da9052, DA9052_VDD_RES_REG);
> +       if (vdd < 0) {
> +               ret = vdd;
> +               goto hwmon_err_release;
> +       }
> +
> +       ret = da9052_disable_vddout_channel(hwmon->da9052);
> +       if (ret < 0)
> +               goto hwmon_err;
> +
> +       mutex_unlock(&hwmon->hwmon_lock);
> +       return sprintf(buf, "%d\n", volt_reg_to_mV(vdd));
> +
> +hwmon_err_release:
> +       da9052_disable_vddout_channel(hwmon->da9052);
> +hwmon_err:
> +       mutex_unlock(&hwmon->hwmon_lock);
> +       return ret;
> +}
> +
> +static ssize_t da9052_read_ich(struct device *dev,
> +                              struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret;
> +
> +       ret = da9052_reg_read(hwmon->da9052, DA9052_ICHG_AV_REG);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* Equivalent to 3.9mA/bit in register ICHG_AV */
> +       return sprintf(buf, "%d\n", DIV_ROUND_CLOSEST(ret * 39, 10));
> +}
> +
> +static ssize_t da9052_read_tbat(struct device *dev,
> +                               struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +
> +       return sprintf(buf, "%d\n", da9052_adc_read_temp(hwmon->da9052));

>From other code in the upstream kernel, this function can return an
error code, which you should check.

Oddly enough, I find the call to da9052_adc_read_temp() in the upstream
kernel, but not the function itself. Is there something missing in the
upstream kernel ?

> +}
> +
> +static ssize_t da9052_read_vbat(struct device *dev,
> +                               struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret;
> +
> +       ret = da9052_adc_manual_read(hwmon->da9052, DA9052_ADC_VBAT);

Again, I find this function called in the upstream kernel, but not
defined. Odd.

> +       if (ret < 0)
> +               return ret;
> +
> +       return sprintf(buf, "%d\n", volt_reg_to_mV(ret));
> +}
> +
> +static ssize_t da9052_read_misc_channel(struct device *dev,
> +                                       struct device_attribute *devattr,
> +                                       char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int channel = to_sensor_dev_attr(devattr)->index;
> +       int ret;
> +
> +       ret = da9052_adc_manual_read(hwmon->da9052, channel);
> +       if (ret < 0)
> +               return ret;
> +
> +       return sprintf(buf, "%d\n", input_reg_to_mV(ret));
> +}
> +
> +static ssize_t da9052_read_tjunc(struct device *dev,
> +                                struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int tjunc;
> +       int toffset;
> +
> +       tjunc = da9052_reg_read(hwmon->da9052, DA9052_TJUNC_RES_REG);
> +       if (tjunc < 0)
> +               return tjunc;
> +
> +       toffset = da9052_reg_read(hwmon->da9052, DA9052_T_OFFSET_REG);
> +       if (toffset < 0)
> +               return toffset;
> +
> +       /*
> +        * Degrees celsius = 1.708 * (TJUNC_RES - T_OFFSET) - 108.8
> +        * T_OFFSET is a trim value used to improve accuracy of the result
> +        */
> +       return sprintf(buf, "%d\n", 1708 * (tjunc - toffset) - 108800);
> +}
> +
> +static ssize_t da9052_read_vbbat(struct device *dev,
> +                                struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret;
> +
> +       ret = da9052_adc_manual_read(hwmon->da9052, DA9052_ADC_VBBAT);
> +       if (ret < 0)
> +               return ret;
> +
> +       return sprintf(buf, "%d\n", vbbat_reg_to_mV(ret));
> +}
> +
> +static ssize_t da9052_hwmon_show_name(struct device *dev,
> +                                     struct device_attribute *devattr,
> +                                     char *buf)
> +{
> +       return sprintf(buf, "da9052-hwmon\n");
> +}
> +
> +static ssize_t show_label(struct device *dev,
> +                         struct device_attribute *devattr, char *buf)
> +{
> +       return sprintf(buf, "%s\n",
> +                      input_names[to_sensor_dev_attr(devattr)->index]);
> +}
> +
> +static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, da9052_read_vddout, NULL,
> +                         DA9052_ADC_VDDOUT);
> +static SENSOR_DEVICE_ATTR(in0_label, S_IRUGO, show_label, NULL,
> +                         DA9052_ADC_VDDOUT);
> +static SENSOR_DEVICE_ATTR(in3_input, S_IRUGO, da9052_read_vbat, NULL,
> +                         DA9052_ADC_VBAT);
> +static SENSOR_DEVICE_ATTR(in3_label, S_IRUGO, show_label, NULL,
> +                         DA9052_ADC_VBAT);
> +static SENSOR_DEVICE_ATTR(in4_input, S_IRUGO, da9052_read_misc_channel, NULL,
> +                         DA9052_ADC_IN4);
> +static SENSOR_DEVICE_ATTR(in4_label, S_IRUGO, show_label, NULL,
> +                         DA9052_ADC_IN4);
> +static SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, da9052_read_misc_channel, NULL,
> +                         DA9052_ADC_IN5);
> +static SENSOR_DEVICE_ATTR(in5_label, S_IRUGO, show_label, NULL,
> +                         DA9052_ADC_IN5);
> +static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, da9052_read_misc_channel, NULL,
> +                         DA9052_ADC_IN6);
> +static SENSOR_DEVICE_ATTR(in6_label, S_IRUGO, show_label, NULL,
> +                         DA9052_ADC_IN6);
> +static SENSOR_DEVICE_ATTR(in9_input, S_IRUGO, da9052_read_vbbat, NULL,
> +                         DA9052_ADC_VBBAT);
> +static SENSOR_DEVICE_ATTR(in9_label, S_IRUGO, show_label, NULL,
> +                         DA9052_ADC_VBBAT);
> +
> +static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, da9052_read_ich, NULL,
> +                         DA9052_ADC_ICH);
> +static SENSOR_DEVICE_ATTR(curr1_label, S_IRUGO, show_label, NULL,
> +                         DA9052_ADC_ICH);
> +
> +static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, da9052_read_tbat, NULL,
> +                         DA9052_ADC_TBAT);
> +static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, show_label, NULL,
> +                         DA9052_ADC_TBAT);
> +static SENSOR_DEVICE_ATTR(temp8_input, S_IRUGO, da9052_read_tjunc, NULL,
> +                         DA9052_ADC_TJUNC);
> +static SENSOR_DEVICE_ATTR(temp8_label, S_IRUGO, show_label, NULL,
> +                         DA9052_ADC_TJUNC);
> +
> +static DEVICE_ATTR(name, S_IRUGO, da9052_hwmon_show_name, NULL);
> +
> +static struct attribute *da9052_attr[] = {
> +       &dev_attr_name.attr,
> +       &sensor_dev_attr_in0_input.dev_attr.attr,
> +       &sensor_dev_attr_in0_label.dev_attr.attr,
> +       &sensor_dev_attr_in3_input.dev_attr.attr,
> +       &sensor_dev_attr_in3_label.dev_attr.attr,
> +       &sensor_dev_attr_in4_input.dev_attr.attr,
> +       &sensor_dev_attr_in4_label.dev_attr.attr,
> +       &sensor_dev_attr_in5_input.dev_attr.attr,
> +       &sensor_dev_attr_in5_label.dev_attr.attr,
> +       &sensor_dev_attr_in6_input.dev_attr.attr,
> +       &sensor_dev_attr_in6_label.dev_attr.attr,
> +       &sensor_dev_attr_in9_input.dev_attr.attr,
> +       &sensor_dev_attr_in9_label.dev_attr.attr,
> +       &sensor_dev_attr_curr1_input.dev_attr.attr,
> +       &sensor_dev_attr_curr1_label.dev_attr.attr,
> +       &sensor_dev_attr_temp2_input.dev_attr.attr,
> +       &sensor_dev_attr_temp2_label.dev_attr.attr,
> +       &sensor_dev_attr_temp8_input.dev_attr.attr,
> +       &sensor_dev_attr_temp8_label.dev_attr.attr,
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
> +       hwmon = devm_kzalloc(&pdev->dev, sizeof(struct da9052_hwmon),
> +                            GFP_KERNEL);
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
> +               goto err_sysfs;
> +       }
> +
> +       return 0;
> +
> +err_sysfs:
> +       sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
> +err_mem:
> +       return ret;
> +}
> +
> +static int __devexit da9052_hwmon_remove(struct platform_device *pdev)
> +{
> +       struct da9052_hwmon *hwmon = platform_get_drvdata(pdev);
> +
> +       hwmon_device_unregister(hwmon->class_device);
> +       sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver da9052_hwmon_driver = {
> +       .probe = da9052_hwmon_probe,
> +       .remove = __devexit_p(da9052_hwmon_remove),
> +       .driver = {
> +               .name = "da9052-hwmon",
> +               .owner = THIS_MODULE,
> +       },
> +};
> +
> +module_platform_driver(da9052_hwmon_driver);
> +
> +MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("DA9052 HWMON driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:da9052-hwmon");
> 
> 


