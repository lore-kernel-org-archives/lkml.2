Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2DWN4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:56:20 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:45199 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2DWN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:56:18 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v1 2/8] dmaengine: rebalance DMA channels when CPU hotplug happens
Date: Mon, 23 Apr 2012 21:51:43 +0800
Message-Id: <1335189109-4871-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
References: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebalance DMA channels when CPU hotplug happens to correctly update
DMA channel reference count.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dma/dmaengine.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 5b6ad58..198d891 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -49,6 +49,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/dmaengine.h>
 #include <linux/hardirq.h>
@@ -1008,8 +1009,29 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx)
 }
 EXPORT_SYMBOL_GPL(dma_run_dependencies);
 
+static int __cpuinit
+hotcpu_rebalance(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_POST_DEAD:
+		mutex_lock(&dma_list_mutex);
+		dma_channel_rebalance();
+		mutex_unlock(&dma_list_mutex);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __refdata dma_cpu_notifier = {
+	.notifier_call = hotcpu_rebalance,
+};
+
+
 static int __init dma_bus_init(void)
 {
+	register_hotcpu_notifier(&dma_cpu_notifier);
 	return class_register(&dma_devclass);
 }
 arch_initcall(dma_bus_init);
-- 
1.7.5.4

