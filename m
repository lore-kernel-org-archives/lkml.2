Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab0GHOJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:09:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55255 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab0GHOJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:09:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Jul 2010 16:09:06 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: integrate software-forced bus resets with bus
 management
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.d1f53bbc87864922@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: core: integrate software-forced bus resets with bus management

Bus resets which are triggered
  - by the kernel drivers after updates of the local nodes' config ROM,
  - by userspace software via ioctl
shall be deferred until after >=2 seconds after the last bus reset.

If multiple modifications of the local nodes' config ROM happen in a row,
only a single bus reset should happen after them.

When the local node's link goes from inactive to active or vice versa,
and at the two occasions of bus resets mentioned above --- and if the
current gap count differs from 63 --- the bus reset should be preceded
by a PHY configuration packet that reaffirms the gap count.  Otherwise a
bus manager would have to reset the bus again right after that.

This is necessary to promote bus stability, e.g. leave grace periods for
allocations and reallocations of isochronous channels and bandwidth,
SBP-2 reconnections etc.; see IEEE 1394 clause 8.2.1.

This change implements all of the above by moving bus reset initiation
into a delayed work (except for bus resets which are triggered by the
bus manager workqueue job and are performed there immediately).  It
comes with a necessary addition to the card driver methods that allows
to get the current gap count from PHY registers.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c        |   68 +++++++++++++++++++++-------
 drivers/firewire/core-cdev.c        |    3 +
 drivers/firewire/core-transaction.c |   18 ++++++-
 drivers/firewire/core.h             |    6 ++
 drivers/firewire/ohci.c             |   53 ++++++++++++++++------
 include/linux/firewire.h            |    6 +-
 6 files changed, 116 insertions(+), 38 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -204,6 +204,45 @@ void fw_core_remove_descriptor(struct fw
 }
 EXPORT_SYMBOL(fw_core_remove_descriptor);
 
