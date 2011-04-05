Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1DEO5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:57:16 -0400
Received: from smtp.nokia.com ([147.243.1.48]:57618 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab1DEO5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:57:02 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, sshtylyov@mvista.com, mina86@mina86.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH v3 3/3] usb: gadget: f_mass_storage: Make CD-ROM emulation work with Mac OS-X
Date: Tue,  5 Apr 2011 17:59:29 +0300
Message-Id: <1302015569-9668-4-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com>
References: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mac OS-X expects CD-ROM TOC in raw format (i.e. format:2). It also
sends the READ_TOC CDB in old style SFF8020i format. i.e. 2 format bits
are encoded in MSBs of CDB byte 9.

This patch will enable CD-ROM emulation to work with Mac OS-X. Tested on
Mac OS X v10.6.3.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 6d8e533..ef6c65a 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -1315,6 +1315,8 @@ static int do_read_toc(struct fsg_common *common, struct fsg_buffhd *bh)
 	int		msf = common->cmnd[1] & 0x02;
 	int		start_track = common->cmnd[6];
 	u8		*buf = (u8 *)bh->buf;
+	u8		format;
+	int		ret;
 
 	if ((common->cmnd[1] & ~0x02) != 0 ||	/* Mask away MSF */
 			start_track > 1) {
@@ -1322,18 +1324,21 @@ static int do_read_toc(struct fsg_common *common, struct fsg_buffhd *bh)
 		return -EINVAL;
 	}
 
-	memset(buf, 0, 20);
-	buf[1] = (20-2);		/* TOC data length */
-	buf[2] = 1;			/* First track number */
-	buf[3] = 1;			/* Last track number */
-	buf[5] = 0x16;			/* Data track, copying allowed */
-	buf[6] = 0x01;			/* Only track is number 1 */
-	store_cdrom_address(&buf[8], msf, 0);
+	format = common->cmnd[2] & 0xf;
+	/*
+	 * Check if CDB is old style SFF-8020i
+	 * i.e. format is in 2 MSBs of byte 9
+	 * Mac OS-X host sends us this.
+	 */
+	if (format == 0)
+		format = (common->cmnd[9] >> 6) & 0x3;
 
-	buf[13] = 0x16;			/* Lead-out track is data */
-	buf[14] = 0xAA;			/* Lead-out track number */
-	store_cdrom_address(&buf[16], msf, curlun->num_sectors);
-	return 20;
+	ret = fsg_get_toc(curlun, msf, format, buf);
+	if (ret < 0) {
+		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
+		return -EINVAL;
+	}
+	return ret;
 }
 
 static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
@@ -2103,7 +2108,7 @@ static int do_scsi_command(struct fsg_common *common)
 		common->data_size_from_cmnd =
 			get_unaligned_be16(&common->cmnd[7]);
 		reply = check_command(common, 10, DATA_DIR_TO_HOST,
-				      (7<<6) | (1<<1), 1,
+				      (0xf<<6) | (1<<1), 1,
 				      "READ TOC");
 		if (reply == 0)
 			reply = do_read_toc(common, bh);
-- 
1.6.0.4

