Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2BRVDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 16:03:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52754 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2BRVDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 16:03:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Feb 2012 22:03:14 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] firewire: core: prefix log messages with card name
Message-ID: <20120218220314.12a03ddf@stein>
In-Reply-To: <20120218215824.5b2359bf@stein>
References: <20120218215824.5b2359bf@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Associate all log messages from firewire-core with the respective card
because some people have more than one card.  E.g.
    firewire_ohci 0000:04:00.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirks 0x0
    firewire_ohci 0000:05:00.0: added OHCI v1.10 device as card 1, 8 IR + 8 IT contexts, quirks 0x0
    firewire_core: created device fw0: GUID 0814438400000389, S800
    firewire_core: phy config: new root=ffc1, gap_count=5
    firewire_core: created device fw1: GUID 0814438400000388, S800
    firewire_core: created device fw2: GUID 0001d202e06800d1, S800
turns into
    firewire_ohci 0000:04:00.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirks 0x0
    firewire_ohci 0000:05:00.0: added OHCI v1.10 device as card 1, 8 IR + 8 IT contexts, quirks 0x0
    firewire_core 0000:04:00.0: created device fw0: GUID 0814438400000389, S800
    firewire_core 0000:04:00.0: phy config: new root=ffc1, gap_count=5
    firewire_core 0000:05:00.0: created device fw1: GUID 0814438400000388, S800
    firewire_core 0000:04:00.0: created device fw2: GUID 0001d202e06800d1, S800

This increases the module size slightly; to keep this in check, turn the
former printk wrapper macros into functions.  Their implementation is
largely copied from driver core's dev_printk counterparts.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c        |   28 ++++++++++---
 drivers/firewire/core-cdev.c        |   10 ++--
 drivers/firewire/core-device.c      |   60 +++++++++++++---------------
 drivers/firewire/core-topology.c    |   18 ++++----
 drivers/firewire/core-transaction.c |    4 +-
 drivers/firewire/core.h             |    6 +++
 include/linux/firewire.h            |    3 -
 7 files changed, 72 insertions(+), 57 deletions(-)

--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -37,6 +37,22 @@
 
 #include "core.h"
 
