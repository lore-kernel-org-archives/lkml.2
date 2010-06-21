Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab0FUV21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:28:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34154 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab0FUV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:28:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 21 Jun 2010 23:24:35 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] firewire: cdev: fix fw_cdev_event_bus_reset.bm_node_id
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.96072b90a5c06bb3@s5r6.in-berlin.de>
Message-ID: <tkrat.b4e432df46b12230@s5r6.in-berlin.de>
References: <tkrat.96072b90a5c06bb3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an obscure ABI feature that is a bit of a hassle to implement.
However, somebody put it into the ABI, so let's fill in a sensible
value there.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c     |   12 +++++++++---
 drivers/firewire/core-cdev.c     |    2 +-
 drivers/firewire/core-topology.c |    1 +
 include/linux/firewire-cdev.h    |    5 +++++
 include/linux/firewire.h         |    1 +
 5 files changed, 17 insertions(+), 4 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -239,7 +239,7 @@ static void fw_card_bm_work(struct work_
 	struct fw_card *card = container_of(work, struct fw_card, work.work);
 	struct fw_device *root_device, *irm_device;
 	struct fw_node *root_node;
-	int root_id, new_root_id, irm_id, local_id;
+	int root_id, new_root_id, irm_id, bm_id, local_id;
 	int gap_count, generation, grace, rcode;
 	bool do_reset = false;
 	bool root_device_is_running;
@@ -315,9 +315,15 @@ static void fw_card_bm_work(struct work_
 			/* Another bus reset, BM work has been rescheduled. */
 			goto out;
 
-		if (rcode == RCODE_COMPLETE &&
-		    card->bm_transaction_data[0] != cpu_to_be32(0x3f)) {
+		bm_id = be32_to_cpu(card->bm_transaction_data[0]);
 
+		spin_lock_irq(&card->lock);
+		if (rcode == RCODE_COMPLETE && generation == card->generation)
+			card->bm_node_id =
+			    bm_id == 0x3f ? local_id : 0xffc0 | bm_id;
+		spin_unlock_irq(&card->lock);
+
+		if (rcode == RCODE_COMPLETE && bm_id != 0x3f) {
 			/* Somebody else is BM.  Only act as IRM. */
 			if (local_id == irm_id)
 				allocate_broadcast_channel(card, generation);
Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -319,7 +319,7 @@ static void fill_bus_reset_event(struct 
 	event->generation    = client->device->generation;
 	event->node_id       = client->device->node_id;
 	event->local_node_id = card->local_node->node_id;
-	event->bm_node_id    = 0; /* FIXME: We don't track the BM. */
+	event->bm_node_id    = card->bm_node_id;
 	event->irm_node_id   = card->irm_node->node_id;
 	event->root_node_id  = card->root_node->node_id;
 
Index: b/drivers/firewire/core-topology.c
===================================================================
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -552,6 +552,7 @@ void fw_core_handle_bus_reset(struct fw_
 	smp_wmb();
 	card->generation = generation;
 	card->reset_jiffies = jiffies;
+	card->bm_node_id  = 0xffff;
 	card->bm_abdicate = bm_abdicate;
 	fw_schedule_bm_work(card, 0);
 
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -71,6 +71,10 @@ struct fw_cdev_event_common {
  * This event is sent when the bus the device belongs to goes through a bus
  * reset.  It provides information about the new bus configuration, such as
  * new node ID for this device, new root ID, and others.
+ *
+ * If @bm_node_id is 0xffff right after bus reset it can be reread by an
+ * %FW_CDEV_IOC_GET_INFO ioctl after bus manager selection was finished.
+ * Kernels with ABI version < 4 do not set @bm_node_id.
  */
 struct fw_cdev_event_bus_reset {
 	__u64 closure;
@@ -353,6 +357,7 @@ union fw_cdev_event {
  *  3  (2.6.34)  - made &fw_cdev_get_cycle_timer reliable
  *               - added %FW_CDEV_IOC_GET_CYCLE_TIMER2
  *  4  (2.6.36)  - added %FW_CDEV_EVENT_REQUEST2
+ *               - implemented &fw_cdev_event_bus_reset.bm_node_id
  */
 #define FW_CDEV_VERSION 3 /* Meaningless; don't use this macro. */
 
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -119,6 +119,7 @@ struct fw_card {
 	int bm_retries;
 	int bm_generation;
 	__be32 bm_transaction_data[2];
+	int bm_node_id;
 	bool bm_abdicate;
 
 	bool priority_budget_implemented;	/* controller feature */

-- 
Stefan Richter
-=====-==-=- -==- =-=-=
http://arcgraph.de/sr/

