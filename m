Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab2KXRQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 12:16:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55050 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2KXRQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 12:16:07 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH RFC] spidev.c: add sysfs attributes for SPI configuration
Date: Sat, 24 Nov 2012 18:20:08 +0100
Message-Id: <1353777608-24934-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce the use of the sysfs attribute for the spidev
configuration. This avoid the user to have a specific program which does
ioctl() on spidev. The user can easily does cat (to read) and echo (to
write) on the sysfs file and configure SPI.

The patch exports the following attributes: bits-per-word, lsb-first,
mode and speed-hz.

Example:
    # cat /sys/bus/spi/devices/spi1.0/speed-hz
    500000
    # echo 450000 > /sys/bus/spi/devices/spi1.0/speed-hz
    # dmesg | tail -n 4
    spidev spi1.0: DEactivate 60, mr 000f0011
    spidev spi1.0: setup: 449447 Hz bpw 8 mode 0x0 -> csr0 0000dd02
    spidev spi1.0: setup mode 0, 8 bits/w, 450000 Hz max --> 0
    spidev spi1.0: 450000 Hz (max)

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/spi/spidev.c | 258 +++++++++++++++++++++++++++++++++++++++++----------
 1 file modificato, 208 inserzioni(+), 50 rimozioni(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 830adbe..4aa0832 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/compat.h>
+#include <linux/sysfs.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spidev.h>
@@ -92,6 +93,201 @@ static unsigned bufsiz = 4096;
 module_param(bufsiz, uint, S_IRUGO);
 MODULE_PARM_DESC(bufsiz, "data bytes in biggest supported SPI message");
 
+
+/*-------------------------------------------------------------------------*/
+
+/* SYSFS */
+enum spidev_config_enum {
+	SPIDEV_SPEED_HZ,
+	SPIDEV_BIT_PER_WORD,
+	SPIDEV_LSB_FIRST,
+	SPIDEV_MODE,
+};
+struct spidev_config_attr {
+	struct device_attribute	attr;
+	enum spidev_config_enum	cmd;
+};
+#define to_spidev_attr(_attr) \
+	container_of(_attr, struct spidev_config_attr, attr)
+
+static int spidev_conf_mode(struct spi_device *spi, u32 tmp)
+{
+	u8 save = spi->mode;
+	int err = 0;
+
+	if (tmp & ~SPI_MODE_MASK)
+		return -EINVAL;
+
+	tmp |= spi->mode & ~SPI_MODE_MASK;
+	spi->mode = (u8)tmp;
+	err = spi_setup(spi);
+	if (err < 0)
+		spi->mode = save;
+	else
+		dev_dbg(&spi->dev, "spi mode %02x\n", tmp);
+
+	return err;
+}
+static int spidev_conf_lsb(struct spi_device *spi, u32 tmp)
+{
+	u8 save = spi->mode;
+	int err = 0;
+
+	if (tmp)
+		spi->mode |= SPI_LSB_FIRST;
+	else
+		spi->mode &= ~SPI_LSB_FIRST;
+	err = spi_setup(spi);
+	if (err < 0)
+		spi->mode = save;
+	else
+		dev_dbg(&spi->dev, "%csb first\n", (tmp ? 'l' : 'm'));
+
+	return err;
+}
+static int spidev_conf_bpw(struct spi_device *spi, u32 tmp)
+{
+	u8 save = spi->bits_per_word;
+	int err = 0;
+
+	spi->bits_per_word = tmp;
+	err = spi_setup(spi);
+	if (err < 0)
+		spi->bits_per_word = save;
+	else
+		dev_dbg(&spi->dev, "%d bits per word\n", tmp);
+
+	return err;
+}
+static int spidev_conf_speedhz(struct spi_device *spi, u32 tmp)
+{
+	u32 save = spi->max_speed_hz;
+	int err = 0;
+
+	spi->max_speed_hz = tmp;
+	err = spi_setup(spi);
+	if (err < 0)
+		spi->max_speed_hz = save;
+	else
+		dev_dbg(&spi->dev, "%d Hz (max)\n", tmp);
+
+	return err;
+}
+
+/* Return to user space the current SPI configuration */
+static ssize_t spidev_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct spidev_config_attr *sattr = to_spidev_attr(attr);
+	struct spidev_data *spidev;
+	struct spi_device *spi;
+	ssize_t count = 0;
+
+	spidev = spi_get_drvdata(to_spi_device(dev));
+
+	spin_lock_irq(&spidev->spi_lock);
+	spi = spi_dev_get(spidev->spi);
+	spin_unlock_irq(&spidev->spi_lock);
+
+	mutex_lock(&spidev->buf_lock);
+	switch (sattr->cmd) {
+	case SPIDEV_MODE:
+		count = sprintf(buf, "%d\n", (spi->mode & SPI_MODE_MASK));
+		break;
+	case SPIDEV_LSB_FIRST:
+		count = sprintf(buf, "%d\n",
+				((spi->mode & SPI_LSB_FIRST) ?  1 : 0));
+		break;
+	case SPIDEV_BIT_PER_WORD:
+		count = sprintf(buf, "%d\n", spi->bits_per_word);
+		break;
+	case SPIDEV_SPEED_HZ:
+		count = sprintf(buf, "%d\n", spi->max_speed_hz);
+		break;
+	}
+	mutex_unlock(&spidev->buf_lock);
+	spi_dev_put(spi);
+
+	return count;
+}
+/* Configure the SPI from userspace */
+static ssize_t spidev_store(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct spidev_config_attr *sattr = to_spidev_attr(attr);
+	struct spidev_data *spidev;
+	struct spi_device *spi;
+	int err = 0;
+	u32 tmp;
+
+	spidev = spi_get_drvdata(to_spi_device(dev));
+
+	spin_lock_irq(&spidev->spi_lock);
+	spi = spi_dev_get(spidev->spi);
+	spin_unlock_irq(&spidev->spi_lock);
+
+	mutex_lock(&spidev->buf_lock);
+	sscanf(buf, "%d", &tmp);
+	err = kstrtou32(buf, 0, &tmp);
+	if (err) {
+		dev_err(&spi->dev, "invalid string \"%s\"", buf);
+		goto out;
+	}
+	switch (sattr->cmd) {
+	case SPIDEV_MODE:
+		err = spidev_conf_mode(spi, tmp);
+		break;
+	case SPIDEV_LSB_FIRST:
+		err = spidev_conf_lsb(spi, tmp);
+		break;
+	case SPIDEV_BIT_PER_WORD:
+		err = spidev_conf_bpw(spi, tmp);
+		break;
+	case SPIDEV_SPEED_HZ:
+		err = spidev_conf_speedhz(spi, tmp);
+		break;
+	}
+
+out:
+	mutex_unlock(&spidev->buf_lock);
+	spi_dev_put(spi);
+	return err ? err : count;
+}
+
+#define SPIDEV_CONFIG_ATTR(_name, _cmd) { \
+	.attr = __ATTR(_name, S_IWUGO | S_IRUGO, spidev_show, spidev_store),\
+	.cmd = _cmd,\
+}
+static struct spidev_config_attr spidev_attrs[] = {
+	SPIDEV_CONFIG_ATTR(speed-hz, SPIDEV_SPEED_HZ),
+	SPIDEV_CONFIG_ATTR(bits-per-word, SPIDEV_BIT_PER_WORD),
+	SPIDEV_CONFIG_ATTR(lsb-first, SPIDEV_LSB_FIRST),
+	SPIDEV_CONFIG_ATTR(mode, SPIDEV_MODE),
+};
+
+static int spidev_create_file(struct device *dev)
+{
+	int i, err = 0;
+
+	pr_info("CREATING sysfs\n");
+	for (i = 0; i < ARRAY_SIZE(spidev_attrs); i++) {
+		err = device_create_file(dev, &spidev_attrs[i].attr);
+		if (err)
+			break;
+	}
+	if (err)
+		while (--i >= 0)
+			device_remove_file(dev, &spidev_attrs[i].attr);
+	return err;
+}
+static void spidev_destroy_file(struct device *dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(spidev_attrs); i++)
+		device_remove_file(dev, &spidev_attrs[i].attr);
+}
+
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -371,65 +567,23 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	/* write requests */
 	case SPI_IOC_WR_MODE:
 		retval = __get_user(tmp, (u8 __user *)arg);