+#define define_fw_printk_level(func, kern_level)		\
+void func(const struct fw_card *card, const char *fmt, ...)	\
+{								\
+	struct va_format vaf;					\
+	va_list args;						\
+								\
+	va_start(args, fmt);					\
+	vaf.fmt = fmt;						\
+	vaf.va = &args;						\
+	printk(kern_level KBUILD_MODNAME " %s: %pV",		\
+	       dev_name(card->device), &vaf);			\
+	va_end(args);						\
+}
+define_fw_printk_level(fw_err, KERN_ERR);
+define_fw_printk_level(fw_notice, KERN_NOTICE);
+
 int fw_compute_block_crc(__be32 *block)
 {
 	int length;
@@ -260,7 +276,7 @@ static void allocate_broadcast_channel(s
 		fw_iso_resource_manage(card, generation, 1ULL << 31,
 				       &channel, &bandwidth, true);
 		if (channel != 31) {
-			fw_notify("failed to allocate broadcast channel\n");
+			fw_notice(card, "failed to allocate broadcast channel\n");
 			return;
 		}
 		card->broadcast_channel_allocated = true;
@@ -343,14 +359,14 @@ static void bm_work(struct work_struct *
 
 		if (!card->irm_node->link_on) {
 			new_root_id = local_id;
-			fw_notify("%s, making local node (%02x) root.\n",
+			fw_notice(card, "%s, making local node (%02x) root\n",
 				  "IRM has link off", new_root_id);
 			goto pick_me;
 		}
 
 		if (irm_is_1394_1995_only && !keep_this_irm) {
 			new_root_id = local_id;
-			fw_notify("%s, making local node (%02x) root.\n",
+			fw_notice(card, "%s, making local node (%02x) root\n",
 				  "IRM is not 1394a compliant", new_root_id);
 			goto pick_me;
 		}
@@ -405,7 +421,7 @@ static void bm_work(struct work_struct *
 			 * root, and thus, IRM.
 			 */
 			new_root_id = local_id;
-			fw_notify("%s, making local node (%02x) root.\n",
+			fw_notice(card, "%s, making local node (%02x) root\n",
 				  "BM lock failed", new_root_id);
 			goto pick_me;
 		}
@@ -478,8 +494,8 @@ static void bm_work(struct work_struct *
 	spin_unlock_irq(&card->lock);
 
 	if (do_reset) {
-		fw_notify("phy config: card %d, new root=%x, gap_count=%d\n",
-			  card->index, new_root_id, gap_count);
+		fw_notice(card, "phy config: new root=%x, gap_count=%d\n",
+			  new_root_id, gap_count);
 		fw_send_phy_config(card, new_root_id, generation, gap_count);
 		reset_bus(card, true);
 		/* Will allocate broadcast channel after the reset. */
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -389,7 +389,7 @@ static void queue_bus_reset_event(struct
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (e == NULL) {
-		fw_notify("Out of memory when allocating event\n");
+		fw_notice(client->device->card, "out of memory when allocating event\n");
 		return;
 	}
 
@@ -691,7 +691,7 @@ static void handle_request(struct fw_car
 	r = kmalloc(sizeof(*r), GFP_ATOMIC);
 	e = kmalloc(sizeof(*e), GFP_ATOMIC);
 	if (r == NULL || e == NULL) {
-		fw_notify("Out of memory when allocating event\n");
+		fw_notice(card, "out of memory when allocating event\n");
 		goto failed;
 	}
 	r->card    = card;
@@ -928,7 +928,7 @@ static void iso_callback(struct fw_iso_c
 
 	e = kmalloc(sizeof(*e) + header_length, GFP_ATOMIC);
 	if (e == NULL) {
-		fw_notify("Out of memory when allocating event\n");
+		fw_notice(context->card, "out of memory when allocating event\n");
 		return;
 	}
 	e->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT;
@@ -948,7 +948,7 @@ static void iso_mc_callback(struct fw_is
 
 	e = kmalloc(sizeof(*e), GFP_ATOMIC);
 	if (e == NULL) {
-		fw_notify("Out of memory when allocating event\n");
+		fw_notice(context->card, "out of memory when allocating event\n");
 		return;
 	}
 	e->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL;
@@ -1548,7 +1548,7 @@ void fw_cdev_handle_phy_packet(struct fw
 	list_for_each_entry(client, &card->phy_receiver_list, phy_receiver_link) {
 		e = kmalloc(sizeof(*e) + 8, GFP_ATOMIC);
 		if (e == NULL) {
-			fw_notify("Out of memory when allocating event\n");
+			fw_notice(card, "out of memory when allocating event\n");
 			break;
 		}
 		e->phy_packet.closure	= client->phy_receiver_closure;
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -485,6 +485,7 @@ static int read_rom(struct fw_device *de
  */
 static int read_config_rom(struct fw_device *device, int generation)
 {
+	struct fw_card *card = device->card;
 	const u32 *old_rom, *new_rom;
 	u32 *rom, *stack;
 	u32 sp, key;
@@ -529,12 +530,12 @@ static int read_config_rom(struct fw_dev
 	 */
 	if ((rom[2] & 0x7) < device->max_speed ||
 	    device->max_speed == SCODE_BETA ||
-	    device->card->beta_repeaters_present) {
+	    card->beta_repeaters_present) {
 		u32 dummy;
 
 		/* for S1600 and S3200 */
 		if (device->max_speed == SCODE_BETA)
-			device->max_speed = device->card->link_speed;
+			device->max_speed = card->link_speed;
 
 		while (device->max_speed > SCODE_100) {
 			if (read_rom(device, generation, 0, &dummy) ==
@@ -576,9 +577,9 @@ static int read_config_rom(struct fw_dev
 			 * a firmware bug.  Ignore this whole block, i.e.
 			 * simply set a fake block length of 0.
 			 */
-			fw_error("skipped invalid ROM block %x at %llx\n",
-				 rom[i],
-				 i * 4 | CSR_REGISTER_BASE | CSR_CONFIG_ROM);
+			fw_err(card, "skipped invalid ROM block %x at %llx\n",
+			       rom[i],
+			       i * 4 | CSR_REGISTER_BASE | CSR_CONFIG_ROM);
 			rom[i] = 0;
 			end = i;
 		}
@@ -604,9 +605,10 @@ static int read_config_rom(struct fw_dev
 			 * the ROM don't have to check offsets all the time.
 			 */
 			if (i + (rom[i] & 0xffffff) >= MAX_CONFIG_ROM_SIZE) {
-				fw_error("skipped unsupported ROM entry %x at %llx\n",
-					 rom[i],
-					 i * 4 | CSR_REGISTER_BASE | CSR_CONFIG_ROM);
+				fw_err(card,
+				       "skipped unsupported ROM entry %x at %llx\n",
+				       rom[i],
+				       i * 4 | CSR_REGISTER_BASE | CSR_CONFIG_ROM);
 				rom[i] = 0;
 				continue;
 			}
@@ -673,7 +675,7 @@ static void create_units(struct fw_devic
 		 */
 		unit = kzalloc(sizeof(*unit), GFP_KERNEL);
 		if (unit == NULL) {
-			fw_error("failed to allocate memory for unit\n");
+			fw_err(device->card, "out of memory for unit\n");
 			continue;
 		}
 
@@ -875,7 +877,7 @@ static int lookup_existing_device(struct
 		smp_wmb();  /* update node_id before generation */
 		old->generation = card->generation;
 		old->config_rom_retries = 0;
-		fw_notify("rediscovered device %s\n", dev_name(dev));
+		fw_notice(card, "rediscovered device %s\n", dev_name(dev));
 
 		PREPARE_DELAYED_WORK(&old->work, fw_device_update);
 		fw_schedule_device_work(old, 0);
@@ -956,6 +958,7 @@ static void fw_device_init(struct work_s
 {
 	struct fw_device *device =
 		container_of(work, struct fw_device, work.work);
+	struct fw_card *card = device->card;
 	struct device *revived_dev;
 	int minor, ret;
 
@@ -972,16 +975,16 @@ static void fw_device_init(struct work_s
 			fw_schedule_device_work(device, RETRY_DELAY);
 		} else {
 			if (device->node->link_on)
-				fw_notify("giving up on config rom for node id %x\n",
+				fw_notice(card, "giving up on Config ROM for node id %x\n",
 					  device->node_id);
-			if (device->node == device->card->root_node)
-				fw_schedule_bm_work(device->card, 0);
+			if (device->node == card->root_node)
+				fw_schedule_bm_work(card, 0);
 			fw_device_release(&device->device);
 		}
 		return;
 	}
 
-	revived_dev = device_find_child(device->card->device,
+	revived_dev = device_find_child(card->device,
 					device, lookup_existing_device);
 	if (revived_dev) {
 		put_device(revived_dev);
@@ -1004,7 +1007,7 @@ static void fw_device_init(struct work_s
 
 	device->device.bus = &fw_bus_type;
 	device->device.type = &fw_device_type;
-	device->device.parent = device->card->device;
+	device->device.parent = card->device;
 	device->device.devt = MKDEV(fw_cdev_major, minor);
 	dev_set_name(&device->device, "fw%d", minor);
 
@@ -1016,7 +1019,7 @@ static void fw_device_init(struct work_s
 				&device->attribute_group);
 
 	if (device_add(&device->device)) {
-		fw_error("Failed to add device.\n");
+		fw_err(card, "failed to add device\n");
 		goto error_with_cdev;
 	}
 
@@ -1037,18 +1040,10 @@ static void fw_device_init(struct work_s
 		PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
 		fw_schedule_device_work(device, SHUTDOWN_DELAY);
 	} else {
-		if (device->config_rom_retries)
-			fw_notify("created device %s: GUID %08x%08x, S%d00, "
-				  "%d config ROM retries\n",
-				  dev_name(&device->device),
-				  device->config_rom[3], device->config_rom[4],
-				  1 << device->max_speed,
-				  device->config_rom_retries);
-		else
-			fw_notify("created device %s: GUID %08x%08x, S%d00\n",
-				  dev_name(&device->device),
-				  device->config_rom[3], device->config_rom[4],
-				  1 << device->max_speed);
+		fw_notice(card, "created device %s: GUID %08x%08x, S%d00\n",
+			  dev_name(&device->device),
+			  device->config_rom[3], device->config_rom[4],
+			  1 << device->max_speed);
 		device->config_rom_retries = 0;
 
 		set_broadcast_channel(device, device->generation);
@@ -1060,8 +1055,8 @@ static void fw_device_init(struct work_s
 	 * just end up running the IRM work a couple of extra times -
 	 * pretty harmless.
 	 */
-	if (device->node == device->card->root_node)
-		fw_schedule_bm_work(device->card, 0);
+	if (device->node == card->root_node)
+		fw_schedule_bm_work(card, 0);
 
 	return;
 
@@ -1165,12 +1160,13 @@ static void fw_device_refresh(struct wor
 			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE)
 		goto gone;
 
-	fw_notify("refreshed device %s\n", dev_name(&device->device));
+	fw_notice(card, "refreshed device %s\n", dev_name(&device->device));
 	device->config_rom_retries = 0;
 	goto out;
 
  give_up:
-	fw_notify("giving up on refresh of device %s\n", dev_name(&device->device));
+	fw_notice(card, "giving up on refresh of device %s\n",
+		  dev_name(&device->device));
  gone:
 	atomic_set(&device->state, FW_DEVICE_GONE);
 	PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -205,19 +205,19 @@ static struct fw_node *build_tree(struct
 		next_sid = count_ports(sid, &port_count, &child_port_count);
 
 		if (next_sid == NULL) {
-			fw_error("Inconsistent extended self IDs.\n");
+			fw_err(card, "inconsistent extended self IDs\n");
 			return NULL;
 		}
 
 		q = *sid;
 		if (phy_id != SELF_ID_PHY_ID(q)) {
-			fw_error("PHY ID mismatch in self ID: %d != %d.\n",
-				 phy_id, SELF_ID_PHY_ID(q));
+			fw_err(card, "PHY ID mismatch in self ID: %d != %d\n",
+			       phy_id, SELF_ID_PHY_ID(q));
 			return NULL;
 		}
 
 		if (child_port_count > stack_depth) {
-			fw_error("Topology stack underflow\n");
+			fw_err(card, "topology stack underflow\n");
 			return NULL;
 		}
 
@@ -235,7 +235,7 @@ static struct fw_node *build_tree(struct
 
 		node = fw_node_create(q, port_count, card->color);
 		if (node == NULL) {
-			fw_error("Out of memory while building topology.\n");
+			fw_err(card, "out of memory while building topology\n");
 			return NULL;
 		}
 
@@ -284,8 +284,8 @@ static struct fw_node *build_tree(struct
 		 */
 		if ((next_sid == end && parent_count != 0) ||
 		    (next_sid < end && parent_count != 1)) {
-			fw_error("Parent port inconsistency for node %d: "
-				 "parent_count=%d\n", phy_id, parent_count);
+			fw_err(card, "parent port inconsistency for node %d: "
+			       "parent_count=%d\n", phy_id, parent_count);
 			return NULL;
 		}
 
@@ -530,7 +530,7 @@ void fw_core_handle_bus_reset(struct fw_
 	 */
 	if (!is_next_generation(generation, card->generation) &&
 	    card->local_node != NULL) {
-		fw_notify("skipped bus generations, destroying all nodes\n");
+		fw_notice(card, "skipped bus generations, destroying all nodes\n");
 		fw_destroy_nodes(card);
 		card->bm_retries = 0;
 	}
@@ -557,7 +557,7 @@ void fw_core_handle_bus_reset(struct fw_
 	card->color++;
 
 	if (local_node == NULL) {
-		fw_error("topology build failed\n");
+		fw_err(card, "topology build failed\n");
 		/* FIXME: We need to issue a bus reset in this case. */
 	} else if (card->local_node == NULL) {
 		card->local_node = local_node;
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -770,7 +770,7 @@ static struct fw_request *allocate_reque
 		break;
 
 	default:
-		fw_error("ERROR - corrupt request received - %08x %08x %08x\n",
+		fw_notice(card, "ERROR - corrupt request received - %08x %08x %08x\n",
 			 p->header[0], p->header[1], p->header[2]);
 		return NULL;
 	}
@@ -950,7 +950,7 @@ void fw_core_handle_response(struct fw_c
 
 	if (&t->link == &card->transaction_list) {
  timed_out:
-		fw_notify("Unsolicited response (source %x, tlabel %x)\n",
+		fw_notice(card, "unsolicited response (source %x, tlabel %x)\n",
 			  source, tlabel);
 		return;
 	}
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -1,6 +1,7 @@
 #ifndef _FIREWIRE_CORE_H
 #define _FIREWIRE_CORE_H
 
+#include <linux/compiler.h>
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/list.h>
@@ -24,6 +25,11 @@ struct fw_packet;
 
 /* -card */
 
+extern __printf(2, 3)
+void fw_err(const struct fw_card *card, const char *fmt, ...);
+extern __printf(2, 3)
+void fw_notice(const struct fw_card *card, const char *fmt, ...);
+
 /* bitfields within the PHY registers */
 #define PHY_LINK_ACTIVE		0x80
 #define PHY_CONTENDER		0x40
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -17,9 +17,6 @@
 #include <linux/atomic.h>
 #include <asm/byteorder.h>
 
-#define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
-#define fw_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
-
 #define CSR_REGISTER_BASE		0xfffff0000000ULL
 
 /* register offsets are relative to CSR_REGISTER_BASE */


-- 
Stefan Richter
-=====-===-- --=- =--=-
http://arcgraph.de/sr/
