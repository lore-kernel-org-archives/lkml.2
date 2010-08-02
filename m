Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0HBGAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:00:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61470 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0HBGAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=buYBr/QfsygYkllUzEViJaJNSvdB5nYPSA/PL2XA4PDfX3BKwnn98MiF7BezrvTsng
         /dGDCJ2GZvDa3P+aFfiDqC3GnXKA3eElaj9trZxDbi+WPf4zcouV6118TiC8niShwNTb
         Cad43PhshHlcMNT5dZlLk4tBDDQDurEDKJo4E=
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: gregkh@suse.de, nm127@freemail.hu, linux-kernel@vger.kernel.org,
        maxinbjohn@gmail.com, forest.bond@outpostembedded.com,
        vijaykumar@zilogic.com, Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH] USB-serial dummy cable driver
Date: Mon,  2 Aug 2010 08:00:07 +0200
Message-Id: <1280728807-20296-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is used to implement USB-serial like behaviour over dummy
USB cables. These are used in the following devices:
	Funsoft Serial USB driver
	Genesys Logic GL620USB USB Laplink cable
	HP4x (48/49) Serial cable
	Motorola phones
	Siemens USB-MPI Serial USB driver
	ViVOpay USB Serial Driver
	ZIO Motherboard USB driver

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/usb/serial/Kconfig            |   59 ++++++---------------
 drivers/usb/serial/Makefile           |    7 +--
 drivers/usb/serial/funsoft.c          |   69 ------------------------
 drivers/usb/serial/hp4x.c             |   86 ------------------------------
 drivers/usb/serial/moto_modem.c       |   71 -------------------------
 drivers/usb/serial/siemens_mpi.c      |   77 ---------------------------
 drivers/usb/serial/usb-serial-dummy.c |   92 +++++++++++++++++++++++++++++++++
 drivers/usb/serial/vivopay-serial.c   |   76 ---------------------------
 drivers/usb/serial/zio.c              |   64 -----------------------
 9 files changed, 111 insertions(+), 490 deletions(-)
 delete mode 100644 drivers/usb/serial/funsoft.c
 delete mode 100644 drivers/usb/serial/hp4x.c
 delete mode 100644 drivers/usb/serial/moto_modem.c
 delete mode 100644 drivers/usb/serial/siemens_mpi.c
 create mode 100644 drivers/usb/serial/usb-serial-dummy.c
 delete mode 100644 drivers/usb/serial/vivopay-serial.c
 delete mode 100644 drivers/usb/serial/zio.c

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index bd8aab0..9466c4e 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -116,6 +116,24 @@ config USB_SERIAL_DIGI_ACCELEPORT
 	  To compile this driver as a module, choose M here: the
 	  module will be called digi_acceleport.
 
+config USB_SERIAL_DUMMY
+       tristate "USB-serial dummy cable driver"
+       help
+         Say Y here if you want to use the USB-serial dummy cable driver.
+
+         This driver is used to implement USB-serial like behaviour over dummy
+	 USB cables. These are used in the following devices:
+		Genesys Logic GL620USB USB Laplink cable
+		HP4x (48/49) Serial cable
+		Motorola phones
+		Funsoft Serial USB driver
+		ViVOpay USB Serial Driver
+		ZIO Motherboard USB driver
+		Siemens USB-MPI Serial USB driver
+
+         To compile this driver as a module, choose M here: the
+         module will be called usb-serial-dummy.
+
 config USB_SERIAL_CP210X
 	tristate "USB CP210x family of UART Bridge Controllers"
 	help
@@ -449,15 +467,6 @@ config USB_SERIAL_MOS7840
 	  To compile this driver as a module, choose M here: the
 	  module will be called mos7840.  If unsure, choose N.
 
-config USB_SERIAL_MOTOROLA
-	tristate "USB Motorola Phone modem driver"
-	---help---
-	  Say Y here if you want to use a Motorola phone with a USB
-	  connector as a modem link.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called moto_modem.  If unsure, choose N.
-
 config USB_SERIAL_NAVMAN
 	tristate "USB Navman GPS device"
 	help
