Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab1BKBx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:53:28 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:57287 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1BKBx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:53:27 -0500
Date: Thu, 10 Feb 2011 17:53:24 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 06/10] olpc_dcon: add config options for XO_1 and XO_1_5,
 drop hardcoded XO-1 stuff
Message-ID: <20110210175324.6d40a5ca@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds CONFIG_FB_OLPC_DCON_1 and CONFIG_FB_OLPC_DCON_1_5 options for
allowing selection of XO-1 and/or XO-1.5 DCON support.  In the process,
it also forces the xo_1.c and xo_1_5.c files to build as separate units,
correctly selects between XO-1 and XO-1.5 at runtime, and adds some
hacks to allow xo_1_5.c to build.

This isn't the cleanest patch, but it'll get better as more global
variables are dropped.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/Kconfig            |   20 +++++++++++++++
 drivers/staging/olpc_dcon/Makefile           |    7 ++++-
 drivers/staging/olpc_dcon/olpc_dcon.c        |   34 +++++++++++++-------------
 drivers/staging/olpc_dcon/olpc_dcon.h        |   22 ++++++++++++++++
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c   |    2 +-
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c |   18 +++++++++++--
 6 files changed, 81 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/olpc_dcon/Kconfig b/drivers/staging/olpc_dcon/Kconfig
index 8be8716..982273c 100644
--- a/drivers/staging/olpc_dcon/Kconfig
+++ b/drivers/staging/olpc_dcon/Kconfig
@@ -6,3 +6,23 @@ config FB_OLPC_DCON
 	  Add support for the OLPC XO DCON controller.  This controller is
 	  only available on OLPC platforms.   Unless you have one of these
 	  platforms, you will want to say 'N'.
