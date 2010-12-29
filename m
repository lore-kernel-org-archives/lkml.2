Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab0L2OMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:12:41 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54021 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0L2OMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:12:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Mfr6JHjdURiCgfoI5k2pZE2m55Qy/Fqp55KY0Z1bd/HboKn9k+A72Axi4RPmlKXB3b
         tHUkKUBhDy5kwHojC8bfoaCcQ69zwG9giBR2hEq1KuXDOcahsTxVkXyo3MOXCRfI2B8s
         3cGM9yGRF7/UyYVpE2LfS/ukhesFnEUdxVyhE=
Date: Wed, 29 Dec 2010 22:12:44 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix return value when mount fail
Message-ID: <20101229141244.GA11081@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I happened to pass swap partition as root partition in cmdline,
then kernel panic and tell me about "Cannot open root device".
It is not correct, in fact it is a mount failer instead of 'no device'.

Eventually I found btrfs mounting failed with -EIO, it should be -EINVAL.

Here fix the return value as -EINVAL

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 fs/btrfs/disk-io.c |    4 +++-
 fs/btrfs/volumes.c |    8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

--- linux-2.6.orig/fs/btrfs/disk-io.c	2010-12-29 21:53:17.473333338 +0800
+++ linux-2.6/fs/btrfs/disk-io.c	2010-12-29 21:57:37.916666672 +0800
@@ -1713,8 +1713,10 @@ struct btrfs_root *open_ctree(struct sup
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
 	bh = btrfs_read_dev_super(fs_devices->latest_bdev);
-	if (!bh)
+	if (!bh) {
+		err = -EINVAL;
 		goto fail_iput;
+	}
 
 	memcpy(&fs_info->super_copy, bh->b_data, sizeof(fs_info->super_copy));
 	memcpy(&fs_info->super_for_commit, &fs_info->super_copy,
--- linux-2.6.orig/fs/btrfs/volumes.c	2010-12-29 21:53:17.503333338 +0800
+++ linux-2.6/fs/btrfs/volumes.c	2010-12-29 21:57:37.920000005 +0800
@@ -598,8 +598,10 @@ static int __btrfs_open_devices(struct b
 		set_blocksize(bdev, 4096);
 
 		bh = btrfs_read_dev_super(bdev);
-		if (!bh)
+		if (!bh) {
+			ret = -EINVAL;
 			goto error_close;
+		}
 
 		disk_super = (struct btrfs_super_block *)bh->b_data;
 		devid = btrfs_stack_device_id(&disk_super->dev_item);
@@ -700,7 +702,7 @@ int btrfs_scan_one_device(const char *pa
 		goto error_close;
 	bh = btrfs_read_dev_super(bdev);
 	if (!bh) {
-		ret = -EIO;
+		ret = -EINVAL;
 		goto error_close;
 	}
 	disk_super = (struct btrfs_super_block *)bh->b_data;
@@ -1193,7 +1195,7 @@ int btrfs_rm_device(struct btrfs_root *r
 		set_blocksize(bdev, 4096);
 		bh = btrfs_read_dev_super(bdev);
 		if (!bh) {
-			ret = -EIO;
+			ret = -EINVAL;
 			goto error_close;
 		}
 		disk_super = (struct btrfs_super_block *)bh->b_data;
