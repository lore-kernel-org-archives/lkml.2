Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2DWN4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:56:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46808 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2DWN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:56:34 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v1 4/8] dmaengine: use atomic_t for struct dma_chan->client_count field
Date: Mon, 23 Apr 2012 21:51:45 +0800
Message-Id: <1335189109-4871-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
References: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use atomic_t for struct dma_chan->client_count field to prepare for
DMA device hotplug.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dma/dmaengine.c   |   41 ++++++++++++++++++++++++++---------------
 include/linux/dmaengine.h |    4 ++++
 2 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 198d891..da7a683 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -62,6 +62,18 @@
 #include <linux/idr.h>
 #include <linux/slab.h>
 
+#ifndef	CONFIG_DMA_ENGINE_HOTPLUG
+#define	dma_chan_ref_read(chan)		((chan)->client_count)
+#define	dma_chan_ref_set(chan, v)	((chan)->client_count = (v))
+#define	dma_chan_ref_inc(chan)		((chan)->client_count++)
+#define	dma_chan_ref_dec_and_test(ch)	(--(chan)->client_count == 0)
+#else	/* CONFIG_DMA_ENGINE_HOTPLUG */
+#define	dma_chan_ref_read(chan)		atomic_read(&(chan)->client_count)
+#define	dma_chan_ref_set(chan, v)	atomic_set(&(chan)->client_count, (v))
+#define	dma_chan_ref_inc(chan)		atomic_inc(&(chan)->client_count)
+#define	dma_chan_ref_dec_and_test(ch)	atomic_dec_and_test(&(ch)->client_count)
+#endif	/* CONFIG_DMA_ENGINE_HOTPLUG */
+
 static DEFINE_MUTEX(dma_list_mutex);
 static DEFINE_IDR(dma_idr);
 static LIST_HEAD(dma_device_list);
@@ -132,7 +144,7 @@ static ssize_t show_in_use(struct device *dev, struct device_attribute *attr, ch
 	mutex_lock(&dma_list_mutex);
 	chan = dev_to_dma_chan(dev);
 	if (chan)
-		err = sprintf(buf, "%d\n", chan->client_count);
+		err = sprintf(buf, "%d\n", dma_chan_ref_read(chan));
 	else
 		err = -ENODEV;
 	mutex_unlock(&dma_list_mutex);
@@ -201,15 +213,15 @@ static int dma_chan_get(struct dma_chan *chan)
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	chan->client_count++;
+	dma_chan_ref_inc(chan);
 
 	/* allocate upon first client reference */
-	if (chan->client_count == 1) {
+	if (dma_chan_ref_read(chan) == 1) {
 		int desc_cnt = chan->device->device_alloc_chan_resources(chan);
 
 		if (desc_cnt < 0) {
 			err = desc_cnt;
-			chan->client_count = 0;
+			dma_chan_ref_set(chan, 0);
 			module_put(owner);
 		}
 	}
@@ -225,9 +237,8 @@ static int dma_chan_get(struct dma_chan *chan)
  */
 static void dma_chan_put(struct dma_chan *chan)
 {
-	BUG_ON(chan->client_count <= 0);
-	chan->client_count--;
-	if (chan->client_count == 0)
+	BUG_ON(dma_chan_ref_read(chan) <= 0);
+	if (dma_chan_ref_dec_and_test(chan))
 		chan->device->device_free_chan_resources(chan);
 	module_put(dma_chan_to_owner(chan));
 }
@@ -341,7 +352,7 @@ void dma_issue_pending_all(void)
 		if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
 			continue;
 		list_for_each_entry(chan, &device->channels, device_node)
-			if (chan->client_count)
+			if (dma_chan_ref_read(chan))
 				device->device_issue_pending(chan);
 	}
 	rcu_read_unlock();
@@ -460,12 +471,12 @@ static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_devic
 	if (dev->chancnt > 1 && !dma_has_cap(DMA_PRIVATE, dev->cap_mask))
 		list_for_each_entry(chan, &dev->channels, device_node) {
 			/* some channels are already publicly allocated */
-			if (chan->client_count)
+			if (dma_chan_ref_read(chan))
 				return NULL;
 		}
 
 	list_for_each_entry(chan, &dev->channels, device_node) {
-		if (chan->client_count) {
+		if (dma_chan_ref_read(chan)) {
 			pr_debug("%s: %s busy\n",
 				 __func__, dma_chan_name(chan));
 			continue;
@@ -530,8 +541,8 @@ EXPORT_SYMBOL_GPL(__dma_request_channel);
 void dma_release_channel(struct dma_chan *chan)
 {
 	mutex_lock(&dma_list_mutex);
-	WARN_ONCE(chan->client_count != 1,
-		  "chan reference count %d != 1\n", chan->client_count);
+	WARN_ONCE(dma_chan_ref_read(chan) != 1,
+		  "chan reference count %d != 1\n", dma_chan_ref_read(chan));
 	dma_chan_put(chan);
 	/* drop PRIVATE cap enabled by __dma_request_channel() */
 	if (--chan->device->privatecnt == 0)
@@ -722,7 +733,7 @@ int dma_async_device_register(struct dma_device *device)
 			atomic_dec(idr_ref);
 			goto err_out;
 		}
-		chan->client_count = 0;
+		dma_chan_ref_set(chan, 0);
 	}
 	device->chancnt = chancnt;
 
@@ -784,9 +795,9 @@ void dma_async_device_unregister(struct dma_device *device)
 	}
 
 	list_for_each_entry(chan, &device->channels, device_node) {
-		WARN_ONCE(chan->client_count,
+		WARN_ONCE(dma_chan_ref_read(chan),
 			  "%s called while %d clients hold a reference\n",
-			  __func__, chan->client_count);
+			  __func__, dma_chan_ref_read(chan));
 		mutex_lock(&dma_list_mutex);
 		chan->dev->chan = NULL;
 		mutex_unlock(&dma_list_mutex);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index f9a2e5e..d1532dc 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -279,7 +279,11 @@ struct dma_chan {
 
 	struct list_head device_node;
 	struct dma_chan_percpu __percpu *local;
+#ifdef	CONFIG_DMA_ENGINE_HOTPLUG
+	atomic_t client_count;
+#else
 	int client_count;
+#endif
 	int table_count;
 	void *private;
 };
-- 
1.7.5.4

