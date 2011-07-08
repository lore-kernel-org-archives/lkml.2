Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab1GHEBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:01:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:37903 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab1GHEAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:00:53 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] powerpc: implement arch_setup_pdev_archdata
Date: Thu,  7 Jul 2011 23:00:42 -0500
Message-Id: <1310097643-8414-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1310097643-8414-1-git-send-email-galak@kernel.crashing.org>
References: <1310097643-8414-1-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a long standing issues with platform devices not have a valid
dma_mask pointer.  This hasn't been an issue to date as no platform
device has tried to set its dma_mask value to a non-default value.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/kernel/setup-common.c |   28 ++++------------------------
 drivers/of/platform.c              |    4 ++--
 2 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 79fca26..ea82baa 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -704,29 +704,9 @@ static int powerpc_debugfs_init(void)
 arch_initcall(powerpc_debugfs_init);
 #endif
 
-static int ppc_dflt_bus_notify(struct notifier_block *nb,
-				unsigned long action, void *data)
+void arch_setup_pdev_archdata(struct platform_device *pdev)
 {
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
+	pdev->archdata.dma_mask = DMA_BIT_MASK(32);
+	pdev->dev.dma_mask = &pdev->archdata.dma_mask;
+ 	set_dma_ops(&pdev->dev, &dma_direct_ops);
 }
-
-arch_initcall(setup_bus_notifier);
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 63d3cb7..cfc6a79 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -153,7 +153,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
 	}
 
 	dev->dev.of_node = of_node_get(np);
-#if defined(CONFIG_PPC) || defined(CONFIG_MICROBLAZE)
+#if defined(CONFIG_MICROBLAZE)
 	dev->dev.dma_mask = &dev->archdata.dma_mask;
 #endif
 	dev->dev.parent = parent;
@@ -189,7 +189,7 @@ struct platform_device *of_platform_device_create(struct device_node *np,
 	if (!dev)
 		return NULL;
 
-#if defined(CONFIG_PPC) || defined(CONFIG_MICROBLAZE)
+#if defined(CONFIG_MICROBLAZE)
 	dev->archdata.dma_mask = 0xffffffffUL;
 #endif
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-- 
1.7.3.4

