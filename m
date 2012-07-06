Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2GFJft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:35:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35619 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2GFJfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:35:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Register the AB8500 from DB8500 MFD
Date: Fri,  6 Jul 2012 10:35:40 +0100
Message-Id: <1341567340-5800-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the AB8500 is a subordinate MFD device to the DB8500-PRCMU,
for consistency and a better 1:1 depiction of how the hardware
is laid out, it is a good idea to register it in the same way
as we do for the other MFD child devices. In order for us to do
this successfully we have to pass AB8500's platform data when
registering the DB8500-PRCMU from platform code.

Also solves this issue:
WARNING: at fs/sysfs/dir.c:526 sysfs_add_one+0x88/0xb0()
sysfs: cannot create duplicate filename '/bus/platform/devices/ab8500-core.0'

Reported-by: Linus Walleij <linus.walleij@linaro.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c       |   27 +++------------------------
 arch/arm/mach-ux500/cpu-db8500.c         |    7 +++++--
 arch/arm/mach-ux500/include/mach/setup.h |    3 ++-
 drivers/mfd/db8500-prcmu.c               |   10 +++++++++-
 4 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index ac762bd..c2a7270 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -211,24 +211,6 @@ static struct ab8500_platform_data ab8500_platdata = {
 	.codec		= &ab8500_codec_pdata,
 };
 
-static struct resource ab8500_resources[] = {
-	[0] = {
-		.start	= IRQ_DB8500_AB8500,
-		.end	= IRQ_DB8500_AB8500,
-		.flags	= IORESOURCE_IRQ
-	}
-};
-
-struct platform_device ab8500_device = {
-	.name = "ab8500-core",
-	.id = 0,
-	.dev = {
-		.platform_data = &ab8500_platdata,
-	},
-	.num_resources = 1,
-	.resource = ab8500_resources,
-};
-
 /*
  * TPS61052
  */
@@ -443,7 +425,6 @@ static struct hash_platform_data u8500_hash1_platform_data = {
 /* add any platform devices here - TODO */
 static struct platform_device *mop500_platform_devs[] __initdata = {
 	&mop500_gpio_keys_device,
-	&ab8500_device,
 };
 
 #ifdef CONFIG_STE_DMA40
@@ -605,7 +586,6 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
 	&snowball_led_dev,
 	&snowball_key_dev,
 	&snowball_sbnet_dev,
-	&ab8500_device,
 };
 
 static void __init mop500_init_machine(void)
@@ -617,9 +597,8 @@ static void __init mop500_init_machine(void)
 	mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
 
 	mop500_pinmaps_init();
-	parent = u8500_init_devices();
+	parent = u8500_init_devices(&ab8500_platdata);
 
-	/* FIXME: parent of ab8500 should be prcmu */
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
 
@@ -652,7 +631,7 @@ static void __init snowball_init_machine(void)
 	int i;
 
 	snowball_pinmaps_init();
-	parent = u8500_init_devices();
+	parent = u8500_init_devices(&ab8500_platdata);
 
 	for (i = 0; i < ARRAY_SIZE(snowball_platform_devs); i++)
 		snowball_platform_devs[i]->dev.parent = parent;
@@ -684,7 +663,7 @@ static void __init hrefv60_init_machine(void)
 	mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
 
 	hrefv60_pinmaps_init();
-	parent = u8500_init_devices();
+	parent = u8500_init_devices(&ab8500_platdata);
 
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index a12bd9e..aab96ca 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -16,6 +16,7 @@
 #include <linux/irq.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/mfd/abx500/ab8500.h>
 
 #include <asm/mach/map.h>
 #include <asm/pmu.h>
@@ -115,7 +116,7 @@ static irqreturn_t db8500_pmu_handler(int irq, void *dev, irq_handler_t handler)
 	return ret;
 }
 
-static struct arm_pmu_platdata db8500_pmu_platdata = {
+struct arm_pmu_platdata db8500_pmu_platdata = {
 	.handle_irq		= db8500_pmu_handler,
 };
 
@@ -207,7 +208,7 @@ static struct device * __init db8500_soc_device_init(void)
 /*
  * This function is called from the board init
  */
-struct device * __init u8500_init_devices(void)
+struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500)
 {
 	struct device *parent;
 	int i;
@@ -224,6 +225,8 @@ struct device * __init u8500_init_devices(void)
 	for (i = 0; i < ARRAY_SIZE(platform_devs); i++)
 		platform_devs[i]->dev.parent = parent;
 
+	db8500_prcmu_device.dev.platform_data = ab8500;
+
 	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
 
 	return parent;
diff --git a/arch/arm/mach-ux500/include/mach/setup.h b/arch/arm/mach-ux500/include/mach/setup.h
index 8b7ed82..7914e5e 100644
--- a/arch/arm/mach-ux500/include/mach/setup.h
+++ b/arch/arm/mach-ux500/include/mach/setup.h
@@ -13,11 +13,12 @@
 
 #include <asm/mach/time.h>
 #include <linux/init.h>
+#include <linux/mfd/abx500/ab8500.h>
 
 void __init ux500_map_io(void);
 extern void __init u8500_map_io(void);
 
-extern struct device * __init u8500_init_devices(void);
+extern struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500);
 
 extern void __init ux500_init_irq(void);
 extern void __init ux500_init_late(void);
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index f4adcab..4050a1e 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -28,6 +28,7 @@
 #include <linux/uaccess.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/dbx500-prcmu.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/db8500-prcmu.h>
 #include <linux/regulator/machine.h>
 #include <asm/hardware/gic.h>
@@ -2972,8 +2973,9 @@ static struct mfd_cell db8500_prcmu_devs[] = {
  */
 static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 {
+	struct ab8500_platform_data *ab8500_platdata = pdev->dev.platform_data;
 	struct device_node *np = pdev->dev.of_node;
-	int irq = 0, err = 0;
+	int irq = 0, err = 0, i;
 
 	if (ux500_is_svp())
 		return -ENODEV;
@@ -2997,6 +2999,12 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 		goto no_irq_return;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(db8500_prcmu_devs); i++) {
+		if (!strcmp(db8500_prcmu_devs[i].name, "ab8500-core")) {
+			db8500_prcmu_devs[i].platform_data = ab8500_platdata;
+		}
+	}
+
 	if (cpu_is_u8500v20_or_later())
 		prcmu_config_esram0_deep_sleep(ESRAM0_DEEP_SLEEP_STATE_RET);
 
-- 
1.7.9.5

