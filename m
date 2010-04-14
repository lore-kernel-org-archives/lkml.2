Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0DNQvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:51:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35019 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756478Ab0DNQvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:51:52 -0400
Date: Wed, 14 Apr 2010 17:56:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: isl29020: ALS driver as misc device
Message-ID: <20100414175602.44580f3c@lxorguk.ukuu.org.uk>
In-Reply-To: <4BC5D681.20707@jic23.retrosnub.co.uk>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414125136.23181.16788.stgit@localhost.localdomain>
	<4BC5C7A8.1040807@cam.ac.uk>
	<20100414153234.22765666@lxorguk.ukuu.org.uk>
	<4BC5D681.20707@jic23.retrosnub.co.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And this adds the isl29020 as a misc device per discussions

isl29020: ambient light sensor

From: Kalhan Trisal <kalhan.trisal@intel.com>

The LS driver will read the latest Lux measurement based upon the
light brightness and will report the LUX output through sysfs interface.

This hardware isn't quite the same as the ISL29003 so has a different driver.

Signed-off-by: Kalhan Trisal <kalhan.trisal@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/misc/Kconfig    |   10 ++
 drivers/misc/Makefile   |    1 
 drivers/misc/isl29020.c |  210 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 221 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/isl29020.c


diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index e626bac..b3af3f4 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -268,6 +268,16 @@ config ISL29003
 	  This driver can also be built as a module.  If so, the module
 	  will be called isl29003.
 
+config ISL29020
+	tristate "Intersil ISL29020 ambient light sensor"
+	depends on I2C
+	help
+	  If you say yes here you get support for the Intersil ISL29020
+	  ambient light sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called isl29020.
+
 config SENSORS_TSL2550
 	tristate "Taos TSL2550 ambient light sensor"
 	depends on I2C && SYSFS
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 620cf0b..75c8b0e 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_CS5535_MFGPT)	+= cs5535-mfgpt.o
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
+obj-$(CONFIG_ISL29020)		+= isl29020.o
 obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
 obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
 obj-$(CONFIG_DS1682)		+= ds1682.o
diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
new file mode 100644
index 0000000..b8a6ed6
--- /dev/null
+++ b/drivers/misc/isl29020.c
@@ -0,0 +1,210 @@
+/*
+ * isl29020.c - Intersil  ALS Driver
+ *
+ * Copyright (C) 2008 Intel Corp
+ *
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+
+
+#define ALS_MIN_RANGE_VAL 0
+#define ALS_MAX_RANGE_VAL 5
+
+static unsigned int i2c_write_current_data(struct i2c_client *client,
+					unsigned int reg, unsigned int value)
+{
+	int ret_val;
+
+	ret_val = i2c_smbus_write_byte_data(client, reg, value);
+	return ret_val;
+}
+
+static ssize_t als_sensing_range_show(struct device *dev,
+			struct device_attribute *attr,  char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int  val;
+
+	val = i2c_smbus_read_byte_data(client, 0x00);
+	return sprintf(buf, "%d000\n", 1 << (2 * (val & 3)));
+
+}
+
+static ssize_t als_lux_output_data_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	unsigned int ret_val, val;
+	unsigned long int lux, max_count;
+	int tempv1, tempv2;
+
+	max_count = 65535;
+	tempv1 = i2c_smbus_read_byte_data(client, 0x02); /* MSB data */
+	tempv2 = i2c_smbus_read_byte_data(client, 0x01); /* LSB data */
+	ret_val = tempv1;
+	ret_val = (ret_val << 8 | tempv2);
+	val = i2c_smbus_read_byte_data(client, 0x00);
+	lux = ((((1 << (2 * (val & 3))))*1000) * ret_val) / max_count;
+	return sprintf(buf, "%ld\n", lux);
+}
+
+static ssize_t als_sensing_range_store(struct device *dev,
+		struct device_attribute *attr, const  char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	unsigned int ret_val, set_val = 0;
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+	ret_val = i2c_smbus_read_byte_data(client, 0x00);
+	ret_val = ret_val & 0xFC; /*reset the bit before setting them */
+	if (val == 1)
+		set_val = (ret_val | 0x00); /* setting the 1:0  bit */
+	else if (val == 2)
+		set_val = (ret_val | 0x01);
+	else if (val == 3)
+		set_val = (ret_val | 0x02);
+	else if (val == 4)
+		set_val = (ret_val | 0x03);
+	else
+		goto invarg;
+	i2c_write_current_data(client, 0x00, set_val);
+	return count;
+invarg:
+	return -EINVAL;
+}
+
+static ssize_t als_power_status_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret_val;
+
+	ret_val = i2c_smbus_read_byte_data(client, 0x00);
+	ret_val = ret_val & 0x80;
+	if (ret_val == 0x80)
+		ret_val = 1;
+	return sprintf(buf, "%x", ret_val);
+}
+
+static ssize_t als_power_status_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	unsigned long val = 0;
+	char curr_val;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+
+	curr_val = i2c_smbus_read_byte_data(client, 0x00);
+	if (val == 1)
+		curr_val = curr_val | 0x80;
+	else if (val == 0)
+		curr_val = curr_val & 0x7F;
+	else
+		return -EINVAL;
+	i2c_write_current_data(client, 0x00, curr_val);
+	return count;
+}
+
+static DEVICE_ATTR(sensing_range, S_IRUGO | S_IWUSR,
+	als_sensing_range_show, als_sensing_range_store);
+static DEVICE_ATTR(lux_output, S_IRUGO, als_lux_output_data_show, NULL);
+static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
+	als_power_status_show, als_power_status_store);
+
+static struct attribute *mid_att_als[] = {
+	&dev_attr_sensing_range.attr,
+	&dev_attr_lux_output.attr,
+	&dev_attr_power_state.attr,
+	NULL
+};
+
+static struct attribute_group m_als_gr = {
+	.name = "isl29020",
+	.attrs = mid_att_als
+};
+
+static void als_set_default_config(struct i2c_client *client)
+{
+	i2c_write_current_data(client, 0x00, 0xc0);
+}
+
+static int  isl29020_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	int res = sysfs_create_group(&client->dev.kobj, &m_als_gr);
+	if (res) {
+		dev_err(&client->dev, "isl29020: device create file failed\n");
+		return res;
+	}
+	dev_info(&client->dev, "%s isl29020: ALS chip found\n", client->name);
+	als_set_default_config(client);
+	return res;
+}
+
+static int isl29020_remove(struct i2c_client *client)
+{
+	struct als_data *data = i2c_get_clientdata(client);
+	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
+	kfree(data);
+	return 0;
+}
+
+static struct i2c_device_id isl29020_id[] = {
+	{ "isl29020", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, isl29020_id);
+
+static struct i2c_driver isl29020_driver = {
+	.driver = {
+	.name = "isl29020",
+	},
+	.probe = isl29020_probe,
+	.remove = isl29020_remove,
+	.id_table = isl29020_id,
+};
+
+static int __init sensor_isl29020_init(void)
+{
+	return i2c_add_driver(&isl29020_driver);
+}
+
+static void  __exit sensor_isl29020_exit(void)
+{
+	i2c_del_driver(&isl29020_driver);
+}
+
+module_init(sensor_isl29020_init);
+module_exit(sensor_isl29020_exit);
+
+MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
+MODULE_DESCRIPTION("Intersil isl29020 ALS Driver");
+MODULE_LICENSE("GPL v2");
