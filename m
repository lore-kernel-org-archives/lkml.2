Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0JJO4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 10:56:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57322 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0JJO4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 10:56:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 10 Oct 2010 16:55:55 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: use non-reentrant workqueue where necessary
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Message-ID: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
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
  - should not be executed in parallel by multiple CPUs but was not
    strictly protected against that

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
  - must not be executed in parallel by multiple CPUs but was not
    strictly protected against that

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
  - must not be executed in parallel by multiple CPUs but was not
    strictly protected against that

iso_resource.work:
  - accesses registers at the Isochronous Resource Manager node
  - usually does not (but may in corner cases) sleep for long
  - is scheduled via schedule_iso_resource() by
      - the owning userspace driver at addition and removal of the
        resource
      - firewire-core's fw_device.work instances after bus reset
      - itself in case of resource allocation if necessary to obey the
        1000ms reallocation period after bus reset
  - must not be executed in parallel by multiple CPUs but was not
    strictly protected against that

Therefore queue all of these types of work items on system_nrt_wq
instead of system_wq.  The former guarantees non-reentrance across all
CPUs, the latter only on the CPU which schedules a work item.

As a bonus, other subsystems which flush system_wq won't be held up if
the firewire subsystem spends a lot of time in an extraordinarily long
fw_device.work.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c   |    6 +++---
 drivers/firewire/core-cdev.c   |    2 +-
 drivers/firewire/core-device.c |   28 +++++++++++++++++-----------
 3 files changed, 21 insertions(+), 15 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -219,8 +219,8 @@ void fw_schedule_bus_reset(struct fw_car
 
 	/* Use an arbitrary short delay to combine multiple reset requests. */
 	fw_card_get(card);
-	if (!schedule_delayed_work(&card->br_work,
-				   delayed ? DIV_ROUND_UP(HZ, 100) : 0))
+	if (!queue_delayed_work(system_nrt_wq, &card->br_work,
+				delayed ? DIV_ROUND_UP(HZ, 100) : 0))
 		fw_card_put(card);
 }
 EXPORT_SYMBOL(fw_schedule_bus_reset);
@@ -232,7 +232,7 @@ static void br_work(struct work_struct *
 	/* Delay for 2s after last reset per IEEE 1394 clause 8.2.1. */
 	if (card->reset_jiffies != 0 &&
 	    time_is_after_jiffies(card->reset_jiffies + 2 * HZ)) {
-		if (!schedule_delayed_work(&card->br_work, 2 * HZ))
+		if (!queue_delayed_work(system_nrt_wq, &card->br_work, 2 * HZ))
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
+	if (!queue_delayed_work(system_nrt_wq, &r->work, delay))
 		client_put(r->client);
 }
 
Index: b/drivers/firewire/core-device.c
===================================================================
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -725,6 +725,12 @@ struct fw_device *fw_device_get_by_devt(
 	return device;
 }
 
+static void fw_schedule_device_work(struct fw_device *device,
+				    unsigned long delay)
+{
+	queue_delayed_work(system_nrt_wq, &device->work, delay);
+}
+
 /*
  * These defines control the retry behavior for reading the config
  * rom.  It shouldn't be necessary to tweak these; if the device
@@ -749,7 +755,7 @@ static void fw_device_shutdown(struct wo
 
 	if (time_is_after_jiffies(device->card->reset_jiffies + SHUTDOWN_DELAY)
 	    && !list_empty(&device->card->link)) {
-		schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
+		fw_schedule_device_work(device, SHUTDOWN_DELAY);
 		return;
 	}
 
@@ -861,7 +867,7 @@ static int lookup_existing_device(struct
 		fw_notify("rediscovered device %s\n", dev_name(dev));
 
 		PREPARE_DELAYED_WORK(&old->work, fw_device_update);
-		schedule_delayed_work(&old->work, 0);
+		fw_schedule_device_work(old, 0);
 
 		if (current_node == card->root_node)
 			fw_schedule_bm_work(card, 0);
@@ -952,7 +958,7 @@ static void fw_device_init(struct work_s
 		if (device->config_rom_retries < MAX_RETRIES &&
 		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;
-			schedule_delayed_work(&device->work, RETRY_DELAY);
+			fw_schedule_device_work(device, RETRY_DELAY);
 		} else {
 			fw_notify("giving up on config rom for node id %x\n",
 				  device->node_id);
@@ -1017,7 +1023,7 @@ static void fw_device_init(struct work_s
 			   FW_DEVICE_INITIALIZING,
 			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE) {
 		PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
-		schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
+		fw_schedule_device_work(device, SHUTDOWN_DELAY);
 	} else {
 		if (device->config_rom_retries)
 			fw_notify("created device %s: GUID %08x%08x, S%d00, "
@@ -1096,7 +1102,7 @@ static void fw_device_refresh(struct wor
 		if (device->config_rom_retries < MAX_RETRIES / 2 &&
 		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;
-			schedule_delayed_work(&device->work, RETRY_DELAY / 2);
+			fw_schedule_device_work(device, RETRY_DELAY / 2);
 
 			return;
 		}
@@ -1129,7 +1135,7 @@ static void fw_device_refresh(struct wor
 		if (device->config_rom_retries < MAX_RETRIES &&
 		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;
-			schedule_delayed_work(&device->work, RETRY_DELAY);
+			fw_schedule_device_work(device, RETRY_DELAY);
 
 			return;
 		}
@@ -1156,7 +1162,7 @@ static void fw_device_refresh(struct wor
  gone:
 	atomic_set(&device->state, FW_DEVICE_GONE);
 	PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
-	schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
+	fw_schedule_device_work(device, SHUTDOWN_DELAY);
  out:
 	if (node_id == card->root_node->node_id)
 		fw_schedule_bm_work(card, 0);
@@ -1209,7 +1215,7 @@ void fw_node_event(struct fw_card *card,
 		 * first config rom scan half a second after bus reset.
 		 */
 		INIT_DELAYED_WORK(&device->work, fw_device_init);
-		schedule_delayed_work(&device->work, INITIAL_DELAY);
+		fw_schedule_device_work(device, INITIAL_DELAY);
 		break;
 
 	case FW_NODE_INITIATED_RESET:
@@ -1224,7 +1230,7 @@ void fw_node_event(struct fw_card *card,
 			    FW_DEVICE_RUNNING,
 			    FW_DEVICE_INITIALIZING) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_refresh);
-			schedule_delayed_work(&device->work,
+			fw_schedule_device_work(device,
 				device->is_local ? 0 : INITIAL_DELAY);
 		}
 		break;
@@ -1239,7 +1245,7 @@ void fw_node_event(struct fw_card *card,
 		device->generation = card->generation;
 		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
-			schedule_delayed_work(&device->work, 0);
+			fw_schedule_device_work(device, 0);
 		}
 		break;
 
@@ -1264,7 +1270,7 @@ void fw_node_event(struct fw_card *card,
 		if (atomic_xchg(&device->state,
 				FW_DEVICE_GONE) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
-			schedule_delayed_work(&device->work,
+			fw_schedule_device_work(device,
 				list_empty(&card->link) ? 0 : SHUTDOWN_DELAY);
 		}
 		break;

-- 
Stefan Richter
-=====-==-=- =-=- -=-=-
http://arcgraph.de/sr/

