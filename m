Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2DWN4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:56:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46808 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2DWN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:56:42 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v1 5/8] dmaengine: enhance dma_async_device_unregister() to be called by drv->remove()
Date: Mon, 23 Apr 2012 21:51:46 +0800
Message-Id: <1335189109-4871-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
References: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances dma_async_device_unregister() to be called by DMA
driver's detaching routines. To achieve that, it enhances dma_find_channel()
and net_dma_find_channel() to hold a reference count on returned channel,
also introduce dma_get/put_channel() to update DMA channel reference count.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dma/dmaengine.c   |  110 ++++++++++++++++++++++++++++++++++++++++-----
 include/linux/dmaengine.h |   12 +++++
 2 files changed, 111 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index da7a683..1cb91df 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -61,17 +61,28 @@
 #include <linux/rculist.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #ifndef	CONFIG_DMA_ENGINE_HOTPLUG
 #define	dma_chan_ref_read(chan)		((chan)->client_count)
 #define	dma_chan_ref_set(chan, v)	((chan)->client_count = (v))
 #define	dma_chan_ref_inc(chan)		((chan)->client_count++)
 #define	dma_chan_ref_dec_and_test(ch)	(--(chan)->client_count == 0)
+#define	dma_chan_rcu_get(var)		(var)
+#define	dma_chan_rcu_set(var, ptr)	((var) = (ptr))
+#define	dma_chan_rcu_access_ptr(var)	(var)
+#define	dma_chan_rcu_space
 #else	/* CONFIG_DMA_ENGINE_HOTPLUG */
 #define	dma_chan_ref_read(chan)		atomic_read(&(chan)->client_count)
 #define	dma_chan_ref_set(chan, v)	atomic_set(&(chan)->client_count, (v))
 #define	dma_chan_ref_inc(chan)		atomic_inc(&(chan)->client_count)
 #define	dma_chan_ref_dec_and_test(ch)	atomic_dec_and_test(&(ch)->client_count)
+#define	dma_chan_rcu_get(var)		rcu_dereference(var);
+#define	dma_chan_rcu_set(var, ptr)	rcu_assign_pointer((var), (ptr))
+#define	dma_chan_rcu_access_ptr(var)	rcu_access_pointer((var));
+#define	dma_chan_rcu_space		__rcu
+
+static DECLARE_WAIT_QUEUE_HEAD(dma_device_wait_queue);
 #endif	/* CONFIG_DMA_ENGINE_HOTPLUG */
 
 static DEFINE_MUTEX(dma_list_mutex);
@@ -238,8 +249,12 @@ static int dma_chan_get(struct dma_chan *chan)
 static void dma_chan_put(struct dma_chan *chan)
 {
 	BUG_ON(dma_chan_ref_read(chan) <= 0);
-	if (dma_chan_ref_dec_and_test(chan))
+	if (unlikely(dma_chan_ref_dec_and_test(chan))) {
 		chan->device->device_free_chan_resources(chan);
+#ifdef CONFIG_DMA_ENGINE_HOTPLUG
+		wake_up_all(&dma_device_wait_queue);
+#endif
+	}
 	module_put(dma_chan_to_owner(chan));
 }
 
@@ -272,7 +287,7 @@ static dma_cap_mask_t dma_cap_mask_all;
  * @prev_chan - previous associated channel for this entry
  */
 struct dma_chan_tbl_ent {
-	struct dma_chan *chan;
+	struct dma_chan dma_chan_rcu_space *chan;
 	struct dma_chan *prev_chan;
 };
 
@@ -316,29 +331,86 @@ static int __init dma_channel_table_init(void)
 arch_initcall(dma_channel_table_init);
 
 /**
- * dma_find_channel - find a channel to carry out the operation
+ * dma_has_capability - check whether any channel supports tx_type
  * @tx_type: transaction type
  */
-struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type)
+bool dma_has_capability(enum dma_transaction_type tx_type)
 {
-	return this_cpu_read(channel_table[tx_type]->chan);
+	struct dma_chan_tbl_ent *entry = this_cpu_ptr(channel_table[tx_type]);
+
+	return !!dma_chan_rcu_access_ptr(entry->chan);
 }
-EXPORT_SYMBOL(dma_find_channel);
+EXPORT_SYMBOL(dma_has_capability);
 
 /*
- * net_dma_find_channel - find a channel for net_dma
+ * net_dma_find_channel - find and hold a channel for net_dma
  * net_dma has alignment requirements
  */
 struct dma_chan *net_dma_find_channel(void)
 {
 	struct dma_chan *chan = dma_find_channel(DMA_MEMCPY);
-	if (chan && !is_dma_copy_aligned(chan->device, 1, 1, 1))
+
+	if (chan && !is_dma_copy_aligned(chan->device, 1, 1, 1)) {
+		dma_put_channel(chan);
 		return NULL;
+	}
 
 	return chan;
 }
 EXPORT_SYMBOL(net_dma_find_channel);
 
