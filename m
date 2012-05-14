Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2ENNuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:50:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49717 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ENNuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:50:02 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 2/7] dmaengine: rebalance DMA channels when CPU hotplug happens
Date: Mon, 14 May 2012 21:47:04 +0800
Message-Id: <1337003229-9158-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
References: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Rebalance DMA channels when CPU hotplug happens to correctly update
DMA channel reference count.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dma/dmaengine.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 58bc45c..d3b1c48 100644
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
@@ -1003,8 +1004,29 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx)
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
1.7.9.5

