Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0DWV2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:28:42 -0400
Received: from tex.lwn.net ([70.33.254.29]:50535 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0DWV2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:28:34 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 01/13] viafb: Move core stuff into via-core.c
Date: Fri, 23 Apr 2010 15:28:01 -0600
Message-Id: <1272058093-20914-2-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272058093-20914-1-git-send-email-corbet@lwn.net>
References: <1272058093-20914-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first step toward turning viafb into a multifunction driver.  This
patch creates a new via-core.c file which serves as the main PCI driver;
everything else comes below that.  Some work has been done to rationalize
the i2c drivers in this new scheme.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/Makefile   |    2 +-
 drivers/video/via/dvi.c      |    4 +-
 drivers/video/via/global.c   |    2 +
 drivers/video/via/global.h   |    1 +
 drivers/video/via/lcd.c      |   10 ++--
 drivers/video/via/via-core.c |  106 ++++++++++++++++++++++++++++++++++++++++++
 drivers/video/via/via-core.h |   55 ++++++++++++++++++++++
 drivers/video/via/via_i2c.c  |   65 ++++++++++++-------------
 drivers/video/via/via_i2c.h  |   25 +---------
 drivers/video/via/viafbdev.c |   59 ++++--------------------
 drivers/video/via/viafbdev.h |   14 ++++-
 11 files changed, 226 insertions(+), 117 deletions(-)
 create mode 100644 drivers/video/via/via-core.c
 create mode 100644 drivers/video/via/via-core.h

diff --git a/drivers/video/via/Makefile b/drivers/video/via/Makefile
index eeed238..e6d2a2b 100644
--- a/drivers/video/via/Makefile
+++ b/drivers/video/via/Makefile
@@ -2,6 +2,6 @@
 # Makefile for the VIA framebuffer driver (for Linux Kernel 2.6)
 #
 
-obj-$(CONFIG_FB_VIA) += viafb.o
+obj-$(CONFIG_FB_VIA) += viafb.o via-core.o
 
 viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o
diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index be51370..e357c4d 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -96,7 +96,7 @@ int viafb_tmds_trasmitter_identify(void)
 	viaparinfo->chip_info->tmds_chip_info.tmds_chip_name = VT1632_TMDS;
 	viaparinfo->chip_info->
 		tmds_chip_info.tmds_chip_slave_addr = VT1632_TMDS_I2C_ADDR;
