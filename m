Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0DZKef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 06:34:35 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:60484 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0DZKed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 06:34:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jK5ETSiTDNigdB+CkUuzyQTVcpbppLg3Is/6N0oAtZnn824yCj+4mzzTh1QnR8g3CV
         NgWSUk7gztmk+k+yOiuwK/yqS4GgBhxk/dQV5MOZhYSOraQhOQyekKdfhioZtcAhTzIi
         Nu901skRel9SZByl9XcEMff7c3Pu1+JYMatEE=
From: fabien.chouteau@gmail.com
To: linux-usb@vger.kernel.org
Cc: Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH RE-RESEND] Mass storage gadget: Handle eject request
Date: Mon, 26 Apr 2010 12:34:54 +0200
Message-Id: <1272278094-25433-1-git-send-email-fabien.chouteau@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabien Chouteau <fabien.chouteau@barco.com>

This patch adds handling of the "Start/Stop Unit" SCSI request
to simulate media ejection.

Signed-off-by: Fabien Chouteau <fabien.chouteau@barco.com>
---
 drivers/usb/gadget/f_mass_storage.c |   48 ++++++++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f4911c0..c3e5dbb 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -163,6 +163,10 @@
  * ro setting are not allowed when the medium is loaded or if CD-ROM
  * emulation is being used.
  *
+ * When a LUN receive an "eject" SCSI request (Start/Stop Unit),
+ * if the LUN is removable, the backing file is released to simulate
+ * ejection.
+ *
  *
  * This function is heavily based on "File-backed Storage Gadget" by
  * Alan Stern which in turn is heavily based on "Gadget Zero" by David
@@ -1385,12 +1389,50 @@ static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 
 static int do_start_stop(struct fsg_common *common)
 {
-	if (!common->curlun) {
+	struct fsg_lun	*curlun = common->curlun;
+	int		loej, start;
+
+	if (!curlun) {
 		return -EINVAL;
-	} else if (!common->curlun->removable) {
-		common->curlun->sense_data = SS_INVALID_COMMAND;
+	} else if (!curlun->removable) {
+		curlun->sense_data = SS_INVALID_COMMAND;
+		return -EINVAL;
+	}
+
+	loej = common->cmnd[4] & 0x02;
+	start = common->cmnd[4] & 0x01;
+
+	/* eject code from file_storage.c:do_start_stop() */
+
+	if ((common->cmnd[1] & ~0x01) != 0 ||	  /* Mask away Immed */
+		(common->cmnd[4] & ~0x03) != 0) { /* Mask LoEj, Start */
+		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 		return -EINVAL;
 	}
+
+	if (!start) {
+		/* Are we allowed to unload the media? */
+		if (curlun->prevent_medium_removal) {
+			LDBG(curlun, "unload attempt prevented\n");
+			curlun->sense_data = SS_MEDIUM_REMOVAL_PREVENTED;
+			return -EINVAL;
+		}
+		if (loej) {	/* Simulate an unload/eject */
+			up_read(&common->filesem);
+			down_write(&common->filesem);
+			fsg_lun_close(curlun);
+			up_write(&common->filesem);
+			down_read(&common->filesem);
+		}
+	} else {
+
+		/* Our emulation doesn't support mounting; the medium is
+		 * available for use as soon as it is loaded. */
+		if (!fsg_lun_is_open(curlun)) {
+			curlun->sense_data = SS_MEDIUM_NOT_PRESENT;
+			return -EINVAL;
+		}
+	}
 	return 0;
 }
 
-- 
1.7.0.5

