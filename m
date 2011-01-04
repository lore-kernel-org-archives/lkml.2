Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1ADTmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:42:00 -0500
Received: from imr4.ericy.com ([198.24.6.8]:57091 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab1ADTl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:41:59 -0500
Date: Tue, 4 Jan 2011 11:40:54 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: Patch[2/2]:hwmon:Adding_Threshold_Support_to_Coretemp.c
Message-ID: <20110104194054.GA635@ericsson.com>
References: <D6D887BA8C9DFF48B5233887EF04654105C11DB93B@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D6D887BA8C9DFF48B5233887EF04654105C11DB93B@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 03:56:57PM +0530, R, Durgadoss wrote:
> Hi,
> 
> I am submitting a patch to enable core thermal threshold
> Support to coretemp.c. There are two core thermal thresholds
> available through sysfs interfaces temp1_max and temp1_max_hyst.
> The temp1_max_alarm is set when temperature reaches or crosses
> above temp1_max or drops below temp1_max_hyst.
> 
> This patch is generated against stable Linux-2.6 kernel.
> 
> Kindly review and merge.
> ----------------------------------------------------------------
> From: Durgadoss R <durgadoss.r@intel.com>
> 
> Date: Sun, 19 Dec 2010 22:44:54 +0530
> Subject: [PATCH 2/2] hwmon:Adding_Threshold_Support_to_Coretemp
> 
> This patch adds core thermal thresholds support to coretemp.
> These thresholds can be configured via the sysfs interfaces temp1_max
> and temp1_max_hyst. An interrupt is generated when CPU temperature
> goes above temp1_max or drops below temp1_max_hyst.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>

Fenghua Yu <fenghua.yu@intel.com> as driver maintainer will have to Ack this patch.

Driver fails to build if MCE is not configured.

drivers/built-in.o: In function `config_thresh_intrpt':
coretemp.c:(.devinit.text+0xd909): undefined reference to `platform_thermal_notify'
coretemp.c:(.devinit.text+0xd91b): undefined reference to `platform_thermal_notify'
make: *** [.tmp_vmlinux1] Error 1

It also fails to build if APIC is not defined. See below. After that I gave up
trying more combinations. _Please_ do your homework.

> ---
>  Documentation/hwmon/coretemp |    8 ++
>  drivers/hwmon/coretemp.c     |  214 ++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 202 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
> index 25568f8..615fdbe 100644
> --- a/Documentation/hwmon/coretemp
> +++ b/Documentation/hwmon/coretemp
> @@ -29,6 +29,14 @@ the Out-Of-Spec bit. Following table summarizes the exported sysfs files:
>  
>  temp1_input	 - Core temperature (in millidegrees Celsius).
>  temp1_max	 - All cooling devices should be turned on (on Core2).
> +		   Initialized with IA32_TEMPERATURE_TARGET if supported,
> +		   otherwise initialized with (tjmax - 20). When the CPU
> +		   temperature reaches this temperature, an interrupt is
> +		   generated and temp1_max_alarm is set.
> +temp1_max_hyst	 - If the CPU temperature falls below than temperature,

	... falls below _this_ temperature ...

> +		   an interrupt is generated and temp1_max_alarm is reset.
> +temp1_max_alarm - Set if the temperature reaches or exceeds temp1_max.
> +		   Reset if the temperature drops to or below temp1_max_hyst.
>  temp1_crit	 - Maximum junction temperature (in millidegrees Celsius).
>  temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
>  		   Correct CPU operation is no longer guaranteed.
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 42de98d..025902f 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -36,11 +36,12 @@
>  #include <asm/msr.h>
>  #include <asm/processor.h>
>  #include <asm/smp.h>
> +#include <asm/mce.h>
>  
>  #define DRVNAME	"coretemp"
>  
> -typedef enum { SHOW_TEMP, SHOW_TJMAX, SHOW_TTARGET, SHOW_LABEL,
> -		SHOW_NAME } SHOW;
> +enum attributes { SHOW_TEMP, SHOW_TJMAX, CORE_TTARGET, CORE_TMIN, SHOW_LABEL,
> +		SHOW_NAME, SHOW_CRIT_ALARM, SHOW_MAX_ALARM } attrs;
>  
This defines a global variable named attrs. Not a good idea. You do not have to specify "attrs" here.

>  /*
>   * Functions declaration
> @@ -59,9 +60,14 @@ struct coretemp_data {
>  	int temp;
>  	int tjmax;
>  	int ttarget;
> -	u8 alarm;
> +	int tmin;
> +	u8 max_alarm;
> +	u8 crit_alarm;
>  };
>  
> +static void update_alarm(struct coretemp_data *data);
> +static int set_core_threshold(struct coretemp_data *data, int temp, int thres);
> +
Please keep with other function forward references. Yes, I know you need the struct,
but that doesn't have to be defined when you declare the forward references.
Or define the struct first and then all the forward declarations. 

>  /*
>   * Sysfs stuff
>   */
> @@ -83,9 +89,15 @@ static ssize_t show_name(struct device *dev, struct device_attribute
>  static ssize_t show_alarm(struct device *dev, struct device_attribute
>  			  *devattr, char *buf)
>  {
> -	struct coretemp_data *data = coretemp_update_device(dev);
> -	/* read the Out-of-spec log, never clear */
> -	return sprintf(buf, "%d\n", data->alarm);
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +	struct coretemp_data *data = dev_get_drvdata(dev);
> +
> +	update_alarm(data);
> +	if (attr->index == SHOW_CRIT_ALARM)
> +		/* read the Out-of-spec log, never clear */
> +		return sprintf(buf, "%d\n", data->crit_alarm);
> +
Since the if () statement includes a comment, it is better to add { } to improve 
readability.

> +	return sprintf(buf, "%d\n", data->max_alarm);
>  }
>  
>  static ssize_t show_temp(struct device *dev,
> @@ -93,33 +105,67 @@ static ssize_t show_temp(struct device *dev,
>  {
>  	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>  	struct coretemp_data *data = coretemp_update_device(dev);
> -	int err;
> +	int err = -EINVAL;
>  
> -	if (attr->index == SHOW_TEMP)
> +	switch (attr->index) {
> +	case SHOW_TEMP:
>  		err = data->valid ? sprintf(buf, "%d\n", data->temp) : -EAGAIN;
> -	else if (attr->index == SHOW_TJMAX)
> +		break;
> +	case SHOW_TJMAX:
>  		err = sprintf(buf, "%d\n", data->tjmax);
> -	else
> +		break;
> +	case CORE_TTARGET:
>  		err = sprintf(buf, "%d\n", data->ttarget);
> +		break;
> +	case CORE_TMIN:
> +		err = sprintf(buf, "%d\n", data->tmin);
> +		break;
> +	}
> +
>  	return err;
>  }
>  
> +
> +static ssize_t store_temp(struct device *dev,
> +		struct device_attribute *devattr, const char *buf, size_t count)
> +{
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +	struct coretemp_data *data = dev_get_drvdata(dev);
> +	unsigned long val;
> +	int err;
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	err = set_core_threshold(data, val, attr->index);
> +
> +	return err ? err : count;
> +}
> +
>  static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL,
>  			  SHOW_TEMP);
>  static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, show_temp, NULL,
>  			  SHOW_TJMAX);
> -static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO, show_temp, NULL,
> -			  SHOW_TTARGET);
> -static DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL);
> +static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp,
> +						store_temp, CORE_TTARGET);
> +static SENSOR_DEVICE_ATTR(temp1_max_hyst, S_IWUSR | S_IRUGO, show_temp,
> +						store_temp, CORE_TMIN);
> +static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL,
> +							SHOW_CRIT_ALARM);
> +static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_alarm, NULL,
> +							SHOW_MAX_ALARM);
>  static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_name, NULL, SHOW_LABEL);
>  static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, SHOW_NAME);
>  
>  static struct attribute *coretemp_attributes[] = {
>  	&sensor_dev_attr_name.dev_attr.attr,
>  	&sensor_dev_attr_temp1_label.dev_attr.attr,
> -	&dev_attr_temp1_crit_alarm.attr,
> +	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
>  	&sensor_dev_attr_temp1_input.dev_attr.attr,
>  	&sensor_dev_attr_temp1_crit.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max_hyst.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
>  	NULL
>  };
>  
> @@ -127,6 +173,26 @@ static const struct attribute_group coretemp_group = {
>  	.attrs = coretemp_attributes,
>  };
>  
> +static void update_alarm(struct coretemp_data *data)
> +{
> +	u32 eax, edx;
> +
> +	rdmsr_on_cpu(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
> +
> +	/* Update the critical temperature alarm */
> +	data->crit_alarm = (eax >> 5) & 1;
> +
> +	/* Temperature reached threshold1 */
> +	if (eax & THERM_LOG_THRESHOLD1)
> +		data->max_alarm = 1;
> +	/* Temperature reached threshold0 */
> +	else if (eax & THERM_LOG_THRESHOLD0)
> +		data->max_alarm = 0;
> +	/* If none of these cases, don't update max_alarm */
> +
> +	return;
> +}
> +
>  static struct coretemp_data *coretemp_update_device(struct device *dev)
>  {
>  	struct coretemp_data *data = dev_get_drvdata(dev);
> @@ -138,7 +204,6 @@ static struct coretemp_data *coretemp_update_device(struct device *dev)
>  
>  		data->valid = 0;
>  		rdmsr_on_cpu(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
> -		data->alarm = (eax >> 5) & 1;
>  		/* update only if data has been valid */
>  		if (eax & 0x80000000) {
>  			data->temp = data->tjmax - (((eax >> 16)
> @@ -298,6 +363,106 @@ static void __devinit get_ucode_rev_on_cpu(void *edx)
>  	rdmsr(MSR_IA32_UCODE_REV, eax, *(u32 *)edx);
>  }
>  
> +/* Platform thermal Interrupt Handler */
> +static int coretemp_interrupt(__u64 msr_val)
> +{
> +

That blank line isn't really needed.

> +	if (msr_val & THERM_LOG_THRESHOLD0) {
> +		if (!(msr_val & THERM_STATUS_THRESHOLD0))
> +			pr_info("%s:Lower Threshold Reached\n", __func__);

Info with each interrupt seems to be excessive. I would suggest to make it a debug message
if you really think it is needed. And __func__ should not be needed at all.

> +		/* Reset the Threshold0 interrupt */
> +		wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOLD0);
> +	}
> +
> +	if (msr_val & THERM_LOG_THRESHOLD1) {
> +		if (msr_val & THERM_STATUS_THRESHOLD1)
> +			pr_info("%s:Upper Threshold Reached\n", __func__);

Same here.

> +		/* Reset the Threshold1 interrupt */
> +		wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOLD1);
> +	}
> +
> +	return 0;
> +}
> +
> +static void configure_apic(void *info)
> +{
> +	u32 l;
> +	int *flag = (int *)info;
> +
> +	l = apic_read(APIC_LVTTHMR);
> +
> +	if (*flag)	/* Non-Zero flag Masks the APIC */
> +		apic_write(APIC_LVTTHMR, l | APIC_LVT_MASKED);
> +	else		/* Zero flag UnMasks the APIC */
> +		apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
> +}
> +
Fails to build if one manages to have APIC undefined (eg on a 32 bit kernel
with coretemp enabled and local APIC disabled).

drivers/hwmon/coretemp.c: In function ‘configure_apic’:
drivers/hwmon/coretemp.c:393: error: implicit declaration of function ‘apic_read’
drivers/hwmon/coretemp.c:396: error: implicit declaration of function ‘apic_write’

> +static int set_core_threshold(struct coretemp_data *data, int temp, int thres)
> +{
> +	u32 eax, edx;
> +	int diff;
> +	int flag = 1;
> +
> +	if (temp > data->tjmax)
> +		return -EINVAL;
> +
> +	mutex_lock(&data->update_lock);
> +
> +	diff = (data->tjmax - temp)/1000;
> +
> +	/* Mask the APIC */
> +	smp_call_function_single(data->id, &configure_apic, &flag, 1);
> +
> +	rdmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, &eax, &edx);
> +
> +	if (thres == CORE_TMIN) {
> +		eax = (eax & ~THERM_MASK_THRESHOLD0) |
> +					(diff << THERM_SHIFT_THRESHOLD0);
> +		data->tmin = temp;
> +	} else {
> +		eax = (eax & ~THERM_MASK_THRESHOLD1) |
> +					(diff << THERM_SHIFT_THRESHOLD1);
> +		data->ttarget = temp;
> +	}
> +
> +	wrmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, eax, edx);
> +
> +	/* Unmask the APIC */
> +	flag = 0;
> +	smp_call_function_single(data->id, &configure_apic, &flag, 1);
> +
> +	mutex_unlock(&data->update_lock);
> +	return 0;
> +}
> +
> +static int __devinit config_thresh_intrpt(struct coretemp_data *data,
> +								int enable)
> +{
> +	u32 eax, edx;
> +	int flag = 1; /* Non-Zero Flag masks the apic */
> +
> +	smp_call_function_single(data->id, &configure_apic, &flag, 1);
> +
> +	rdmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, &eax, &edx);
> +
> +	if (enable) {
> +		eax |= (THERM_INT_THRESHOLD0_ENABLE |
> +						THERM_INT_THRESHOLD1_ENABLE);
> +		platform_thermal_notify = coretemp_interrupt;
> +	} else {
> +		eax &= (~(THERM_INT_THRESHOLD0_ENABLE |
> +						THERM_INT_THRESHOLD1_ENABLE));
> +		platform_thermal_notify = NULL;
> +	}
> +
> +	wrmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, eax, edx);
> +
> +	flag = 0; /*Flag should be zero to unmask the apic */
> +	smp_call_function_single(data->id, &configure_apic, &flag, 1);
> +
> +	return 0;
> +}
> +
>  static int __devinit coretemp_probe(struct platform_device *pdev)
>  {
>  	struct coretemp_data *data;
> @@ -351,6 +516,10 @@ static int __devinit coretemp_probe(struct platform_device *pdev)
>  	}
>  
>  	data->tjmax = get_tjmax(c, data->id, &pdev->dev);
> +	/* Initialize ttarget value. If IA32_TEMPERATURE_TARGET is
> +	 * supported, this value will be over written below

overwritten 

> +	 */
> +	data->ttarget = data->tjmax - 20000;
>  	platform_set_drvdata(pdev, data);
>  
>  	/*
> @@ -368,13 +537,18 @@ static int __devinit coretemp_probe(struct platform_device *pdev)
>  		} else {
>  			data->ttarget = data->tjmax -
>  					(((eax >> 8) & 0xff) * 1000);
> -			err = device_create_file(&pdev->dev,
> -					&sensor_dev_attr_temp1_max.dev_attr);
> -			if (err)
> -				goto exit_free;
>  		}
>  	}
>  
> +	/* Enable threshold interrupt support */
> +	config_thresh_intrpt(data, 1);
> +
> +	/* Set Initial Core thresholds.
> +	 * The lower and upper threshold values here are assumed
> +	 */
> +	set_core_threshold(data, 0, CORE_TMIN);
> +	set_core_threshold(data, data->ttarget, CORE_TTARGET);
> +

I think I asked before ... are the threshold registers known to be supported on all intel CPUs
with coretemp support, or is some detection needed ?

>  	if ((err = sysfs_create_group(&pdev->dev.kobj, &coretemp_group)))
>  		goto exit_dev;
>  
> @@ -404,7 +578,7 @@ static int __devexit coretemp_remove(struct platform_device *pdev)
>  
>  	hwmon_device_unregister(data->hwmon_dev);
>  	sysfs_remove_group(&pdev->dev.kobj, &coretemp_group);
> -	device_remove_file(&pdev->dev, &sensor_dev_attr_temp1_max.dev_attr);
> +	config_thresh_intrpt(data, 0);
>  	platform_set_drvdata(pdev, NULL);
>  	kfree(data);
>  	return 0;
> -- 
> 1.6.5.2
> 


> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors

