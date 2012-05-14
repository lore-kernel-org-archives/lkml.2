Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2ENNti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:49:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49717 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ENNtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:49:36 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 1/7] dmaengine: enhance DMA channel reference count management
Date: Mon, 14 May 2012 21:47:03 +0800
Message-Id: <1337003229-9158-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
References: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Intel IOAT (Crystal Beach) devices are often built into PCIe root complex.
When hot-plugging a PCI root complex (IOH) on Intel Nehalem/Westmere
platforms, all IOAT devices built in the IOH must be handled first.
For future Intel processors with Integrated IOH (IIO), IOAT device will
get involved even when hot-plugging physical processors.

Currently dmaengine core already supports hot-add of IOAT devices,
but hot-removal of IOAT devices is still unsupported due to a design
limiation in the dmaengine core.

Currently dmaengine has an assumption that DMA devices could only be
deregistered when there's no any clients making use of DMA devices.
So dma_async_device_unregister() is designed to be called by DMA device
driver's module_exit routines only. But the ioatdma driver doesn't
conform to that rule, it calls dma_async_device_unregister() from its
driver detaching routine instead of module_exit routine.

This patch set enhances the dmaengine core to support DMA device hotplug,
so that dma_async_device_unregister() could be called by DMA driver's
detach routines to hot-remove DMA devices at runtime.

With currently implementation, variable dmaengine_ref_count is used to track
how many clients are making use of the dmaengine. There's also a per-channel
reference count named client_count in struct dma_chan.  For successfully
initialized channels, dma_chan->client_count is set to dmaengine_ref_count.
That means all channels can't be released/removed if there are still clients.

To support DMA device hotplug, this patch change dma_chan->client_count to
track actual reference to the DMA channel instead of tracking the global
client count.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dma/dmaengine.c |  193 ++++++++++++++++-------------------------------
 1 file changed, 67 insertions(+), 126 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 2397f6f..58bc45c 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -64,7 +64,7 @@
 static DEFINE_MUTEX(dma_list_mutex);
 static DEFINE_IDR(dma_idr);
 static LIST_HEAD(dma_device_list);
-static long dmaengine_ref_count;
+static long dmaengine_client_count;
 
 /* --- sysfs implementation --- */
 
@@ -168,8 +168,6 @@ static struct class dma_devclass = {
 
 /* --- client and device registration --- */
 
-#define dma_device_satisfies_mask(device, mask) \
-	__dma_device_satisfies_mask((device), &(mask))
 static int
 __dma_device_satisfies_mask(struct dma_device *device, dma_cap_mask_t *want)
 {
@@ -186,22 +184,6 @@ static struct module *dma_chan_to_owner(struct dma_chan *chan)
 }
 
 /**
- * balance_ref_count - catch up the channel reference count
- * @chan - channel to balance ->client_count versus dmaengine_ref_count
- *
- * balance_ref_count must be called under dma_list_mutex
- */
-static void balance_ref_count(struct dma_chan *chan)
-{
-	struct module *owner = dma_chan_to_owner(chan);
-
-	while (chan->client_count < dmaengine_ref_count) {
-		__module_get(owner);
-		chan->client_count++;
-	}
-}
-
-/**
  * dma_chan_get - try to grab a dma channel's parent driver module
  * @chan - channel to grab
  *
@@ -209,28 +191,22 @@ static void balance_ref_count(struct dma_chan *chan)
  */
 static int dma_chan_get(struct dma_chan *chan)
 {
-	int err = -ENODEV;
+	int err = 0;
 	struct module *owner = dma_chan_to_owner(chan);
 
-	if (chan->client_count) {
-		__module_get(owner);
-		err = 0;
-	} else if (try_module_get(owner))
-		err = 0;
-
-	if (err == 0)
-		chan->client_count++;
+	/* Device driver module has been unloaded */
+	if (!try_module_get(owner))
+		return -ENODEV;
 
 	/* allocate upon first client reference */
-	if (chan->client_count == 1 && err == 0) {
+	if (++chan->client_count == 1) {
 		int desc_cnt = chan->device->device_alloc_chan_resources(chan);
 
 		if (desc_cnt < 0) {
 			err = desc_cnt;
 			chan->client_count = 0;
 			module_put(owner);
-		} else if (!dma_has_cap(DMA_PRIVATE, chan->device->cap_mask))
-			balance_ref_count(chan);
+		}
 	}
 
 	return err;
@@ -244,12 +220,10 @@ static int dma_chan_get(struct dma_chan *chan)
  */
 static void dma_chan_put(struct dma_chan *chan)
 {
-	if (!chan->client_count)
-		return; /* this channel failed alloc_chan_resources */
-	chan->client_count--;
-	module_put(dma_chan_to_owner(chan));
-	if (chan->client_count == 0)
+	BUG_ON(chan->client_count <= 0);
+	if (--chan->client_count == 0)
 		chan->device->device_free_chan_resources(chan);
+	module_put(dma_chan_to_owner(chan));
 }
 
 enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
@@ -278,9 +252,11 @@ static dma_cap_mask_t dma_cap_mask_all;
 /**
  * dma_chan_tbl_ent - tracks channel allocations per core/operation
  * @chan - associated channel for this entry
+ * @prev_chan - previous associated channel for this entry
  */
 struct dma_chan_tbl_ent {
 	struct dma_chan *chan;
+	struct dma_chan *prev_chan;
 };
 
 /**
@@ -367,7 +343,7 @@ void dma_issue_pending_all(void)
 EXPORT_SYMBOL(dma_issue_pending_all);
 
 /**
- * nth_chan - returns the nth channel of the given capability
+ * nth_chan - grab a reference to the nth channel of the given capability
  * @cap: capability to match
  * @n: nth channel desired
  *
@@ -387,17 +363,19 @@ static struct dma_chan *nth_chan(enum dma_transaction_type cap, int n)
 		    dma_has_cap(DMA_PRIVATE, device->cap_mask))
 			continue;
 		list_for_each_entry(chan, &device->channels, device_node) {
-			if (!chan->client_count)
+			if (dma_chan_get(chan))
 				continue;
-			if (!min)
-				min = chan;
-			else if (chan->table_count < min->table_count)
-				min = chan;
-
 			if (n-- == 0) {
 				ret = chan;
 				break; /* done */
 			}
+			if (!min)
+				min = chan;
+			else if (chan->table_count < min->table_count) {
+				dma_chan_put(min);
+				min = chan;
+			} else
+				dma_chan_put(chan);
 		}
 		if (ret)
 			break; /* done */
