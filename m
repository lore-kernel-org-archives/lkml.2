Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab0HPUNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:13:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54053 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0HPUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:13:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 16 Aug 2010 22:13:34 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] firewire: sbp2: fix stall with "Unsolicited response"
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.330c42bb8ceb6a7a@s5r6.in-berlin.de>
Message-ID: <tkrat.d1f4cde2efe6d756@s5r6.in-berlin.de>
References: <tkrat.330c42bb8ceb6a7a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix I/O stalls with some 4-bay RAID enclosures which are based on
OXUF936QSE:
  - Onnto dataTale RSM4QO, old firmware (not anymore with current
    firmware),
  - inXtron Hydra Super-S LCM, old as well as current firmware
when used in RAID-5 mode, perhaps also in other RAID modes.

The stalls happen during heavy or moderate disk traffic in periods that
are a multiple of 5 minutes, roughly twice per hour.  They are caused
by the target responding too late to an ORB_Pointer register write:
The target responds after Split_Timeout, hence firewire-core cancels
the transaction, and firewire-sbp2 fails the SCSI request.  The SCSI
core retries the request, that fails again (and again), hence SCSI core
calls firewire-sbp2's abort handler (and even the Management_Agent
register write in the abort handler has the transaction timeout
problem).

During all that, the process which issued the I/O is stalled in I/O
wait state.

Meanwhile, the target actually acts on the first failed SCSI request:
It responds to the ORB_Pointer write later (seen in the kernel log as
"firewire_core: Unsolicited response") and also finishes the SCSI
request with proper status (seen in the kernel log as "firewire_sbp2:
status write for unknown orb").

So let's just ignore RCODE_CANCELLED in the transaction callback and
wait for the target to complete the ORB nevertheless.  This requires
a small modification is sbp2_cancel_orbs(); it now needs to call
orb->callback() regardless whether fw_cancel_transaction() found the
transaction unfinished or finished.

A different solution which has been proven to work too is to increase
Split_Timeout on the local node.  (Tested: 2000ms timeout; maybe 1000ms
or something like that works too.  200ms is insufficient.  Standard is
100ms.)  However, I rather not do this because any software on any node
could change the Split_Timeout to something unsuitable.  Or such a large
Split_Timeout might be undesirable for other purposes.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

BTW, these "Unsolicited response"s from bad 963QSE firmwares seem to be
reproducible only on FireWire 800 buses, not in case of FireWire 400/
1394a.

 drivers/firewire/sbp2.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -472,12 +472,18 @@ static void complete_transaction(struct 
 	 * So this callback only sets the rcode if it hasn't already
 	 * been set and only does the cleanup if the transaction
 	 * failed and we didn't already get a status write.
+	 *
+	 * Here we treat RCODE_CANCELLED like RCODE_COMPLETE because some
+	 * OXUF936QSE firmwares occasionally respond after Split_Timeout and
+	 * complete the ORB just fine.  Note, we also get RCODE_CANCELLED
+	 * from sbp2_cancel_orbs() if fw_cancel_transaction() == 0.
 	 */
 	spin_lock_irqsave(&card->lock, flags);
 
 	if (orb->rcode == -1)
 		orb->rcode = rcode;
-	if (orb->rcode != RCODE_COMPLETE) {
+
+	if (orb->rcode != RCODE_COMPLETE && orb->rcode != RCODE_CANCELLED) {
 		list_del(&orb->link);
 		spin_unlock_irqrestore(&card->lock, flags);
 
@@ -526,8 +532,7 @@ static int sbp2_cancel_orbs(struct sbp2_
 
 	list_for_each_entry_safe(orb, next, &list, link) {
 		retval = 0;
-		if (fw_cancel_transaction(device->card, &orb->t) == 0)
-			continue;
+		fw_cancel_transaction(device->card, &orb->t);
 
 		orb->rcode = RCODE_CANCELLED;
 		orb->callback(orb, NULL);

-- 
Stefan Richter
-=====-==-=- =--- =----
http://arcgraph.de/sr/

