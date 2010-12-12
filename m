Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0LLXpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44551 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0LLXo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:44:58 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jack@suse.cz, jaxboe@fusionio.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [2/223] block: Fix race during disk initialization
Message-Id: <20101212234456.CB45FB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:44:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jan Kara <jack@suse.cz>

commit 01ea50638bc04ca5259f5711fcdedefcdde1cf43 upstream.

When a new disk is being discovered, add_disk() first ties the bdev to gendisk
(via register_disk()->blkdev_get()) and only after that calls
bdi_register_bdev(). Because register_disk() also creates disk's kobject, it
can happen that userspace manages to open and modify the device's data (or
inode) before its BDI is properly initialized leading to a warning in
__mark_inode_dirty().

Fix the problem by registering BDI early enough.

This patch addresses https://bugzilla.kernel.org/show_bug.cgi?id=16312

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 block/genhd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/block/genhd.c
===================================================================
--- linux.orig/block/genhd.c
+++ linux/block/genhd.c
@@ -541,13 +541,15 @@ void add_disk(struct gendisk *disk)
 	disk->major = MAJOR(devt);
 	disk->first_minor = MINOR(devt);
 
+	/* Register BDI before referencing it from bdev */
+	bdi = &disk->queue->backing_dev_info;
+	bdi_register_dev(bdi, disk_devt(disk));
+
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
 
-	bdi = &disk->queue->backing_dev_info;
-	bdi_register_dev(bdi, disk_devt(disk));
 	retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
 				   "bdi");
 	WARN_ON(retval);
