Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0LROKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 09:10:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:6314 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab0LROKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:10:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,193,1291622400"; 
   d="scan'208";a="688452776"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 18 Dec 2010 19:39:59 +0530
Subject: Patch[1/2] Adding_threshold_support_to_coretemp
Thread-Topic: Patch[1/2] Adding_threshold_support_to_coretemp
Thread-Index: AcuevUFBArCUWnVFS4WnNsgCS1l2kg==
Message-ID: <D6D887BA8C9DFF48B5233887EF04654105C1173BCD@bgsmsx502.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_D6D887BA8C9DFF48B5233887EF04654105C1173BCDbgsmsx502garc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_D6D887BA8C9DFF48B5233887EF04654105C1173BCDbgsmsx502garc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I am submitting a patch to enable core thermal threshold
Support to coretemp.c. There are two core thermal thresholds
available through sysfs interfaces temp1_max and temp1_max_hyst.
The temp1_max_alarm is set when temperature reaches or crosses
above temp1_max or drops below temp1_max_hyst.

This patch is generated against stable Linux-2.6 kernel.

Kindly review and merge.
----------------------------------------------------------------
From: Durgadoss R <durgadoss.r@intel.com>

Date: Sat, 18 Dec 2010 06:45:41 +0530
Subject: PATCH[1/2] Adding_Threshold_Support_to_Coretemp

This patch adds core thermal threshold support to coretemp.
These thresholds can be configured via the sysfs interfaces temp1_max
and temp1_max_hyst. An interrupt is generated when CPU temperature reaches
or crosses above temp1_max and drops below temp1_max_hyst.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>

---
 Documentation/hwmon/coretemp             |    8 +
 arch/x86/include/asm/mce.h               |    3 +
 arch/x86/include/asm/msr-index.h         |   12 ++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   40 ++++++
 drivers/hwmon/coretemp.c                 |  214 ++++++++++++++++++++++++++=
+---
 5 files changed, 257 insertions(+), 20 deletions(-)

diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
index 25568f8..6389292 100644
--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -29,6 +29,14 @@ the Out-Of-Spec bit. Following table summarizes the expo=
rted sysfs files:

 temp1_input     - Core temperature (in millidegrees Celsius).
 temp1_max       - All cooling devices should be turned on (on Core2).
+                  Initialized with IA32_TEMPERATURE_TARGET if supported,
+                  otherwise initialized with (tjmax - 20). When the CPU
+                  temperature reaches this temperature, an interrupt is
+                  generated and temp1_max_alarm is set.
+temp1_max_hyst  - If the CPU temperature falls below than temperature,
+                  an interrupt is generated and temp1_max_alarm is reset.
+temp1_max_alarm - Set if the temperature reaches or exceeds temp1_max.
+                  Reset if the temperature drops to or below temp1_max_hys=
t.
 temp1_crit      - Maximum junction temperature (in millidegrees Celsius).
 temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
                   Correct CPU operation is no longer guaranteed.
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c62c13c..eb16e94 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -223,6 +223,9 @@ void intel_init_thermal(struct cpuinfo_x86 *c);

 void mce_log_therm_throt_event(__u64 status);

+/* Interrupt Handler for core thermal thresholds */
+extern int (*platform_thermal_notify)(__u64 msr_val);
+
 #ifdef CONFIG_X86_THERMAL_VECTOR
 extern void mcheck_intel_therm_init(void);
 #else
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-in=
dex.h
index 3ea3dc4..a9de090 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -253,6 +253,18 @@
 #define PACKAGE_THERM_INT_LOW_ENABLE           (1 << 1)
 #define PACKAGE_THERM_INT_PLN_ENABLE           (1 << 24)

+/* Thermal Thresholds Support */
+#define THERM_INT_THRESHOLD0_ENABLE    (1 << 15)
+#define THERM_SHIFT_THRESHOLD0        8
+#define THERM_MASK_THRESHOLD0          (0x7f << THERM_SHIFT_THRESHOLD0)
+#define THERM_INT_THRESHOLD1_ENABLE    (1 << 23)
+#define THERM_SHIFT_THRESHOLD1        16
+#define THERM_MASK_THRESHOLD1          (0x7f << THERM_SHIFT_THRESHOLD1)
+#define THERM_STATUS_THRESHOLD0        (1 << 6)
+#define THERM_LOG_THRESHOLD0           (1 << 7)
+#define THERM_STATUS_THRESHOLD1        (1 << 8)
+#define THERM_LOG_THRESHOLD1           (1 << 9)
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING       (1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC               (1ULL << 1)
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu=
/mcheck/therm_throt.c
index 4b68326..e12246f 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -53,8 +53,13 @@ struct thermal_state {
        struct _thermal_state core_power_limit;
        struct _thermal_state package_throttle;
        struct _thermal_state package_power_limit;
+       struct _thermal_state core_thresh0;
+       struct _thermal_state core_thresh1;
 };

+/* Callback to handle core threshold interrupts */
+int (*platform_thermal_notify)(__u64 msr_val);
+
 static DEFINE_PER_CPU(struct thermal_state, thermal_state);

 static atomic_t therm_throt_en =3D ATOMIC_INIT(0);
@@ -200,6 +205,22 @@ static int therm_throt_process(bool new_event, int eve=
nt, int level)
        return 0;
 }

+static int thresh_event_valid(int event)
+{
+       struct _thermal_state *state;
+       unsigned int this_cpu =3D smp_processor_id();
+       struct thermal_state *pstate =3D &per_cpu(thermal_state, this_cpu);
+       u64 now =3D get_jiffies_64();
+
+       state =3D (event =3D=3D 0) ? &pstate->core_thresh0 : &pstate->core_=
thresh1;
+
+       if (time_before64(now, state->next_check))
+               return 0;
+
+       state->next_check =3D now + CHECK_INTERVAL;
+       return 1;
+}
+
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
 static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
@@ -313,6 +334,22 @@ device_initcall(thermal_throttle_init_device);
 #define PACKAGE_THROTTLED      ((__u64)2 << 62)
 #define PACKAGE_POWER_LIMIT    ((__u64)3 << 62)

+static void notify_thresholds(__u64 msr_val)
+{
+       /* check whether the interrupt handler is defined;
+        * otherwise simply return
+        */
+       if (!platform_thermal_notify)
+               return;
+
+       /* lower threshold reached */
+       if ((msr_val & THERM_LOG_THRESHOLD0) && thresh_event_valid(0))
+               platform_thermal_notify(msr_val);
+       /* higher threshold reached */
+       if ((msr_val & THERM_LOG_THRESHOLD1) && thresh_event_valid(1))
+               platform_thermal_notify(msr_val);
+}
+
 /* Thermal transition interrupt handler */
 static void intel_thermal_interrupt(void)
 {
@@ -321,6 +358,9 @@ static void intel_thermal_interrupt(void)

        rdmsrl(MSR_IA32_THERM_STATUS, msr_val);

+       /* Check for violation of core thermal thresholds*/
+       notify_thresholds(msr_val);
+
        if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT,
                                THERMAL_THROTTLING_EVENT,
                                CORE_LEVEL) !=3D 0)
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 42de98d..1bf8acb 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -36,11 +36,12 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
+#include <asm/mce.h>

 #define DRVNAME        "coretemp"

-typedef enum { SHOW_TEMP, SHOW_TJMAX, SHOW_TTARGET, SHOW_LABEL,
-               SHOW_NAME } SHOW;
+enum attributes { SHOW_TEMP, SHOW_TJMAX, CORE_TTARGET, CORE_TMIN, SHOW_LAB=
EL,
+               SHOW_NAME, SHOW_CRIT_ALARM, SHOW_MAX_ALARM } attrs;

 /*
  * Functions declaration
@@ -59,9 +60,14 @@ struct coretemp_data {
        int temp;
        int tjmax;
        int ttarget;
-       u8 alarm;
+       int tmin;
+       u8 max_alarm;
+       u8 crit_alarm;
 };

+static void update_alarm(struct coretemp_data *data);
+static int set_core_threshold(struct coretemp_data *data, int temp, int th=
res);
+
 /*
  * Sysfs stuff
  */
