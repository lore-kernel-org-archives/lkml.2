Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1ACLx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:53:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:61985 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab1ACLx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:53:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,266,1291622400"; 
   d="txt'?scan'208";a="873934809"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Mon, 3 Jan 2011 17:23:19 +0530
Subject: Patch[2/2]:hwmon:Adding_Threshold_Support_to_Coretemp.c
Thread-Topic: Patch[2/2]:hwmon:Adding_Threshold_Support_to_Coretemp.c
Thread-Index: AcugDH7j0CGLX8P7R+WaTUw3u+AkagLMCoOg
Message-ID: <D6D887BA8C9DFF48B5233887EF04654105C1251712@bgsmsx502.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_003_D6D887BA8C9DFF48B5233887EF04654105C1251712bgsmsx502garc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_003_D6D887BA8C9DFF48B5233887EF04654105C1251712bgsmsx502garc_
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

Date: Sun, 19 Dec 2010 22:44:54 +0530
Subject: [PATCH 2/2] hwmon:Adding_Threshold_Support_to_Coretemp

This patch adds core thermal thresholds support to coretemp.
These thresholds can be configured via the sysfs interfaces temp1_max
and temp1_max_hyst. An interrupt is generated when CPU temperature
goes above temp1_max or drops below temp1_max_hyst.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>

---
 Documentation/hwmon/coretemp |    8 ++
 drivers/hwmon/coretemp.c     |  214 ++++++++++++++++++++++++++++++++++++++=
----
 2 files changed, 202 insertions(+), 20 deletions(-)

diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
index 25568f8..615fdbe 100644
--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -29,6 +29,14 @@ the Out-Of-Spec bit. Following table summarizes the expo=
rted sysfs files:
=20
 temp1_input	 - Core temperature (in millidegrees Celsius).
 temp1_max	 - All cooling devices should be turned on (on Core2).
+		   Initialized with IA32_TEMPERATURE_TARGET if supported,
+		   otherwise initialized with (tjmax - 20). When the CPU
+		   temperature reaches this temperature, an interrupt is
+		   generated and temp1_max_alarm is set.
+temp1_max_hyst	 - If the CPU temperature falls below than temperature,
+		   an interrupt is generated and temp1_max_alarm is reset.
+temp1_max_alarm - Set if the temperature reaches or exceeds temp1_max.
+		   Reset if the temperature drops to or below temp1_max_hyst.
 temp1_crit	 - Maximum junction temperature (in millidegrees Celsius).
 temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
 		   Correct CPU operation is no longer guaranteed.
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 42de98d..025902f 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -36,11 +36,12 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
+#include <asm/mce.h>
=20
 #define DRVNAME	"coretemp"
=20
-typedef enum { SHOW_TEMP, SHOW_TJMAX, SHOW_TTARGET, SHOW_LABEL,
-		SHOW_NAME } SHOW;
+enum attributes { SHOW_TEMP, SHOW_TJMAX, CORE_TTARGET, CORE_TMIN, SHOW_LAB=
EL,
+		SHOW_NAME, SHOW_CRIT_ALARM, SHOW_MAX_ALARM } attrs;
=20
 /*
  * Functions declaration
@@ -59,9 +60,14 @@ struct coretemp_data {
 	int temp;
 	int tjmax;
 	int ttarget;
-	u8 alarm;
+	int tmin;
+	u8 max_alarm;
+	u8 crit_alarm;
 };
=20
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
-	struct coretemp_data *data =3D coretemp_update_device(dev);
-	/* read the Out-of-spec log, never clear */
-	return sprintf(buf, "%d\n", data->alarm);
+	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr);
+	struct coretemp_data *data =3D dev_get_drvdata(dev);
+
+	update_alarm(data);
+	if (attr->index =3D=3D SHOW_CRIT_ALARM)
+		/* read the Out-of-spec log, never clear */
+		return sprintf(buf, "%d\n", data->crit_alarm);
+
+	return sprintf(buf, "%d\n", data->max_alarm);
 }
=20
 static ssize_t show_temp(struct device *dev,
@@ -93,33 +105,67 @@ static ssize_t show_temp(struct device *dev,
 {
 	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr);
 	struct coretemp_data *data =3D coretemp_update_device(dev);
-	int err;
+	int err =3D -EINVAL;
=20
-	if (attr->index =3D=3D SHOW_TEMP)
+	switch (attr->index) {
+	case SHOW_TEMP:
 		err =3D data->valid ? sprintf(buf, "%d\n", data->temp) : -EAGAIN;
-	else if (attr->index =3D=3D SHOW_TJMAX)
+		break;
+	case SHOW_TJMAX:
 		err =3D sprintf(buf, "%d\n", data->tjmax);
-	else
+		break;
+	case CORE_TTARGET:
 		err =3D sprintf(buf, "%d\n", data->ttarget);
+		break;
+	case CORE_TMIN:
+		err =3D sprintf(buf, "%d\n", data->tmin);
+		break;
+	}
+
 	return err;
 }
=20
+
+static ssize_t store_temp(struct device *dev,
+		struct device_attribute *devattr, const char *buf, size_t count)
+{
+	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr);
+	struct coretemp_data *data =3D dev_get_drvdata(dev);
+	unsigned long val;
+	int err;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+
+	err =3D set_core_threshold(data, val, attr->index);
+
+	return err ? err : count;
+}
+
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL,
 			  SHOW_TEMP);
 static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, show_temp, NULL,
 			  SHOW_TJMAX);
-static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO, show_temp, NULL,
-			  SHOW_TTARGET);
-static DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp,
+						store_temp, CORE_TTARGET);
+static SENSOR_DEVICE_ATTR(temp1_max_hyst, S_IWUSR | S_IRUGO, show_temp,
+						store_temp, CORE_TMIN);
+static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL,
+							SHOW_CRIT_ALARM);
+static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_alarm, NULL,
+							SHOW_MAX_ALARM);
 static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_name, NULL, SHOW_LABE=
