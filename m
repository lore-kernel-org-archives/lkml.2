Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab0KOIYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:24:53 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:45129 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab0KOIYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:24:52 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Indan Zupancic <indan@nul.nu>,
        Greg KH <greg@kroah.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Alex Gershgorin <agersh@rambler.ru>, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCHv3] drivers/misc: Altera active serial implementation
Date: Mon, 15 Nov 2010 10:23:12 +0200
Message-Id: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Gershgorin <agersh@rambler.ru>

The active serial protocol can be used to program Altera serial configuration
devices. This driver uses the kernel gpio interface to implement the active
serial protocol.

This patch also introduces the include/platform_drivers/ directory, which is
the new home for platform data headers. This is per Greg's suggestion.

Reviewed-by: Indan Zupancic <indan@nul.nu>
Signed-off-by: Alex Gershgorin <agersh@rambler.ru>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
Changes in v3:

    * Rename to altera_as for a better description of the driver scope

    * Mention ESPC devices in the Kconfig help text

    * Add a comment that explains why the static altera_as_devs arrays doesn't
      need locking protection

    * Shorten too long delays

    * Move the erase operation to a separate function

    * Eliminate page_count in .write, use *ppos instead

Changes in v2:

    * Don't create a new class, use the misc class instead

    * Depend on GENERIC_GPIO

    * Simplify xmit_byte(), use bitrev8() to flip data bytes

    * Add xmit_cmd() to simplify send of simple commands

    * Remove unnecessary debug prints

    * Check msleep_interruptible() return value

    * Remove unneeded ndelay() calls

    * Poll the write-in-progress indicator instead of waiting for a fixed (and 
      too short) period of time after erase.

 drivers/misc/Kconfig                 |   12 ++
 drivers/misc/Makefile                |    1 +
 drivers/misc/altera_as.c             |  349 ++++++++++++++++++++++++++++++++++
 include/platform_drivers/altera_as.h |   28 +++
 4 files changed, 390 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/altera_as.c
 create mode 100644 include/platform_drivers/altera_as.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4d073f1..6dbe59b 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -452,6 +452,18 @@ config PCH_PHUB
 	  To compile this driver as a module, choose M here: the module will
 	  be called pch_phub.
 
