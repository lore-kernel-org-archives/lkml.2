Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab1FWRkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:40:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:35846 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933684Ab1FWRjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:39:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tejun Heo <tj@kernel.org>,
        Jeff Garzik <jgarzik@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 168/247] libata: no special completion processing for EH commands
Date: Thu, 23 Jun 2011 13:33:56 -0400
Message-Id: <1308850515-15242-109-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ata/libata-core.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5405b36..6e4b795 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5038,9 +5038,6 @@ static void ata_verify_xfer(struct ata_queued_cmd *qc)
 {
 	struct ata_device *dev = qc->dev;
 
-	if (ata_tag_internal(qc->tag))
-		return;
-
 	if (ata_is_nodata(qc->tf.protocol))
 		return;
 
@@ -5084,14 +5081,23 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
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
 
-- 
1.7.4.4