@@ -83,9 +89,15 @@ static ssize_t show_name(struct device *dev, struct devi=
ce_attribute
 static ssize_t show_alarm(struct device *dev, struct device_attribute
                          *devattr, char *buf)
 {
-       struct coretemp_data *data =3D coretemp_update_device(dev);
-       /* read the Out-of-spec log, never clear */
-       return sprintf(buf, "%d\n", data->alarm);
+       struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr=
);
+       struct coretemp_data *data =3D dev_get_drvdata(dev);
+
+       update_alarm(data);
+       if (attr->index =3D=3D SHOW_CRIT_ALARM)
+               /* read the Out-of-spec log, never clear */
+               return sprintf(buf, "%d\n", data->crit_alarm);
+
+       return sprintf(buf, "%d\n", data->max_alarm);
 }

 static ssize_t show_temp(struct device *dev,
@@ -93,33 +105,67 @@ static ssize_t show_temp(struct device *dev,
 {
        struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr=
);
        struct coretemp_data *data =3D coretemp_update_device(dev);
-       int err;
+       int err =3D -EINVAL;

-       if (attr->index =3D=3D SHOW_TEMP)
+       switch (attr->index) {
+       case SHOW_TEMP:
                err =3D data->valid ? sprintf(buf, "%d\n", data->temp) : -E=
AGAIN;
-       else if (attr->index =3D=3D SHOW_TJMAX)
+               break;
+       case SHOW_TJMAX:
                err =3D sprintf(buf, "%d\n", data->tjmax);
-       else
+               break;
+       case CORE_TTARGET:
                err =3D sprintf(buf, "%d\n", data->ttarget);
+               break;
+       case CORE_TMIN:
+               err =3D sprintf(buf, "%d\n", data->tmin);
+               break;
+       }
+
        return err;
 }

+
+static ssize_t store_temp(struct device *dev,
+               struct device_attribute *devattr, const char *buf, size_t c=
ount)
+{
+       struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr=
);
+       struct coretemp_data *data =3D dev_get_drvdata(dev);
+       unsigned long val;
+       int err;
+
+       if (strict_strtoul(buf, 10, &val))
+               return -EINVAL;
+
+       err =3D set_core_threshold(data, val, attr->index);
+
+       return err ? err : count;
+}
+
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL,
                          SHOW_TEMP);
 static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, show_temp, NULL,
                          SHOW_TJMAX);
-static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO, show_temp, NULL,
-                         SHOW_TTARGET);
-static DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp,
+                                               store_temp, CORE_TTARGET);
+static SENSOR_DEVICE_ATTR(temp1_max_hyst, S_IWUSR | S_IRUGO, show_temp,
+                                               store_temp, CORE_TMIN);
+static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL,
+                                                       SHOW_CRIT_ALARM);
+static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_alarm, NULL,
+                                                       SHOW_MAX_ALARM);
 static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_name, NULL, SHOW_LABE=
L);
 static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, SHOW_NAME);

 static struct attribute *coretemp_attributes[] =3D {
        &sensor_dev_attr_name.dev_attr.attr,
        &sensor_dev_attr_temp1_label.dev_attr.attr,
-       &dev_attr_temp1_crit_alarm.attr,
+       &sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
        &sensor_dev_attr_temp1_input.dev_attr.attr,
        &sensor_dev_attr_temp1_crit.dev_attr.attr,
+       &sensor_dev_attr_temp1_max.dev_attr.attr,
+       &sensor_dev_attr_temp1_max_hyst.dev_attr.attr,
+       &sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
        NULL
 };

@@ -127,6 +173,26 @@ static const struct attribute_group coretemp_group =3D=
 {
        .attrs =3D coretemp_attributes,
 };

+static void update_alarm(struct coretemp_data *data)
+{
+       u32 eax, edx;
+
+       rdmsr_on_cpu(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
+
+       /* Update the critical temperature alarm */
+       data->crit_alarm =3D (eax >> 5) & 1;
+
+       /* Temperature reached threshold1 */
+       if (eax & THERM_LOG_THRESHOLD1)
+               data->max_alarm =3D 1;
+       /* Temperature reached threshold0 */
+       else if (eax & THERM_LOG_THRESHOLD0)
+               data->max_alarm =3D 0;
+       /* If none of these cases, don't update max_alarm */
+
+       return;
+}
+
 static struct coretemp_data *coretemp_update_device(struct device *dev)
 {
        struct coretemp_data *data =3D dev_get_drvdata(dev);
@@ -138,7 +204,6 @@ static struct coretemp_data *coretemp_update_device(str=
uct device *dev)

                data->valid =3D 0;
                rdmsr_on_cpu(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
-               data->alarm =3D (eax >> 5) & 1;
                /* update only if data has been valid */
                if (eax & 0x80000000) {
                        data->temp =3D data->tjmax - (((eax >> 16)
@@ -298,6 +363,106 @@ static void __devinit get_ucode_rev_on_cpu(void *edx)
        rdmsr(MSR_IA32_UCODE_REV, eax, *(u32 *)edx);
 }

+/* Platform thermal Interrupt Handler */
+static int coretemp_interrupt(__u64 msr_val)
+{
+
+       if (msr_val & THERM_LOG_THRESHOLD0) {
+               if (!(msr_val & THERM_STATUS_THRESHOLD0))
+                       pr_info("%s:Lower Threshold Reached\n", __func__);
+               /* Reset the Threshold0 interrupt */
+               wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOL=
D0);
+       }
+
+       if (msr_val & THERM_LOG_THRESHOLD1) {
+               if (msr_val & THERM_STATUS_THRESHOLD1)
+                       pr_info("%s:Upper Threshold Reached\n", __func__);
+               /* Reset the Threshold1 interrupt */
+               wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOL=
D1);
+       }
+
+       return 0;
+}
+
+static void configure_apic(void *info)
+{
+       u32 l;
+       int *flag =3D (int *)info;
+
+       l =3D apic_read(APIC_LVTTHMR);
+
+       if (*flag)      /* Non-Zero flag Masks the APIC */
+               apic_write(APIC_LVTTHMR, l | APIC_LVT_MASKED);
+       else            /* Zero flag UnMasks the APIC */
+               apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
+}
+
+static int set_core_threshold(struct coretemp_data *data, int temp, int th=
res)
+{
+       u32 eax, edx;
+       int diff;
+       int flag =3D 1;
+
+       if (temp > data->tjmax)
+               return -EINVAL;
+
+       mutex_lock(&data->update_lock);
+
+       diff =3D (data->tjmax - temp)/1000;
+
+       /* Mask the APIC */
+       smp_call_function_single(data->id, &configure_apic, &flag, 1);
+
+       rdmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, &eax, &edx);
+
+       if (thres =3D=3D CORE_TMIN) {
+               eax =3D (eax & ~THERM_MASK_THRESHOLD0) |
+                                       (diff << THERM_SHIFT_THRESHOLD0);
+               data->tmin =3D temp;
+       } else {
+               eax =3D (eax & ~THERM_MASK_THRESHOLD1) |
+                                       (diff << THERM_SHIFT_THRESHOLD1);
+               data->ttarget =3D temp;
+       }
+
+       wrmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, eax, edx);
+
+       /* Unmask the APIC */
+       flag =3D 0;
+       smp_call_function_single(data->id, &configure_apic, &flag, 1);
+
+       mutex_unlock(&data->update_lock);
+       return 0;
+}
+
+static int __devinit config_thresh_intrpt(struct coretemp_data *data,
+                                                               int enable)
+{
+       u32 eax, edx;
+       int flag =3D 1; /* Non-Zero Flag masks the apic */
+
+       smp_call_function_single(data->id, &configure_apic, &flag, 1);
+
+       rdmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, &eax, &edx);
+
+       if (enable) {
+               eax |=3D (THERM_INT_THRESHOLD0_ENABLE |
+                                               THERM_INT_THRESHOLD1_ENABLE=
);
+               platform_thermal_notify =3D coretemp_interrupt;
+       } else {
+               eax &=3D (~(THERM_INT_THRESHOLD0_ENABLE |
+                                               THERM_INT_THRESHOLD1_ENABLE=
));
+               platform_thermal_notify =3D NULL;
+       }
+
+       wrmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, eax, edx);
+
+       flag =3D 0; /*Flag should be zero to unmask the apic */
+       smp_call_function_single(data->id, &configure_apic, &flag, 1);
+
+       return 0;
+}
+
 static int __devinit coretemp_probe(struct platform_device *pdev)
 {
        struct coretemp_data *data;
@@ -351,6 +516,10 @@ static int __devinit coretemp_probe(struct platform_de=
vice *pdev)
        }

        data->tjmax =3D get_tjmax(c, data->id, &pdev->dev);
