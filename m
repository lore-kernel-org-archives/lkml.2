Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab0LHCE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:04:57 -0500
Received: from kroah.org ([198.145.64.141]:48276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726Ab0LHA66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:58:58 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:21 2010
Message-Id: <20101208005721.652865552@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, Jens Axboe <jaxboe@fusionio.com>
Subject: [002/289] block: Fix race during disk initialization
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 block/genhd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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


