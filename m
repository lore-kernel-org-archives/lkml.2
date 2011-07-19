Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab1GSUEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:04:05 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:36218 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1GSUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:03:41 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        lm-sensors@lm-sensors.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH 5/5] mtd: move support for TS-5500 MTD
Date: Tue, 19 Jul 2011 16:00:35 -0400
Message-Id: <1311105635-22432-6-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311105635-22432-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1311105635-22432-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the existing driver for the TS-5500 Flash from
drivers/mtd/maps/ts5500_flash.c to arch/x86/platform/ts5500/, to regroup every
TS-5500 drivers under the same platform directory.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 MAINTAINERS                             |    1 +
 arch/x86/platform/ts5500/Kconfig        |   20 +++++
 arch/x86/platform/ts5500/Makefile       |    1 +
 arch/x86/platform/ts5500/ts5500.c       |    5 ++
 arch/x86/platform/ts5500/ts5500_flash.c |  118 ++++++++++++++++++++++++++++++
 drivers/mtd/maps/Kconfig                |   18 -----
 drivers/mtd/maps/Makefile               |    1 -
 drivers/mtd/maps/ts5500_flash.c         |  121 -------------------------------
 8 files changed, 145 insertions(+), 140 deletions(-)
 create mode 100644 arch/x86/platform/ts5500/ts5500_flash.c
 delete mode 100644 drivers/mtd/maps/ts5500_flash.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 967f5cc..5789eca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6145,6 +6145,7 @@ F:  arch/x86/platform/ts5500/ts5500_gpio.h
 F:  arch/x86/platform/ts5500/ts5500_leds.c
 F:  arch/x86/platform/ts5500/ts5500_adc.c
 F:  arch/x86/platform/ts5500/ts5500_adc.h
+F:  arch/x86/platform/ts5500/ts5500_flash.c
 
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
diff --git a/arch/x86/platform/ts5500/Kconfig b/arch/x86/platform/ts5500/Kconfig
index f38c8b6..b7e4cd0 100644
--- a/arch/x86/platform/ts5500/Kconfig
+++ b/arch/x86/platform/ts5500/Kconfig
@@ -6,6 +6,26 @@ config TS5500
 
 	  If you have a TS-5500, say Y here.
 
+config TS5500_MTD
+	tristate "JEDEC Flash device mapped on TS-5500"
+	depends on TS5500 && MTD
+	select MTD_PARTITIONS
+	select MTD_JEDECPROBE
+	select MTD_CFI_AMDSTD
+	select CONFIG_RFD_FTL
+	help
+	  This provides a driver for the on-board flash of the Technologic
+	  System's TS-5500 board. The 2MB flash is split into 3 partitions
+	  which are accessed as separate MTD devices.
+
+	  mtd0 and mtd2 are the two BIOS drives, which use the resident
+	  flash disk (RFD) flash translation layer.
+
+	  mtd1 allows you to reprogram your BIOS. BE VERY CAREFUL.
+
+	  Note that jumper 3 ("Write Enable Drive A") must be set
+	  otherwise detection won't succeed.
+
 config TS5500_GPIO
 	bool "TS-5500 GPIO support"
 	depends on TS5500
diff --git a/arch/x86/platform/ts5500/Makefile b/arch/x86/platform/ts5500/Makefile
index 79b8d10..249f0de 100644
--- a/arch/x86/platform/ts5500/Makefile
+++ b/arch/x86/platform/ts5500/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_TS5500)			+= ts5500.o
 obj-$(CONFIG_TS5500_GPIO)		+= ts5500_gpio.o
 obj-$(CONFIG_TS5500_LEDS)		+= ts5500_leds.o
 obj-$(CONFIG_TS5500_ADC)		+= ts5500_adc.o
+obj-$(CONFIG_TS5500_MTD)		+= ts5500_flash.o
\ No newline at end of file
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index d0c496a..960066ae 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -417,6 +417,11 @@ static int __init ts5500_init(void)
 	if (ret)
 		goto release_pdev;
 
+
+#ifdef CONFIG_TS5500_MTD
+	if (!TS5500_IS_JP_SET(ts5500, 3))
+		pr_warn("Jumper 3 is not set, Flash drive A is read-only.");
+#endif
 	return 0;
 
 release_pdev:
