Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0JYHMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:12:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0JYHMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:12:23 -0400
From: Milan Broz <mbroz@redhat.com>
To: axboe@kernel.dk
Cc: jeff.chua.linux@gmail.com, hch@lst.de, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>
Subject: [PATCH] loop: Properly clear sysfs in autoclear mode
Date: Mon, 25 Oct 2010 09:11:38 +0200
Message-Id: <1287990698-21690-1-git-send-email-mbroz@redhat.com>
In-Reply-To: <20101023155950.GA31946@lst.de>
References: <20101023155950.GA31946@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In autoclear mode bdev is NULL but the sysfs
entry should be destroyed otherwise this warning appears:

WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()
sysfs: cannot create duplicate filename '/devices/virtual/block/loop0/loop'

Fixes commit ee86273062cbb310665fe49e1f1937d2cf85b0b9

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/block/loop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6c48b35..c21d4f3 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1049,9 +1049,9 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	if (bdev)
 		invalidate_bdev(bdev);
 	set_capacity(lo->lo_disk, 0);
+	loop_sysfs_exit(lo);
 	if (bdev) {
 		bd_set_size(bdev, 0);
-		loop_sysfs_exit(lo);
 		/* let user-space know about this change */
 		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	}
-- 
1.7.2.3

