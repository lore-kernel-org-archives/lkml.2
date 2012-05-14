Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2ENNuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:50:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49717 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2ENNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:50:15 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v2 3/7] dmaengine: enhance dmaengine to support DMA device hotplug
Date: Mon, 14 May 2012 21:47:05 +0800
Message-Id: <1337003229-9158-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
References: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

From: Jiang Liu <liuj97@gmail.com>

To support DMA device hotplug, dmaengine must correctly manage
reference count for DMA channels. On the other hand, DMA hot path
is performance critical, reference count management code should
avoid polluting global shared cachelines, otherwise it may cause
heavy performance penalty.

This patch introduces a lightweight DMA channel reference count
management mechanism by using percpu counter. When DMA device
hotplug is disabled, there's no performance penalty. When hotplug
is enabled, a dma_find_channel()/dma_put_channel() pair adds two
local memory accesses to the hot path.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dma/dmaengine.c   |  112 +++++++++++++++++++++++++++++++++++++++++----
 include/linux/dmaengine.h |   29 +++++++++++-
 2 files changed, 129 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index d3b1c48..eca45c0 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -61,12 +61,20 @@
 #include <linux/rculist.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 static DEFINE_MUTEX(dma_list_mutex);
 static DEFINE_IDR(dma_idr);
 static LIST_HEAD(dma_device_list);
 static long dmaengine_client_count;
 
+#ifdef	CONFIG_DMA_ENGINE_HOTPLUG
+static atomic_t dmaengine_dirty;
+static struct static_key dmaengine_quiesce = STATIC_KEY_INIT_FALSE;
+static DECLARE_WAIT_QUEUE_HEAD(dmaengine_wait_queue);
+DEFINE_PER_CPU(long, dmaengine_chan_ref_count);
+#endif	/* CONFIG_DMA_ENGINE_HOTPLUG */
+
 /* --- sysfs implementation --- */
 
 /**
@@ -305,10 +313,40 @@ arch_initcall(dma_channel_table_init);
  */
 struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type)
 {
-	return this_cpu_read(channel_table[tx_type]->chan);
+	struct dma_chan *chan = this_cpu_read(channel_table[tx_type]->chan);
+
+#ifdef	CONFIG_DMA_ENGINE_HOTPLUG
+	this_cpu_inc(dmaengine_chan_ref_count);
+	if (static_key_false(&dmaengine_quiesce))
+		chan = NULL;
+#endif
+
+	return chan;
 }
 EXPORT_SYMBOL(dma_find_channel);
 
+#ifdef	CONFIG_DMA_ENGINE_HOTPLUG
+struct dma_chan *dma_get_channel(struct dma_chan *chan)
+{
+	if (static_key_false(&dmaengine_quiesce))
+		atomic_inc(&dmaengine_dirty);
+	this_cpu_inc(dmaengine_chan_ref_count);
+
+	return chan;
+}
+EXPORT_SYMBOL(dma_get_channel);
+#endif
+
+/**
+ * dma_has_capability - check whether any channel supports tx_type
+ * @tx_type: transaction type
+ */
+bool dma_has_capability(enum dma_transaction_type tx_type)
+{
+	return !!this_cpu_read(channel_table[tx_type]->chan);
+}
+EXPORT_SYMBOL(dma_has_capability);
+
 /*
  * net_dma_find_channel - find a channel for net_dma
  * net_dma has alignment requirements
@@ -316,10 +354,15 @@ EXPORT_SYMBOL(dma_find_channel);
 struct dma_chan *net_dma_find_channel(void)
 {
 	struct dma_chan *chan = dma_find_channel(DMA_MEMCPY);
-	if (chan && !is_dma_copy_aligned(chan->device, 1, 1, 1))
-		return NULL;
 
-	return chan;
+	if (chan && is_dma_copy_aligned(chan->device, 1, 1, 1))
+		return chan;
+
+#ifdef	CONFIG_DMA_ENGINE_HOTPLUG
+	this_cpu_dec(dmaengine_chan_ref_count);
+#endif
+
+	return NULL;
 }
 EXPORT_SYMBOL(net_dma_find_channel);
 
@@ -393,6 +436,37 @@ static struct dma_chan *nth_chan(enum dma_transaction_type cap, int n)
 	return ret;
 }
 
+static void dma_channel_quiesce(void)
+{
+#ifdef	CONFIG_DMA_ENGINE_HOTPLUG
+	int cpu;
+	long ref_count;
+	int quiesce_count = 0;
+
+	static_key_slow_inc(&dmaengine_quiesce);
+
+	do {
+		atomic_set(&dmaengine_dirty, 0);
+		schedule_timeout(1);
+
+		if (atomic_read(&dmaengine_dirty)) {
+			quiesce_count = 0;
+			continue;
+		}
+
+		ref_count = 0;
+		for_each_possible_cpu(cpu)
+			ref_count += per_cpu(dmaengine_chan_ref_count, cpu);
+		if (ref_count == 0)
+			quiesce_count++;
+		else
+			quiesce_count = 0;
+	} while (quiesce_count < 10);
+
+	static_key_slow_dec(&dmaengine_quiesce);
+#endif
+}
+
 /**
  * dma_channel_rebalance - redistribute the available channels
  *
@@ -401,7 +475,7 @@ static struct dma_chan *nth_chan(enum dma_transaction_type cap, int n)
  * multi-tasking channels) in the non-SMP case.  Must be called under
  * dma_list_mutex.
  */