-	viaparinfo->chip_info->tmds_chip_info.i2c_port = VIA_I2C_ADAP_31;
+	viaparinfo->chip_info->tmds_chip_info.i2c_port = VIA_PORT_31;
 	if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID) != FAIL) {
 		/*
 		 * Currently only support 12bits,dual edge,add 24bits mode later
@@ -110,7 +110,7 @@ int viafb_tmds_trasmitter_identify(void)
 			  viaparinfo->chip_info->tmds_chip_info.i2c_port);
 		return OK;
 	} else {
-		viaparinfo->chip_info->tmds_chip_info.i2c_port = VIA_I2C_ADAP_2C;
+		viaparinfo->chip_info->tmds_chip_info.i2c_port = VIA_PORT_2C;
 		if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID)
 		    != FAIL) {
 			tmds_register_write(0x08, 0x3b);
diff --git a/drivers/video/via/global.c b/drivers/video/via/global.c
index 1ee511b..339d663 100644
--- a/drivers/video/via/global.c
+++ b/drivers/video/via/global.c
@@ -46,7 +46,9 @@ unsigned int viafb_second_virtual_xres;
 unsigned int viafb_second_virtual_yres;
 int viafb_lcd_panel_id = LCD_PANEL_ID_MAXIMUM + 1;
 struct fb_info *viafbinfo;
+EXPORT_SYMBOL_GPL(viafbinfo);
 struct fb_info *viafbinfo1;
 struct viafb_par *viaparinfo;
+EXPORT_SYMBOL_GPL(viaparinfo);
 struct viafb_par *viaparinfo1;
 
diff --git a/drivers/video/via/global.h b/drivers/video/via/global.h
index 8d95d5f..be48e73 100644
--- a/drivers/video/via/global.h
+++ b/drivers/video/via/global.h
@@ -35,6 +35,7 @@
 
 #include "debug.h"
 
+#include "via-core.h"
 #include "viafbdev.h"
 #include "chip.h"
 #include "accel.h"
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index e32c5c8..063a853 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -179,14 +179,14 @@ int viafb_lvds_trasmitter_identify(void)
 	if (machine_is_olpc())
 		return FAIL;
 
-	if (viafb_lvds_identify_vt1636(VIA_I2C_ADAP_31)) {
-		viaparinfo->chip_info->lvds_chip_info.i2c_port = VIA_I2C_ADAP_31;
+	if (viafb_lvds_identify_vt1636(VIA_PORT_31)) {
+		viaparinfo->chip_info->lvds_chip_info.i2c_port = VIA_PORT_31;
 		DEBUG_MSG(KERN_INFO
 			  "Found VIA VT1636 LVDS on port i2c 0x31\n");
 	} else {
-		if (viafb_lvds_identify_vt1636(VIA_I2C_ADAP_26)) {
+		if (viafb_lvds_identify_vt1636(VIA_PORT_26)) {
 			viaparinfo->chip_info->lvds_chip_info.i2c_port =
-				VIA_I2C_ADAP_2C;
+				VIA_PORT_2C;
 			DEBUG_MSG(KERN_INFO
 				  "Found VIA VT1636 LVDS on port gpio 0x2c\n");
 		}
@@ -426,7 +426,7 @@ static int lvds_register_read(int index)
 {
 	u8 data;
 
-	viafb_i2c_readbyte(VIA_I2C_ADAP_2C,
+	viafb_i2c_readbyte(VIA_PORT_2C,
 			(u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
 			(u8) index, &data);
 	return data;
diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
new file mode 100644
index 0000000..41e4df9
--- /dev/null
+++ b/drivers/video/via/via-core.c
@@ -0,0 +1,106 @@
+/*
+ * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+ * Copyright 2009 Jonathan Corbet <corbet@lwn.net>
+ */
+
+/*
+ * Core code for the Via multifunction framebuffer device.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include "global.h"  	/* Includes everything under the sun */
+
+/*
+ * The default port config.
+ */
+static struct via_port_cfg adap_configs[] = {
+	[VIA_PORT_26]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x26 },
+	[VIA_PORT_31]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x31 },
+	[VIA_PORT_25]	= { VIA_PORT_GPIO, VIA_MODE_GPIO, VIASR, 0x25 },
+	[VIA_PORT_2C]	= { VIA_PORT_GPIO, VIA_MODE_GPIO, VIASR, 0x2c },
+	[VIA_PORT_3D]	= { VIA_PORT_GPIO, VIA_MODE_GPIO, VIASR, 0x3d },
+	{ 0, 0, 0, 0 }
+};
+
+
+static int __devinit via_pci_probe(struct pci_dev *pdev,
+		const struct pci_device_id *ent)
+{
+	int ret;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+	/*
+	 * Set up subsidiary devices
+	 */
+	ret = via_fb_pci_probe(pdev, ent);
+	if (ret)
+		return ret;
+	/*
+	 * Create the I2C busses.  Bailing out on failure seems extreme,
+	 * but that's what the code did before.
+	 */
+	ret = viafb_create_i2c_busses(adap_configs);
+	if (ret) {
+		via_fb_pci_remove(pdev);
+		return ret;
+	}
+	return 0;
+}
+
+static void __devexit via_pci_remove(struct pci_dev *pdev)
+{
+	viafb_delete_i2c_busses();
+	via_fb_pci_remove(pdev);
+	pci_disable_device(pdev);
+}
+
+
+static struct pci_device_id via_pci_table[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CLE266_DID),
+	  .driver_data = UNICHROME_CLE266 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_PM800_DID),
+	  .driver_data = UNICHROME_PM800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K400_DID),
+	  .driver_data = UNICHROME_K400 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K800_DID),
+	  .driver_data = UNICHROME_K800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M890_DID),
+	  .driver_data = UNICHROME_CN700 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K8M890_DID),
+	  .driver_data = UNICHROME_K8M890 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CX700_DID),
+	  .driver_data = UNICHROME_CX700 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M900_DID),
+	  .driver_data = UNICHROME_P4M900 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CN750_DID),
+	  .driver_data = UNICHROME_CN750 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX800_DID),
+	  .driver_data = UNICHROME_VX800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX855_DID),
+	  .driver_data = UNICHROME_VX855 },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, viafb_pci_table);
+
+static struct pci_driver via_driver = {
+	.name		= "viafb",
+	.id_table	= via_pci_table,
+	.probe		= via_pci_probe,
+	.remove		= __devexit_p(via_pci_remove),
+};
+
+static int __init via_core_init(void)
+{
+	return pci_register_driver(&via_driver);
+}
+
+static void __exit via_core_exit(void)
+{
+	pci_unregister_driver(&via_driver);
+}
+
+module_init(via_core_init);
+module_exit(via_core_exit);
diff --git a/drivers/video/via/via-core.h b/drivers/video/via/via-core.h
new file mode 100644
index 0000000..1c2fb06
--- /dev/null
+++ b/drivers/video/via/via-core.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+ * Copyright 2009 Jonathan Corbet <corbet@lwn.net>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __VIA_CORE_H__
+#define __VIA_CORE_H__
+/*
+ * A description of each known serial I2C/GPIO port.
+ */
+enum via_port_type {
+	VIA_PORT_NONE = 0,
+	VIA_PORT_I2C,
+	VIA_PORT_GPIO,
+};
+
+enum via_port_mode {
+	VIA_MODE_OFF = 0,
+	VIA_MODE_I2C,		/* Used as I2C port */
+	VIA_MODE_GPIO,	/* Two GPIO ports */
+};
+
+enum viafb_i2c_adap {
+	VIA_PORT_26 = 0,
+	VIA_PORT_31,
+	VIA_PORT_25,
+	VIA_PORT_2C,
+	VIA_PORT_3D,
+};
+#define VIAFB_NUM_PORTS 5
+
+struct via_port_cfg {
+	enum via_port_type	type;
+	enum via_port_mode	mode;
+	u_int16_t		io_port;
+	u_int8_t		ioport_index;
+};
+#endif /* __VIA_CORE_H__ */
diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index fe5535c..124c935 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -21,10 +21,17 @@
 
 #include "global.h"
 
