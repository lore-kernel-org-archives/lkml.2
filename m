Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602Ab1KCBlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:41:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934578Ab1KCBlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:45 2011
Message-Id: <20111102222745.324713877@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Luben Tuikov <ltuikov@yahoo.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [061/101] USB: storage: Use normalized sense when emulating autosense
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Luben Tuikov <ltuikov@yahoo.com>

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

---
 drivers/usb/storage/transport.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -693,6 +693,9 @@ void usb_stor_invoke_transport(struct sc
 		int temp_result;
 		struct scsi_eh_save ses;
 		int sense_size = US_SENSE_SIZE;
+		struct scsi_sense_hdr sshdr;
+		const u8 *scdd;
+		u8 fm_ili;
 
 		/* device supports and needs bigger sense buffer */
 		if (us->fflags & US_FL_SANE_SENSE)
@@ -776,32 +779,30 @@ Retry_Sense:
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
@@ -816,7 +817,10 @@ Retry_Sense:
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