+static int reset_bus(struct fw_card *card, bool short_reset)
+{
+	int reg = short_reset ? 5 : 1;
+	int bit = short_reset ? PHY_BUS_SHORT_RESET : PHY_BUS_RESET;
+
+	return card->driver->update_phy_reg(card, reg, 0, bit);
+}
+
+void fw_schedule_bus_reset(struct fw_card *card, bool delayed, bool short_reset)
+{
+	/* We don't try hard to sort out requests of long vs. short resets. */
+	card->br_short = short_reset;
+
+	/* Use an arbitrary short delay to combine multiple reset requests. */
+	fw_card_get(card);
+	if (!schedule_delayed_work(&card->br_work,
+				   delayed ? DIV_ROUND_UP(HZ, 100) : 0))
+		fw_card_put(card);
+}
+EXPORT_SYMBOL(fw_schedule_bus_reset);
+
+static void br_work(struct work_struct *work)
+{
+	struct fw_card *card = container_of(work, struct fw_card, br_work.work);
+
+	/* Delay for 2s after last reset per IEEE 1394 clause 8.2.1. */
+	if (card->reset_jiffies != 0 &&
+	    time_is_after_jiffies(card->reset_jiffies + 2 * HZ)) {
+		if (!schedule_delayed_work(&card->br_work, 2 * HZ))
+			fw_card_put(card);
+		return;
+	}
+
+	fw_send_phy_config(card, FW_PHY_CONFIG_NO_NODE_ID, card->generation,
+			   FW_PHY_CONFIG_CURRENT_GAP_COUNT);
+	reset_bus(card, card->br_short);
+	fw_card_put(card);
+}
+
 static void allocate_broadcast_channel(struct fw_card *card, int generation)
 {
 	int channel, bandwidth = 0;
@@ -230,13 +269,13 @@ static const char gap_count_table[] = {
 void fw_schedule_bm_work(struct fw_card *card, unsigned long delay)
 {
 	fw_card_get(card);
-	if (!schedule_delayed_work(&card->work, delay))
+	if (!schedule_delayed_work(&card->bm_work, delay))
 		fw_card_put(card);
 }
 
-static void fw_card_bm_work(struct work_struct *work)
+static void bm_work(struct work_struct *work)
 {
-	struct fw_card *card = container_of(work, struct fw_card, work.work);
+	struct fw_card *card = container_of(work, struct fw_card, bm_work.work);
 	struct fw_device *root_device, *irm_device;
 	struct fw_node *root_node;
 	int root_id, new_root_id, irm_id, bm_id, local_id;
@@ -427,7 +466,7 @@ static void fw_card_bm_work(struct work_
 		fw_notify("phy config: card %d, new root=%x, gap_count=%d\n",
 			  card->index, new_root_id, gap_count);
 		fw_send_phy_config(card, new_root_id, generation, gap_count);
-		fw_core_initiate_bus_reset(card, 1);
+		reset_bus(card, true);
 		/* Will allocate broadcast channel after the reset. */
 		goto out;
 	}
@@ -479,7 +518,8 @@ void fw_card_initialize(struct fw_card *
 
 	card->local_node = NULL;
 
-	INIT_DELAYED_WORK(&card->work, fw_card_bm_work);
+	INIT_DELAYED_WORK(&card->br_work, br_work);
+	INIT_DELAYED_WORK(&card->bm_work, bm_work);
 }
 EXPORT_SYMBOL(fw_card_initialize);
 
@@ -505,7 +545,6 @@ int fw_card_add(struct fw_card *card,
 }
 EXPORT_SYMBOL(fw_card_add);
 
-
 /*
  * The next few functions implement a dummy driver that is used once a card
  * driver shuts down an fw_card.  This allows the driver to cleanly unload,
@@ -521,6 +560,11 @@ static int dummy_enable(struct fw_card *
 	return -1;
 }
 
+static int dummy_read_phy_reg(struct fw_card *card, int address)
+{
+	return -ENODEV;
+}
+
 static int dummy_update_phy_reg(struct fw_card *card, int address,
 				int clear_bits, int set_bits)
 {
@@ -561,6 +605,7 @@ static int dummy_enable_phys_dma(struct 
 
 static const struct fw_card_driver dummy_driver_template = {
 	.enable          = dummy_enable,
+	.read_phy_reg    = dummy_read_phy_reg,
 	.update_phy_reg  = dummy_update_phy_reg,
 	.set_config_rom  = dummy_set_config_rom,
 	.send_request    = dummy_send_request,
@@ -582,7 +627,7 @@ void fw_core_remove_card(struct fw_card 
 
 	card->driver->update_phy_reg(card, 4,
 				     PHY_LINK_ACTIVE | PHY_CONTENDER, 0);
-	fw_core_initiate_bus_reset(card, 1);
+	fw_schedule_bus_reset(card, false, true);
 
 	mutex_lock(&card_mutex);
 	list_del_init(&card->link);
@@ -602,12 +647,3 @@ void fw_core_remove_card(struct fw_card 
 	WARN_ON(!list_empty(&card->transaction_list));
 }
 EXPORT_SYMBOL(fw_core_remove_card);
-
-int fw_core_initiate_bus_reset(struct fw_card *card, int short_reset)
-{
-	int reg = short_reset ? 5 : 1;
-	int bit = short_reset ? PHY_BUS_SHORT_RESET : PHY_BUS_RESET;
-
-	return card->driver->update_phy_reg(card, reg, 0, bit);
-}
-EXPORT_SYMBOL(fw_core_initiate_bus_reset);
Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -821,8 +821,9 @@ static int ioctl_send_response(struct cl
 
 static int ioctl_initiate_bus_reset(struct client *client, union ioctl_arg *arg)
 {
-	return fw_core_initiate_bus_reset(client->device->card,
+	fw_schedule_bus_reset(client->device->card, true,
 			arg->initiate_bus_reset.type == FW_CDEV_SHORT_RESET);
+	return 0;
 }
 
 static void release_descriptor(struct client *client,
Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -426,9 +426,21 @@ void fw_send_phy_config(struct fw_card *
 			int node_id, int generation, int gap_count)
 {
 	long timeout = DIV_ROUND_UP(HZ, 10);
-	u32 data = PHY_IDENTIFIER(PHY_PACKET_CONFIG) |
-		   PHY_CONFIG_ROOT_ID(node_id) |
-		   PHY_CONFIG_GAP_COUNT(gap_count);
+	u32 data = PHY_IDENTIFIER(PHY_PACKET_CONFIG);
+
+	if (node_id != FW_PHY_CONFIG_NO_NODE_ID)
+		data |= PHY_CONFIG_ROOT_ID(node_id);
+
+	if (gap_count == FW_PHY_CONFIG_CURRENT_GAP_COUNT) {
+		gap_count = card->driver->read_phy_reg(card, 1);
+		if (gap_count < 0)
+			return;
+
+		gap_count &= 63;
+		if (gap_count == 63)
+			return;
+	}
+	data |= PHY_CONFIG_GAP_COUNT(gap_count);
 
 	mutex_lock(&phy_config_mutex);
 
Index: b/drivers/firewire/core.h
===================================================================
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -51,6 +51,7 @@ struct fw_card_driver {
 	int (*enable)(struct fw_card *card,
 		      const __be32 *config_rom, size_t length);
 
+	int (*read_phy_reg)(struct fw_card *card, int address);
 	int (*update_phy_reg)(struct fw_card *card, int address,
 			      int clear_bits, int set_bits);
 
@@ -102,8 +103,8 @@ void fw_card_initialize(struct fw_card *
 int fw_card_add(struct fw_card *card,
 		u32 max_receive, u32 link_speed, u64 guid);
 void fw_core_remove_card(struct fw_card *card);
-int fw_core_initiate_bus_reset(struct fw_card *card, int short_reset);
 int fw_compute_block_crc(__be32 *block);
+void fw_schedule_bus_reset(struct fw_card *card, bool delayed, bool short_reset);
 void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
 
 static inline struct fw_card *fw_card_get(struct fw_card *card)
@@ -225,6 +226,9 @@ void fw_core_handle_response(struct fw_c
 int fw_get_response_length(struct fw_request *request);
 void fw_fill_response(struct fw_packet *response, u32 *request_header,
 		      int rcode, void *payload, size_t length);
+
+#define FW_PHY_CONFIG_NO_NODE_ID	-1
+#define FW_PHY_CONFIG_CURRENT_GAP_COUNT	-1
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count);
 
Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -33,6 +33,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
@@ -182,6 +183,8 @@ struct fw_ohci {
 	 */
 	spinlock_t lock;
 
+	struct mutex phy_reg_mutex;
+
 	struct ar_context ar_request_ctx;
 	struct ar_context ar_response_ctx;
 	struct context at_request_ctx;
@@ -517,13 +520,10 @@ static int write_phy_reg(const struct fw
 	return -EBUSY;
 }
 
-static int ohci_update_phy_reg(struct fw_card *card, int addr,
-			       int clear_bits, int set_bits)
+static int update_phy_reg(struct fw_ohci *ohci, int addr,
+			  int clear_bits, int set_bits)
 {
-	struct fw_ohci *ohci = fw_ohci(card);
-	int ret;
-
-	ret = read_phy_reg(ohci, addr);
+	int ret = read_phy_reg(ohci, addr);
 	if (ret < 0)
 		return ret;
 
@@ -541,13 +541,38 @@ static int read_paged_phy_reg(struct fw_
 {
 	int ret;
 
-	ret = ohci_update_phy_reg(&ohci->card, 7, PHY_PAGE_SELECT, page << 5);
+	ret = update_phy_reg(ohci, 7, PHY_PAGE_SELECT, page << 5);
 	if (ret < 0)
 		return ret;
 
 	return read_phy_reg(ohci, addr);
 }
 
+static int ohci_read_phy_reg(struct fw_card *card, int addr)
+{
+	struct fw_ohci *ohci = fw_ohci(card);
+	int ret;
+
+	mutex_lock(&ohci->phy_reg_mutex);
+	ret = read_phy_reg(ohci, addr);
+	mutex_unlock(&ohci->phy_reg_mutex);
+
+	return ret;
+}
+
+static int ohci_update_phy_reg(struct fw_card *card, int addr,
+			       int clear_bits, int set_bits)
+{
+	struct fw_ohci *ohci = fw_ohci(card);
+	int ret;
+
+	mutex_lock(&ohci->phy_reg_mutex);
+	ret = update_phy_reg(ohci, addr, clear_bits, set_bits);
+	mutex_unlock(&ohci->phy_reg_mutex);
+
+	return ret;
+}
+
 static int ar_context_add_page(struct ar_context *ctx)
 {
 	struct device *dev = ctx->ohci->card.device;
@@ -1681,7 +1706,7 @@ static int configure_1394a_enhancements(
 		clear = PHY_ENABLE_ACCEL | PHY_ENABLE_MULTI;
 		set = 0;
 	}
-	ret = ohci_update_phy_reg(&ohci->card, 5, clear, set);
+	ret = update_phy_reg(ohci, 5, clear, set);
 	if (ret < 0)
 		return ret;
 
@@ -1861,12 +1886,8 @@ static int ohci_enable(struct fw_card *c
 		  OHCI1394_HCControl_BIBimageValid);
 	flush_writes(ohci);
 
-	/*
-	 * We are ready to go, initiate bus reset to finish the
-	 * initialization.
-	 */
-
-	fw_core_initiate_bus_reset(&ohci->card, 1);
+	/* We are ready to go, reset bus to finish initialization. */
+	fw_schedule_bus_reset(&ohci->card, false, true);
 
 	return 0;
 }
@@ -1941,7 +1962,7 @@ static int ohci_set_config_rom(struct fw
 	 * takes effect.
 	 */
 	if (ret == 0)
-		fw_core_initiate_bus_reset(&ohci->card, 1);
+		fw_schedule_bus_reset(&ohci->card, true, true);
 	else
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  next_config_rom, next_config_rom_bus);
@@ -2575,6 +2596,7 @@ static int ohci_queue_iso(struct fw_iso_
 
 static const struct fw_card_driver ohci_driver = {
 	.enable			= ohci_enable,
+	.read_phy_reg		= ohci_read_phy_reg,
 	.update_phy_reg		= ohci_update_phy_reg,
 	.set_config_rom		= ohci_set_config_rom,
 	.send_request		= ohci_send_request,
@@ -2650,6 +2672,7 @@ static int __devinit pci_probe(struct pc
 	pci_set_drvdata(dev, ohci);
 
 	spin_lock_init(&ohci->lock);
+	mutex_init(&ohci->phy_reg_mutex);
 
 	tasklet_init(&ohci->bus_reset_tasklet,
 		     bus_reset_tasklet, (unsigned long)ohci);
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -114,8 +114,10 @@ struct fw_card {
 
 	struct list_head link;
 
-	/* Work struct for BM duties. */
-	struct delayed_work work;
+	struct delayed_work br_work; /* bus reset job */
+	bool br_short;
+
+	struct delayed_work bm_work; /* bus manager job */
 	int bm_retries;
 	int bm_generation;
 	__be32 bm_transaction_data[2];

-- 
Stefan Richter
-=====-==-=- -=== -=---
http://arcgraph.de/sr/