+/*
+ * There can only be one set of these, so there's no point in having
+ * them be dynamically allocated...
+ */
+#define VIAFB_NUM_I2C		5
+static struct via_i2c_stuff via_i2c_par[VIAFB_NUM_I2C];
+
 static void via_i2c_setscl(void *data, int state)
 {
 	u8 val;
-	struct via_i2c_adap_cfg *adap_data = data;
+	struct via_port_cfg *adap_data = data;
 
 	DEBUG_MSG(KERN_DEBUG "reading index 0x%02x from IO 0x%x\n",
 		adap_data->ioport_index, adap_data->io_port);
@@ -35,10 +42,10 @@ static void via_i2c_setscl(void *data, int state)
 	else
 		val &= ~0x20;
 	switch (adap_data->type) {
-	case VIA_I2C_I2C:
+	case VIA_PORT_I2C:
 		val |= 0x01;
 		break;
-	case VIA_I2C_GPIO:
+	case VIA_PORT_GPIO:
 		val |= 0x80;
 		break;
 	default:
@@ -50,7 +57,7 @@ static void via_i2c_setscl(void *data, int state)
 
 static int via_i2c_getscl(void *data)
 {
-	struct via_i2c_adap_cfg *adap_data = data;
+	struct via_port_cfg *adap_data = data;
 
 	if (viafb_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x08)
 		return 1;
@@ -59,7 +66,7 @@ static int via_i2c_getscl(void *data)
 
 static int via_i2c_getsda(void *data)
 {
-	struct via_i2c_adap_cfg *adap_data = data;
+	struct via_port_cfg *adap_data = data;
 
 	if (viafb_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x04)
 		return 1;
@@ -69,7 +76,7 @@ static int via_i2c_getsda(void *data)
 static void via_i2c_setsda(void *data, int state)
 {
 	u8 val;
-	struct via_i2c_adap_cfg *adap_data = data;
+	struct via_port_cfg *adap_data = data;
 
 	val = viafb_read_reg(adap_data->io_port,
 			     adap_data->ioport_index) & 0xF0;
@@ -78,10 +85,10 @@ static void via_i2c_setsda(void *data, int state)
 	else
 		val &= ~0x10;
 	switch (adap_data->type) {
-	case VIA_I2C_I2C:
+	case VIA_PORT_I2C:
 		val |= 0x01;
 		break;
-	case VIA_I2C_GPIO:
+	case VIA_PORT_GPIO:
 		val |= 0x40;
 		break;
 	default:
@@ -103,8 +110,7 @@ int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata)
 	mm1[0] = index;
 	msgs[0].len = 1; msgs[1].len = 1;
 	msgs[0].buf = mm1; msgs[1].buf = pdata;
-	return i2c_transfer(&viaparinfo->shared->i2c_stuff[adap].adapter,
-			msgs, 2);
+	return i2c_transfer(&via_i2c_par[adap].adapter, msgs, 2);
 }
 
 int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data)
@@ -116,8 +122,7 @@ int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data)
 	msgs.addr = slave_addr / 2;
 	msgs.len = 2;
 	msgs.buf = msg;
-	return i2c_transfer(&viaparinfo->shared->i2c_stuff[adap].adapter,
-			&msgs, 1);
+	return i2c_transfer(&via_i2c_par[adap].adapter, &msgs, 1);
 }
 
 int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len)
