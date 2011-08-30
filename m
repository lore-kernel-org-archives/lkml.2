Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1H3JGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:06:01 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38211 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1H3JF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/15] drbd: allow to select specific bitmap pages for writeout
Date: Tue, 30 Aug 2011 11:05:45 +0200
Message-Id: <1314695149-387-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We are about to allow several changes to the active set in one activity
log transaction. We have to write out the corresponding bitmap pages as
well, if changed.

Introduce drbd_bm_mark_for_writeout(), then re-use the existing bitmap
writeout path to submit all marked pages in one go.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c |   43 ++++++++++++++++++++++++++++++++-----
 drivers/block/drbd/drbd_int.h    |   13 ++++++++---
 2 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 4be7370..2d00a8f 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -188,6 +188,9 @@ void drbd_bm_unlock(struct drbd_conf *mdev)
 /* to mark for lazy writeout once syncer cleared all clearable bits,
  * we if bits have been cleared since last IO. */
 #define BM_PAGE_LAZY_WRITEOUT	28
+/* pages marked with this "HINT" will be considered for writeout
+ * on activity log transactions */
+#define BM_PAGE_HINT_WRITEOUT	27
 
 /* store_page_idx uses non-atomic assignment. It is only used directly after
  * allocating the page.  All other bm_set_page_* and bm_clear_page_* need to
@@ -237,6 +240,21 @@ static void bm_set_page_need_writeout(struct page *page)
 	set_bit(BM_PAGE_NEED_WRITEOUT, &page_private(page));
 }
 
+/**
+ * drbd_bm_mark_for_writeout() - mark a page with a "hint" to be considered for writeout
+ * @mdev:	DRBD device.
+ * @page_nr:	the bitmap page to mark with the "hint" flag
+ *
+ * From within an activity log transaction, we mark a few pages with these
+ * hints, then call drbd_bm_write_hinted(), which will only write out changed
+ * pages which are flagged with this mark.
+ */
+void drbd_bm_mark_for_writeout(struct drbd_conf *mdev, int page_nr)
+{
+	struct page *page = mdev->bitmap->bm_pages[page_nr];
+	set_bit(BM_PAGE_HINT_WRITEOUT, &page_private(page));
+}
+
 static int bm_test_page_unchanged(struct page *page)
 {
 	volatile const unsigned long *addr = &page_private(page);
@@ -897,6 +915,7 @@ struct bm_aio_ctx {
 	struct completion done;
 	unsigned flags;
 #define BM_AIO_COPY_PAGES	1
+#define BM_AIO_WRITE_HINTED	2
 	int error;
 };
 
@@ -1007,13 +1026,13 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
 /*
  * bm_rw: read/write the whole bitmap from/to its on disk location.
  */
-static int bm_rw(struct drbd_conf *mdev, int rw, unsigned lazy_writeout_upper_idx) __must_hold(local)
+static int bm_rw(struct drbd_conf *mdev, int rw, unsigned flags, unsigned lazy_writeout_upper_idx) __must_hold(local)
 {
 	struct bm_aio_ctx ctx = {
 		.mdev = mdev,
 		.in_flight = ATOMIC_INIT(1),
 		.done = COMPLETION_INITIALIZER_ONSTACK(ctx.done),
-		.flags = lazy_writeout_upper_idx ? BM_AIO_COPY_PAGES : 0,
+		.flags = flags,
 	};
 	struct drbd_bitmap *b = mdev->bitmap;
 	int num_pages, i, count = 0;
@@ -1042,6 +1061,10 @@ static int bm_rw(struct drbd_conf *mdev, int rw, unsigned lazy_writeout_upper_id
 		if (lazy_writeout_upper_idx && i == lazy_writeout_upper_idx)
 			break;
 		if (rw & WRITE) {
+			if ((flags & BM_AIO_WRITE_HINTED) &&
+			    !test_and_clear_bit(BM_PAGE_HINT_WRITEOUT,
+				    &page_private(b->bm_pages[i])))
+				continue;
 			if (bm_test_page_unchanged(b->bm_pages[i])) {
 				dynamic_dev_dbg(DEV, "skipped bm write for idx %u\n", i);
 				continue;
@@ -1099,7 +1122,7 @@ static int bm_rw(struct drbd_conf *mdev, int rw, unsigned lazy_writeout_upper_id
  */
 int drbd_bm_read(struct drbd_conf *mdev) __must_hold(local)
 {
-	return bm_rw(mdev, READ, 0);
+	return bm_rw(mdev, READ, 0, 0);
 }
 
 /**
@@ -1110,7 +1133,7 @@ int drbd_bm_read(struct drbd_conf *mdev) __must_hold(local)
  */
 int drbd_bm_write(struct drbd_conf *mdev) __must_hold(local)
 {
-	return bm_rw(mdev, WRITE, 0);
+	return bm_rw(mdev, WRITE, 0, 0);
 }
 
 /**
@@ -1120,12 +1143,20 @@ int drbd_bm_write(struct drbd_conf *mdev) __must_hold(local)
  */
 int drbd_bm_write_lazy(struct drbd_conf *mdev, unsigned upper_idx) __must_hold(local)
 {
-	return bm_rw(mdev, WRITE, upper_idx);
+	return bm_rw(mdev, WRITE, BM_AIO_COPY_PAGES, upper_idx);
 }
 
+/**
+ * drbd_bm_write_hinted() - Write bitmap pages with "hint" marks, if they have changed.
+ * @mdev:	DRBD device.
+ */
+int drbd_bm_write_hinted(struct drbd_conf *mdev) __must_hold(local)
+{
+	return bm_rw(mdev, WRITE, BM_AIO_WRITE_HINTED | BM_AIO_COPY_PAGES, 0);
+}
 
 /**
- * drbd_bm_write_page: Writes a PAGE_SIZE aligned piece of bitmap
+ * drbd_bm_write_page() - Writes a PAGE_SIZE aligned piece of bitmap
  * @mdev:	DRBD device.
  * @idx:	bitmap page index
  *
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index de92e8b..f125c0e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1310,11 +1310,14 @@ struct bm_extent {
 
 #define SLEEP_TIME (HZ/10)
 
-#define BM_BLOCK_SHIFT  12			 /* 4k per bit */
+/* We do bitmap IO in units of 4k blocks.
+ * We also still have a hardcoded 4k per bit relation. */
+#define BM_BLOCK_SHIFT	12			 /* 4k per bit */
 #define BM_BLOCK_SIZE	 (1<<BM_BLOCK_SHIFT)
-/* (9+3) : 512 bytes @ 8 bits; representing 16M storage
- * per sector of on disk bitmap */
-#define BM_EXT_SHIFT	 (BM_BLOCK_SHIFT + MD_SECTOR_SHIFT + 3)  /* = 24 */
+/* mostly arbitrarily set the represented size of one bitmap extent,
+ * aka resync extent, to 16 MiB (which is also 512 Byte worth of bitmap
+ * at 4k per bit resolution) */
+#define BM_EXT_SHIFT	 24	/* 16 MiB per resync extent */
 #define BM_EXT_SIZE	 (1<<BM_EXT_SHIFT)
 
 #if (BM_EXT_SHIFT != 24) || (BM_BLOCK_SHIFT != 12)
@@ -1408,7 +1411,9 @@ extern int  drbd_bm_test_bit(struct drbd_conf *mdev, unsigned long bitnr);
 extern int  drbd_bm_e_weight(struct drbd_conf *mdev, unsigned long enr);
 extern int  drbd_bm_write_page(struct drbd_conf *mdev, unsigned int idx) __must_hold(local);
 extern int  drbd_bm_read(struct drbd_conf *mdev) __must_hold(local);
+extern void drbd_bm_mark_for_writeout(struct drbd_conf *mdev, int page_nr);
 extern int  drbd_bm_write(struct drbd_conf *mdev) __must_hold(local);
+extern int  drbd_bm_write_hinted(struct drbd_conf *mdev) __must_hold(local);
 extern unsigned long drbd_bm_ALe_set_all(struct drbd_conf *mdev,
 		unsigned long al_enr);
 extern size_t	     drbd_bm_words(struct drbd_conf *mdev);
-- 
1.7.4.1

