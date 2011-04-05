Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1DEO5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:57:02 -0400
Received: from smtp.nokia.com ([147.243.1.48]:57598 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab1DEO5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:57:01 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, sshtylyov@mvista.com, mina86@mina86.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH v3 1/3] usb: gadget: storage: Add fsg_get_toc helper
Date: Tue,  5 Apr 2011 17:59:27 +0300
Message-Id: <1302015569-9668-2-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com>
References: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsg_get_toc can be used by both storage gadgets to build a CD-ROM
Table of Contents which can be used as data for READ_TOC command.
Currently fsg_get_toc supports two TOC formats, i.e.
format 0: Formatted TOC and format 2: Raw TOC.

Raw TOC is required for CD-ROM emulation to work with Mac OS-X.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/storage_common.c |   65 +++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index b015561..38fd675 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -655,6 +655,71 @@ static void store_cdrom_address(u8 *dest, int msf, u32 addr)
 	}
 }
 
+/**
+ * fsg_get_toc() - Builds a TOC with required format @format.
+ * @curlun: The LUN for which the TOC has to be built
+ * @msf: Min Sec Frame format or LBA format for address
+ * @format: TOC format code
+ * @buf: The buffer into which the TOC is built
+ *
+ * Builds a Table of Content which can be used as data for READ_TOC command.
+ * The TOC simulates a single session, single track CD-ROM mode 1 disc.
+ *
+ * Returns number of bytes written to @buf, -EINVAL if format not supported.
+ */
+static int fsg_get_toc(struct fsg_lun *curlun, int msf, int format, u8 *buf)
+{
+	int i, len;
+	switch (format) {
+	case 0:
+		/* Formatted TOC */
+		len = 4 + 2*8;		/* 4 byte header + 2 descriptors */
+		memset(buf, 0, len);
+		buf[1] = len - 2;	/* TOC Length excludes length field */
+		buf[2] = 1;		/* First track number */
+		buf[3] = 1;		/* Last track number */
+		buf[5] = 0x16;		/* Data track, copying allowed */
+		buf[6] = 0x01;		/* Only track is number 1 */
+		store_cdrom_address(&buf[8], msf, 0);
+
+		buf[13] = 0x16;		/* Lead-out track is data */
+		buf[14] = 0xAA;		/* Lead-out track number */
+		store_cdrom_address(&buf[16], msf, curlun->num_sectors);
+		return len;
+		break;
+
+	case 2:
+		/* Raw TOC */
+		len = 4 + 3*11;		/* 4 byte header + 3 descriptors */
+		memset(buf, 0, len);	/* Header + A0, A1 & A2 descriptors */
+		buf[1] = len - 2;	/* TOC Length excludes length field */
+		buf[2] = 1;		/* First complete session */
+		buf[3] = 1;		/* Last complete session */
+
+		buf += 4;
+		/* fill in A0, A1 and A2 points */
+		for (i = 0; i < 3; i++) {
+			buf[0] = 1;	/* Session number */
+			buf[1] = 0x16;	/* Data track, copying allowed */
+			/* 2 - Track number 0 ->  TOC */
+			buf[3] = 0xA0 + i; /* A0, A1, A2 point */
+			/* 4, 5, 6 - Min, sec, frame is zero */
+			buf[8] = 1;	/* Pmin: last track number */
+			buf += 11;	/* go to next track descriptor */
+		}
+		buf -= 11;		/* go back to A2 descriptor */
+
+		/* For A2, 7, 8, 9, 10 - zero, Pmin, Psec, Pframe of Lead out */
+		store_cdrom_address(&buf[7], msf, curlun->num_sectors);
+		return len;
+		break;
+	default:
+		/* Multi-session, PMA, ATIP, CD-TEXT not supported/required */
+		return -EINVAL;
+		break;
+	}
+}
+
 
 /*-------------------------------------------------------------------------*/
 
-- 
1.6.0.4

