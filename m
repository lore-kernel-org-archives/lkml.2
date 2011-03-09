Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1CIMTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:19:09 -0500
Received: from smtp.nokia.com ([147.243.1.47]:25292 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab1CIMTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:19:04 -0500
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] usb: gadget: file_storage: Make CD-ROM emulation work with Mac OS-X
Date: Wed,  9 Mar 2011 14:21:39 +0200
Message-Id: <1299673300-16726-3-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1299673300-16726-2-git-send-email-roger.quadros@nokia.com>
References: <1299673300-16726-1-git-send-email-roger.quadros@nokia.com>
 <1299673300-16726-2-git-send-email-roger.quadros@nokia.com>
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
 drivers/usb/gadget/file_storage.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index a6eacb5..753ac94 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -1696,6 +1696,8 @@ static int do_read_toc(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	int		msf = fsg->cmnd[1] & 0x02;
 	int		start_track = fsg->cmnd[6];
 	u8		*buf = (u8 *) bh->buf;
+	u8		format;
+	int		ret;
 
 	if ((fsg->cmnd[1] & ~0x02) != 0 ||		/* Mask away MSF */
 			start_track > 1) {
@@ -1703,18 +1705,22 @@ static int do_read_toc(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 		return -EINVAL;
 	}
 
-	memset(buf, 0, 20);
-	buf[1] = (20-2);		/* TOC data length */
-	buf[2] = 1;			/* First track number */
-	buf[3] = 1;			/* Last track number */
-	buf[5] = 0x16;			/* Data track, copying allowed */
-	buf[6] = 0x01;			/* Only track is number 1 */
-	store_cdrom_address(&buf[8], msf, 0);
+	/*
+	 * Check if CDB is old style SFF-8020i
+	 * i.e. format is in 2 MSBs of byte 9
+	 * Mac OS-X host sends us this.
+	 */
+	format = (fsg->cmnd[9] >> 6) & 0x3;
+	if (format == 0)
+		format = fsg->cmnd[2] & 0xf;	/* new style MMC-2 */
+
+	ret = fsg_get_toc(curlun, msf, format, buf);
+	if (ret < 0) {
+		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
+		return -EINVAL;
+	}
+	return ret;
 
-	buf[13] = 0x16;			/* Lead-out track is data */
-	buf[14] = 0xAA;			/* Lead-out track number */
-	store_cdrom_address(&buf[16], msf, curlun->num_sectors);
-	return 20;
 }
 
 
@@ -2486,7 +2492,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			goto unknown_cmnd;
 		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
-				(7<<6) | (1<<1), 1,
+				(0xf<<6) | (1<<1), 1,
 				"READ TOC")) == 0)
 			reply = do_read_toc(fsg, bh);
 		break;
-- 
1.6.0.4

