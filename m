Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1CUXNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:13:38 -0400
Received: from kroah.org ([198.145.64.141]:48918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab1CUXNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:51 2011
Message-Id: <20110321231051.147810165@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:09:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [04/44] libata: no special completion processing for EH commands
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
 


