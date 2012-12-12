Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2LLLVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 06:21:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40161 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab2LLLVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 06:21:47 -0500
From: Mehar Bajwa <mehar.bajwa@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Mehar Bajwa <mehar.bajwa@ti.com>
Subject: [PATCH] Mfd: Initial support for Texas Instruments AIC family of CODECs
Date: Wed, 12 Dec 2012 16:51:40 +0530
Message-ID: <1355311300-21178-1-git-send-email-mehar.bajwa@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial support for TI's AIC platform and TLV320AIC3262 CODEC device.

The AIC platform provides common interface to series of low power audio CODECS.
This MFD core driver instantiates subdevices that help in supporting range of features
provided by AIC family of devices.

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 drivers/mfd/Kconfig                         |   41 +++
 drivers/mfd/Makefile                        |    3 +
 drivers/mfd/tlv320aic3xxx-core.c            |  462 +++++++++++++++++++++++++++
 drivers/mfd/tlv320aic3xxx-i2c.c             |   97 ++++++
 drivers/mfd/tlv320aic3xxx-irq.c             |  234 ++++++++++++++
 drivers/mfd/tlv320aic3xxx-spi.c             |   96 ++++++
 include/linux/mfd/tlv320aic3262-registers.h |  312 ++++++++++++++++++
 include/linux/mfd/tlv320aic3xxx-core.h      |  153 +++++++++
 include/linux/mfd/tlv320aic3xxx-registers.h |   75 +++++
 9 files changed, 1473 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tlv320aic3xxx-core.c
 create mode 100644 drivers/mfd/tlv320aic3xxx-i2c.c
 create mode 100644 drivers/mfd/tlv320aic3xxx-irq.c
 create mode 100644 drivers/mfd/tlv320aic3xxx-spi.c
 create mode 100644 include/linux/mfd/tlv320aic3262-registers.h
 create mode 100644 include/linux/mfd/tlv320aic3xxx-core.h
 create mode 100644 include/linux/mfd/tlv320aic3xxx-registers.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 50bbe88..2ecfbad 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -45,6 +45,47 @@ config MFD_88PM805
 	  components like codec device, headset/Mic device under the
 	  corresponding menus.
 
+config MFD_AIC3XXX
+	bool "Support for AIC3XXX"
+	select REGMAP
+	select MFD_CORE
+	help
+	  Say yes here if you want support for Texas Instruments AIC audio
+	  codec.
+	  You have to select individual I2C or SPI depending on
+	  AIC3XXX interfacing with platform.
+
+config MFD_AIC3XXX_I2C
+	bool "Support Texas Instruments AIC3XXX platform with I2C"
+	select MFD_AIC3XXX
+	select REGMAP_I2C
+	depends on I2C
+	help
+	  Support for the Texas Instruments TLV320AIC3XXX family of audio SoC
+	  core functionality controlled via I2C.  This driver provides common
+	  support for accessing the device, additional drivers must be enabled
+	  in order to use the functionality of the device.
+
+config MFD_AIC3XXX_SPI
+	bool "Support Texas Instruments AIC3XXX  platform with SPI"
+	select MFD_AIC3XXX
+	select REGMAP_SPI
+	depends on SPI_MASTER
+	help
+	  Support for the Texas Instruments TLV320AIC3XXX family of audio SoC
+	  core functionality controlled via SPI.  This driver provides common
+	  support for accessing the device, additional drivers must be enabled
+	  in order to use the functionality of the device.
+
+config MFD_AIC3262
+	bool "Support Texas Instruments AIC3262"
+	depends on MFD_AIC3XXX
+	help
+	  If you say yes here you will get support for Texas Instrument
+	  TLV320AIC3262 low power audio SoC.
+	  Addition driver must be enabled to use this in order to use
+	  functionality on device.
+
 config MFD_SM501
 	tristate "Support for Silicon Motion SM501"
 	 ---help---
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f2216df..8c97872 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -6,6 +6,9 @@
 obj-$(CONFIG_MFD_88PM860X)	+= 88pm860x.o
 obj-$(CONFIG_MFD_88PM800)	+= 88pm800.o 88pm80x.o
 obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
