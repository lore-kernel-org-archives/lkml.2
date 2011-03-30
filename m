Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab1C3V2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:28:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:12876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933633Ab1C3VJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735919"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tj@kernel.org, ak@linux.intel.com, jgarzik@redhat.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [186/275] libata: no special completion processing for EH commands
Message-Id: <20110330210709.89C993E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

Index: linux-2.6.35.y/drivers/ata/libata-core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/ata/libata-core.c	2011-03-29 22:50:47.570041221 -0700
+++ linux-2.6.35.y/drivers/ata/libata-core.c	2011-03-29 23:03:02.128245713 -0700
@@ -4946,9 +4946,6 @@
 {
 	struct ata_device *dev = qc->dev;
 
-	if (ata_tag_internal(qc->tag))
-		return;
-
 	if (ata_is_nodata(qc->tf.protocol))
 		return;
 
@@ -4992,14 +4989,23 @@
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
 
