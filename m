Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1JMKcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:32:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:58118 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1JMKcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:32:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/10] drbd: detach from frozen backing device
Date: Thu, 13 Oct 2011 12:32:13 +0200
Message-Id: <1318501936-11689-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
References: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* drbd-8.3:
  documentation: Documented detach's --force and disk's --disk-timeout
  drbd: Implemented the disk-timeout option
  drbd: Force flag for the detach operation
  drbd: Allow new IOs while the local disk in in FAILED state
  drbd: Bitmap IO functions can not return prematurely if the disk breaks
  drbd: Added a kref to bm_aio_ctx
  drbd: Hold a reference to ldev while doing meta-data IO
  drbd: Keep a reference to the bio until the completion handler finished
  drbd: Implemented wait_until_done_or_disk_failure()
  drbd: Replaced md_io_mutex by an atomic: md_io_in_use
  drbd: moved md_io into mdev
  drbd: Immediately allow completion of IOs, that wait for IO completions on a failed disk
  drbd: Keep a reference to barrier acked requests

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |   75 +++++++++++++++++++------
 drivers/block/drbd/drbd_bitmap.c   |  109 ++++++++++++++++++++++++++---------
 drivers/block/drbd/drbd_int.h      |   12 +++-
 drivers/block/drbd/drbd_main.c     |   77 ++++++++++++++++++++++---
 drivers/block/drbd/drbd_nl.c       |   28 ++++++++-
 drivers/block/drbd/drbd_receiver.c |    2 -
 drivers/block/drbd/drbd_req.c      |   52 ++++++++++++-----
 drivers/block/drbd/drbd_req.h      |   19 ++++--
 drivers/block/drbd/drbd_state.c    |    7 ++
 drivers/block/drbd/drbd_worker.c   |    9 +++-
 include/linux/drbd_genl.h          |    9 +++-
 include/linux/drbd_limits.h        |    6 ++
 12 files changed, 317 insertions(+), 88 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index aeb483d..58b5b61 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -114,18 +114,44 @@ struct drbd_atodb_wait {
 
 static int w_al_write_transaction(struct drbd_work *, int);
 
+void *drbd_md_get_buffer(struct drbd_conf *mdev)
+{
+	int r;
+
+	wait_event(mdev->misc_wait,
+		   (r = atomic_cmpxchg(&mdev->md_io_in_use, 0, 1)) == 0 ||
+		   mdev->state.disk <= D_FAILED);
+
+	return r ? NULL : page_address(mdev->md_io_page);
+}
+
+void drbd_md_put_buffer(struct drbd_conf *mdev)
+{
+	if (atomic_dec_and_test(&mdev->md_io_in_use))
+		wake_up(&mdev->misc_wait);
+}
+
+static bool md_io_allowed(struct drbd_conf *mdev)
+{
+	enum drbd_disk_state ds = mdev->state.disk;
+	return ds >= D_NEGOTIATING || ds == D_ATTACHING;
+}
+
+void wait_until_done_or_disk_failure(struct drbd_conf *mdev, unsigned int *done)
+{
+	wait_event(mdev->misc_wait, *done || !md_io_allowed(mdev));
+}
+
 static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 				 struct drbd_backing_dev *bdev,
 				 struct page *page, sector_t sector,
 				 int rw, int size)
 {
 	struct bio *bio;
-	struct drbd_md_io md_io;
 	int err;
 
-	md_io.mdev = mdev;
-	init_completion(&md_io.event);
-	md_io.error = 0;
+	mdev->md_io.done = 0;
+	mdev->md_io.error = -ENODEV;
 
 	if ((rw & WRITE) && !test_bit(MD_NO_FUA, &mdev->flags))
 		rw |= REQ_FUA | REQ_FLUSH;
@@ -137,17 +163,25 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 	err = -EIO;
 	if (bio_add_page(bio, page, size, 0) != size)
 		goto out;
-	bio->bi_private = &md_io;
+	bio->bi_private = &mdev->md_io;
 	bio->bi_end_io = drbd_md_io_complete;
 	bio->bi_rw = rw;
 
+	if (!get_ldev_if_state(mdev, D_ATTACHING)) {  /* Corresponding put_ldev in drbd_md_io_complete() */
+		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in _drbd_md_sync_page_io()\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	bio_get(bio); /* one bio_put() is in the completion handler */
+	atomic_inc(&mdev->md_io_in_use); /* drbd_md_put_buffer() is in the completion handler */
 	if (drbd_insert_fault(mdev, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
 		bio_endio(bio, -EIO);
 	else
 		submit_bio(rw, bio);
-	wait_for_completion(&md_io.event);
+	wait_until_done_or_disk_failure(mdev, &mdev->md_io.done);
 	if (bio_flagged(bio, BIO_UPTODATE))
-		err = md_io.error;
+		err = mdev->md_io.error;
 
  out:
 	bio_put(bio);
@@ -160,7 +194,7 @@ int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 	int err;
 	struct page *iop = mdev->md_io_page;
 
-	D_ASSERT(mutex_is_locked(&mdev->md_io_mutex));
+	D_ASSERT(atomic_read(&mdev->md_io_in_use) == 1);
 
 	BUG_ON(!bdev->md_bdev);
 
@@ -344,8 +378,14 @@ w_al_write_transaction(struct drbd_work *w, int unused)
 		return 0;
 	}
 
-	mutex_lock(&mdev->md_io_mutex); /* protects md_io_buffer, al_tr_cycle, ... */
-	buffer = page_address(mdev->md_io_page);
+	buffer = drbd_md_get_buffer(mdev); /* protects md_io_buffer, al_tr_cycle, ... */
+	if (!buffer) {
+		dev_err(DEV, "disk failed while waiting for md_io buffer\n");
+		aw->err = -EIO;
+		complete(&((struct update_al_work *)w)->event);
+		put_ldev(mdev);
+		return 1;
+	}
 
 	memset(buffer, 0, sizeof(*buffer));
 	buffer->magic = cpu_to_be32(DRBD_AL_MAGIC);
@@ -415,7 +455,7 @@ w_al_write_transaction(struct drbd_work *w, int unused)
 		mdev->al_tr_number++;
 	}
 
-	mutex_unlock(&mdev->md_io_mutex);
+	drbd_md_put_buffer(mdev);
 	complete(&((struct update_al_work *)w)->event);
 	put_ldev(mdev);
 
@@ -506,8 +546,9 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	/* lock out all other meta data io for now,
 	 * and make sure the page is mapped.
 	 */
-	mutex_lock(&mdev->md_io_mutex);
-	b = page_address(mdev->md_io_page);
+	b = drbd_md_get_buffer(mdev);
+	if (!b)
+		return 0;
 
 	/* Always use the full ringbuffer space for now.
 	 * possible optimization: read in all of it,
@@ -528,7 +569,7 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 
 		/* IO error */
 		if (rv == -1) {
-			mutex_unlock(&mdev->md_io_mutex);
+			drbd_md_put_buffer(mdev);
 			return 0;
 		}
 
@@ -558,7 +599,7 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	if (!found_valid) {
 		if (found_initialized != mx)
 			dev_warn(DEV, "No usable activity log found.\n");
-		mutex_unlock(&mdev->md_io_mutex);
+		drbd_md_put_buffer(mdev);
 		return 1;
 	}
 
@@ -573,7 +614,7 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 		if (!expect(rv != 0))
 			goto cancel;
 		if (rv == -1) {
-			mutex_unlock(&mdev->md_io_mutex);
+			drbd_md_put_buffer(mdev);
 			return 0;
 		}
 
@@ -643,7 +684,7 @@ cancel:
 	mdev->al_tr_pos = (to + 1) % (MD_AL_SECTORS*512/MD_BLOCK_SIZE);
 
 	/* ok, we are done with it */
-	mutex_unlock(&mdev->md_io_mutex);
+	drbd_md_put_buffer(mdev);
 
 	dev_info(DEV, "Found %d transactions (%d active extents) in activity log.\n",
 	     transactions, active_extents);
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 52c4814..7249671 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -918,13 +918,22 @@ void drbd_bm_clear_all(struct drbd_conf *mdev)
 struct bm_aio_ctx {
 	struct drbd_conf *mdev;
 	atomic_t in_flight;
-	struct completion done;
+	unsigned int done;
 	unsigned flags;
 #define BM_AIO_COPY_PAGES	1
 #define BM_AIO_WRITE_HINTED	2
 	int error;
+	struct kref kref;
 };
 
+static void bm_aio_ctx_destroy(struct kref *kref)
+{
+	struct bm_aio_ctx *ctx = container_of(kref, struct bm_aio_ctx, kref);
+
+	put_ldev(ctx->mdev);
+	kfree(ctx);
+}
+
 /* bv_page may be a copy, or may be the original */
 static void bm_async_io_complete(struct bio *bio, int error)
 {
@@ -968,8 +977,11 @@ static void bm_async_io_complete(struct bio *bio, int error)
 
 	bio_put(bio);
 
-	if (atomic_dec_and_test(&ctx->in_flight))
-		complete(&ctx->done);
+	if (atomic_dec_and_test(&ctx->in_flight)) {
+		ctx->done = 1;
+		wake_up(&mdev->misc_wait);
+		kref_put(&ctx->kref, &bm_aio_ctx_destroy);
+	}
 }
 
 static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must_hold(local)
@@ -1032,12 +1044,7 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
  */
 static int bm_rw(struct drbd_conf *mdev, int rw, unsigned flags, unsigned lazy_writeout_upper_idx) __must_hold(local)
 {
-	struct bm_aio_ctx ctx = {
-		.mdev = mdev,
-		.in_flight = ATOMIC_INIT(1),
-		.done = COMPLETION_INITIALIZER_ONSTACK(ctx.done),
-		.flags = flags,
-	};
+	struct bm_aio_ctx *ctx;
 	struct drbd_bitmap *b = mdev->bitmap;
 	int num_pages, i, count = 0;
 	unsigned long now;
@@ -1052,7 +1059,27 @@ static int bm_rw(struct drbd_conf *mdev, int rw, unsigned flags, unsigned lazy_w
 	 * For lazy writeout, we don't care for ongoing changes to the bitmap,
 	 * as we submit copies of pages anyways.
 	 */
-	if (!ctx.flags)
+
+	ctx = kmalloc(sizeof(struct bm_aio_ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	*ctx = (struct bm_aio_ctx) {
+		.mdev = mdev,
+		.in_flight = ATOMIC_INIT(1),
+		.done = 0,
+		.flags = flags,
+		.error = 0,
+		.kref = { ATOMIC_INIT(2) },
+	};
+
+	if (!get_ldev_if_state(mdev, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
+		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in bm_rw()\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	if (!ctx->flags)
 		WARN_ON(!(BM_LOCKED_MASK & b->bm_flags));
 
 	num_pages = b->bm_number_of_pages;
@@ -1081,32 +1108,38 @@ static int bm_rw(struct drbd_conf *mdev, int rw, unsigned flags, unsigned lazy_w
 				continue;
 			}
 		}
-		atomic_inc(&ctx.in_flight);
-		bm_page_io_async(&ctx, i, rw);
+		atomic_inc(&ctx->in_flight);
+		bm_page_io_async(ctx, i, rw);
 		++count;
 		cond_resched();
 	}
 
 	/*
-	 * We initialize ctx.in_flight to one to make sure bm_async_io_complete
+	 * We initialize ctx->in_flight to one to make sure bm_async_io_complete
 	 * will not complete() early, and decrement / test it here.  If there
 	 * are still some bios in flight, we need to wait for them here.
 	 */
-	if (!atomic_dec_and_test(&ctx.in_flight))
-		wait_for_completion(&ctx.done);
+	if (!atomic_dec_and_test(&ctx->in_flight))
+		wait_until_done_or_disk_failure(mdev, &ctx->done);
+
+	if (!count)
+		put_ldev(mdev); /* Since no IO was started, the completion handler was not invoked */
 
 	/* summary for global bitmap IO */
 	if (flags == 0)
 		dev_info(DEV, "bitmap %s of %u pages took %lu jiffies\n",
-				rw == WRITE ? "WRITE" : "READ",
-				count, jiffies - now);
+			 rw == WRITE ? "WRITE" : "READ",
+			 count, jiffies - now);
 
-	if (ctx.error) {
+	if (ctx->error) {
 		dev_alert(DEV, "we had at least one MD IO ERROR during bitmap IO\n");
 		drbd_chk_io_error(mdev, 1, true);
-		err = -EIO; /* ctx.error ? */
+		err = -EIO; /* ctx->error ? */
 	}
 
+	if (atomic_read(&ctx->in_flight))
+		err = -EIO; /* Disk failed during IO... */
+
 	now = jiffies;
 	if (rw == WRITE) {
 		drbd_md_flush(mdev);
@@ -1121,6 +1154,8 @@ static int bm_rw(struct drbd_conf *mdev, int rw, unsigned flags, unsigned lazy_w
 		dev_info(DEV, "%s (%lu bits) marked out-of-sync by on disk bit-map.\n",
 		     ppsize(ppb, now << (BM_BLOCK_SHIFT-10)), now);
 
+out:
+	kref_put(&ctx->kref, &bm_aio_ctx_destroy);
 	return err;
 }
 
@@ -1177,28 +1212,46 @@ int drbd_bm_write_hinted(struct drbd_conf *mdev) __must_hold(local)
  */
 int drbd_bm_write_page(struct drbd_conf *mdev, unsigned int idx) __must_hold(local)
 {
-	struct bm_aio_ctx ctx = {
+	struct bm_aio_ctx *ctx;
+	int err;
+
+	if (bm_test_page_unchanged(mdev->bitmap->bm_pages[idx])) {
+		dynamic_dev_dbg(DEV, "skipped bm page write for idx %u\n", idx);
+		return 0;
+	}
+
+	ctx = kmalloc(sizeof(struct bm_aio_ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	*ctx = (struct bm_aio_ctx) {
 		.mdev = mdev,
 		.in_flight = ATOMIC_INIT(1),
-		.done = COMPLETION_INITIALIZER_ONSTACK(ctx.done),
+		.done = 0,
 		.flags = BM_AIO_COPY_PAGES,
+		.error = 0,
+		.kref = { ATOMIC_INIT(2) },
 	};
 
-	if (bm_test_page_unchanged(mdev->bitmap->bm_pages[idx])) {
-		dynamic_dev_dbg(DEV, "skipped bm page write for idx %u\n", idx);
-		return 0;
+	if (!get_ldev_if_state(mdev, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
+		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in drbd_bm_write_page()\n");
+		err = -ENODEV;
+		goto out;
 	}
 
-	bm_page_io_async(&ctx, idx, WRITE_SYNC);
-	wait_for_completion(&ctx.done);
+	bm_page_io_async(ctx, idx, WRITE_SYNC);
+	wait_until_done_or_disk_failure(mdev, &ctx->done);
 
-	if (ctx.error)
+	if (ctx->error)
 		drbd_chk_io_error(mdev, 1, true);
 		/* that should force detach, so the in memory bitmap will be
 		 * gone in a moment as well. */
 
 	mdev->bm_writ_cnt++;
-	return ctx.error;
+	err = atomic_read(&ctx->in_flight) ? -EIO : ctx->error;
+ out:
+	kref_put(&ctx->kref, &bm_aio_ctx_destroy);
+	return err;
 }
 
 /* NOTE
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 6035784..4e58205 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -780,8 +780,7 @@ struct drbd_backing_dev {
 };
 
 struct drbd_md_io {
-	struct drbd_conf *mdev;
-	struct completion event;
+	unsigned int done;
 	int error;
 };
 
@@ -852,6 +851,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct drbd_tl_epoch *newest_tle;
 	struct drbd_tl_epoch *oldest_tle;
 	struct list_head out_of_sequence_requests;
+	struct list_head barrier_acked_requests;
 
 	struct crypto_hash *cram_hmac_tfm;
 	struct crypto_hash *integrity_tfm;  /* checksums we compute, updates protected by tconn->data->mutex */
@@ -978,7 +978,8 @@ struct drbd_conf {
 	atomic_t pp_in_use_by_net;	/* sendpage()d, still referenced by tcp */
 	wait_queue_head_t ee_wait;
 	struct page *md_io_page;	/* one page buffer for md_io */
-	struct mutex md_io_mutex;	/* protects the md_io_buffer */
+	struct drbd_md_io md_io;
+	atomic_t md_io_in_use;		/* protects the md_io, md_io_page and md_io_tmpp */
 	spinlock_t al_lock;
 	wait_queue_head_t al_wait;
 	struct lru_cache *act_log;	/* activity log */
@@ -1424,9 +1425,12 @@ extern void resume_next_sg(struct drbd_conf *mdev);
 extern void suspend_other_sg(struct drbd_conf *mdev);
 extern int drbd_resync_finished(struct drbd_conf *mdev);
 /* maybe rather drbd_main.c ? */
+extern void *drbd_md_get_buffer(struct drbd_conf *mdev);
+extern void drbd_md_put_buffer(struct drbd_conf *mdev);
 extern int drbd_md_sync_page_io(struct drbd_conf *mdev,
 		struct drbd_backing_dev *bdev, sector_t sector, int rw);
 extern void drbd_ov_out_of_sync_found(struct drbd_conf *, sector_t, int);
+extern void wait_until_done_or_disk_failure(struct drbd_conf *mdev, unsigned int *done);
 extern void drbd_rs_controller_reset(struct drbd_conf *mdev);
 
 static inline void ov_out_of_sync_print(struct drbd_conf *mdev)
@@ -2151,12 +2155,12 @@ static inline int drbd_state_is_stable(struct drbd_conf *mdev)
 	case D_OUTDATED:
 	case D_CONSISTENT:
 	case D_UP_TO_DATE:
+	case D_FAILED:
 		/* disk state is stable as well. */
 		break;
 
 	/* no new io accepted during transitional states */
 	case D_ATTACHING:
-	case D_FAILED:
 	case D_NEGOTIATING:
 	case D_UNKNOWN:
 	case D_MASK:
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 448de7b..1538498 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -215,6 +215,7 @@ static int tl_init(struct drbd_tconn *tconn)
 	tconn->oldest_tle = b;
 	tconn->newest_tle = b;
 	INIT_LIST_HEAD(&tconn->out_of_sequence_requests);
+	INIT_LIST_HEAD(&tconn->barrier_acked_requests);
 
 	return 1;
 }
@@ -315,7 +316,7 @@ void tl_release(struct drbd_tconn *tconn, unsigned int barrier_nr,
 	   These have been list_move'd to the out_of_sequence_requests list in
 	   _req_mod(, BARRIER_ACKED) above.
 	   */
-	list_del_init(&b->requests);
+	list_splice_init(&b->requests, &tconn->barrier_acked_requests);
 	mdev = b->w.mdev;
 
 	nob = b->next;
@@ -417,8 +418,23 @@ void _tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what)
 		b = tmp;
 		list_splice(&carry_reads, &b->requests);
 	}
-}
 
+	/* Actions operating on the disk state, also want to work on
+	   requests that got barrier acked. */
+	switch (what) {
+	case FAIL_FROZEN_DISK_IO:
+	case RESTART_FROZEN_DISK_IO:
+		list_for_each_safe(le, tle, &tconn->barrier_acked_requests) {
+			req = list_entry(le, struct drbd_request, tl_requests);
+			_req_mod(req, what);
+		}
+	case CONNECTION_LOST_WHILE_PENDING:
+	case RESEND:
+		break;
+	default:
+		conn_err(tconn, "what = %d in _tl_restart()\n", what);
+	}
+}
 
 /**
  * tl_clear() - Clears all requests and &struct drbd_tl_epoch objects out of the TL
@@ -467,6 +483,42 @@ void tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what)
 	spin_unlock_irq(&tconn->req_lock);
 }
 
+/**
+ * tl_apply() - Applies an event to all requests for a certain mdev in the TL
+ * @mdev:	DRBD device.
+ * @what:       The action/event to perform with all request objects
+ *
+ * @what might ony be ABORT_DISK_IO.
+ */
+void tl_apply(struct drbd_conf *mdev, enum drbd_req_event what)
+{
+	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_tl_epoch *b;
+	struct list_head *le, *tle;
+	struct drbd_request *req;
+
+	D_ASSERT(what == ABORT_DISK_IO);
+
+	spin_lock_irq(&tconn->req_lock);
+	b = tconn->oldest_tle;
+	while (b) {
+		list_for_each_safe(le, tle, &b->requests) {
+			req = list_entry(le, struct drbd_request, tl_requests);
+			if (req->w.mdev == mdev)
+				_req_mod(req, what);
+		}
+		b = b->next;
+	}
+
+	list_for_each_safe(le, tle, &tconn->barrier_acked_requests) {
+		req = list_entry(le, struct drbd_request, tl_requests);
+		if (req->w.mdev == mdev)
+			_req_mod(req, what);
+	}
+
+	spin_unlock_irq(&tconn->req_lock);
+}
+
 static int drbd_thread_setup(void *arg)
 {
 	struct drbd_thread *thi = (struct drbd_thread *) arg;
@@ -2003,8 +2055,8 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	atomic_set(&mdev->rs_sect_in, 0);
 	atomic_set(&mdev->rs_sect_ev, 0);
 	atomic_set(&mdev->ap_in_flight, 0);
+	atomic_set(&mdev->md_io_in_use, 0);
 
-	mutex_init(&mdev->md_io_mutex);
 	mutex_init(&mdev->own_state_mutex);
 	mdev->state_mutex = &mdev->own_state_mutex;
 
@@ -2282,6 +2334,8 @@ void drbd_minor_destroy(struct kref *kref)
 	struct drbd_conf *mdev = container_of(kref, struct drbd_conf, kref);
 	struct drbd_tconn *tconn = mdev->tconn;
 
+	del_timer_sync(&mdev->request_timer);
+
 	/* paranoia asserts */
 	D_ASSERT(mdev->open_cnt == 0);
 	D_ASSERT(list_empty(&mdev->tconn->data.work.q));
@@ -2868,8 +2922,10 @@ void drbd_md_sync(struct drbd_conf *mdev)
 	if (!get_ldev_if_state(mdev, D_FAILED))
 		return;
 
-	mutex_lock(&mdev->md_io_mutex);
-	buffer = (struct meta_data_on_disk *)page_address(mdev->md_io_page);
+	buffer = drbd_md_get_buffer(mdev);
+	if (!buffer)
+		goto out;
+
 	memset(buffer, 0, 512);
 
 	buffer->la_size = cpu_to_be64(drbd_get_capacity(mdev->this_bdev));
@@ -2900,7 +2956,8 @@ void drbd_md_sync(struct drbd_conf *mdev)
 	 * since we updated it on metadata. */
 	mdev->ldev->md.la_size_sect = drbd_get_capacity(mdev->this_bdev);
 
-	mutex_unlock(&mdev->md_io_mutex);
+	drbd_md_put_buffer(mdev);
+out:
 	put_ldev(mdev);
 }
 
@@ -2920,8 +2977,9 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	if (!get_ldev_if_state(mdev, D_ATTACHING))
 		return ERR_IO_MD_DISK;
 
-	mutex_lock(&mdev->md_io_mutex);
-	buffer = (struct meta_data_on_disk *)page_address(mdev->md_io_page);
+	buffer = drbd_md_get_buffer(mdev);
+	if (!buffer)
+		goto out;
 
 	if (drbd_md_sync_page_io(mdev, bdev, bdev->md.md_offset, READ)) {
 		/* NOTE: can't do normal error processing here as this is
@@ -2983,7 +3041,8 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 		bdev->disk_conf->al_extents = DRBD_AL_EXTENTS_DEF;
 
  err:
-	mutex_unlock(&mdev->md_io_mutex);
+	drbd_md_put_buffer(mdev);
+ out:
 	put_ldev(mdev);
 
 	return rv;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0f8d473..d6bdb59 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1276,6 +1276,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	synchronize_rcu();
 	kfree(old_disk_conf);
 	kfree(old_plan);
+	mod_timer(&mdev->request_timer, jiffies + HZ);
 	goto success;
 
 fail_unlock:
@@ -1668,6 +1669,8 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (rv < SS_SUCCESS)
 		goto force_diskless_dec;
 
+	mod_timer(&mdev->request_timer, jiffies + HZ);
+
 	if (mdev->state.role == R_PRIMARY)
 		mdev->ldev->md.uuid[UI_CURRENT] |=  (u64)1;
 	else
@@ -1707,10 +1710,17 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-static int adm_detach(struct drbd_conf *mdev)
+static int adm_detach(struct drbd_conf *mdev, int force)
 {
 	enum drbd_state_rv retcode;
 	int ret;
+
+	if (force) {
+		drbd_force_state(mdev, NS(disk, D_FAILED));
+		retcode = SS_SUCCESS;
+		goto out;
+	}
+
 	drbd_suspend_io(mdev); /* so no-one is stuck in drbd_al_begin_io */
 	retcode = drbd_request_state(mdev, NS(disk, D_FAILED));
 	/* D_FAILED will transition to DISKLESS. */
@@ -1721,6 +1731,7 @@ static int adm_detach(struct drbd_conf *mdev)
 		retcode = SS_NOTHING_TO_DO;
 	if (ret)
 		retcode = ERR_INTR;
+out:
 	return retcode;
 }
 
@@ -1732,6 +1743,8 @@ static int adm_detach(struct drbd_conf *mdev)
 int drbd_adm_detach(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
+	struct detach_parms parms = { };
+	int err;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
 	if (!adm_ctx.reply_skb)
@@ -1739,7 +1752,16 @@ int drbd_adm_detach(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	retcode = adm_detach(adm_ctx.mdev);
+	if (info->attrs[DRBD_NLA_DETACH_PARMS]) {
+		err = detach_parms_from_attrs(&parms, info);
+		if (err) {
+			retcode = ERR_MANDATORY_TAG;
+			drbd_msg_put_info(from_attrs_err_to_txt(err));
+			goto out;
+		}
+	}
+
+	retcode = adm_detach(adm_ctx.mdev, parms.force_detach);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3162,7 +3184,7 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 
 	/* detach */
 	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
-		retcode = adm_detach(mdev);
+		retcode = adm_detach(mdev, 0);
 		if (retcode < SS_SUCCESS) {
 			drbd_msg_put_info("failed to detach");
 			goto out;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 7218750..3a7e54b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4366,8 +4366,6 @@ static int drbd_disconnected(struct drbd_conf *mdev)
 	atomic_set(&mdev->rs_pending_cnt, 0);
 	wake_up(&mdev->misc_wait);
 
-	del_timer(&mdev->request_timer);
-
 	del_timer_sync(&mdev->resync_timer);
 	resync_timer_fn((unsigned long)mdev);
 
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index c4e4553..2f41205 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -213,8 +213,7 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 {
 	const unsigned long s = req->rq_state;
 	struct drbd_conf *mdev = req->w.mdev;
-	/* only WRITES may end up here without a master bio (on barrier ack) */
-	int rw = req->master_bio ? bio_data_dir(req->master_bio) : WRITE;
+	int rw = req->rq_state & RQ_WRITE ? WRITE : READ;
 
 	/* we must not complete the master bio, while it is
 	 *	still being processed by _drbd_send_zc_bio (drbd_send_dblock)
@@ -225,7 +224,7 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 	 *	the receiver,
 	 *	the bio_endio completion callbacks.
 	 */
-	if (s & RQ_LOCAL_PENDING)
+	if (s & RQ_LOCAL_PENDING && !(s & RQ_LOCAL_ABORTED))
 		return;
 	if (req->i.waiting) {
 		/* Retry all conflicting peer requests.  */
@@ -288,6 +287,9 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 		req->master_bio = NULL;
 	}
 
+	if (s & RQ_LOCAL_PENDING)
+		return;
+
 	if ((s & RQ_NET_MASK) == 0 || (s & RQ_NET_DONE)) {
 		/* this is disconnected (local only) operation,
 		 * or protocol C P_WRITE_ACK,
@@ -362,7 +364,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case COMPLETED_OK:
-		if (bio_data_dir(req->master_bio) == WRITE)
+		if (req->rq_state & RQ_WRITE)
 			mdev->writ_cnt += req->i.size >> 9;
 		else
 			mdev->read_cnt += req->i.size >> 9;
@@ -374,6 +376,14 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		put_ldev(mdev);
 		break;
 
+	case ABORT_DISK_IO:
+		req->rq_state |= RQ_LOCAL_ABORTED;
+		if (req->rq_state & RQ_WRITE)
+			_req_may_be_done_not_susp(req, m);
+		else
+			goto goto_queue_for_net_read;
+		break;
+
 	case WRITE_COMPLETED_WITH_ERROR:
 		req->rq_state |= RQ_LOCAL_COMPLETED;
 		req->rq_state &= ~RQ_LOCAL_PENDING;
@@ -402,6 +412,8 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		__drbd_chk_io_error(mdev, false);
 		put_ldev(mdev);
 
+	goto_queue_for_net_read:
+
 		/* no point in retrying if there is no good remote data,
 		 * or we have no connection. */
 		if (mdev->state.pdsk != D_UP_TO_DATE) {
@@ -1071,14 +1083,21 @@ void request_timer_fn(unsigned long data)
 	struct drbd_request *req; /* oldest request */
 	struct list_head *le;
 	struct net_conf *nc;
-	unsigned long et; /* effective timeout = ko_count * timeout */
+	unsigned long ent = 0, dt = 0, et; /* effective timeout = ko_count * timeout */
 
 	rcu_read_lock();
 	nc = rcu_dereference(tconn->net_conf);
-	et = nc ? nc->timeout * HZ/10 * nc->ko_count : 0;
+	ent = nc ? nc->timeout * HZ/10 * nc->ko_count : 0;
+
+	if (get_ldev(mdev)) {
+		dt = rcu_dereference(mdev->ldev->disk_conf)->disk_timeout * HZ / 10;
+		put_ldev(mdev);
+	}
 	rcu_read_unlock();
 
-	if (!et || mdev->state.conn < C_WF_REPORT_PARAMS)
+	et = min_not_zero(dt, ent);
+
+	if (!et || (mdev->state.conn < C_WF_REPORT_PARAMS && mdev->state.disk <= D_FAILED))
 		return; /* Recurring timer stopped */
 
 	spin_lock_irq(&tconn->req_lock);
@@ -1091,17 +1110,18 @@ void request_timer_fn(unsigned long data)
 
 	le = le->prev;
 	req = list_entry(le, struct drbd_request, tl_requests);
-	if (time_is_before_eq_jiffies(req->start_time + et)) {
-		if (req->rq_state & RQ_NET_PENDING) {
+	if (ent && req->rq_state & RQ_NET_PENDING) {
+		if (time_is_before_eq_jiffies(req->start_time + ent)) {
 			dev_warn(DEV, "Remote failed to finish a request within ko-count * timeout\n");
-			_drbd_set_state(_NS(mdev, conn, C_TIMEOUT), CS_VERBOSE, NULL);
-		} else {
-			dev_warn(DEV, "Local backing block device frozen?\n");
-			mod_timer(&mdev->request_timer, jiffies + et);
+			_drbd_set_state(_NS(mdev, conn, C_TIMEOUT), CS_VERBOSE | CS_HARD, NULL);
+		}
+	}
+	if (dt && req->rq_state & RQ_LOCAL_PENDING) {
+		if (time_is_before_eq_jiffies(req->start_time + dt)) {
+			dev_warn(DEV, "Local backing device failed to meet the disk-timeout\n");
+			_drbd_set_state(_NS(mdev, disk, D_FAILED), CS_VERBOSE | CS_HARD, NULL);
 		}
-	} else {
-		mod_timer(&mdev->request_timer, req->start_time + et);
 	}
-
 	spin_unlock_irq(&tconn->req_lock);
+	mod_timer(&mdev->request_timer, req->start_time + et);
 }
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 5135c95..f6aff15 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -106,6 +106,7 @@ enum drbd_req_event {
 	READ_COMPLETED_WITH_ERROR,
 	READ_AHEAD_COMPLETED_WITH_ERROR,
 	WRITE_COMPLETED_WITH_ERROR,
+	ABORT_DISK_IO,
 	COMPLETED_OK,
 	RESEND,
 	FAIL_FROZEN_DISK_IO,
@@ -119,18 +120,21 @@ enum drbd_req_event {
  * same time, so we should hold the request lock anyways.
  */
 enum drbd_req_state_bits {
-	/* 210
-	 * 000: no local possible
-	 * 001: to be submitted
+	/* 3210
+	 * 0000: no local possible
+	 * 0001: to be submitted
 	 *    UNUSED, we could map: 011: submitted, completion still pending
-	 * 110: completed ok
-	 * 010: completed with error
+	 * 0110: completed ok
+	 * 0010: completed with error
+	 * 1001: Aborted (before completion)
+	 * 1x10: Aborted and completed -> free
 	 */
 	__RQ_LOCAL_PENDING,
 	__RQ_LOCAL_COMPLETED,
 	__RQ_LOCAL_OK,
+	__RQ_LOCAL_ABORTED,
 
-	/* 76543
+	/* 87654
 	 * 00000: no network possible
 	 * 00001: to be send
 	 * 00011: to be send, on worker queue
@@ -209,8 +213,9 @@ enum drbd_req_state_bits {
 #define RQ_LOCAL_PENDING   (1UL << __RQ_LOCAL_PENDING)
 #define RQ_LOCAL_COMPLETED (1UL << __RQ_LOCAL_COMPLETED)
 #define RQ_LOCAL_OK        (1UL << __RQ_LOCAL_OK)
+#define RQ_LOCAL_ABORTED   (1UL << __RQ_LOCAL_ABORTED)
 
-#define RQ_LOCAL_MASK      ((RQ_LOCAL_OK << 1)-1) /* 0x07 */
+#define RQ_LOCAL_MASK      ((RQ_LOCAL_ABORTED << 1)-1)
 
 #define RQ_NET_PENDING     (1UL << __RQ_NET_PENDING)
 #define RQ_NET_QUEUED      (1UL << __RQ_NET_QUEUED)
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 65ba12b..0f538a6 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -29,6 +29,9 @@
 #include "drbd_int.h"
 #include "drbd_req.h"
 
+/* in drbd_main.c */
+extern void tl_apply(struct drbd_conf *mdev, enum drbd_req_event what);
+
 struct after_state_chg_work {
 	struct drbd_work w;
 	union drbd_state os;
@@ -1315,6 +1318,10 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 		rcu_read_unlock();
 		was_io_error = test_and_clear_bit(WAS_IO_ERROR, &mdev->flags);
 
+		/* Immediately allow completion of all application IO, that waits
+		   for completion from the local disk. */
+		tl_apply(mdev, ABORT_DISK_IO);
+
 		/* current state still has to be D_FAILED,
 		 * there is only one way out: to D_DISKLESS,
 		 * and that may only happen after our put_ldev below. */
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 85bcab9..9eae4f6 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -67,11 +67,18 @@ rwlock_t global_state_lock;
 void drbd_md_io_complete(struct bio *bio, int error)
 {
 	struct drbd_md_io *md_io;
+	struct drbd_conf *mdev;
 
 	md_io = (struct drbd_md_io *)bio->bi_private;
+	mdev = container_of(md_io, struct drbd_conf, md_io);
+
 	md_io->error = error;
 
-	complete(&md_io->event);
+	md_io->done = 1;
+	wake_up(&mdev->misc_wait);
+	bio_put(bio);
+	drbd_md_put_buffer(mdev);
+	put_ldev(mdev);
 }
 
 /* reads on behalf of the partner,
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index e879a93..2e6cefe 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -128,6 +128,7 @@ GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 	__flg_field_def(17, DRBD_GENLA_F_MANDATORY,	disk_flushes, DRBD_DISK_FLUSHES_DEF)
 	__flg_field_def(18, DRBD_GENLA_F_MANDATORY,	disk_drain, DRBD_DISK_DRAIN_DEF)
 	__flg_field_def(19, DRBD_GENLA_F_MANDATORY,	md_flushes, DRBD_MD_FLUSHES_DEF)
+	__u32_field_def(20,	DRBD_GENLA_F_MANDATORY,	disk_timeout, DRBD_DISK_TIMEOUT_DEF)
 )
 
 GENL_struct(DRBD_NLA_RESOURCE_OPTS, 4, res_opts,
@@ -224,6 +225,10 @@ GENL_struct(DRBD_NLA_DISCONNECT_PARMS, 12, disconnect_parms,
 	__flg_field(1, DRBD_GENLA_F_MANDATORY,	force_disconnect)
 )
 
+GENL_struct(DRBD_NLA_DETACH_PARMS, 13, detach_parms,
+	__flg_field(1, DRBD_GENLA_F_MANDATORY,	force_detach)
+)
+
 /*
  * Notifications and commands (genlmsghdr->cmd)
  */
@@ -335,7 +340,9 @@ GENL_op(
 )
 
 GENL_op(DRBD_ADM_DETACH,	18, GENL_doit(drbd_adm_detach),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_DETACH_PARMS, DRBD_GENLA_F_MANDATORY))
+
 GENL_op(DRBD_ADM_INVALIDATE,	19, GENL_doit(drbd_adm_invalidate),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_INVAL_PEER,	20, GENL_doit(drbd_adm_invalidate_peer),
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index cd51207..425010a 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -50,6 +50,12 @@
 #define DRBD_TIMEOUT_MAX 600
 #define DRBD_TIMEOUT_DEF 60       /* 6 seconds */
 
+ /* If backing disk takes longer than disk_timeout, mark the disk as failed */
+#define DRBD_DISK_TIMEOUT_MIN 0    /* 0 = disabled */
+#define DRBD_DISK_TIMEOUT_MAX 6000 /* 10 Minutes */
+#define DRBD_DISK_TIMEOUT_DEF 0    /* disabled */
+#define DRBD_DISK_TIMEOUT_SCALE '1'
+
   /* active connection retries when C_WF_CONNECTION */
 #define DRBD_CONNECT_INT_MIN 1
 #define DRBD_CONNECT_INT_MAX 120
-- 
1.7.4.1

