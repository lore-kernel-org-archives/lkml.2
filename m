Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1CDR4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:56:52 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37321 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab1CDR4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:56:49 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 10/11] hwmon: (w83627ehf) Store rpm instead of raw fan speed data
Date: Fri, 4 Mar 2011 09:58:05 -0800
Message-ID: <1299261486-15190-11-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the fan speed value can be above 0xff, we can no longer use
that value to determine if the fan speed reading is valid. This
makes it difficult to manipulate the stored fan speed register value.

If we store rpm instead of the fan speed register value, we do not
need to correct it if the fan divisor value is changed, and the above
mentioned problem no longer exists.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/w83627ehf.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index df6e502..460292b 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -452,7 +452,7 @@ struct w83627ehf_data {
 	u8 in[10];		/* Register value */
 	u8 in_max[10];		/* Register value */
 	u8 in_min[10];		/* Register value */
-	u16 fan[5];
+	unsigned int rpm[5];
 	u16 fan_min[5];
 	u8 fan_div[5];
 	u8 has_fan;		/* some fan inputs can be disabled */
@@ -775,11 +775,14 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 
 		/* Measured fan speeds and limits */
 		for (i = 0; i < 5; i++) {
+			u16 reg;
+
 			if (!(data->has_fan & (1 << i)))
 				continue;
 
-			data->fan[i] = w83627ehf_read_value(data,
-							    data->REG_FAN[i]);
+			reg = w83627ehf_read_value(data, data->REG_FAN[i]);
+			data->rpm[i] = data->fan_from_reg(reg,
+							  data->fan_div[i]);
 
 			if (data->has_fan_min & (1 << i))
 				data->fan_min[i] = w83627ehf_read_value(data,
@@ -789,9 +792,8 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 			   divider can be increased, let's try that for next
 			   time */
 			if (data->has_fan_div
-			    && (data->fan[i] >= 0xff
-				|| (sio_data->kind == nct6775
-				    && data->fan[i] == 0x00))
+			    && (reg >= 0xff || (sio_data->kind == nct6775
+						&& reg == 0x00))
 			    && data->fan_div[i] < 0x07) {
 				dev_dbg(dev, "Increasing fan%d "
 					"clock divider from %u to %u\n",
@@ -984,8 +986,7 @@ show_fan(struct device *dev, struct device_attribute *attr, char *buf)
 	struct w83627ehf_data *data = w83627ehf_update_device(dev);
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
-	return sprintf(buf, "%d\n",
-		       data->fan_from_reg(data->fan[nr], data->fan_div[nr]));
+	return sprintf(buf, "%d\n", data->rpm[nr]);
 }
 
 static ssize_t
@@ -1078,16 +1079,6 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 	/* Write both the fan clock divider (if it changed) and the new
 	   fan min (unconditionally) */
 	if (new_div != data->fan_div[nr]) {
-		/* Preserve the fan speed reading */
-		if (data->fan[nr] != 0xff) {
-			if (new_div > data->fan_div[nr])
-				data->fan[nr] >>= new_div - data->fan_div[nr];
-			else if (data->fan[nr] & 0x80)
-				data->fan[nr] = 0xff;
-			else
-				data->fan[nr] <<= data->fan_div[nr] - new_div;
-		}
-
 		dev_dbg(dev, "fan%u clock divider changed from %u to %u\n",
 			nr + 1, div_from_reg(data->fan_div[nr]),
 			div_from_reg(new_div));
-- 
1.7.3.1

