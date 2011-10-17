Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab1JQLxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:53:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44300 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1JQLxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:53:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linus.walleij@stericsson.com, jamie@jamieiles.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/6] mach-ux500: move top level platform devices in sysfs to /sys/devices/socX
Date: Mon, 17 Oct 2011 12:52:57 +0100
Message-Id: <1318852378-14180-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the request of Arnd Bergmann this patch moves all SoC
platform devices found in sysfs from /sys/devices/platform to
/sys/devices/soc<SoCNum>/. It is believed as the devices are
SoC specific and a /sys/devices/soc node has recently
become available, that this would be a more appropriate place to
display the data.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c   |   12 ++++++++++++
 arch/arm/mach-ux500/board-u5500.c    |    4 ++++
 arch/arm/mach-ux500/cpu-db5500.c     |    3 +++
 arch/arm/mach-ux500/cpu-db8500.c     |    7 ++++++-
 arch/arm/mach-ux500/devices-common.c |   13 ++++++++++---
 arch/arm/mach-ux500/usb.c            |    3 +++
 6 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 2d4a7de..3a5b32e 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -608,6 +608,7 @@ static void __init mop500_init_machine(void)
 {
 	struct device *parent = NULL;
 	int i2c0_devs;
+	int i;
 
 	mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
 
@@ -615,6 +616,9 @@ static void __init mop500_init_machine(void)
 
 	mop500_pins_init();
 
+	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
+		mop500_platform_devs[i]->dev.parent = parent;
+
 	platform_add_devices(mop500_platform_devs,
 			ARRAY_SIZE(mop500_platform_devs));
 
@@ -637,11 +641,15 @@ static void __init snowball_init_machine(void)
 {
 	struct device *parent = NULL;
 	int i2c0_devs;
+	int i;
 
 	parent = u8500_init_devices();
 
 	snowball_pins_init();
 
+	for (i = 0; i < ARRAY_SIZE(snowball_platform_devs); i++)
+		snowball_platform_devs[i]->dev.parent = parent;
+
 	platform_add_devices(snowball_platform_devs,
 			ARRAY_SIZE(snowball_platform_devs));
 
@@ -663,6 +671,7 @@ static void __init hrefv60_init_machine(void)
 {
 	struct device *parent = NULL;
 	int i2c0_devs;
+	int i;
 
 	/*
 	 * The HREFv60 board removed a GPIO expander and routed
@@ -675,6 +684,9 @@ static void __init hrefv60_init_machine(void)
 
 	hrefv60_pins_init();
 
+	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
+		mop500_platform_devs[i]->dev.parent = parent;
+
 	platform_add_devices(mop500_platform_devs,
 			ARRAY_SIZE(mop500_platform_devs));
 
diff --git a/arch/arm/mach-ux500/board-u5500.c b/arch/arm/mach-ux500/board-u5500.c
index 3196b40a..6648c56 100644
--- a/arch/arm/mach-ux500/board-u5500.c
+++ b/arch/arm/mach-ux500/board-u5500.c
@@ -135,6 +135,7 @@ static void __init u5500_uart_init(struct device *parent)
 static void __init u5500_init_machine(void)
 {
 	struct device *parent = NULL;
+	int i;
 
 	parent = u5500_init_devices();
 	nmk_config_pins(u5500_pins, ARRAY_SIZE(u5500_pins));
@@ -143,6 +144,9 @@ static void __init u5500_init_machine(void)
 	u5500_sdi_init(parent);
 	u5500_uart_init(parent);
 
+	for (i = 0; i < ARRAY_SIZE(u5500_platform_devices); i++)
+		u5500_platform_devices[i]->dev.parent = parent;
+
 	platform_add_devices(u5500_platform_devices,
 		ARRAY_SIZE(u5500_platform_devices));
 }
diff --git a/arch/arm/mach-ux500/cpu-db5500.c b/arch/arm/mach-ux500/cpu-db5500.c
index 6bbc9da..067ad27 100644
--- a/arch/arm/mach-ux500/cpu-db5500.c
+++ b/arch/arm/mach-ux500/cpu-db5500.c
@@ -245,6 +245,9 @@ struct device * __init u5500_init_devices(void)
 	db5500_add_usb(parent, usb_db5500_rx_dma_cfg,
 		usb_db5500_tx_dma_cfg);
 
+	for (i = 0; i < ARRAY_SIZE(db5500_platform_devs); i++)
+		db5500_platform_devs[i]->dev.parent = parent;
+
 	platform_add_devices(db5500_platform_devs,
 			     ARRAY_SIZE(db5500_platform_devs));
 
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index c83440b..21e917e 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -224,7 +224,12 @@ struct device * __init u8500_init_devices(void)
 	db8500_add_usb(parent, usb_db8500_rx_dma_cfg,
 		usb_db8500_tx_dma_cfg);
 
-	platform_device_register_simple("cpufreq-u8500", -1, NULL, 0);
+	platform_device_register_data(parent,
+		"cpufreq-u8500", -1, NULL, 0);
+
+	for (i = 0; i < ARRAY_SIZE(platform_devs); i++)
+		platform_devs[i]->dev.parent = parent;
+
 	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
 
 	return parent;
diff --git a/arch/arm/mach-ux500/devices-common.c b/arch/arm/mach-ux500/devices-common.c
index 51fd658..b8d9a99 100644
--- a/arch/arm/mach-ux500/devices-common.c
+++ b/arch/arm/mach-ux500/devices-common.c
@@ -47,6 +47,8 @@ dbx500_add_amba_device(struct device *parent, const char *name,
 
 	dev->dev.platform_data = pdata;
 
+	dev->dev.parent = parent;
+
 	ret = amba_device_register(dev, &iomem_resource);
 	if (ret) {
 		kfree(dev);
@@ -126,9 +128,14 @@ dbx500_add_gpio(struct device *parent, int id, resource_size_t addr, int irq,
 		}
 	};
 
-	return platform_device_register_resndata(NULL, "gpio", id,
-				resources, ARRAY_SIZE(resources),
-				pdata, sizeof(*pdata));
+	return platform_device_register_resndata(
+		parent,
+		"gpio",
+		id,
+		resources,
+		ARRAY_SIZE(resources),
+		pdata,
+		sizeof(*pdata));
 }
 
 void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
index bef6a31..cdae63e 100644
--- a/arch/arm/mach-ux500/usb.c
+++ b/arch/arm/mach-ux500/usb.c
@@ -7,6 +7,7 @@
 #include <linux/platform_device.h>
 #include <linux/usb/musb.h>
 #include <linux/dma-mapping.h>
+
 #include <plat/ste_dma40.h>
 #include <mach/hardware.h>
 #include <mach/usb.h>
@@ -157,5 +158,7 @@ void ux500_add_usb(struct device *parent, resource_size_t base, int irq,
 	ux500_usb_dma_update_rx_ch_config(dma_rx_cfg);
 	ux500_usb_dma_update_tx_ch_config(dma_tx_cfg);
 
+	ux500_musb_device.dev.parent = parent;
+
 	platform_device_register(&ux500_musb_device);
 }
-- 
1.7.5.4