+       /* Initialize ttarget value. If IA32_TEMPERATURE_TARGET is
+        * supported, this value will be over written below
+        */
+       data->ttarget =3D data->tjmax - 20000;
        platform_set_drvdata(pdev, data);

        /*
@@ -368,13 +537,18 @@ static int __devinit coretemp_probe(struct platform_d=
evice *pdev)
                } else {
                        data->ttarget =3D data->tjmax -
                                        (((eax >> 8) & 0xff) * 1000);
-                       err =3D device_create_file(&pdev->dev,
-                                       &sensor_dev_attr_temp1_max.dev_attr=
);
-                       if (err)
-                               goto exit_free;
                }
        }

+       /* Enable threshold interrupt support */
+       config_thresh_intrpt(data, 1);
+
+       /* Set Initial Core thresholds.
+        * The lower and upper threshold values here are assumed
+        */
+       set_core_threshold(data, 0, CORE_TMIN);
+       set_core_threshold(data, data->ttarget, CORE_TTARGET);
+
        if ((err =3D sysfs_create_group(&pdev->dev.kobj, &coretemp_group)))
                goto exit_dev;

@@ -404,7 +578,7 @@ static int __devexit coretemp_remove(struct platform_de=
vice *pdev)

        hwmon_device_unregister(data->hwmon_dev);
        sysfs_remove_group(&pdev->dev.kobj, &coretemp_group);
-       device_remove_file(&pdev->dev, &sensor_dev_attr_temp1_max.dev_attr)=
;
+       config_thresh_intrpt(data, 0);
        platform_set_drvdata(pdev, NULL);
        kfree(data);
        return 0;
--
1.6.5.2


--_002_D6D887BA8C9DFF48B5233887EF04654105C1173BCDbgsmsx502garc_
Content-Type: application/octet-stream;
	name="0001-Adding_Threshold_Support_to_Coretemp.patch"
Content-Description: 0001-Adding_Threshold_Support_to_Coretemp.patch
Content-Disposition: attachment;
	filename="0001-Adding_Threshold_Support_to_Coretemp.patch"; size=15029;
	creation-date="Sat, 18 Dec 2010 18:55:33 GMT";
	modification-date="Sat, 18 Dec 2010 06:51:51 GMT"
Content-Transfer-Encoding: base64