-		if (retval == 0) {
-			u8	save = spi->mode;
-
-			if (tmp & ~SPI_MODE_MASK) {
-				retval = -EINVAL;
-				break;
-			}
-
-			tmp |= spi->mode & ~SPI_MODE_MASK;
-			spi->mode = (u8)tmp;
-			retval = spi_setup(spi);
-			if (retval < 0)
-				spi->mode = save;
-			else
-				dev_dbg(&spi->dev, "spi mode %02x\n", tmp);
-		}
+		if (retval == 0)
+			retval = spidev_conf_mode(spi, tmp);
 		break;
 	case SPI_IOC_WR_LSB_FIRST:
 		retval = __get_user(tmp, (__u8 __user *)arg);
-		if (retval == 0) {
-			u8	save = spi->mode;
-
-			if (tmp)
-				spi->mode |= SPI_LSB_FIRST;
-			else
-				spi->mode &= ~SPI_LSB_FIRST;
-			retval = spi_setup(spi);
-			if (retval < 0)
-				spi->mode = save;
-			else
-				dev_dbg(&spi->dev, "%csb first\n",
-						tmp ? 'l' : 'm');
-		}
+		if (retval == 0)
+			retval = spidev_conf_lsb(spi, tmp);
 		break;
 	case SPI_IOC_WR_BITS_PER_WORD:
 		retval = __get_user(tmp, (__u8 __user *)arg);
