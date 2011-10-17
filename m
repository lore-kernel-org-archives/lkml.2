Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1JQLxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:53:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46258 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1JQLxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:53:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linus.walleij@stericsson.com, jamie@jamieiles.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/6] mach-ux500: export System-on-Chip information ux500 via sysfs
Date: Mon, 17 Oct 2011 12:52:56 +0100
Message-Id: <1318852378-14180-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we make use of the new System-On-Chip bus driver to export
vital SoC information out to userspace via sysfs. This patch
provides a data structure of strings to populate the base
nodes found in:

/sys/devices/soc[0|1|2|...]/[family|machine|revision|soc_id].

It also adds one more node as requested by ST-Ericsson.
'process' depicts the way in which the silicon was manufactured.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/Kconfig                    |    1 +
 arch/arm/mach-ux500/cpu-db5500.c               |   32 +++++++++---
 arch/arm/mach-ux500/cpu-db8500.c               |   36 ++++++++++---
 arch/arm/mach-ux500/cpu.c                      |   67 ++++++++++++++++++++++++
 arch/arm/mach-ux500/include/mach/db8500-regs.h |    3 +
 arch/arm/mach-ux500/include/mach/setup.h       |    6 ++-
 6 files changed, 128 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 86188b2..1c462ed 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -27,6 +27,7 @@ config MACH_U8500
 	bool "U8500 Development platform"
 	depends on UX500_SOC_DB8500
 	select TPS6105X
+	select SOC_BUS
 	help
 	  Include support for the mop500 development platform.
 
diff --git a/arch/arm/mach-ux500/cpu-db5500.c b/arch/arm/mach-ux500/cpu-db5500.c
index 3995284..6bbc9da 100644
--- a/arch/arm/mach-ux500/cpu-db5500.c
+++ b/arch/arm/mach-ux500/cpu-db5500.c
@@ -220,17 +220,33 @@ static int usb_db5500_tx_dma_cfg[] = {
 	DB5500_DMA_DEV38_USB_OTG_OEP_8
 };
 
-struct device* __init u5500_init_devices(void)
+static const char *db5500_read_soc_id(void)
 {
-	/* FIXME: First parameter to be a real parent. */
-	db5500_add_gpios(NULL);
-	db5500_dma_init(NULL);
-	db5500_add_rtc(NULL);
-	db5500_add_usb(NULL, usb_db5500_rx_dma_cfg, usb_db5500_tx_dma_cfg);
+	return kasprintf(GFP_KERNEL, "u5500 currently unsupported\n");
+}
+
+static struct device * __init db5500_soc_device_init(void)
+{
+	const char *soc_id = db5500_read_soc_id();
+
+	return ux500_soc_device_init(soc_id);
+}
+
+struct device * __init u5500_init_devices(void)
+{
+	struct device *parent;
+	int i;
+
+	parent = db5500_soc_device_init();
+
+	db5500_add_gpios(parent);
+	db5500_dma_init(parent);
+	db5500_add_rtc(parent);
+	db5500_add_usb(parent, usb_db5500_rx_dma_cfg,
+		usb_db5500_tx_dma_cfg);
 
 	platform_add_devices(db5500_platform_devs,
 			     ARRAY_SIZE(db5500_platform_devs));
 
-	/* FIXME: Return value to be a real parent. */
-	return NULL;
+	return parent;
 }
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 375171e..c83440b 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -24,6 +24,7 @@
 #include <mach/setup.h>
 #include <mach/devices.h>
 #include <mach/usb.h>
+#include <mach/db8500-regs.h>
 
 #include "devices-db8500.h"
 #include "ste-dma40-db8500.h"
@@ -188,22 +189,43 @@ static int usb_db8500_tx_dma_cfg[] = {
 	DB8500_DMA_DEV39_USB_OTG_OEP_8
 };
 
+static const char *db8500_read_soc_id(void)
+{
+	void __iomem *uid = __io_address(U8500_BB_UID_BASE);
+
+	return kasprintf(GFP_KERNEL, "%08x%08x%08x%08x%08x",
+			 readl((u32 *)uid+1),
+			 readl((u32 *)uid+1), readl((u32 *)uid+2),
+			 readl((u32 *)uid+3), readl((u32 *)uid+4));
+}
+
+static struct device * __init db8500_soc_device_init(void)
+{
+	const char *soc_id = db8500_read_soc_id();
+
+	return ux500_soc_device_init(soc_id);
+}
+
 /*
  * This function is called from the board init
  */
