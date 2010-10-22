Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab0JVVMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:12:54 -0400
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:27515 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757563Ab0JVVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:12:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=mww/Gsg6BsG6FAwbW35GHabkvuAu/tCHPs6NVNx6qS1vHl1u9rji4LO88WEt6VM1Q+lR7BjtA5s3c3v8u0MjIFTVdrnG8hSUDNN+KcDh+qHOm8Ppevz38KrZxBGtSYtDtT8D8efu3LjlSkVa2lR5Ajh4laC/7oB41n4pS/wyCWs=;
Message-ID: <985163.58416.qm@web31807.mail.mud.yahoo.com>
X-YMail-OSG: LY1JBsoVM1nGIpTzAj0N_OptziqXENkCUtX17cv37osA.tL
 9CVoQcrpnxpCyJLHB42QO3yWH2InGyyO7JdYLYLrwVkey8vyEGwCS.ZiEFGz
 T2oCE6rjpLqjtEyMpDqSjeqxCWDtRBwaWStjiSCXRCzIx1CPr4AYuWrYq5Fq
 16rcP4MDMdqd8_iJgic8PUP_bxeVSdVkuUh62Xr3gBtDKvSco4lghfB_NSUi
 Fii5eE47K9DlHGgFUt37yEj8imea0LTJP0S0xesrThdH_Lih_0QktsofK5Hn
 63PdiU.yf7A1N0g5IEN_X_s0lBE_FLhaZQ7O6t7IDxBlGV0ljpkvASoHpYY_
 _OUW84Ktmysp5HcsQEhcrmUr_afeHYuilbA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Fri, 22 Oct 2010 14:12:51 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [PATCH take 2] [USB] Use normalized sense when emulating autosense
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/usb/storage/transport.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 64ec073..cb04664 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -691,6 +691,9 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		int temp_result;
 		struct scsi_eh_save ses;
 		int sense_size = US_SENSE_SIZE;
+		struct scsi_sense_hdr sshdr;
+		const u8 *scdd;
+		u8 fm_ili;
 
 		/* device supports and needs bigger sense buffer */
 		if (us->fflags & US_FL_SANE_SENSE)
@@ -774,32 +777,30 @@ Retry_Sense:
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
@@ -814,7 +815,10 @@ Retry_Sense:
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
1.7.0.1

