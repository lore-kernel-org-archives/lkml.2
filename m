Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1IWLA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:00:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59097 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1IWLAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:00:24 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jaxboe@fusionio.com, akpm@linux-foundation.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] loop: cleanup set_status interface
Date: Fri, 23 Sep 2011 15:01:29 +0400
Message-Id: <1316775689-22695-2-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316775689-22695-1-git-send-email-dmonakhov@openvz.org>
References: <1316775689-22695-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Anyone who has read access to loopdev has permission to call set_status
   and may change important parameters such as lo_offset, lo_sizelimit and
   so on, which contradicts to read access pattern and definitely equals
   to write access pattern.
2) Add lo_offset over i_size check to prevent blkdev_size overflow.
   ##Testcase_bagin
   #dd if=/dev/zero of=./file bs=1k count=1
   #losetup /dev/loop0 ./file
   /* userspace_application */
   struct loop_info64 loinf;
   fd = open("/dev/loop0", O_RDONLY);
   ioctl(fd, LOOP_GET_STATUS64, &loinf);
   /* Set offset to any value which is bigger than i_size, and sizelimit
    * to nonzero value*/
   loinf.lo_offset = 4096*1024;
   loinf.lo_sizelimit = 1024;
   ioctl(fd, LOOP_SET_STATUS64, &loinf);
   /* After this loop device will have size similar to 0x7fffffffffxxxx */
   #blockdev --getsz /dev/loop0
   ##OUTPUT: 36028797018955968
   ##Testcase_end

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/block/loop.c |   44 +++++++++++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 0dcc7bf..0420cda 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -159,17 +159,19 @@ static struct loop_func_table *xfer_funcs[MAX_LO_CRYPT] = {
 	&xor_funcs
 };
 
-static loff_t get_loop_size(struct loop_device *lo, struct file *file)
+static loff_t get_size(loff_t offset, loff_t sizelimit, struct file *file)
 {
-	loff_t size, offset, loopsize;
+	loff_t size, loopsize;
 
 	/* Compute loopsize in bytes */
 	size = i_size_read(file->f_mapping->host);
-	offset = lo->lo_offset;
 	loopsize = size - offset;
-	if (lo->lo_sizelimit > 0 && lo->lo_sizelimit < loopsize)
-		loopsize = lo->lo_sizelimit;
+	/* offset is beyond i_size, wierd but possible */
+	if (loopsize < 0)
+		return 0;
 
+	if (sizelimit > 0 && sizelimit < loopsize)
+		loopsize = sizelimit;
 	/*
 	 * Unfortunately, if we want to do I/O on the device,
 	 * the number of 512-byte sectors has to fit into a sector_t.
@@ -177,17 +179,25 @@ static loff_t get_loop_size(struct loop_device *lo, struct file *file)
 	return loopsize >> 9;
 }
 
+static loff_t get_loop_size(struct loop_device *lo, struct file *file)
+{
+	return get_size(lo->lo_offset, lo->lo_sizelimit, file);
+}
+
 static int
-figure_loop_size(struct loop_device *lo)
+figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 {
-	loff_t size = get_loop_size(lo, lo->lo_backing_file);
+	loff_t size = get_size(offset, sizelimit, lo->lo_backing_file);
 	sector_t x = (sector_t)size;
 
 	if (unlikely((loff_t)x != size))
 		return -EFBIG;
-
+	if (lo->lo_offset != offset)
+		lo->lo_offset = offset;
+	if (lo->lo_sizelimit != sizelimit)
+		lo->lo_sizelimit = sizelimit;
 	set_capacity(lo->lo_disk, x);
-	return 0;					
+	return 0;
 }
 
 static inline int
@@ -1081,9 +1091,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
-		lo->lo_offset = info->lo_offset;
-		lo->lo_sizelimit = info->lo_sizelimit;
-		if (figure_loop_size(lo))
+		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit))
 			return -EFBIG;
 	}
 
@@ -1261,7 +1269,7 @@ static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
 	err = -ENXIO;
 	if (unlikely(lo->lo_state != Lo_bound))
 		goto out;
-	err = figure_loop_size(lo);
+	err = figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
 	if (unlikely(err))
 		goto out;
 	sec = get_capacity(lo->lo_disk);
@@ -1299,13 +1307,19 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 			goto out_unlocked;
 		break;
 	case LOOP_SET_STATUS:
-		err = loop_set_status_old(lo, (struct loop_info __user *) arg);
+		err = -EPERM;
+		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_status_old(lo,
+						(struct loop_info __user *) arg);
 		break;
 	case LOOP_GET_STATUS:
 		err = loop_get_status_old(lo, (struct loop_info __user *) arg);
 		break;
 	case LOOP_SET_STATUS64:
-		err = loop_set_status64(lo, (struct loop_info64 __user *) arg);
+		err = -EPERM;
+		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_status64(lo,
+					(struct loop_info64 __user *) arg);
 		break;
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
-- 
1.7.1

