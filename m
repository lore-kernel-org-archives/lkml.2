Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab1BPAvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:51:02 -0500
Received: from kroah.org ([198.145.64.141]:46034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174Ab1BPAux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:12 2011
Message-Id: <20110216002112.051600919@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 130/176] firewire: core: fix unstable I/O with Canon camcorder
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 6044565af458e7fa6e748bff437ecc49dea88d79 upstream.

Regression since commit 10389536742c, "firewire: core: check for 1394a
compliant IRM, fix inaccessibility of Sony camcorder":

The camcorder Canon MV5i generates lots of bus resets when asynchronous
requests are sent to it (e.g. Config ROM read requests or FCP Command
write requests) if the camcorder is not root node.  This causes drop-
outs in videos or makes the camcorder entirely inaccessible.
https://bugzilla.redhat.com/show_bug.cgi?id=633260

Fix this by allowing any Canon device, even if it is a pre-1394a IRM
like MV5i are, to remain root node (if it is at least Cycle Master
capable).  With the FireWire controller cards that I tested, MV5i always
becomes root node when plugged in and left to its own devices.

Reported-by: Ralf Lange
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/core-card.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -75,6 +75,8 @@ static size_t config_rom_length = 1 + 4
 #define BIB_IRMC		((1) << 31)
 #define NODE_CAPABILITIES	0x0c0083c0 /* per IEEE 1394 clause 8.3.2.6.5.2 */
 
+#define CANON_OUI		0x000085
+
 static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
 {
 	struct fw_descriptor *desc;
@@ -284,6 +286,7 @@ static void bm_work(struct work_struct *
 	bool root_device_is_running;
 	bool root_device_is_cmc;
 	bool irm_is_1394_1995_only;
+	bool keep_this_irm;
 
 	spin_lock_irq(&card->lock);
 
@@ -305,6 +308,10 @@ static void bm_work(struct work_struct *
 	irm_is_1394_1995_only = irm_device && irm_device->config_rom &&
 			(irm_device->config_rom[2] & 0x000000f0) == 0;
 
+	/* Canon MV5i works unreliably if it is not root node. */
+	keep_this_irm = irm_device && irm_device->config_rom &&
+			irm_device->config_rom[3] >> 8 == CANON_OUI;
+
 	root_id  = root_node->node_id;
 	irm_id   = card->irm_node->node_id;
 	local_id = card->local_node->node_id;
@@ -333,7 +340,7 @@ static void bm_work(struct work_struct *
 			goto pick_me;
 		}
 
-		if (irm_is_1394_1995_only) {
+		if (irm_is_1394_1995_only && !keep_this_irm) {
 			new_root_id = local_id;
 			fw_notify("%s, making local node (%02x) root.\n",
 				  "IRM is not 1394a compliant", new_root_id);
@@ -382,7 +389,7 @@ static void bm_work(struct work_struct *
 
 		spin_lock_irq(&card->lock);
 
-		if (rcode != RCODE_COMPLETE) {
+		if (rcode != RCODE_COMPLETE && !keep_this_irm) {
 			/*
 			 * The lock request failed, maybe the IRM
 			 * isn't really IRM capable after all. Let's


