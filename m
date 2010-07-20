Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0GTUn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:43:28 -0400
Received: from claw.goop.org ([74.207.240.146]:50951 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761609Ab0GTUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/16] blkfront: Fix blkfront backend switch race (bdev open)
Date: Tue, 20 Jul 2010 13:42:20 -0700
Message-Id: <92a640f68db1ba799cb663455c9ccb1fb3fe206c.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stodden <daniel.stodden@citrix.com>

We need not mind if users grab a late handle on a closing disk. We
probably even should not. But we have to make sure it's not a dead
one already

Let the bdev deal with a gendisk deleted under its feet. Takes the
info mutex to decide a race against backend closing.

Signed-off-by: Daniel Stodden <daniel.stodden@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 1046a58..974d59a 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1118,12 +1118,27 @@ static int blkfront_is_ready(struct xenbus_device *dev)
 
 static int blkif_open(struct block_device *bdev, fmode_t mode)
 {
-	struct blkfront_info *info = bdev->bd_disk->private_data;
+	struct gendisk *disk = bdev->bd_disk;
+	struct blkfront_info *info;
+	int err = 0;
 
-	if (!info->xbdev)
-		return -ENODEV;
-	info->users++;
-	return 0;
+	info = disk->private_data;
+	if (!info)
+		/* xbdev gone */
+		return -ERESTARTSYS;
+
+	mutex_lock(&info->mutex);
+
+	if (!info->gd)
+		/* xbdev is closed */
+		err = -ERESTARTSYS;
+
+	mutex_unlock(&info->mutex);
+
+	if (!err)
+		++info->users;
+
+	return err;
 }
 
 static int blkif_release(struct gendisk *disk, fmode_t mode)
-- 
1.7.1.1