@@ -131,13 +136,12 @@ int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len
 	mm1[0] = index;
 	msgs[0].len = 1; msgs[1].len = buff_len;
 	msgs[0].buf = mm1; msgs[1].buf = buff;
-	return i2c_transfer(&viaparinfo->shared->i2c_stuff[adap].adapter,
-			msgs, 2);
+	return i2c_transfer(&via_i2c_par[adap].adapter, msgs, 2);
 }
 
 static int create_i2c_bus(struct i2c_adapter *adapter,
 			  struct i2c_algo_bit_data *algo,
-			  struct via_i2c_adap_cfg *adap_cfg,
+			  struct via_port_cfg *adap_cfg,
 			  struct pci_dev *pdev)
 {
 	DEBUG_MSG(KERN_DEBUG "viafb: creating bus adap=0x%p, algo_bit_data=0x%p, adap_cfg=0x%p\n", adapter, algo, adap_cfg);
@@ -170,24 +174,15 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
 	return i2c_bit_add_bus(adapter);
 }
 
-static struct via_i2c_adap_cfg adap_configs[] = {
-	[VIA_I2C_ADAP_26]	= { VIA_I2C_I2C,  VIASR, 0x26 },
-	[VIA_I2C_ADAP_31]	= { VIA_I2C_I2C,  VIASR, 0x31 },
-	[VIA_I2C_ADAP_25]	= { VIA_I2C_GPIO, VIASR, 0x25 },
-	[VIA_I2C_ADAP_2C]	= { VIA_I2C_GPIO, VIASR, 0x2c },
-	[VIA_I2C_ADAP_3D]	= { VIA_I2C_GPIO, VIASR, 0x3d },
-	{ 0, 0, 0 }
-};
-
-int viafb_create_i2c_busses(struct viafb_par *viapar)
+int viafb_create_i2c_busses(struct via_port_cfg *configs)
 {
 	int i, ret;
 
-	for (i = 0; i < VIAFB_NUM_I2C; i++) {
-		struct via_i2c_adap_cfg *adap_cfg = &adap_configs[i];
-		struct via_i2c_stuff *i2c_stuff = &viapar->shared->i2c_stuff[i];
+	for (i = 0; i < VIAFB_NUM_PORTS; i++) {
+		struct via_port_cfg *adap_cfg = configs++;
+		struct via_i2c_stuff *i2c_stuff = &via_i2c_par[i];
 
-		if (adap_cfg->type == 0)
+		if (adap_cfg->type == 0 || adap_cfg->mode != VIA_MODE_I2C)
 			break;
 
 		ret = create_i2c_bus(&i2c_stuff->adapter,
@@ -204,14 +199,16 @@ int viafb_create_i2c_busses(struct viafb_par *viapar)
 	return 0;
 }
 
-void viafb_delete_i2c_busses(struct viafb_par *par)
+void viafb_delete_i2c_busses(void)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(par->shared->i2c_stuff); i++) {
-		struct via_i2c_stuff *i2c_stuff = &par->shared->i2c_stuff[i];
-		/* only remove those entries in the array that we've
-		 * actually used (and thus initialized algo_data) */
+	for (i = 0; i < VIAFB_NUM_PORTS; i++) {
+		struct via_i2c_stuff *i2c_stuff = &via_i2c_par[i];
+		/*
+		 * Only remove those entries in the array that we've
+		 * actually used (and thus initialized algo_data)
+		 */
 		if (i2c_stuff->adapter.algo_data == &i2c_stuff->algo)
 			i2c_del_adapter(&i2c_stuff->adapter);
 	}
diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
index 00ed978..0093291 100644
--- a/drivers/video/via/via_i2c.h
+++ b/drivers/video/via/via_i2c.h
@@ -24,38 +24,19 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 
-enum via_i2c_type {
-	VIA_I2C_NONE,
-	VIA_I2C_I2C,
-	VIA_I2C_GPIO,
-};
-
-/* private data for each adapter */
-struct via_i2c_adap_cfg {
-	enum via_i2c_type	type;
-	u_int16_t		io_port;
-	u_int8_t		ioport_index;
-};
-
 struct via_i2c_stuff {
 	u16 i2c_port;			/* GPIO or I2C port */
 	struct i2c_adapter adapter;
 	struct i2c_algo_bit_data algo;
 };
 
-enum viafb_i2c_adap {
-	VIA_I2C_ADAP_26,
-	VIA_I2C_ADAP_31,
-	VIA_I2C_ADAP_25,
-	VIA_I2C_ADAP_2C,
-	VIA_I2C_ADAP_3D,
-};
 
 int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata);
 int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data);
 int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len);
 
 struct viafb_par;
