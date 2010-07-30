Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0G3I7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 04:59:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47812 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0G3I7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 04:59:36 -0400
Subject: [PATCH] block: move blk_register_queue() before uevent is send out
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 10:59:43 +0200
Message-ID: <1280480383.1851.2.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: block: move blk_register_queue() before uevent is send out

Sysfs attributes should be created before the device is announced to
userspace. Createing attributes after the event makes it impossible
to use them reliably from udev.

The issue was found by Karel.

Cc: Karel Zak <kzak@redhat.com>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -531,6 +531,7 @@ static void register_disk(struct gendisk
 #endif
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
+	blk_register_queue(disk);
 
 	/* No minors to use for partitions */
 	if (!disk_partitionable(disk))
@@ -602,7 +603,6 @@ void add_disk(struct gendisk *disk)
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
 	register_disk(disk);
-	blk_register_queue(disk);
 
 	bdi = &disk->queue->backing_dev_info;
 	bdi_register_dev(bdi, disk_devt(disk));


