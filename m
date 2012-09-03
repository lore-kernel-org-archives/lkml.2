Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2ICCMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 22:12:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35878 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab2ICCMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 22:12:36 -0400
From: Robin Dong <robin.k.dong@gmail.com>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH 2/2] md: modify dm_io() so it could return bios instead of submitting it
Date: Mon,  3 Sep 2012 10:12:26 +0800
Message-Id: <1346638346-497-2-git-send-email-robin.k.dong@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1346638346-497-1-git-send-email-robin.k.dong@gmail.com>
References: <1346638346-497-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Dong <sanbai@taobao.com>

When trying to modify flashcache to request based (current it's bio based), we need
to make request from bios by ourselves, but dm_io() will submit these bios directly,
so we propose to modify the dm_io() to return bios instead of submiting it.

This could also improve the flexibility of dm_io().

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 drivers/md/dm-bufio.c           |    2 +
 drivers/md/dm-io.c              |   58 +++++++++++++++++++++++----------------
 drivers/md/dm-kcopyd.c          |    1 +
 drivers/md/dm-log.c             |    1 +
 drivers/md/dm-raid1.c           |    3 ++
 drivers/md/dm-snap-persistent.c |    1 +
 include/linux/dm-io.h           |    3 ++
 7 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cc06a1e..f5867b9 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -487,6 +487,7 @@ static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
 		.notify.fn = dmio_complete,
 		.notify.context = b,
 		.client = b->c->dm_io,
+		.submit_bio = 1,
 	};
 	struct dm_io_region region = {
 		.bdev = b->c->bdev,
@@ -1200,6 +1201,7 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c)
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
 		.client = c->dm_io,
+		.submit_bio = 1,
 	};
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index ea5dd28..f235182 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -287,8 +287,8 @@ static void km_dp_init(struct dpages *dp, void *data)
 /*-----------------------------------------------------------------
  * IO routines that accept a list of pages.
  *---------------------------------------------------------------*/
