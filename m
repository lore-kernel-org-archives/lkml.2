Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162050Ab2CSQT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:19:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62300 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031388Ab2CSQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:13:21 -0400
From: jean.pihet@newoldbits.com
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 2/9] ARM: OMAP2+: SmartReflex: move the driver specific macros in include/linux/power
Date: Mon, 19 Mar 2012 17:12:51 +0100
Message-Id: <1332173578-27422-3-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Move the driver specific macros from the smartreflex header file
(arch/arm/mach-omap2/smartreflex.h) in a new header file
include/linux/power/smartreflex.h.

This change makes the SmartReflex implementation ready for the move
to drivers/.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    4 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    3 +-
 arch/arm/mach-omap2/smartreflex.c          |    2 +-
 arch/arm/mach-omap2/smartreflex.h          |   42 -----------------
 arch/arm/mach-omap2/sr_device.c            |    2 +-
 include/linux/power/smartreflex.h          |   67 ++++++++++++++++++++++++++++
 6 files changed, 72 insertions(+), 48 deletions(-)
 create mode 100644 include/linux/power/smartreflex.h

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 0cc6a40..d7d4c70 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -13,6 +13,8 @@
  *
  * XXX these should be marked initdata for multi-OMAP kernels
  */
+#include <linux/power/smartreflex.h>
+
 #include <plat/omap_hwmod.h>
 #include <mach/irqs.h>
 #include <plat/cpu.h>
@@ -28,8 +30,6 @@
 #include <plat/dmtimer.h>
 
 #include "omap_hwmod_common_data.h"
-
-#include "smartreflex.h"
 #include "prm-regbits-34xx.h"
 #include "cm-regbits-34xx.h"
 #include "wd_timer.h"
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 48e5834..31e7b87 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/io.h>
+#include <linux/power/smartreflex.h>
 
 #include <plat/omap_hwmod.h>
 #include <plat/cpu.h>
@@ -32,8 +33,6 @@
 #include <plat/common.h>
 
 #include "omap_hwmod_common_data.h"
-
-#include "smartreflex.h"
 #include "cm1_44xx.h"
 #include "cm2_44xx.h"
 #include "prm44xx.h"
diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 008fbd7..33e2825 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -25,9 +25,9 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/power/smartreflex.h>
 
 #include "common.h"
-
 #include "pm.h"
 #include "smartreflex.h"
 
diff --git a/arch/arm/mach-omap2/smartreflex.h b/arch/arm/mach-omap2/smartreflex.h
index c4e8530..8835422 100644
--- a/arch/arm/mach-omap2/smartreflex.h
+++ b/arch/arm/mach-omap2/smartreflex.h
@@ -152,14 +152,6 @@ struct omap_sr_pmic_data {
 	void (*sr_pmic_init) (void);
 };
 
-/**
- * struct omap_smartreflex_dev_attr - Smartreflex Device attribute.
- *
- * @sensor_voltdm_name:       Name of voltdomain of SR instance
- */
-struct omap_smartreflex_dev_attr {
-	const char      *sensor_voltdm_name;
-};
 
 #ifdef CONFIG_OMAP_SMARTREFLEX
 /*
@@ -194,40 +186,6 @@ struct omap_sr_class_data {
 	u8 class_type;
 };
 
-/**
- * struct omap_sr_nvalue_table	- Smartreflex n-target value info
- *
- * @efuse_offs:	The offset of the efuse where n-target values are stored.
- * @nvalue:	The n-target value.
- */
-struct omap_sr_nvalue_table {
-	u32 efuse_offs;
-	u32 nvalue;
-};
-
-/**
- * struct omap_sr_data - Smartreflex platform data.
- *
- * @ip_type:		Smartreflex IP type.
- * @senp_mod:		SENPENABLE value for the sr
- * @senn_mod:		SENNENABLE value for sr
- * @nvalue_count:	Number of distinct nvalues in the nvalue table
- * @enable_on_init:	whether this sr module needs to enabled at
- *			boot up or not.
- * @nvalue_table:	table containing the  efuse offsets and nvalues
- *			corresponding to them.
- * @voltdm:		Pointer to the voltage domain associated with the SR
- */
-struct omap_sr_data {
-	int				ip_type;
-	u32				senp_mod;
-	u32				senn_mod;
-	int				nvalue_count;
-	bool				enable_on_init;
-	struct omap_sr_nvalue_table	*nvalue_table;
-	struct voltagedomain		*voltdm;
-};
-
 /* Smartreflex module enable/disable interface */
 void omap_sr_enable(struct voltagedomain *voltdm);
 void omap_sr_disable(struct voltagedomain *voltdm);
diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index a503e1e..86e438e 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -17,6 +17,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/power/smartreflex.h>
 
 #include <linux/err.h>
 #include <linux/slab.h>
@@ -24,7 +25,6 @@
 
 #include <plat/omap_device.h>
 
-#include "smartreflex.h"
 #include "voltage.h"
 #include "control.h"
 #include "pm.h"
diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
new file mode 100644
index 0000000..4a15640
--- /dev/null
+++ b/include/linux/power/smartreflex.h
@@ -0,0 +1,67 @@
+/*
+ * OMAP Smartreflex Defines and Routines
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ * Jean Pihet <j-pihet@ti.com>
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ * Kalle Jokiniemi
+ *
+ * Copyright (C) 2007 Texas Instruments, Inc.
+ * Lesly A M <x0080970@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __POWER_SMARTREFLEX_H
+#define __POWER_SMARTREFLEX_H
+
+#include <linux/types.h>
+
+#include <plat/voltage.h>
+
+/**
+ * struct omap_sr_nvalue_table	- Smartreflex n-target value info
+ *
+ * @efuse_offs:	The offset of the efuse where n-target values are stored.
+ * @nvalue:	The n-target value.
+ */
+struct omap_sr_nvalue_table {
+	u32 efuse_offs;
+	u32 nvalue;
+};
+
+/**
+ * struct omap_sr_data - Smartreflex platform data.
+ *
+ * @ip_type:		Smartreflex IP type.
+ * @senp_mod:		SENPENABLE value for the sr
+ * @senn_mod:		SENNENABLE value for sr
+ * @nvalue_count:	Number of distinct nvalues in the nvalue table
+ * @enable_on_init:	whether this sr module needs to enabled at
+ *			boot up or not.
+ * @nvalue_table:	table containing the  efuse offsets and nvalues
+ *			corresponding to them.
+ * @voltdm:		Pointer to the voltage domain associated with the SR
+ */
+struct omap_sr_data {
+	int				ip_type;
+	u32				senp_mod;
+	u32				senn_mod;
+	int				nvalue_count;
+	bool				enable_on_init;
+	struct omap_sr_nvalue_table	*nvalue_table;
+	struct voltagedomain		*voltdm;
+};
+
+/**
+ * struct omap_smartreflex_dev_attr - Smartreflex Device attribute.
+ *
+ * @sensor_voltdm_name:       Name of voltdomain of SR instance
+ */
+struct omap_smartreflex_dev_attr {
+	const char      *sensor_voltdm_name;
+};
+
+#endif
-- 
1.7.5.4