@@ -512,14 +521,6 @@ config USB_SERIAL_SPCP8X5
 	  To compile this driver as a module, choose M here: the
 	  module will be called spcp8x5.
 
-config USB_SERIAL_HP4X
-        tristate "USB HP4x Calculators support"
-        help
-          Say Y here if you want to use an Hewlett-Packard 4x Calculator.
-
-          To compile this driver as a module, choose M here: the
-          module will be called hp4x.
-
 config USB_SERIAL_SAFE
 	tristate "USB Safe Serial (Encapsulated) Driver"
 
@@ -527,14 +528,6 @@ config USB_SERIAL_SAFE_PADDED
 	bool "USB Secure Encapsulated Driver - Padded"
 	depends on USB_SERIAL_SAFE
 
-config USB_SERIAL_SIEMENS_MPI
-	tristate "USB Siemens MPI driver"
-	help
-	  Say M here if you want to use a Siemens USB/MPI adapter.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called siemens_mpi.
-
 config USB_SERIAL_SIERRAWIRELESS
 	tristate "USB Sierra Wireless Driver"
 	help
@@ -626,22 +619,6 @@ config USB_SERIAL_OPTICON
 	  To compile this driver as a module, choose M here: the
 	  module will be called opticon.
 
-config USB_SERIAL_VIVOPAY_SERIAL
-        tristate "USB ViVOpay serial interface driver"
-        help
-          Say Y here if you want to use a ViVOtech ViVOpay USB device.
-
-          To compile this driver as a module, choose M here: the
-          module will be called vivopay-serial.
-
-config USB_SERIAL_ZIO
-	tristate "ZIO Motherboard USB serial interface driver"
-	help
-	  Say Y here if you want to use ZIO Motherboard.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called zio.
-
 config USB_SERIAL_DEBUG
 	tristate "USB Debugging Device"
 	help
diff --git a/drivers/usb/serial/Makefile b/drivers/usb/serial/Makefile
index e54c728..c96e81e 100644
--- a/drivers/usb/serial/Makefile
+++ b/drivers/usb/serial/Makefile
@@ -20,13 +20,12 @@ obj-$(CONFIG_USB_SERIAL_CYBERJACK)		+= cyberjack.o
 obj-$(CONFIG_USB_SERIAL_CYPRESS_M8)		+= cypress_m8.o
 obj-$(CONFIG_USB_SERIAL_DEBUG)			+= usb_debug.o
 obj-$(CONFIG_USB_SERIAL_DIGI_ACCELEPORT)	+= digi_acceleport.o
+obj-$(CONFIG_USB_SERIAL_DUMMY)			+= usb-serial-dummy.o
 obj-$(CONFIG_USB_SERIAL_EDGEPORT)		+= io_edgeport.o
 obj-$(CONFIG_USB_SERIAL_EDGEPORT_TI)		+= io_ti.o
 obj-$(CONFIG_USB_SERIAL_EMPEG)			+= empeg.o
 obj-$(CONFIG_USB_SERIAL_FTDI_SIO)		+= ftdi_sio.o
-obj-$(CONFIG_USB_SERIAL_FUNSOFT)		+= funsoft.o
 obj-$(CONFIG_USB_SERIAL_GARMIN)			+= garmin_gps.o
-obj-$(CONFIG_USB_SERIAL_HP4X)			+= hp4x.o
 obj-$(CONFIG_USB_SERIAL_IPAQ)			+= ipaq.o
 obj-$(CONFIG_USB_SERIAL_IPW)			+= ipw.o
 obj-$(CONFIG_USB_SERIAL_IR)			+= ir-usb.o
@@ -38,7 +37,6 @@ obj-$(CONFIG_USB_SERIAL_KOBIL_SCT)		+= kobil_sct.o
 obj-$(CONFIG_USB_SERIAL_MCT_U232)		+= mct_u232.o
 obj-$(CONFIG_USB_SERIAL_MOS7720)		+= mos7720.o
 obj-$(CONFIG_USB_SERIAL_MOS7840)		+= mos7840.o
