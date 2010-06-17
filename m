Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864Ab0FQLrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 07:47:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60416 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755914Ab0FQLrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 07:47:19 -0400
Date: Thu, 17 Jun 2010 12:50:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hmc6352: Add driver for the HMC6352 compass
Message-ID: <20100617125056.6d648ee7@lxorguk.ukuu.org.uk>
In-Reply-To: <20100616151056.181234b0@hyperion.delvare>
References: <20100616121534.26294.12540.stgit@localhost.localdomain>
	<20100616151056.181234b0@hyperion.delvare>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	struct i2c_msg msg1[] = {
> > +		{ client->addr, 0, 1, &cmd1 },
> > +	};
> 
> It's quite overkill IMHO to have two messages here. In the end you send
> only one. It would make sense if you made these messages static const,

They can't be const but I cleaned it up based on your other suggestions and
then jumped up and down on it a bit more.


hmc6352: Add driver for the HMC6352 compass

From: Kalhan Trisal <kalhan.trisal@intel.com>

This driver will report the heading values in degrees to the sysfs interface.
The values returned are headings . e.g. 245.6

Cleanups requested now all folded in and a sysfs description to keep Andrew
happy.

Signed-off-by: Kalhan Trisal <kalhan.trisal@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 .../ABI/testing/sysfs-bus-i2c-devices-hm6352       |   21 +++
 drivers/misc/Kconfig                               |    7 +
 drivers/misc/Makefile                              |    1 
 drivers/misc/hmc6352.c                             |  165 ++++++++++++++++++++
 4 files changed, 194 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352
 create mode 100644 drivers/misc/hmc6352.c


diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352 b/Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352
new file mode 100644
index 0000000..feb2e4a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352
@@ -0,0 +1,21 @@
+Where:		/sys/bus/i2c/devices/.../heading0_input
+Date:		April 2010
+Kernel Version: 2.6.36?
+Contact:	alan.cox@intel.com
+Description:	Reports the current heading from the compass as a floating
+		point value in degrees.
+
+Where:		/sys/bus/i2c/devices/.../power_state
+Date:		April 2010
+Kernel Version: 2.6.36?
+Contact:	alan.cox@intel.com
+Description:	Sets the power state of the device. 0 sets the device into
+		sleep mode, 1 wakes it up.
+
+Where:		/sys/bus/i2c/devices/.../calibration
+Date:		April 2010
+Kernel Version: 2.6.36?
+Contact:	alan.cox@intel.com
+Description:	Sets the calibration on or off (1 = on, 0 = off). See the
+		chip data sheet.
+
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 26386a9..9e825cb 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -304,6 +304,13 @@ config SENSORS_TSL2550
 	  This driver can also be built as a module.  If so, the module
 	  will be called tsl2550.
 
+config HMC6352
+	tristate "Honeywell HMC6352 compass"
+	depends on I2C
+	help
+	  This driver provides support for the Honeywell HMC6352 compass,
+	  providing configuration and heading data via sysfs.
+
 config EP93XX_PWM
 	tristate "EP93xx PWM support"
 	depends on ARCH_EP93XX
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 6ed06a1..48597df 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
+obj-$(CONFIG_HMC6352)		+= hmc6352.o
 obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
new file mode 100644
index 0000000..3243c8c
--- /dev/null
+++ b/drivers/misc/hmc6352.c
@@ -0,0 +1,165 @@
+/*
+ * hmc6352.c - Honeywell Compass Driver
+ *
+ * Copyright (C) 2009 Intel Corp
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
+static DEFINE_MUTEX(compass_mutex);
+
+static int compass_command(struct i2c_client *c, u8 cmd)
+{
+	int ret = i2c_master_send(c, &cmd, 1);
+	if (ret < 0)
+		dev_warn(&c->dev, "command '%c' failed.\n", cmd);
+	return ret;
+}
+
+static int compass_store(struct device *dev, const char *buf, size_t count,
+			const char *map)
+{
+	struct i2c_client *c = to_i2c_client(dev);
+	int ret;
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+	if (val < 0 || val >= strlen(map) || map[val] == ' ')
+		return -EINVAL;
+	mutex_lock(&compass_mutex);
+	ret = compass_command(c, map[val]);
+	mutex_unlock(&compass_mutex);
+	return ret;
+}
+
+static ssize_t compass_calibration_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return compass_store(dev, buf, count, " CE");
+}	
+
+static ssize_t compass_power_mode_store(struct device *dev,
+		struct device_attribute *attr, const  char *buf, size_t count)
+{
+	return compass_store(dev, buf, count, "SW");
+}
+
+static ssize_t compass_heading_data_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+
+	struct i2c_client *client = to_i2c_client(dev);
+	unsigned char i2c_data[2];
+	unsigned int ret;
+
+	mutex_lock(&compass_mutex);
+	ret = compass_command(client, 'A');
+	if (ret != 1) {
+		mutex_unlock(&compass_mutex);
+		return ret;
+	}
+	msleep(10); /* sending 'A' cmd we need to wait for 7-10 millisecs */
+	ret = i2c_master_recv(client, i2c_data, 2);
+	mutex_unlock(&compass_mutex);
+	if (ret != 1) {
+		dev_warn(dev, "i2c read data cmd failed\n");
+		return ret;
+	}
+	ret = (i2c_data[0] << 8) | i2c_data[1];
+	return sprintf(buf, "%d.%d\n", ret/10, ret%10);
+}
+
+
+static DEVICE_ATTR(heading0_input, S_IRUGO, compass_heading_data_show, NULL);
+static DEVICE_ATTR(calibration, S_IWUSR, NULL, compass_calibration_store);
+static DEVICE_ATTR(power_state, S_IWUSR, NULL, compass_power_mode_store);
+
+static struct attribute *mid_att_compass[] = {
+	&dev_attr_heading0_input.attr,
+	&dev_attr_calibration.attr,
+	&dev_attr_power_state.attr,
+	NULL
+};
+
+static const struct attribute_group m_compass_gr = {
+	.name = "hmc6352",
+	.attrs = mid_att_compass
+};
+
+static int hmc6352_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	int res;
+
+	res = sysfs_create_group(&client->dev.kobj, &m_compass_gr);
+	if (res) {
+		dev_err(&client->dev, "device_create_file failed\n");
+		return res;
+	}
+	dev_info(&client->dev, "%s HMC6352 compass chip found\n",
+							client->name);
+	return 0;
+}
+
+static int hmc6352_remove(struct i2c_client *client)
+{
+	sysfs_remove_group(&client->dev.kobj, &m_compass_gr);
+	return 0;
+}
+
+static struct i2c_device_id hmc6352_id[] = {
+	{ "hmc6352", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, hmc6352_id);
+
+static struct i2c_driver hmc6352_driver = {
+	.driver = {
+		.name = "hmc6352",
+	},
+	.probe = hmc6352_probe,
+	.remove = hmc6352_remove,
+	.id_table = hmc6352_id,
+};
+
+static int __init sensor_hmc6352_init(void)
+{
+	return i2c_add_driver(&hmc6352_driver);
+}
+
+static void  __exit sensor_hmc6352_exit(void)
+{
+	i2c_del_driver(&hmc6352_driver);
+}
+
+module_init(sensor_hmc6352_init);
+module_exit(sensor_hmc6352_exit);
+
+MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
+MODULE_DESCRIPTION("hmc6352 Compass Driver");
+MODULE_LICENSE("GPL v2");

