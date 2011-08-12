Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1HLUlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 16:41:18 -0400
Received: from smtp16.mail.ru ([94.100.176.153]:51518 "EHLO smtp16.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab1HLUlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 16:41:17 -0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: lm-sensors@lm-sensors.org
Cc: Ian Dobson <i.dobson@planet-ian.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] hwmon: add caseopen detection to w83627ehf driver
Date: Sat, 13 Aug 2011 00:41:11 +0400
Message-Id: <1313181671-5164-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.4.rc3
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export caseopen alarm status into userspace for Winbond W83627*
and Nuvoton NCT677[56] chips and implement alarm clear knob.
Second caseopen alarm on NCT6776 is also supported.

Thanks to Guenter Roeck for information about Nuvoton chips
and suggestion to use SENSOR_ATTR_2.

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 drivers/hwmon/w83627ehf.c |   62 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

Changes v2 -> v3:
* SENSOR_ATTR_2 is used instead of SENSOR_ATTR. As result code became
  more slim and neat.
* Type of reg variable in caseopen_clear() function changed from
  unsigned int to u16 to match return value of w83627ehf_read_value()

Changes v1 -> v2:
* support for Nuvoton NCT677[56] is added (including second caseopen on NCT6776)
* now data->caseopen contains raw register value, extraction of needed bits
  is done in show_caseopen()
  * store_caseopen_clear() is renamed to clear_caseopen()

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index f2b377c..eca61b3 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -197,6 +197,9 @@ static const u16 W83627EHF_REG_TEMP_CONFIG[] = { 0, 0x152, 0x252, 0 };
 #define W83627EHF_REG_ALARM2		0x45A
 #define W83627EHF_REG_ALARM3		0x45B
 
+#define W83627EHF_REG_CASEOPEN_DET	0x42 /* SMI STATUS #2 */
+#define W83627EHF_REG_CASEOPEN_CLR	0x46 /* SMI MASK #3 */
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
 
+		data->caseopen = w83627ehf_read_value(data,
+						W83627EHF_REG_CASEOPEN_DET);
+
 		data->last_updated = jiffies;
 		data->valid = 1;
 	}
@@ -1654,6 +1661,48 @@ show_vid(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(cpu0_vid, S_IRUGO, show_vid, NULL);
 
+
+/* Case open detection */
+
+static ssize_t
+show_caseopen(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct w83627ehf_data *data = w83627ehf_update_device(dev);
+
+	return sprintf(buf, "%d\n",
+		!!(data->caseopen & to_sensor_dev_attr_2(attr)->index));
+}
+
+static ssize_t
+clear_caseopen(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct w83627ehf_data *data = dev_get_drvdata(dev);
+	unsigned long val;
+	u16 reg, mask;
+
+	if (strict_strtoul(buf, 10, &val) || val != 0)
+		return -EINVAL;
+
+	mask = to_sensor_dev_attr_2(attr)->nr;
+
+	mutex_lock(&data->update_lock);
+	reg = w83627ehf_read_value(data, W83627EHF_REG_CASEOPEN_CLR);
+	w83627ehf_write_value(data, W83627EHF_REG_CASEOPEN_CLR, reg | mask);
+	w83627ehf_write_value(data, W83627EHF_REG_CASEOPEN_CLR, reg & ~mask);
+	data->valid = 0;	/* Force cache refresh */
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
+static struct sensor_device_attribute_2 sda_caseopen[] = {
+	SENSOR_ATTR_2(intrusion0_alarm, S_IWUSR | S_IRUGO, show_caseopen,
+			clear_caseopen, 0x80, 0x10),
+	SENSOR_ATTR_2(intrusion1_alarm, S_IWUSR | S_IRUGO, show_caseopen,
+			clear_caseopen, 0x40, 0x40),
+};
+
 /*
  * Driver and device management
  */
@@ -1710,6 +1759,9 @@ static void w83627ehf_device_remove_files(struct device *dev)
 		device_remove_file(dev, &sda_temp_type[i].dev_attr);
 	}
 
+	device_remove_file(dev, &sda_caseopen[0].dev_attr);
+	device_remove_file(dev, &sda_caseopen[1].dev_attr);
+
 	device_remove_file(dev, &dev_attr_name);
 	device_remove_file(dev, &dev_attr_cpu0_vid);
 }
@@ -2261,6 +2313,16 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 			goto exit_remove;
 	}
 
+	err = device_create_file(dev, &sda_caseopen[0].dev_attr);
+	if (err)
+		goto exit_remove;
+
+	if (sio_data->kind == nct6776) {
+		err = device_create_file(dev, &sda_caseopen[1].dev_attr);
+		if (err)
+			goto exit_remove;
+	}
+
 	err = device_create_file(dev, &dev_attr_name);
 	if (err)
 		goto exit_remove;
-- 
1.7.4.rc3

