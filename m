Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2IHQRo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 12:17:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55922 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2IHQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 12:17:42 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sat, 08 Sep 2012 11:17:38 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] spi core: Provide means to instantiate devices through sysfs
Date: Sat,  8 Sep 2012 09:17:45 -0700
Message-Id: <1347121065-31879-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C core provides a means to instantiate devices from userspace
using sysfs attributes. Provide the same mechanism for SPI devices.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
This helped me tremendously for testing new SPI master and client drivers.
Maybe it is useful for others as well.

 Documentation/spi/spi-summary |   48 +++++++++++++
 drivers/spi/spi.c             |  159 +++++++++++++++++++++++++++++++++++++++++
 include/linux/spi/spi.h       |    3 +
 3 files changed, 210 insertions(+)

diff --git a/Documentation/spi/spi-summary b/Documentation/spi/spi-summary
index 7312ec1..5b59992 100644
--- a/Documentation/spi/spi-summary
+++ b/Documentation/spi/spi-summary
@@ -331,6 +331,54 @@ configurations will also be dynamic.  Fortunately, such devices all support
 basic device identification probes, so they should hotplug normally.
 
 
+DECLARE SLAVE DEVICES FROM USER-SPACE
+
+In general, the kernel should know which SPI devices are connected and
+what addresses they live at. However, in certain cases, it does not, so a
+sysfs interface was added to let the user provide the information. This
+interface is made of 2 attribute files which are created in every SPI master
+directory: new_device and delete_device. Both files are write only and you
+must write the right parameters to them in order to properly instantiate,
+respectively delete, a SPI device.
+
+File new_device takes several parameters:
+
+Primary parameters are the name of the SPI device (a string), the SPI chip
+select (a number, expressed in decimal or hexadecimal), the SPI bus speed
+(a number, expressed in decimal or hexadecimal), and the SPI mode (a number,
+expressed in decimal or hexadecimal). SPI device name, chip select, and speed
+are mandatory. The mode parameter is optional and will be initialized with 0 if
+not provided.
+
+For at25 type EEPROMs, additional parameters must be provided in < >. Those are
+the EEPROM name (a string), the EEPROM capacity in bytes (a number, expressed in
+decimal or hexadecimal), the EEPROM write page size (a number, expressed in
+decimal or hexadecimal), and the EEPROM flags (a number, expressed in decimal or
+hexadecimal).
+
+File delete_device takes a single parameter: the chip select of the SPI
+device. As no two devices can live at the same chip select on a given SPI
+master, the chip select is sufficient to uniquely identify the device to be
+deleted.
+
+Examples:
+	cd /sys/class/spi_master/spi0
+		Instantiate devices on SPI master 0
+
+	echo "lm70 0 400000" > new_device
+		Instantiate LM70 on CS0
+
+	echo "at25 1 1000000 0 < at25160b 2048 32 0x02 >" > new_device
+		Instantiate at25 driver with AT25160B on CS1
+
+	echo "sst25vf080b 2 1000000 3" > new_device
+		Instantiate SST25VF080B on CS2, using SPI mode 3
+
+While this interface should only be used when in-kernel device declaration
+can't be done, it can be helpful if you are developing a driver on a test board,
+where you soldered the SPI device yourself, or in hot-plug situations.
+
+
 How do I write an "SPI Protocol Driver"?
 ----------------------------------------
 Most SPI drivers are currently kernel drivers, but there's also support
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 84c2861..da9ea04 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -30,11 +30,13 @@
 #include <linux/slab.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
