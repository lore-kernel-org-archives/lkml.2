Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1HOOCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:02:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1HOOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:02:13 -0400
Subject: [PATCH] loop: always allow userspace-created partitions and
 optionally support automatic kernel partition scanning
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Karel Zak <kzak@redhat.com>, "Davidlohr Bueso dave"@gnu.org
Date: Mon, 15 Aug 2011 16:00:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313416853.982.3.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: loop: always allow userspace-created partitions and optionally support automatic kernel partition scanning

Automatic partition scanning can be requested individually per loop
device during its setup by setting LO_FLAGS_PARTSCAN. By default, no
partition tables are scanned. Userspace can now always add and remove
partitions from all loop devices, regardless the in-kernel partition
scanner is enabled or not.

The needed partition minor numbers are allocated from the extended
minors space, the main loop device numbers will continue to match the
loop minors, regardless of the number of partitions used.

  # grep . /sys/class/block/loop1/loop/*
  /sys/block/loop1/loop/autoclear:0
  /sys/block/loop1/loop/backing_file:/home/kay/data/stuff/part.img
  /sys/block/loop1/loop/offset:0
  /sys/block/loop1/loop/partscan:1
  /sys/block/loop1/loop/sizelimit:0

  # ls -l /dev/loop*
  brw-rw---- 1 root disk   7,   0 Aug 14 20:22 /dev/loop0
  brw-rw---- 1 root disk   7,   1 Aug 14 20:23 /dev/loop1
  brw-rw---- 1 root disk 259,   0 Aug 14 20:23 /dev/loop1p1
  brw-rw---- 1 root disk 259,   1 Aug 14 20:23 /dev/loop1p2
  brw-rw---- 1 root disk   7,  99 Aug 14 20:23 /dev/loop99
  brw-rw---- 1 root disk 259,   2 Aug 14 20:23 /dev/loop99p1
  brw-rw---- 1 root disk 259,   3 Aug 14 20:23 /dev/loop99p2
  crw------T 1 root root  10, 237 Aug 14 20:22 /dev/loop-control

Cc: Karel Zak  <kzak@redhat.com>
Cc: Davidlohr Bueso dave@gnu.org
Acked-By: Tejun Heo <tj@kernel.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/block/loop.c |   49 +++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/loop.h |    1 +
 2 files changed, 46 insertions(+), 4 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -700,7 +700,7 @@ static int loop_change_fd(struct loop_de
 		goto out_putf;
 
 	fput(old_file);
-	if (max_part > 0)
+	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
 		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 
@@ -777,16 +777,25 @@ static ssize_t loop_attr_autoclear_show(
 	return sprintf(buf, "%s\n", autoclear ? "1" : "0");
 }
 
+static ssize_t loop_attr_partscan_show(struct loop_device *lo, char *buf)
+{
+	int partscan = (lo->lo_flags & LO_FLAGS_PARTSCAN);
+
+	return sprintf(buf, "%s\n", partscan ? "1" : "0");
+}
+
 LOOP_ATTR_RO(backing_file);
 LOOP_ATTR_RO(offset);
 LOOP_ATTR_RO(sizelimit);
 LOOP_ATTR_RO(autoclear);
+LOOP_ATTR_RO(partscan);
 
 static struct attribute *loop_attrs[] = {
 	&loop_attr_backing_file.attr,
 	&loop_attr_offset.attr,
 	&loop_attr_sizelimit.attr,
 	&loop_attr_autoclear.attr,
+	&loop_attr_partscan.attr,
 	NULL,
 };
 
@@ -919,7 +928,9 @@ static int loop_set_fd(struct loop_devic
 	}
 	lo->lo_state = Lo_bound;
 	wake_up_process(lo->lo_thread);
-	if (max_part > 0)
+	if (part_shift)
+		lo->lo_flags |= LO_FLAGS_PARTSCAN;
+	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
 		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 
@@ -1012,7 +1023,6 @@ static int loop_clr_fd(struct loop_devic
 	lo->lo_offset = 0;
 	lo->lo_sizelimit = 0;
 	lo->lo_encrypt_key_size = 0;
-	lo->lo_flags = 0;
 	lo->lo_thread = NULL;
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
@@ -1030,8 +1040,11 @@ static int loop_clr_fd(struct loop_devic
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	if (max_part > 0 && bdev)
+	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
 		ioctl_by_bdev(bdev, BLKRRPART, 0);
+	lo->lo_flags = 0;
+	if (!part_shift)
+		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
 	mutex_unlock(&lo->lo_ctl_mutex);
 	/*
 	 * Need not hold lo_ctl_mutex to fput backing file.
@@ -1100,6 +1113,13 @@ loop_set_status(struct loop_device *lo,
 	     (info->lo_flags & LO_FLAGS_AUTOCLEAR))
 		lo->lo_flags ^= LO_FLAGS_AUTOCLEAR;
 
+	if ((info->lo_flags & LO_FLAGS_PARTSCAN) &&
+	     !(lo->lo_flags & LO_FLAGS_PARTSCAN)) {
+		lo->lo_flags |= LO_FLAGS_PARTSCAN;
+		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
+		ioctl_by_bdev(lo->lo_device, BLKRRPART, 0);
+	}
+
 	lo->lo_encrypt_key_size = info->lo_encrypt_key_size;
 	lo->lo_init[0] = info->lo_init[0];
 	lo->lo_init[1] = info->lo_init[1];
@@ -1635,6 +1655,27 @@ static int loop_add(struct loop_device *
 	if (!disk)
 		goto out_free_queue;
 
+	/*
+	 * Disable partition scanning by default. The in-kernel partition
+	 * scanning can be requested individually per-device during its
+	 * setup. Userspace can always add and remove partitions from all
+	 * devices. The needed partition minors are allocated from the
+	 * extended minor space, the main loop device numbers will continue
+	 * to match the loop minors, regardless of the number of partitions
+	 * used.
+	 *
+	 * If max_part is given, partition scanning is globally enabled for
+	 * all loop devices. The minors for the main loop devices will be
+	 * multiples of max_part.
+	 *
+	 * Note: Global-for-all-devices, set-only-at-init, read-only module
+	 * parameteters like 'max_loop' and 'max_part' make things needlessly
+	 * complicated, are too static, inflexible and may surprise
+	 * userspace tools. Parameters like this in general should be avoided.
+	 */
+	if (!part_shift)
+		disk->flags |= GENHD_FL_NO_PART_SCAN;
+	disk->flags |= GENHD_FL_EXT_DEVT;
 	mutex_init(&lo->lo_ctl_mutex);
 	lo->lo_number		= i;
 	lo->lo_thread		= NULL;
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -75,6 +75,7 @@ enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_USE_AOPS	= 2,
 	LO_FLAGS_AUTOCLEAR	= 4,
+	LO_FLAGS_PARTSCAN	= 8,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */


