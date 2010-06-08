Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0FHMrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:47:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60793 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0FHMrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:47:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 8 Jun 2010 14:46:41 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.023786185c945b6d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive one update which is merely a fix for an old problem from the
POV of the new firewire subsystem, but is a regression fix for those who
migrated from the older ieee1394 to the firewire subsystem.

Stefan Richter (1):
      firewire: core: check for 1394a compliant IRM, fix inaccessibility of Sony camcorder

 drivers/firewire/core-card.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)


Long story because it is a post -rc1 pull request:

This update does *not* affect behavior of firewire-core in presence of
professional video devices, professional audio devices, storage devices,
IP-over-1394 capable nodes.  It *does* change behavior in presence of
consumer video devices, but in a way that mirrors what the ieee1394 core
driver has always been doing and what I suppose 1394 stacks or other
popular OSs do, a way to which 1394-1995 compliant devices are forwards
compatible and which 1394a-2000 and later specs explicitly require to be
implemented.

I suspect that there were more and earlier reports of this
interoperability bug of firewire-core with broken firmwares on Sony
camcorders, but I may have easily mistaken them for mere signs of
degraded old hardware on the electrical level instead of an actual
software/firmware problem.  Due to feature differences between ieee1394
core and firewire-core we never noticed this firmware bug with the older
stack.

commit 10389536742cefbedecb67a5b2906f155cf3a1c3
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun May 30 19:43:52 2010 +0200

    firewire: core: check for 1394a compliant IRM, fix inaccessibility of Sony camcorder
    
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
    Reported-by: H. S. <hs.samix@gmail.com> (issue with Sony DCR-TRV25)
    Tested-by: H. S. <hs.samix@gmail.com>
    
    Cc: <stable@kernel.org> # .32.x and newer
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 9dcb304..371713f 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -231,7 +231,7 @@ void fw_schedule_bm_work(struct fw_card *card, unsigned long delay)
 static void fw_card_bm_work(struct work_struct *work)
 {
 	struct fw_card *card = container_of(work, struct fw_card, work.work);
-	struct fw_device *root_device;
+	struct fw_device *root_device, *irm_device;
 	struct fw_node *root_node;
 	unsigned long flags;
 	int root_id, new_root_id, irm_id, local_id;
@@ -239,6 +239,7 @@ static void fw_card_bm_work(struct work_struct *work)
 	bool do_reset = false;
 	bool root_device_is_running;
 	bool root_device_is_cmc;
+	bool irm_is_1394_1995_only;
 
 	spin_lock_irqsave(&card->lock, flags);
 
@@ -248,12 +249,18 @@ static void fw_card_bm_work(struct work_struct *work)
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
@@ -276,8 +283,15 @@ static void fw_card_bm_work(struct work_struct *work)
 
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
 
@@ -316,8 +330,8 @@ static void fw_card_bm_work(struct work_struct *work)
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


Thanks,
-- 
Stefan Richter
-=====-==-=- -==- -=---
http://arcgraph.de/sr/