RnJvbTogRHVyZ2Fkb3NzIFIgPGR1cmdhZG9zcy5yQGludGVsLmNvbT4KRGF0ZTogU2F0LCAxOCBE
ZWMgMjAxMCAwNjo0NTo0MSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIEFkZGluZ19UaHJlc2hvbGRf
U3VwcG9ydF90b19Db3JldGVtcAoKVGhpcyBwYXRjaCBhZGRzIGNvcmUgdGhlcm1hbCB0aHJlc2hv
bGQgc3VwcG9ydCB0byBjb3JldGVtcC4KVGhlc2UgdGhyZXNob2xkcyBjYW4gYmUgY29uZmlndXJl
ZCB2aWEgdGhlIHN5c2ZzIGludGVyZmFjZXMgdGVtcDFfbWF4CmFuZCB0ZW1wMV9tYXhfaHlzdC4g
QW4gaW50ZXJydXB0IGlzIGdlbmVyYXRlZCB3aGVuIENQVSB0ZW1wZXJhdHVyZSByZWFjaGVzCm9y
IGNyb3NzZXMgYWJvdmUgdGVtcDFfbWF4IGFuZCBkcm9wcyBiZWxvdyB0ZW1wMV9tYXhfaHlzdC4K
ClNpZ25lZC1vZmYtYnk6IER1cmdhZG9zcyBSIDxkdXJnYWRvc3MuckBpbnRlbC5jb20+Ci0tLQog
RG9jdW1lbnRhdGlvbi9od21vbi9jb3JldGVtcCAgICAgICAgICAgICB8ICAgIDggKwogYXJjaC94
ODYvaW5jbHVkZS9hc20vbWNlLmggICAgICAgICAgICAgICB8ICAgIDMgKwogYXJjaC94ODYvaW5j
bHVkZS9hc20vbXNyLWluZGV4LmggICAgICAgICB8ICAgMTIgKysKIGFyY2gveDg2L2tlcm5lbC9j
cHUvbWNoZWNrL3RoZXJtX3Rocm90LmMgfCAgIDQwICsrKysrKwogZHJpdmVycy9od21vbi9jb3Jl
dGVtcC5jICAgICAgICAgICAgICAgICB8ICAyMTQgKysrKysrKysrKysrKysrKysrKysrKysrKysr
LS0tCiA1IGZpbGVzIGNoYW5nZWQsIDI1NyBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2h3bW9uL2NvcmV0ZW1wIGIvRG9jdW1lbnRhdGlv
bi9od21vbi9jb3JldGVtcAppbmRleCAyNTU2OGY4Li42Mzg5MjkyIDEwMDY0NAotLS0gYS9Eb2N1
bWVudGF0aW9uL2h3bW9uL2NvcmV0ZW1wCisrKyBiL0RvY3VtZW50YXRpb24vaHdtb24vY29yZXRl
bXAKQEAgLTI5LDYgKzI5LDE0IEBAIHRoZSBPdXQtT2YtU3BlYyBiaXQuIEZvbGxvd2luZyB0YWJs
ZSBzdW1tYXJpemVzIHRoZSBleHBvcnRlZCBzeXNmcyBmaWxlczoKIAogdGVtcDFfaW5wdXQJIC0g
Q29yZSB0ZW1wZXJhdHVyZSAoaW4gbWlsbGlkZWdyZWVzIENlbHNpdXMpLgogdGVtcDFfbWF4CSAt
IEFsbCBjb29saW5nIGRldmljZXMgc2hvdWxkIGJlIHR1cm5lZCBvbiAob24gQ29yZTIpLgorCQkg
ICBJbml0aWFsaXplZCB3aXRoIElBMzJfVEVNUEVSQVRVUkVfVEFSR0VUIGlmIHN1cHBvcnRlZCwK
KwkJICAgb3RoZXJ3aXNlIGluaXRpYWxpemVkIHdpdGggKHRqbWF4IC0gMjApLiBXaGVuIHRoZSBD
UFUKKwkJICAgdGVtcGVyYXR1cmUgcmVhY2hlcyB0aGlzIHRlbXBlcmF0dXJlLCBhbiBpbnRlcnJ1
cHQgaXMKKwkJICAgZ2VuZXJhdGVkIGFuZCB0ZW1wMV9tYXhfYWxhcm0gaXMgc2V0LgordGVtcDFf
bWF4X2h5c3QJIC0gSWYgdGhlIENQVSB0ZW1wZXJhdHVyZSBmYWxscyBiZWxvdyB0aGFuIHRlbXBl
cmF0dXJlLAorCQkgICBhbiBpbnRlcnJ1cHQgaXMgZ2VuZXJhdGVkIGFuZCB0ZW1wMV9tYXhfYWxh
cm0gaXMgcmVzZXQuCit0ZW1wMV9tYXhfYWxhcm0gLSBTZXQgaWYgdGhlIHRlbXBlcmF0dXJlIHJl
YWNoZXMgb3IgZXhjZWVkcyB0ZW1wMV9tYXguCisJCSAgIFJlc2V0IGlmIHRoZSB0ZW1wZXJhdHVy
ZSBkcm9wcyB0byBvciBiZWxvdyB0ZW1wMV9tYXhfaHlzdC4KIHRlbXAxX2NyaXQJIC0gTWF4aW11
bSBqdW5jdGlvbiB0ZW1wZXJhdHVyZSAoaW4gbWlsbGlkZWdyZWVzIENlbHNpdXMpLgogdGVtcDFf
Y3JpdF9hbGFybSAtIFNldCB3aGVuIE91dC1vZi1zcGVjIGJpdCBpcyBzZXQsIG5ldmVyIGNsZWFy
cy4KIAkJICAgQ29ycmVjdCBDUFUgb3BlcmF0aW9uIGlzIG5vIGxvbmdlciBndWFyYW50ZWVkLgpk
aWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vbWNlLmggYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9tY2UuaAppbmRleCBjNjJjMTNjLi5lYjE2ZTk0IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9tY2UuaAorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tY2UuaApAQCAtMjIz
LDYgKzIyMyw5IEBAIHZvaWQgaW50ZWxfaW5pdF90aGVybWFsKHN0cnVjdCBjcHVpbmZvX3g4NiAq
Yyk7CiAKIHZvaWQgbWNlX2xvZ190aGVybV90aHJvdF9ldmVudChfX3U2NCBzdGF0dXMpOwogCisv
KiBJbnRlcnJ1cHQgSGFuZGxlciBmb3IgY29yZSB0aGVybWFsIHRocmVzaG9sZHMgKi8KK2V4dGVy
biBpbnQgKCpwbGF0Zm9ybV90aGVybWFsX25vdGlmeSkoX191NjQgbXNyX3ZhbCk7CisKICNpZmRl
ZiBDT05GSUdfWDg2X1RIRVJNQUxfVkVDVE9SCiBleHRlcm4gdm9pZCBtY2hlY2tfaW50ZWxfdGhl
cm1faW5pdCh2b2lkKTsKICNlbHNlCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9t
c3ItaW5kZXguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL21zci1pbmRleC5oCmluZGV4IDNlYTNk
YzQuLmE5ZGUwOTAgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL21zci1pbmRleC5o
CisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL21zci1pbmRleC5oCkBAIC0yNTMsNiArMjUzLDE4
IEBACiAjZGVmaW5lIFBBQ0tBR0VfVEhFUk1fSU5UX0xPV19FTkFCTEUJCSgxIDw8IDEpCiAjZGVm
aW5lIFBBQ0tBR0VfVEhFUk1fSU5UX1BMTl9FTkFCTEUJCSgxIDw8IDI0KQogCisvKiBUaGVybWFs
IFRocmVzaG9sZHMgU3VwcG9ydCAqLworI2RlZmluZSBUSEVSTV9JTlRfVEhSRVNIT0xEMF9FTkFC
TEUgICAgKDEgPDwgMTUpCisjZGVmaW5lIFRIRVJNX1NISUZUX1RIUkVTSE9MRDAgICAgICAgIDgK
KyNkZWZpbmUgVEhFUk1fTUFTS19USFJFU0hPTEQwICAgICAgICAgICgweDdmIDw8IFRIRVJNX1NI
SUZUX1RIUkVTSE9MRDApCisjZGVmaW5lIFRIRVJNX0lOVF9USFJFU0hPTEQxX0VOQUJMRSAgICAo
MSA8PCAyMykKKyNkZWZpbmUgVEhFUk1fU0hJRlRfVEhSRVNIT0xEMSAgICAgICAgMTYKKyNkZWZp
bmUgVEhFUk1fTUFTS19USFJFU0hPTEQxICAgICAgICAgICgweDdmIDw8IFRIRVJNX1NISUZUX1RI
UkVTSE9MRDEpCisjZGVmaW5lIFRIRVJNX1NUQVRVU19USFJFU0hPTEQwICAgICAgICAoMSA8PCA2
KQorI2RlZmluZSBUSEVSTV9MT0dfVEhSRVNIT0xEMCAgICAgICAgICAgKDEgPDwgNykKKyNkZWZp
bmUgVEhFUk1fU1RBVFVTX1RIUkVTSE9MRDEgICAgICAgICgxIDw8IDgpCisjZGVmaW5lIFRIRVJN
X0xPR19USFJFU0hPTEQxICAgICAgICAgICAoMSA8PCA5KQorCiAvKiBNSVNDX0VOQUJMRSBiaXRz
OiBhcmNoaXRlY3R1cmFsICovCiAjZGVmaW5lIE1TUl9JQTMyX01JU0NfRU5BQkxFX0ZBU1RfU1RS
SU5HCSgxVUxMIDw8IDApCiAjZGVmaW5lIE1TUl9JQTMyX01JU0NfRU5BQkxFX1RDQwkJKDFVTEwg
PDwgMSkKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbWNoZWNrL3RoZXJtX3Rocm90
LmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jaGVjay90aGVybV90aHJvdC5jCmluZGV4IDRiNjgz
MjYuLmUxMjI0NmYgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbWNoZWNrL3RoZXJt
X3Rocm90LmMKKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svdGhlcm1fdGhyb3QuYwpA
QCAtNTMsOCArNTMsMTMgQEAgc3RydWN0IHRoZXJtYWxfc3RhdGUgewogCXN0cnVjdCBfdGhlcm1h
bF9zdGF0ZSBjb3JlX3Bvd2VyX2xpbWl0OwogCXN0cnVjdCBfdGhlcm1hbF9zdGF0ZSBwYWNrYWdl
X3Rocm90dGxlOwogCXN0cnVjdCBfdGhlcm1hbF9zdGF0ZSBwYWNrYWdlX3Bvd2VyX2xpbWl0Owor
CXN0cnVjdCBfdGhlcm1hbF9zdGF0ZSBjb3JlX3RocmVzaDA7CisJc3RydWN0IF90aGVybWFsX3N0
YXRlIGNvcmVfdGhyZXNoMTsKIH07CiAKKy8qIENhbGxiYWNrIHRvIGhhbmRsZSBjb3JlIHRocmVz
aG9sZCBpbnRlcnJ1cHRzICovCitpbnQgKCpwbGF0Zm9ybV90aGVybWFsX25vdGlmeSkoX191NjQg
bXNyX3ZhbCk7CisKIHN0YXRpYyBERUZJTkVfUEVSX0NQVShzdHJ1Y3QgdGhlcm1hbF9zdGF0ZSwg
dGhlcm1hbF9zdGF0ZSk7CiAKIHN0YXRpYyBhdG9taWNfdCB0aGVybV90aHJvdF9lbgk9IEFUT01J
Q19JTklUKDApOwpAQCAtMjAwLDYgKzIwNSwyMiBAQCBzdGF0aWMgaW50IHRoZXJtX3Rocm90X3By
b2Nlc3MoYm9vbCBuZXdfZXZlbnQsIGludCBldmVudCwgaW50IGxldmVsKQogCXJldHVybiAwOwog
fQogCitzdGF0aWMgaW50IHRocmVzaF9ldmVudF92YWxpZChpbnQgZXZlbnQpCit7CisJc3RydWN0
IF90aGVybWFsX3N0YXRlICpzdGF0ZTsKKwl1bnNpZ25lZCBpbnQgdGhpc19jcHUgPSBzbXBfcHJv
Y2Vzc29yX2lkKCk7CisJc3RydWN0IHRoZXJtYWxfc3RhdGUgKnBzdGF0ZSA9ICZwZXJfY3B1KHRo
ZXJtYWxfc3RhdGUsIHRoaXNfY3B1KTsKKwl1NjQgbm93ID0gZ2V0X2ppZmZpZXNfNjQoKTsKKwor
CXN0YXRlID0gKGV2ZW50ID09IDApID8gJnBzdGF0ZS0+Y29yZV90aHJlc2gwIDogJnBzdGF0ZS0+
Y29yZV90aHJlc2gxOworCisJaWYgKHRpbWVfYmVmb3JlNjQobm93LCBzdGF0ZS0+bmV4dF9jaGVj
aykpCisJCXJldHVybiAwOworCisJc3RhdGUtPm5leHRfY2hlY2sgPSBub3cgKyBDSEVDS19JTlRF
UlZBTDsKKwlyZXR1cm4gMTsKK30KKwogI2lmZGVmIENPTkZJR19TWVNGUwogLyogQWRkL1JlbW92
ZSB0aGVybWFsX3Rocm90dGxlIGludGVyZmFjZSBmb3IgQ1BVIGRldmljZTogKi8KIHN0YXRpYyBf
X2NwdWluaXQgaW50IHRoZXJtYWxfdGhyb3R0bGVfYWRkX2RldihzdHJ1Y3Qgc3lzX2RldmljZSAq
c3lzX2RldiwKQEAgLTMxMyw2ICszMzQsMjIgQEAgZGV2aWNlX2luaXRjYWxsKHRoZXJtYWxfdGhy
b3R0bGVfaW5pdF9kZXZpY2UpOwogI2RlZmluZSBQQUNLQUdFX1RIUk9UVExFRAkoKF9fdTY0KTIg
PDwgNjIpCiAjZGVmaW5lIFBBQ0tBR0VfUE9XRVJfTElNSVQJKChfX3U2NCkzIDw8IDYyKQogCitz
dGF0aWMgdm9pZCBub3RpZnlfdGhyZXNob2xkcyhfX3U2NCBtc3JfdmFsKQoreworCS8qIGNoZWNr
IHdoZXRoZXIgdGhlIGludGVycnVwdCBoYW5kbGVyIGlzIGRlZmluZWQ7CisJICogb3RoZXJ3aXNl
IHNpbXBseSByZXR1cm4KKwkgKi8KKwlpZiAoIXBsYXRmb3JtX3RoZXJtYWxfbm90aWZ5KQorCQly
ZXR1cm47CisKKwkvKiBsb3dlciB0aHJlc2hvbGQgcmVhY2hlZCAqLworCWlmICgobXNyX3ZhbCAm
IFRIRVJNX0xPR19USFJFU0hPTEQwKSAmJgl0aHJlc2hfZXZlbnRfdmFsaWQoMCkpCisJCXBsYXRm
b3JtX3RoZXJtYWxfbm90aWZ5KG1zcl92YWwpOworCS8qIGhpZ2hlciB0aHJlc2hvbGQgcmVhY2hl
ZCAqLworCWlmICgobXNyX3ZhbCAmIFRIRVJNX0xPR19USFJFU0hPTEQxKSAmJiB0aHJlc2hfZXZl
bnRfdmFsaWQoMSkpCisJCXBsYXRmb3JtX3RoZXJtYWxfbm90aWZ5KG1zcl92YWwpOworfQorCiAv
KiBUaGVybWFsIHRyYW5zaXRpb24gaW50ZXJydXB0IGhhbmRsZXIgKi8KIHN0YXRpYyB2b2lkIGlu
dGVsX3RoZXJtYWxfaW50ZXJydXB0KHZvaWQpCiB7CkBAIC0zMjEsNiArMzU4LDkgQEAgc3RhdGlj
IHZvaWQgaW50ZWxfdGhlcm1hbF9pbnRlcnJ1cHQodm9pZCkKIAogCXJkbXNybChNU1JfSUEzMl9U
SEVSTV9TVEFUVVMsIG1zcl92YWwpOwogCisJLyogQ2hlY2sgZm9yIHZpb2xhdGlvbiBvZiBjb3Jl
IHRoZXJtYWwgdGhyZXNob2xkcyovCisJbm90aWZ5X3RocmVzaG9sZHMobXNyX3ZhbCk7CisKIAlp
ZiAodGhlcm1fdGhyb3RfcHJvY2Vzcyhtc3JfdmFsICYgVEhFUk1fU1RBVFVTX1BST0NIT1QsCiAJ
CQkJVEhFUk1BTF9USFJPVFRMSU5HX0VWRU5ULAogCQkJCUNPUkVfTEVWRUwpICE9IDApCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2h3bW9uL2NvcmV0ZW1wLmMgYi9kcml2ZXJzL2h3bW9uL2NvcmV0ZW1w
LmMKaW5kZXggNDJkZTk4ZC4uMWJmOGFjYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9od21vbi9jb3Jl
dGVtcC5jCisrKyBiL2RyaXZlcnMvaHdtb24vY29yZXRlbXAuYwpAQCAtMzYsMTEgKzM2LDEyIEBA
CiAjaW5jbHVkZSA8YXNtL21zci5oPgogI2luY2x1ZGUgPGFzbS9wcm9jZXNzb3IuaD4KICNpbmNs
dWRlIDxhc20vc21wLmg+CisjaW5jbHVkZSA8YXNtL21jZS5oPgogCiAjZGVmaW5lIERSVk5BTUUJ
ImNvcmV0ZW1wIgogCi10eXBlZGVmIGVudW0geyBTSE9XX1RFTVAsIFNIT1dfVEpNQVgsIFNIT1df
VFRBUkdFVCwgU0hPV19MQUJFTCwKLQkJU0hPV19OQU1FIH0gU0hPVzsKK2VudW0gYXR0cmlidXRl
cyB7IFNIT1dfVEVNUCwgU0hPV19USk1BWCwgQ09SRV9UVEFSR0VULCBDT1JFX1RNSU4sIFNIT1df
TEFCRUwsCisJCVNIT1dfTkFNRSwgU0hPV19DUklUX0FMQVJNLCBTSE9XX01BWF9BTEFSTSB9IGF0
dHJzOwogCiAvKgogICogRnVuY3Rpb25zIGRlY2xhcmF0aW9uCkBAIC01OSw5ICs2MCwxNCBAQCBz
dHJ1Y3QgY29yZXRlbXBfZGF0YSB7CiAJaW50IHRlbXA7CiAJaW50IHRqbWF4OwogCWludCB0dGFy
Z2V0OwotCXU4IGFsYXJtOworCWludCB0bWluOworCXU4IG1heF9hbGFybTsKKwl1OCBjcml0X2Fs
YXJtOwogfTsKIAorc3RhdGljIHZvaWQgdXBkYXRlX2FsYXJtKHN0cnVjdCBjb3JldGVtcF9kYXRh
ICpkYXRhKTsKK3N0YXRpYyBpbnQgc2V0X2NvcmVfdGhyZXNob2xkKHN0cnVjdCBjb3JldGVtcF9k
YXRhICpkYXRhLCBpbnQgdGVtcCwgaW50IHRocmVzKTsKKwogLyoKICAqIFN5c2ZzIHN0dWZmCiAg
Ki8KQEAgLTgzLDkgKzg5LDE1IEBAIHN0YXRpYyBzc2l6ZV90IHNob3dfbmFtZShzdHJ1Y3QgZGV2
aWNlICpkZXYsIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlCiBzdGF0aWMgc3NpemVfdCBzaG93X2Fs
YXJtKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUKIAkJCSAgKmRl
dmF0dHIsIGNoYXIgKmJ1ZikKIHsKLQlzdHJ1Y3QgY29yZXRlbXBfZGF0YSAqZGF0YSA9IGNvcmV0
ZW1wX3VwZGF0ZV9kZXZpY2UoZGV2KTsKLQkvKiByZWFkIHRoZSBPdXQtb2Ytc3BlYyBsb2csIG5l
dmVyIGNsZWFyICovCi0JcmV0dXJuIHNwcmludGYoYnVmLCAiJWRcbiIsIGRhdGEtPmFsYXJtKTsK
KwlzdHJ1Y3Qgc2Vuc29yX2RldmljZV9hdHRyaWJ1dGUgKmF0dHIgPSB0b19zZW5zb3JfZGV2X2F0
dHIoZGV2YXR0cik7CisJc3RydWN0IGNvcmV0ZW1wX2RhdGEgKmRhdGEgPSBkZXZfZ2V0X2RydmRh
dGEoZGV2KTsKKworCXVwZGF0ZV9hbGFybShkYXRhKTsKKwlpZiAoYXR0ci0+aW5kZXggPT0gU0hP
V19DUklUX0FMQVJNKQorCQkvKiByZWFkIHRoZSBPdXQtb2Ytc3BlYyBsb2csIG5ldmVyIGNsZWFy
ICovCisJCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVkXG4iLCBkYXRhLT5jcml0X2FsYXJtKTsKKwor
CXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVkXG4iLCBkYXRhLT5tYXhfYWxhcm0pOwogfQogCiBzdGF0
aWMgc3NpemVfdCBzaG93X3RlbXAoc3RydWN0IGRldmljZSAqZGV2LApAQCAtOTMsMzMgKzEwNSw2
NyBAQCBzdGF0aWMgc3NpemVfdCBzaG93X3RlbXAoc3RydWN0IGRldmljZSAqZGV2LAogewogCXN0
cnVjdCBzZW5zb3JfZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciA9IHRvX3NlbnNvcl9kZXZfYXR0cihk
ZXZhdHRyKTsKIAlzdHJ1Y3QgY29yZXRlbXBfZGF0YSAqZGF0YSA9IGNvcmV0ZW1wX3VwZGF0ZV9k
ZXZpY2UoZGV2KTsKLQlpbnQgZXJyOworCWludCBlcnIgPSAtRUlOVkFMOwogCi0JaWYgKGF0dHIt
PmluZGV4ID09IFNIT1dfVEVNUCkKKwlzd2l0Y2ggKGF0dHItPmluZGV4KSB7CisJY2FzZSBTSE9X
X1RFTVA6CiAJCWVyciA9IGRhdGEtPnZhbGlkID8gc3ByaW50ZihidWYsICIlZFxuIiwgZGF0YS0+
dGVtcCkgOiAtRUFHQUlOOwotCWVsc2UgaWYgKGF0dHItPmluZGV4ID09IFNIT1dfVEpNQVgpCisJ
CWJyZWFrOworCWNhc2UgU0hPV19USk1BWDoKIAkJZXJyID0gc3ByaW50ZihidWYsICIlZFxuIiwg
ZGF0YS0+dGptYXgpOwotCWVsc2UKKwkJYnJlYWs7CisJY2FzZSBDT1JFX1RUQVJHRVQ6CiAJCWVy
ciA9IHNwcmludGYoYnVmLCAiJWRcbiIsIGRhdGEtPnR0YXJnZXQpOworCQlicmVhazsKKwljYXNl
IENPUkVfVE1JTjoKKwkJZXJyID0gc3ByaW50ZihidWYsICIlZFxuIiwgZGF0YS0+dG1pbik7CisJ
CWJyZWFrOworCX0KKwogCXJldHVybiBlcnI7CiB9CiAKKworc3RhdGljIHNzaXplX3Qgc3RvcmVf
dGVtcChzdHJ1Y3QgZGV2aWNlICpkZXYsCisJCXN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICpkZXZh
dHRyLCBjb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkKK3sKKwlzdHJ1Y3Qgc2Vuc29yX2Rl
dmljZV9hdHRyaWJ1dGUgKmF0dHIgPSB0b19zZW5zb3JfZGV2X2F0dHIoZGV2YXR0cik7CisJc3Ry
dWN0IGNvcmV0ZW1wX2RhdGEgKmRhdGEgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsKKwl1bnNpZ25l
ZCBsb25nIHZhbDsKKwlpbnQgZXJyOworCisJaWYgKHN0cmljdF9zdHJ0b3VsKGJ1ZiwgMTAsICZ2
YWwpKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCWVyciA9IHNldF9jb3JlX3RocmVzaG9sZChkYXRh
LCB2YWwsIGF0dHItPmluZGV4KTsKKworCXJldHVybiBlcnIgPyBlcnIgOiBjb3VudDsKK30KKwog
c3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMV9pbnB1dCwgU19JUlVHTywgc2hvd190ZW1w
LCBOVUxMLAogCQkJICBTSE9XX1RFTVApOwogc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1w
MV9jcml0LCBTX0lSVUdPLCBzaG93X3RlbXAsIE5VTEwsCiAJCQkgIFNIT1dfVEpNQVgpOwotc3Rh
dGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMV9tYXgsIFNfSVJVR08sIHNob3dfdGVtcCwgTlVM
TCwKLQkJCSAgU0hPV19UVEFSR0VUKTsKLXN0YXRpYyBERVZJQ0VfQVRUUih0ZW1wMV9jcml0X2Fs
YXJtLCBTX0lSVUdPLCBzaG93X2FsYXJtLCBOVUxMKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FU
VFIodGVtcDFfbWF4LCBTX0lXVVNSIHwgU19JUlVHTywgc2hvd190ZW1wLAorCQkJCQkJc3RvcmVf
dGVtcCwgQ09SRV9UVEFSR0VUKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVtcDFfbWF4
X2h5c3QsIFNfSVdVU1IgfCBTX0lSVUdPLCBzaG93X3RlbXAsCisJCQkJCQlzdG9yZV90ZW1wLCBD
T1JFX1RNSU4pOworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMV9jcml0X2FsYXJtLCBT
X0lSVUdPLCBzaG93X2FsYXJtLCBOVUxMLAorCQkJCQkJCVNIT1dfQ1JJVF9BTEFSTSk7CitzdGF0
aWMgU0VOU09SX0RFVklDRV9BVFRSKHRlbXAxX21heF9hbGFybSwgU19JUlVHTywgc2hvd19hbGFy
bSwgTlVMTCwKKwkJCQkJCQlTSE9XX01BWF9BTEFSTSk7CiBzdGF0aWMgU0VOU09SX0RFVklDRV9B
VFRSKHRlbXAxX2xhYmVsLCBTX0lSVUdPLCBzaG93X25hbWUsIE5VTEwsIFNIT1dfTEFCRUwpOwog
c3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUihuYW1lLCBTX0lSVUdPLCBzaG93X25hbWUsIE5VTEws
IFNIT1dfTkFNRSk7CiAKIHN0YXRpYyBzdHJ1Y3QgYXR0cmlidXRlICpjb3JldGVtcF9hdHRyaWJ1
dGVzW10gPSB7CiAJJnNlbnNvcl9kZXZfYXR0cl9uYW1lLmRldl9hdHRyLmF0dHIsCiAJJnNlbnNv
cl9kZXZfYXR0cl90ZW1wMV9sYWJlbC5kZXZfYXR0ci5hdHRyLAotCSZkZXZfYXR0cl90ZW1wMV9j
cml0X2FsYXJtLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9jcml0X2FsYXJtLmRldl9h
dHRyLmF0dHIsCiAJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9pbnB1dC5kZXZfYXR0ci5hdHRyLAog
CSZzZW5zb3JfZGV2X2F0dHJfdGVtcDFfY3JpdC5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2
X2F0dHJfdGVtcDFfbWF4LmRldl9hdHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9t
YXhfaHlzdC5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfdGVtcDFfbWF4X2FsYXJt
LmRldl9hdHRyLmF0dHIsCiAJTlVMTAogfTsKIApAQCAtMTI3LDYgKzE3MywyNiBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCBjb3JldGVtcF9ncm91cCA9IHsKIAkuYXR0cnMg
PSBjb3JldGVtcF9hdHRyaWJ1dGVzLAogfTsKIAorc3RhdGljIHZvaWQgdXBkYXRlX2FsYXJtKHN0
cnVjdCBjb3JldGVtcF9kYXRhICpkYXRhKQoreworCXUzMiBlYXgsIGVkeDsKKworCXJkbXNyX29u
X2NwdShkYXRhLT5pZCwgTVNSX0lBMzJfVEhFUk1fU1RBVFVTLCAmZWF4LCAmZWR4KTsKKworCS8q
IFVwZGF0ZSB0aGUgY3JpdGljYWwgdGVtcGVyYXR1cmUgYWxhcm0gKi8KKwlkYXRhLT5jcml0X2Fs
YXJtID0gKGVheCA+PiA1KSAmIDE7CisKKwkvKiBUZW1wZXJhdHVyZSByZWFjaGVkIHRocmVzaG9s
ZDEgKi8KKwlpZiAoZWF4ICYgVEhFUk1fTE9HX1RIUkVTSE9MRDEpCisJCWRhdGEtPm1heF9hbGFy
bSA9IDE7CisJLyogVGVtcGVyYXR1cmUgcmVhY2hlZCB0aHJlc2hvbGQwICovCisJZWxzZSBpZiAo
ZWF4ICYgVEhFUk1fTE9HX1RIUkVTSE9MRDApCisJCWRhdGEtPm1heF9hbGFybSA9IDA7CisJLyog
SWYgbm9uZSBvZiB0aGVzZSBjYXNlcywgZG9uJ3QgdXBkYXRlIG1heF9hbGFybSAqLworCisJcmV0
dXJuOworfQorCiBzdGF0aWMgc3RydWN0IGNvcmV0ZW1wX2RhdGEgKmNvcmV0ZW1wX3VwZGF0ZV9k
ZXZpY2Uoc3RydWN0IGRldmljZSAqZGV2KQogewogCXN0cnVjdCBjb3JldGVtcF9kYXRhICpkYXRh
ID0gZGV2X2dldF9kcnZkYXRhKGRldik7CkBAIC0xMzgsNyArMjA0LDYgQEAgc3RhdGljIHN0cnVj
dCBjb3JldGVtcF9kYXRhICpjb3JldGVtcF91cGRhdGVfZGV2aWNlKHN0cnVjdCBkZXZpY2UgKmRl
dikKIAogCQlkYXRhLT52YWxpZCA9IDA7CiAJCXJkbXNyX29uX2NwdShkYXRhLT5pZCwgTVNSX0lB
MzJfVEhFUk1fU1RBVFVTLCAmZWF4LCAmZWR4KTsKLQkJZGF0YS0+YWxhcm0gPSAoZWF4ID4+IDUp
ICYgMTsKIAkJLyogdXBkYXRlIG9ubHkgaWYgZGF0YSBoYXMgYmVlbiB2YWxpZCAqLwogCQlpZiAo
ZWF4ICYgMHg4MDAwMDAwMCkgewogCQkJZGF0YS0+dGVtcCA9IGRhdGEtPnRqbWF4IC0gKCgoZWF4
ID4+IDE2KQpAQCAtMjk4LDYgKzM2MywxMDYgQEAgc3RhdGljIHZvaWQgX19kZXZpbml0IGdldF91
Y29kZV9yZXZfb25fY3B1KHZvaWQgKmVkeCkKIAlyZG1zcihNU1JfSUEzMl9VQ09ERV9SRVYsIGVh
eCwgKih1MzIgKillZHgpOwogfQogCisvKiBQbGF0Zm9ybSB0aGVybWFsIEludGVycnVwdCBIYW5k
bGVyICovCitzdGF0aWMgaW50IGNvcmV0ZW1wX2ludGVycnVwdChfX3U2NCBtc3JfdmFsKQorewor
CisJaWYgKG1zcl92YWwgJiBUSEVSTV9MT0dfVEhSRVNIT0xEMCkgeworCQlpZiAoIShtc3JfdmFs
ICYgVEhFUk1fU1RBVFVTX1RIUkVTSE9MRDApKQorCQkJcHJfaW5mbygiJXM6TG93ZXIgVGhyZXNo
b2xkIFJlYWNoZWRcbiIsIF9fZnVuY19fKTsKKwkJLyogUmVzZXQgdGhlIFRocmVzaG9sZDAgaW50
ZXJydXB0ICovCisJCXdybXNybChNU1JfSUEzMl9USEVSTV9TVEFUVVMsIG1zcl92YWwgJiB+VEhF
Uk1fTE9HX1RIUkVTSE9MRDApOworCX0KKworCWlmIChtc3JfdmFsICYgVEhFUk1fTE9HX1RIUkVT
SE9MRDEpIHsKKwkJaWYgKG1zcl92YWwgJiBUSEVSTV9TVEFUVVNfVEhSRVNIT0xEMSkKKwkJCXBy
X2luZm8oIiVzOlVwcGVyIFRocmVzaG9sZCBSZWFjaGVkXG4iLCBfX2Z1bmNfXyk7CisJCS8qIFJl
c2V0IHRoZSBUaHJlc2hvbGQxIGludGVycnVwdCAqLworCQl3cm1zcmwoTVNSX0lBMzJfVEhFUk1f
U1RBVFVTLCBtc3JfdmFsICYgflRIRVJNX0xPR19USFJFU0hPTEQxKTsKKwl9CisKKwlyZXR1cm4g
MDsKK30KKworc3RhdGljIHZvaWQgY29uZmlndXJlX2FwaWModm9pZCAqaW5mbykKK3sKKwl1MzIg
bDsKKwlpbnQgKmZsYWcgPSAoaW50ICopaW5mbzsKKworCWwgPSBhcGljX3JlYWQoQVBJQ19MVlRU
SE1SKTsKKworCWlmICgqZmxhZykJLyogTm9uLVplcm8gZmxhZyBNYXNrcyB0aGUgQVBJQyAqLwor
CQlhcGljX3dyaXRlKEFQSUNfTFZUVEhNUiwgbCB8IEFQSUNfTFZUX01BU0tFRCk7CisJZWxzZQkJ
LyogWmVybyBmbGFnIFVuTWFza3MgdGhlIEFQSUMgKi8KKwkJYXBpY193cml0ZShBUElDX0xWVFRI
TVIsIGwgJiB+QVBJQ19MVlRfTUFTS0VEKTsKK30KKworc3RhdGljIGludCBzZXRfY29yZV90aHJl
c2hvbGQoc3RydWN0IGNvcmV0ZW1wX2RhdGEgKmRhdGEsIGludCB0ZW1wLCBpbnQgdGhyZXMpCit7
CisJdTMyIGVheCwgZWR4OworCWludCBkaWZmOworCWludCBmbGFnID0gMTsKKworCWlmICh0ZW1w
ID4gZGF0YS0+dGptYXgpCisJCXJldHVybiAtRUlOVkFMOworCisJbXV0ZXhfbG9jaygmZGF0YS0+
dXBkYXRlX2xvY2spOworCisJZGlmZiA9IChkYXRhLT50am1heCAtIHRlbXApLzEwMDA7CisKKwkv
KiBNYXNrIHRoZSBBUElDICovCisJc21wX2NhbGxfZnVuY3Rpb25fc2luZ2xlKGRhdGEtPmlkLCAm
Y29uZmlndXJlX2FwaWMsICZmbGFnLCAxKTsKKworCXJkbXNyX29uX2NwdShkYXRhLT5pZCwgTVNS
X0lBMzJfVEhFUk1fSU5URVJSVVBULCAmZWF4LCAmZWR4KTsKKworCWlmICh0aHJlcyA9PSBDT1JF
X1RNSU4pIHsKKwkJZWF4ID0gKGVheCAmIH5USEVSTV9NQVNLX1RIUkVTSE9MRDApIHwKKwkJCQkJ
KGRpZmYgPDwgVEhFUk1fU0hJRlRfVEhSRVNIT0xEMCk7CisJCWRhdGEtPnRtaW4gPSB0ZW1wOwor
CX0gZWxzZSB7CisJCWVheCA9IChlYXggJiB+VEhFUk1fTUFTS19USFJFU0hPTEQxKSB8CisJCQkJ
CShkaWZmIDw8IFRIRVJNX1NISUZUX1RIUkVTSE9MRDEpOworCQlkYXRhLT50dGFyZ2V0ID0gdGVt
cDsKKwl9CisKKwl3cm1zcl9vbl9jcHUoZGF0YS0+aWQsIE1TUl9JQTMyX1RIRVJNX0lOVEVSUlVQ
VCwgZWF4LCBlZHgpOworCisJLyogVW5tYXNrIHRoZSBBUElDICovCisJZmxhZyA9IDA7CisJc21w
X2NhbGxfZnVuY3Rpb25fc2luZ2xlKGRhdGEtPmlkLCAmY29uZmlndXJlX2FwaWMsICZmbGFnLCAx
KTsKKworCW11dGV4X3VubG9jaygmZGF0YS0+dXBkYXRlX2xvY2spOworCXJldHVybiAwOworfQor
CitzdGF0aWMgaW50IF9fZGV2aW5pdCBjb25maWdfdGhyZXNoX2ludHJwdChzdHJ1Y3QgY29yZXRl
bXBfZGF0YSAqZGF0YSwKKwkJCQkJCQkJaW50IGVuYWJsZSkKK3sKKwl1MzIgZWF4LCBlZHg7CisJ
aW50IGZsYWcgPSAxOyAvKiBOb24tWmVybyBGbGFnIG1hc2tzIHRoZSBhcGljICovCisKKwlzbXBf
Y2FsbF9mdW5jdGlvbl9zaW5nbGUoZGF0YS0+aWQsICZjb25maWd1cmVfYXBpYywgJmZsYWcsIDEp
OworCisJcmRtc3Jfb25fY3B1KGRhdGEtPmlkLCBNU1JfSUEzMl9USEVSTV9JTlRFUlJVUFQsICZl
YXgsICZlZHgpOworCisJaWYgKGVuYWJsZSkgeworCQllYXggfD0gKFRIRVJNX0lOVF9USFJFU0hP
TEQwX0VOQUJMRSB8CisJCQkJCQlUSEVSTV9JTlRfVEhSRVNIT0xEMV9FTkFCTEUpOworCQlwbGF0
Zm9ybV90aGVybWFsX25vdGlmeSA9IGNvcmV0ZW1wX2ludGVycnVwdDsKKwl9IGVsc2UgeworCQll
YXggJj0gKH4oVEhFUk1fSU5UX1RIUkVTSE9MRDBfRU5BQkxFIHwKKwkJCQkJCVRIRVJNX0lOVF9U
SFJFU0hPTEQxX0VOQUJMRSkpOworCQlwbGF0Zm9ybV90aGVybWFsX25vdGlmeSA9IE5VTEw7CisJ
fQorCisJd3Jtc3Jfb25fY3B1KGRhdGEtPmlkLCBNU1JfSUEzMl9USEVSTV9JTlRFUlJVUFQsIGVh
eCwgZWR4KTsKKworCWZsYWcgPSAwOyAvKkZsYWcgc2hvdWxkIGJlIHplcm8gdG8gdW5tYXNrIHRo
ZSBhcGljICovCisJc21wX2NhbGxfZnVuY3Rpb25fc2luZ2xlKGRhdGEtPmlkLCAmY29uZmlndXJl
X2FwaWMsICZmbGFnLCAxKTsKKworCXJldHVybiAwOworfQorCiBzdGF0aWMgaW50IF9fZGV2aW5p
dCBjb3JldGVtcF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogewogCXN0cnVj
dCBjb3JldGVtcF9kYXRhICpkYXRhOwpAQCAtMzUxLDYgKzUxNiwxMCBAQCBzdGF0aWMgaW50IF9f
ZGV2aW5pdCBjb3JldGVtcF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCX0K
IAogCWRhdGEtPnRqbWF4ID0gZ2V0X3RqbWF4KGMsIGRhdGEtPmlkLCAmcGRldi0+ZGV2KTsKKwkv
KiBJbml0aWFsaXplIHR0YXJnZXQgdmFsdWUuIElmIElBMzJfVEVNUEVSQVRVUkVfVEFSR0VUIGlz
CisJICogc3VwcG9ydGVkLCB0aGlzIHZhbHVlIHdpbGwgYmUgb3ZlciB3cml0dGVuIGJlbG93CisJ
ICovCisJZGF0YS0+dHRhcmdldCA9IGRhdGEtPnRqbWF4IC0gMjAwMDA7CiAJcGxhdGZvcm1fc2V0
X2RydmRhdGEocGRldiwgZGF0YSk7CiAKIAkvKgpAQCAtMzY4LDEzICs1MzcsMTggQEAgc3RhdGlj
IGludCBfX2RldmluaXQgY29yZXRlbXBfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRl
dikKIAkJfSBlbHNlIHsKIAkJCWRhdGEtPnR0YXJnZXQgPSBkYXRhLT50am1heCAtCiAJCQkJCSgo
KGVheCA+PiA4KSAmIDB4ZmYpICogMTAwMCk7Ci0JCQllcnIgPSBkZXZpY2VfY3JlYXRlX2ZpbGUo
JnBkZXYtPmRldiwKLQkJCQkJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9tYXguZGV2X2F0dHIpOwot
CQkJaWYgKGVycikKLQkJCQlnb3RvIGV4aXRfZnJlZTsKIAkJfQogCX0KIAorCS8qIEVuYWJsZSB0
aHJlc2hvbGQgaW50ZXJydXB0IHN1cHBvcnQgKi8KKwljb25maWdfdGhyZXNoX2ludHJwdChkYXRh
LCAxKTsKKworCS8qIFNldCBJbml0aWFsIENvcmUgdGhyZXNob2xkcy4KKwkgKiBUaGUgbG93ZXIg
YW5kIHVwcGVyIHRocmVzaG9sZCB2YWx1ZXMgaGVyZSBhcmUgYXNzdW1lZAorCSAqLworCXNldF9j
b3JlX3RocmVzaG9sZChkYXRhLCAwLCBDT1JFX1RNSU4pOworCXNldF9jb3JlX3RocmVzaG9sZChk
YXRhLCBkYXRhLT50dGFyZ2V0LCBDT1JFX1RUQVJHRVQpOworCiAJaWYgKChlcnIgPSBzeXNmc19j
cmVhdGVfZ3JvdXAoJnBkZXYtPmRldi5rb2JqLCAmY29yZXRlbXBfZ3JvdXApKSkKIAkJZ290byBl
eGl0X2RldjsKIApAQCAtNDA0LDcgKzU3OCw3IEBAIHN0YXRpYyBpbnQgX19kZXZleGl0IGNvcmV0
ZW1wX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCiAJaHdtb25fZGV2aWNl
X3VucmVnaXN0ZXIoZGF0YS0+aHdtb25fZGV2KTsKIAlzeXNmc19yZW1vdmVfZ3JvdXAoJnBkZXYt
PmRldi5rb2JqLCAmY29yZXRlbXBfZ3JvdXApOwotCWRldmljZV9yZW1vdmVfZmlsZSgmcGRldi0+
ZGV2LCAmc2Vuc29yX2Rldl9hdHRyX3RlbXAxX21heC5kZXZfYXR0cik7CisJY29uZmlnX3RocmVz
aF9pbnRycHQoZGF0YSwgMCk7CiAJcGxhdGZvcm1fc2V0X2RydmRhdGEocGRldiwgTlVMTCk7CiAJ
a2ZyZWUoZGF0YSk7CiAJcmV0dXJuIDA7Ci0tIAoxLjYuNS4yCgo=

--_002_D6D887BA8C9DFF48B5233887EF04654105C1173BCDbgsmsx502garc_--
