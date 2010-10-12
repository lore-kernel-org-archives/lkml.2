Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab0JLV3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:29:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45927 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0JLV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:29:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 12 Oct 2010 23:29:15 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: core: use non-reentrant workqueue with
 rescuer
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
Message-ID: <tkrat.5d99b60dc100a6d0@s5r6.in-berlin.de>
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

firewire-core manages the following types of work items:

fw_card.br_work:
  - resets the bus on a card and possibly sends a PHY packet before that
  - does not sleep for long or not at all
  - is scheduled via fw_schedule_bus_reset() by
      - firewire-ohci's pci_probe method
      - firewire-ohci's set_config_rom method, called by kernelspace
        protocol drivers and userspace drivers which add/remove
	Configuration ROM descriptors
      - userspace drivers which use the bus reset ioctl
      - itself if the last reset happened less than 2 seconds ago

fw_card.bm_work:
  - performs bus management duties
  - usually does not (but may in corner cases) sleep for long
  - is scheduled via fw_schedule_bm_work() by
      - firewire-ohci's self-ID-complete IRQ handler tasklet
      - firewire-core's fw_device.work instances whenever the root node
        device was (successfully or unsuccessfully) discovered,
	refreshed, or rediscovered
      - itself in case of resource allocation failures or in order to
        obey the 125ms bus manager arbitration interval

fw_device.work:
  - performs node probe, update, shutdown, revival, removal; including
    kernel driver probe, update, shutdown and bus reset notification to
    userspace drivers
  - usually sleeps moderately long, in corner cases very long
  - is scheduled by
      - firewire-ohci's self-ID-complete IRQ handler tasklet via the
        core's fw_node_event
      - firewire-ohci's pci_remove method via core's fw_destroy_nodes/
        fw_node_event
      - itself during retries, e.g. while a node is powering up

iso_resource.work:
  - accesses registers at the Isochronous Resource Manager node
  - usually does not (but may in corner cases) sleep for long
  - is scheduled via schedule_iso_resource() by
      - the owning userspace driver at addition and removal of the
        resource
      - firewire-core's fw_device.work instances after bus reset
      - itself in case of resource allocation if necessary to obey the
        1000ms reallocation period after bus reset

fw_card.br_work instances should not, and instances of the others must
not, be executed in parallel by multiple CPUs -- but were not protected
against that.  Hence allocated a non-reentrant workqueue for them.

fw_device.work may be used in the memory reclaim path in case of SBP-2
device updates.  Hence we need a workqueue with rescuer and cannot use
system_nrt_wq.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c        |    6 +++---
 drivers/firewire/core-cdev.c        |    2 +-
 drivers/firewire/core-device.c      |   30 ++++++++++++++++++----------
 drivers/firewire/core-transaction.c |   12 ++++++++++-
 drivers/firewire/core.h             |    2 ++
 5 files changed, 36 insertions(+), 16 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -219,8 +219,8 @@ void fw_schedule_bus_reset(struct fw_car
 
 	/* Use an arbitrary short delay to combine multiple reset requests. */
 	fw_card_get(card);
-	if (!schedule_delayed_work(&card->br_work,
-				   delayed ? DIV_ROUND_UP(HZ, 100) : 0))
+	if (!queue_delayed_work(fw_wq, &card->br_work,
+				delayed ? DIV_ROUND_UP(HZ, 100) : 0))
 		fw_card_put(card);
 }
 EXPORT_SYMBOL(fw_schedule_bus_reset);
