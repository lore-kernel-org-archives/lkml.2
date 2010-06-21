Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab0FUV1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:27:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34150 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597Ab0FUV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:27:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 21 Jun 2010 23:23:52 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: core: no need to track irq flags in bm_work
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.96072b90a5c06bb3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a workqueue job and always entered with IRQs enabled.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -239,7 +239,6 @@ static void fw_card_bm_work(struct work_
 	struct fw_card *card = container_of(work, struct fw_card, work.work);
 	struct fw_device *root_device, *irm_device;
 	struct fw_node *root_node;
-	unsigned long flags;
 	int root_id, new_root_id, irm_id, local_id;
 	int gap_count, generation, grace, rcode;
 	bool do_reset = false;
@@ -247,10 +246,10 @@ static void fw_card_bm_work(struct work_
 	bool root_device_is_cmc;
 	bool irm_is_1394_1995_only;
 
-	spin_lock_irqsave(&card->lock, flags);
+	spin_lock_irq(&card->lock);
 
 	if (card->local_node == NULL) {
-		spin_unlock_irqrestore(&card->lock, flags);
+		spin_unlock_irq(&card->lock);
 		goto out_put_card;
 	}
 
@@ -305,7 +304,7 @@ static void fw_card_bm_work(struct work_
 		card->bm_transaction_data[0] = cpu_to_be32(0x3f);
 		card->bm_transaction_data[1] = cpu_to_be32(local_id);
 
-		spin_unlock_irqrestore(&card->lock, flags);
+		spin_unlock_irq(&card->lock);
 
 		rcode = fw_run_transaction(card, TCODE_LOCK_COMPARE_SWAP,
 				irm_id, generation, SCODE_100,
@@ -336,7 +335,7 @@ static void fw_card_bm_work(struct work_
 			goto out;
 		}
 
-		spin_lock_irqsave(&card->lock, flags);
+		spin_lock_irq(&card->lock);
 
 		if (rcode != RCODE_COMPLETE) {
 			/*
@@ -355,7 +354,7 @@ static void fw_card_bm_work(struct work_
 		 * We weren't BM in the last generation, and the last
 		 * bus reset is less than 125ms ago.  Reschedule this job.
 		 */
-		spin_unlock_irqrestore(&card->lock, flags);
+		spin_unlock_irq(&card->lock);
 		fw_schedule_bm_work(card, DIV_ROUND_UP(HZ, 8));
 		goto out;
 	}
@@ -378,7 +377,7 @@ static void fw_card_bm_work(struct work_
 		 * If we haven't probed this device yet, bail out now
 		 * and let's try again once that's done.
 		 */
-		spin_unlock_irqrestore(&card->lock, flags);
+		spin_unlock_irq(&card->lock);
 		goto out;
 	} else if (root_device_is_cmc) {
 		/*
@@ -416,7 +415,7 @@ static void fw_card_bm_work(struct work_
 	    (card->gap_count != gap_count || new_root_id != root_id))
 		do_reset = true;
 
-	spin_unlock_irqrestore(&card->lock, flags);
+	spin_unlock_irq(&card->lock);
 
 	if (do_reset) {
 		fw_notify("phy config: card %d, new root=%x, gap_count=%d\n",

-- 
Stefan Richter
-=====-==-=- -==- =-=-=
http://arcgraph.de/sr/

