Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1DYU1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:27:42 -0400
Received: from 1wt.eu ([62.212.114.60]:34663 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542Ab1DYU1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:27:40 -0400
Message-Id: <20110425200236.471595358@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 080/173] libata: no special completion processing for EH commands
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit f08dc1ac6b15c681f4643d8da1700e06c3855608 upstream.

ata_qc_complete() contains special handling for certain commands.  For
example, it schedules EH for device revalidation after certain
configurations are changed.  These shouldn't be applied to EH
commands but they were.

In most cases, it doesn't cause an actual problem because EH doesn't
issue any command which would trigger special handling; however, ACPI
can issue such commands via _GTF which can cause weird interactions.

Restructure ata_qc_complete() such that EH commands are always passed
on to __ata_qc_complete().

stable: Please apply to -stable only after 2.6.38 is released.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5016,9 +5016,6 @@ static void ata_verify_xfer(struct ata_q
 {
 	struct ata_device *dev = qc->dev;
 
-	if (ata_tag_internal(qc->tag))
-		return;
-
 	if (ata_is_nodata(qc->tf.protocol))
 		return;
 
@@ -5062,14 +5059,23 @@ void ata_qc_complete(struct ata_queued_c
 		if (unlikely(qc->err_mask))
 			qc->flags |= ATA_QCFLAG_FAILED;
 
-		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
-			/* always fill result TF for failed qc */
+		/*
+		 * Finish internal commands without any further processing
+		 * and always with the result TF filled.
+		 */
+		if (unlikely(ata_tag_internal(qc->tag))) {
 			fill_result_tf(qc);
+			__ata_qc_complete(qc);
+			return;
+		}
 
-			if (!ata_tag_internal(qc->tag))
-				ata_qc_schedule_eh(qc);
-			else
-				__ata_qc_complete(qc);
+		/*
+		 * Non-internal qc has failed.  Fill the result TF and
+		 * summon EH.
+		 */
+		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
+			fill_result_tf(qc);
+			ata_qc_schedule_eh(qc);
 			return;
 		}
 