-static void do_region(int rw, unsigned region, struct dm_io_region *where,
-		      struct dpages *dp, struct io *io)
+static void do_region(struct dm_io_request *io_req, unsigned region,
+		struct dm_io_region *where, struct dpages *dp, struct io *io)
 {
 	struct bio *bio;
 	struct page *page;
@@ -298,6 +298,7 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 	sector_t remaining = where->count;
 	struct request_queue *q = bdev_get_queue(where->bdev);
 	sector_t discard_sectors;
+	int rw = io_req->bi_rw;
 
 	/*
 	 * where->count may be zero if rw holds a flush and we need to
@@ -339,15 +340,26 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		}
 
 		atomic_inc(&io->count);
-		submit_bio(rw, bio);
+		if (io_req->submit_bio)
+			submit_bio(rw, bio);
+		else {
+			bio->bi_rw |= rw;
+			if (io_req->start) {
+				io_req->end->bi_next = bio;
+				io_req->end = bio;
+			} else
+				io_req->start = io_req->end = bio;
+			bio->bi_next = NULL;
+		}
 	} while (remaining);
 }
 
-static void dispatch_io(int rw, unsigned int num_regions,
+static void dispatch_io(struct dm_io_request *io_req, unsigned int num_regions,
 			struct dm_io_region *where, struct dpages *dp,
 			struct io *io, int sync)
 {
 	int i;
+	int rw = io_req->bi_rw;
 	struct dpages old_pages = *dp;
 
 	BUG_ON(num_regions > DM_IO_MAX_REGIONS);
@@ -362,7 +374,7 @@ static void dispatch_io(int rw, unsigned int num_regions,
 	for (i = 0; i < num_regions; i++) {
 		*dp = old_pages;
 		if (where[i].count || (rw & REQ_FLUSH))
-			do_region(rw, i, where + i, dp, io);
+			do_region(io_req, i, where + i, dp, io);
 	}
 
 	/*
@@ -372,8 +384,8 @@ static void dispatch_io(int rw, unsigned int num_regions,
 	dec_count(io, 0, 0);
 }
 
-static int sync_io(struct dm_io_client *client, unsigned int num_regions,
-		   struct dm_io_region *where, int rw, struct dpages *dp,
+static int sync_io(struct dm_io_request *io_req,  unsigned int num_regions,
+		   struct dm_io_region *where, struct dpages *dp,
 		   unsigned long *error_bits)
 {
 	/*
@@ -385,7 +397,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	volatile char io_[sizeof(struct io) + __alignof__(struct io) - 1];
 	struct io *io = (struct io *)PTR_ALIGN(&io_, __alignof__(struct io));
 
-	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
+	if (num_regions > 1 && (io_req->bi_rw & RW_MASK) != WRITE) {
 		WARN_ON(1);
 		return -EIO;
 	}
@@ -393,12 +405,12 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->sleeper = current;
-	io->client = client;
+	io->client = io_req->client;
 
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
-	dispatch_io(rw, num_regions, where, dp, io, 1);
+	dispatch_io(io_req, num_regions, where, dp, io, 1);
 
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -416,30 +428,29 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	return io->error_bits ? -EIO : 0;
 }
 
-static int async_io(struct dm_io_client *client, unsigned int num_regions,
-		    struct dm_io_region *where, int rw, struct dpages *dp,
-		    io_notify_fn fn, void *context)
+static int async_io(struct dm_io_request *io_req, unsigned int num_regions,
+		    struct dm_io_region *where, struct dpages *dp)
 {
 	struct io *io;
 
-	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
+	if (num_regions > 1 && (io_req->bi_rw & RW_MASK) != WRITE) {
 		WARN_ON(1);
-		fn(1, context);
+		io_req->notify.fn(1, io_req->notify.context);
 		return -EIO;
 	}
 
-	io = mempool_alloc(client->pool, GFP_NOIO);
+	io = mempool_alloc(io_req->client->pool, GFP_NOIO);
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->sleeper = NULL;
-	io->client = client;
-	io->callback = fn;
-	io->context = context;
+	io->client = io_req->client;
+	io->callback = io_req->notify.fn;
+	io->context = io_req->notify.context;
 
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
-	dispatch_io(rw, num_regions, where, dp, io, 0);
+	dispatch_io(io_req, num_regions, where, dp, io, 0);
 	return 0;
 }
 
@@ -499,11 +510,10 @@ int dm_io(struct dm_io_request *io_req, unsigned num_regions,
 		return r;
 
 	if (!io_req->notify.fn)
-		return sync_io(io_req->client, num_regions, where,
-			       io_req->bi_rw, &dp, sync_error_bits);
+		return sync_io(io_req, num_regions, where,
+				&dp, sync_error_bits);
 
-	return async_io(io_req->client, num_regions, where, io_req->bi_rw,
-			&dp, io_req->notify.fn, io_req->notify.context);
+	return async_io(io_req, num_regions, where, &dp);
 }
 EXPORT_SYMBOL(dm_io);
 
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index bed444c..6a8ecc9 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -387,6 +387,7 @@ static int run_io_job(struct kcopyd_job *job)
 		.notify.fn = complete_io,
 		.notify.context = job,
 		.client = job->kc->io_client,
+		.submit_bio = 1,
 	};
 
 	if (job->rw == READ)
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 627d191..8425e84 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -463,6 +463,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 			kfree(lc);
 			return r;
 		}
+		lc->io_req.submit_bio = 1;
 
 		lc->disk_header = vmalloc(buf_size);
 		if (!lc->disk_header) {
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index bc5ddba..338d726 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -261,6 +261,7 @@ static int mirror_flush(struct dm_target *ti)
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
 		.client = ms->io_client,
+		.submit_bio = 1,
 	};
 
 	for (i = 0, m = ms->mirror; i < ms->nr_mirrors; i++, m++) {
@@ -530,6 +531,7 @@ static void read_async_bio(struct mirror *m, struct bio *bio)
 		.notify.fn = read_callback,
 		.notify.context = bio,
 		.client = m->ms->io_client,
+		.submit_bio = 1,
 	};
 
 	map_region(&io, m, bio);
@@ -633,6 +635,7 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 		.notify.fn = write_callback,
 		.notify.context = bio,
 		.client = ms->io_client,
+		.submit_bio = 1,
 	};
 
 	if (bio->bi_rw & REQ_DISCARD) {
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 3ac4156..0600e1d 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -241,6 +241,7 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw,
 		.mem.ptr.vma = area,
 		.client = ps->io_client,
 		.notify.fn = NULL,
+		.submit_bio = 1,
 	};
 	struct mdata_req req;
 
diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
index f4b0aa3..45f576b 100644
--- a/include/linux/dm-io.h
+++ b/include/linux/dm-io.h
@@ -61,6 +61,9 @@ struct dm_io_request {
 	struct dm_io_memory mem;	/* Memory to use for io */
 	struct dm_io_notify notify;	/* Synchronous if notify.fn is NULL */
 	struct dm_io_client *client;	/* Client memory handler */
+	int submit_bio;
+	struct bio *start;
+	struct bio *end;
 };
 
 /*
-- 
1.7.1