+
+config FB_OLPC_DCON_1
+	bool "OLPC XO-1 DCON support"
+	depends on FB_OLPC_DCON
+	default y
+	---help---
+	  Enable support for the DCON in XO-1 model laptops.  The kernel
+	  communicates with the DCON using model-specific code.  If you
+	  have an XO-1 (or if you're unsure what model you have), you should
+	  say 'Y'.
+
+config FB_OLPC_DCON_1_5
+	bool "OLPC XO-1.5 DCON support"
+	depends on FB_OLPC_DCON
+	default y
+	---help---
+	  Enable support for the DCON in XO-1.5 model laptops.  The kernel
+	  communicates with the DCON using model-specific code.  If you
+	  have an XO-1.5 (or if you're unsure what model you have), you
+	  should say 'Y'.
diff --git a/drivers/staging/olpc_dcon/Makefile b/drivers/staging/olpc_dcon/Makefile
index cd8f289..36c7e67 100644
--- a/drivers/staging/olpc_dcon/Makefile
+++ b/drivers/staging/olpc_dcon/Makefile
@@ -1 +1,6 @@
-obj-$(CONFIG_FB_OLPC_DCON)	+= olpc_dcon.o
+olpc-dcon-objs += olpc_dcon.o
+olpc-dcon-$(CONFIG_FB_OLPC_DCON_1)	+= olpc_dcon_xo_1.o
+olpc-dcon-$(CONFIG_FB_OLPC_DCON_1_5)	+= olpc_dcon_xo_1_5.o
+obj-$(CONFIG_FB_OLPC_DCON)	+= olpc-dcon.o
+
+
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 52b7b30..96b6fd2 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -4,7 +4,7 @@
  * Copyright © 2006-2007  Red Hat, Inc.
  * Copyright © 2006-2007  Advanced Micro Devices, Inc.
  * Copyright © 2009       VIA Technology, Inc.
- * Copyright (c) 2010  Andres Salomon <dilinger@queued.net>
+ * Copyright (c) 2010-2011  Andres Salomon <dilinger@queued.net>
  *
  * This program is free software.  You can redistribute it and/or
  * modify it under the terms of version 2 of the GNU General Public
@@ -44,13 +44,6 @@ module_param(noinit, int, 0444);
 static int useaa = 1;
 module_param(useaa, int, 0444);
 
-struct dcon_platform_data {
-	int (*init)(void);
-	void (*bus_stabilize_wiggle)(void);
-	void (*set_dconload)(int);
-	u8 (*read_status)(void);
-};
-
 static struct dcon_platform_data *pdata;
 
 struct dcon_priv {
@@ -73,8 +66,6 @@ struct dcon_priv {
 
 /* I2C structures */
 
-static struct i2c_driver dcon_driver;
-
 /* Platform devices */
 static struct platform_device *dcon_device;
 
@@ -82,10 +73,10 @@ static struct platform_device *dcon_device;
 static struct backlight_device *dcon_bl_dev;
 
 /* Current source, initialized at probe time */
-static int dcon_source;
+int dcon_source;
 
 /* Desired source */
-static int dcon_pending;
+int dcon_pending;
 
 /* Variables used during switches */
 static int dcon_switched;
@@ -693,6 +684,9 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	struct dcon_priv *dcon;
 	int rc, i, j;
 
+	if (!pdata)
+		return -ENXIO;
+
 	dcon = kzalloc(sizeof(*dcon), GFP_KERNEL);
 	if (!dcon)
 		return -ENOMEM;
@@ -830,7 +824,7 @@ static int dcon_resume(struct i2c_client *client)
 #endif
 
 
-static irqreturn_t dcon_interrupt(int irq, void *id)
+irqreturn_t dcon_interrupt(int irq, void *id)
 {
 	int status = pdata->read_status();
 
@@ -877,7 +871,7 @@ static const struct i2c_device_id dcon_idtable[] = {
 
 MODULE_DEVICE_TABLE(i2c, dcon_idtable);
 
-static struct i2c_driver dcon_driver = {
+struct i2c_driver dcon_driver = {
 	.driver = {
 		.name	= "olpc_dcon",
 	},
@@ -893,11 +887,17 @@ static struct i2c_driver dcon_driver = {
 #endif
 };
 
-#include "olpc_dcon_xo_1.c"
-
 static int __init olpc_dcon_init(void)
 {
-	pdata = &dcon_pdata_xo_1;
+#ifdef CONFIG_FB_OLPC_DCON_1_5
+	/* XO-1.5 */
+	if (olpc_board_at_least(olpc_board(0xd0)))
+		pdata = &dcon_pdata_xo_1_5;
+#endif
+#ifdef CONFIG_FB_OLPC_DCON_1
+	if (!pdata)
+		pdata = &dcon_pdata_xo_1;
+#endif
 
 	return i2c_add_driver(&dcon_driver);
 }
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index cef2473..03ac42c 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -44,4 +44,26 @@
 /* Interrupt */
 #define DCON_IRQ                6
 
+struct dcon_platform_data {
+	int (*init)(void);
+	void (*bus_stabilize_wiggle)(void);
+	void (*set_dconload)(int);
+	u8 (*read_status)(void);
+};
+
+#include <linux/interrupt.h>
+
+extern int dcon_source;
+extern int dcon_pending;
+extern irqreturn_t dcon_interrupt(int irq, void *id);
+extern struct i2c_driver dcon_driver;
+
+#ifdef CONFIG_FB_OLPC_DCON_1
+extern struct dcon_platform_data dcon_pdata_xo_1;
+#endif
+
+#ifdef CONFIG_FB_OLPC_DCON_1_5
+extern struct dcon_platform_data dcon_pdata_xo_1_5;
+#endif
+
 #endif
diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
index 043198d..be52b6c 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -195,7 +195,7 @@ static u8 dcon_read_status_xo_1(void)
 	return status;
 }
 
-static struct dcon_platform_data dcon_pdata_xo_1 = {
+struct dcon_platform_data dcon_pdata_xo_1 = {
 	.init = dcon_init_xo_1,
 	.bus_stabilize_wiggle = dcon_wiggle_xo_1,
 	.set_dconload = dcon_set_dconload_1,
diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
index 5ef0540..d4c2d74 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
@@ -7,6 +7,20 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/pci.h>
+#include <linux/gpio.h>
+#include <asm/olpc.h>
+
+/* TODO: this eventually belongs in linux/vx855.h */
+#define NR_VX855_GPI    14
+#define NR_VX855_GPO    13
+#define NR_VX855_GPIO   15
+
+#define VX855_GPI(n)    (n)
+#define VX855_GPO(n)    (NR_VX855_GPI + (n))
+#define VX855_GPIO(n)   (NR_VX855_GPI + NR_VX855_GPO + (n))
+
+#include "olpc_dcon.h"
 
 /* Hardware setup on the XO 1.5:
  * 	DCONLOAD connects to
@@ -26,8 +40,6 @@
 
 #define PREFIX "OLPC DCON:"
 
-static struct dcon_platform_data dcon_pdata_xo_1_5;
-
 static void dcon_clear_irq(void)
 {
 	/* irq status will appear in PMIO_Rx50[6] (RW1C) on gpio12 */
@@ -173,7 +185,7 @@ static u8 dcon_read_status_xo_1_5(void)
 	return status;
 }
 
-static struct dcon_platform_data dcon_pdata_xo_1_5 = {
+struct dcon_platform_data dcon_pdata_xo_1_5 = {
 	.init = dcon_init_xo_1_5,
 	.bus_stabilize_wiggle = dcon_wiggle_xo_1_5,
 	.set_dconload = dcon_set_dconload_xo_1_5,
-- 
1.7.2.3

