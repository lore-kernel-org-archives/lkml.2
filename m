Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1JQLxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:53:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56650 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1JQLxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:53:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linus.walleij@stericsson.com, jamie@jamieiles.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/6] mach-ux500: remove intermediary add_platform_device* functions
Date: Mon, 17 Oct 2011 12:52:58 +0100
Message-Id: <1318852378-14180-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are no longer required since a 'parent' pointer is now
passed to each registering device.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/devices-common.c |   53 ----------------------------------
 arch/arm/mach-ux500/devices-common.h |   34 +++++++++------------
 arch/arm/mach-ux500/devices-db8500.h |   10 ++++--
 3 files changed, 22 insertions(+), 75 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-common.c b/arch/arm/mach-ux500/devices-common.c
index b8d9a99..170975f 100644
--- a/arch/arm/mach-ux500/devices-common.c
+++ b/arch/arm/mach-ux500/devices-common.c
@@ -59,59 +59,6 @@ dbx500_add_amba_device(struct device *parent, const char *name,
 }
 
 static struct platform_device *
-dbx500_add_platform_device(const char *name, int id, void *pdata,
-			   struct resource *res, int resnum)
-{
-	struct platform_device *dev;
-	int ret;
-
-	dev = platform_device_alloc(name, id);
-	if (!dev)
-		return ERR_PTR(-ENOMEM);
-
-	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
-
-	ret = platform_device_add_resources(dev, res, resnum);
-	if (ret)
-		goto out_free;
-
-	dev->dev.platform_data = pdata;
-
-	ret = platform_device_add(dev);
-	if (ret)
-		goto out_free;
-
-	return dev;
-
-out_free:
-	platform_device_put(dev);
-	return ERR_PTR(ret);
-}
-
-struct platform_device *
-dbx500_add_platform_device_4k1irq(const char *name, int id,
-				  resource_size_t base,
-				  int irq, void *pdata)
-{
-	struct resource resources[] = {
-		[0] = {
-			.start	= base,
-			.end	= base + SZ_4K - 1,
-			.flags	= IORESOURCE_MEM,
-		},
-		[1] = {
-			.start	= irq,
-			.end	= irq,
-			.flags	= IORESOURCE_IRQ,
-		}
-	};
-
-	return dbx500_add_platform_device(name, id, pdata, resources,
-					  ARRAY_SIZE(resources));
-}
-
-static struct platform_device *
 dbx500_add_gpio(struct device *parent, int id, resource_size_t addr, int irq,
 		struct nmk_gpio_platform_data *pdata)
 {
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index f8adff8..089371e 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -8,14 +8,13 @@
 #ifndef __DEVICES_COMMON_H
 #define __DEVICES_COMMON_H
 
-extern struct amba_device *
-dbx500_add_amba_device(struct device *parent, const char *name, resource_size_t base,
-		       int irq, void *pdata, unsigned int periphid);
+#include <linux/sys_soc.h>
+#include <plat/i2c.h>
 
-extern struct platform_device *
-dbx500_add_platform_device_4k1irq(const char *name, int id,
-				  resource_size_t base,
-				  int irq, void *pdata);
+extern struct amba_device *
+dbx500_add_amba_device(struct device *parent, const char *name,
+		       resource_size_t base, int irq, void *pdata,
+		       unsigned int periphid);
 
 struct spi_master_cntlr;
 
@@ -62,18 +61,15 @@ static inline struct platform_device *
 dbx500_add_i2c(struct device *parent, int id, resource_size_t base, int irq,
 	       struct nmk_i2c_controller *pdata)
 {
-	return dbx500_add_platform_device_4k1irq("nmk-i2c", id, base, irq,
-						 pdata);
-}
-
-struct msp_i2s_platform_data;
-
-static inline struct platform_device *
-dbx500_add_msp_i2s(int id, resource_size_t base, int irq,
-		   struct msp_i2s_platform_data *pdata)
-{
-	return dbx500_add_platform_device_4k1irq("MSP_I2S", id, base, irq,
-						 pdata);
+	struct resource resources[] = {
+		DEFINE_RES_MEM(base, SZ_4K),
+		DEFINE_RES_IRQ(irq),
+	};
+
+	return platform_device_register_resndata(parent, "nmk-i2c",
+						 id, resources,
+						 ARRAY_SIZE(resources),
+						 pdata, sizeof(*pdata));
 }
 
 static inline struct amba_device *
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index 9bd08ad..9fd93e9 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -18,9 +18,13 @@ db8500_add_ske_keypad(struct device *parent,
 		      struct ske_keypad_platform_data *pdata,
 		      size_t size)
 {
-	return dbx500_add_platform_device_4k1irq("nmk-ske-keypad", -1,
-						 U8500_SKE_BASE,
-						 IRQ_DB8500_KB, pdata);
+	struct resource resources[] = {
+		DEFINE_RES_MEM(U8500_SKE_BASE, SZ_4K),
+		DEFINE_RES_IRQ(IRQ_DB8500_KB),
+	};
+
+	return platform_device_register_resndata(parent, "nmk-ske-keypad", -1,
+						 resources, 2, pdata, size);
 }
 
 static inline struct amba_device *
-- 
1.7.5.4

