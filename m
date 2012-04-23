Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2DWN5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:57:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46808 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab2DWN5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:57:10 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 8/8] dmaengine: assign DMA channel to CPU according to NUMA affinity
Date: Mon, 23 Apr 2012 21:51:49 +0800
Message-Id: <1335189109-4871-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
References: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with multiple CPUs and DMA devices, try optimize DMA
performance by assigning DMA channel to CPU according to NUMA
affinity relationship. This may help architectures with memory
controllers and DMA devices built into physical processors.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dma/dmaengine.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 1cb91df..52d748c 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -289,6 +289,7 @@ static dma_cap_mask_t dma_cap_mask_all;
 struct dma_chan_tbl_ent {
 	struct dma_chan dma_chan_rcu_space *chan;
 	struct dma_chan *prev_chan;
+	int node;
 };
 
 /**
@@ -481,6 +482,46 @@ static struct dma_chan *nth_chan(enum dma_transaction_type cap, int n)
 	return ret;
 }
 
+/* Assign DMA channels to CPUs according to NUMA affinity relationship */
+static void dma_channel_set(int cap, int cpu, struct dma_chan *chan)
+{
+	int node;
+	int src_cpu;
+	struct dma_chan *src_chan;
+	struct dma_chan_tbl_ent *entry;
+	struct dma_chan_tbl_ent *src_entry;
+
+	entry = per_cpu_ptr(channel_table[cap], cpu);
+	node = dev_to_node(chan->device->dev);
+
+	/* Try to optimize if CPU and DMA channel belong to different node. */
+	if (node != -1 && node != cpu_to_node(cpu)) {
+		for_each_online_cpu(src_cpu) {
+			src_entry = per_cpu_ptr(channel_table[cap], src_cpu);
+			src_chan = dma_chan_rcu_get(src_entry->chan);
+
+			/*
+			 * CPU online map may change beneath us due to
+			 * CPU hotplug operations.
+			 */
+			if (src_chan == NULL)
+				continue;
+
+			if (src_entry->node == node ||
+			    cpu_to_node(src_cpu) == node) {
+				entry->node = src_entry->node;
+				src_entry->node = node;
+				dma_chan_rcu_set(entry->chan, src_chan);
+				dma_chan_rcu_set(src_entry->chan, chan);
+				return;
+			}
+		}
+	}
+
+	entry->node = node;
+	dma_chan_rcu_set(entry->chan, chan);
+}
+
 /**
  * dma_channel_rebalance - redistribute the available channels
  *
@@ -515,8 +556,8 @@ static void dma_channel_rebalance(void)
 					chan = nth_chan(cap, n++);
 				else
 					chan = nth_chan(cap, -1);
-				entry = per_cpu_ptr(channel_table[cap], cpu);
-				dma_chan_rcu_set(entry->chan, chan);
+				if (chan)
+					dma_channel_set(cap, cpu, chan);
 			}
 
 #ifdef	CONFIG_DMA_ENGINE_HOTPLUG
-- 
1.7.5.4