L);
 static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, SHOW_NAME);
=20
 static struct attribute *coretemp_attributes[] =3D {
 	&sensor_dev_attr_name.dev_attr.attr,
 	&sensor_dev_attr_temp1_label.dev_attr.attr,
-	&dev_attr_temp1_crit_alarm.attr,
+	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	&sensor_dev_attr_temp1_max.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
 	NULL
 };
=20
@@ -127,6 +173,26 @@ static const struct attribute_group coretemp_group =3D=
 {
 	.attrs =3D coretemp_attributes,
 };
=20
+static void update_alarm(struct coretemp_data *data)
+{
+	u32 eax, edx;
+
+	rdmsr_on_cpu(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
+
+	/* Update the critical temperature alarm */
+	data->crit_alarm =3D (eax >> 5) & 1;
+
+	/* Temperature reached threshold1 */
+	if (eax & THERM_LOG_THRESHOLD1)
+		data->max_alarm =3D 1;
+	/* Temperature reached threshold0 */
+	else if (eax & THERM_LOG_THRESHOLD0)
+		data->max_alarm =3D 0;
+	/* If none of these cases, don't update max_alarm */
+
+	return;
+}
+
 static struct coretemp_data *coretemp_update_device(struct device *dev)
 {
 	struct coretemp_data *data =3D dev_get_drvdata(dev);
@@ -138,7 +204,6 @@ static struct coretemp_data *coretemp_update_device(str=
uct device *dev)
=20
 		data->valid =3D 0;
 		rdmsr_on_cpu(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
-		data->alarm =3D (eax >> 5) & 1;
 		/* update only if data has been valid */
 		if (eax & 0x80000000) {
 			data->temp =3D data->tjmax - (((eax >> 16)
@@ -298,6 +363,106 @@ static void __devinit get_ucode_rev_on_cpu(void *edx)
 	rdmsr(MSR_IA32_UCODE_REV, eax, *(u32 *)edx);
 }
=20
+/* Platform thermal Interrupt Handler */
+static int coretemp_interrupt(__u64 msr_val)
+{
+
+	if (msr_val & THERM_LOG_THRESHOLD0) {
+		if (!(msr_val & THERM_STATUS_THRESHOLD0))
+			pr_info("%s:Lower Threshold Reached\n", __func__);
+		/* Reset the Threshold0 interrupt */
+		wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOLD0);
+	}
+
+	if (msr_val & THERM_LOG_THRESHOLD1) {
+		if (msr_val & THERM_STATUS_THRESHOLD1)
+			pr_info("%s:Upper Threshold Reached\n", __func__);
+		/* Reset the Threshold1 interrupt */
+		wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOLD1);
+	}
+
+	return 0;
+}
+
+static void configure_apic(void *info)
+{
+	u32 l;
+	int *flag =3D (int *)info;
+
+	l =3D apic_read(APIC_LVTTHMR);
+
+	if (*flag)	/* Non-Zero flag Masks the APIC */
+		apic_write(APIC_LVTTHMR, l | APIC_LVT_MASKED);
+	else		/* Zero flag UnMasks the APIC */
+		apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
+}
+
+static int set_core_threshold(struct coretemp_data *data, int temp, int th=
res)
+{
+	u32 eax, edx;
+	int diff;
+	int flag =3D 1;
+
+	if (temp > data->tjmax)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+
+	diff =3D (data->tjmax - temp)/1000;
+
+	/* Mask the APIC */
+	smp_call_function_single(data->id, &configure_apic, &flag, 1);
+
+	rdmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, &eax, &edx);
+
+	if (thres =3D=3D CORE_TMIN) {
+		eax =3D (eax & ~THERM_MASK_THRESHOLD0) |
+					(diff << THERM_SHIFT_THRESHOLD0);
+		data->tmin =3D temp;
+	} else {
+		eax =3D (eax & ~THERM_MASK_THRESHOLD1) |
+					(diff << THERM_SHIFT_THRESHOLD1);
+		data->ttarget =3D temp;
+	}
+
+	wrmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, eax, edx);
+
+	/* Unmask the APIC */
+	flag =3D 0;
+	smp_call_function_single(data->id, &configure_apic, &flag, 1);
+
+	mutex_unlock(&data->update_lock);
+	return 0;
+}
+
+static int __devinit config_thresh_intrpt(struct coretemp_data *data,
+								int enable)
+{
+	u32 eax, edx;
+	int flag =3D 1; /* Non-Zero Flag masks the apic */
+
+	smp_call_function_single(data->id, &configure_apic, &flag, 1);
+
+	rdmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, &eax, &edx);
+
+	if (enable) {
+		eax |=3D (THERM_INT_THRESHOLD0_ENABLE |
+						THERM_INT_THRESHOLD1_ENABLE);
+		platform_thermal_notify =3D coretemp_interrupt;
+	} else {
+		eax &=3D (~(THERM_INT_THRESHOLD0_ENABLE |
+						THERM_INT_THRESHOLD1_ENABLE));
+		platform_thermal_notify =3D NULL;
+	}
+
+	wrmsr_on_cpu(data->id, MSR_IA32_THERM_INTERRUPT, eax, edx);
+
+	flag =3D 0; /*Flag should be zero to unmask the apic */
+	smp_call_function_single(data->id, &configure_apic, &flag, 1);
+
+	return 0;
+}
+
 static int __devinit coretemp_probe(struct platform_device *pdev)
 {
 	struct coretemp_data *data;
@@ -351,6 +516,10 @@ static int __devinit coretemp_probe(struct platform_de=
vice *pdev)
 	}
=20
 	data->tjmax =3D get_tjmax(c, data->id, &pdev->dev);
+	/* Initialize ttarget value. If IA32_TEMPERATURE_TARGET is
+	 * supported, this value will be over written below
+	 */
+	data->ttarget =3D data->tjmax - 20000;
 	platform_set_drvdata(pdev, data);
