Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab0HLAC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:02:29 -0400
Received: from kroah.org ([198.145.64.141]:43761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758826Ab0HKX7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:34 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:05 2010
Message-Id: <20100811235505.442127540@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [107/111] [SCSI] aic79xx: check for non-NULL scb in ahd_handle_nonpkt_busfree
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 534ef056db8a8fb6b9d50188d88ed5d1fbc66673 upstream.

When removing several devices aic79xx will occasionally Oops
in ahd_handle_nonpkt_busfree during rescan. Looking at the
code I found that we're indeed not checking if the scb in
question is NULL. So check for it before accessing it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/aic7xxx/aic79xx_core.c |   53 +++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 22 deletions(-)

--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3171,13 +3171,16 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 				tinfo->curr.transport_version = 2;
 				tinfo->goal.transport_version = 2;
 				tinfo->goal.ppr_options = 0;
-				/*
-				 * Remove any SCBs in the waiting for selection
-				 * queue that may also be for this target so
-				 * that command ordering is preserved.
-				 */
-				ahd_freeze_devq(ahd, scb);
-				ahd_qinfifo_requeue_tail(ahd, scb);
+				if (scb != NULL) {
+					/*
+					 * Remove any SCBs in the waiting
+					 * for selection queue that may
+					 * also be for this target so that
+					 * command ordering is preserved.
+					 */
+					ahd_freeze_devq(ahd, scb);
+					ahd_qinfifo_requeue_tail(ahd, scb);
+				}
 				printerror = 0;
 			}
 		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, FALSE)
@@ -3194,13 +3197,16 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 				      MSG_EXT_WDTR_BUS_8_BIT,
 				      AHD_TRANS_CUR|AHD_TRANS_GOAL,
 				      /*paused*/TRUE);
-			/*
-			 * Remove any SCBs in the waiting for selection
-			 * queue that may also be for this target so that
-			 * command ordering is preserved.
-			 */
-			ahd_freeze_devq(ahd, scb);
-			ahd_qinfifo_requeue_tail(ahd, scb);
+			if (scb != NULL) {
+				/*
+				 * Remove any SCBs in the waiting for
+				 * selection queue that may also be for
+				 * this target so that command ordering
+				 * is preserved.
+				 */
+				ahd_freeze_devq(ahd, scb);
+				ahd_qinfifo_requeue_tail(ahd, scb);
+			}
 			printerror = 0;
 		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, FALSE)
 			&& ppr_busfree == 0) {
@@ -3217,13 +3223,16 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 					/*ppr_options*/0,
 					AHD_TRANS_CUR|AHD_TRANS_GOAL,
 					/*paused*/TRUE);
-			/*
-			 * Remove any SCBs in the waiting for selection
-			 * queue that may also be for this target so that
-			 * command ordering is preserved.
-			 */
-			ahd_freeze_devq(ahd, scb);
-			ahd_qinfifo_requeue_tail(ahd, scb);
+			if (scb != NULL) {
+				/*
+				 * Remove any SCBs in the waiting for
+				 * selection queue that may also be for
+				 * this target so that command ordering
+				 * is preserved.
+				 */
+				ahd_freeze_devq(ahd, scb);
+				ahd_qinfifo_requeue_tail(ahd, scb);
+			}
 			printerror = 0;
 		} else if ((ahd->msg_flags & MSG_FLAG_EXPECT_IDE_BUSFREE) != 0
 			&& ahd_sent_msg(ahd, AHDMSG_1B,
@@ -3251,7 +3260,7 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 	 * the message phases.  We check it last in case we
 	 * had to send some other message that caused a busfree.
 	 */
-	if (printerror != 0
+	if (scb != NULL && printerror != 0
 	 && (lastphase == P_MESGIN || lastphase == P_MESGOUT)
 	 && ((ahd->msg_flags & MSG_FLAG_EXPECT_PPR_BUSFREE) != 0)) {
 


