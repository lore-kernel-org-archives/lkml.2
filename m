Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab0E3RxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 13:53:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58879 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0E3RxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 13:53:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 30 May 2010 19:43:52 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: check for 1394a compliant IRM, fix
 inaccessibility of Sony camcorder
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
In-Reply-To: <4C0284E7.3050803@s5r6.in-berlin.de>
Message-ID: <tkrat.740b506673ccbf6d@s5r6.in-berlin.de>
References: <AANLkTimIFRbKWYjFd56acxT2A6nnH6l3-7Q_UyORnonW@mail.gmail.com>
 <4C017477.8000008@s5r6.in-berlin.de> <4C0284E7.3050803@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per IEEE 1394 clause 8.4.2.3, a contender for the IRM role shall check
whether the current IRM complies to 1394a-2000 or later.  If not force a
compliant node (e.g. itself) to become IRM.  This was implemented in the
older ieee1394 driver but not yet in firewire-core.

An older Sony camcorder (Sony DCR-TRV25) which implements 1394-1995 IRM
but neither 1394a-2000 IRM nor BM was now found to cause an
interoperability bug:
  - Camcorder becomes root node when plugged in, hence gets IRM role.
  - firewire-core successfully contends for BM role, proceeds to perform
    gap count optimization and resets the bus.
  - Sony camcorder ignores presence of a BM (against the spec, this is
    a firmware bug), performs its idea of gap count optimization and
    resets the bus.
  - Preceding two steps are repeated endlessly, bus never settles,
    regular I/O is practically impossible.
http://thread.gmane.org/gmane.linux.kernel.firewire.user/3913

This is an interoperability regression from the old to the new drivers.
Fix it indirectly by adding the 1394a IRM check.  The spec suggests
three and a half methods to determine 1394a compliance of a remote IRM;
we choose the method of testing the Config_ROM.Bus_Info.generation
field.  This is data that firewire-core should have readily available at
this point, i.e. does not require extra I/O.

Reported-by: Clemens Ladisch <clemens@ladisch.de> (missing 1394a check)
Reported-by: H. S. (issue with Sony DCR-TRV25)
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

The patch was generated against the latest kernel sources but is
applicable with harmless line offsets to the 2.6.32.y stable kernel
series too.  Hence it should be applicable to Debian's 2.6.32 sources as
well.

H. S., could you please test this?  *If* this fixes the issue, may I add
your mail address in a Tested-By signature to the changelog as described
at
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmittingPatches;h=72651f788f4e3536149ef5e7ddfbed96a8f14d2f;hb=HEAD#l412
?

 drivers/firewire/core-card.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -231,7 +231,7 @@ void fw_schedule_bm_work(struct fw_card 
 static void fw_card_bm_work(struct work_struct *work)
 {
 	struct fw_card *card = container_of(work, struct fw_card, work.work);
-	struct fw_device *root_device;
+	struct fw_device *root_device, *irm_device;
 	struct fw_node *root_node;
 	unsigned long flags;
 	int root_id, new_root_id, irm_id, local_id;
@@ -239,6 +239,7 @@ static void fw_card_bm_work(struct work_
 	bool do_reset = false;
 	bool root_device_is_running;
 	bool root_device_is_cmc;
+	bool irm_is_1394_1995_only;
 
 	spin_lock_irqsave(&card->lock, flags);
 
@@ -248,12 +249,18 @@ static void fw_card_bm_work(struct work_
 	}
 
 	generation = card->generation;
+
 	root_node = card->root_node;
 	fw_node_get(root_node);
 	root_device = root_node->data;
 	root_device_is_running = root_device &&
 			atomic_read(&root_device->state) == FW_DEVICE_RUNNING;
 	root_device_is_cmc = root_device && root_device->cmc;
+
+	irm_device = card->irm_node->data;
+	irm_is_1394_1995_only = irm_device && irm_device->config_rom &&
+			(irm_device->config_rom[2] & 0x000000f0) == 0;
+
 	root_id  = root_node->node_id;
 	irm_id   = card->irm_node->node_id;
 	local_id = card->local_node->node_id;
@@ -276,8 +283,15 @@ static void fw_card_bm_work(struct work_
 
 		if (!card->irm_node->link_on) {
 			new_root_id = local_id;
-			fw_notify("IRM has link off, making local node (%02x) root.\n",
-				  new_root_id);
+			fw_notify("%s, making local node (%02x) root.\n",
+				  "IRM has link off", new_root_id);
+			goto pick_me;
+		}
+
+		if (irm_is_1394_1995_only) {
+			new_root_id = local_id;
+			fw_notify("%s, making local node (%02x) root.\n",
+				  "IRM is not 1394a compliant", new_root_id);
 			goto pick_me;
 		}
 
@@ -316,8 +330,8 @@ static void fw_card_bm_work(struct work_
 			 * root, and thus, IRM.
 			 */
 			new_root_id = local_id;
-			fw_notify("BM lock failed, making local node (%02x) root.\n",
-				  new_root_id);
+			fw_notify("%s, making local node (%02x) root.\n",
+				  "BM lock failed", new_root_id);
 			goto pick_me;
 		}
 	} else if (card->bm_generation != generation) {

-- 
Stefan Richter
-=====-==-=- -=-= ====-
http://arcgraph.de/sr/

