Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab1KCBjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:39:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab1KCBjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:39:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:41 2011
Message-Id: <20111102222741.771750124@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [023/101] [SCSI] qla2xxx: Correct inadvertent loop state transitions during port-update handling.
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 58b48576966ed0afd3f63ef17480ec12748a7119 upstream.

Transitioning to a LOOP_UPDATE loop-state could cause the driver
to miss normal link/target processing.  LOOP_UPDATE is a crufty
artifact leftover from at time the driver performed it's own
internal command-queuing.  Safely remove this state.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---
 drivers/scsi/qla2xxx/qla_init.c |    3 ---
 drivers/scsi/qla2xxx/qla_isr.c  |    1 -
 2 files changed, 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3481,15 +3481,12 @@ qla2x00_loop_resync(scsi_qla_host_t *vha
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
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -723,7 +723,6 @@ skip_rio:
 			vha->flags.rscn_queue_overflow = 1;
 		}
 
-		atomic_set(&vha->loop_state, LOOP_UPDATE);
 		atomic_set(&vha->loop_down_timer, 0);
 		vha->flags.management_server_logged_in = 0;
 