-		if (retval == 0) {
-			u8	save = spi->bits_per_word;
-
-			spi->bits_per_word = tmp;
-			retval = spi_setup(spi);
-			if (retval < 0)
-				spi->bits_per_word = save;
-			else
-				dev_dbg(&spi->dev, "%d bits per word\n", tmp);
-		}
+		if (retval == 0)
+			retval = spidev_conf_bpw(spi, tmp);
 		break;
 	case SPI_IOC_WR_MAX_SPEED_HZ:
 		retval = __get_user(tmp, (__u32 __user *)arg);
-		if (retval == 0) {
-			u32	save = spi->max_speed_hz;
-
-			spi->max_speed_hz = tmp;
-			retval = spi_setup(spi);
-			if (retval < 0)
-				spi->max_speed_hz = save;
-			else
-				dev_dbg(&spi->dev, "%d Hz (max)\n", tmp);
-		}
+		if (retval == 0)
+			retval = spidev_conf_speedhz(spi, tmp);
 		break;
 
 	default:
@@ -587,6 +741,9 @@ static int __devinit spidev_probe(struct spi_device *spi)
 	spin_lock_init(&spidev->spi_lock);
 	mutex_init(&spidev->buf_lock);
 
+	/* Add sysfs attribute to spidev*/
+	spidev_create_file(&spi->dev);
+
 	INIT_LIST_HEAD(&spidev->device_entry);
 
 	/* If we can allocate a minor number, hook up this device.
@@ -633,6 +790,7 @@ static int __devexit spidev_remove(struct spi_device *spi)
 	/* prevent new opens */
 	mutex_lock(&device_list_lock);
 	list_del(&spidev->device_entry);
+	spidev_destroy_file(&spi->dev);
 	device_destroy(spidev_class, spidev->devt);
 	clear_bit(MINOR(spidev->devt), minors);
 	if (spidev->users == 0)
-- 
1.7.11.7