-obj-$(CONFIG_USB_SERIAL_MOTOROLA)		+= moto_modem.o
 obj-$(CONFIG_USB_SERIAL_NAVMAN)			+= navman.o
 obj-$(CONFIG_USB_SERIAL_OMNINET)		+= omninet.o
 obj-$(CONFIG_USB_SERIAL_OPTICON)		+= opticon.o
@@ -48,7 +46,6 @@ obj-$(CONFIG_USB_SERIAL_PL2303)			+= pl2303.o
 obj-$(CONFIG_USB_SERIAL_QCAUX)			+= qcaux.o
 obj-$(CONFIG_USB_SERIAL_QUALCOMM)		+= qcserial.o
 obj-$(CONFIG_USB_SERIAL_SAFE)			+= safe_serial.o
-obj-$(CONFIG_USB_SERIAL_SIEMENS_MPI)		+= siemens_mpi.o
 obj-$(CONFIG_USB_SERIAL_SIERRAWIRELESS)		+= sierra.o
 obj-$(CONFIG_USB_SERIAL_SPCP8X5)		+= spcp8x5.o
 obj-$(CONFIG_USB_SERIAL_SYMBOL)			+= symbolserial.o
@@ -57,6 +54,4 @@ obj-$(CONFIG_USB_SERIAL_TI)			+= ti_usb_3410_5052.o
 obj-$(CONFIG_USB_SERIAL_VISOR)			+= visor.o
 obj-$(CONFIG_USB_SERIAL_WHITEHEAT)		+= whiteheat.o
 obj-$(CONFIG_USB_SERIAL_XIRCOM)			+= keyspan_pda.o
-obj-$(CONFIG_USB_SERIAL_VIVOPAY_SERIAL)	+= vivopay-serial.o
-obj-$(CONFIG_USB_SERIAL_ZIO)			+= zio.o
 
