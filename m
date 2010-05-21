Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299Ab0EUQyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:54:44 -0400
Received: from kroah.org ([198.145.64.141]:39121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934249Ab0EUQyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Zeuthen <davidz@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/38] generate "change" uevent for loop device
Date: Fri, 21 May 2010 09:53:47 -0700
Message-Id: <1274460848-11377-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Zeuthen <davidz@redhat.com>

Recent udev versions probe loop devices for filesystems meaning that
the /dev/disk hierarchy may contain useful entries such as

 $ ls -l /dev/disk/by-label/Fedora-12-x86_64-Live
 lrwxrwxrwx 1 root root 11 Mar 11 13:41 /dev/disk/by-label/Fedora-12-x86_64-Live -> ../../loop0

Unfortunately, no "change" uevent is generated when the loop device is
detached so the symlink persists. Additionally, no "change" uevent is
guaranteed to be generated when attaching an fd or changing capacity.
For example,  user space could open the loop device O_RDONLY (in fact,
recent util-linux-ng does this) so udev's OPTIONS+="watch" machinery may
not trigger the "change" uevent.

This patch ensures that the "change" uevent is generated in all of
these cases. As a result, the /dev/disk hierarchy works as expected
for loop devices.

Signed-off-by: David Zeuthen <davidz@redhat.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/loop.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 8546d12..a90e83c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -835,6 +835,8 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
+	/* let user-space know about the new size */
+	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 
 	set_blocksize(bdev, lo_blocksize);
 
@@ -858,6 +860,7 @@ out_clr:
 	set_capacity(lo->lo_disk, 0);
 	invalidate_bdev(bdev);
 	bd_set_size(bdev, 0);
+	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask);
 	lo->lo_state = Lo_unbound;
  out_putf:
@@ -944,8 +947,11 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	if (bdev)
 		invalidate_bdev(bdev);
 	set_capacity(lo->lo_disk, 0);
-	if (bdev)
+	if (bdev) {
 		bd_set_size(bdev, 0);
+		/* let user-space know about this change */
+		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
+	}
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
@@ -1189,6 +1195,8 @@ static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
 	sz <<= 9;
 	mutex_lock(&bdev->bd_mutex);
 	bd_set_size(bdev, sz);
+	/* let user-space know about the new size */
+	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	mutex_unlock(&bdev->bd_mutex);
 
  out:
-- 
1.7.0.3

