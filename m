Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1BPNBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:01:54 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38367 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab1BPNBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:01:50 -0500
X-Sasl-enc: Ec1Tx1aoUKufWhq/pTIrtdn1w/8DP28dA4doLQHGDGEv 1297861310
Message-ID: <4D5BCAEE.6030502@ladisch.de>
Date: Wed, 16 Feb 2011 14:02:38 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] hwmon: (jc42) do not allow writing to locked registers
References: <4D5BCA87.7010204@ladisch.de>
In-Reply-To: <4D5BCA87.7010204@ladisch.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems where the temperature sensor is actually used, the BIOS is
likely to have locked the alarm registers.  In that case, all writes
through the corresponding sysfs files would be silently ignored.

To prevent this, detect the locks and make the affected sysfs files
read-only.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 Documentation/hwmon/jc42 |   12 ++++++++----
 drivers/hwmon/jc42.c     |   33 +++++++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 8 deletions(-)

--- a/Documentation/hwmon/jc42
+++ b/Documentation/hwmon/jc42
@@ -86,15 +86,19 @@ limits. The chip supports only a single
 which applies to all limits. This register can be written by writing into
 temp1_crit_hyst. Other hysteresis attributes are read-only.
 
+If the BIOS has configured the sensor for automatic temperature management, it
+is likely that it has locked the registers, i.e., that the temperature limits
+cannot be changed.
+
 Sysfs entries
 -------------
 
 temp1_input		Temperature (RO)
-temp1_min		Minimum temperature (RW)
-temp1_max		Maximum temperature (RW)
-temp1_crit		Critical high temperature (RW)
+temp1_min		Minimum temperature (RO or RW)
+temp1_max		Maximum temperature (RO or RW)
+temp1_crit		Critical high temperature (RO or RW)
 
-temp1_crit_hyst		Critical hysteresis temperature (RW)
+temp1_crit_hyst		Critical hysteresis temperature (RO or RW)
 temp1_max_hyst		Maximum hysteresis temperature (RO)
 
 temp1_min_alarm		Temperature low alarm
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -53,6 +53,8 @@ static const unsigned short normal_i2c[]
 
 /* Configuration register defines */
 #define JC42_CFG_CRIT_ONLY	(1 << 2)
+#define JC42_CFG_TCRIT_LOCK	(1 << 6)
+#define JC42_CFG_EVENT_LOCK	(1 << 7)
 #define JC42_CFG_SHUTDOWN	(1 << 8)
 #define JC42_CFG_HYST_SHIFT	9
 #define JC42_CFG_HYST_MASK	0x03
@@ -380,14 +382,14 @@ static ssize_t show_alarm(struct device
 
 static DEVICE_ATTR(temp1_input, S_IRUGO,
 		   show_temp_input, NULL);
-static DEVICE_ATTR(temp1_crit, S_IWUSR | S_IRUGO,
+static DEVICE_ATTR(temp1_crit, S_IRUGO,
 		   show_temp_crit, set_temp_crit);
-static DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO,
+static DEVICE_ATTR(temp1_min, S_IRUGO,
 		   show_temp_min, set_temp_min);
-static DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO,
+static DEVICE_ATTR(temp1_max, S_IRUGO,
 		   show_temp_max, set_temp_max);
 
-static DEVICE_ATTR(temp1_crit_hyst, S_IWUSR | S_IRUGO,
+static DEVICE_ATTR(temp1_crit_hyst, S_IRUGO,
 		   show_temp_crit_hyst, set_temp_crit_hyst);
 static DEVICE_ATTR(temp1_max_hyst, S_IRUGO,
 		   show_temp_max_hyst, NULL);
@@ -412,8 +414,31 @@ static struct attribute *jc42_attributes
 	NULL
 };
 
+static mode_t jc42_attribute_mode(struct kobject *kobj,
+				  struct attribute *attr, int index)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct i2c_client *client = to_i2c_client(dev);
+	struct jc42_data *data = i2c_get_clientdata(client);
+	unsigned int config = data->config;
+	bool readonly;
+
+	if (attr == &dev_attr_temp1_crit.attr)
+		readonly = config & JC42_CFG_TCRIT_LOCK;
+	else if (attr == &dev_attr_temp1_min.attr ||
+		 attr == &dev_attr_temp1_max.attr)
+		readonly = config & JC42_CFG_EVENT_LOCK;
+	else if (attr == &dev_attr_temp1_crit_hyst.attr)
+		readonly = config & (JC42_CFG_EVENT_LOCK | JC42_CFG_TCRIT_LOCK);
+	else
+		readonly = true;
+
+	return S_IRUGO | (readonly ? 0 : S_IWUSR);
+}
+
 static const struct attribute_group jc42_group = {
 	.attrs = jc42_attributes,
+	.is_visible = jc42_attribute_mode,
 };
 
 /* Return 0 if detection is successful, -ENODEV otherwise */
