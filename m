Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1CRJhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:37:33 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:58258 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab1CRJhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:37:24 -0400
X-AuditID: 83cfa826-b7c1cae000000efa-68-4d8327d14b58
From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
To: <linux-i2c@vger.kernel.org>
CC: <arnd@arndb.de>, <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <hthebaud@insidefr.com>, <matti.j.aaltonen@nokia.com>,
        Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Fri, 18 Mar 2011 11:40:24 +0100
Message-ID: <1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new driver for MicroRead NFC chip connected to i2c bus.

See Documentation/nfc/nfc-microread.txt.

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
---
 Documentation/nfc/nfc-microread.txt |   46 ++++
 drivers/nfc/Kconfig                 |   10 +
 drivers/nfc/Makefile                |    1 +
 drivers/nfc/microread.c             |  465 +++++++++++++++++++++++++++++++++++
 include/linux/nfc/microread.h       |   31 +++
 5 files changed, 553 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/nfc/nfc-microread.txt
 create mode 100644 drivers/nfc/microread.c
 create mode 100644 include/linux/nfc/microread.h

diff --git a/Documentation/nfc/nfc-microread.txt b/Documentation/nfc/nfc-microread.txt
new file mode 100644
index 0000000..e15c49c
--- /dev/null
+++ b/Documentation/nfc/nfc-microread.txt
@@ -0,0 +1,46 @@
+Kernel driver for Inside Secure MicroRead Near Field Communication chip
+
+General
+-------
+
+microread is the RF chip that uses Near Field Communication (NFC) for proximity
+transactions and interactions.
+
+Please visit Inside Secure webside for microread specification:
+http://www.insidesecure.com/eng/Products/NFC-Products/MicroRead
+
+
+The Driver
+----------
+
+The microread driver can be found under drivers/nfc/microread.c and it's
+compiled as a module named "microread".
+
+The driver supports i2c interface only.
+
+The userspace application can use /dev/microread device to control the chip by
+HCI messages. In a typical scenario application will open() /dev/microread,
+reset the chip useing ioctl() interface then poll() the device to check if
+writing/reaing is possible.Finally, will read/write data (HCI) from/to the chip.
+
+Note that only one application can use the /dev/microread at the time.
+
+The driver waits for microread chip interrupt which occures if there are some
+data to be read. Then, poll() will indicate that fact to the userspace.
+
+The application can use ioctl(MICROREAD_IOC_RESET)to reset the hardware.
+
+
+Platform Data
+-------------
+
+The below platform data should be set when configuring board.
+
+struct microread_nfc_platform_data {
+	unsigned int rst_gpio;
+	unsigned int irq_gpio;
+	unsigned int ioh_gpio;
+	int (*request_hardware) (struct i2c_client *client);
+	void (*release_hardware) (void);
+};
+
diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index ea15800..a805615 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -26,5 +26,15 @@ config PN544_NFC
 	  To compile this driver as a module, choose m here. The module will
 	  be called pn544.
 
+config MICROREAD_NFC
+	tristate "MICROREAD NFC driver"
+	depends on I2C
+	default n
+	---help---
+	  Say yes if you want Inside Secure Microread Near Field Communication
+	  driver. This is for i2c connected version. If unsure, say N here.
+
+	  To compile this driver as a module, choose m here. The module will
+	  be called microread.
 
 endif # NFC_DEVICES
diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index a4efb16..974f5cb 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_PN544_NFC)		+= pn544.o
+obj-$(CONFIG_MICROREAD_NFC)	+= microread.o
diff --git a/drivers/nfc/microread.c b/drivers/nfc/microread.c
new file mode 100644
index 0000000..bcbdbad
--- /dev/null
+++ b/drivers/nfc/microread.c
@@ -0,0 +1,465 @@
+/*
+ *  Driver for Microread NFC chip
+ *
+ *  Copyright (C) 2011 Tieto Poland
+ *
+ *  Author: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/miscdevice.h>
+#include <linux/nfc/microread.h>
+#include <linux/uaccess.h>
+#include <linux/pm.h>
+
+#define MICROREAD_DEV_NAME	"microread"
+#define MICROREAD_MAX_BUF_SIZE	0x20
+
+#define MICROREAD_STATE_BUSY	0x00
+#define MICROREAD_STATE_READY	0x01
+
+struct microread_info {
+	struct i2c_client *i2c_dev;
+	struct miscdevice mdev;
+
+	u8 state;
+	u8 irq_state;
+	int irq;
+	u16 buflen;
+	u8 *buf;
+	wait_queue_head_t rx_waitq;
+	struct mutex rx_mutex;
+	struct mutex mutex;
+};
+
+static void microread_reset_hw(struct microread_nfc_platform_data *pdata)
+{
+	gpio_set_value(pdata->rst_gpio, 1);
+	usleep_range(1000, 2000);
+	gpio_set_value(pdata->rst_gpio, 0);
+	usleep_range(5000, 10000);
+}
+
+static u8 calc_lrc(u8 *buf, int len)
+{
+	int i;
+	u8 lrc = 0;
+	for (i = 0; i < len; i++)
+		lrc = lrc ^ buf[i];
+	return lrc;
+}
+
+static inline int microread_is_busy(struct microread_info *info)
+{
+	return (info->state == MICROREAD_STATE_BUSY);
+}
+
+static int microread_open(struct inode *inode, struct file *file)
+{
+	struct microread_info *info = container_of(file->private_data,
+					struct microread_info, mdev);
+	struct i2c_client *client = info->i2c_dev;
+	int ret = 0;
+
+	dev_vdbg(&client->dev, "%s: info: %p", __func__, info);
+
+	mutex_lock(&info->mutex);
+
+	if (microread_is_busy(info)) {
+		dev_err(&client->dev, "%s: info %p: device is busy.", __func__,
+				info);
+		ret = -EBUSY;
+		goto done;
+	}
+
+	info->state = MICROREAD_STATE_BUSY;
+done:
+	mutex_unlock(&info->mutex);
+	return ret;
+}
+
+static int microread_release(struct inode *inode, struct file *file)
+{
+	struct microread_info *info = container_of(file->private_data,
+					struct microread_info, mdev);
+	struct i2c_client *client = info->i2c_dev;
+
+	dev_vdbg(&client->dev, "%s: info: %p, client %p\n", __func__, info,
+					client);
+
+	mutex_lock(&info->mutex);
+	info->state = MICROREAD_STATE_READY;
+	mutex_unlock(&info->mutex);
+
+	return 0;
+}
+
+static ssize_t microread_read(struct file *file, char __user *buf, size_t count,
+								loff_t *f_pos)
+{
+	struct microread_info *info = container_of(file->private_data,
+					struct microread_info, mdev);
+	struct i2c_client *client = info->i2c_dev;
+	struct microread_nfc_platform_data *pdata =
+				dev_get_platdata(&client->dev);
+	int ret;
+	u8 len, lrc;
+
+	dev_dbg(&client->dev, "%s: info: %p, size: %d (bytes).", __func__,
+						info, count);
+	mutex_lock(&info->mutex);
+
+	if (!info->irq_state && !gpio_get_value(pdata->irq_gpio)) {
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			goto done;
+		}
+
+		if (wait_event_interruptible(info->rx_waitq,
+				(info->irq_state == 1))) {
+			ret = -EINTR;
+			goto done;
+		}
+	}
+
+	if (count > info->buflen) {
+		dev_err(&client->dev, "%s: no enough space in read buffer.",
+				__func__);
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	mutex_lock(&info->rx_mutex);
+	ret = i2c_master_recv(client, info->buf, info->buflen);
+	info->irq_state = 0;
+	mutex_unlock(&info->rx_mutex);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: i2c read (data) failed (err %d).",
+				__func__, ret);
+		ret = -EREMOTEIO;
+		goto done;
+	}
+
+#ifdef VERBOSE_DEBUG
+		print_hex_dump(KERN_DEBUG, "rx: ", DUMP_PREFIX_NONE,
+				16, 1, info->buf, ret, false);
+#endif
+	len = info->buf[0];
+
+	lrc = calc_lrc(info->buf, len + 1);
+	if (lrc != info->buf[len + 1]) {
+		dev_err(&client->dev, "%s: incorrect i2c frame.", __func__);
+		ret = -EFAULT;
+		goto done;
+	}
+
+	ret = len + 2;
+
+	if (copy_to_user(buf, info->buf, len + 2)) {
+		dev_err(&client->dev, "%s: error copying to user.", __func__);
+		ret = -EFAULT;
+		goto done;
+	}
+done:
+	mutex_unlock(&info->mutex);
+
+	return ret;
+}
+
+static ssize_t microread_write(struct file *file, const char __user *buf,
+			size_t count, loff_t *f_pos)
+{
+	struct microread_info *info = container_of(file->private_data,
+					struct microread_info, mdev);
+	struct i2c_client *client = info->i2c_dev;
+	int ret;
+	u16 len;
+
+	dev_dbg(&client->dev, "%s: info: %p, size %d (bytes).", __func__,
+					info, count);
+
+	if (count > info->buflen) {
+		dev_err(&client->dev, "%s: no enought space in TX buffer.",
+				__func__);
+		return -EINVAL;
+	}
+
+	len = min_t(u16, count, info->buflen);
+
+	mutex_lock(&info->mutex);
+	if (copy_from_user(info->buf, buf, len)) {
+		dev_err(&client->dev, "%s: error copying from user.",
+				__func__);
+		ret = -EFAULT;
+		goto done;
+	}
+
+#ifdef VERBOSE_DEBUG
+	print_hex_dump(KERN_DEBUG, "tx: ", DUMP_PREFIX_NONE, 16, 1, info->buf,
+			len, false);
+#endif
+	ret = i2c_master_send(client, info->buf, len);
+	if (ret < 0)
+		dev_err(&client->dev, "%s: i2c write failed (err %d).",
+			__func__, ret);
+
+done:
+	mutex_unlock(&info->mutex);
+	return ret;
+
+}
+
+static unsigned int microread_poll(struct file *file, poll_table *wait)
+{
+	struct microread_info *info = container_of(file->private_data,
+					struct microread_info, mdev);
+	struct i2c_client *client = info->i2c_dev;
+	int ret = (POLLOUT | POLLWRNORM);
+
+	dev_vdbg(&client->dev, "%s: info: %p client %p", __func__, info,
+			client);
+
+	mutex_lock(&info->mutex);
+	poll_wait(file, &info->rx_waitq, wait);
+
+	mutex_lock(&info->rx_mutex);
+	if (info->irq_state)
+		ret |= (POLLIN | POLLRDNORM);
+	mutex_unlock(&info->rx_mutex);
+	mutex_unlock(&info->mutex);
+
+	return ret;
+}
+
+static long microread_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	struct microread_info *info = container_of(file->private_data,
+					struct microread_info, mdev);
+	struct i2c_client *client = info->i2c_dev;
+	struct microread_nfc_platform_data *pdata =
+				dev_get_platdata(&client->dev);
+	int ret = 0;
+
+	dev_dbg(&client->dev, "%s: info: %p cmd %d", __func__, info, cmd);
+
+	mutex_lock(&info->mutex);
+
+	switch (cmd) {
+	case MICROREAD_IOC_CONFIGURE:
+	case MICROREAD_IOC_CONNECT:
+		goto done;
+
+	case MICROREAD_IOC_RESET:
+		microread_reset_hw(pdata);
+		goto done;
+
+	default:
+		dev_err(&client->dev, "%s; not supported ioctl 0x%x", __func__,
+			cmd);
+		ret = -ENOIOCTLCMD;
+		goto done;
+	}
+
+done:
+	mutex_unlock(&info->mutex);
+	return ret;
+}
+
+const struct file_operations microread_fops = {
+	.owner		= THIS_MODULE,
+	.open		= microread_open,
+	.release	= microread_release,
+	.read		= microread_read,
+	.write		= microread_write,
+	.poll		= microread_poll,
+	.unlocked_ioctl	= microread_ioctl,
+};
+
+static irqreturn_t microread_irq(int irq, void *dev)
+{
+	struct microread_info *info = dev;
+	struct i2c_client *client = info->i2c_dev;
+
+	dev_dbg(&client->dev, "irq: info %p client %p ", info,	client);
+
+	if (irq != client->irq)
+		return IRQ_NONE;
+
+	mutex_lock(&info->rx_mutex);
+	info->irq_state = 1;
+	mutex_unlock(&info->rx_mutex);
+
+	wake_up_interruptible(&info->rx_waitq);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit microread_probe(struct i2c_client *client,
+				 const struct i2c_device_id *id)
+{
+	struct microread_info *info;
+	struct microread_nfc_platform_data *pdata =
+				dev_get_platdata(&client->dev);
+	int ret = 0;
+
+	dev_dbg(&client->dev, "%s: client %p", __func__, client);
+
+	if (!pdata) {
+		dev_err(&client->dev, "%s: client %p: missing platform data.",
+				__func__, client);
+		return -EINVAL;
+	}
+
+	info = kzalloc(sizeof(struct microread_info), GFP_KERNEL);
+	if (!info) {
+		dev_err(&client->dev, "%s: can't allocate microread_info.",
+				__func__);
+		return -ENOMEM;
+	}
+
+	info->buflen = (u16) MICROREAD_MAX_BUF_SIZE;
+	info->buf = kzalloc(info->buflen, GFP_KERNEL);
+	if (!info->buf) {
+		dev_err(&client->dev, "%s: can't allocate buf. (len %d)",
+			__func__, info->buflen);
+		ret = -ENOMEM;
+		goto free_info;
+	}
+
+	mutex_init(&info->mutex);
+	mutex_init(&info->rx_mutex);
+	init_waitqueue_head(&info->rx_waitq);
+	i2c_set_clientdata(client, info);
+	info->i2c_dev = client;
+	info->irq_state = 0;
+	info->state = MICROREAD_STATE_READY;
+
+	ret = request_threaded_irq(client->irq, NULL, microread_irq,
+		IRQF_SHARED|IRQF_TRIGGER_RISING, MICROREAD_DRIVER_NAME, info);
+	if (ret) {
+		dev_err(&client->dev, "%s: can't request irq. (ret %d, irq %d)",
+			__func__, ret, client->irq);
+		goto free_buf;
+	}
+
+	info->mdev.minor = MISC_DYNAMIC_MINOR;
+	info->mdev.name = MICROREAD_DEV_NAME;
+	info->mdev.fops = &microread_fops;
+	info->mdev.parent = &client->dev;
+
+	ret = misc_register(&info->mdev);
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: register chr dev failed (ret %d)",
+			__func__, ret);
+			goto free_irq;
+	}
+
+	dev_info(&client->dev, "Probed.[/dev/%s]", MICROREAD_DEV_NAME);
+	return 0;
+
+free_irq:
+	free_irq(client->irq, info);
+free_buf:
+	kfree(info->buf);
+free_info:
+	kfree(info);
+
+	dev_info(&client->dev, "Not probed.");
+	return ret;
+}
+
+static __devexit int microread_remove(struct i2c_client *client)
+{
+	struct microread_info *info = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "%s", __func__);
+
+	misc_deregister(&info->mdev);
+	free_irq(client->irq, info);
+	kfree(info->buf);
+	kfree(info);
+
+	dev_info(&client->dev, "%s: Removed.", __func__);
+	return 0;
+}
+
+static int microread_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	return -ENOSYS;
+}
+
+static int microread_resume(struct i2c_client *client)
+{
+	return -ENOSYS;
+}
+
+static struct i2c_device_id microread_id[] = {
+	{ MICROREAD_DRIVER_NAME, 0},
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, microread_id);
+
+static struct i2c_driver microread_driver = {
+	.driver = {
+		.name = MICROREAD_DRIVER_NAME,
+	},
+	.probe		= microread_probe,
+	.remove		= __devexit_p(microread_remove),
+	.suspend	= microread_suspend,
+	.resume		= microread_resume,
+	.id_table	= microread_id,
+};
+
+static int __init microread_init(void)
+{
+	int ret;
+
+	pr_debug(MICROREAD_DRIVER_NAME ": %s", __func__);
+
+	ret = i2c_add_driver(&microread_driver);
+	if (ret) {
+		pr_err(MICROREAD_DRIVER_NAME ": driver registration failed");
+		return ret;
+	}
+	pr_info(MICROREAD_DRIVER_NAME ": Loaded.");
+	return 0;
+}
+
+static void __exit microread_exit(void)
+{
+	pr_debug(MICROREAD_DRIVER_NAME ": %s", __func__);
+	i2c_del_driver(&microread_driver);
+	pr_info(MICROREAD_DRIVER_NAME ": Unloaded");
+}
+
+module_init(microread_init);
+module_exit(microread_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>");
+MODULE_DESCRIPTION("Driver for Microread NFC chip");
diff --git a/include/linux/nfc/microread.h b/include/linux/nfc/microread.h
new file mode 100644
index 0000000..a0ad68e
--- /dev/null
+++ b/include/linux/nfc/microread.h
@@ -0,0 +1,31 @@
+#ifndef _MICROREAD_H
+#define _MICROREAD_H
+
+#include <linux/i2c.h>
+
+#define MICROREAD_DRIVER_NAME	"microread"
+
+#define MICROREAD_IOC_MAGIC	'o'
+#define MICROREAD_IOC_MAX_CONFIG_LENGTH	16
+
+struct microread_ioc_configure {
+	int length;
+	unsigned char buffer[MICROREAD_IOC_MAX_CONFIG_LENGTH];
+};
+
+/* ioctl cmds */
+#define MICROREAD_IOC_CONFIGURE	_IOW(MICROREAD_IOC_MAGIC, 0, \
+					struct microread_ioc_configure)
+#define MICROREAD_IOC_CONNECT	_IO(MICROREAD_IOC_MAGIC, 1)
+#define MICROREAD_IOC_RESET	_IO(MICROREAD_IOC_MAGIC, 2)
+
+#ifdef __KERNEL__
+/* board config platform data for microread */
+struct microread_nfc_platform_data {
+	unsigned int rst_gpio;
+	unsigned int irq_gpio;
+	unsigned int ioh_gpio;
+};
+#endif /* __KERNEL__ */
+
+#endif /* _MICROREAD_H */
-- 
1.7.1