-int viafb_create_i2c_busses(struct viafb_par *par);
-void viafb_delete_i2c_busses(struct viafb_par *par);
+int viafb_create_i2c_busses(struct via_port_cfg *cfg);
+void viafb_delete_i2c_busses(void);
+struct i2c_adapter *viafb_find_adapter(enum viafb_i2c_adap which);
 #endif /* __VIA_I2C_H__ */
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index fa10049..cd00c37 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1731,8 +1731,9 @@ static int parse_mode(const char *str, u32 *xres, u32 *yres)
 	return 0;
 }
 
-static int __devinit via_pci_probe(struct pci_dev *pdev,
-				   const struct pci_device_id *ent)
+
+int __devinit via_fb_pci_probe(struct pci_dev *pdev,
+		const struct pci_device_id *ent)
 {
 	u32 default_xres, default_yres;
 	struct VideoModeTable *vmode_entry;
@@ -1764,6 +1765,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 		&viaparinfo->shared->lvds_setting_info2;
 	viaparinfo->crt_setting_info = &viaparinfo->shared->crt_setting_info;
 	viaparinfo->chip_info = &viaparinfo->shared->chip_info;
+	spin_lock_init(&viaparinfo->reg_lock);
 
 	if (viafb_dual_fb)
 		viafb_SAMM_ON = 1;
@@ -1774,26 +1776,21 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	if (!viafb_SAMM_ON)
 		viafb_dual_fb = 0;
 
-	/* Set up I2C bus stuff */
-	rc = viafb_create_i2c_busses(viaparinfo);
-	if (rc)
-		goto out_fb_release;
-
 	viafb_init_chip_info(pdev, ent);
 	viaparinfo->fbmem = pci_resource_start(pdev, 0);
 	viaparinfo->memsize = viafb_get_fb_size_from_pci();
 	if (viaparinfo->memsize < 0) {
 		rc = viaparinfo->memsize;
-		goto out_delete_i2c;
+		goto out_fb_release;
 	}
 	viaparinfo->fbmem_free = viaparinfo->memsize;
 	viaparinfo->fbmem_used = 0;
 	viafbinfo->screen_base = ioremap_nocache(viaparinfo->fbmem,
 		viaparinfo->memsize);
 	if (!viafbinfo->screen_base) {
-		printk(KERN_INFO "ioremap failed\n");
+		printk(KERN_ERR "ioremap of fbmem failed\n");
 		rc = -ENOMEM;
-		goto out_delete_i2c;
+		goto out_fb_release;
 	}
 
 	viafbinfo->fix.mmio_start = pci_resource_start(pdev, 1);
@@ -1963,14 +1960,12 @@ out_fb1_release:
 		framebuffer_release(viafbinfo1);
 out_unmap_screen:
 	iounmap(viafbinfo->screen_base);
-out_delete_i2c:
-	viafb_delete_i2c_busses(viaparinfo);
 out_fb_release:
 	framebuffer_release(viafbinfo);
 	return rc;
 }
 