@@ -232,7 +232,7 @@ static void br_work(struct work_struct *
 	/* Delay for 2s after last reset per IEEE 1394 clause 8.2.1. */
 	if (card->reset_jiffies != 0 &&
 	    time_is_after_jiffies(card->reset_jiffies + 2 * HZ)) {
-		if (!schedule_delayed_work(&card->br_work, 2 * HZ))
+		if (!queue_delayed_work(fw_wq, &card->br_work, 2 * HZ))
 			fw_card_put(card);
 		return;
 	}
Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -149,7 +149,7 @@ static void release_iso_resource(struct 
 static void schedule_iso_resource(struct iso_resource *r, unsigned long delay)
 {
 	client_get(r->client);
-	if (!schedule_delayed_work(&r->work, delay))
+	if (!queue_delayed_work(fw_wq, &r->work, delay))
 		client_put(r->client);
 }
 
Index: b/drivers/firewire/core-device.c
===================================================================
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -725,6 +725,14 @@ struct fw_device *fw_device_get_by_devt(
 	return device;
 }
 
+struct workqueue_struct *fw_wq;
+
+static void fw_schedule_device_work(struct fw_device *device,
+				    unsigned long delay)
+{
+	queue_delayed_work(fw_wq, &device->work, delay);
+}
+
 /*
  * These defines control the retry behavior for reading the config
  * rom.  It shouldn't be necessary to tweak these; if the device
@@ -749,7 +757,7 @@ static void fw_device_shutdown(struct wo
 
 	if (time_is_after_jiffies(device->card->reset_jiffies + SHUTDOWN_DELAY)
 	    && !list_empty(&device->card->link)) {
-		schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
+		fw_schedule_device_work(device, SHUTDOWN_DELAY);
 		return;
 	}
 
@@ -861,7 +869,7 @@ static int lookup_existing_device(struct
 		fw_notify("rediscovered device %s\n", dev_name(dev));
 
 		PREPARE_DELAYED_WORK(&old->work, fw_device_update);
-		schedule_delayed_work(&old->work, 0);
+		fw_schedule_device_work(old, 0);
 
 		if (current_node == card->root_node)
 			fw_schedule_bm_work(card, 0);
@@ -952,7 +960,7 @@ static void fw_device_init(struct work_s
 		if (device->config_rom_retries < MAX_RETRIES &&
 		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;
-			schedule_delayed_work(&device->work, RETRY_DELAY);
+			fw_schedule_device_work(device, RETRY_DELAY);
 		} else {
 			fw_notify("giving up on config rom for node id %x\n",
 				  device->node_id);
@@ -1017,7 +1025,7 @@ static void fw_device_init(struct work_s
 			   FW_DEVICE_INITIALIZING,
 			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE) {
 		PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
-		schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
+		fw_schedule_device_work(device, SHUTDOWN_DELAY);
 	} else {
 		if (device->config_rom_retries)
 			fw_notify("created device %s: GUID %08x%08x, S%d00, "
@@ -1096,7 +1104,7 @@ static void fw_device_refresh(struct wor
 		if (device->config_rom_retries < MAX_RETRIES / 2 &&
 		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;
-			schedule_delayed_work(&device->work, RETRY_DELAY / 2);
+			fw_schedule_device_work(device, RETRY_DELAY / 2);
 
 			return;
 		}
@@ -1129,7 +1137,7 @@ static void fw_device_refresh(struct wor
 		if (device->config_rom_retries < MAX_RETRIES &&
 		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;
-			schedule_delayed_work(&device->work, RETRY_DELAY);
+			fw_schedule_device_work(device, RETRY_DELAY);
 
 			return;
 		}
@@ -1156,7 +1164,7 @@ static void fw_device_refresh(struct wor
  gone:
 	atomic_set(&device->state, FW_DEVICE_GONE);
 	PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
-	schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
+	fw_schedule_device_work(device, SHUTDOWN_DELAY);
  out:
 	if (node_id == card->root_node->node_id)
 		fw_schedule_bm_work(card, 0);
@@ -1209,7 +1217,7 @@ void fw_node_event(struct fw_card *card,
 		 * first config rom scan half a second after bus reset.
 		 */
 		INIT_DELAYED_WORK(&device->work, fw_device_init);
-		schedule_delayed_work(&device->work, INITIAL_DELAY);
+		fw_schedule_device_work(device, INITIAL_DELAY);
 		break;
 
 	case FW_NODE_INITIATED_RESET:
@@ -1224,7 +1232,7 @@ void fw_node_event(struct fw_card *card,
 			    FW_DEVICE_RUNNING,
 			    FW_DEVICE_INITIALIZING) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_refresh);
-			schedule_delayed_work(&device->work,
+			fw_schedule_device_work(device,
 				device->is_local ? 0 : INITIAL_DELAY);
 		}
 		break;
@@ -1239,7 +1247,7 @@ void fw_node_event(struct fw_card *card,
 		device->generation = card->generation;
 		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
-			schedule_delayed_work(&device->work, 0);
+			fw_schedule_device_work(device, 0);
 		}
 		break;
 
@@ -1264,7 +1272,7 @@ void fw_node_event(struct fw_card *card,
 		if (atomic_xchg(&device->state,
 				FW_DEVICE_GONE) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
-			schedule_delayed_work(&device->work,
+			fw_schedule_device_work(device,
 				list_empty(&card->link) ? 0 : SHUTDOWN_DELAY);
 		}
 		break;
Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -36,6 +36,7 @@
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 
 #include <asm/byteorder.h>
 
@@ -1192,13 +1193,21 @@ static int __init fw_core_init(void)
 {
 	int ret;
 
+	fw_wq = alloc_workqueue(KBUILD_MODNAME,
+				WQ_NON_REENTRANT | WQ_RESCUER, 0);
+	if (!fw_wq)
+		return -ENOMEM;
+
 	ret = bus_register(&fw_bus_type);
-	if (ret < 0)
+	if (ret < 0) {
+		destroy_workqueue(fw_wq);
 		return ret;
+	}
 
 	fw_cdev_major = register_chrdev(0, "firewire", &fw_device_ops);
 	if (fw_cdev_major < 0) {
 		bus_unregister(&fw_bus_type);
+		destroy_workqueue(fw_wq);
 		return fw_cdev_major;
 	}
 
@@ -1214,6 +1223,7 @@ static void __exit fw_core_cleanup(void)
 {
 	unregister_chrdev(fw_cdev_major, "firewire");
 	bus_unregister(&fw_bus_type);
+	destroy_workqueue(fw_wq);
 	idr_destroy(&fw_device_idr);
 }
 
Index: b/drivers/firewire/core.h
===================================================================
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -138,6 +138,8 @@ void fw_cdev_handle_phy_packet(struct fw
 extern struct rw_semaphore fw_device_rwsem;
 extern struct idr fw_device_idr;
 extern int fw_cdev_major;
+struct workqueue_struct;
+extern struct workqueue_struct *fw_wq;
 
 struct fw_device *fw_device_get_by_devt(dev_t devt);
 int fw_device_set_broadcast_channel(struct device *dev, void *gen);

-- 
Stefan Richter
-=====-==-=- =-=- -==--
http://arcgraph.de/sr/

