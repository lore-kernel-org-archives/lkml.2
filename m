Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1ATWRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:17:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:28017 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab1ATWRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:17:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,354,1291622400"; 
   d="scan'208";a="377622761"
Date: Thu, 20 Jan 2011 14:17:05 -0800
From: Fenghua Yu <fenghua.yu@intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        H Peter Anvin <hpa@zytor.com>
Subject: Re: patch[1/1]:hwmon:Adding_Threshold_support_to_coretemp
Message-ID: <20110120221704.GA26954@linux-os.sc.intel.com>
References: <D6D887BA8C9DFF48B5233887EF046541094482ED6A@bgsmsx502.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6D887BA8C9DFF48B5233887EF046541094482ED6A@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 11:45:44PM -0800, R, Durgadoss wrote:
> Hi,
> 
> This patch adds the core temperature threshold support to
> coretemp.c. These thresholds can be configured via the sysfs interfaces
> temp1_max and temp1_max_hyst. An interrupt is generated when CPU temperature
> goes above temp1_max or drops below temp1_max_hyst.
> 
> This patch needs the x86 patch, that can be downloaded
> from here:
> http://git.kernel.org/tip/9e76a97efd31a08cb19d0ba12013b8fb4ad3e474
> 
> ---------------------------------------------
> From: Durgadoss R <durgadoss.r@intel.com>
> 
> Date: Wed, 19 Jan 2011 03:52:19 +0530
> Subject: PATCH[1/1] hwmon:Adding_Threshold_support_to_coretemp
> 
> This patch adds the core temperature threshold support to
> coretemp.c. These thresholds can be configured via the sysfs interfaces
> temp1_max and temp1_max_hyst. An interrupt is generated when CPU temperature
> goes above temp1_max or drops below temp1_max_hyst.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> 
> ---
>  Documentation/hwmon/coretemp |    8 ++
>  drivers/hwmon/coretemp.c     |  222 ++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 210 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
> index 25568f8..2b89ae1 100644
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
> +temp1_max_hyst	 - If the CPU temperature falls below this temperature,
> +		   an interrupt is generated and temp1_max_alarm is reset.
> +temp1_max_alarm - Set if the temperature reaches or exceeds temp1_max.
> +		   Reset if the temperature drops to or below temp1_max_hyst.
>  temp1_crit	 - Maximum junction temperature (in millidegrees Celsius).
>  temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
>  		   Correct CPU operation is no longer guaranteed.
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 42de98d..0d09255 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -36,17 +36,21 @@
>  #include <asm/msr.h>
>  #include <asm/processor.h>
>  #include <asm/smp.h>
> +#include <asm/mce.h>
> +#include <asm/apic.h>
>  
>  #define DRVNAME	"coretemp"
>  
> -typedef enum { SHOW_TEMP, SHOW_TJMAX, SHOW_TTARGET, SHOW_LABEL,
> -		SHOW_NAME } SHOW;
> +enum attributes { SHOW_TEMP, SHOW_TJMAX, CORE_TTARGET, CORE_TMIN, SHOW_LABEL,
> +		SHOW_NAME, SHOW_CRIT_ALARM, SHOW_MAX_ALARM };
>  
>  /*
>   * Functions declaration
>   */
>  
>  static struct coretemp_data *coretemp_update_device(struct device *dev);
> +static void update_alarm(struct coretemp_data *data);
> +static int set_core_threshold(struct coretemp_data *data, int temp, int thres);
>  
>  struct coretemp_data {
>  	struct device *hwmon_dev;
> @@ -59,7 +63,9 @@ struct coretemp_data {
>  	int temp;
>  	int tjmax;
>  	int ttarget;
> -	u8 alarm;
> +	int tmin;
> +	u8 max_alarm;
> +	u8 crit_alarm;
>  };
>  
>  /*
> @@ -83,9 +89,16 @@ static ssize_t show_name(struct device *dev, struct device_attribute
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
> +	if (attr->index == SHOW_CRIT_ALARM) {
> +		/* read the Out-of-spec log, never clear */
> +		return sprintf(buf, "%d\n", data->crit_alarm);
> +	}
> +
> +	return sprintf(buf, "%d\n", data->max_alarm);
>  }
>  
>  static ssize_t show_temp(struct device *dev,
> @@ -93,33 +106,67 @@ static ssize_t show_temp(struct device *dev,
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
> @@ -127,6 +174,26 @@ static const struct attribute_group coretemp_group = {
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
> @@ -138,7 +205,6 @@ static struct coretemp_data *coretemp_update_device(struct device *dev)
>  
>  		data->valid = 0;
>  		rdmsr_on_cpu(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
> -		data->alarm = (eax >> 5) & 1;
>  		/* update only if data has been valid */
>  		if (eax & 0x80000000) {
>  			data->temp = data->tjmax - (((eax >> 16)
> @@ -298,6 +364,110 @@ static void __devinit get_ucode_rev_on_cpu(void *edx)
>  	rdmsr(MSR_IA32_UCODE_REV, eax, *(u32 *)edx);
>  }
>  
> +#ifdef CONFIG_X86_MCE
> +/* Platform thermal Interrupt Handler */
> +static int coretemp_interrupt(__u64 msr_val)
> +{
> +	if (msr_val & THERM_LOG_THRESHOLD0) {
> +		if (!(msr_val & THERM_STATUS_THRESHOLD0))
> +			pr_info(":Lower Threshold Reached\n");
> +		/* Reset the Threshold0 interrupt */
> +		wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOLD0);
> +	}
> +
> +	if (msr_val & THERM_LOG_THRESHOLD1) {
> +		if (msr_val & THERM_STATUS_THRESHOLD1)
> +			pr_info(":Upper Threshold Reached\n");
> +		/* Reset the Threshold1 interrupt */
> +		wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOLD1);
> +	}
> +
> +	return 0;
> +}
> +#endif
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
> +static int config_thresh_intrpt(struct coretemp_data *data, int enable)
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
> +	} else {
> +		eax &= (~(THERM_INT_THRESHOLD0_ENABLE |
> +						THERM_INT_THRESHOLD1_ENABLE));
> +	}
> +
> +	wrmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, eax, edx);
> +
> +	flag = 0; /*Flag should be zero to unmask the apic */
> +	smp_call_function_single(data->id, &configure_apic, &flag, 1);
> +
> +#ifdef CONFIG_X86_MCE
> +	if (enable)
> +		platform_thermal_notify = coretemp_interrupt;
> +	else
> +		platform_thermal_notify = NULL;
> +#endif
> +	return 0;
> +}
> +
>  static int __devinit coretemp_probe(struct platform_device *pdev)
>  {
>  	struct coretemp_data *data;
> @@ -351,6 +521,10 @@ static int __devinit coretemp_probe(struct platform_device *pdev)
>  	}
>  
>  	data->tjmax = get_tjmax(c, data->id, &pdev->dev);
> +	/* Initialize ttarget value. If IA32_TEMPERATURE_TARGET is
> +	 * supported, this value will be overwritten below
> +	 */
> +	data->ttarget = data->tjmax - 20000;
>  	platform_set_drvdata(pdev, data);
>  
>  	/*
> @@ -368,13 +542,21 @@ static int __devinit coretemp_probe(struct platform_device *pdev)
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
> +	/* Threshold support is available if the ACPI flag (bit 22) is set */
> +	if (cpu_has(c, X86_FEATURE_ACPI)) {
> +		/* Enable threshold interrupt support */
> +		config_thresh_intrpt(data, 1);
> +
> +		/* Set Initial Core thresholds.
> +		 * The lower and upper threshold values here are assumed
> +		 */
> +		set_core_threshold(data, 0, CORE_TMIN);
> +		set_core_threshold(data, data->ttarget, CORE_TTARGET);
> +	}
> +
>  	if ((err = sysfs_create_group(&pdev->dev.kobj, &coretemp_group)))
>  		goto exit_dev;
>  
> @@ -404,7 +586,7 @@ static int __devexit coretemp_remove(struct platform_device *pdev)
>  
>  	hwmon_device_unregister(data->hwmon_dev);
>  	sysfs_remove_group(&pdev->dev.kobj, &coretemp_group);
> -	device_remove_file(&pdev->dev, &sensor_dev_attr_temp1_max.dev_attr);
> +	config_thresh_intrpt(data, 0);
>  	platform_set_drvdata(pdev, NULL);
>  	kfree(data);
>  	return 0;

This patch has compilation error:
ERROR: "platform_thermal_notify" [drivers/hwmon/coretemp.ko] undefined!

The reason is commit 9e76a97efd31a08cb19d0ba12013b8fb4ad3e474 patch for 
therm_throt.c in upstream doesn't export the symbol platform_thermal_notify.

The following patch should fix the issue. Apply it before compiling your patch.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---

 arch/x86/kernel/cpu/mcheck/therm_throt.c |    1 +
 1 files changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index e12246f..6f8c5e9 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -59,6 +59,7 @@ struct thermal_state {
 
 /* Callback to handle core threshold interrupts */
 int (*platform_thermal_notify)(__u64 msr_val);
+EXPORT_SYMBOL(platform_thermal_notify);
 
 static DEFINE_PER_CPU(struct thermal_state, thermal_state);
 