-static void __devexit via_pci_remove(struct pci_dev *pdev)
+void __devexit via_fb_pci_remove(struct pci_dev *pdev)
 {
 	DEBUG_MSG(KERN_INFO "via_pci_remove!\n");
 	fb_dealloc_cmap(&viafbinfo->cmap);
@@ -1980,8 +1975,6 @@ static void __devexit via_pci_remove(struct pci_dev *pdev)
 	iounmap((void *)viafbinfo->screen_base);
 	iounmap(viaparinfo->shared->engine_mmio);
 
-	viafb_delete_i2c_busses(viaparinfo);
-
 	framebuffer_release(viafbinfo);
 	if (viafb_dual_fb)
 		framebuffer_release(viafbinfo1);
@@ -2062,39 +2055,6 @@ static int __init viafb_setup(char *options)
 }
 #endif
 
-static struct pci_device_id viafb_pci_table[] __devinitdata = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CLE266_DID),
-	  .driver_data = UNICHROME_CLE266 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_PM800_DID),
-	  .driver_data = UNICHROME_PM800 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K400_DID),
-	  .driver_data = UNICHROME_K400 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K800_DID),
-	  .driver_data = UNICHROME_K800 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M890_DID),
-	  .driver_data = UNICHROME_CN700 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K8M890_DID),
-	  .driver_data = UNICHROME_K8M890 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CX700_DID),
-	  .driver_data = UNICHROME_CX700 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M900_DID),
-	  .driver_data = UNICHROME_P4M900 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CN750_DID),
-	  .driver_data = UNICHROME_CN750 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX800_DID),
-	  .driver_data = UNICHROME_VX800 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX855_DID),
-	  .driver_data = UNICHROME_VX855 },
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, viafb_pci_table);
-
-static struct pci_driver viafb_driver = {
-	.name		= "viafb",
-	.id_table	= viafb_pci_table,
-	.probe		= via_pci_probe,
-	.remove		= __devexit_p(via_pci_remove),
-};
 
 static int __init viafb_init(void)
 {
@@ -2115,13 +2075,12 @@ static int __init viafb_init(void)
 	printk(KERN_INFO
        "VIA Graphics Intergration Chipset framebuffer %d.%d initializing\n",
 	       VERSION_MAJOR, VERSION_MINOR);
-	return pci_register_driver(&viafb_driver);
+	return 0;
 }
 
 static void __exit viafb_exit(void)
 {
 	DEBUG_MSG(KERN_INFO "viafb_exit!\n");
-	pci_unregister_driver(&viafb_driver);
 }
 
 static struct fb_ops viafb_ops = {
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 4bc00ec..1fe6c29 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -24,6 +24,7 @@
 
 #include <linux/proc_fs.h>
 #include <linux/fb.h>
+#include <linux/spinlock.h>
 
 #include "ioctl.h"
 #include "share.h"
@@ -42,9 +43,6 @@
 struct viafb_shared {
 	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
 
-	/* I2C stuff */
-	struct via_i2c_stuff i2c_stuff[VIAFB_NUM_I2C];
-
 	/* All the information will be needed to set engine */
 	struct tmds_setting_information tmds_setting_info;
 	struct crt_setting_information crt_setting_info;
@@ -74,6 +72,14 @@ struct viafb_par {
 
 	struct viafb_shared *shared;
 
+	/*
+	 * (jc) I believe one should use locking to protect against
+	 * concurrent access to the device ports and registers.  Thus,
+	 * this lock.  Use of it is *far* from universal, though...
+	 * someday...
+	 */
+	spinlock_t reg_lock;
+
 	/* All the information will be needed to set engine */
 	/* depreciated, use the ones in shared directly */
 	struct tmds_setting_information *tmds_setting_info;
@@ -101,4 +107,6 @@ u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
 void viafb_gpio_i2c_write_mask_lvds(struct lvds_setting_information
 			      *plvds_setting_info, struct lvds_chip_information
 			      *plvds_chip_info, struct IODATA io_data);
+int via_fb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+void via_fb_pci_remove(struct pci_dev *pdev);
 #endif /* __VIAFBDEV_H__ */
-- 
1.7.0.1

