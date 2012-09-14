Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab2INJ0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:26:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:60696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758675Ab2INJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:26:18 -0400
From: Vinod Koul <vinod.koul@linux.intel.com>
To: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linus.walleij@linaro.org, Jon Hunter <jon-hunter@ti.com>,
        Stephen Warren <swarren@nvidia.com>, Benoit Cousson <b-cousson@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [PATCH] dmaengine: add dmanegine slave map api's
Date: Fri, 14 Sep 2012 15:03:09 +0530
Message-Id: <1347615189-27052-1-git-send-email-vinod.koul@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when allocating a channel the dmaengine finds first channel that matches the
mask and calls filter function
In slave dmaengine model, there already exists a mapping, either hardwired in
SoC or thru a configurable mux. So we typically need channel from controller X
and in same cases a partcular channel Y.

Add new APIs which allow adding channel map for client-dma relationship.
This mapping needs to be registered with dmaengine by platform specfic code
which is aware of this mapping. This mapping needs to be added _before_ any
client tries to access a channel.

Then in order for slave devices to get a channel based on above mapping, add new
slave specfic dmanengine channel request/free APIs

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
---
this is the first attempt to do the slave dma mapping, we have been discussing
this and we all agree to need for this. This is the same patch which was shown
at KS and attempts to build the mapping information within dmaengine which is
platform and arch agnostic.

The arch code like DT/board-files/SFI etc can use these APIs to build dmaengine
mapping and then dmaengine filters channels based on this mapping.

Now Credits:
the orginal idea was from Linus Walleij and has been discussed in similar
format.
---
 drivers/dma/dmaengine.c   |  152 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |   50 +++++++++++++++
 2 files changed, 202 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 3491654..293dfd0 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1066,6 +1066,158 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx)
 }
 EXPORT_SYMBOL_GPL(dma_run_dependencies);
 