+config ALTERA_AS
+	depends on GENERIC_GPIO
+	tristate "Altera Active Serial driver"
+	help
+	  Provides support for active serial programming of Altera serial
+	  configuration devices (EPCS1, EPCS4, EPCS16, EPCS128). For the active
+	  serial protocol details see the Altera "Serial Configuration Devices"
+	  document (C51014).
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called altera_as.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 98009cc..ea03995 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
 obj-y				+= ti-st/
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
+obj-$(CONFIG_ALTERA_AS)		+= altera_as.o
diff --git a/drivers/misc/altera_as.c b/drivers/misc/altera_as.c
new file mode 100644
index 0000000..b6806a6
--- /dev/null
+++ b/drivers/misc/altera_as.c
@@ -0,0 +1,349 @@
+/*
+ * Copyright 2010 Alex Gershgorin, Orex Computed Radiography
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ */
+
+#include <linux/fs.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/bitrev.h>
+#include <linux/device.h>
+#include <linux/uaccess.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+
+#include <platform_drivers/altera_as.h>
+
+/* Active Serial Instruction Set */
+#define AS_WRITE_ENABLE		0x06
+#define AS_WRITE_DISABLE	0x04
+#define AS_READ_STATUS		0x05
+#define AS_WRITE_STATUS		0x01
+#define AS_READ_BYTES		0x03
+#define AS_FAST_READ_BYTES	0x0B
+#define AS_PAGE_PROGRAM		0x02
+#define AS_ERASE_SECTOR		0xD8
+#define AS_ERASE_BULK		0xC7
+#define AS_READ_SILICON_ID	0xAB
+#define AS_CHECK_SILICON_ID	0x9F
+
+#define AS_STATUS_WIP		(1 << 0)
+#define AS_STATUS_WEL		(1 << 1)
+#define AS_STATUS_BP0		(1 << 2)
+#define AS_STATUS_BP1		(1 << 3)
+#define AS_STATUS_BP2		(1 << 4)
+
+#define AS_ERASE_TIMEOUT	250 /* seconds, max for EPCS128 */
+
+#define AS_PAGE_SIZE		256
+
+#define AS_MAX_DEVS		16
+
+#define ASIO_DATA		0
+#define ASIO_ASDI		1
+#define ASIO_NCONFIG		2
+#define ASIO_DCLK		3
+#define ASIO_NCS		4
+#define ASIO_NCE		5
+#define AS_GPIO_NUM		6
+
+#define AS_ALIGNED(x)	IS_ALIGNED(x, AS_PAGE_SIZE)
+
+struct altera_as_device {
+	unsigned id;
+	struct device *dev;
+	struct miscdevice miscdev;
+	struct mutex open_lock;
+	struct gpio gpios[AS_GPIO_NUM];
+};
+
+/*
+ * The only functions updating this array are .probe/.remove, which are
+ * serialized. Hence, no locking is needed here.
+ */
+static struct {
+	int minor;
+	struct altera_as_device *drvdata;
+} altera_as_devs[AS_MAX_DEVS];
+
+static struct altera_as_device *get_as_dev(int minor)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(altera_as_devs); i++)
+		if (altera_as_devs[i].minor == minor)
+			return altera_as_devs[i].drvdata;
+
+	return NULL;
+}
+
+static void as_clk_tick(struct gpio *gpios)
+{
+	gpio_set_value(gpios[ASIO_DCLK].gpio, 0);
+	ndelay(20);
+	gpio_set_value(gpios[ASIO_DCLK].gpio, 1);
+	ndelay(20);
+}
+
+static void xmit_byte(struct gpio *gpios, u8 c)
+{
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		gpio_set_value(gpios[ASIO_ASDI].gpio, (c << i) & 0x80);
+		as_clk_tick(gpios);
+	}
+}
+
+static void xmit_cmd(struct gpio *gpios, u8 cmd)
+{
+	gpio_set_value(gpios[ASIO_NCS].gpio, 0);
+	xmit_byte(gpios, cmd);
+	gpio_set_value(gpios[ASIO_NCS].gpio, 1);
+	ndelay(100);
+}
+
+static u8 recv_byte(struct gpio *gpios)
+{
+	int i;
+	u8 val = 0;
+
+	for (i = 0; i < 8; i++) {
+		as_clk_tick(gpios);
+		val |= (!!gpio_get_value(gpios[ASIO_DATA].gpio) << (7 - i));
+	}
+
+	return val;
+}
+
+static int as_erase(struct gpio *gpios)
+{
+	u8 as_status;
+	int i, err = 0;
+
+	xmit_cmd(gpios, AS_WRITE_ENABLE);
+	xmit_cmd(gpios, AS_ERASE_BULK);
+
+	gpio_set_value(gpios[ASIO_NCS].gpio, 0);
+	xmit_byte(gpios, AS_READ_STATUS);
+	for (i = 0; i < AS_ERASE_TIMEOUT; i++) {
+		as_status = recv_byte(gpios);
+		if ((as_status & AS_STATUS_WIP) == 0)
+			break; /* erase done */
+		if (msleep_interruptible(1000) > 0) {
+			err = -EINTR;
+			break;
+		}
+	}
+	gpio_set_value(gpios[ASIO_NCS].gpio, 1);
+	ndelay(100);
+	if ((as_status & AS_STATUS_WIP) && err == 0)
+		err = -EIO; /* erase timeout */
+
+	return err;
+}
+
+static int altera_as_open(struct inode *inode, struct file *file)
+{
+	int ret;
+	struct altera_as_device *drvdata = get_as_dev(iminor(inode));
+
+	if (drvdata == NULL)
+		return -ENODEV;
+	file->private_data = drvdata;
+
+	ret = mutex_trylock(&drvdata->open_lock);
+	if (ret == 0)
+		return -EBUSY;
+
+	ret = gpio_request_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
+	if (ret < 0) {
+		mutex_unlock(&drvdata->open_lock);
+		return ret;
+	}
+
+	return 0;
+}
+
+static ssize_t altera_as_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	int	i, err = 0;
+	u8	*page_buf;
+	ssize_t written = 0;
+	struct altera_as_device *drvdata = file->private_data;
+
+	if (count == 0)
+		return 0;
+
+	/* writes must be page aligned */
+	if (!AS_ALIGNED(*ppos) || !AS_ALIGNED(count))
+		return -EINVAL;
+
+	page_buf = kmalloc(AS_PAGE_SIZE, GFP_KERNEL);
+	if (page_buf == NULL)
+		return -ENOMEM;
+
+	if (*ppos == 0) {
+		err = as_erase(drvdata->gpios);
+		if (err < 0)
+			goto out;
+	}
+
+	while ((count - written) > 0) {
+		err = copy_from_user(page_buf, buf+written, AS_PAGE_SIZE);
+		if (err < 0) {
+			err = -EFAULT;
+			goto out;
+		}
+
+		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
+
+		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
+		/* op code */
+		xmit_byte(drvdata->gpios, AS_PAGE_PROGRAM);
+		/* address */
+		xmit_byte(drvdata->gpios, (*ppos >> 16) & 0xff);
+		xmit_byte(drvdata->gpios, (*ppos >> 8) & 0xff);
+		xmit_byte(drvdata->gpios, *ppos & 0xff);
+		/* page data (LSB first) */
+		for (i = 0; i < AS_PAGE_SIZE; i++)
+			xmit_byte(drvdata->gpios, bitrev8(page_buf[i]));
+		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
+		mdelay(7);
+
+		*ppos += AS_PAGE_SIZE;
+		written += AS_PAGE_SIZE;
+	}
+
+out:
+	kfree(page_buf);
+	return err ?: written;
+}
+
+static int altera_as_release(struct inode *inode, struct file *file)
+{
+	struct altera_as_device *drvdata = file->private_data;
+	int i;
+
+	gpio_set_value(drvdata->gpios[ASIO_NCONFIG].gpio, 1);
+	gpio_set_value(drvdata->gpios[ASIO_NCE].gpio, 0);
+	gpio_set_value(drvdata->gpios[ASIO_DCLK].gpio, 0);
+	ndelay(500);
+
+	for (i = 0; i < ARRAY_SIZE(drvdata->gpios); i++)
+		gpio_direction_input(drvdata->gpios[i].gpio);
+	gpio_free_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
+	mutex_unlock(&drvdata->open_lock);
+
+	return 0;
+}
+
+static const struct file_operations altera_as_fops = {
+	.open		= altera_as_open,
+	.write		= altera_as_write,
+	.release	= altera_as_release,
+};
+
+static int __init altera_as_probe(struct platform_device *pdev)
+{
+	struct altera_as_device *drvdata;
+	struct altera_as_platform_data *pdata = pdev->dev.platform_data;
+
+	if (pdata->id >= AS_MAX_DEVS)
+		return -ENODEV;
+
+	if (altera_as_devs[pdata->id].drvdata)
+		return -EBUSY;
+
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	drvdata->dev = &pdev->dev;
+	platform_set_drvdata(pdev, drvdata);
+
+	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
+	drvdata->miscdev.name = kasprintf(GFP_KERNEL, "altera_as%d",
+			pdata->id);
+	if (drvdata->miscdev.name == NULL)
+		return -ENOMEM;
+	drvdata->miscdev.fops = &altera_as_fops;
+	if (misc_register(&drvdata->miscdev) < 0) {
+		kfree(drvdata->miscdev.name);
+		return -ENODEV;
+	}
+	altera_as_devs[pdata->id].minor = drvdata->miscdev.minor;
+	altera_as_devs[pdata->id].drvdata = drvdata;
+
+	mutex_init(&drvdata->open_lock);
+
+	drvdata->id = pdata->id;
+
+	drvdata->gpios[ASIO_DATA].gpio		= pdata->data;
+	drvdata->gpios[ASIO_DATA].flags		= GPIOF_IN;
+	drvdata->gpios[ASIO_DATA].label		= "as_data";
+	drvdata->gpios[ASIO_ASDI].gpio		= pdata->asdi;
+	drvdata->gpios[ASIO_ASDI].flags		= GPIOF_OUT_INIT_LOW;
+	drvdata->gpios[ASIO_ASDI].label		= "as_asdi";
+	drvdata->gpios[ASIO_NCONFIG].gpio	= pdata->nconfig;
+	drvdata->gpios[ASIO_NCONFIG].flags	= GPIOF_OUT_INIT_LOW;
+	drvdata->gpios[ASIO_NCONFIG].label	= "as_nconfig";
+	drvdata->gpios[ASIO_DCLK].gpio		= pdata->dclk;
+	drvdata->gpios[ASIO_DCLK].flags		= GPIOF_OUT_INIT_LOW;
+	drvdata->gpios[ASIO_DCLK].label		= "as_dclk";
+	drvdata->gpios[ASIO_NCS].gpio		= pdata->ncs;
+	drvdata->gpios[ASIO_NCS].flags		= GPIOF_OUT_INIT_HIGH;
+	drvdata->gpios[ASIO_NCS].label		= "as_ncs";
+	drvdata->gpios[ASIO_NCE].gpio		= pdata->nce;
+	drvdata->gpios[ASIO_NCE].flags		= GPIOF_OUT_INIT_HIGH;
+	drvdata->gpios[ASIO_NCE].label		= "as_nce";
+
+	dev_info(drvdata->dev, "Altera Cyclone Active Serial driver\n");
+
+	return 0;
+}
+
+static int __devexit altera_as_remove(struct platform_device *pdev)
+{
+	struct altera_as_device *drvdata = platform_get_drvdata(pdev);
+
+	altera_as_devs[drvdata->id].drvdata = NULL;
+	kfree(drvdata->miscdev.name);
+
+	return misc_deregister(&drvdata->miscdev);
+}
+
+static struct platform_driver altera_as_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "altera_as",
+	},
+	.remove = __devexit_p(altera_as_remove),
+};
+
+int __init altera_as_init(void)
+{
+	return platform_driver_probe(&altera_as_driver, altera_as_probe);
+}
+
+void __exit altera_as_cleanup(void)
+{
+	platform_driver_unregister(&altera_as_driver);
+}
+
+module_init(altera_as_init);
+module_exit(altera_as_cleanup);
+
+MODULE_AUTHOR("Alex Gershgorin <agersh@rambler.ru>");
+MODULE_DESCRIPTION("Altera Active Serial driver");
+MODULE_LICENSE("GPL");
diff --git a/include/platform_drivers/altera_as.h b/include/platform_drivers/altera_as.h
new file mode 100644
index 0000000..788bab5
--- /dev/null
+++ b/include/platform_drivers/altera_as.h
@@ -0,0 +1,28 @@
+/*
+ * include/platform_drivers/altera_as.h
+ *
+ * Copyright 2010 Alex Gershgorin, Orex Computed Radiography
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ */
+
+#ifndef __PLATFORM_DRIVERS_ALTERA_AS_H__
+#define __PLATFORM_DRIVERS_ALTERA_AS_H__
+
+struct altera_as_platform_data {
+	unsigned id; /* instance number */
+
+	unsigned data;
+	unsigned asdi;
+	unsigned nconfig;
+	unsigned dclk;
+	unsigned ncs;
+	unsigned nce;
+};
+
+#endif /* __PLATFORM_DRIVERS_ALTERA_AS_H__ */
-- 
1.7.2.3

