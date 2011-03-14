Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1CNXIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:08:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45997 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1CNXIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:08:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 15 Mar 2011 00:08:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: core: ignore link-active bit of new nodes, fix
 device recognition
Message-ID: <20110315000841.46230773@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like the older ieee1394 core driver, firewire-core skipped scanning of
any new node whose PHY sent a self ID without "link active" bits.  If a
device had this bit off mistakenly, it meant that it was inaccessible to
kernel drivers with the old IEEE 1394 driver stack but could still be
accessed by userspace drivers through the raw1394 interface.

But with firewire-core, userspace drivers don't get to see such buggy
devices anymore.  This is effectively a driver regression since this
device bug is otherwise harmless.

We now attempt to scan all devices, even repeaters that don't have a
link or powered-down devices that have everything but their PHY shut
down when plugged in.  This results in futile repeated scanning attempts
in case of such devices that really don't have an active link, but this
doesn't hurt since recent workqueue infrastructure lets us run more
concurrent scanning jobs than we can shake a stick at.

This should fix accessibility of Focusrite Saffire PRO 26 I/O:
http://sourceforge.net/mailarchive/forum.php?thread_name=20110314215622.5c751bb0%40stein&forum_name=ffado-user

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

Index: b/drivers/firewire/core-device.c
===================================================================
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -955,8 +955,9 @@ static void fw_device_init(struct work_s
 			device->config_rom_retries++;
 			schedule_delayed_work(&device->work, RETRY_DELAY);
 		} else {
-			fw_notify("giving up on config rom for node id %x\n",
-				  device->node_id);
+			if (device->node->link_on)
+				fw_notify("giving up on config rom for node id %x\n",
+					  device->node_id);
 			if (device->node == device->card->root_node)
 				fw_schedule_bm_work(device->card, 0);
 			fw_device_release(&device->device);
@@ -1169,9 +1170,12 @@ void fw_node_event(struct fw_card *card,
 
 	switch (event) {
 	case FW_NODE_CREATED:
-	case FW_NODE_LINK_ON:
-		if (!node->link_on)
-			break;
+		/*
+		 * Attempt to scan the node, regardless whether its self ID has
+		 * the L (link active) flag set or not.  Some broken devices
+		 * send L=0 but have an up-and-running link; others send L=1
+		 * without actually having a link.
+		 */
  create:
 		device = kzalloc(sizeof(*device), GFP_ATOMIC);
 		if (device == NULL)
@@ -1214,6 +1218,7 @@ void fw_node_event(struct fw_card *card,
 		break;
 
 	case FW_NODE_INITIATED_RESET:
+	case FW_NODE_LINK_ON:
 		device = node->data;
 		if (device == NULL)
 			goto create;
@@ -1231,10 +1236,10 @@ void fw_node_event(struct fw_card *card,
 		break;
 
 	case FW_NODE_UPDATED:
-		if (!node->link_on || node->data == NULL)
+		device = node->data;
+		if (device == NULL)
 			break;
 
-		device = node->data;
 		device->node_id = node->node_id;
 		smp_wmb();  /* update node_id before generation */
 		device->generation = card->generation;


-- 
Stefan Richter
-=====-==-== --== -====
http://arcgraph.de/sr/
