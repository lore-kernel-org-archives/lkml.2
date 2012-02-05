Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2BEWdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:33:07 -0500
Received: from 1wt.eu ([62.212.114.60]:62125 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab2BEW1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:03 -0500
Message-Id: <20120205220953.356092520@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:20 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 91/91] dm: do not forward ioctls from logical volumes to the underlying device
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit ec8013beddd717d1740cfefb1a9b900deef85462 upstream.

A logical volume can map to just part of underlying physical volume.
In this case, it must be treated like a partition.

Based on a patch from Alasdair G Kergon.

Cc: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backport to 2.6.32 - drop change to drivers/md/dm-flakey.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-linear.c |   12 +++++++++++-
 drivers/md/dm-mpath.c  |    6 ++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/drivers/md/dm-linear.c
===================================================================
--- longterm-2.6.27.orig/drivers/md/dm-linear.c	2012-02-05 22:34:32.148917626 +0100
+++ longterm-2.6.27/drivers/md/dm-linear.c	2012-02-05 22:34:47.932914720 +0100
@@ -118,12 +118,20 @@
 	struct block_device *bdev = lc->dev->bdev;
 	struct file fake_file = {};
 	struct dentry fake_dentry = {};
+	int r = 0;
 
 	fake_file.f_mode = lc->dev->mode;
 	fake_file.f_path.dentry = &fake_dentry;
 	fake_dentry.d_inode = bdev->bd_inode;
 
-	return blkdev_driver_ioctl(bdev->bd_inode, &fake_file, bdev->bd_disk, cmd, arg);
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (lc->start ||
+	    ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
+	return r ? : blkdev_driver_ioctl(bdev->bd_inode, &fake_file, bdev->bd_disk, cmd, arg);
 }
 
 static int linear_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
Index: longterm-2.6.27/drivers/md/dm-mpath.c
===================================================================
--- longterm-2.6.27.orig/drivers/md/dm-mpath.c	2012-02-05 22:34:32.145914857 +0100
+++ longterm-2.6.27/drivers/md/dm-mpath.c	2012-02-05 22:34:47.937916536 +0100
@@ -1421,6 +1421,12 @@
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
 	return r ? : blkdev_driver_ioctl(bdev->bd_inode, &fake_file,
 					 bdev->bd_disk, cmd, arg);
 }


