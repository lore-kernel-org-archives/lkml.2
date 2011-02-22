Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1BVW1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:27:24 -0500
Received: from kroah.org ([198.145.64.141]:32938 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab1BVWWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:42 2011
Message-Id: <20110222221842.122859233@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [51/70] hwmon: (jc42) do not allow writing to locked registers
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 2c6315da6a1657a49e03970a4084dc3d1958ad70 upstream.

On systems where the temperature sensor is actually used, the BIOS is
likely to have locked the alarm registers.  In that case, all writes
through the corresponding sysfs files would be silently ignored.

To prevent this, detect the locks and make the affected sysfs files
read-only.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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


