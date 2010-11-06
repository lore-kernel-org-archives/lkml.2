Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0KFHfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 03:35:45 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:41697 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab0KFHfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 03:35:43 -0400
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] floppy: replace NO_GEOM macro with a function
Date: Sat,  6 Nov 2010 09:35:39 +0200
Message-Id: <1289028939-9407-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the NO_GEOM macro with a proper static inline function and
converts an open-coded caller in check_floppy_change() to use it.

Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/block/floppy.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 767107c..69dc9fc 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -597,6 +597,11 @@ static unsigned char fsector_t;	/* sector in track */
 static unsigned char in_sector_offset;	/* offset within physical sector,
 					 * expressed in units of 512 bytes */
 
+static inline bool drive_no_geom(int drive)
+{
+	return !current_type[drive] && !ITYPE(UDRS->fd_device);
+}
+
 #ifndef fd_eject
 static inline int fd_eject(int drive)
 {
@@ -3782,7 +3787,7 @@ static int check_floppy_change(struct gendisk *disk)
 	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
 	    test_bit(drive, &fake_change) ||
-	    (!ITYPE(UDRS->fd_device) && !current_type[drive]))
+	    drive_no_geom(drive))
 		return 1;
 	return 0;
 }
@@ -3848,13 +3853,13 @@ static int __floppy_read_block_0(struct block_device *bdev)
 static int floppy_revalidate(struct gendisk *disk)
 {
 	int drive = (long)disk->private_data;
-#define NO_GEOM (!current_type[drive] && !ITYPE(UDRS->fd_device))
 	int cf;
 	int res = 0;
 
 	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
-	    test_bit(drive, &fake_change) || NO_GEOM) {
+	    test_bit(drive, &fake_change) ||
+	    drive_no_geom(drive)) {
 		if (WARN(atomic_read(&usage_count) == 0,
 			 "VFS: revalidate called on non-open device.\n"))
 			return -EFAULT;
@@ -3862,7 +3867,7 @@ static int floppy_revalidate(struct gendisk *disk)
 		lock_fdc(drive, false);
 		cf = (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 		      test_bit(FD_VERIFY_BIT, &UDRS->flags));
-		if (!(cf || test_bit(drive, &fake_change) || NO_GEOM)) {
+		if (!(cf || test_bit(drive, &fake_change) || drive_no_geom(drive))) {
 			process_fd_request();	/*already done by another thread */
 			return 0;
 		}
@@ -3874,7 +3879,7 @@ static int floppy_revalidate(struct gendisk *disk)
 		clear_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
 		if (cf)
 			UDRS->generation++;
-		if (NO_GEOM) {
+		if (drive_no_geom(drive)) {
 			/* auto-sensing */
 			res = __floppy_read_block_0(opened_bdev[drive]);
 		} else {
-- 
1.7.0.4