@@ -405,6 +383,8 @@ static struct dma_chan *nth_chan(enum dma_transaction_type cap, int n)
 
 	if (!ret)
 		ret = min;
+	else if (min)
+		dma_chan_put(min);
 
 	if (ret)
 		ret->table_count++;
@@ -423,37 +403,39 @@ static struct dma_chan *nth_chan(enum dma_transaction_type cap, int n)
 static void dma_channel_rebalance(void)
 {
 	struct dma_chan *chan;
-	struct dma_device *device;
+	struct dma_chan_tbl_ent *entry;
 	int cpu;
 	int cap;
-	int n;
+	int n = 0;
 
-	/* undo the last distribution */
+	/* save the last distribution */
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
-		for_each_possible_cpu(cpu)
-			per_cpu_ptr(channel_table[cap], cpu)->chan = NULL;
-
-	list_for_each_entry(device, &dma_device_list, global_node) {
-		if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
-			continue;
-		list_for_each_entry(chan, &device->channels, device_node)
-			chan->table_count = 0;
-	}
+		for_each_possible_cpu(cpu) {
+			entry = per_cpu_ptr(channel_table[cap], cpu);
+			entry->prev_chan = entry->chan;
+			entry->chan = NULL;
+			if (entry->prev_chan)
+				entry->prev_chan->table_count--;
+		}
 
-	/* don't populate the channel_table if no clients are available */
-	if (!dmaengine_ref_count)
-		return;
+	/* redistribute available channels if there are clients */
+	if (dmaengine_client_count)
+		for_each_dma_cap_mask(cap, dma_cap_mask_all)
+			for_each_online_cpu(cpu) {
+				if (num_possible_cpus() > 1)
+					chan = nth_chan(cap, n++);
+				else
+					chan = nth_chan(cap, -1);
+				entry = per_cpu_ptr(channel_table[cap], cpu);
+				entry->chan = chan;
+			}
 
-	/* redistribute available channels */
-	n = 0;
+	/* undo the last distribution */
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
-		for_each_online_cpu(cpu) {
-			if (num_possible_cpus() > 1)
-				chan = nth_chan(cap, n++);
-			else
-				chan = nth_chan(cap, -1);
-
-			per_cpu_ptr(channel_table[cap], cpu)->chan = chan;
+		for_each_possible_cpu(cpu) {
+			chan = per_cpu(channel_table[cap]->prev_chan, cpu);
+			if (chan)
+				dma_chan_put(chan);
 		}
 }
 
@@ -511,19 +493,16 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 		chan = private_candidate(mask, device, fn, fn_param);
 		if (chan) {
 			/* Found a suitable channel, try to grab, prep, and
-			 * return it.  We first set DMA_PRIVATE to disable
-			 * balance_ref_count as this channel will not be
-			 * published in the general-purpose allocator
+			 * return it.
 			 */
 			dma_cap_set(DMA_PRIVATE, device->cap_mask);
 			device->privatecnt++;
 			err = dma_chan_get(chan);
 
-			if (err == -ENODEV) {
+			if (err == -ENODEV)
 				pr_debug("%s: %s module removed\n", __func__,
 					 dma_chan_name(chan));
-				list_del_rcu(&device->global_node);
-			} else if (err)
+			else if (err)
 				pr_debug("%s: failed to get %s: (%d)\n",
 					__func__, dma_chan_name(chan), err);
 			else
@@ -560,57 +539,26 @@ EXPORT_SYMBOL_GPL(dma_release_channel);
  */
 void dmaengine_get(void)
 {
-	struct dma_device *device, *_d;
-	struct dma_chan *chan;
-	int err;
-
 	mutex_lock(&dma_list_mutex);
-	dmaengine_ref_count++;
-
-	/* try to grab channels */
-	list_for_each_entry_safe(device, _d, &dma_device_list, global_node) {
-		if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
-			continue;
-		list_for_each_entry(chan, &device->channels, device_node) {
-			err = dma_chan_get(chan);
-			if (err == -ENODEV) {
-				/* module removed before we could use it */
-				list_del_rcu(&device->global_node);
-				break;
-			} else if (err)
-				pr_err("%s: failed to get %s: (%d)\n",
-					__func__, dma_chan_name(chan), err);
-		}
-	}
-
 	/* if this is the first reference and there were channels
 	 * waiting we need to rebalance to get those channels
 	 * incorporated into the channel table
 	 */
-	if (dmaengine_ref_count == 1)
+	if (++dmaengine_client_count == 1)
 		dma_channel_rebalance();
 	mutex_unlock(&dma_list_mutex);
 }
 EXPORT_SYMBOL(dmaengine_get);
 
 /**
- * dmaengine_put - let dma drivers be removed when ref_count == 0
+ * dmaengine_put - deregister interest in dma_channels
  */
 void dmaengine_put(void)
 {
-	struct dma_device *device;
-	struct dma_chan *chan;
-
 	mutex_lock(&dma_list_mutex);
-	dmaengine_ref_count--;
-	BUG_ON(dmaengine_ref_count < 0);
-	/* drop channel references */
-	list_for_each_entry(device, &dma_device_list, global_node) {
-		if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
-			continue;
-		list_for_each_entry(chan, &device->channels, device_node)
-			dma_chan_put(chan);
-	}
+	BUG_ON(dmaengine_client_count <= 0);
+	if (--dmaengine_client_count == 0)
+		dma_channel_rebalance();
 	mutex_unlock(&dma_list_mutex);
 }
 EXPORT_SYMBOL(dmaengine_put);
@@ -773,26 +721,11 @@ int dma_async_device_register(struct dma_device *device)
 	device->chancnt = chancnt;
 
 	mutex_lock(&dma_list_mutex);
-	/* take references on public channels */
-	if (dmaengine_ref_count && !dma_has_cap(DMA_PRIVATE, device->cap_mask))
-		list_for_each_entry(chan, &device->channels, device_node) {
-			/* if clients are already waiting for channels we need
-			 * to take references on their behalf
-			 */
-			if (dma_chan_get(chan) == -ENODEV) {
-				/* note we can only get here for the first
-				 * channel as the remaining channels are
-				 * guaranteed to get a reference
-				 */
-				rc = -ENODEV;
-				mutex_unlock(&dma_list_mutex);
-				goto err_out;
-			}
-		}
 	list_add_tail_rcu(&device->global_node, &dma_device_list);
 	if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
 		device->privatecnt++;	/* Always private */
-	dma_channel_rebalance();
+	else
+		dma_channel_rebalance();
 	mutex_unlock(&dma_list_mutex);
 
 	return 0;
@@ -836,6 +769,14 @@ void dma_async_device_unregister(struct dma_device *device)
 	dma_channel_rebalance();
 	mutex_unlock(&dma_list_mutex);
 
+	/* Check whether it's called from module exit function. */
+	if (try_module_get(device->dev->driver->owner)) {
+		dev_warn(device->dev,
+			"%s isn't called from module exit function.\n",
+			__func__);
+		module_put(device->dev->driver->owner);
+	}
+
 	list_for_each_entry(chan, &device->channels, device_node) {
 		WARN_ONCE(chan->client_count,
 			  "%s called while %d clients hold a reference\n",
-- 
1.7.9.5

