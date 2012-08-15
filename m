Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2HOTuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:21 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62862 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab2HOTuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 054/165] 3w-9xxx: fix iommu_iova leak
Date: Wed, 15 Aug 2012 15:46:38 -0400
Message-ID: <1345060109-9187-55-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <JBottomley@Parallels.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 96067723e46b0dd24ae7b934085ab4eff4d26a1b upstream.

Following reports on the list, it looks like the 3e-9xxx driver will leak dma
mappings every time we get a transient queueing error back from the card.
This is because it maps the sg list in the routine that sends the command, but
doesn't unmap again in the transient failure path (even though the command is
sent back to the block layer).  Fix by unmapping before returning the status.

Reported-by: Chris Boot <bootc@bootc.net>
Tested-by: Chris Boot <bootc@bootc.net>
Acked-by: Adam Radford <aradford@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/3w-9xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e9788f5..3499131 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1794,10 +1794,12 @@ static int twa_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 	switch (retval) {
 	case SCSI_MLQUEUE_HOST_BUSY:
 		twa_free_request_id(tw_dev, request_id);
+		twa_unmap_scsi_data(tw_dev, request_id);
 		break;
 	case 1:
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		twa_free_request_id(tw_dev, request_id);
+		twa_unmap_scsi_data(tw_dev, request_id);
 		SCpnt->result = (DID_ERROR << 16);
 		done(SCpnt);
 		retval = 0;
-- 
1.7.12.rc2

