Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2HOTtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:52 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62806 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab2HOTts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 040/165] qla2xxx: Correct inadvertent loop state transitions during port-update handling.
Date: Wed, 15 Aug 2012 15:46:24 -0400
Message-ID: <1345060109-9187-41-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 58b48576966ed0afd3f63ef17480ec12748a7119 upstream.

Transitioning to a LOOP_UPDATE loop-state could cause the driver
to miss normal link/target processing.  LOOP_UPDATE is a crufty
artifact leftover from at time the driver performed it's own
internal command-queuing.  Safely remove this state.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 3 ---
 drivers/scsi/qla2xxx/qla_isr.c  | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4229bb4..8e23aa2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3497,15 +3497,12 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 		req = vha->req;
 	rsp = req->rsp;
 
-	atomic_set(&vha->loop_state, LOOP_UPDATE);
 	clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 	if (vha->flags.online) {
 		if (!(rval = qla2x00_fw_ready(vha))) {
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
 			do {
-				atomic_set(&vha->loop_state, LOOP_UPDATE);
-
 				/* Issue a marker after FW becomes ready. */
 				qla2x00_marker(vha, req, rsp, 0, 0,
 					MK_SYNC_ALL);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index db539b0..0266b78 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -724,7 +724,6 @@ skip_rio:
 			vha->flags.rscn_queue_overflow = 1;
 		}
 
-		atomic_set(&vha->loop_state, LOOP_UPDATE);
 		atomic_set(&vha->loop_down_timer, 0);
 		vha->flags.management_server_logged_in = 0;
 
-- 
1.7.12.rc2

