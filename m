Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2DPNRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:17:15 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:52202 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753534Ab2DPNRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:17:12 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, arnd@arndb.de, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 1/3] USB: Add driver for NXP ISP1301 USB transceiver
Date: Mon, 16 Apr 2012 15:16:04 +0200
Message-Id: <1334582166-5485-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This very-lowlevel driver registers the NXP ISP1301 chip via the I2C subsystem.
The chip is the USB transceiver shared by ohci-nxp, lpc32xx_udc (gadget) and
isp1301_omap.

Following patches let the respective USB host and gadget drivers use this
driver, instead of duplicating ISP1301 handling.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.4-rc3

This driver needs to be probe()d before the respective USB driver using it. For
modules, this is handled via the module dependency. When linking statically, it
is done via linking order in the Makefile (misc/ before host/ and the gadget/).

Currently, only one ISP1301 chip is supported. To support multiple instances,
we would need a mechanism to identify the respective chips via DT (and static
resources or platform data) to be referenced by the higher level USB driver at
isp1301_get_client(). Any suggestions?


 drivers/usb/Makefile        |    5 ++
 drivers/usb/misc/Kconfig    |   12 ++++++
 drivers/usb/misc/Makefile   |    1 
 drivers/usb/misc/isp1301.c  |   64 ++++++++++++++++++++++++++++++++++
 include/linux/usb/isp1301.h |   82 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 163 insertions(+), 1 deletion(-)

--- linux-2.6.orig/drivers/usb/Makefile
+++ linux-2.6/drivers/usb/Makefile
@@ -12,6 +12,10 @@ obj-$(CONFIG_USB_DWC3)		+= dwc3/
 
 obj-$(CONFIG_USB_MON)		+= mon/
 
+# misc/ before ohci and gadget for probe order when linking statically:
+# misc/isp1301.c is used by ohci and gadget
+obj-$(CONFIG_USB)		+= misc/
+
 obj-$(CONFIG_PCI)		+= host/
 obj-$(CONFIG_USB_EHCI_HCD)	+= host/
 obj-$(CONFIG_USB_ISP116X_HCD)	+= host/
@@ -45,7 +49,6 @@ obj-$(CONFIG_USB_MICROTEK)	+= image/
 
 obj-$(CONFIG_USB_SERIAL)	+= serial/
 
-obj-$(CONFIG_USB)		+= misc/
 obj-$(CONFIG_EARLY_PRINTK_DBGP)	+= early/
 
 obj-$(CONFIG_USB_ATM)		+= atm/
--- linux-2.6.orig/drivers/usb/misc/Kconfig
+++ linux-2.6/drivers/usb/misc/Kconfig
@@ -231,6 +231,18 @@ config USB_ISIGHTFW
 	  driver beforehand. Tools for doing so are available at
 	  http://bersace03.free.fr
 
+config USB_ISP1301
+	tristate "NXP ISP1301 USB transceiver support"
+	depends on USB
+	depends on I2C
+	help
+	  Say Y here to add support for the NXP ISP1301 USB transceiver driver.
+	  This chip is typically used as USB transceiver for USB host, gadget
+	  and OTG drivers (to be selected separately).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called isp1301.
+
 config USB_YUREX
 	tristate "USB YUREX driver support"
 	depends on USB
--- linux-2.6.orig/drivers/usb/misc/Makefile
+++ linux-2.6/drivers/usb/misc/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_USB_FTDI_ELAN)		+= ftdi-ela
 obj-$(CONFIG_USB_IDMOUSE)		+= idmouse.o
 obj-$(CONFIG_USB_IOWARRIOR)		+= iowarrior.o
 obj-$(CONFIG_USB_ISIGHTFW)		+= isight_firmware.o
+obj-$(CONFIG_USB_ISP1301)		+= isp1301.o
 obj-$(CONFIG_USB_LCD)			+= usblcd.o
 obj-$(CONFIG_USB_LD)			+= ldusb.o
 obj-$(CONFIG_USB_LED)			+= usbled.o
