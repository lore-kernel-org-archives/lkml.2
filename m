Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1IELsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:48:05 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60137 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1IELqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 47/54] drbd: _drbd_md_sync_page_io(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:38 +0200
Message-Id: <1315223145-20640-48-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 285dd74..22a0763 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -115,7 +115,7 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 {
 	struct bio *bio;
 	struct drbd_md_io md_io;
-	int ok;
+	int err;
 
 	md_io.mdev = mdev;
 	init_completion(&md_io.event);
@@ -128,8 +128,8 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 	bio = bio_alloc_drbd(GFP_NOIO);
 	bio->bi_bdev = bdev->md_bdev;
 	bio->bi_sector = sector;
-	ok = (bio_add_page(bio, page, size, 0) == size);
-	if (!ok)
+	err = -EIO;
+	if (bio_add_page(bio, page, size, 0) != size)
 		goto out;
 	bio->bi_private = &md_io;
 	bio->bi_end_io = drbd_md_io_complete;
@@ -140,11 +140,12 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 	else
 		submit_bio(rw, bio);
 	wait_for_completion(&md_io.event);
-	ok = bio_flagged(bio, BIO_UPTODATE) && md_io.error == 0;
+	if (bio_flagged(bio, BIO_UPTODATE))
+		err = md_io.error;
 
  out:
 	bio_put(bio);
-	return ok;
+	return err;
 }
 
 int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
@@ -167,7 +168,7 @@ int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 		     current->comm, current->pid, __func__,
 		     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
 
-	ok = _drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, MD_BLOCK_SIZE);
+	ok = !_drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, MD_BLOCK_SIZE);
 	if (unlikely(!ok)) {
 		dev_err(DEV, "drbd_md_sync_page_io(,%llus,%s) failed!\n",
 		    (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
-- 
1.7.4.1

