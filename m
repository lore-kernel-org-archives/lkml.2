Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1AVOWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:22:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61939 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1AVOWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CFK5KVIsgzRvqG0xVyYL2U0LSqClfL8u69aS5s+Agb4cfOrqzGpD5MbAsgOX24gbcz
         IO0nHMtQJlfMlv41G6ARW+KO6V+H5GVUB6mywy5mxFrnwHgWeEH+8S/N6GoUgLlpx3Xz
         BiByx/ADPNS/yDxdSd86aEKPpeZNVoWaLYiFI=
Date: Sat, 22 Jan 2011 15:22:34 +0100
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] loop: guarantee lo->lo_device availability while fd is
 bound
Message-ID: <20110122142234.GC6160@htj.dyndns.org>
References: <23846.1295615979@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23846.1295615979@jrobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop_set_fd() recorded the attached bdev in lo->lo_device; however,
the fd may remain attached while the bdev is detached.  This causes
several problems.

* lo->lo_device may end up pointing to already reclaimed bdev, so
  loop_clr_fd() can't use it to clear bdev attributes when called from
  lo_ioctl().

* As lo_open() doesn't fill in @bdev on open, if the bdev is reclaimed
  and then recreated, the attributes set on the original bdev are
  lost.

Fix it by making loop_set_fd() hold onto the bdev using bdgrab().
This allows loop_clr_fd() to rely on lo->lo_device to access the
attached bdev.  Drop @bdev from loop_clr_fd() and always use
lo->lo_device.  This guarantees that bdev attributes are cleared no
matter how the fd is detached.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
Jens, these two patches fix a regression in loop introduced by block
change.  Thanks.

 drivers/block/loop.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

Index: work/drivers/block/loop.c
===================================================================
--- work.orig/drivers/block/loop.c
+++ work/drivers/block/loop.c
@@ -901,7 +901,7 @@ static int loop_set_fd(struct loop_devic
 	set_device_ro(bdev, (lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
 	lo->lo_blocksize = lo_blocksize;
-	lo->lo_device = bdev;
+	lo->lo_device = bdgrab(bdev);
 	lo->lo_flags = lo_flags;
 	lo->lo_backing_file = file;
 	lo->transfer = transfer_none;
@@ -1000,8 +1000,9 @@ loop_init_xfer(struct loop_device *lo, s
 	return err;
 }
 
-static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
+static int loop_clr_fd(struct loop_device *lo)
 {
+	struct block_device *bdev = lo->lo_device;
 	struct file *filp = lo->lo_backing_file;
 	gfp_t gfp = lo->old_gfp_mask;
 
@@ -1036,20 +1037,17 @@ static int loop_clr_fd(struct loop_devic
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
-	if (bdev)
-		invalidate_bdev(bdev);
+	invalidate_bdev(bdev);
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
-	if (bdev) {
-		bd_set_size(bdev, 0);
-		/* let user-space know about this change */
-		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
-	}
+	bd_set_size(bdev, 0);
+	/* let user-space know about this change */
+	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	if (max_part > 0 && bdev)
+	if (max_part > 0)
 		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	mutex_unlock(&lo->lo_ctl_mutex);
 	/*
@@ -1059,6 +1057,7 @@ static int loop_clr_fd(struct loop_devic
 	 * bd_mutex which is usually taken before lo_ctl_mutex.
 	 */
 	fput(filp);
+	bdput(bdev);
 	return 0;
 }
 
@@ -1312,7 +1311,7 @@ static int lo_ioctl(struct block_device
 		break;
 	case LOOP_CLR_FD:
 		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
-		err = loop_clr_fd(lo, bdev);
+		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
 		break;
@@ -1526,7 +1525,7 @@ static int lo_release(struct gendisk *di
 		 * In autoclear mode, stop the loop thread
 		 * and remove configuration after last close.
 		 */
-		err = loop_clr_fd(lo, NULL);
+		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
 	} else {