+obj-$(CONFIG_MFD_AIC3XXX)	+= tlv320aic3xxx-core.o tlv320aic3xxx-irq.o
+obj-$(CONFIG_MFD_AIC3XXX_I2C)	+= tlv320aic3xxx-i2c.o
+obj-$(CONFIG_MFD_AIC3XXX_SPI)	+= tlv320aic3xxx-spi.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
diff --git a/drivers/mfd/tlv320aic3xxx-core.c b/drivers/mfd/tlv320aic3xxx-core.c
new file mode 100644
index 0000000..6fd151b
--- /dev/null
+++ b/drivers/mfd/tlv320aic3xxx-core.c
@@ -0,0 +1,462 @@
+/*
+ * tlv320aic3xxx-core.c  -- driver for TLV320AIC3XXX
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *              Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/regmap.h>
+#include <linux/mfd/core.h>
+#include <linux/pm_runtime.h>
+#include <linux/regulator/consumer.h>
+#include <linux/regulator/machine.h>
+#include <linux/gpio.h>
+
+#include <linux/mfd/tlv320aic3xxx-core.h>
+#include <linux/mfd/tlv320aic3xxx-registers.h>
+
+
+/**
+ * set_aic3xxx_book: change book which we have to write/read to.
+ *
+ * @aic3xxx: Device to write/read to.
+ * @book: Book to write/read to.
+ */
+int set_aic3xxx_book(struct aic3xxx *aic3xxx, int book)
+{
+	int ret = 0;
+	u8 page_buf[] = { 0x0, 0x0 };
+	u8 book_buf[] = { 0x7f, 0x0 };
+
+	ret = regmap_write(aic3xxx->regmap, page_buf[0], page_buf[1]);
+
+	if (ret < 0)
+		return ret;
+	book_buf[1] = book;
+	ret = regmap_write(aic3xxx->regmap, book_buf[0], book_buf[1]);
+
+	if (ret < 0)
+		return ret;
+	aic3xxx->book_no = book;
+	aic3xxx->page_no = 0;
+
+	return ret;
+}
+
+/**
+ * set_aic3xxx_page: change page which we have to write/read to.
+ *
+ * @aic3xxx: Device to write/read to.
+ * @page: Book to write/read to.
+ */
+int set_aic3xxx_page(struct aic3xxx *aic3xxx, int page)
+{
+	int ret = 0;
+	u8 page_buf[] = { 0x0, 0x0 };
+
+	page_buf[1] = page;
+	ret = regmap_write(aic3xxx->regmap, page_buf[0], page_buf[1]);
+
+	if (ret < 0)
+		return ret;
+	aic3xxx->page_no = page;
+	return ret;
+}
+/**
+ * aic3xxx_reg_read: Read a single TLV320AIC3xxx register.
+ *
+ * @aic3xxx: Device to read from.
+ * @reg: Register to read.
+ */
+int aic3xxx_reg_read(struct aic3xxx *aic3xxx, unsigned int reg)
+{
+	unsigned int val;
+	int ret;
+	union aic3xxx_reg_union *aic_reg = (union aic3xxx_reg_union *) &reg;
+	u8 book, page, offset;
+
+	page = aic_reg->aic3xxx_register.page;
+	book = aic_reg->aic3xxx_register.book;
+	offset = aic_reg->aic3xxx_register.offset;
+
+	mutex_lock(&aic3xxx->io_lock);
+	if (aic3xxx->book_no != book) {
+		ret = set_aic3xxx_book(aic3xxx, book);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+
+	if (aic3xxx->page_no != page) {
+		ret = set_aic3xxx_page(aic3xxx, page);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_read(aic3xxx->regmap, offset, &val);
+	mutex_unlock(&aic3xxx->io_lock);
+
+	if (ret < 0)
+		return ret;
+	else
+		return val;
+}
+EXPORT_SYMBOL_GPL(aic3xxx_reg_read);
+
+/**
+ * aic3xxx_bulk_read: Read multiple TLV320AIC3XXX registers
+ *
+ * @aic3xxx: Device to read from
+ * @reg: First register
+ * @count: Number of registers
+ * @buf: Buffer to fill.  The data will be returned big endian.
+ */
+int aic3xxx_bulk_read(struct aic3xxx *aic3xxx, unsigned int reg,
+		      int count, u8 *buf)
+{
+	int ret;
+	union aic3xxx_reg_union *aic_reg = (union aic3xxx_reg_union *) &reg;
+	u8 book, page, offset;
+
+	page = aic_reg->aic3xxx_register.page;
+	book = aic_reg->aic3xxx_register.book;
+	offset = aic_reg->aic3xxx_register.offset;
+
+	mutex_lock(&aic3xxx->io_lock);
+	if (aic3xxx->book_no != book) {
+		ret = set_aic3xxx_book(aic3xxx, book);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+
+	if (aic3xxx->page_no != page) {
+		ret = set_aic3xxx_page(aic3xxx, page);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_bulk_read(aic3xxx->regmap, offset, buf, count);
+	mutex_unlock(&aic3xxx->io_lock);
+		return ret;
+}
+EXPORT_SYMBOL_GPL(aic3xxx_bulk_read);
+
+/**
+ * aic3xxx_reg_write: Write a single TLV320AIC3XXX register.
+ *
+ * @aic3xxx: Device to write to.
+ * @reg: Register to write to.
+ * @val: Value to write.
+ */
+int aic3xxx_reg_write(struct aic3xxx *aic3xxx, unsigned int reg,
+		      unsigned char val)
+{
+	union aic3xxx_reg_union *aic_reg = (union aic3xxx_reg_union *) &reg;
+	int ret = 0;
+	u8 page, book, offset;
+
+	page = aic_reg->aic3xxx_register.page;
+	book = aic_reg->aic3xxx_register.book;
+	offset = aic_reg->aic3xxx_register.offset;
+
+	mutex_lock(&aic3xxx->io_lock);
+	if (book != aic3xxx->book_no) {
+		ret = set_aic3xxx_book(aic3xxx, book);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+	if (page != aic3xxx->page_no) {
+		ret = set_aic3xxx_page(aic3xxx, page);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_write(aic3xxx->regmap, offset, val);
+	mutex_unlock(&aic3xxx->io_lock);
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(aic3xxx_reg_write);
+
+/**
+ * aic3xxx_bulk_write: Write multiple TLV320AIC3XXX registers
+ *
+ * @aic3xxx: Device to write to
+ * @reg: First register
+ * @count: Number of registers
+ * @buf: Buffer to write from.  Data must be big-endian formatted.
+ */
+int aic3xxx_bulk_write(struct aic3xxx *aic3xxx, unsigned int reg,
+		       int count, const u8 *buf)
+{
+	union aic3xxx_reg_union *aic_reg = (union aic3xxx_reg_union *) &reg;
+	int ret = 0;
+	u8 page, book, offset;
+
+	page = aic_reg->aic3xxx_register.page;
+	book = aic_reg->aic3xxx_register.book;
+	offset = aic_reg->aic3xxx_register.offset;
+
+	mutex_lock(&aic3xxx->io_lock);
+	if (book != aic3xxx->book_no) {
+		ret = set_aic3xxx_book(aic3xxx, book);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+	if (page != aic3xxx->page_no) {
+		ret = set_aic3xxx_page(aic3xxx, page);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_raw_write(aic3xxx->regmap, offset, buf, count);
+	mutex_unlock(&aic3xxx->io_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(aic3xxx_bulk_write);
+
+/**
+ * aic3xxx_set_bits: Set the value of a bitfield in a TLV320AIC3XXX register
+ *
+ * @aic3xxx: Device to write to.
+ * @reg: Register to write to.
+ * @mask: Mask of bits to set.
+ * @val: Value to set (unshifted)
+ */
+int aic3xxx_set_bits(struct aic3xxx *aic3xxx, unsigned int reg,
+		     unsigned char mask, unsigned char val)
+{
+	union aic3xxx_reg_union *aic_reg = (union aic3xxx_reg_union *) &reg;
+	int ret = 0;
+	u8 page, book, offset;
+
+	page = aic_reg->aic3xxx_register.page;
+	book = aic_reg->aic3xxx_register.book;
+	offset = aic_reg->aic3xxx_register.offset;
+
+	mutex_lock(&aic3xxx->io_lock);
+	if (book != aic3xxx->book_no) {
+		ret = set_aic3xxx_book(aic3xxx, book);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+	if (page != aic3xxx->page_no) {
+		ret = set_aic3xxx_page(aic3xxx, page);
+		if (ret < 0) {
+			mutex_unlock(&aic3xxx->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_update_bits(aic3xxx->regmap, offset, mask, val);
+	mutex_unlock(&aic3xxx->io_lock);
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(aic3xxx_set_bits);
+
+/**
+ * aic3xxx_wait_bits: wait for a value of a bitfield in a TLV320AIC3XXX register
+ *
+ * @aic3xxx: Device to write to.
+ * @reg: Register to write to.
+ * @mask: Mask of bits to set.
+ * @val: Value to set (unshifted)
+ * @sleep: delay value in each iteration in micro seconds
+ * @count: iteration count for timeout
+ */
+int aic3xxx_wait_bits(struct aic3xxx *aic3xxx, unsigned int reg,
+		      unsigned char mask, unsigned char val, int sleep,
+		      int counter)
+{
+	int status;
+	int timeout = sleep * counter;
+
+	status = aic3xxx_reg_read(aic3xxx, reg);
+	while (((status & mask) != val) && counter) {
+		usleep_range(sleep, sleep + 500);
+		status = aic3xxx_reg_read(aic3xxx, reg);
+		counter--;
+	};
+	if (!counter)
+		dev_err(aic3xxx->dev,
+			"wait_bits timedout (%d millisecs). lastval 0x%x\n",
+			timeout, status);
+	return counter;
+}
+EXPORT_SYMBOL_GPL(aic3xxx_wait_bits);
+
+static struct mfd_cell aic3262_devs[] = {
+	{
+	.name = "tlv320aic3262-codec",
+	},
+	{
+	.name = "tlv320aic3262-gpio",
+	},
+	{
+	.name = "tlv320aic3262-extcon",
+	}
+};
+
+
+/**
+ * Instantiate the generic non-control parts of the device.
+ */
+int aic3xxx_device_init(struct aic3xxx *aic3xxx)
+{
+	const char *devname;
+	int ret, i;
+	u8 reset = 1;
+
+	mutex_init(&aic3xxx->io_lock);
+	dev_set_drvdata(aic3xxx->dev, aic3xxx);
+
+	if (dev_get_platdata(aic3xxx->dev))
+		memcpy(&aic3xxx->pdata, dev_get_platdata(aic3xxx->dev),
+			sizeof(aic3xxx->pdata));
+
+	/* GPIO reset for TLV320AIC3xxx codec */
+	if (gpio_is_valid(aic3xxx->pdata.gpio_reset)) {
+		ret = gpio_request_one(aic3xxx->pdata.gpio_reset,
+					GPIOF_DIR_OUT | GPIOF_INIT_LOW,
+					"aic3xxx-reset-pin");
+		if (ret != 0) {
+			dev_err(aic3xxx->dev, "not able to acquire gpio\n");
+			goto err_return;
+		}
+	}
+
+	/* run the codec through software reset */
+	ret = aic3xxx_reg_write(aic3xxx, AIC3XXX_RESET, reset);
+	if (ret < 0) {
+		dev_err(aic3xxx->dev, "Could not write to AIC3XXX register\n");
+		goto err_return;
+	}
+
+	usleep_range(10000, 10500);
+
+	ret = aic3xxx_reg_read(aic3xxx, AIC3XXX_DEVICE_ID);
+	if (ret < 0) {
+		dev_err(aic3xxx->dev, "Failed to read ID register\n");
+		goto err_return;
+	}
+
+	switch (ret) {
+	case 3:
+		devname = "TLV320AIC3262";
+		if (aic3xxx->type != TLV320AIC3262)
+			dev_warn(aic3xxx->dev, "Device registered as type %d\n",
+				 aic3xxx->type);
+		aic3xxx->type = TLV320AIC3262;
+		break;
+	default:
+		dev_err(aic3xxx->dev, "Device is not a TLV320AIC3XXX");
+		ret = -EINVAL;
+		goto err_return;
+	}
+
+	dev_info(aic3xxx->dev, "%s\n", devname);
+
+	/*If naudint is gpio convert it to irq number */
+	if (aic3xxx->pdata.gpio_irq == 1) {
+		aic3xxx->irq = gpio_to_irq(aic3xxx->pdata.naudint_irq);
+		gpio_request(aic3xxx->pdata.naudint_irq, "aic3xxx-gpio-irq");
+		gpio_direction_input(aic3xxx->pdata.naudint_irq);
+	} else {
+		aic3xxx->irq = aic3xxx->pdata.naudint_irq;
+	}
+
+	for (i = 0; i < aic3xxx->pdata.num_gpios; i++) {
+		aic3xxx_reg_write(aic3xxx, aic3xxx->pdata.gpio_defaults[i].reg,
+			aic3xxx->pdata.gpio_defaults[i].value);
+	}
+
+	if (aic3xxx->irq) {
+		ret = aic3xxx_irq_init(aic3xxx);
+		if (ret < 0)
+			goto err_irq;
+	}
+	switch (aic3xxx->type) {
+	case TLV320AIC3262:
+		ret = mfd_add_devices(aic3xxx->dev, -1, aic3262_devs,
+				ARRAY_SIZE(aic3262_devs), NULL,
+				0, aic3xxx->domain);
+		break;
+	default:
+		dev_err(aic3xxx->dev, "unable to recognize codec\n");
+		break;
+	}
+	if (ret != 0) {
+		dev_err(aic3xxx->dev, "Failed to add children: %d\n", ret);
+		goto err_mfd;
+	}
+	dev_info(aic3xxx->dev, "aic3xxx_device_init added mfd devices\n");
+
+	return 0;
+
+err_mfd:
+
+	aic3xxx_irq_exit(aic3xxx);
+err_irq:
+
+	if (aic3xxx->pdata.gpio_irq)
+		gpio_free(aic3xxx->pdata.naudint_irq);
+err_return:
+
+	if (aic3xxx->pdata.gpio_reset)
+		gpio_free(aic3xxx->pdata.gpio_reset);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(aic3xxx_device_init);
+
+void aic3xxx_device_exit(struct aic3xxx *aic3xxx)
+{
+
+	mfd_remove_devices(aic3xxx->dev);
+	aic3xxx_irq_exit(aic3xxx);
+
+	if (aic3xxx->pdata.gpio_irq)
+		gpio_free(aic3xxx->pdata.naudint_irq);
+	if (aic3xxx->pdata.gpio_reset)
+		gpio_free(aic3xxx->pdata.gpio_reset);
+
+}
+EXPORT_SYMBOL_GPL(aic3xxx_device_exit);
+
+MODULE_AUTHOR("Mukund Navada <navada@ti.comm>");
+MODULE_AUTHOR("Mehar Bajwa <mehar.bajwa@ti.com>");
+MODULE_DESCRIPTION("Core support for the TLV320AIC3XXX audio CODEC");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/tlv320aic3xxx-i2c.c b/drivers/mfd/tlv320aic3xxx-i2c.c
new file mode 100644
index 0000000..cfa4822
--- /dev/null
+++ b/drivers/mfd/tlv320aic3xxx-i2c.c
@@ -0,0 +1,97 @@
+/*
+ * tlv320aic3xxx-i2c.c  -- driver for TLV320AIC3XXX
+ *
+ * Author:	Mukund Navada <navada@ti.com>
+ *		Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/tlv320aic3xxx-core.h>
+
+struct regmap_config aic3xxx_i2c_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.cache_type = REGCACHE_NONE,
+};
+
+static __devinit int aic3xxx_i2c_probe(struct i2c_client *i2c,
+					  const struct i2c_device_id *id)
+{
+	struct aic3xxx *aic3xxx;
+	const struct regmap_config *regmap_config;
+	int ret;
+
+	regmap_config = &aic3xxx_i2c_regmap;
+
+	aic3xxx = devm_kzalloc(&i2c->dev, sizeof(*aic3xxx), GFP_KERNEL);
+	if (aic3xxx == NULL)
+		return -ENOMEM;
+
+	aic3xxx->regmap = devm_regmap_init_i2c(i2c, regmap_config);
+
+	if (IS_ERR(aic3xxx->regmap)) {
+		ret = PTR_ERR(aic3xxx->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	aic3xxx->type = id->driver_data;
+	aic3xxx->dev = &i2c->dev;
+	aic3xxx->irq = i2c->irq;
+
+	return aic3xxx_device_init(aic3xxx);
+}
+
+static int __devexit aic3xxx_i2c_remove(struct i2c_client *i2c)
+{
+	struct aic3xxx *aic3xxx = dev_get_drvdata(&i2c->dev);
+
+	aic3xxx_device_exit(aic3xxx);
+	return 0;
+}
+
+static const struct i2c_device_id aic3xxx_i2c_id[] = {
+	{"tlv320aic3262", TLV320AIC3262},
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, aic3xxx_i2c_id);
+
+static struct i2c_driver aic3xxx_i2c_driver = {
+	.driver = {
+		.name	= "tlv320aic3xxx",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= aic3xxx_i2c_probe,
+	.remove		= __devexit_p(aic3xxx_i2c_remove),
+	.id_table	= aic3xxx_i2c_id,
+};
+
+module_i2c_driver(aic3xxx_i2c_driver);
+
+MODULE_DESCRIPTION("TLV320AIC3XXX I2C bus interface");
+MODULE_AUTHOR("Mukund Navada <navada@ti.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/tlv320aic3xxx-irq.c b/drivers/mfd/tlv320aic3xxx-irq.c
new file mode 100644
index 0000000..8830fba
--- /dev/null
+++ b/drivers/mfd/tlv320aic3xxx-irq.c
@@ -0,0 +1,234 @@
+/*
+ * tlv320aic3xxx-irq.c  --  Interrupt controller support for
+ *			 TI TLV320AIC3xxx family
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *              Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+
+#include <linux/mfd/tlv320aic3xxx-core.h>
+#include <linux/mfd/tlv320aic3xxx-registers.h>
+
+#include <linux/delay.h>
+
+struct aic3xxx_irq_data {
+	int mask;
+	int status;
+};
+
+static struct aic3xxx_irq_data aic3xxx_irqs[] = {
+	{
+	 .mask = AIC3XXX_HEADSET_IN_M,
+	 .status = AIC3XXX_HEADSET_PLUG_UNPLUG_INT,
+	 },
+	{
+	 .mask = AIC3XXX_BUTTON_PRESS_M,
+	 .status = AIC3XXX_BUTTON_PRESS_INT,
+	 },
+	{
+	 .mask = AIC3XXX_DAC_DRC_THRES_M,
+	 .status = AIC3XXX_LEFT_DRC_THRES_INT | AIC3XXX_RIGHT_DRC_THRES_INT,
+	 },
+	{
+	 .mask = AIC3XXX_AGC_NOISE_M,
+	 .status = AIC3XXX_LEFT_AGC_NOISE_INT | AIC3XXX_RIGHT_AGC_NOISE_INT,
+	 },
+	{
+	 .mask = AIC3XXX_OVER_CURRENT_M,
+	 .status = AIC3XXX_LEFT_OUTPUT_DRIVER_OVERCURRENT_INT
+	 | AIC3XXX_RIGHT_OUTPUT_DRIVER_OVERCURRENT_INT,
+	 },
+	{
+	 .mask = AIC3XXX_OVERFLOW_M,
+	 .status =
+	 AIC3XXX_LEFT_DAC_OVERFLOW_INT | AIC3XXX_RIGHT_DAC_OVERFLOW_INT |
+	 AIC3XXX_MINIDSP_D_BARREL_SHIFT_OVERFLOW_INT |
+	 AIC3XXX_LEFT_ADC_OVERFLOW_INT | AIC3XXX_RIGHT_ADC_OVERFLOW_INT |
+	 AIC3XXX_MINIDSP_D_BARREL_SHIFT_OVERFLOW_INT,
+	 },
+	{
+	 .mask = AIC3XXX_SPK_OVERCURRENT_M,
+	 .status = AIC3XXX_SPK_OVER_CURRENT_INT,
+	 },
+
+};
+
+static void aic3xxx_irq_lock(struct irq_data *data)
+{
+	struct aic3xxx *aic3xxx = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&aic3xxx->irq_lock);
+}
+
+static void aic3xxx_irq_sync_unlock(struct irq_data *data)
+{
+	struct aic3xxx *aic3xxx = irq_data_get_irq_chip_data(data);
+
+	/* write back to hardware any change in irq mask */
+	if (aic3xxx->irq_masks_cur != aic3xxx->irq_masks_cache) {
+		aic3xxx->irq_masks_cache = aic3xxx->irq_masks_cur;
+		aic3xxx_reg_write(aic3xxx, AIC3XXX_INT1_CNTL,
+				  aic3xxx->irq_masks_cur);
+	}
+
+	mutex_unlock(&aic3xxx->irq_lock);
+}
+
+
+static void aic3xxx_irq_enable(struct irq_data *data)
+{
+	struct aic3xxx *aic3xxx = irq_data_get_irq_chip_data(data);
+	struct aic3xxx_irq_data *irq_data = &aic3xxx_irqs[data->hwirq];
+	aic3xxx->irq_masks_cur |= irq_data->mask;
+}
+
+static void aic3xxx_irq_disable(struct irq_data *data)
+{
+	struct aic3xxx *aic3xxx = irq_data_get_irq_chip_data(data);
+	struct aic3xxx_irq_data *irq_data = &aic3xxx_irqs[data->hwirq];
+
+	aic3xxx->irq_masks_cur &= ~irq_data->mask;
+}
+
+static struct irq_chip aic3xxx_irq_chip = {
+	.name = "tlv320aic3xxx",
+	.irq_bus_lock = aic3xxx_irq_lock,
+	.irq_bus_sync_unlock = aic3xxx_irq_sync_unlock,
+	.irq_enable = aic3xxx_irq_enable,
+	.irq_disable = aic3xxx_irq_disable
+};
+
+static irqreturn_t aic3xxx_irq_thread(int irq, void *data)
+{
+	struct aic3xxx *aic3xxx = data;
+	u8 status[4];
+
+	/* Reading sticky bit registers acknowledges
+		the interrupt to the device */
+	aic3xxx_bulk_read(aic3xxx, AIC3XXX_INT_STICKY_FLAG1, 4, status);
+
+	/* report  */
+	if (status[2] & aic3xxx_irqs[AIC3XXX_IRQ_HEADSET_DETECT].status)
+		handle_nested_irq(aic3xxx->irq_base);
+	if (status[2] & aic3xxx_irqs[AIC3XXX_IRQ_BUTTON_PRESS].status)
+		handle_nested_irq(aic3xxx->irq_base + 1);
+	if (status[2] & aic3xxx_irqs[AIC3XXX_IRQ_DAC_DRC].status)
+		handle_nested_irq(aic3xxx->irq_base + 2);
+	if (status[3] & aic3xxx_irqs[AIC3XXX_IRQ_AGC_NOISE].status)
+		handle_nested_irq(aic3xxx->irq_base + 3);
+	if (status[2] & aic3xxx_irqs[AIC3XXX_IRQ_OVER_CURRENT].status)
+		handle_nested_irq(aic3xxx->irq_base + 4);
+	if (status[0] & aic3xxx_irqs[AIC3XXX_IRQ_OVERFLOW_EVENT].status)
+		handle_nested_irq(aic3xxx->irq_base + 5);
+	if (status[3] & aic3xxx_irqs[AIC3XXX_IRQ_SPEAKER_OVER_TEMP].status)
+		handle_nested_irq(aic3xxx->irq_base + 6);
+
+	return IRQ_HANDLED;
+}
+
+static int aic3xxx_irq_map(struct irq_domain *h, unsigned int virq,
+				irq_hw_number_t hw)
+{
+	struct aic3xxx *aic3xxx = h->host_data;
+
+	irq_set_chip_data(virq, aic3xxx);
+	irq_set_chip_and_handler(virq, &aic3xxx_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/* ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static const struct irq_domain_ops aic3xxx_domain_ops = {
+	.map    = aic3xxx_irq_map,
+	.xlate  = irq_domain_xlate_twocell,
+};
+
+int aic3xxx_irq_init(struct aic3xxx *aic3xxx)
+{
+	int ret;
+
+	mutex_init(&aic3xxx->irq_lock);
+
+	/* mask the individual interrupt sources */
+	aic3xxx->irq_masks_cur = 0x0;
+	aic3xxx->irq_masks_cache = 0x0;
+	aic3xxx_reg_write(aic3xxx, AIC3XXX_INT1_CNTL, 0x0);
+
+	if (!aic3xxx->irq) {
+		dev_warn(aic3xxx->dev, "no interrupt specified\n");
+		aic3xxx->irq_base = 0;
+		return 0;
+	}
+	if (aic3xxx->irq_base) {
+		aic3xxx->domain = irq_domain_add_legacy(aic3xxx->dev->of_node,
+					ARRAY_SIZE(aic3xxx_irqs),
+					aic3xxx->irq_base, 0,
+					&aic3xxx_domain_ops, aic3xxx);
+	} else {
+		aic3xxx->domain = irq_domain_add_linear(aic3xxx->dev->of_node,
+					ARRAY_SIZE(aic3xxx_irqs),
+					&aic3xxx_domain_ops, aic3xxx);
+		/* initiallizing irq_base from irq_domain*/
+	}
+	if (!aic3xxx->domain) {
+		dev_err(aic3xxx->dev, "Failed to create IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	aic3xxx->irq_base = irq_create_mapping(aic3xxx->domain, 0);
+
+	ret = request_threaded_irq(aic3xxx->irq, NULL, aic3xxx_irq_thread,
+				   IRQF_ONESHOT,
+				   "tlv320aic3xxx", aic3xxx);
+	if (ret < 0) {
+		dev_err(aic3xxx->dev, "failed to request IRQ %d: %d\n",
+			aic3xxx->irq, ret);
+		return ret;
+	}
+	irq_set_irq_type(aic3xxx->irq, IRQF_TRIGGER_RISING);
+
+	return 0;
+}
+EXPORT_SYMBOL(aic3xxx_irq_init);
+
+void aic3xxx_irq_exit(struct aic3xxx *aic3xxx)
+{
+	if (aic3xxx->irq)
+		free_irq(aic3xxx->irq, aic3xxx);
+}
+EXPORT_SYMBOL(aic3xxx_irq_exit);
+MODULE_AUTHOR("Mukund navada <navada@ti.com>");
+MODULE_AUTHOR("Mehar Bajwa <mehar.bajwa@ti.com>");
+MODULE_DESCRIPTION("Interrupt controller support for TI TLV320AIC3XXX family");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/tlv320aic3xxx-spi.c b/drivers/mfd/tlv320aic3xxx-spi.c
new file mode 100644
index 0000000..b981378
--- /dev/null
+++ b/drivers/mfd/tlv320aic3xxx-spi.c
@@ -0,0 +1,96 @@
+/*
+ * tlv320aic3xxx-spi.c  -- driver for TLV320AIC3XXX
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *		Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+
+#include <linux/mfd/tlv320aic3xxx-core.h>
+
+struct regmap_config aic3xxx_spi_regmap = {
+	.reg_bits = 7,
+	.val_bits = 8,
+	.cache_type = REGCACHE_NONE,
+	.read_flag_mask = 0x1,
+	.pad_bits = 1;
+};
+
+static int __devinit tlv320aic3xxx_spi_probe(struct spi_device *spi)
+{
+	const struct spi_device_id *id = spi_get_device_id(spi);
+	struct aic3xxx *aic3xxx;
+	const struct regmap_config *regmap_config;
+	int ret;
+
+	regmap_config = &aic3xxx_spi_regmap;
+
+	aic3xxx = devm_kzalloc(&spi->dev, sizeof(struct aic3xxx), GFP_KERNEL);
+	if (aic3xxx == NULL)
+		return -ENOMEM;
+
+	aic3xxx->regmap = devm_regmap_init_spi(spi, regmap_config);
+	if (IS_ERR(aic3xxx->regmap)) {
+		ret = PTR_ERR(aic3xxx->regmap);
+		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	aic3xxx->type = id->driver_data;
+	aic3xxx->dev = &spi->dev;
+	aic3xxx->irq = spi->irq;
+
+	return aic3xxx_device_init(aic3xxx);
+}
+
+static int __devexit tlv320aic3xxx_spi_remove(struct spi_device *spi)
+{
+	struct aic3xxx *aic3xxx = dev_get_drvdata(&spi->dev);
+	aic3xxx_device_exit(aic3xxx);
+	return 0;
+}
+
+static const struct spi_device_id aic3xxx_spi_ids[] = {
+	{"tlv320aic3262", TLV320AIC3262},
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, aic3xxx_spi_ids);
+
+static struct spi_driver aic3xxx_spi_driver = {
+	.driver = {
+		.name	= "tlv320aic3xxx",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tlv320aic3xxx_spi_probe,
+	.remove		= __devexit_p(tlv320aic3xxx_spi_remove),
+	.id_table	= aic3xxx_spi_ids,
+};
+
+module_spi_driver(tlv320aic3xxx_spi_driver);
+
+MODULE_DESCRIPTION("TLV320AIC3XXX SPI bus interface");
+MODULE_AUTHOR("Mukund Navada <navada@ti.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/tlv320aic3262-registers.h b/include/linux/mfd/tlv320aic3262-registers.h
new file mode 100644
index 0000000..0fa2e4c
--- /dev/null
+++ b/include/linux/mfd/tlv320aic3262-registers.h
@@ -0,0 +1,312 @@
+
+/*
+ *tlv320aic3262-registers: Register bits for AIC3262 codecs
+ *
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *              Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __MFD_AIC3262_REGISTERS_H__
+#define __MFD_AIC3262_REGISTERS_H__
+
+
+/* ****************** Book 0 Registers **************************************/
+
+/* ****************** Page 0 Registers **************************************/
+#define AIC3262_PAGE_SEL_REG		AIC3XXX_MAKE_REG(0, 0, 0)
+#define AIC3262_RESET_REG		AIC3XXX_MAKE_REG(0, 0, 1)
+#define AIC3262_REV_PG_ID		AIC3XXX_MAKE_REG(0, 0, 2)
+#define AIC3262_REV_MASK		(0b01110000)
+#define AIC3262_REV_SHIFT		4
+#define AIC3262_PG_MASK			(0b00000111)
+#define AIC3262_PG_SHIFT		0
+#define AIC3262_DAC_ADC_CLKIN_REG	AIC3XXX_MAKE_REG(0, 0, 4)
+#define AIC3262_PLL_CLKIN_REG		AIC3XXX_MAKE_REG(0, 0, 5)
+#define AIC3262_PLL_CLKIN_MASK		(0b00111100)
+#define AIC3262_PLL_CLKIN_SHIFT		2
+#define AIC3262_PLL_CLKIN_MCLK1		0
+#define AIC3262_PLL_CLKIN_BCLK1		1
+#define AIC3262_PLL_CLKIN_GPIO1		2
+#define AIC3262_PLL_CLKIN_DIN1		3
+#define AIC3262_PLL_CLKIN_BCLK2		4
+#define AIC3262_PLL_CLKIN_GPI1		5
+#define AIC3262_PLL_CLKIN_HF_REF_CLK	6
+#define AIC3262_PLL_CLKIN_GPIO2		7
+#define AIC3262_PLL_CLKIN_GPI2		8
+#define AIC3262_PLL_CLKIN_MCLK2		9
+#define AIC3262_CLK_VAL_MASK		0x7f
+#define AIC3262_PLL_CLK_RANGE_REG	AIC3XXX_MAKE_REG(0, 0, 5)
+#define AIC3262_PLL_PR_POW_REG		AIC3XXX_MAKE_REG(0, 0, 6)
+#define AIC3262_PLL_PVAL_MASK		0x70
+#define AIC3262_PLL_RVAL_MASK		0x0F
+
+#define AIC3262_ENABLE_CLK_MASK		0x80
+#define AIC3262_ENABLE_CLK		0x80
+
+#define AIC3262_PLL_J_REG		AIC3XXX_MAKE_REG(0, 0, 7)
+#define AIC3262_JVAL_MASK		0x3f
+#define AIC3262_PLL_D_MSB		AIC3XXX_MAKE_REG(0, 0, 8)
+#define AIC3262_DVAL_MSB_MASK		0xf
+#define AIC3262_DVAL_LSB_MASK		0xff
+#define AIC3262_PLL_D_LSB		AIC3XXX_MAKE_REG(0, 0, 9)
+#define AIC3262_PLL_CKIN_DIV		AIC3XXX_MAKE_REG(0, 0, 10)
+
+#define AIC3262_NDAC_DIV_POW_REG	AIC3XXX_MAKE_REG(0, 0, 11)
+#define AIC3262_MDAC_DIV_POW_REG	AIC3XXX_MAKE_REG(0, 0, 12)
+#define AIC3262_DOSR_MSB_REG		AIC3XXX_MAKE_REG(0, 0, 13)
+#define AIC3262_DOSR_MSB_MASK		0x3
+#define AIC3262_DOSR_LSB_REG		AIC3XXX_MAKE_REG(0, 0, 14)
+#define AIC3262_DOSR_LSB_MASK		0xFF
+
+#define AIC3262_NADC_DIV_POW_REG	AIC3XXX_MAKE_REG(0, 0, 18)
+#define AIC3262_MADC_DIV_POW_REG	AIC3XXX_MAKE_REG(0, 0, 19)
+#define AIC3262_AOSR_REG		AIC3XXX_MAKE_REG(0, 0, 20)
+#define AIC3262_CLKOUT_MUX		AIC3XXX_MAKE_REG(0, 0, 21)
+#define AIC3262_CLKOUT_MDIV_VAL		AIC3XXX_MAKE_REG(0, 0, 22)
+#define AIC3262_TIMER_REG		AIC3XXX_MAKE_REG(0, 0, 23)
+
+#define AIC3262_LF_CLK_CNTL		AIC3XXX_MAKE_REG(0, 0, 24)
+#define AIC3262_HF_CLK_CNTL_R1		AIC3XXX_MAKE_REG(0, 0, 25)
+#define AIC3262_HF_CLK_CNTL_R2		AIC3XXX_MAKE_REG(0, 0, 26)
+#define AIC3262_HF_CLK_CNTL_R3		AIC3XXX_MAKE_REG(0, 0, 27)
+#define AIC3262_HF_CLK_CNTL_R4		AIC3XXX_MAKE_REG(0, 0, 28)
+#define AIC3262_HF_CLK_TRIM_R1		AIC3XXX_MAKE_REG(0, 0, 29)
+#define AIC3262_HF_CLK_TRIM_R2		AIC3XXX_MAKE_REG(0, 0, 30)
+#define AIC3262_HF_CLK_TRIM_R3		AIC3XXX_MAKE_REG(0, 0, 31)
+#define AIC3262_HF_CLK_TRIM_R4		AIC3XXX_MAKE_REG(0, 0, 32)
+#define AIC3262_LDAC_POWER_STATUS_MASK		0x80
+#define AIC3262_RDAC_POWER_STATUS_MASK		0x08
+#define AIC3262_DAC_POWER_MASK		0x88
+#define AIC3262_DAC_FLAG		AIC3XXX_MAKE_REG(0, 0, 37)
+#define AIC3262_LADC_POWER_MASK		0x40
+#define AIC3262_RADC_POWER_MASK		0x04
+#define AIC3262_ADC_POWER_MASK		0x44
+#define AIC3262_ADC_FLAG                AIC3XXX_MAKE_REG(0, 0, 36)
+#define AIC3262_JACK_WITH_STEREO_HS	(0b00000010)
+#define AIC3262_JACK_WITH_MIC		(0b00110000)
+#define AIC3262_HEADSET_NOT_INSERTED	(0b00000011)
+#define AIC3262_JACK_TYPE_MASK		(0b00110000)
+#define AIC3262_JACK_NOT_INSERTED	(0b00000000)
+#define AIC3262_JACK_WITHOUT_MIC	(0b00010000)
+
+#define AIC3262_RIGHT_DRC_AUX_INT			0x01
+#define AIC3262_INT1_CNTL		AIC3XXX_MAKE_REG(0, 0, 48)
+
+#define AIC3262_DAC_PRB			AIC3XXX_MAKE_REG(0, 0, 60)
+#define AIC3262_ADC_PRB			AIC3XXX_MAKE_REG(0, 0, 61)
+#define AIC3262_PASI_DAC_DP_SETUP	AIC3XXX_MAKE_REG(0, 0, 63)
+
+#define AIC3262_DAC_MVOL_CONF		AIC3XXX_MAKE_REG(0, 0, 64)
+#define AIC3262_DAC_LR_MUTE_MASK	0xc
+#define AIC3262_DAC_LR_MUTE		0xc
+
+#define AIC3262_DAC_LVOL		AIC3XXX_MAKE_REG(0, 0, 65)
+#define AIC3262_DAC_RVOL		AIC3XXX_MAKE_REG(0, 0, 66)
+#define AIC3262_HP_DETECT		AIC3XXX_MAKE_REG(0, 0, 67)
+#define AIC3262_DRC_CNTL_R1		AIC3XXX_MAKE_REG(0, 0, 68)
+#define AIC3262_DRC_CNTL_R2		AIC3XXX_MAKE_REG(0, 0, 69)
+#define AIC3262_DRC_CNTL_R3		AIC3XXX_MAKE_REG(0, 0, 70)
+#define AIC3262_BEEP_CNTL_R1		AIC3XXX_MAKE_REG(0, 0, 71)
+#define AIC3262_BEEP_CNTL_R2		AIC3XXX_MAKE_REG(0, 0, 72)
+
+#define AIC3262_ADC_CHANNEL_POW		AIC3XXX_MAKE_REG(0, 0, 81)
+#define AIC3262_ADC_FINE_GAIN		AIC3XXX_MAKE_REG(0, 0, 82)
+#define AIC3262_LADC_VOL		AIC3XXX_MAKE_REG(0, 0, 83)
+#define AIC3262_RADC_VOL		AIC3XXX_MAKE_REG(0, 0, 84)
+#define AIC3262_ADC_PHASE		AIC3XXX_MAKE_REG(0, 0, 85)
+
+#define AIC3262_LAGC_CNTL		AIC3XXX_MAKE_REG(0, 0, 86)
+#define AIC3262_LAGC_CNTL_R2		AIC3XXX_MAKE_REG(0, 0, 87)
+#define AIC3262_LAGC_CNTL_R3		AIC3XXX_MAKE_REG(0, 0, 88)
+#define AIC3262_LAGC_CNTL_R4		AIC3XXX_MAKE_REG(0, 0, 89)
+#define AIC3262_LAGC_CNTL_R5		AIC3XXX_MAKE_REG(0, 0, 90)
+#define AIC3262_LAGC_CNTL_R6		AIC3XXX_MAKE_REG(0, 0, 91)
+#define AIC3262_LAGC_CNTL_R7		AIC3XXX_MAKE_REG(0, 0, 92)
+#define AIC3262_LAGC_CNTL_R8		AIC3XXX_MAKE_REG(0, 0, 93)
+
+#define AIC3262_RAGC_CNTL		AIC3XXX_MAKE_REG(0, 0, 94)
+#define AIC3262_RAGC_CNTL_R2		AIC3XXX_MAKE_REG(0, 0, 95)
+#define AIC3262_RAGC_CNTL_R3		AIC3XXX_MAKE_REG(0, 0, 96)
+#define AIC3262_RAGC_CNTL_R4		AIC3XXX_MAKE_REG(0, 0, 97)
+#define AIC3262_RAGC_CNTL_R5		AIC3XXX_MAKE_REG(0, 0, 98)
+#define AIC3262_RAGC_CNTL_R6		AIC3XXX_MAKE_REG(0, 0, 99)
+#define AIC3262_RAGC_CNTL_R7		AIC3XXX_MAKE_REG(0, 0, 100)
+#define AIC3262_RAGC_CNTL_R8		AIC3XXX_MAKE_REG(0, 0, 101)
+#define AIC3262_MINIDSP_ACCESS_CTRL	AIC3XXX_MAKE_REG(0, 0, 121)
+/* ****************** Page 1 Registers **************************************/
+#define AIC3262_PAGE_1			128
+
+#define AIC3262_POWER_CONF		AIC3XXX_MAKE_REG(0, 1, 1)
+
+#define AIC3262_AVDD_TO_DVDD_MASK	(0b00001000)
+#define	AIC3262_AVDD_TO_DVDD		0x8
+#define AIC3262_EXT_ANALOG_SUPPLY_MASK	(0b00000100)
+#define	AIC3262_EXT_ANALOG_SUPPLY_OFF	0x4
+
+#define AIC3262_LDAC_PTM		AIC3XXX_MAKE_REG(0, 1, 3)
+#define AIC3262_RDAC_PTM		AIC3XXX_MAKE_REG(0, 1, 4)
+#define AIC3262_CM_REG			AIC3XXX_MAKE_REG(0, 1, 8)
+#define AIC3262_HP_CTL			AIC3XXX_MAKE_REG(0, 1, 9)
+#define AIC3262_HP_DEPOP		AIC3XXX_MAKE_REG(0, 1, 11)
+#define AIC3262_RECV_DEPOP		AIC3XXX_MAKE_REG(0, 1, 12)
+#define AIC3262_MA_CNTL			AIC3XXX_MAKE_REG(0, 1, 17)
+#define AIC3262_LADC_PGA_MAL_VOL	AIC3XXX_MAKE_REG(0, 1, 18)
+#define AIC3262_RADC_PGA_MAR_VOL	AIC3XXX_MAKE_REG(0, 1, 19)
+
+#define AIC3262_LINE_AMP_CNTL_R1	AIC3XXX_MAKE_REG(0, 1, 22)
+#define AIC3262_LINE_AMP_CNTL_R2	AIC3XXX_MAKE_REG(0, 1, 23)
+
+#define AIC3262_HP_AMP_CNTL_R1		AIC3XXX_MAKE_REG(0, 1, 27)
+#define AIC3262_HP_AMP_CNTL_R2		AIC3XXX_MAKE_REG(0, 1, 28)
+#define AIC3262_HP_AMP_CNTL_R3		AIC3XXX_MAKE_REG(0, 1, 29)
+
+#define AIC3262_HPL_VOL			AIC3XXX_MAKE_REG(0, 1, 31)
+#define AIC3262_HPR_VOL			AIC3XXX_MAKE_REG(0, 1, 32)
+#define AIC3262_INT1_SEL_L		AIC3XXX_MAKE_REG(0, 1, 34)
+#define AIC3262_CHARGE_PUMP_CNTL	AIC3XXX_MAKE_REG(0, 1, 35)
+#define AIC3262_RAMP_CNTL_R1		AIC3XXX_MAKE_REG(0, 1, 36)
+#define AIC3262_RAMP_CNTL_R2		AIC3XXX_MAKE_REG(0, 1, 37)
+#define AIC3262_IN1L_SEL_RM		AIC3XXX_MAKE_REG(0, 1, 38)
+#define AIC3262_IN1R_SEL_RM		AIC3XXX_MAKE_REG(0, 1, 39)
+#define AIC3262_REC_AMP_CNTL_R5		AIC3XXX_MAKE_REG(0, 1, 40)
+#define AIC3262_RAMPR_VOL		AIC3XXX_MAKE_REG(0, 1, 41)
+#define AIC3262_RAMP_TIME_CNTL		AIC3XXX_MAKE_REG(0, 1, 42)
+#define AIC3262_SPK_AMP_CNTL_R1		AIC3XXX_MAKE_REG(0, 1, 45)
+#define AIC3262_SPK_AMP_CNTL_R2		AIC3XXX_MAKE_REG(0, 1, 46)
+#define AIC3262_SPK_AMP_CNTL_R3		AIC3XXX_MAKE_REG(0, 1, 47)
+#define AIC3262_SPK_AMP_CNTL_R4		AIC3XXX_MAKE_REG(0, 1, 48)
+#define AIC3262_MIC_BIAS_CNTL		AIC3XXX_MAKE_REG(0, 1, 51)
+
+#define AIC3262_LMIC_PGA_PIN		AIC3XXX_MAKE_REG(0, 1, 52)
+#define AIC3262_LMIC_PGA_PM_IN4		AIC3XXX_MAKE_REG(0, 1, 53)
+#define AIC3262_LMIC_PGA_MIN		AIC3XXX_MAKE_REG(0, 1, 54)
+#define AIC3262_RMIC_PGA_PIN		AIC3XXX_MAKE_REG(0, 1, 55)
+#define AIC3262_RMIC_PGA_PM_IN4		AIC3XXX_MAKE_REG(0, 1, 56)
+#define AIC3262_RMIC_PGA_MIN		AIC3XXX_MAKE_REG(0, 1, 57)
+#define AIC3262_HP_FLAG		        AIC3XXX_MAKE_REG(0, 1, 66)
+#define AIC3262_SPKL_POWER_MASK		0x2
+#define AIC3262_SPKR_POWER_MASK		0x1
+#define AIC3262_HPL_POWER_MASK		(0b00000010)
+#define AIC3262_HPR_POWER_MASK		(0b00000001)
+#define AIC3262_SPKL_POWER_STATUS_MASK		0x2
+#define AIC3262_SPKR_POWER_STATUS_MASK		0x1
+#define AIC3262_HPL_POWER_STATUS_MASK		0x20
+#define AIC3262_HPR_POWER_STATUS_MASK		0x10
+
+#define AIC3262_HP_STAGE_MASK		(0b01100000)
+#define AIC3262_HP_STAGE_100		(0)
+#define AIC3262_HP_STAGE_75		(1)
+#define AIC3262_HP_STAGE_50		(2)
+#define AIC3262_HP_STAGE_25		(3)
+#define AIC3262_HP_STAGE_SHIFT		(5)
+#define AIC3262_DYNAMIC_OFFSET_CALIB_MASK	(0b00100000)
+#define AIC3262_DYNAMIC_OFFSET_CALIB		(0b00100000)
+
+/* MIC PGA Gain Registers */
+#define AIC3262_MICL_PGA		AIC3XXX_MAKE_REG(0, 1, 59)
+#define AIC3262_MICR_PGA		AIC3XXX_MAKE_REG(0, 1, 60)
+#define AIC3262_HEADSET_TUNING1_REG	AIC3XXX_MAKE_REG(0, 1, 119)
+#define AIC3262_HEADSET_DETECTOR_PULSE_MASK (0b11000000)
+#define AIC3262_HEADSET_DETECTOR_PULSE_RESET (0b10000000)
+#define AIC3262_MIC_PWR_DLY		AIC3XXX_MAKE_REG(0, 1, 121)
+#define AIC3262_REF_PWR_DLY		AIC3XXX_MAKE_REG(0, 1, 122)
+#define AIC3262_CHIP_REF_PWR_ON_MASK	0x4
+#define AIC3262_CHIP_REF_PWR_ON		0x4
+/* ****************** Page 4 Registers **************************************/
+#define AIC3262_PAGE_4			512
+#define AIC3262_ASI1_BUS_FMT		AIC3XXX_MAKE_REG(0, 4, 1)
+#define AIC3262_ASI_SELECTION_MASK	(0b11100000)
+#define AIC3262_ASI_DATA_WORD_LENGTH_MASK	(0b00011000)
+#define AIC3262_ASI1_BCLK_N_MASK	(0b01111111)
+#define AIC3262_ASI1_WCLK_N_MASK	(0b01111111)
+#define AIC3262_ASI1_CHNL_MASK		(0b11000000)
+#define AIC3262_ASI1_DAC_OUT_OFFSET	(0b00000001)
+#define AIC3262_ASI1_LCH_OFFSET		AIC3XXX_MAKE_REG(0, 4, 2)
+#define AIC3262_ASI1_RCH_OFFSET		AIC3XXX_MAKE_REG(0, 4, 3)
+#define AIC3262_ASI1_CHNL_SETUP		AIC3XXX_MAKE_REG(0, 4, 4)
+#define AIC3262_ASI1_MULTI_CH_SETUP_R1	AIC3XXX_MAKE_REG(0, 4, 5)
+#define AIC3262_ASI1_MULTI_CH_SETUP_R2	AIC3XXX_MAKE_REG(0, 4, 6)
+#define AIC3262_ASI1_ADC_INPUT_CNTL	AIC3XXX_MAKE_REG(0, 4, 7)
+#define AIC3262_ASI1_DAC_OUT_CNTL	AIC3XXX_MAKE_REG(0, 4, 8)
+#define AIC3262_ASI1_ADC_OUT_TRISTATE	AIC3XXX_MAKE_REG(0, 4, 9)
+#define AIC3262_ASI1_BWCLK_CNTL_REG	AIC3XXX_MAKE_REG(0, 4, 10)
+#define AIC3262_ASI1_BCLK_N_CNTL	AIC3XXX_MAKE_REG(0, 4, 11)
+#define AIC3262_ASI1_BCLK_N		AIC3XXX_MAKE_REG(0, 4, 12)
+#define AIC3262_ASI1_WCLK_N		AIC3XXX_MAKE_REG(0, 4, 13)
+#define AIC3262_ASI1_BWCLK_OUT_CNTL	AIC3XXX_MAKE_REG(0, 4, 14)
+#define AIC3262_ASI1_DOUT_CNTL		AIC3XXX_MAKE_REG(0, 4, 15)
+#define AIC3262_ASI2_BUS_FMT	        AIC3XXX_MAKE_REG(0, 4, 17)
+#define AIC3262_ASI2_LCH_OFFSET		AIC3XXX_MAKE_REG(0, 4, 18)
+#define AIC3262_ASI2_ADC_INPUT_CNTL	AIC3XXX_MAKE_REG(0, 4, 23)
+#define AIC3262_ASI2_DAC_OUT_CNTL	AIC3XXX_MAKE_REG(0, 4, 24)
+#define AIC3262_ASI2_BWCLK_CNTL_REG	AIC3XXX_MAKE_REG(0, 4, 26)
+#define AIC3262_ASI2_BCLK_N_CNTL	AIC3XXX_MAKE_REG(0, 4, 27)
+#define AIC3262_ASI2_BCLK_N		AIC3XXX_MAKE_REG(0, 4, 28)
+#define AIC3262_ASI2_WCLK_N		AIC3XXX_MAKE_REG(0, 4, 29)
+#define AIC3262_ASI2_BWCLK_OUT_CNTL	AIC3XXX_MAKE_REG(0, 4, 30)
+#define AIC3262_ASI2_DOUT_CNTL		AIC3XXX_MAKE_REG(0, 4, 31)
+#define AIC3262_ASI3_BUS_FMT		AIC3XXX_MAKE_REG(0, 4, 33)
+#define AIC3262_ASI3_LCH_OFFSET		AIC3XXX_MAKE_REG(0, 4, 34)
+#define AIC3262_ASI3_ADC_INPUT_CNTL	AIC3XXX_MAKE_REG(0, 4, 39)
+#define AIC3262_ASI3_DAC_OUT_CNTL	AIC3XXX_MAKE_REG(0, 4, 40)
+#define AIC3262_ASI3_BWCLK_CNTL_REG	AIC3XXX_MAKE_REG(0, 4, 42)
+#define AIC3262_ASI3_BCLK_N_CNTL	AIC3XXX_MAKE_REG(0, 4, 43)
+#define AIC3262_ASI3_BCLK_N		AIC3XXX_MAKE_REG(0, 4, 44)
+#define AIC3262_ASI3_WCLK_N		AIC3XXX_MAKE_REG(0, 4, 45)
+#define AIC3262_ASI3_BWCLK_OUT_CNTL	AIC3XXX_MAKE_REG(0, 4, 46)
+#define AIC3262_ASI3_DOUT_CNTL		AIC3XXX_MAKE_REG(0, 4, 47)
+#define AIC3262_DMIC_INPUT_CNTL		AIC3XXX_MAKE_REG(0, 4, 101)
+#define AIC3262_GPIO1_IO_CNTL		AIC3XXX_MAKE_REG(0, 4, 86)
+#define AIC3262_GPIO_D6_D2		(0b01111100)
+#define AIC3262_GPIO_D2_SHIFT		(2)
+#define AIC3262_GPIO_D1_SHIFT		(1)
+#define AIC3262_GPIO_D4_SHIFT		(4)
+#define AIC3262_GPIO2_IO_CNTL		AIC3XXX_MAKE_REG(0, 4, 87)
+#define AIC3262_GPI1_EN			AIC3XXX_MAKE_REG(0, 4, 91)
+#define AIC3262_GPI1_D2_D1		(0b00000110)
+#define AIC3262_GPI2_D5_D4		(0b00110000)
+#define AIC3262_GPI2_EN			AIC3XXX_MAKE_REG(0, 4, 92)
+#define AIC3262_GPO1_OUT_CNTL		AIC3XXX_MAKE_REG(0, 4, 96)
+#define AIC3262_GPO1_D4_D1		(0b00011110)
+#define AIC3262_DMIC_INPUT_CONTROL	AIC3XXX_MAKE_REG(0, 4, 101)
+#define AIC3262_DMIC_CONFIGURE_MASK	(0b00011111)
+#define AIC3262_DMIC_CONFIGURE_SHIFT	(0)
+#define AIC3262_DMIC_GPI2_LEFT_GPI2_RIGHT	(1)
+#define AIC3262_MINIDSP_DATA_PORT_CNTL	AIC3XXX_MAKE_REG(0, 4, 118)
+
+#define AIC3262_DAC_ASI_LR_UNMUTE_MASK	0x50
+#define AIC3262_DAC_ASI_LR_UNMUTE	0x50
+#define AIC3262_WCLK_BCLK_MASTER_MASK (0b00100110)
+#define AIC3262_WCLK_MASTER_MASK (0b00100000)
+#define AIC3262_BCLK_MASTER_MASK (0b00000100)
+#define AIC3262_ASI_WCLK_MASTER_MASK (0b10000000)
+#define AIC3262_ASI_BCLK_MASTER_MASK (0b10000000)
+#define AIC3262_BCLK_OFFSET_MASK (0b11111111)
+#define AIC3262_ASI_INTERFACE_MASK (0b11100000)
+#define AIC3262_WCLK_OUT_MASK (0b00100000)
+#define AIC3262_BCLK_OUT_MASK (0b00000100)
+#define AIC3262_BCLK_INV_MASK (0b00000010)
+
+#define AIC3262_ADC_ADAPTIVE_CRAM_REG    AIC3XXX_MAKE_REG(40, 0, 1)
+#define AIC3262_DAC_ADAPTIVE_BANK1_REG   AIC3XXX_MAKE_REG(80, 0, 1)
+#define AIC3262_DAC_ADAPTIVE_BANK2_REG   AIC3XXX_MAKE_REG(82, 0, 1)
+#define AIC3262_ADC_DATAPATH_SETUP      AIC3XXX_MAKE_REG(0, 0, 81)
+#define AIC3262_DAC_DATAPATH_SETUP      AIC3XXX_MAKE_REG(0, 0, 63)
+
+#endif
diff --git a/include/linux/mfd/tlv320aic3xxx-core.h b/include/linux/mfd/tlv320aic3xxx-core.h
new file mode 100644
index 0000000..d2f1d97
--- /dev/null
+++ b/include/linux/mfd/tlv320aic3xxx-core.h
@@ -0,0 +1,153 @@
+/*
+ * MFD driver for aic3262
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *              Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __MFD_AIC3XXX_CORE_H__
+#define __MFD_AIC3XXX_CORE_H__
+
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/irqdomain.h>
+
+enum aic3xxx_type {
+	TLV320AIC3262 = 0,
+};
+
+#define AIC3XXX_IRQ_HEADSET_DETECT	0
+#define AIC3XXX_IRQ_BUTTON_PRESS	1
+#define AIC3XXX_IRQ_DAC_DRC		2
+#define AIC3XXX_IRQ_AGC_NOISE		3
+#define AIC3XXX_IRQ_OVER_CURRENT	4
+#define AIC3XXX_IRQ_OVERFLOW_EVENT	5
+#define AIC3XXX_IRQ_SPEAKER_OVER_TEMP	6
+
+
+union aic3xxx_reg_union {
+	struct aic3xxx_reg {
+		u8 offset;
+		u8 page;
+		u8 book;
+		u8 reserved;
+	} aic3xxx_register;
+	unsigned int aic3xxx_register_int;
+};
+
+/****************************             ************************************/
+
+struct aic3xxx_gpio_setup {
+	unsigned int reg;
+	u8 value;
+};
+
+/**
+ * Platform data for aic3xxx family device.
+ *
+ * @audio_mclk1: MCLK1 frequency in Hz
+ * @audio_mclk2: MCLK2 frequency in Hz
+ * @gpio_irq: whether AIC3262 interrupts the host AP on a GPIO pin
+ *		of AP
+ * @gpio_reset: is the codec being reset by a gpio [host] pin,
+ *		if yes provide the number.
+ * @num_gpios: number of gpio pins on this device
+ * @gpio_defaults: all gpio configuration
+ * @naudint_irq: audio interrupt number
+ * @irq_base: base of chained interrupt handler
+ */
+struct aic3xxx_pdata {
+	unsigned int audio_mclk1;
+	unsigned int audio_mclk2;
+	unsigned int gpio_irq;	/* whether AIC3262 interrupts the host AP on */
+				/* a GPIO pin of AP */
+	unsigned int gpio_reset;/* is the codec being reset by a gpio*/
+				/* [host] pin, if yes provide the number. */
+	int num_gpios;
+	/* all gpio configuration */
+	struct aic3xxx_gpio_setup *gpio_defaults;
+	int naudint_irq;	/* audio interrupt */
+	unsigned int irq_base;
+};
+
+struct aic3xxx {
+	struct mutex io_lock;
+	struct mutex irq_lock;
+	enum aic3xxx_type type;
+	struct device *dev;
+	struct regmap *regmap;
+	struct aic3xxx_pdata pdata;
+	void *control_data;
+	unsigned int irq;
+	unsigned int irq_base;
+	struct irq_domain *domain;
+	u8 irq_masks_cur;
+	u8 irq_masks_cache;
+	/* Used over suspend/resume */
+	bool suspended;
+	u8 book_no;
+	u8 page_no;
+};
+
+
+
+static inline int aic3xxx_request_irq(struct aic3xxx *aic3xxx, int irq,
+				      irq_handler_t handler,
+				      unsigned long irqflags, const char *name,
+				      void *data)
+{
+	irq = irq_create_mapping(aic3xxx->domain, irq);
+	if (irq < 0) {
+		dev_err(aic3xxx->dev,
+			"Mapping hardware interrupt failed %d\n", irq);
+		return irq;
+	}
+
+	return request_threaded_irq(irq, NULL, handler,
+				    irqflags, name, data);
+}
+
+static inline int aic3xxx_free_irq(struct aic3xxx *aic3xxx, int irq, void *data)
+{
+	if (!aic3xxx->irq_base)
+		return -EINVAL;
+
+	free_irq(aic3xxx->irq_base + irq, data);
+	return 0;
+}
+
+/* Device I/O API */
+int aic3xxx_reg_read(struct aic3xxx *aic3xxx, unsigned int reg);
+int aic3xxx_reg_write(struct aic3xxx *aic3xxx, unsigned int reg,
+		      unsigned char val);
+int aic3xxx_set_bits(struct aic3xxx *aic3xxx, unsigned int reg,
+		     unsigned char mask, unsigned char val);
+int aic3xxx_bulk_read(struct aic3xxx *aic3xxx, unsigned int reg,
+		      int count, u8 *buf);
+int aic3xxx_bulk_write(struct aic3xxx *aic3xxx, unsigned int reg,
+		       int count, const u8 *buf);
+int aic3xxx_wait_bits(struct aic3xxx *aic3xxx, unsigned int reg,
+		      unsigned char mask, unsigned char val, int delay,
+		      int counter);
+
+int aic3xxx_irq_init(struct aic3xxx *aic3xxx);
+void aic3xxx_irq_exit(struct aic3xxx *aic3xxx);
+int aic3xxx_device_init(struct aic3xxx *aic3xxx);
+void aic3xxx_device_exit(struct aic3xxx *aic3xxx);
+
+#endif /* End of __MFD_AIC3XXX_CORE_H__ */
diff --git a/include/linux/mfd/tlv320aic3xxx-registers.h b/include/linux/mfd/tlv320aic3xxx-registers.h
new file mode 100644
index 0000000..6fbcd7e
--- /dev/null
+++ b/include/linux/mfd/tlv320aic3xxx-registers.h
@@ -0,0 +1,75 @@
+
+/*
+ *tlv320aic3xxx-registers: Register bits for AIC3XXX codecs
+ *
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *              Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __MFD_AIC3XXX_REGISTERS_H__
+#define __MFD_AIC3XXX_REGISTERS_H__
+#define AIC3XXX_MAKE_REG(book, page, offset)	(unsigned int)((book << 16) | \
+							(page << 8) | \
+							offset)
+
+#define AIC3XXX_RESET		AIC3XXX_MAKE_REG(0, 0, 1)
+#define AIC3XXX_REV_PG_ID		AIC3XXX_MAKE_REG(0, 0, 2)
+#define AIC3XXX_REV_M		(0b01110000)
+#define AIC3XXX_REV_S		4
+#define AIC3XXX_PG_M			(0b00000111)
+#define AIC3XXX_PG_S		0
+
+#define AIC3XXX_INT_STICKY_FLAG1		AIC3XXX_MAKE_REG(0, 0, 42)
+#define AIC3XXX_LEFT_DAC_OVERFLOW_INT	0x80
+#define AIC3XXX_RIGHT_DAC_OVERFLOW_INT	0x40
+#define AIC3XXX_MINIDSP_D_BARREL_SHIFT_OVERFLOW_INT	0x20
+#define AIC3XXX_LEFT_ADC_OVERFLOW_INT	0x08
+#define AIC3XXX_RIGHT_ADC_OVERFLOW_INT	0x04
+#define AIC3XXX_MINIDSP_A_BARREL_SHIFT_OVERFLOW_INT	0x02
+#define AIC3XXX_INT_STICKY_FLAG2		AIC3XXX_MAKE_REG(0, 0, 44)
+#define AIC3XXX_LEFT_OUTPUT_DRIVER_OVERCURRENT_INT	0x80
+#define AIC3XXX_RIGHT_OUTPUT_DRIVER_OVERCURRENT_INT	0x40
+#define AIC3XXX_BUTTON_PRESS_INT			0x20
+#define AIC3XXX_HEADSET_PLUG_UNPLUG_INT			0x10
+#define AIC3XXX_LEFT_DRC_THRES_INT			0x08
+#define AIC3XXX_RIGHT_DRC_THRES_INT			0x04
+#define AIC3XXX_MINIDSP_D_STD_INT			0x02
+#define AIC3XXX_MINIDSP_D_AUX_INT			0x01
+#define AIC3XXX_INT_STICKY_FLAG3		AIC3XXX_MAKE_REG(0, 0, 45)
+#define AIC3XXX_SPK_OVER_CURRENT_INT			0x80
+#define AIC3XXX_LEFT_AGC_NOISE_INT			0x40
+#define AIC3XXX_RIGHT_AGC_NOISE_INT			0x20
+#define AIC3XXX_MINIDSP_A_STD_INT			0x10
+#define AIC3XXX_MINIDSP_A_AUX_INT			0x08
+#define AIC3XXX_LEFT_ADC_DC_DATA_AVAILABLE_INT		0x04
+#define AIC3XXX_RIGHT_ADC_DC_DATA_AVAILABLE_INT		0x02
+#define AIC3XXX_CP_SHORT_CIRCUIT_INT			0x01
+#define AIC3XXX_INT1_CNTL		AIC3XXX_MAKE_REG(0, 0, 48)
+#define AIC3XXX_HEADSET_IN_M		0x80
+#define AIC3XXX_BUTTON_PRESS_M	0x40
+#define AIC3XXX_DAC_DRC_THRES_M	0x20
+#define AIC3XXX_AGC_NOISE_M		0x10
+#define AIC3XXX_OVER_CURRENT_M	0x08
+#define AIC3XXX_OVERFLOW_M		0x04
+#define AIC3XXX_SPK_OVERCURRENT_M	0x02
+#define AIC3XXX_CP_SHORT_CIRCUIT_M	0x02
+#define AIC3XXX_INT2_CNTL		AIC3XXX_MAKE_REG(0, 0, 49)
+#define AIC3XXX_INT_FMT			AIC3XXX_MAKE_REG(0, 0, 51)
+#define AIC3XXX_DEVICE_ID		AIC3XXX_MAKE_REG(0, 0, 125)
+#endif
-- 
1.7.0.4

