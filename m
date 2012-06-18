Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab2FRMiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:38:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44114 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2FRMhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:37:40 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=202/3=5D=20usb=3A=20gadget=3A=20mass=5Fstorage=3A=20fail=20fsg=5Fstore=5Ffile=28=29=20early=20if=20colud=20not=20open=20file?=
Date: Mon, 18 Jun 2012 14:37:20 +0200
Message-Id: <3d80ba5730fb74945ee903664e57f257507bc47c.1340022674.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1340022674.git.mina86@mina86.com>
References: <cover.1340022674.git.mina86@mina86.com>
In-Reply-To: <cover.1340022674.git.mina86@mina86.com>
References: <cover.1340022674.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Currently, when a new value is stored to the “file” sysfs entry,
fsg_store_file() will release existing backing file and only then attempt to
open a new one.  If that fails, no new backing file is open.

This commit changes the fsg_lun_open() so that it closes existing backing file
only after the new backing file has been successfully opened.  With that
change, fsg_store_file() may use it to perform an atomic open operation with
guarantee that logical unit will either point to the new backing file or still
to the old one.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/storage_common.c |   52 +++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 8a8157f..e576678 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -617,6 +617,16 @@ static struct usb_gadget_strings	fsg_stringtab = {
  * the caller must own fsg->filesem for writing.
  */
 
+static void fsg_lun_close(struct fsg_lun *curlun)
+{
+	if (curlun->filp) {
+		LDBG(curlun, "close backing file\n");
+		fput(curlun->filp);
+		curlun->filp = NULL;
+	}
+}
+
+
 static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 {
 	int				ro;
@@ -626,6 +636,8 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	loff_t				size;
 	loff_t				num_sectors;
 	loff_t				min_sectors;
+	unsigned int			blkbits;
+	unsigned int			blksize;
 
 	/* R/W if we can, R/O if we must */
 	ro = curlun->initially_ro;
@@ -670,17 +682,17 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	}
 
 	if (curlun->cdrom) {
-		curlun->blksize = 2048;
-		curlun->blkbits = 11;
+		blksize = 2048;
+		blkbits = 11;
 	} else if (inode->i_bdev) {
-		curlun->blksize = bdev_logical_block_size(inode->i_bdev);
-		curlun->blkbits = blksize_bits(curlun->blksize);
+		blksize = bdev_logical_block_size(inode->i_bdev);
+		blkbits = blksize_bits(blksize);
 	} else {
-		curlun->blksize = 512;
-		curlun->blkbits = 9;
+		blksize = 512;
+		blkbits = 9;
 	}
 
-	num_sectors = size >> curlun->blkbits; /* File size in logic-block-size blocks */
+	num_sectors = size >> blkbits; /* File size in logic-block-size blocks */
 	min_sectors = 1;
 	if (curlun->cdrom) {
 		min_sectors = 300;	/* Smallest track is 300 frames */
@@ -697,7 +709,12 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 		goto out;
 	}
 
+	if (fsg_lun_is_open(curlun))
+		fsg_lun_close(curlun);
+
 	get_file(filp);
+	curlun->blksize = blksize;
+	curlun->blkbits = blkbits;
 	curlun->ro = ro;
 	curlun->filp = filp;
 	curlun->file_length = size;
@@ -711,16 +728,6 @@ out:
 }
 
 
-static void fsg_lun_close(struct fsg_lun *curlun)
-{
-	if (curlun->filp) {
-		LDBG(curlun, "close backing file\n");
-		fput(curlun->filp);
-		curlun->filp = NULL;
-	}
-}
-
-
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -871,19 +878,18 @@ static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
 	if (count > 0 && buf[count-1] == '\n')
 		((char *) buf)[count-1] = 0;		/* Ugh! */
 
-	/* Eject current medium */
-	down_write(filesem);
-	if (fsg_lun_is_open(curlun)) {
-		fsg_lun_close(curlun);
-		curlun->unit_attention_data = SS_MEDIUM_NOT_PRESENT;
-	}
 
 	/* Load new medium */
+	down_write(filesem);
 	if (count > 0 && buf[0]) {
+		/* fsg_lun_open() will close existing file if any. */
 		rc = fsg_lun_open(curlun, buf);
 		if (rc == 0)
 			curlun->unit_attention_data =
 					SS_NOT_READY_TO_READY_TRANSITION;
+	} else if (fsg_lun_is_open(curlun)) {
+		fsg_lun_close(curlun);
+		curlun->unit_attention_data = SS_MEDIUM_NOT_PRESENT;
 	}
 	up_write(filesem);
 	return (rc < 0 ? rc : count);
-- 
1.7.7.3

