Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2HOTuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62910 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab2HOTug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Luben Tuikov <ltuikov@yahoo.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 072/165] USB: storage: Use normalized sense when emulating autosense
Date: Wed, 15 Aug 2012 15:46:56 -0400
Message-ID: <1345060109-9187-73-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luben Tuikov <ltuikov@yahoo.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e16da02fcdf1c5e824432f88abf42623dafdf191 upstream.

This patch solves two things:
1) Enables autosense emulation code to correctly
interpret descriptor format sense data, and
2) Fixes a bug whereby the autosense emulation
code would overwrite descriptor format sense data
with SENSE KEY HARDWARE ERROR in fixed format, to
incorrectly look like this:

Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  Sense Key : Recovered Error [current] [descriptor]
Oct 21 14:11:07 localhost kernel: Descriptor sense data with sense descriptors (in hex):
Oct 21 14:11:07 localhost kernel:        72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
Oct 21 14:11:07 localhost kernel:        00 4f 00 c2 00 50
Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  ASC=0x4 ASCQ=0x1d

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/storage/transport.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index f253ede..0ea5426 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -695,6 +695,9 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		int temp_result;
 		struct scsi_eh_save ses;
 		int sense_size = US_SENSE_SIZE;
+		struct scsi_sense_hdr sshdr;
+		const u8 *scdd;
+		u8 fm_ili;
 
 		/* device supports and needs bigger sense buffer */
 		if (us->fflags & US_FL_SANE_SENSE)
@@ -778,32 +781,30 @@ Retry_Sense:
 			srb->sense_buffer[7] = (US_SENSE_SIZE - 8);
 		}
 
+		scsi_normalize_sense(srb->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+				     &sshdr);
+
 		US_DEBUGP("-- Result from auto-sense is %d\n", temp_result);
 		US_DEBUGP("-- code: 0x%x, key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
-			  srb->sense_buffer[0],
-			  srb->sense_buffer[2] & 0xf,
-			  srb->sense_buffer[12], 
-			  srb->sense_buffer[13]);
+			  sshdr.response_code, sshdr.sense_key,
+			  sshdr.asc, sshdr.ascq);
 #ifdef CONFIG_USB_STORAGE_DEBUG
-		usb_stor_show_sense(
-			  srb->sense_buffer[2] & 0xf,
-			  srb->sense_buffer[12], 
-			  srb->sense_buffer[13]);
+		usb_stor_show_sense(sshdr.sense_key, sshdr.asc, sshdr.ascq);
 #endif
 
 		/* set the result so the higher layers expect this data */
 		srb->result = SAM_STAT_CHECK_CONDITION;
 
+		scdd = scsi_sense_desc_find(srb->sense_buffer,
+					    SCSI_SENSE_BUFFERSIZE, 4);
+		fm_ili = (scdd ? scdd[3] : srb->sense_buffer[2]) & 0xA0;
+
 		/* We often get empty sense data.  This could indicate that
 		 * everything worked or that there was an unspecified
 		 * problem.  We have to decide which.
 		 */
-		if (	/* Filemark 0, ignore EOM, ILI 0, no sense */
-				(srb->sense_buffer[2] & 0xaf) == 0 &&
-			/* No ASC or ASCQ */
-				srb->sense_buffer[12] == 0 &&
-				srb->sense_buffer[13] == 0) {
-
+		if (sshdr.sense_key == 0 && sshdr.asc == 0 && sshdr.ascq == 0 &&
+		    fm_ili == 0) {
 			/* If things are really okay, then let's show that.
 			 * Zero out the sense buffer so the higher layers
 			 * won't realize we did an unsolicited auto-sense.
@@ -818,7 +819,10 @@ Retry_Sense:
 			 */
 			} else {
 				srb->result = DID_ERROR << 16;
-				srb->sense_buffer[2] = HARDWARE_ERROR;
+				if ((sshdr.response_code & 0x72) == 0x72)
+					srb->sense_buffer[1] = HARDWARE_ERROR;
+				else
+					srb->sense_buffer[2] = HARDWARE_ERROR;
 			}
 		}
 	}
-- 
1.7.12.rc2