+#include <linux/spi/eeprom.h>
 #include <linux/pm_runtime.h>
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/stat.h>
 
 static void spidev_release(struct device *dev)
 {
@@ -229,6 +231,161 @@ struct bus_type spi_bus_type = {
 };
 EXPORT_SYMBOL_GPL(spi_bus_type);
 
+/*
+ * Let users instantiate SPI devices through sysfs. This can be used when
+ * platform initialization code doesn't contain the proper data for
+ * whatever reason, or for testing.
+ *
+ * Parameter checking may look overzealous, but we really don't want
+ * the user to provide incorrect parameters.
+ */
+static ssize_t
+spi_sysfs_new_device(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct spi_master *master = container_of(dev, struct spi_master, dev);
+	struct spi_board_info info;
+	struct spi_eeprom eeprom;
+	struct spi_device *spi;
+	char end, d1, d2;
+	unsigned int cs, speed, mode = 0;
+	unsigned int len, pagesize, flags;
+	int res;
+
+	dev_warn(dev,
+		 "The new_device interface is still experimental and may change in a near future\n");
+
+	memset(&info, 0, sizeof(struct spi_board_info));
+	memset(&eeprom, 0, sizeof(struct spi_eeprom));
+
+	/* Parse parameters, reject extra parameters */
+	res = sscanf(buf, " %32s %u %u %x %c %10s %u %u %x %c%c",
+		     info.modalias, &cs, &speed, &mode,
+		     &d1, eeprom.name, &len, &pagesize, &flags, &d2,
+		     &end);
+	/* Must have at least name (modalias), chip select, and frequency */
+	if (res < 3) {
+		dev_err(dev, "new_device: Can't parse SPI data\n");
+		return -EINVAL;
+	}
+	if (mode & ~master->mode_bits) {
+		dev_err(dev, "new_device: Unsupported mode\n");
+		return -EINVAL;
+	}
+	if (cs >= master->num_chipselect) {
+		dev_err(dev, "new_device: Bad chipselect\n");
+		return -EINVAL;
+	}
+	if (speed == 0) {
+		dev_err(dev, "new_device: Bad speed\n");
+		return -EINVAL;
+	}
+	if (!strcmp(info.modalias, "at25")) {
+		/* For EEPROMs, all parameters must be provided and valid */
+		if (res != 11 || d1 != '<' || d2 != '>' || end != '\n' ||
+		    !len || !pagesize || !flags || (flags & ~0x1f)) {
+			dev_err(dev, "new_device: Can't parse EEPROM data\n");
+			return -EINVAL;
+		}
+		eeprom.byte_len = len;
+		eeprom.page_size = pagesize;
+		eeprom.flags = flags;
+		info.platform_data = &eeprom;
+	} else if (res > 4) {
+		dev_err(dev, "new_device: Extra parameters\n");
+		return -EINVAL;
+	}
+	info.chip_select = cs;
+	info.mode = mode;
+	info.max_speed_hz = speed;
+
+	spi = spi_new_device(master, &info);
+	if (!spi)
+		return -EINVAL;
+
+	/* Keep track of the added device */
+	mutex_lock(&master->bus_lock_mutex);
+	list_add_tail(&spi->detected, &master->userspace_devices);
+	mutex_unlock(&master->bus_lock_mutex);
+	dev_info(dev,
+		 "new_device: Instantiated device %s:%u (speed=%u, mode=%u)\n",
+		 info.modalias, info.chip_select, info.max_speed_hz, info.mode);
+
+	return count;
+}
+
+/*
+ * And of course let the users delete the devices they instantiated, if
+ * they got it wrong. This interface can only be used to delete devices
+ * instantiated by spi_sysfs_new_device above. This guarantees that we
+ * don't delete devices to which some kernel code still has references.
+ *
+ * Parameter checking may look overzealous, but we really don't want
+ * the user to delete the wrong device.
+ */
+static ssize_t
+spi_sysfs_delete_device(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct spi_master *master = container_of(dev, struct spi_master, dev);
+	struct spi_device *spi, *next;
+	unsigned int cs;
+	char end;
+	int res;
+
+	/* Parse parameters, reject extra parameters */
+	res = sscanf(buf, "%u%c", &cs, &end);
+	if (res < 1) {
+		dev_err(dev, "delete_device: Can't parse SPI chip select\n");
+		return -EINVAL;
+	}
+	if (res > 1 && end != '\n') {
+		dev_err(dev, "delete_device: Extra parameters\n");
+		return -EINVAL;
+	}
+
+	/* Make sure the device was added through sysfs */
+	res = -ENOENT;
+	mutex_lock(&master->bus_lock_mutex);
+	list_for_each_entry_safe(spi, next, &master->userspace_devices,
+				 detected) {
+		if (spi->chip_select == cs) {
+			dev_info(dev, "delete_device: Deleting device %s:%u\n",
+				 spi->modalias, spi->chip_select);
+			list_del(&spi->detected);
+			spi_unregister_device(spi);
+			res = count;
+			break;
+		}
+	}
+	mutex_unlock(&master->bus_lock_mutex);
+
+	if (res < 0)
+		dev_err(dev, "delete_device: Can't find device in list\n");
+	return res;
+}
+
+static DEVICE_ATTR(new_device, S_IWUSR, NULL, spi_sysfs_new_device);
+static DEVICE_ATTR(delete_device, S_IWUSR, NULL, spi_sysfs_delete_device);
+
+static struct attribute *spi_master_attrs[] = {
+	&dev_attr_new_device.attr,
+	&dev_attr_delete_device.attr,
+	NULL
+};
+
+static struct attribute_group spi_master_attr_group = {
+	.attrs		= spi_master_attrs,
+};
+
+static const struct attribute_group *spi_master_attr_groups[] = {
+	&spi_master_attr_group,
+	NULL
+};
+
+static struct device_type spi_master_type = {
+	.groups		= spi_master_attr_groups,
+};
 
 static int spi_drv_probe(struct device *dev)
 {
@@ -584,6 +741,7 @@ static int spi_init_queue(struct spi_master *master)
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
 
 	INIT_LIST_HEAD(&master->queue);
+	INIT_LIST_HEAD(&master->userspace_devices);
 	spin_lock_init(&master->queue_lock);
 
 	master->running = false;
@@ -939,6 +1097,7 @@ struct spi_master *spi_alloc_master(struct device *dev, unsigned size)
 	master->bus_num = -1;
 	master->num_chipselect = 1;
 	master->dev.class = &spi_master_class;
+	master->dev.type = &spi_master_type;
 	master->dev.parent = get_device(dev);
 	spi_master_set_devdata(master, &master[1]);
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index fa702ae..dac46bc 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -91,6 +91,8 @@ struct spi_device {
 	void			*controller_data;
 	char			modalias[SPI_NAME_SIZE];
 
+	struct list_head	detected;
+
 	/*
 	 * likely need more hooks for more protocol options affecting how
 	 * the controller talks to each chip, like:
@@ -273,6 +275,7 @@ struct spi_master {
 	struct device	dev;
 
 	struct list_head list;
+	struct list_head userspace_devices;
 
 	/* other than negative (== assign one dynamically), bus_num is fully
 	 * board-specific.  usually that simplifies to being SOC-specific.
-- 
1.7.9.7