diff --git a/arch/x86/platform/ts5500/ts5500_flash.c b/arch/x86/platform/ts5500/ts5500_flash.c
new file mode 100644
index 0000000..3472e77
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500_flash.c
@@ -0,0 +1,118 @@
+/*
+ * ts5500_flash.c -- MTD map driver for Technology Systems TS-5500 board
+ *
+ * Copyright (C) 2004 Sean Young <sean@mess.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ *
+ * Note:
+ * - In order for detection to work, jumper 3 must be set.
+ * - Drive A and B use the resident flash disk (RFD) flash translation layer.
+ * - If you have created your own jffs file system and the bios overwrites
+ *   it during boot, try disabling Drive A: and B: in the boot order.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/types.h>
+
+#define WINDOW_ADDR	0x09400000
+#define WINDOW_SIZE	0x00200000
+
+static struct map_info ts5500_map = {
+	.name = "TS-5500 Flash",
+	.size = WINDOW_SIZE,
+	.bankwidth = 1,
+	.phys = WINDOW_ADDR
+};
+
+static struct mtd_partition ts5500_partitions[] = {
+	{
+		.name = "Drive A",
+		.offset = 0,
+		.size = 0x0e0000
+	},
+	{
+		.name = "BIOS",
+		.offset = 0x0e0000,
+		.size = 0x020000,
+	},
+	{
+		.name = "Drive B",
+		.offset = 0x100000,
+		.size = 0x100000
+	}
+};
+
+#define NUM_PARTITIONS ARRAY_SIZE(ts5500_partitions)
+
+static struct mtd_info *mymtd;
+
+static int __init init_ts5500_map(void)
+{
+	int rc = 0;
+
+	ts5500_map.virt = ioremap_nocache(ts5500_map.phys, ts5500_map.size);
+
+	if (!ts5500_map.virt) {
+		printk(KERN_ERR "Failed to ioremap_nocache\n");
+		rc = -EIO;
+		goto err2;
+	}
+
+	simple_map_init(&ts5500_map);
+
+	mymtd = do_map_probe("jedec_probe", &ts5500_map);
+	if (!mymtd)
+		mymtd = do_map_probe("map_rom", &ts5500_map);
+
+	if (!mymtd) {
+		rc = -ENXIO;
+		goto err1;
+	}
+
+	mymtd->owner = THIS_MODULE;
+	mtd_device_register(mymtd, ts5500_partitions, NUM_PARTITIONS);
+
+	return 0;
+
+err1:
+	iounmap(ts5500_map.virt);
+err2:
+	return rc;
+}
+module_init(init_ts5500_map);
+
+static void __exit cleanup_ts5500_map(void)
+{
+	if (mymtd) {
+		mtd_device_unregister(mymtd);
+		map_destroy(mymtd);
+	}
+
+	if (ts5500_map.virt) {
+		iounmap(ts5500_map.virt);
+		ts5500_map.virt = NULL;
+	}
+}
+module_exit(cleanup_ts5500_map);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
+MODULE_DESCRIPTION("MTD map driver for Techology Systems TS-5500 board");
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index c0c328c..41cb511 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -127,24 +127,6 @@ config MTD_NETSC520
 	  demonstration board. If you have one of these boards and would like
 	  to use the flash chips on it, say 'Y'.
 
-config MTD_TS5500
-	tristate "JEDEC Flash device mapped on Technologic Systems TS-5500"
-	depends on X86
-	select MTD_JEDECPROBE
-	select MTD_CFI_AMDSTD
-	help
-	  This provides a driver for the on-board flash of the Technologic
-	  System's TS-5500 board. The 2MB flash is split into 3 partitions
-	  which are accessed as separate MTD devices.
-
-	  mtd0 and mtd2 are the two BIOS drives, which use the resident
-	  flash disk (RFD) flash translation layer.
-
-	  mtd1 allows you to reprogram your BIOS. BE VERY CAREFUL.
-
-	  Note that jumper 3 ("Write Enable Drive A") must be set
-	  otherwise detection won't succeed.
-
 config MTD_SBC_GXX
 	tristate "CFI Flash device mapped on Arcom SBC-GXx boards"
 	depends on X86 && MTD_CFI_INTELEXT && MTD_COMPLEX_MAPPINGS
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index cb48b11..f999fa3 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -32,7 +32,6 @@ obj-$(CONFIG_MTD_SA1100)	+= sa1100-flash.o
 obj-$(CONFIG_MTD_SBC_GXX)	+= sbc_gxx.o
 obj-$(CONFIG_MTD_SC520CDP)	+= sc520cdp.o
 obj-$(CONFIG_MTD_NETSC520)	+= netsc520.o
-obj-$(CONFIG_MTD_TS5500)	+= ts5500_flash.o
 obj-$(CONFIG_MTD_SUN_UFLASH)	+= sun_uflash.o
 obj-$(CONFIG_MTD_VMAX)		+= vmax301.o
 obj-$(CONFIG_MTD_SCx200_DOCFLASH)+= scx200_docflash.o
diff --git a/drivers/mtd/maps/ts5500_flash.c b/drivers/mtd/maps/ts5500_flash.c
deleted file mode 100644
index d1d671d..0000000
--- a/drivers/mtd/maps/ts5500_flash.c
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- * ts5500_flash.c -- MTD map driver for Technology Systems TS-5500 board
- *
- * Copyright (C) 2004 Sean Young <sean@mess.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
- *
- * Note:
- * - In order for detection to work, jumper 3 must be set.
- * - Drive A and B use the resident flash disk (RFD) flash translation layer.
- * - If you have created your own jffs file system and the bios overwrites
- *   it during boot, try disabling Drive A: and B: in the boot order.
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
-#include <linux/types.h>
-
-
-#define WINDOW_ADDR	0x09400000
-#define WINDOW_SIZE	0x00200000
-
-static struct map_info ts5500_map = {
-	.name = "TS-5500 Flash",
-	.size = WINDOW_SIZE,
-	.bankwidth = 1,
-	.phys = WINDOW_ADDR
-};
-
-static struct mtd_partition ts5500_partitions[] = {
-	{
-		.name = "Drive A",
-		.offset = 0,
-		.size = 0x0e0000
-	},
-	{
-		.name = "BIOS",
-		.offset = 0x0e0000,
-		.size = 0x020000,
-	},
-	{
-		.name = "Drive B",
-		.offset = 0x100000,
-		.size = 0x100000
-	}
-};
-
-#define NUM_PARTITIONS ARRAY_SIZE(ts5500_partitions)
-
-static struct mtd_info *mymtd;
-
-static int __init init_ts5500_map(void)
-{
-	int rc = 0;
-
-	ts5500_map.virt = ioremap_nocache(ts5500_map.phys, ts5500_map.size);
-
-	if (!ts5500_map.virt) {
-		printk(KERN_ERR "Failed to ioremap_nocache\n");
-		rc = -EIO;
-		goto err2;
-	}
-
-	simple_map_init(&ts5500_map);
-
-	mymtd = do_map_probe("jedec_probe", &ts5500_map);
-	if (!mymtd)
-		mymtd = do_map_probe("map_rom", &ts5500_map);
-
-	if (!mymtd) {
-		rc = -ENXIO;
-		goto err1;
-	}
-
-	mymtd->owner = THIS_MODULE;
-	mtd_device_register(mymtd, ts5500_partitions, NUM_PARTITIONS);
-
-	return 0;
-
-err1:
-	iounmap(ts5500_map.virt);
-err2:
-	return rc;
-}
-
-static void __exit cleanup_ts5500_map(void)
-{
-	if (mymtd) {
-		mtd_device_unregister(mymtd);
-		map_destroy(mymtd);
-	}
-
-	if (ts5500_map.virt) {
-		iounmap(ts5500_map.virt);
-		ts5500_map.virt = NULL;
-	}
-}
-
-module_init(init_ts5500_map);
-module_exit(cleanup_ts5500_map);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Sean Young <sean@mess.org>");
-MODULE_DESCRIPTION("MTD map driver for Techology Systems TS-5500 board");
-
-- 
1.7.6