-struct device* __init u8500_init_devices(void)
+struct device * __init u8500_init_devices(void)
 {
+	struct device *parent;
+	int i;
+
+	parent = db8500_soc_device_init();
+
 	if (cpu_is_u8500ed())
 		dma40_u8500ed_fixup();
 
-	/* FIXME: First parameter to be a real parent. */
-	db8500_add_rtc(NULL);
-	db8500_add_gpios(NULL);
-	db8500_add_usb(NULL, usb_db8500_rx_dma_cfg, usb_db8500_tx_dma_cfg);
+	db8500_add_rtc(parent);
+	db8500_add_gpios(parent);
+	db8500_add_usb(parent, usb_db8500_rx_dma_cfg,
+		usb_db8500_tx_dma_cfg);
 
 	platform_device_register_simple("cpufreq-u8500", -1, NULL, 0);
 	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
 
-	/* FIXME: Return value to be a real parent. */
-	return NULL;
+	return parent;
 }
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index b457799..3315436 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -2,6 +2,7 @@
  * Copyright (C) ST-Ericsson SA 2010
  *
  * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ * Author: Lee Jones <lee.jones@linaro.org> for ST-Ericsson
  * License terms: GNU General Public License (GPL) version 2
  */
 
@@ -10,6 +11,9 @@
 #include <linux/clk.h>
 #include <linux/mfd/db8500-prcmu.h>
 #include <linux/mfd/db5500-prcmu.h>
+#include <linux/sys_soc.h>
+#include <linux/err.h>
+#include <linux/slab.h>
 
 #include <asm/hardware/gic.h>
 #include <asm/mach/map.h>
@@ -77,3 +81,66 @@ static void __init ux500_timer_init(void)
 struct sys_timer ux500_timer = {
 	.init	= ux500_timer_init,
 };
+
+static const char * __init ux500_get_machine(void)
+{
+	return kasprintf(GFP_KERNEL, "DB%4x", dbx500_partnumber());
+}
+
+static const char * __init ux500_get_family(void)
+{
+	return kasprintf(GFP_KERNEL, "ux500");
+}
+
+static const char * __init ux500_get_revision(void)
+{
+	unsigned int rev = dbx500_revision();
+
+	if (rev == 0x01)
+		return kasprintf(GFP_KERNEL, "%s", "ED");
+	else if (rev >= 0xA0)
+		return kasprintf(GFP_KERNEL, "%d.%d",
+				 (rev >> 4) - 0xA + 1, rev & 0xf);
+
+	return kasprintf(GFP_KERNEL, "%s", "Unknown");
+}
+
+static ssize_t __init ux500_get_process(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	if (dbx500_id.process == 0x00)
+		return sprintf(buf, "Standard\n");
+
+	return sprintf(buf, "%02xnm\n", dbx500_id.process);
+}
+
+static void __init soc_info_populate(struct soc_device_attribute *soc_dev_attr,
+				     const char *soc_id)
+{
+	soc_dev_attr->soc_id   = soc_id;
+	soc_dev_attr->machine  = ux500_get_machine();
+	soc_dev_attr->family   = ux500_get_family();
+	soc_dev_attr->revision = ux500_get_revision();
+}
+
+struct device_attribute ux500_soc_attr =
+	__ATTR(process,  S_IRUGO, ux500_get_process,  NULL);
+
+struct device * __init ux500_soc_device_init(const char *soc_id)
+{
+	struct device *parent;
+	struct soc_device_attribute *soc_dev_attr;
+
+	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	if (!soc_dev_attr)
+		return ERR_PTR(-ENOMEM);
+
+	soc_info_populate(soc_dev_attr, soc_id);
+
+	parent = soc_device_register(soc_dev_attr);
+	if (!IS_ERR_OR_NULL(parent))
+		device_create_file(parent, &ux500_soc_attr);
+
+	return parent;
+}
diff --git a/arch/arm/mach-ux500/include/mach/db8500-regs.h b/arch/arm/mach-ux500/include/mach/db8500-regs.h
index 0499971..22a9a5d 100644
--- a/arch/arm/mach-ux500/include/mach/db8500-regs.h
+++ b/arch/arm/mach-ux500/include/mach/db8500-regs.h
@@ -166,4 +166,7 @@
 #define U8500_MODEM_BASE	0xe000000
 #define U8500_APE_BASE		0x6000000
 
+/* SoC identification number information */
+#define U8500_BB_UID_BASE      (U8500_BACKUPRAM1_BASE + 0xFC0)
+
 #endif
diff --git a/arch/arm/mach-ux500/include/mach/setup.h b/arch/arm/mach-ux500/include/mach/setup.h
index 88e8d6b..74b43bb 100644
--- a/arch/arm/mach-ux500/include/mach/setup.h
+++ b/arch/arm/mach-ux500/include/mach/setup.h
@@ -18,8 +18,8 @@ void __init ux500_map_io(void);
 extern void __init u5500_map_io(void);
 extern void __init u8500_map_io(void);
 
-extern void __init u5500_init_devices(void);
-extern void __init u8500_init_devices(void);
+extern struct device * __init u5500_init_devices(void);
+extern struct device * __init u8500_init_devices(void);
 
 extern void __init ux500_init_irq(void);
 
@@ -27,6 +27,8 @@ extern void __init u5500_sdi_init(struct device *parent);
 
 extern void __init db5500_dma_init(struct device *parent);
 
+extern struct device *ux500_soc_device_init(const char *soc_id);
+
 /* We re-use nomadik_timer for this platform */
 extern void nmdk_timer_init(void);
 
-- 
1.7.5.4