-static void dma_channel_rebalance(void)
+static void dma_channel_rebalance(bool quiesce)
 {
 	struct dma_chan *chan;
 	struct dma_chan_tbl_ent *entry;
@@ -431,6 +505,9 @@ static void dma_channel_rebalance(void)
 				entry->chan = chan;
 			}
 
+	if (quiesce)
+		dma_channel_quiesce();
+
 	/* undo the last distribution */
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
 		for_each_possible_cpu(cpu) {
@@ -532,6 +609,10 @@ void dma_release_channel(struct dma_chan *chan)
 	if (--chan->device->privatecnt == 0)
 		dma_cap_clear(DMA_PRIVATE, chan->device->cap_mask);
 	mutex_unlock(&dma_list_mutex);
+
+#ifdef	CONFIG_DMA_ENGINE_HOTPLUG
+	wake_up_all(&dmaengine_wait_queue);
+#endif
 }
 EXPORT_SYMBOL_GPL(dma_release_channel);
 
@@ -546,7 +627,7 @@ void dmaengine_get(void)
 	 * incorporated into the channel table
 	 */
 	if (++dmaengine_client_count == 1)
-		dma_channel_rebalance();
+		dma_channel_rebalance(false);
 	mutex_unlock(&dma_list_mutex);
 }
 EXPORT_SYMBOL(dmaengine_get);
@@ -559,7 +640,7 @@ void dmaengine_put(void)
 	mutex_lock(&dma_list_mutex);
 	BUG_ON(dmaengine_client_count <= 0);
 	if (--dmaengine_client_count == 0)
-		dma_channel_rebalance();
+		dma_channel_rebalance(false);
 	mutex_unlock(&dma_list_mutex);
 }
 EXPORT_SYMBOL(dmaengine_put);
@@ -726,7 +807,7 @@ int dma_async_device_register(struct dma_device *device)
 	if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
 		device->privatecnt++;	/* Always private */
 	else
-		dma_channel_rebalance();
+		dma_channel_rebalance(false);
 	mutex_unlock(&dma_list_mutex);
 
 	return 0;
@@ -767,14 +848,22 @@ void dma_async_device_unregister(struct dma_device *device)
 
 	mutex_lock(&dma_list_mutex);
 	list_del_rcu(&device->global_node);
-	dma_channel_rebalance();
+	dma_channel_rebalance(true);
 	mutex_unlock(&dma_list_mutex);
 
 	/* Check whether it's called from module exit function. */
 	if (try_module_get(device->dev->driver->owner)) {
+#ifndef	CONFIG_DMA_ENGINE_HOTPLUG
 		dev_warn(device->dev,
 			"%s isn't called from module exit function.\n",
 			__func__);
+#else
+		list_for_each_entry(chan, &device->channels, device_node) {
+			/* TODO: notify clients to release channels*/
+			wait_event(dmaengine_wait_queue,
+				   chan->client_count == 0);
+		}
+#endif
 		module_put(device->dev->driver->owner);
 	}
 
@@ -788,6 +877,9 @@ void dma_async_device_unregister(struct dma_device *device)
 		device_unregister(&chan->dev->device);
 		free_percpu(chan->local);
 	}
+
+	/* Synchronize with dma_issue_pending_all() */
+	synchronize_rcu();
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
 
@@ -1011,7 +1103,7 @@ hotcpu_rebalance(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_ONLINE:
 	case CPU_POST_DEAD:
 		mutex_lock(&dma_list_mutex);
-		dma_channel_rebalance();
+		dma_channel_rebalance(false);
 		mutex_unlock(&dma_list_mutex);
 		break;
 	}
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index f9a2e5e..e099b28 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -973,10 +973,35 @@ static inline void dma_release_channel(struct dma_chan *chan)
 int dma_async_device_register(struct dma_device *device);
 void dma_async_device_unregister(struct dma_device *device);
 void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
-struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
-struct dma_chan *net_dma_find_channel(void);
 #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
 
+/*
+ * Special DMA channel reference count management scheme has been adopted
+ * to support DMA device hotplug without introducing big performance penalty.
+ * Please follow rules below to correctly manage channel reference count.
+ * 1) dma_find_channel()/dma_get_channel() must be paired with
+ *    dma_put_channel(), even if dma_find_channel() returns NULL.
+ * 2) Only call dma_put_channel() if net_dma_find_channel() returns valid
+ *    channel pointer.
+ */
+bool dma_has_capability(enum dma_transaction_type tx_type);
+struct dma_chan *net_dma_find_channel(void);
+struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
+#ifdef	CONFIG_DMA_ENGINE_HOTPLUG
+DECLARE_PER_CPU(long, dmaengine_chan_ref_count);
+static inline void dma_put_channel(struct dma_chan *chan)
+{
+	this_cpu_dec(dmaengine_chan_ref_count);
+}
+
+struct dma_chan *dma_get_channel(struct dma_chan *chan);
+#else	/* CONFIG_DMA_ENGINE_HOTPLUG */
+static inline void dma_put_channel(struct dma_chan *chan) { }
+static inline struct dma_chan *dma_get_channel(struct dma_chan *chan)
+{ return chan; }
+#endif	/* CONFIG_DMA_ENGINE_HOTPLUG */
+
+
 /* --- Helper iov-locking functions --- */
 
 struct dma_page_list {
-- 
1.7.9.5

