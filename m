Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab2ENNv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:51:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55035 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2ENNvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:51:24 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 7/7] dmaengine: assign DMA channel to CPU according to NUMA affinity
Date: Mon, 14 May 2012 21:47:09 +0800
Message-Id: <1337003229-9158-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
References: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

On systems with multiple CPUs and DMA devices, try optimize DMA
performance by assigning DMA channels to CPUs according to NUMA
affinity relationship. This may help architectures with memory
controllers and DMA devices built into the same physical processor
to avoid unnecessary cross socket traffic.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dma/dmaengine.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index eca45c0..8a41bdf 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -266,6 +266,7 @@ static dma_cap_mask_t dma_cap_mask_all;
 struct dma_chan_tbl_ent {
 	struct dma_chan *chan;
 	struct dma_chan *prev_chan;
+	int node;
 };
 
 /**
@@ -467,6 +468,46 @@ static void dma_channel_quiesce(void)
 #endif
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
+			src_chan = src_entry->chan;
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
+				entry->chan = src_chan;
+				src_entry->chan = chan;
+				return;
+			}
+		}
+	}
+
+	entry->node = node;
+	entry->chan = chan;
+}
+
 /**
  * dma_channel_rebalance - redistribute the available channels
  *
@@ -501,8 +542,8 @@ static void dma_channel_rebalance(bool quiesce)
 					chan = nth_chan(cap, n++);
 				else
 					chan = nth_chan(cap, -1);
-				entry = per_cpu_ptr(channel_table[cap], cpu);
-				entry->chan = chan;
+				if (chan)
+					dma_channel_set(cap, cpu, chan);
 			}
 
 	if (quiesce)
-- 
1.7.9.5