--- /dev/null
+++ linux-2.6/drivers/usb/misc/isp1301.c
@@ -0,0 +1,64 @@
+/*
+ * NXP ISP1301 USB transceiver driver
+ *
+ * Copyright (C) 2012 Roland Stigge
+ *
+ * Author: Roland Stigge <stigge@antcom.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+
+#define DRV_NAME		"isp1301"
+#define DRV_VERSION		"0.1.0"
+
+#define ISP1301_I2C_ADDR	0x2C
+
+static const unsigned short normal_i2c[] = {
+	ISP1301_I2C_ADDR, ISP1301_I2C_ADDR + 1, I2C_CLIENT_END
+};
+
+static const struct i2c_device_id isp1301_id[] = {
+	{ "isp1301", 0 },
+	{ }
+};
+
+static struct i2c_client *isp1301_i2c_client;
+
+struct i2c_client *isp1301_get_client(void)
+{
+	return isp1301_i2c_client;
+}
+EXPORT_SYMBOL(isp1301_get_client);
+
+static int isp1301_probe(struct i2c_client *client,
+			 const struct i2c_device_id *i2c_id)
+{
+	isp1301_i2c_client = client;
+	return 0;
+}
+
+static int isp1301_remove(struct i2c_client *client)
+{
+	return 0;
+}
+
+static struct i2c_driver isp1301_driver = {
+	.driver = {
+		.name = DRV_NAME,
+	},
+	.probe = isp1301_probe,
+	.remove = isp1301_remove,
+	.id_table = isp1301_id,
+};
+
+module_i2c_driver(isp1301_driver);
+
+MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
+MODULE_DESCRIPTION("NXP ISP1301 USB transceiver driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
--- /dev/null
+++ linux-2.6/include/linux/usb/isp1301.h
@@ -0,0 +1,82 @@
+/*
+ * NXP ISP1301 USB transceiver driver
+ *
+ * Copyright (C) 2012 Roland Stigge <stigge@antcom.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#ifndef __LINUX_USB_ISP1301_H
+#define __LINUX_USB_ISP1301_H
+
+/* I2C Register definitions: */
+
+#define ISP1301_I2C_MODE_CONTROL_1	0x04	/* u8 read, set, +1 clear */
+
+#define MC1_SPEED_REG			(1 << 0)
+#define MC1_SUSPEND_REG			(1 << 1)
+#define MC1_DAT_SE0			(1 << 2)
+#define MC1_TRANSPARENT			(1 << 3)
+#define MC1_BDIS_ACON_EN		(1 << 4)
+#define MC1_OE_INT_EN			(1 << 5)
+#define MC1_UART_EN			(1 << 6)
+#define MC1_MASK			0x7f
+
+#define ISP1301_I2C_MODE_CONTROL_2	0x12	/* u8 read, set, +1 clear */
+
+#define MC2_GLOBAL_PWR_DN		(1 << 0)
+#define MC2_SPD_SUSP_CTRL		(1 << 1)
+#define MC2_BI_DI			(1 << 2)
+#define MC2_TRANSP_BDIR0		(1 << 3)
+#define MC2_TRANSP_BDIR1		(1 << 4)
+#define MC2_AUDIO_EN			(1 << 5)
+#define MC2_PSW_EN			(1 << 6)
+#define MC2_EN2V7			(1 << 7)
+
+#define ISP1301_I2C_OTG_CONTROL_1	0x06	/* u8 read, set, +1 clear */
+
+#define OTG1_DP_PULLUP			(1 << 0)
+#define OTG1_DM_PULLUP			(1 << 1)
+#define OTG1_DP_PULLDOWN		(1 << 2)
+#define OTG1_DM_PULLDOWN		(1 << 3)
+#define OTG1_ID_PULLDOWN		(1 << 4)
+#define OTG1_VBUS_DRV			(1 << 5)
+#define OTG1_VBUS_DISCHRG		(1 << 6)
+#define OTG1_VBUS_CHRG			(1 << 7)
+
+#define ISP1301_I2C_OTG_CONTROL_2	0x10	/* u8 readonly */
+
+#define OTG_B_SESS_END			(1 << 6)
+#define OTG_B_SESS_VLD			(1 << 7)
+
+#define ISP1301_I2C_INTERRUPT_SOURCE	0x8
+#define ISP1301_I2C_INTERRUPT_LATCH	0xA
+#define ISP1301_I2C_INTERRUPT_FALLING	0xC
+#define ISP1301_I2C_INTERRUPT_RISING	0xE
+
+#define INT_VBUS_VLD			(1 << 0)
+#define INT_SESS_VLD			(1 << 1)
+#define INT_DP_HI			(1 << 2)
+#define INT_ID_GND			(1 << 3)
+#define INT_DM_HI			(1 << 4)
+#define INT_ID_FLOAT			(1 << 5)
+#define INT_BDIS_ACON			(1 << 6)
+#define INT_CR_INT			(1 << 7)
+
+#define ISP1301_I2C_REG_CLEAR_ADDR	1	/* Register Address Modifier */
+
+struct i2c_client *isp1301_get_client(void);
+
+#endif /* __LINUX_USB_ISP1301_H */
