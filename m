Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1FVMDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:03:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:37823 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab1FVMDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:03:07 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 2/3] powerpc: implement arch_setup_pdev_archdata
Date: Wed, 22 Jun 2011 07:02:55 -0500
Message-Id: <1308744176-24491-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org>
References: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a long standing issues with platform devices not have a valid
dma_mask pointer.  This hasn't been an issue to date as no platform
device has tried to set its dma_mask value to a non-default value.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/include/asm/platform_device.h |   17 ++++++++++++++++-
 arch/powerpc/kernel/setup-common.c         |   27 ---------------------------
 drivers/of/platform.c                      |    5 +++--
 3 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/platform_device.h b/arch/powerpc/include/asm/platform_device.h
index 01452c3..137b183 100644
--- a/arch/powerpc/include/asm/platform_device.h
+++ b/arch/powerpc/include/asm/platform_device.h
@@ -1 +1,16 @@
-#include <asm-generic/platform_device.h>
+#ifndef __ASM_PLATFORM_DEVICE_H_
+#define __ASM_PLATFORM_DEVICE_H_
+
+#include <linux/platform_device.h>
+#include <asm/dma-mapping.h>
+
+#define ARCH_HAS_PDEV_ARCHDATA_SETUP
+
+static inline void arch_setup_pdev_archdata(struct platform_device *pdev)
+{
+	pdev->archdata.dma_mask = DMA_BIT_MASK(32);
+	pdev->dev.dma_mask = &pdev->archdata.dma_mask;
+ 	set_dma_ops(&pdev->dev, &dma_direct_ops);
+}
+
+#endif /* __ASM_GENERIC_PLATFORM_DEVICE_H_ */
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 79fca26..eb5229e 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -703,30 +703,3 @@ static int powerpc_debugfs_init(void)
 }
 arch_initcall(powerpc_debugfs_init);
 #endif
-
-static int ppc_dflt_bus_notify(struct notifier_block *nb,
-				unsigned long action, void *data)
-{
-	struct device *dev = data;
-
-	/* We are only intereted in device addition */
-	if (action != BUS_NOTIFY_ADD_DEVICE)
-		return 0;
-
-	set_dma_ops(dev, &dma_direct_ops);
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block ppc_dflt_plat_bus_notifier = {
-	.notifier_call = ppc_dflt_bus_notify,
-	.priority = INT_MAX,
-};
-
-static int __init setup_bus_notifier(void)
-{
-	bus_register_notifier(&platform_bus_type, &ppc_dflt_plat_bus_notifier);
-	return 0;
-}
-
-arch_initcall(setup_bus_notifier);
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 63d3cb7..5ba8f48 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -21,6 +21,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <asm/platform_device.h>
 
 static int of_dev_node_match(struct device *dev, void *data)
 {
@@ -153,7 +154,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
 	}
 
 	dev->dev.of_node = of_node_get(np);
-#if defined(CONFIG_PPC) || defined(CONFIG_MICROBLAZE)
+#if defined(CONFIG_MICROBLAZE)
 	dev->dev.dma_mask = &dev->archdata.dma_mask;
 #endif
 	dev->dev.parent = parent;
@@ -189,7 +190,7 @@ struct platform_device *of_platform_device_create(struct device_node *np,
 	if (!dev)
 		return NULL;
 
-#if defined(CONFIG_PPC) || defined(CONFIG_MICROBLAZE)
+#if defined(CONFIG_MICROBLAZE)
 	dev->archdata.dma_mask = 0xffffffffUL;
 #endif
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-- 
1.7.3.4