+/* slave channel mapping code*/
+static LIST_HEAD(dma_slave_map);
+
+/*called under lock held */
+static struct dma_chan *dmaengine_get_slave_channel(char *requestor, dma_cap_mask_t *mask)
+{
+
+	struct dma_device *device, *_d;
+	struct dma_chan *chan = NULL;
+	int err;
+
+	list_for_each_entry_safe(device, _d, &dma_device_list, global_node) {
+		if (strcmp(requestor, dev_name(device->dev)))
+			continue;
+
+		chan = private_candidate(mask, device, NULL, NULL);
+		if (chan) {
+			/* Found a suitable channel, try to grab, prep, and
+			 * return it.  We first set DMA_PRIVATE to disable
+			 * balance_ref_count as this channel will not be
+			 * published in the general-purpose allocator
+			 */
+			dma_cap_set(DMA_PRIVATE, device->cap_mask);
+			device->privatecnt++;
+			err = dma_chan_get(chan);
+
+			if (err == -ENODEV) {
+				pr_debug("%s: %s module removed\n",
+					 __func__, dma_chan_name(chan));
+				list_del_rcu(&device->global_node);
+			} else if (err)
+				pr_debug("%s: failed to get %s: (%d)\n",
+					 __func__, dma_chan_name(chan), err);
+			else
+				break;
+			if (--device->privatecnt == 0)
+				dma_cap_clear(DMA_PRIVATE, device->cap_mask);
+			chan = NULL;
+		}
+	}
+	return chan;
+}
+
+/**
+ * dmaengine_request_slave_channel - request a slave channel for which damengine
+ * knows the channel mapping
+ *
+ * This is generic API which should work on all arch and doesnt assume any arch
+ * implementation of how map is constructed. Arch code should call map apis to
+ * build the channel map first
+ *
+ * @requestor: client name
+ * @config: dma_slave_config, this is set post channle allocation
+ * @mask: capabilities that the channel must satisfy
+ * @fn: optional filter function should be unused typically
+ * @fn_param: filter fn params
+ */
+struct dma_chan *dmaengine_request_slave_channel(
+		char *requestor, struct dma_slave_config *config,
+		dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param)
+{
+	struct dma_chan *slave = NULL;
+	struct dmaengine_slave_map_entries *entry, *_e;
+
+	/* perhpas we dont need mask arg, it should be slave anyway */
+	if (!__dma_has_cap(DMA_SLAVE, mask))
+		return NULL;
+
+	mutex_lock(&dma_list_mutex);
+	/* find a channel which maps to this request */
+	list_for_each_entry_safe(entry, _e, &dma_slave_map, node) {
+		if (strcmp(requestor, entry->map->client))
+			continue;
+
+		/* have we already allocated this mapping */
+		if (entry->used == true)
+			continue;
+
+		/* now we hit an entry in map,
+		 * see if we can get a channel in controller */
+		slave = dmaengine_get_slave_channel(requestor, mask);
+		if (!slave)
+			continue;
+
+		/* check if client is requesting some specfic slave channel */
+		if ((entry->map->ch != -1) && (entry->map->ch != slave->chan_id))
+			continue;
+
+		/* now call filter fn but it should not be used anyway */
+		if (fn && !fn(slave, fn_param))
+			continue;
+
+		entry->used = true;
+		mutex_unlock(&dma_list_mutex);
+
+		/* pick slave id from map if not set */
+		if (!config->slave_id)
+			config->slave_id = entry->map->slave_id;
+
+		/*now lets set slave params */
+		dmaengine_slave_config(slave, config);
+
+		return slave;
+	}
+	mutex_unlock(&dma_list_mutex);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dmaengine_request_slave_channel);
+
+int dmaengine_add_channel_map(struct dmaengine_slave_map *map,
+		unsigned int num_entries)
+{
+	int i = 0;
+	struct dmaengine_slave_map_entries *entry;
+
+	entry = kzalloc(sizeof(struct dmaengine_slave_map) * num_entries, GFP_KERNEL);
+	if (entry == NULL)
+		return -ENOMEM;
+	entry->num_entries = num_entries;
+	mutex_lock(&dma_list_mutex);
+	for (i = 0; i < num_entries; i++) {
+		entry->map = map;
+		entry->used = false;
+		entry->map->entry = entry;
+		list_add_tail(&entry->node, &dma_slave_map);
+		entry++;
+		map++;
+	}
+	mutex_unlock(&dma_list_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmaengine_add_channel_map);
+
+void dmaengine_free_channel_map(struct dmaengine_slave_map *map)
+{
+	struct dmaengine_slave_map_entries *entry;
+	unsigned int i, num_entries;
+
+	BUG_ON(map);
+	mutex_lock(&dma_list_mutex);
+	entry = map->entry;
+	num_entries = entry->num_entries;
+	for (i = 0; i < num_entries; i++) {
+		list_del(&entry->node);
+		entry++;
+	}
+	kfree(entry);
+	mutex_unlock(&dma_list_mutex);
+	return;
+}
+EXPORT_SYMBOL_GPL(dmaengine_free_channel_map);
+
 static int __init dma_bus_init(void)
 {
 	return class_register(&dma_devclass);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 9c02a45..54dd1d5 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -371,6 +371,35 @@ struct dma_slave_config {
 	unsigned int slave_id;
 };
 
+struct dmaengine_slave_map_entries;
+/* dmaengine slave channel map
+ *
+ * @dma: dma controller, mandatory
+ * @client: clinet associated with the controller, mandatory
+ * @ch: channel index, desired but optional
+ * @slave_id: slave id for programming mux
+ *
+ * the platform needs to tell the channel mapping information to the dmaengine
+ * code thru this structure.
+ * This is used by dmanengine to find the channel to be allocated during
+ * dma_rquest_channel process for slave channels
+ */
+struct dmaengine_slave_map {
+	char *dma;
+	char *client;
+	int ch;
+	int slave_id;
+	struct dmaengine_slave_map_entries *entry;
+};
+
+struct dmaengine_slave_map_entries {
+	struct dmaengine_slave_map *map;
+	bool used;
+	struct list_head node;
+	unsigned int num_entries;
+};
+
+
 static inline const char *dma_chan_name(struct dma_chan *chan)
 {
 	return dev_name(&chan->dev->device);
@@ -974,6 +1003,12 @@ enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
 struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
 void dma_release_channel(struct dma_chan *chan);
+struct dma_chan *dmaengine_request_slave_channel(
+		char *requestor, struct dma_slave_config *config,
+		dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
+int dmaengine_add_channel_map(struct dmaengine_slave_map *map,
+		unsigned int num_entries);
+void dmaengine_free_channel_map(struct dmaengine_slave_map *map);
 #else
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
@@ -990,6 +1025,21 @@ static inline struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask,
 static inline void dma_release_channel(struct dma_chan *chan)
 {
 }
+struct dma_chan *dmaengine_request_slave_channel(
+		char *requestor, struct dma_slave_config *config,
+		dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param)
+{
+	return NULL;
+}
+static inline int dmaengine_add_channel_map(struct dmaengine_slave_map *map,
+		unsigned int num_entries)
+{
+	return -EIO;
+}
+void dmaengine_free_channel_map(struct dmaengine_slave_map *map)
+{
+	return;
+}
 #endif
 
 /* --- DMA device --- */
-- 
1.7.9.5

