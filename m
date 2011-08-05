Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab1HENGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:06:22 -0400
Received: from fallback5.mail.ru ([94.100.176.59]:43405 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab1HENGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:06:18 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Aug 2011 09:06:18 EDT
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: lm-sensors@lm-sensors.org
Cc: Ian Dobson <i.dobson@planet-ian.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: add caseopen detection to w83627ehf driver
Date: Fri,  5 Aug 2011 17:00:43 +0400
Message-Id: <1312549243-7503-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.4.rc3
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export caseopen alarm status into userspace for
Winbond w83627* chips and also implement alarm clear knob.

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 drivers/hwmon/w83627ehf.c |   66 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)

Tested on board with W83627DHG-P chip and also checked against datasheets
for other W83627 chips. NCT6775F / NCT6776F are currently excluded as I
haven't found datasheets for them online and can't check if they have the
same registers for caseopen detection. If anyone having access to these
datasheets can check that caseopen detection is read from 4th bit of
register 42h (Bank 0), and cleared by writing 1 and then 0 into bit 7 of
register 46h (Bank 0), then I'll throw away those 'if'-s and resend updated
patch.

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index f2b377c..696e5d6 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -197,6 +197,9 @@ static const u16 W83627EHF_REG_TEMP_CONFIG[] = { 0, 0x152, 0x252, 0 };
 #define W83627EHF_REG_ALARM2		0x45A
 #define W83627EHF_REG_ALARM3		0x45B
 
+#define W83627EHF_REG_CASEOPEN_DET	0x42 /* SMI STATUS #2, bit 4 */
+#define W83627EHF_REG_CASEOPEN_CLR	0x46 /* SMI MASK #3, bit 7 */
+
 /* SmartFan registers */
 #define W83627EHF_REG_FAN_STEPUP_TIME 0x0f
 #define W83627EHF_REG_FAN_STEPDOWN_TIME 0x0e
@@ -468,6 +471,7 @@ struct w83627ehf_data {
 	s16 temp_max[9];
 	s16 temp_max_hyst[9];
 	u32 alarms;
+	u8 caseopen;
 
 	u8 pwm_mode[4]; /* 0->DC variable voltage, 1->PWM variable duty cycle */
 	u8 pwm_enable[4]; /* 1->manual
@@ -873,6 +877,9 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 			       (w83627ehf_read_value(data,
 					W83627EHF_REG_ALARM3) << 16);
 
+		data->caseopen = !!(w83627ehf_read_value(data,
+					W83627EHF_REG_CASEOPEN_DET) & 0x10);
+
 		data->last_updated = jiffies;
 		data->valid = 1;
 	}
@@ -1654,6 +1661,47 @@ show_vid(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(cpu0_vid, S_IRUGO, show_vid, NULL);
 
+
+/* Case open detection */
+
+static ssize_t
+show_caseopen(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct w83627ehf_data *data = w83627ehf_update_device(dev);
+	unsigned int reg;
+	mutex_lock(&data->update_lock);
+	reg = w83627ehf_read_value(data, 0x42);
+	mutex_unlock(&data->update_lock);
+	return sprintf(buf, "%d\n", data->caseopen);
+}
+
+static ssize_t
+store_caseopen_clear(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct w83627ehf_data *data = dev_get_drvdata(dev);
+	unsigned long val;
+	unsigned int reg;
+
+	if (strict_strtoul(buf, 10, &val) || val != 0)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+	reg = w83627ehf_read_value(data, W83627EHF_REG_CASEOPEN_CLR);
+	w83627ehf_write_value(data, W83627EHF_REG_CASEOPEN_CLR, reg | 0x80);
+	reg = w83627ehf_read_value(data, W83627EHF_REG_CASEOPEN_CLR);
+	w83627ehf_write_value(data, W83627EHF_REG_CASEOPEN_CLR, reg & ~0x80);
+	reg = w83627ehf_read_value(data, W83627EHF_REG_CASEOPEN_CLR);
+	data->valid = 0;	/* Force cache refresh */
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
+static struct sensor_device_attribute sda_caseopen =
+	SENSOR_ATTR(intrusion0_alarm, S_IWUSR | S_IRUGO, show_caseopen,
+			store_caseopen_clear , 12);
+
 /*
  * Driver and device management
  */
@@ -1663,6 +1711,7 @@ static void w83627ehf_device_remove_files(struct device *dev)
 	/* some entries in the following arrays may not have been used in
 	 * device_create_file(), but device_remove_file() will ignore them */
 	int i;
+	struct w83627ehf_sio_data *sio_data = dev->platform_data;
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
 
 	for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays); i++)
@@ -1710,6 +1759,13 @@ static void w83627ehf_device_remove_files(struct device *dev)
 		device_remove_file(dev, &sda_temp_type[i].dev_attr);
 	}
 
+	/*
+	 * FIXME: if NCT chips have same caseopen registers as w83627 ones
+	 * this check can be removed
+	 */
+	if (!(sio_data->kind == nct6775 || sio_data->kind == nct6776))
+		device_remove_file(dev, &sda_caseopen.dev_attr);
+
 	device_remove_file(dev, &dev_attr_name);
 	device_remove_file(dev, &dev_attr_cpu0_vid);
 }
@@ -2261,6 +2317,16 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 			goto exit_remove;
 	}
 
+	/*
+	 * FIXME: if NCT chips have same caseopen registers as w83627 ones
+	 * this check can be removed
+	 */
+	if (!(sio_data->kind == nct6775 || sio_data->kind == nct6776)) {
+		err = device_create_file(dev, &sda_caseopen.dev_attr);
+		if (err)
+			goto exit_remove;
+	}
+
 	err = device_create_file(dev, &dev_attr_name);
 	if (err)
 		goto exit_remove;
-- 
1.7.5.1.300.gc565c

