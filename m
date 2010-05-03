Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab0ECMKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 08:10:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:34988 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab0ECMK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 08:10:27 -0400
Subject: generate "change" uevent for loop device
From: Kay Sievers <kay.sievers@vrfy.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Zeuthen <davidz@redhat.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 14:08:59 +0200
Message-ID: <1272888539.27606.3.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.0.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Zeuthen <davidz@redhat.com>
Subject: generate "change" uevent for loop device

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
---
 drivers/block/loop.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -835,6 +835,8 @@ static int loop_set_fd(struct loop_devic
 
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
@@ -944,8 +947,11 @@ static int loop_clr_fd(struct loop_devic
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
@@ -1189,6 +1195,8 @@ static int loop_set_capacity(struct loop
 	sz <<= 9;
 	mutex_lock(&bdev->bd_mutex);
 	bd_set_size(bdev, sz);
+	/* let user-space know about the new size */
+	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	mutex_unlock(&bdev->bd_mutex);
 
  out:


