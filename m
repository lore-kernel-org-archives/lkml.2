Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1IELr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:47:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59852 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1IELqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 48/54] drbd: drbd_md_sync_page_io(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:39 +0200
Message-Id: <1315223145-20640-49-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_actlog.c |   14 ++++++--------
 drivers/block/drbd/drbd_main.c   |    4 ++--
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 22a0763..9c9929a 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -151,7 +151,7 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 			 sector_t sector, int rw)
 {
-	int ok;
+	int err;
 	struct page *iop = mdev->md_io_page;
 
 	D_ASSERT(mutex_is_locked(&mdev->md_io_mutex));
@@ -168,14 +168,12 @@ int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 		     current->comm, current->pid, __func__,
 		     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
 
-	ok = !_drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, MD_BLOCK_SIZE);
-	if (unlikely(!ok)) {
+	err = _drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, MD_BLOCK_SIZE);
+	if (err) {
 		dev_err(DEV, "drbd_md_sync_page_io(,%llus,%s) failed!\n",
 		    (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
-		return 0;
 	}
-
-	return ok;
+	return err;
 }
 
 static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr)
@@ -382,7 +380,7 @@ w_al_write_transaction(struct drbd_work *w, int unused)
 	if (drbd_bm_write_hinted(mdev))
 		aw->err = -EIO;
 		/* drbd_chk_io_error done already */
-	else if (!drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
+	else if (drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
 		aw->err = -EIO;
 		drbd_chk_io_error(mdev, 1, true);
 	} else {
@@ -429,7 +427,7 @@ static int drbd_al_read_tr(struct drbd_conf *mdev,
 
 	/* Dont process error normally,
 	 * as this is done before disk is attached! */
-	if (!drbd_md_sync_page_io(mdev, bdev, sector, READ))
+	if (drbd_md_sync_page_io(mdev, bdev, sector, READ))
 		return -1;
 
 	if (!expect(b->magic == cpu_to_be32(DRBD_AL_MAGIC)))
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index b995937..4e25e50 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2638,7 +2638,7 @@ void drbd_md_sync(struct drbd_conf *mdev)
 	D_ASSERT(drbd_md_ss__(mdev, mdev->ldev) == mdev->ldev->md.md_offset);
 	sector = mdev->ldev->md.md_offset;
 
-	if (!drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
+	if (drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
 		/* this was a try anyways ... */
 		dev_err(DEV, "meta data update failed!\n");
 		drbd_chk_io_error(mdev, 1, true);
@@ -2671,7 +2671,7 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	mutex_lock(&mdev->md_io_mutex);
 	buffer = (struct meta_data_on_disk *)page_address(mdev->md_io_page);
 
-	if (!drbd_md_sync_page_io(mdev, bdev, bdev->md.md_offset, READ)) {
+	if (drbd_md_sync_page_io(mdev, bdev, bdev->md.md_offset, READ)) {
 		/* NOTE: can't do normal error processing here as this is
 		   called BEFORE disk is attached */
 		dev_err(DEV, "Error while reading metadata.\n");
-- 
1.7.4.1

