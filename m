Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966464Ab0CPPYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:24:07 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:55170 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966350Ab0CPPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:24:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, James Smart <james.smart@emulex.com>
Subject: [PATCH 2/3] SCSI: lpfc, fix lock imbalances
Date: Tue, 16 Mar 2010 16:23:58 +0100
Message-Id: <1268753039-17214-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1268753039-17214-1-git-send-email-jslaby@suse.cz>
References: <1268753039-17214-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that two error paths in lpfc_bsg_rport_els_cmp and
lpfc_issue_ct_rsp_cmp omits to unlock phba->ct_ev_lock. It is
because they wrongly unlock phba->hbalock instead. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/lpfc/lpfc_bsg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 692c29f..992efb1 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -432,7 +432,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	dd_data = cmdiocbq->context1;
 	/* normal completion and timeout crossed paths, already done */
 	if (!dd_data) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		return;
 	}
 
@@ -1195,7 +1195,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	dd_data = cmdiocbq->context1;
 	/* normal completion and timeout crossed paths, already done */
 	if (!dd_data) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		return;
 	}
 
-- 
1.7.0.1