=20
 	/*
@@ -368,13 +537,18 @@ static int __devinit coretemp_probe(struct platform_d=
evice *pdev)
 		} else {
 			data->ttarget =3D data->tjmax -
 					(((eax >> 8) & 0xff) * 1000);
-			err =3D device_create_file(&pdev->dev,
-					&sensor_dev_attr_temp1_max.dev_attr);
-			if (err)
-				goto exit_free;
 		}
 	}
=20
+	/* Enable threshold interrupt support */
+	config_thresh_intrpt(data, 1);
+
+	/* Set Initial Core thresholds.
+	 * The lower and upper threshold values here are assumed
+	 */
+	set_core_threshold(data, 0, CORE_TMIN);
+	set_core_threshold(data, data->ttarget, CORE_TTARGET);
+
 	if ((err =3D sysfs_create_group(&pdev->dev.kobj, &coretemp_group)))
 		goto exit_dev;
=20
@@ -404,7 +578,7 @@ static int __devexit coretemp_remove(struct platform_de=
vice *pdev)
=20
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &coretemp_group);
-	device_remove_file(&pdev->dev, &sensor_dev_attr_temp1_max.dev_attr);
+	config_thresh_intrpt(data, 0);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 	return 0;
--=20
1.6.5.2


--_003_D6D887BA8C9DFF48B5233887EF04654105C1251712bgsmsx502garc_
Content-Type: application/octet-stream;
	name="0002-hwmon-Adding_Threshold_Support_to_Coretemp.patch"
Content-Description: 0002-hwmon-Adding_Threshold_Support_to_Coretemp.patch
Content-Disposition: attachment;
	filename="0002-hwmon-Adding_Threshold_Support_to_Coretemp.patch"; size=10983;
	creation-date="Mon, 20 Dec 2010 16:55:25 GMT";
	modification-date="Mon, 20 Dec 2010 04:53:46 GMT"
Content-Transfer-Encoding: base64