diff --git a/drivers/usb/serial/funsoft.c b/drivers/usb/serial/funsoft.c
deleted file mode 100644
index e21ce9d..0000000
--- a/drivers/usb/serial/funsoft.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- * Funsoft Serial USB driver
- *
- * Copyright (C) 2006 Greg Kroah-Hartman <gregkh@suse.de>
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License version
- *	2 as published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/tty.h>
-#include <linux/module.h>
-#include <linux/usb.h>
-#include <linux/usb/serial.h>
-#include <linux/uaccess.h>
-
-static int debug;
-
-static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(0x1404, 0xcddc) },
-	{ },
-};
-MODULE_DEVICE_TABLE(usb, id_table);
-
-static struct usb_driver funsoft_driver = {
-	.name =		"funsoft",
-	.probe =	usb_serial_probe,
-	.disconnect =	usb_serial_disconnect,
-	.id_table =	id_table,
-	.no_dynamic_id = 	1,
-};
-
-static struct usb_serial_driver funsoft_device = {
-	.driver = {
-		.owner =	THIS_MODULE,
-		.name =		"funsoft",
-	},
-	.id_table =		id_table,
-	.usb_driver = 		&funsoft_driver,
-	.num_ports =		1,
-};
-
-static int __init funsoft_init(void)
-{
-	int retval;
-
-	retval = usb_serial_register(&funsoft_device);
-	if (retval)
-		return retval;
-	retval = usb_register(&funsoft_driver);
-	if (retval)
-		usb_serial_deregister(&funsoft_device);
-	return retval;
-}
-
-static void __exit funsoft_exit(void)
-{
-	usb_deregister(&funsoft_driver);
-	usb_serial_deregister(&funsoft_device);
-}
-
-module_init(funsoft_init);
-module_exit(funsoft_exit);
-MODULE_LICENSE("GPL");
-
-module_param(debug, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Debug enabled or not");
diff --git a/drivers/usb/serial/hp4x.c b/drivers/usb/serial/hp4x.c
deleted file mode 100644
index 8093791..0000000
--- a/drivers/usb/serial/hp4x.c
+++ /dev/null
@@ -1,86 +0,0 @@
-/*
- * HP4x Calculators Serial USB driver
- *
- * Copyright (C) 2005 Arthur Huillet (ahuillet@users.sf.net)
- * Copyright (C) 2001-2005 Greg Kroah-Hartman (greg@kroah.com)
- *
- *	This program is free software; you can redistribute it and/or modify
- *	it under the terms of the GNU General Public License as published by
- *	the Free Software Foundation; either version 2 of the License, or
- *	(at your option) any later version.
- *
- * See Documentation/usb/usb-serial.txt for more information on using this
- * driver
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/tty.h>
-#include <linux/module.h>
-#include <linux/usb.h>
-#include <linux/usb/serial.h>
-
-/*
- * Version Information
- */
-#define DRIVER_VERSION "v1.00"
-#define DRIVER_DESC "HP4x (48/49) Generic Serial driver"
-
-#define HP_VENDOR_ID 0x03f0
-#define HP49GP_PRODUCT_ID 0x0121
-
-static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(HP_VENDOR_ID, HP49GP_PRODUCT_ID) },
-	{ }					/* Terminating entry */
-};
-
-MODULE_DEVICE_TABLE(usb, id_table);
-
-static struct usb_driver hp49gp_driver = {
-	.name =		"hp4X",
-	.probe =	usb_serial_probe,
-	.disconnect =	usb_serial_disconnect,
-	.id_table =	id_table,
-	.no_dynamic_id = 	1,
-};
-
-static struct usb_serial_driver hp49gp_device = {
-	.driver = {
-		.owner =	THIS_MODULE,
-		.name =		"hp4X",
-	},
-	.id_table =		id_table,
-	.usb_driver = 		&hp49gp_driver,
-	.num_ports =		1,
-};
-
-static int __init hp49gp_init(void)
-{
-	int retval;
-	retval = usb_serial_register(&hp49gp_device);
-	if (retval)
-		goto failed_usb_serial_register;
-	retval = usb_register(&hp49gp_driver);
-	if (retval)
-		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
-	return 0;
-failed_usb_register:
-	usb_serial_deregister(&hp49gp_device);
-failed_usb_serial_register:
-	return retval;
-}
-
-static void __exit hp49gp_exit(void)
-{
-	usb_deregister(&hp49gp_driver);
-	usb_serial_deregister(&hp49gp_device);
-}
-
-module_init(hp49gp_init);
-module_exit(hp49gp_exit);
-
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_VERSION(DRIVER_VERSION);
-MODULE_LICENSE("GPL");
diff --git a/drivers/usb/serial/moto_modem.c b/drivers/usb/serial/moto_modem.c
deleted file mode 100644
index cf17183..0000000
--- a/drivers/usb/serial/moto_modem.c
+++ /dev/null
@@ -1,71 +0,0 @@
-/*
- * Motorola USB Phone driver
- *
- * Copyright (C) 2008 Greg Kroah-Hartman <greg@kroah.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- *
- * {sigh}
- * Motorola should be using the CDC ACM USB spec, but instead
- * they try to just "do their own thing"...  This driver should handle a
- * few phones in which a basic "dumb serial connection" is needed to be
- * able to get a connection through to them.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/tty.h>
-#include <linux/module.h>
-#include <linux/usb.h>
-#include <linux/usb/serial.h>
-
-static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(0x05c6, 0x3197) },	/* unknown Motorola phone */
-	{ USB_DEVICE(0x0c44, 0x0022) },	/* unknown Mororola phone */
-	{ USB_DEVICE(0x22b8, 0x2a64) },	/* Motorola KRZR K1m */
-	{ USB_DEVICE(0x22b8, 0x2c64) }, /* Motorola V950 phone */
-	{ },
-};
-MODULE_DEVICE_TABLE(usb, id_table);
-
-static struct usb_driver moto_driver = {
-	.name =		"moto-modem",
-	.probe =	usb_serial_probe,
-	.disconnect =	usb_serial_disconnect,
-	.id_table =	id_table,
-	.no_dynamic_id = 	1,
-};
-
-static struct usb_serial_driver moto_device = {
-	.driver = {
-		.owner =	THIS_MODULE,
-		.name =		"moto-modem",
-	},
-	.id_table =		id_table,
-	.num_ports =		1,
-};
-
-static int __init moto_init(void)
-{
-	int retval;
-
-	retval = usb_serial_register(&moto_device);
-	if (retval)
-		return retval;
-	retval = usb_register(&moto_driver);
-	if (retval)
-		usb_serial_deregister(&moto_device);
-	return retval;
-}
-
-static void __exit moto_exit(void)
-{
-	usb_deregister(&moto_driver);
-	usb_serial_deregister(&moto_device);
-}
-
-module_init(moto_init);
-module_exit(moto_exit);
-MODULE_LICENSE("GPL");
diff --git a/drivers/usb/serial/siemens_mpi.c b/drivers/usb/serial/siemens_mpi.c
deleted file mode 100644
index cb8195c..0000000
--- a/drivers/usb/serial/siemens_mpi.c
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- * Siemens USB-MPI Serial USB driver
- *
- * Copyright (C) 2005 Thomas Hergenhahn <thomas.hergenhahn@suse.de>
- * Copyright (C) 2005,2008 Greg Kroah-Hartman <gregkh@suse.de>
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License version
- *	2 as published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/tty.h>
-#include <linux/module.h>
-#include <linux/usb.h>
-#include <linux/usb/serial.h>
-
-/* Version Information */
-#define DRIVER_VERSION "Version 0.1 09/26/2005"
-#define DRIVER_AUTHOR "Thomas Hergenhahn@web.de http://libnodave.sf.net"
-#define DRIVER_DESC "Driver for Siemens USB/MPI adapter"
-
-
-static const struct usb_device_id id_table[] = {
-	/* Vendor and product id for 6ES7-972-0CB20-0XA0 */
-	{ USB_DEVICE(0x908, 0x0004) },
-	{ },
-};
-MODULE_DEVICE_TABLE(usb, id_table);
-
-static struct usb_driver siemens_usb_mpi_driver = {
-	.name =		"siemens_mpi",
-	.probe =	usb_serial_probe,
-	.disconnect =	usb_serial_disconnect,
-	.id_table =	id_table,
-};
-
-static struct usb_serial_driver siemens_usb_mpi_device = {
-	.driver = {
-		.owner =	THIS_MODULE,
-		.name =		"siemens_mpi",
-	},
-	.id_table =		id_table,
-	.num_ports =		1,
-};
-
-static int __init siemens_usb_mpi_init(void)
-{
-	int retval;
-
-	retval = usb_serial_register(&siemens_usb_mpi_device);
-	if (retval)
-		goto failed_usb_serial_register;
-	retval = usb_register(&siemens_usb_mpi_driver);
-	if (retval)
-		goto failed_usb_register;
-	printk(KERN_INFO DRIVER_DESC "\n");
-	printk(KERN_INFO DRIVER_VERSION " " DRIVER_AUTHOR "\n");
-	return retval;
-failed_usb_register:
-	usb_serial_deregister(&siemens_usb_mpi_device);
-failed_usb_serial_register:
-	return retval;
-}
-
-static void __exit siemens_usb_mpi_exit(void)
-{
-	usb_deregister(&siemens_usb_mpi_driver);
-	usb_serial_deregister(&siemens_usb_mpi_device);
-}
-
-module_init(siemens_usb_mpi_init);
-module_exit(siemens_usb_mpi_exit);
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE("GPL");
diff --git a/drivers/usb/serial/usb-serial-dummy.c b/drivers/usb/serial/usb-serial-dummy.c
new file mode 100644
index 0000000..1e2d0a2
--- /dev/null
+++ b/drivers/usb/serial/usb-serial-dummy.c
@@ -0,0 +1,92 @@
+/*
+ * Dummy USB-serial cable driver
+ *
+ * Copyright (C) 2008-2010 Marek Vasut <marek.vasut@gmail.com>
+ *
+ * This driver is used to implement USB-serial like behaviour over dummy USB
+ * cables. These are used in the following devices:
+ *	Funsoft Serial USB driver			(was funsoft)
+ *	Genesys Logic GL620USB USB Laplink cable	(was gl620)
+ *	HP4x (48/49) Serial cable			(was hp4x)
+ *	Motorola phones					(was moto_modem)
+ *	Siemens USB-MPI Serial USB driver		(was siemens_mpi)
+ *	ViVOpay USB Serial Driver			(was vivopay-serial)
+ *	ZIO Motherboard USB driver			(was zio)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/tty.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/serial.h>
+
+struct usb_device_id usb_serial_dummy_id_table[] = {
+	{ USB_DEVICE(0x05e3, 0x0501) },	/* Genesys Logic GL620USB USB Laplink */
+	{ USB_DEVICE(0x03f0, 0x0121) },	/* HP4x Calculators Serial USB driver */
+	{ USB_DEVICE(0x1cbe, 0x0103) },	/* ZIO Motherboard USB driver */
+	{ USB_DEVICE(0x1404, 0xcddc) },	/* Funsoft Serial USB driver */
+	{ USB_DEVICE(0x1d5f, 0x1004) },	/* ViVOpay USB Serial Driver */
+	{ USB_DEVICE(0x05c6, 0x3197) },	/* unknown Motorola phone */
+	{ USB_DEVICE(0x0c44, 0x0022) },	/* unknown Mororola phone */
+	{ USB_DEVICE(0x22b8, 0x2a64) },	/* Motorola KRZR K1m */
+	{ USB_DEVICE(0x22b8, 0x2c64) }, /* Motorola V950 phone */
+	{ USB_DEVICE(0x0908, 0x0004) },	/* Siemens USB-MPI Serial USB driver */
+	{ },
+};
+
+MODULE_DEVICE_TABLE(usb, usb_serial_dummy_id_table);
+
+struct usb_driver usb_serial_dummy_usb_driver = {
+	.name			= "usb-serial-dummy",
+	.probe			= usb_serial_probe,
+	.disconnect		= usb_serial_disconnect,
+	.id_table		= usb_serial_dummy_id_table,
+	.no_dynamic_id		= 1,
+};
+
+struct usb_serial_driver usb_serial_dummy_serial_driver = {
+	.driver	= {
+		.name	= "usb-serial-dummy",
+		.owner	= THIS_MODULE,
+	},
+	.description		= "Dummy USB-serial cable",
+	.usb_driver		= &usb_serial_dummy_usb_driver,
+	.id_table		= usb_serial_dummy_id_table,
+	.num_ports		= 1,
+};
+
+int __init usb_serial_dummy_init(void)
+{
+	int ret;
+
+	ret = usb_serial_register(&usb_serial_dummy_serial_driver);
+	if (ret)
+		goto err1;
+	ret = usb_register(&usb_serial_dummy_usb_driver);
+	if (ret)
+		goto err2;
+
+	return 0;
+err2:
+	usb_serial_deregister(&usb_serial_dummy_serial_driver);
+err1:
+	return ret;
+}
+
+void __exit usb_serial_dummy_exit(void)
+{
+	usb_deregister(&usb_serial_dummy_usb_driver);
+	usb_serial_deregister(&usb_serial_dummy_serial_driver);
+}
+
+module_init(usb_serial_dummy_init);
+module_exit(usb_serial_dummy_exit);
+
+MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Driver for dummy USB-serial cables");
diff --git a/drivers/usb/serial/vivopay-serial.c b/drivers/usb/serial/vivopay-serial.c
deleted file mode 100644
index f719d00..0000000
--- a/drivers/usb/serial/vivopay-serial.c
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * Copyright (C) 2001-2005 Greg Kroah-Hartman (greg@kroah.com)
- * Copyright (C) 2009 Outpost Embedded, LLC
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/tty.h>
-#include <linux/module.h>
-#include <linux/usb.h>
-#include <linux/usb/serial.h>
-
-
-#define DRIVER_VERSION "v1.0"
-#define DRIVER_DESC "ViVOpay USB Serial Driver"
-
-#define VIVOPAY_VENDOR_ID 0x1d5f
-
-
-static struct usb_device_id id_table [] = {
-	/* ViVOpay 8800 */
-	{ USB_DEVICE(VIVOPAY_VENDOR_ID, 0x1004) },
-	{ },
-};
-
-MODULE_DEVICE_TABLE(usb, id_table);
-
-static struct usb_driver vivopay_serial_driver = {
-	.name =			"vivopay-serial",
-	.probe =		usb_serial_probe,
-	.disconnect =		usb_serial_disconnect,
-	.id_table =		id_table,
-	.no_dynamic_id =	1,
-};
-
-static struct usb_serial_driver vivopay_serial_device = {
-	.driver = {
-		.owner =	THIS_MODULE,
-		.name =		"vivopay-serial",
-	},
-	.id_table =		id_table,
-	.usb_driver =		&vivopay_serial_driver,
-	.num_ports =		1,
-};
-
-static int __init vivopay_serial_init(void)
-{
-	int retval;
-	retval = usb_serial_register(&vivopay_serial_device);
-	if (retval)
-		goto failed_usb_serial_register;
-	retval = usb_register(&vivopay_serial_driver);
-	if (retval)
-		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	    DRIVER_DESC "\n");
-	return 0;
-failed_usb_register:
-	usb_serial_deregister(&vivopay_serial_device);
-failed_usb_serial_register:
-	return retval;
-}
-
-static void __exit vivopay_serial_exit(void)
-{
-	usb_deregister(&vivopay_serial_driver);
-	usb_serial_deregister(&vivopay_serial_device);
-}
-
-module_init(vivopay_serial_init);
-module_exit(vivopay_serial_exit);
-
-MODULE_AUTHOR("Forest Bond <forest.bond@outpostembedded.com>");
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_VERSION(DRIVER_VERSION);
-MODULE_LICENSE("GPL");
diff --git a/drivers/usb/serial/zio.c b/drivers/usb/serial/zio.c
deleted file mode 100644
index f579672..0000000
--- a/drivers/usb/serial/zio.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * ZIO Motherboard USB driver
- *
- * Copyright (C) 2010 Zilogic Systems <code@zilogic.com>
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License version
- *	2 as published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/tty.h>
-#include <linux/module.h>
-#include <linux/usb.h>
-#include <linux/usb/serial.h>
-#include <linux/uaccess.h>
-
-static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(0x1CBE, 0x0103) },
-	{ },
-};
-MODULE_DEVICE_TABLE(usb, id_table);
-
-static struct usb_driver zio_driver = {
-	.name =		"zio",
-	.probe =	usb_serial_probe,
-	.disconnect =	usb_serial_disconnect,
-	.id_table =	id_table,
-	.no_dynamic_id =	1,
-};
-
-static struct usb_serial_driver zio_device = {
-	.driver = {
-		.owner =	THIS_MODULE,
-		.name =		"zio",
-	},
-	.id_table =		id_table,
-	.usb_driver =		&zio_driver,
-	.num_ports =		1,
-};
-
-static int __init zio_init(void)
-{
-	int retval;
-
-	retval = usb_serial_register(&zio_device);
-	if (retval)
-		return retval;
-	retval = usb_register(&zio_driver);
-	if (retval)
-		usb_serial_deregister(&zio_device);
-	return retval;
-}
-
-static void __exit zio_exit(void)
-{
-	usb_deregister(&zio_driver);
-	usb_serial_deregister(&zio_device);
-}
-
-module_init(zio_init);
-module_exit(zio_exit);
-MODULE_LICENSE("GPL");
-- 
1.7.1