+#ifndef	CONFIG_DMA_ENGINE_HOTPLUG
+/**
+ * dma_find_channel - find and get a channel to carry out the operation
+ * @tx_type: transaction type
+ */
+struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type)
+{
+	return this_cpu_read(channel_table[tx_type]->chan);
+}
+EXPORT_SYMBOL(dma_find_channel);
+
+#else	/* CONFIG_DMA_ENGINE_HOTPLUG */
+
+/**
+ * dma_find_channel - find and get a channel to carry out the operation
+ * @tx_type: transaction type
+ */
+struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type)
+{
+	struct dma_chan_tbl_ent *entry = this_cpu_ptr(channel_table[tx_type]);
+	struct dma_chan *chan;
+
+	rcu_read_lock();
+	chan = rcu_dereference(entry->chan);
+	if (chan)
+		dma_chan_ref_inc(chan);
+	rcu_read_unlock();
+
+	return chan;
+}
+EXPORT_SYMBOL(dma_find_channel);
+
+struct dma_chan *dma_get_channel(struct dma_chan *chan)
+{
+	if (chan)
+		dma_chan_ref_inc(chan);
+
+	return chan;
+}
+EXPORT_SYMBOL(dma_get_channel);
+
+void dma_put_channel(struct dma_chan *chan)
+{
+	if (chan)
+		if (unlikely(dma_chan_ref_dec_and_test(chan))) {
+			chan->device->device_free_chan_resources(chan);
+			wake_up_all(&dma_device_wait_queue);
+		}
+}
+EXPORT_SYMBOL(dma_put_channel);
+#endif	/* CONFIG_DMA_ENGINE_HOTPLUG */
+
 /**
  * dma_issue_pending_all - flush all pending operations across all channels
  */
@@ -429,8 +501,8 @@ static void dma_channel_rebalance(void)
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
 		for_each_possible_cpu(cpu) {
 			entry = per_cpu_ptr(channel_table[cap], cpu);
-			entry->prev_chan = entry->chan;
-			entry->chan = NULL;
+			entry->prev_chan = dma_chan_rcu_get(entry->chan);
+			dma_chan_rcu_set(entry->chan, NULL);
 			if (entry->prev_chan)
 				entry->prev_chan->table_count--;
 		}
@@ -444,9 +516,14 @@ static void dma_channel_rebalance(void)
 				else
 					chan = nth_chan(cap, -1);
 				entry = per_cpu_ptr(channel_table[cap], cpu);
-				entry->chan = chan;
+				dma_chan_rcu_set(entry->chan, chan);
 			}
 
+#ifdef	CONFIG_DMA_ENGINE_HOTPLUG
+	/* Synchronize with dma_find_get_channel() */
+	synchronize_rcu();
+#endif
+
 	/* undo the last distribution */
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
 		for_each_possible_cpu(cpu) {
@@ -788,9 +865,17 @@ void dma_async_device_unregister(struct dma_device *device)
 
 	/* Check whether it's called from module exit function. */
 	if (try_module_get(device->dev->driver->owner)) {
+#ifndef	CONFIG_DMA_ENGINE_HOTPLUG
 		dev_warn(device->dev,
 			"%s isn't called from module exit function.\n",
 			__func__);
+#else
+		list_for_each_entry(chan, &device->channels, device_node) {
+			/* TODO: notify clients to release channels*/
+			wait_event(dma_device_wait_queue,
+				   dma_chan_ref_read(chan) == 0);
+		}
+#endif
 		module_put(device->dev->driver->owner);
 	}
 
@@ -804,6 +889,9 @@ void dma_async_device_unregister(struct dma_device *device)
 		device_unregister(&chan->dev->device);
 		free_percpu(chan->local);
 	}
+
+	/* Synchronize with dma_issue_pending_all() */
+	synchronize_rcu();
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d1532dc..874f8de 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -977,9 +977,21 @@ static inline void dma_release_channel(struct dma_chan *chan)
 int dma_async_device_register(struct dma_device *device);
 void dma_async_device_unregister(struct dma_device *device);
 void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
+bool dma_has_capability(enum dma_transaction_type tx_type);
 struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
 struct dma_chan *net_dma_find_channel(void);
 #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
+#ifdef CONFIG_DMA_ENGINE_HOTPLUG
+struct dma_chan *dma_get_channel(struct dma_chan *chan);
+void dma_put_channel(struct dma_chan *chan);
+#else /* CONFIG_DMA_ENGINE_HOTPLUG */
+static inline struct dma_chan *dma_get_channel(struct dma_chan *chan)
+{
+	return chan;
+}
+
+static inline void dma_put_channel(struct dma_chan *chan) {}
+#endif /* CONFIG_DMA_ENGINE_HOTPLUG */
 
 /* --- Helper iov-locking functions --- */
 
-- 
1.7.5.4

