Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0IPSVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:21:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:51732 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab0IPSVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:21:15 -0400
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH] block: Fix race during disk initialization
Date: Thu, 16 Sep 2010 20:20:17 +0200
Message-Id: <1284661217-22783-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 block/genhd.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

 Jens, would you consider merging this fix? The kernel boots with it but
I'm not too familiar with this area of kernel so there can be something subtle
I've missed. So please review. Thanks.

diff --git a/block/genhd.c b/block/genhd.c
index 59a2db6..315afd2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
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
-- 
1.6.4.2