RnJvbTogRHVyZ2Fkb3NzIFIgPGR1cmdhZG9zcy5yQGludGVsLmNvbT4KRGF0ZTogU3VuLCAxOSBE
ZWMgMjAxMCAyMjo0NDo1NCArMDUzMApTdWJqZWN0OiBbUEFUQ0ggMi8yXSBod21vbjpBZGRpbmdf
VGhyZXNob2xkX1N1cHBvcnRfdG9fQ29yZXRlbXAKClRoaXMgcGF0Y2ggYWRkcyBjb3JlIHRoZXJt
YWwgdGhyZXNob2xkcyBzdXBwb3J0IHRvIGNvcmV0ZW1wLgpUaGVzZSB0aHJlc2hvbGRzIGNhbiBi
ZSBjb25maWd1cmVkIHZpYSB0aGUgc3lzZnMgaW50ZXJmYWNlcyB0ZW1wMV9tYXgKYW5kIHRlbXAx
X21heF9oeXN0LiBBbiBpbnRlcnJ1cHQgaXMgZ2VuZXJhdGVkIHdoZW4gQ1BVIHRlbXBlcmF0dXJl
CmdvZXMgYWJvdmUgdGVtcDFfbWF4IG9yIGRyb3BzIGJlbG93IHRlbXAxX21heF9oeXN0LgoKU2ln
bmVkLW9mZi1ieTogRHVyZ2Fkb3NzIFIgPGR1cmdhZG9zcy5yQGludGVsLmNvbT4KLS0tCiBEb2N1
bWVudGF0aW9uL2h3bW9uL2NvcmV0ZW1wIHwgICAgOCArKwogZHJpdmVycy9od21vbi9jb3JldGVt
cC5jICAgICB8ICAyMTQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0t
CiAyIGZpbGVzIGNoYW5nZWQsIDIwMiBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2h3bW9uL2NvcmV0ZW1wIGIvRG9jdW1lbnRhdGlvbi9o
d21vbi9jb3JldGVtcAppbmRleCAyNTU2OGY4Li42MTVmZGJlIDEwMDY0NAotLS0gYS9Eb2N1bWVu
dGF0aW9uL2h3bW9uL2NvcmV0ZW1wCisrKyBiL0RvY3VtZW50YXRpb24vaHdtb24vY29yZXRlbXAK
QEAgLTI5LDYgKzI5LDE0IEBAIHRoZSBPdXQtT2YtU3BlYyBiaXQuIEZvbGxvd2luZyB0YWJsZSBz
dW1tYXJpemVzIHRoZSBleHBvcnRlZCBzeXNmcyBmaWxlczoKIAogdGVtcDFfaW5wdXQJIC0gQ29y
ZSB0ZW1wZXJhdHVyZSAoaW4gbWlsbGlkZWdyZWVzIENlbHNpdXMpLgogdGVtcDFfbWF4CSAtIEFs
bCBjb29saW5nIGRldmljZXMgc2hvdWxkIGJlIHR1cm5lZCBvbiAob24gQ29yZTIpLgorCQkgICBJ
bml0aWFsaXplZCB3aXRoIElBMzJfVEVNUEVSQVRVUkVfVEFSR0VUIGlmIHN1cHBvcnRlZCwKKwkJ
ICAgb3RoZXJ3aXNlIGluaXRpYWxpemVkIHdpdGggKHRqbWF4IC0gMjApLiBXaGVuIHRoZSBDUFUK
KwkJICAgdGVtcGVyYXR1cmUgcmVhY2hlcyB0aGlzIHRlbXBlcmF0dXJlLCBhbiBpbnRlcnJ1cHQg
aXMKKwkJICAgZ2VuZXJhdGVkIGFuZCB0ZW1wMV9tYXhfYWxhcm0gaXMgc2V0LgordGVtcDFfbWF4
X2h5c3QJIC0gSWYgdGhlIENQVSB0ZW1wZXJhdHVyZSBmYWxscyBiZWxvdyB0aGFuIHRlbXBlcmF0
dXJlLAorCQkgICBhbiBpbnRlcnJ1cHQgaXMgZ2VuZXJhdGVkIGFuZCB0ZW1wMV9tYXhfYWxhcm0g
aXMgcmVzZXQuCit0ZW1wMV9tYXhfYWxhcm0gLSBTZXQgaWYgdGhlIHRlbXBlcmF0dXJlIHJlYWNo
ZXMgb3IgZXhjZWVkcyB0ZW1wMV9tYXguCisJCSAgIFJlc2V0IGlmIHRoZSB0ZW1wZXJhdHVyZSBk
cm9wcyB0byBvciBiZWxvdyB0ZW1wMV9tYXhfaHlzdC4KIHRlbXAxX2NyaXQJIC0gTWF4aW11bSBq
dW5jdGlvbiB0ZW1wZXJhdHVyZSAoaW4gbWlsbGlkZWdyZWVzIENlbHNpdXMpLgogdGVtcDFfY3Jp
dF9hbGFybSAtIFNldCB3aGVuIE91dC1vZi1zcGVjIGJpdCBpcyBzZXQsIG5ldmVyIGNsZWFycy4K
IAkJICAgQ29ycmVjdCBDUFUgb3BlcmF0aW9uIGlzIG5vIGxvbmdlciBndWFyYW50ZWVkLgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9od21vbi9jb3JldGVtcC5jIGIvZHJpdmVycy9od21vbi9jb3JldGVt
cC5jCmluZGV4IDQyZGU5OGQuLjAyNTkwMmYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaHdtb24vY29y
ZXRlbXAuYworKysgYi9kcml2ZXJzL2h3bW9uL2NvcmV0ZW1wLmMKQEAgLTM2LDExICszNiwxMiBA
QAogI2luY2x1ZGUgPGFzbS9tc3IuaD4KICNpbmNsdWRlIDxhc20vcHJvY2Vzc29yLmg+CiAjaW5j
bHVkZSA8YXNtL3NtcC5oPgorI2luY2x1ZGUgPGFzbS9tY2UuaD4KIAogI2RlZmluZSBEUlZOQU1F
CSJjb3JldGVtcCIKIAotdHlwZWRlZiBlbnVtIHsgU0hPV19URU1QLCBTSE9XX1RKTUFYLCBTSE9X
X1RUQVJHRVQsIFNIT1dfTEFCRUwsCi0JCVNIT1dfTkFNRSB9IFNIT1c7CitlbnVtIGF0dHJpYnV0
ZXMgeyBTSE9XX1RFTVAsIFNIT1dfVEpNQVgsIENPUkVfVFRBUkdFVCwgQ09SRV9UTUlOLCBTSE9X
X0xBQkVMLAorCQlTSE9XX05BTUUsIFNIT1dfQ1JJVF9BTEFSTSwgU0hPV19NQVhfQUxBUk0gfSBh
dHRyczsKIAogLyoKICAqIEZ1bmN0aW9ucyBkZWNsYXJhdGlvbgpAQCAtNTksOSArNjAsMTQgQEAg
c3RydWN0IGNvcmV0ZW1wX2RhdGEgewogCWludCB0ZW1wOwogCWludCB0am1heDsKIAlpbnQgdHRh
cmdldDsKLQl1OCBhbGFybTsKKwlpbnQgdG1pbjsKKwl1OCBtYXhfYWxhcm07CisJdTggY3JpdF9h
bGFybTsKIH07CiAKK3N0YXRpYyB2b2lkIHVwZGF0ZV9hbGFybShzdHJ1Y3QgY29yZXRlbXBfZGF0
YSAqZGF0YSk7CitzdGF0aWMgaW50IHNldF9jb3JlX3RocmVzaG9sZChzdHJ1Y3QgY29yZXRlbXBf
ZGF0YSAqZGF0YSwgaW50IHRlbXAsIGludCB0aHJlcyk7CisKIC8qCiAgKiBTeXNmcyBzdHVmZgog
ICovCkBAIC04Myw5ICs4OSwxNSBAQCBzdGF0aWMgc3NpemVfdCBzaG93X25hbWUoc3RydWN0IGRl
dmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZQogc3RhdGljIHNzaXplX3Qgc2hvd19h
bGFybShzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlCiAJCQkgICpk
ZXZhdHRyLCBjaGFyICpidWYpCiB7Ci0Jc3RydWN0IGNvcmV0ZW1wX2RhdGEgKmRhdGEgPSBjb3Jl
dGVtcF91cGRhdGVfZGV2aWNlKGRldik7Ci0JLyogcmVhZCB0aGUgT3V0LW9mLXNwZWMgbG9nLCBu
ZXZlciBjbGVhciAqLwotCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVkXG4iLCBkYXRhLT5hbGFybSk7
CisJc3RydWN0IHNlbnNvcl9kZXZpY2VfYXR0cmlidXRlICphdHRyID0gdG9fc2Vuc29yX2Rldl9h
dHRyKGRldmF0dHIpOworCXN0cnVjdCBjb3JldGVtcF9kYXRhICpkYXRhID0gZGV2X2dldF9kcnZk
YXRhKGRldik7CisKKwl1cGRhdGVfYWxhcm0oZGF0YSk7CisJaWYgKGF0dHItPmluZGV4ID09IFNI
T1dfQ1JJVF9BTEFSTSkKKwkJLyogcmVhZCB0aGUgT3V0LW9mLXNwZWMgbG9nLCBuZXZlciBjbGVh
ciAqLworCQlyZXR1cm4gc3ByaW50ZihidWYsICIlZFxuIiwgZGF0YS0+Y3JpdF9hbGFybSk7CisK
KwlyZXR1cm4gc3ByaW50ZihidWYsICIlZFxuIiwgZGF0YS0+bWF4X2FsYXJtKTsKIH0KIAogc3Rh
dGljIHNzaXplX3Qgc2hvd190ZW1wKHN0cnVjdCBkZXZpY2UgKmRldiwKQEAgLTkzLDMzICsxMDUs
NjcgQEAgc3RhdGljIHNzaXplX3Qgc2hvd190ZW1wKHN0cnVjdCBkZXZpY2UgKmRldiwKIHsKIAlz
dHJ1Y3Qgc2Vuc29yX2RldmljZV9hdHRyaWJ1dGUgKmF0dHIgPSB0b19zZW5zb3JfZGV2X2F0dHIo
ZGV2YXR0cik7CiAJc3RydWN0IGNvcmV0ZW1wX2RhdGEgKmRhdGEgPSBjb3JldGVtcF91cGRhdGVf
ZGV2aWNlKGRldik7Ci0JaW50IGVycjsKKwlpbnQgZXJyID0gLUVJTlZBTDsKIAotCWlmIChhdHRy
LT5pbmRleCA9PSBTSE9XX1RFTVApCisJc3dpdGNoIChhdHRyLT5pbmRleCkgeworCWNhc2UgU0hP
V19URU1QOgogCQllcnIgPSBkYXRhLT52YWxpZCA/IHNwcmludGYoYnVmLCAiJWRcbiIsIGRhdGEt
PnRlbXApIDogLUVBR0FJTjsKLQllbHNlIGlmIChhdHRyLT5pbmRleCA9PSBTSE9XX1RKTUFYKQor
CQlicmVhazsKKwljYXNlIFNIT1dfVEpNQVg6CiAJCWVyciA9IHNwcmludGYoYnVmLCAiJWRcbiIs
IGRhdGEtPnRqbWF4KTsKLQllbHNlCisJCWJyZWFrOworCWNhc2UgQ09SRV9UVEFSR0VUOgogCQll
cnIgPSBzcHJpbnRmKGJ1ZiwgIiVkXG4iLCBkYXRhLT50dGFyZ2V0KTsKKwkJYnJlYWs7CisJY2Fz
ZSBDT1JFX1RNSU46CisJCWVyciA9IHNwcmludGYoYnVmLCAiJWRcbiIsIGRhdGEtPnRtaW4pOwor
CQlicmVhazsKKwl9CisKIAlyZXR1cm4gZXJyOwogfQogCisKK3N0YXRpYyBzc2l6ZV90IHN0b3Jl
X3RlbXAoc3RydWN0IGRldmljZSAqZGV2LAorCQlzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqZGV2
YXR0ciwgY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpCit7CisJc3RydWN0IHNlbnNvcl9k
ZXZpY2VfYXR0cmlidXRlICphdHRyID0gdG9fc2Vuc29yX2Rldl9hdHRyKGRldmF0dHIpOworCXN0
cnVjdCBjb3JldGVtcF9kYXRhICpkYXRhID0gZGV2X2dldF9kcnZkYXRhKGRldik7CisJdW5zaWdu
ZWQgbG9uZyB2YWw7CisJaW50IGVycjsKKworCWlmIChzdHJpY3Rfc3RydG91bChidWYsIDEwLCAm
dmFsKSkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwllcnIgPSBzZXRfY29yZV90aHJlc2hvbGQoZGF0
YSwgdmFsLCBhdHRyLT5pbmRleCk7CisKKwlyZXR1cm4gZXJyID8gZXJyIDogY291bnQ7Cit9CisK
IHN0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVtcDFfaW5wdXQsIFNfSVJVR08sIHNob3dfdGVt
cCwgTlVMTCwKIAkJCSAgU0hPV19URU1QKTsKIHN0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVt
cDFfY3JpdCwgU19JUlVHTywgc2hvd190ZW1wLCBOVUxMLAogCQkJICBTSE9XX1RKTUFYKTsKLXN0
YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVtcDFfbWF4LCBTX0lSVUdPLCBzaG93X3RlbXAsIE5V
TEwsCi0JCQkgIFNIT1dfVFRBUkdFVCk7Ci1zdGF0aWMgREVWSUNFX0FUVFIodGVtcDFfY3JpdF9h
bGFybSwgU19JUlVHTywgc2hvd19hbGFybSwgTlVMTCk7CitzdGF0aWMgU0VOU09SX0RFVklDRV9B
VFRSKHRlbXAxX21heCwgU19JV1VTUiB8IFNfSVJVR08sIHNob3dfdGVtcCwKKwkJCQkJCXN0b3Jl
X3RlbXAsIENPUkVfVFRBUkdFVCk7CitzdGF0aWMgU0VOU09SX0RFVklDRV9BVFRSKHRlbXAxX21h
eF9oeXN0LCBTX0lXVVNSIHwgU19JUlVHTywgc2hvd190ZW1wLAorCQkJCQkJc3RvcmVfdGVtcCwg
Q09SRV9UTUlOKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVtcDFfY3JpdF9hbGFybSwg
U19JUlVHTywgc2hvd19hbGFybSwgTlVMTCwKKwkJCQkJCQlTSE9XX0NSSVRfQUxBUk0pOworc3Rh
dGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMV9tYXhfYWxhcm0sIFNfSVJVR08sIHNob3dfYWxh
cm0sIE5VTEwsCisJCQkJCQkJU0hPV19NQVhfQUxBUk0pOwogc3RhdGljIFNFTlNPUl9ERVZJQ0Vf
QVRUUih0ZW1wMV9sYWJlbCwgU19JUlVHTywgc2hvd19uYW1lLCBOVUxMLCBTSE9XX0xBQkVMKTsK
IHN0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIobmFtZSwgU19JUlVHTywgc2hvd19uYW1lLCBOVUxM
LCBTSE9XX05BTUUpOwogCiBzdGF0aWMgc3RydWN0IGF0dHJpYnV0ZSAqY29yZXRlbXBfYXR0cmli
dXRlc1tdID0gewogCSZzZW5zb3JfZGV2X2F0dHJfbmFtZS5kZXZfYXR0ci5hdHRyLAogCSZzZW5z
b3JfZGV2X2F0dHJfdGVtcDFfbGFiZWwuZGV2X2F0dHIuYXR0ciwKLQkmZGV2X2F0dHJfdGVtcDFf
Y3JpdF9hbGFybS5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfdGVtcDFfY3JpdF9hbGFybS5kZXZf
YXR0ci5hdHRyLAogCSZzZW5zb3JfZGV2X2F0dHJfdGVtcDFfaW5wdXQuZGV2X2F0dHIuYXR0ciwK
IAkmc2Vuc29yX2Rldl9hdHRyX3RlbXAxX2NyaXQuZGV2X2F0dHIuYXR0ciwKKwkmc2Vuc29yX2Rl
dl9hdHRyX3RlbXAxX21heC5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfdGVtcDFf
bWF4X2h5c3QuZGV2X2F0dHIuYXR0ciwKKwkmc2Vuc29yX2Rldl9hdHRyX3RlbXAxX21heF9hbGFy
bS5kZXZfYXR0ci5hdHRyLAogCU5VTEwKIH07CiAKQEAgLTEyNyw2ICsxNzMsMjYgQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgY29yZXRlbXBfZ3JvdXAgPSB7CiAJLmF0dHJz
ID0gY29yZXRlbXBfYXR0cmlidXRlcywKIH07CiAKK3N0YXRpYyB2b2lkIHVwZGF0ZV9hbGFybShz
dHJ1Y3QgY29yZXRlbXBfZGF0YSAqZGF0YSkKK3sKKwl1MzIgZWF4LCBlZHg7CisKKwlyZG1zcl9v
bl9jcHUoZGF0YS0+aWQsIE1TUl9JQTMyX1RIRVJNX1NUQVRVUywgJmVheCwgJmVkeCk7CisKKwkv
KiBVcGRhdGUgdGhlIGNyaXRpY2FsIHRlbXBlcmF0dXJlIGFsYXJtICovCisJZGF0YS0+Y3JpdF9h
bGFybSA9IChlYXggPj4gNSkgJiAxOworCisJLyogVGVtcGVyYXR1cmUgcmVhY2hlZCB0aHJlc2hv
bGQxICovCisJaWYgKGVheCAmIFRIRVJNX0xPR19USFJFU0hPTEQxKQorCQlkYXRhLT5tYXhfYWxh
cm0gPSAxOworCS8qIFRlbXBlcmF0dXJlIHJlYWNoZWQgdGhyZXNob2xkMCAqLworCWVsc2UgaWYg
KGVheCAmIFRIRVJNX0xPR19USFJFU0hPTEQwKQorCQlkYXRhLT5tYXhfYWxhcm0gPSAwOworCS8q
IElmIG5vbmUgb2YgdGhlc2UgY2FzZXMsIGRvbid0IHVwZGF0ZSBtYXhfYWxhcm0gKi8KKworCXJl
dHVybjsKK30KKwogc3RhdGljIHN0cnVjdCBjb3JldGVtcF9kYXRhICpjb3JldGVtcF91cGRhdGVf
ZGV2aWNlKHN0cnVjdCBkZXZpY2UgKmRldikKIHsKIAlzdHJ1Y3QgY29yZXRlbXBfZGF0YSAqZGF0
YSA9IGRldl9nZXRfZHJ2ZGF0YShkZXYpOwpAQCAtMTM4LDcgKzIwNCw2IEBAIHN0YXRpYyBzdHJ1
Y3QgY29yZXRlbXBfZGF0YSAqY29yZXRlbXBfdXBkYXRlX2RldmljZShzdHJ1Y3QgZGV2aWNlICpk
ZXYpCiAKIAkJZGF0YS0+dmFsaWQgPSAwOwogCQlyZG1zcl9vbl9jcHUoZGF0YS0+aWQsIE1TUl9J
QTMyX1RIRVJNX1NUQVRVUywgJmVheCwgJmVkeCk7Ci0JCWRhdGEtPmFsYXJtID0gKGVheCA+PiA1
KSAmIDE7CiAJCS8qIHVwZGF0ZSBvbmx5IGlmIGRhdGEgaGFzIGJlZW4gdmFsaWQgKi8KIAkJaWYg
KGVheCAmIDB4ODAwMDAwMDApIHsKIAkJCWRhdGEtPnRlbXAgPSBkYXRhLT50am1heCAtICgoKGVh
eCA+PiAxNikKQEAgLTI5OCw2ICszNjMsMTA2IEBAIHN0YXRpYyB2b2lkIF9fZGV2aW5pdCBnZXRf
dWNvZGVfcmV2X29uX2NwdSh2b2lkICplZHgpCiAJcmRtc3IoTVNSX0lBMzJfVUNPREVfUkVWLCBl
YXgsICoodTMyICopZWR4KTsKIH0KIAorLyogUGxhdGZvcm0gdGhlcm1hbCBJbnRlcnJ1cHQgSGFu
ZGxlciAqLworc3RhdGljIGludCBjb3JldGVtcF9pbnRlcnJ1cHQoX191NjQgbXNyX3ZhbCkKK3sK
KworCWlmIChtc3JfdmFsICYgVEhFUk1fTE9HX1RIUkVTSE9MRDApIHsKKwkJaWYgKCEobXNyX3Zh
bCAmIFRIRVJNX1NUQVRVU19USFJFU0hPTEQwKSkKKwkJCXByX2luZm8oIiVzOkxvd2VyIFRocmVz
aG9sZCBSZWFjaGVkXG4iLCBfX2Z1bmNfXyk7CisJCS8qIFJlc2V0IHRoZSBUaHJlc2hvbGQwIGlu
dGVycnVwdCAqLworCQl3cm1zcmwoTVNSX0lBMzJfVEhFUk1fU1RBVFVTLCBtc3JfdmFsICYgflRI
RVJNX0xPR19USFJFU0hPTEQwKTsKKwl9CisKKwlpZiAobXNyX3ZhbCAmIFRIRVJNX0xPR19USFJF
U0hPTEQxKSB7CisJCWlmIChtc3JfdmFsICYgVEhFUk1fU1RBVFVTX1RIUkVTSE9MRDEpCisJCQlw
cl9pbmZvKCIlczpVcHBlciBUaHJlc2hvbGQgUmVhY2hlZFxuIiwgX19mdW5jX18pOworCQkvKiBS
ZXNldCB0aGUgVGhyZXNob2xkMSBpbnRlcnJ1cHQgKi8KKwkJd3Jtc3JsKE1TUl9JQTMyX1RIRVJN
X1NUQVRVUywgbXNyX3ZhbCAmIH5USEVSTV9MT0dfVEhSRVNIT0xEMSk7CisJfQorCisJcmV0dXJu
IDA7Cit9CisKK3N0YXRpYyB2b2lkIGNvbmZpZ3VyZV9hcGljKHZvaWQgKmluZm8pCit7CisJdTMy
IGw7CisJaW50ICpmbGFnID0gKGludCAqKWluZm87CisKKwlsID0gYXBpY19yZWFkKEFQSUNfTFZU
VEhNUik7CisKKwlpZiAoKmZsYWcpCS8qIE5vbi1aZXJvIGZsYWcgTWFza3MgdGhlIEFQSUMgKi8K
KwkJYXBpY193cml0ZShBUElDX0xWVFRITVIsIGwgfCBBUElDX0xWVF9NQVNLRUQpOworCWVsc2UJ
CS8qIFplcm8gZmxhZyBVbk1hc2tzIHRoZSBBUElDICovCisJCWFwaWNfd3JpdGUoQVBJQ19MVlRU
SE1SLCBsICYgfkFQSUNfTFZUX01BU0tFRCk7Cit9CisKK3N0YXRpYyBpbnQgc2V0X2NvcmVfdGhy
ZXNob2xkKHN0cnVjdCBjb3JldGVtcF9kYXRhICpkYXRhLCBpbnQgdGVtcCwgaW50IHRocmVzKQor
eworCXUzMiBlYXgsIGVkeDsKKwlpbnQgZGlmZjsKKwlpbnQgZmxhZyA9IDE7CisKKwlpZiAodGVt
cCA+IGRhdGEtPnRqbWF4KQorCQlyZXR1cm4gLUVJTlZBTDsKKworCW11dGV4X2xvY2soJmRhdGEt
PnVwZGF0ZV9sb2NrKTsKKworCWRpZmYgPSAoZGF0YS0+dGptYXggLSB0ZW1wKS8xMDAwOworCisJ
LyogTWFzayB0aGUgQVBJQyAqLworCXNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZShkYXRhLT5pZCwg
JmNvbmZpZ3VyZV9hcGljLCAmZmxhZywgMSk7CisKKwlyZG1zcl9vbl9jcHUoZGF0YS0+aWQsIE1T
Ul9JQTMyX1RIRVJNX0lOVEVSUlVQVCwgJmVheCwgJmVkeCk7CisKKwlpZiAodGhyZXMgPT0gQ09S
RV9UTUlOKSB7CisJCWVheCA9IChlYXggJiB+VEhFUk1fTUFTS19USFJFU0hPTEQwKSB8CisJCQkJ
CShkaWZmIDw8IFRIRVJNX1NISUZUX1RIUkVTSE9MRDApOworCQlkYXRhLT50bWluID0gdGVtcDsK
Kwl9IGVsc2UgeworCQllYXggPSAoZWF4ICYgflRIRVJNX01BU0tfVEhSRVNIT0xEMSkgfAorCQkJ
CQkoZGlmZiA8PCBUSEVSTV9TSElGVF9USFJFU0hPTEQxKTsKKwkJZGF0YS0+dHRhcmdldCA9IHRl
bXA7CisJfQorCisJd3Jtc3Jfb25fY3B1KGRhdGEtPmlkLCBNU1JfSUEzMl9USEVSTV9JTlRFUlJV
UFQsIGVheCwgZWR4KTsKKworCS8qIFVubWFzayB0aGUgQVBJQyAqLworCWZsYWcgPSAwOworCXNt
cF9jYWxsX2Z1bmN0aW9uX3NpbmdsZShkYXRhLT5pZCwgJmNvbmZpZ3VyZV9hcGljLCAmZmxhZywg
MSk7CisKKwltdXRleF91bmxvY2soJmRhdGEtPnVwZGF0ZV9sb2NrKTsKKwlyZXR1cm4gMDsKK30K
Kworc3RhdGljIGludCBfX2RldmluaXQgY29uZmlnX3RocmVzaF9pbnRycHQoc3RydWN0IGNvcmV0
ZW1wX2RhdGEgKmRhdGEsCisJCQkJCQkJCWludCBlbmFibGUpCit7CisJdTMyIGVheCwgZWR4Owor
CWludCBmbGFnID0gMTsgLyogTm9uLVplcm8gRmxhZyBtYXNrcyB0aGUgYXBpYyAqLworCisJc21w
X2NhbGxfZnVuY3Rpb25fc2luZ2xlKGRhdGEtPmlkLCAmY29uZmlndXJlX2FwaWMsICZmbGFnLCAx
KTsKKworCXJkbXNyX29uX2NwdShkYXRhLT5pZCwgTVNSX0lBMzJfVEhFUk1fSU5URVJSVVBULCAm
ZWF4LCAmZWR4KTsKKworCWlmIChlbmFibGUpIHsKKwkJZWF4IHw9IChUSEVSTV9JTlRfVEhSRVNI
T0xEMF9FTkFCTEUgfAorCQkJCQkJVEhFUk1fSU5UX1RIUkVTSE9MRDFfRU5BQkxFKTsKKwkJcGxh
dGZvcm1fdGhlcm1hbF9ub3RpZnkgPSBjb3JldGVtcF9pbnRlcnJ1cHQ7CisJfSBlbHNlIHsKKwkJ
ZWF4ICY9ICh+KFRIRVJNX0lOVF9USFJFU0hPTEQwX0VOQUJMRSB8CisJCQkJCQlUSEVSTV9JTlRf
VEhSRVNIT0xEMV9FTkFCTEUpKTsKKwkJcGxhdGZvcm1fdGhlcm1hbF9ub3RpZnkgPSBOVUxMOwor
CX0KKworCXdybXNyX29uX2NwdShkYXRhLT5pZCwgTVNSX0lBMzJfVEhFUk1fSU5URVJSVVBULCBl
YXgsIGVkeCk7CisKKwlmbGFnID0gMDsgLypGbGFnIHNob3VsZCBiZSB6ZXJvIHRvIHVubWFzayB0
aGUgYXBpYyAqLworCXNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZShkYXRhLT5pZCwgJmNvbmZpZ3Vy
ZV9hcGljLCAmZmxhZywgMSk7CisKKwlyZXR1cm4gMDsKK30KKwogc3RhdGljIGludCBfX2Rldmlu
aXQgY29yZXRlbXBfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIHsKIAlzdHJ1
Y3QgY29yZXRlbXBfZGF0YSAqZGF0YTsKQEAgLTM1MSw2ICs1MTYsMTAgQEAgc3RhdGljIGludCBf
X2RldmluaXQgY29yZXRlbXBfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAl9
CiAKIAlkYXRhLT50am1heCA9IGdldF90am1heChjLCBkYXRhLT5pZCwgJnBkZXYtPmRldik7CisJ
LyogSW5pdGlhbGl6ZSB0dGFyZ2V0IHZhbHVlLiBJZiBJQTMyX1RFTVBFUkFUVVJFX1RBUkdFVCBp
cworCSAqIHN1cHBvcnRlZCwgdGhpcyB2YWx1ZSB3aWxsIGJlIG92ZXIgd3JpdHRlbiBiZWxvdwor
CSAqLworCWRhdGEtPnR0YXJnZXQgPSBkYXRhLT50am1heCAtIDIwMDAwOwogCXBsYXRmb3JtX3Nl
dF9kcnZkYXRhKHBkZXYsIGRhdGEpOwogCiAJLyoKQEAgLTM2OCwxMyArNTM3LDE4IEBAIHN0YXRp
YyBpbnQgX19kZXZpbml0IGNvcmV0ZW1wX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBk
ZXYpCiAJCX0gZWxzZSB7CiAJCQlkYXRhLT50dGFyZ2V0ID0gZGF0YS0+dGptYXggLQogCQkJCQko
KChlYXggPj4gOCkgJiAweGZmKSAqIDEwMDApOwotCQkJZXJyID0gZGV2aWNlX2NyZWF0ZV9maWxl
KCZwZGV2LT5kZXYsCi0JCQkJCSZzZW5zb3JfZGV2X2F0dHJfdGVtcDFfbWF4LmRldl9hdHRyKTsK
LQkJCWlmIChlcnIpCi0JCQkJZ290byBleGl0X2ZyZWU7CiAJCX0KIAl9CiAKKwkvKiBFbmFibGUg
dGhyZXNob2xkIGludGVycnVwdCBzdXBwb3J0ICovCisJY29uZmlnX3RocmVzaF9pbnRycHQoZGF0
YSwgMSk7CisKKwkvKiBTZXQgSW5pdGlhbCBDb3JlIHRocmVzaG9sZHMuCisJICogVGhlIGxvd2Vy
IGFuZCB1cHBlciB0aHJlc2hvbGQgdmFsdWVzIGhlcmUgYXJlIGFzc3VtZWQKKwkgKi8KKwlzZXRf
Y29yZV90aHJlc2hvbGQoZGF0YSwgMCwgQ09SRV9UTUlOKTsKKwlzZXRfY29yZV90aHJlc2hvbGQo
ZGF0YSwgZGF0YS0+dHRhcmdldCwgQ09SRV9UVEFSR0VUKTsKKwogCWlmICgoZXJyID0gc3lzZnNf
Y3JlYXRlX2dyb3VwKCZwZGV2LT5kZXYua29iaiwgJmNvcmV0ZW1wX2dyb3VwKSkpCiAJCWdvdG8g
ZXhpdF9kZXY7CiAKQEAgLTQwNCw3ICs1NzgsNyBAQCBzdGF0aWMgaW50IF9fZGV2ZXhpdCBjb3Jl
dGVtcF9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAogCWh3bW9uX2Rldmlj
ZV91bnJlZ2lzdGVyKGRhdGEtPmh3bW9uX2Rldik7CiAJc3lzZnNfcmVtb3ZlX2dyb3VwKCZwZGV2
LT5kZXYua29iaiwgJmNvcmV0ZW1wX2dyb3VwKTsKLQlkZXZpY2VfcmVtb3ZlX2ZpbGUoJnBkZXYt
PmRldiwgJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9tYXguZGV2X2F0dHIpOworCWNvbmZpZ190aHJl
c2hfaW50cnB0KGRhdGEsIDApOwogCXBsYXRmb3JtX3NldF9kcnZkYXRhKHBkZXYsIE5VTEwpOwog
CWtmcmVlKGRhdGEpOwogCXJldHVybiAwOwotLSAKMS42LjUuMgoK

--_003_D6D887BA8C9DFF48B5233887EF04654105C1251712bgsmsx502garc_
Content-Type: text/plain; name="ATT00001..txt"
Content-Description: ATT00001..txt
Content-Disposition: attachment; filename="ATT00001..txt"; size=156;
	creation-date="Mon, 20 Dec 2010 11:42:39 GMT";
	modification-date="Mon, 20 Dec 2010 11:42:39 GMT"
Content-Transfer-Encoding: base64

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCmxtLXNlbnNv
cnMgbWFpbGluZyBsaXN0DQpsbS1zZW5zb3JzQGxtLXNlbnNvcnMub3JnDQpodHRwOi8vbGlzdHMu
bG0tc2Vuc29ycy5vcmcvbWFpbG1hbi9saXN0aW5mby9sbS1zZW5zb3Jz

--_003_D6D887BA8C9DFF48B5233887EF04654105C1251712bgsmsx502garc_--
