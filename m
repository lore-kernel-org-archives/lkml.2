Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0HPT6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:58:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53987 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0HPT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:58:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 16 Aug 2010 21:58:03 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: sbp2: fix memory leak in sbp2_cancel_orbs or at
 send error
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.330c42bb8ceb6a7a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an ORB was canceled (Command ORB i.e. SCSI request timed out, or
Management ORB timed out), or there was a send error in the initial
transaction, we missed to drop one of the ORB's references and thus
leaked memory.

Background:
In total, we hold 3 references to each Operation Request Block:
  - 1 during sbp2_scsi_queuecommand() or sbp2_send_management_orb()
    respectively,
  - 1 for the duration of the write transaction to the ORB_Pointer or
    Management_Agent register of the target,
  - 1 for as long as the ORB stays within the lu->orb_list, until
    the ORB is unlinked from the list and the orb->callback was
    executed.

The latter one of these 3 references is finished
  - normally by sbp2_status_write() when the target wrote status
    for a pending ORB,
  - or by sbp2_cancel_orbs() in case of an ORB time-out,
  - or by complete_transaction() in case of a send error.
Of them, the latter two lacked the kref_put.

Add the missing kref_put()s.  Add comments to the gets and puts of
references for transaction callbacks and ORB callbacks so that it is
easier to see what is supposed to happen.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -450,7 +450,7 @@ static void sbp2_status_write(struct fw_
 
 	if (&orb->link != &lu->orb_list) {
 		orb->callback(orb, &status);
-		kref_put(&orb->kref, free_orb);
+		kref_put(&orb->kref, free_orb); /* orb callback reference */
 	} else {
 		fw_error("status write for unknown orb\n");
 	}
@@ -480,12 +480,14 @@ static void complete_transaction(struct 
 	if (orb->rcode != RCODE_COMPLETE) {
 		list_del(&orb->link);
 		spin_unlock_irqrestore(&card->lock, flags);
+
 		orb->callback(orb, NULL);
+		kref_put(&orb->kref, free_orb); /* orb callback reference */
 	} else {
 		spin_unlock_irqrestore(&card->lock, flags);
 	}
 
-	kref_put(&orb->kref, free_orb);
+	kref_put(&orb->kref, free_orb); /* transaction callback reference */
 }
 
 static void sbp2_send_orb(struct sbp2_orb *orb, struct sbp2_logical_unit *lu,
@@ -501,9 +503,8 @@ static void sbp2_send_orb(struct sbp2_or
 	list_add_tail(&orb->link, &lu->orb_list);
 	spin_unlock_irqrestore(&device->card->lock, flags);
 
-	/* Take a ref for the orb list and for the transaction callback. */
-	kref_get(&orb->kref);
-	kref_get(&orb->kref);
+	kref_get(&orb->kref); /* transaction callback reference */
+	kref_get(&orb->kref); /* orb callback reference */
 
 	fw_send_request(device->card, &orb->t, TCODE_WRITE_BLOCK_REQUEST,
 			node_id, generation, device->max_speed, offset,
@@ -530,6 +531,7 @@ static int sbp2_cancel_orbs(struct sbp2_
 
 		orb->rcode = RCODE_CANCELLED;
 		orb->callback(orb, NULL);
+		kref_put(&orb->kref, free_orb); /* orb callback reference */
 	}
 
 	return retval;

-- 
Stefan Richter
-=====-==-=- =--- =----
http://arcgraph.de/sr/

