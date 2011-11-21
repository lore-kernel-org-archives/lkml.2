Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1KUORz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:17:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:35992 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1KUORx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:17:53 -0500
Date: Mon, 21 Nov 2011 09:17:37 -0500
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [RFC] Evil elevator to test cache flushes
Message-ID: <20111121141737.GD22935@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4ECA5D8A.0016,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

We recently found some bugs in the btrfs cache flush code.  The
frustrating part was that I wasn't able to trigger these bugs by ripping
the plug out of my test box, no matter how many times I tried.

The problem is that you have to rip out the cord at just the right time,
and that's pretty hard to catch.  I've been meaning to make an elevator
or dm device or qemu hack to emulate a writeback cache for a while, and
so here we go.

A big part of this elevator is the bit that reboots the box in the
middle of servicing a cache flush (enabled via sysfs flag).  With
this on, I'm able to trigger the btrfs bug 100% of the time, and it
doesn't trigger corruptions with the btrfs bug fixed.  So far I haven't
seen corruptions in the other filesystems unless I turn barriers off,
but I've only tried a few runs.

I'm writing up a script to bash on things in a big reboot loop, so we
should be able to get a lot of crashes in very little time.

I owe Jens at least one change to this patch.  I made an elevator op to
process cache flushes, and Jens doesn't like the part where I made it
conditional (he wants a default operation given to the other elevators).

Other parts that should be unpopular include abusing elvpriv to make the
elevator switching code wait for my elevator to exit, and my code to
duplicate requests/bios.

I'm happy to include suggestions that make this elevator even more evil.

-chris

-------------------

block: add new barrier-test io scheduler

This elevator tries to simulate a drive with a non-battery backed
writeback cache.  Writes are completed immediately up to the caller
and a duplicate of the request is sent down to the storage after the
higher level has sent down a cache FLUSH operation.

This is only meant for debugging purposes, and it intentionally tries
to send down the IO in an inefficient order in hopes of catching
corner cases or bugs in the filesystem cache flush operations.

It also includes a sysfs file called random_reboot, which will
call emergency_reboot() while it is processing a cache flush.
It triggers the reboot only when a given flush is a fairly large
operation, and it waits until after it has written about half
the blocks.

When servicing a cache flush, it sends the IO down to disk in
reverse order.  This is assuming the FS writes the most important
blocks last, so reversing the order is going to confuse the FS the most.

This doesn't maintain an index of things in the writeback cache,
so any read operation triggers a full flush.  This could be fixed by
indexing the duplicate bios and servicing reads directly from the bios.

Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 3199b76..1bc1925 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -12,6 +12,14 @@ config IOSCHED_NOOP
 	  that do their own scheduling and require only minimal assistance from
 	  the kernel.
 
+config IOSCHED_BARRIER_TEST
+	tristate "Barrier testing I/O scheduler"
+	default n
+	---help---
+	  This is for testing purposes only.  It tries to simulate a worst case
+	  writeback cache that only properly flushes writes when barriers are
+	  done.  Say no here.
+
 config IOSCHED_DEADLINE
 	tristate "Deadline I/O scheduler"
 	default y
diff --git a/block/Makefile b/block/Makefile
index 514c6e4..216a007 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_BLK_DEV_THROTTLING)	+= blk-throttle.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
+obj-$(CONFIG_IOSCHED_BARRIER_TEST)	+= barrier-test-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
diff --git a/block/barrier-test-iosched.c b/block/barrier-test-iosched.c
new file mode 100644
index 0000000..f6415378
--- /dev/null
+++ b/block/barrier-test-iosched.c
@@ -0,0 +1,684 @@
+/*
+ * elevator barrier-test
+ *
+ * This elevator is meant to test filesystem barrier
+ * flushing code.  It pretends to do writes and immediately returns
+ * success.  Writes are only sent down when a barrier is done
+ * by the filesystem.
+ */
+#include <linux/blkdev.h>
+#include <linux/elevator.h>
+#include <linux/bio.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/reboot.h>
+#include "blk.h"
+
+/* this is how many ios we'll lie about at once */
+#define NR_SPARE_REQUESTS 4096
+#define MAX_IOVECS 1
+
+struct barrier_test_data {
+	struct request_queue *q;
+
+	/* the queue is what we send down to the device */
+	struct list_head queue;
+
+	/*
+	 * the writeback queue are the requests we've pretended are done.
+	 * We have made private copies of all of these and placed the
+	 * copy into the delayed_requests list below.  The writeback_requests
+	 * will be completed immediately when dispatch is called.
+	 */
+	struct list_head writeback_requests;
+
+	/*
+	 * these are the copies requests that we've pretended we've done.  They
+	 * must be sent down when we get a barrier or when the queue is
+	 * being shutdown, or when we've queued up a bunch of them.
+	 */
+	struct list_head delayed_requests;
+
+	/*
+	 * reads may read sectors that are stuck in delayed_requests.  To avoid
+	 * this, we just force all the delayed stuff out before the reads can
+	 * continue
+	 */
+	struct list_head reads_waiting_flush;
+
+	/* each barrier we get ends up here.  In practice there's only one, but
+	 * everything else is a list...
+	 */
+	struct list_head barrier_requests;
+
+	/*
+	 * this is our array of preallocated requests that we use to lie
+	 * about ios.  When a new write comes in, we copy it into a spare
+	 * request and immediately complete the original
+	 */
+	struct list_head spare_requests;
+
+	/* when we lie about ios, we copy the pages first */
+	struct list_head spare_pages;
+
+	/* when we lie about ios, we copy the bios first */
+	struct bio_list spare_bios;
+
+	/*
+	 * we maintain a count of delayed_requests so we know when it is safe
+	 * to let a barrier proceed.
+	 */
+	atomic_t pending_rqs;
+
+	/* this is for waiting until prending_rqs is zero */
+	wait_queue_head_t pending_rq_wait;
+
+	int random_reboot;
+	int total_barriers;
+};
+
+typedef void (rq_end_io_fn)(struct request *, int);
+
+/*
+ * wb_requests are ones that we are pretending are done.  We
+ * just return completion right away to the poor user.
+ */
+static int end_all_wb_reqs(struct barrier_test_data *nd)
+{
+	struct request *rq;
+	int ret = 0;
+
+	while(!list_empty(&nd->writeback_requests)) {
+		rq = list_entry(nd->writeback_requests.next, struct request,
+				queuelist);
+		list_del_init(&rq->queuelist);
+		__blk_end_request_all(rq, 0);
+		ret = 1;
+	}
+	return ret;
+}
+
+/*
+ * endio function so we can reclaim the bios on our
+ * copied requests.  This also reclaims the pages.  It
+ * should be called with the queue lock held.
+ */
+static void barrier_bio_endio(struct bio *bio, int err)
+{
+	struct barrier_test_data *nd;
+	struct page *page;
+
+	nd = bio->bi_private;
+
+	/* the queue lock seems to be held here? */
+	bio_list_add(&nd->spare_bios, bio);
+	page = bio->bi_io_vec[0].bv_page;
+	list_add(&page->lru, &nd->spare_pages);
+}
+
+/*
+ * once the number of delayed requests goes down to zero,
+ * we can safely run the actual barrier.
+ */
+static void run_all_barriers(struct barrier_test_data *nd)
+{
+	struct request *rq;
+	while(!list_empty(&nd->barrier_requests)) {
+		rq = list_entry(nd->barrier_requests.next,
+				struct request, queuelist);
+		list_del_init(&rq->queuelist);
+
+		blk_insert_flush(rq);
+	}
+}
+
+/*
+ * request end_io function to reclaim the request struct
+ * we copied the writeback IO to.  This is called with the queue
+ * lock held.
+ */
+static void barrier_test_end_io_fn(struct request *rq, int err)
+{
+	struct request_queue *q;
+	struct barrier_test_data *nd;
+	int pending_empty;
+
+	q = rq->q;
+	nd = q->elevator->elevator_data;
+
+	list_add(&rq->queuelist, &nd->spare_requests);
+
+	/* if there are no more pending requests, we can
+	 * service any reads or barriers we've been asked to do
+	 */
+	pending_empty = atomic_dec_and_test(&nd->pending_rqs);
+
+	if (pending_empty && !list_empty(&nd->reads_waiting_flush)) {
+		list_splice_tail_init(&nd->reads_waiting_flush, &nd->queue);
+		blk_run_queue_async(q);
+	}
+
+	if (pending_empty && !list_empty(&nd->barrier_requests))
+		run_all_barriers(nd);
+
+	/*
+	 * we abuse elvpriv to make sure the elevator doesn't switch away
+	 * while we still have delayed requests in flight
+	 */
+	nd->q->rq.elvpriv--;
+	wake_up(&nd->pending_rq_wait);
+}
+
+static void barrier_test_merged_requests(struct request_queue *q, struct request *rq,
+				 struct request *next)
+{
+	list_del_init(&next->queuelist);
+}
+
+/*
+ * Copy attributes of the original request to the clone request.
+ * The actual data parts (e.g. ->cmd, ->buffer, ->sense) are not copied.
+ */
+static void __blk_rq_prep_clone(struct request *dst, struct request *src)
+{
+	dst->cpu = src->cpu;
+	dst->cmd_flags = (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
+	dst->cmd_type = src->cmd_type;
+	dst->__sector = blk_rq_pos(src);
+	dst->__data_len = blk_rq_bytes(src);
+	dst->nr_phys_segments = src->nr_phys_segments;
+	dst->ioprio = src->ioprio;
+	dst->extra_len = src->extra_len;
+}
+
+/*
+ * we don't delay requests if they are reads, or
+ * if they are FUAs/flushes, or they are reads, or
+ * if they are bigger than one bio, or if the bio
+ * has more than one page, or if the bio is empty.
+ */
+static int can_delay_request(struct request *rq)
+{
+	if (!(rq->cmd_flags & REQ_WRITE))
+		return 0;
+	if (rq->cmd_flags & (REQ_DISCARD | REQ_FLUSH | REQ_FUA))
+		return 0;
+	if (rq->bio != rq->biotail)
+		return 0;
+	if (rq->bio->bi_vcnt != 1)
+		return 0;
+	if (!bio_has_data(rq->bio))
+		return 0;
+	return 1;
+}
+
+/*
+ * bio clone that doesn't try to memcpy the iovec array
+ */
+void clone_one_bio(struct bio *bio, struct bio *bio_src)
+{
+	bio->bi_sector = bio_src->bi_sector;
+	bio->bi_bdev = bio_src->bi_bdev;
+	bio->bi_flags |= 1 << BIO_CLONED;
+	bio->bi_rw = bio_src->bi_rw;
+	bio->bi_vcnt = bio_src->bi_vcnt;
+	bio->bi_size = bio_src->bi_size;
+	bio->bi_idx = bio_src->bi_idx;
+}
+
+/*
+ * this pulls a spare bio, request and page out and copies the source
+ * request into them.  It returns the resulting request, or NULL if
+ * we couldn't do the copy.
+ */
+noinline static struct request *copy_one_request(struct request_queue *q,
+				       struct barrier_test_data *nd,
+				       struct request *rq_orig)
+{
+	struct request *rq = NULL;
+	struct bio *bio;
+	struct bio *src_bio;
+	struct page *page;
+	char *src_page;
+	char *dst_page;
+
+	if (list_empty(&nd->spare_requests))
+		goto fail_enomem;
+	if (bio_list_empty(&nd->spare_bios))
+		goto fail_enomem;
+	if (list_empty(&nd->spare_pages))
+		goto fail_enomem;
+
+	rq = list_entry(nd->spare_requests.next, struct request, queuelist);
+	list_del_init(&rq->queuelist);
+
+	blk_rq_init(q, rq);
+	__blk_rq_prep_clone(rq, rq_orig);
+
+	rq->ref_count++;
+	bio = bio_list_pop(&nd->spare_bios);
+
+	src_bio = rq_orig->bio;
+
+	page = list_entry(nd->spare_pages.next, struct page, lru);
+	list_del_init(&page->lru);
+
+	bio_get(bio);
+	clone_one_bio(bio, src_bio);
+	rq->bio = bio;
+	rq->biotail = bio;
+
+	/*
+	 * now we have a bio and a request, but our copy is still pointing to
+	 * the original.  Copy the page from the bio into our page here.
+	 */
+	src_page = kmap_atomic(src_bio->bi_io_vec[0].bv_page, KM_SOFTIRQ0);
+	dst_page = kmap_atomic(page, KM_SOFTIRQ1);
+	memcpy(dst_page, src_page, PAGE_CACHE_SIZE);
+	kunmap_atomic(src_page);
+	kunmap_atomic(dst_page);
+
+	/* and update our bio to include the correct page */
+	page_cache_get(page);
+	bio->bi_io_vec[0].bv_page = page;
+	bio->bi_io_vec[0].bv_offset = src_bio->bi_io_vec[0].bv_offset;
+	bio->bi_io_vec[0].bv_len = src_bio->bi_io_vec[0].bv_len;
+
+	/* make sure the request points to the new bio */
+	rq->buffer = bio_data(bio);
+	rq->nr_phys_segments = bio_phys_segments(q, bio);
+
+	atomic_inc(&nd->pending_rqs);
+
+	/*
+	 * bump the elvpriv so the elevator can't switch until our
+	 * end IO function allows it.  Our endio code needs q->elevator
+	 * to stay on the barrier elevator until all requests are done
+	 */
+	q->rq.elvpriv++;
+
+	rq->end_io = barrier_test_end_io_fn;
+	bio->bi_end_io = barrier_bio_endio;
+	bio->bi_private = nd;
+
+fail_enomem:
+	return rq;
+}
+
+/*
+ * when we actually move our requests off the delayed list,
+ * we dispatch it ourselves to increases the chances the
+ * drive will do the IO sooner (and out of order).
+ */
+static int __dispatch(struct request_queue *q)
+{
+	struct barrier_test_data *nd = q->elevator->elevator_data;
+	if (!list_empty(&nd->queue)) {
+		struct request *rq;
+		rq = list_entry(nd->queue.next, struct request, queuelist);
+		list_del_init(&rq->queuelist);
+		elv_dispatch_sort(q, rq);
+		return 1;
+	}
+	return 0;
+}
+
+static void queue_all_delayed(struct barrier_test_data *nd, int for_barrier)
+{
+	int nr = 0;
+	struct request *rq;
+	int orig_delayed_nr = atomic_read(&nd->pending_rqs);
+
+	/* a good scheduler would queue these in order.  But we're not
+	 * good, we're evil.  Queue them up in a horrible
+	 * order in hopes of getting the drive to do something bad
+	 *
+	 * note we're walking the list of delayed requests in reverse
+	 * order, just to be extra mean.
+	 */
+	while(!list_empty(&nd->delayed_requests)) {
+		rq = list_entry(nd->delayed_requests.prev,
+				struct request, queuelist);
+		list_del_init(&rq->queuelist);
+		if (nr % 2)
+			list_add(&rq->queuelist, &nd->queue);
+		else
+			list_add_tail(&rq->queuelist, &nd->queue);
+		nr++;
+
+		/*
+		 * dispatch all of these requests
+		 * FIXME, is this required or is the __blk_run_queue enough
+		 */
+		while(__dispatch(nd->q));
+
+		/* kick the drive */
+		__blk_run_queue(nd->q);
+
+		/*
+		 * maybe reboot the box!  We only reboot if we've been able
+		 * to queue up a good chunk of ios, and after we've written
+		 * some
+		 */
+		if (for_barrier && orig_delayed_nr > 256 &&
+		    nr == 256 && nd->random_reboot) {
+			printk(KERN_CRIT "doing random crash before barrier submit\n");
+			emergency_restart();
+		}
+	}
+}
+
+/*
+ * when the elevator is shutting down, we switch to write-through
+ */
+static int must_not_delay_requests(struct request_queue *q)
+{
+	if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+	    test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags)) {
+		return 1;
+	}
+	return 0;
+}
+
+static int barrier_test_dispatch(struct request_queue *q, int force)
+{
+	struct barrier_test_data *nd = q->elevator->elevator_data;
+	int must_not_delay;
+	int ret;
+
+	must_not_delay = must_not_delay_requests(q);
+	if (must_not_delay)
+		queue_all_delayed(nd, 0);
+
+	/*
+	 * we don't do the writeback requests until the dispatch,
+	 * the elevator code seems to get confused when requests
+	 * end during the add_request function
+	 */
+	end_all_wb_reqs(nd);
+
+	ret = __dispatch(q);
+	if (!ret && must_not_delay) {
+		/*
+		 * must_not_delay means the elevator is shutting down.
+		 * make sure to kick the queue so our delayed_requests
+		 * actually get to disk
+		 */
+		blk_run_queue_async(q);
+	}
+	return ret;
+}
+
+/*
+ * we have to pull the writeback requests off the hashes, since they
+ * never get properly dispatched.
+ */
+static void __elv_rqhash_del(struct request_queue *q, struct request *rq)
+{
+        if (ELV_ON_HASH(rq))
+		hlist_del_init(&rq->hash);
+}
+
+static void barrier_test_add_request(struct request_queue *q, struct request *rq)
+{
+	struct barrier_test_data *nd = q->elevator->elevator_data;
+	struct request *copy;
+
+	/*
+	 * reads only happen after all the writeback io is complete.
+	 */
+	if (!(rq->cmd_flags & REQ_WRITE)) {
+		if (atomic_read(&nd->pending_rqs)) {
+			queue_all_delayed(nd, 0);
+			list_add_tail(&rq->queuelist, &nd->reads_waiting_flush);
+		} else {
+			list_add_tail(&rq->queuelist, &nd->queue);
+		}
+		return;
+	}
+
+	/*
+	 * if we're waiting for a barrier or a read or the request
+	 * can't be done as writeback, don't delay it
+	 */
+	if (!list_empty(&nd->barrier_requests) ||
+	    !list_empty(&nd->reads_waiting_flush) ||
+	    must_not_delay_requests(q) ||
+	    !can_delay_request(rq)) {
+		list_add_tail(&rq->queuelist, &nd->queue);
+		return;
+	}
+
+	/* try to make our copy and queue it up as a writeback request */
+	copy = copy_one_request(q, nd, rq);
+	if (!copy) {
+		/* we've run out of delayed requests, force them down */
+		list_add_tail(&rq->queuelist, &nd->queue);
+		queue_all_delayed(nd, 0);
+		return;
+	}
+
+	/* the original must be removed from the hash lists */
+	__elv_rqhash_del(q, rq);
+	if (rq->cmd_flags & REQ_SORTED) {
+		copy->cmd_flags |= REQ_SORTED;
+		rq->cmd_flags &= ~REQ_SORTED;
+	}
+
+	/*
+	 * end the original request immediately when dispatch is called.
+	 * elevator.c gets upset if it ends during add_request
+	 */
+	list_add_tail(&rq->queuelist, &nd->writeback_requests);
+
+	/* add our copy to the delayed_requests list */
+	list_add_tail(&copy->queuelist, &nd->delayed_requests);
+
+	/* if we're depleting our list of spares, start the writeback IO */
+	if (atomic_read(&nd->pending_rqs) > (NR_SPARE_REQUESTS / 2))
+		queue_all_delayed(nd, 0);
+}
+
+/*
+ * queue up a cache flush.  If we don't have any writebacks, just do the flush
+ * right away.  If we do have anything in the delayed_request list, we're
+ * only allowed to flush after all of the delayed IO is complete.
+ */
+static void barrier_test_add_flush(struct request_queue *q, struct request *rq)
+{
+	struct barrier_test_data *nd = q->elevator->elevator_data;
+
+	nd->total_barriers++;
+	if (atomic_read(&nd->pending_rqs)) {
+		queue_all_delayed(nd, 1);
+		list_add_tail(&rq->queuelist, &nd->barrier_requests);
+		blk_run_queue_async(q);
+	} else {
+		blk_insert_flush(rq);
+	}
+}
+
+static void free_all_spare_structs(struct barrier_test_data *nd)
+{
+	struct bio *bio;
+	struct page *page;
+	struct request *rq;
+
+	while (!list_empty(&nd->spare_requests)) {
+		rq = list_entry(nd->spare_requests.next,
+				struct request, queuelist);
+		list_del_init(&rq->queuelist);
+		mempool_free(rq, rq->q->rq.rq_pool);
+	}
+
+	while (!bio_list_empty(&nd->spare_bios)) {
+		bio = bio_list_pop(&nd->spare_bios);
+		bio_put(bio);
+	}
+
+	while (!list_empty(&nd->spare_pages)) {
+		page = list_entry(nd->spare_pages.next, struct page, lru);
+		list_del_init(&page->lru);
+		put_page(page);
+	}
+}
+
+static void *barrier_test_init_queue(struct request_queue *q)
+{
+	struct barrier_test_data *nd;
+	struct request *rq;
+	struct bio *bio;
+	struct page *page;
+	int i;
+
+	nd = kmalloc_node(sizeof(*nd), GFP_KERNEL, q->node);
+	if (!nd)
+		return NULL;
+	INIT_LIST_HEAD(&nd->queue);
+	INIT_LIST_HEAD(&nd->writeback_requests);
+	INIT_LIST_HEAD(&nd->spare_requests);
+	INIT_LIST_HEAD(&nd->delayed_requests);
+	INIT_LIST_HEAD(&nd->barrier_requests);
+	INIT_LIST_HEAD(&nd->spare_pages);
+	INIT_LIST_HEAD(&nd->reads_waiting_flush);
+
+	init_waitqueue_head(&nd->pending_rq_wait);
+	atomic_set(&nd->pending_rqs, 0);
+	bio_list_init(&nd->spare_bios);
+	nd->random_reboot = 0;
+	nd->total_barriers = 0;
+
+	for (i = 0; i < NR_SPARE_REQUESTS; i++) {
+		rq = mempool_alloc(q->rq.rq_pool, GFP_NOIO);
+
+		if (!rq)
+			goto fail;
+
+		rq->q = q;
+		list_add(&rq->queuelist, &nd->spare_requests);
+
+		bio = bio_kmalloc(GFP_NOIO, MAX_IOVECS);
+		if (!bio)
+			goto fail;
+
+		bio_list_add(&nd->spare_bios, bio);
+
+		page = alloc_page(GFP_NOIO);
+		if (!page)
+			goto fail;
+		list_add(&page->lru, &nd->spare_pages);
+	}
+
+	set_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags);
+	nd->q = q;
+	return nd;
+fail:
+
+	free_all_spare_structs(nd);
+	kfree(nd);
+	return NULL;
+}
+
+static void barrier_test_exit_queue(struct elevator_queue *e)
+{
+	struct barrier_test_data *nd = e->elevator_data;
+
+	wait_event(nd->pending_rq_wait, atomic_read(&nd->pending_rqs) == 0);
+	free_all_spare_structs(nd);
+	BUG_ON(!list_empty(&nd->queue));
+	kfree(nd);
+}
+
+/*
+ * sysfs parts below
+ */
+
+static ssize_t
+barrier_test_var_show(int var, char *page)
+{
+	return sprintf(page, "%d\n", var);
+}
+
+static ssize_t
+barrier_test_var_store(int *var, const char *page, size_t count)
+{
+	char *p = (char *) page;
+
+	*var = simple_strtol(p, &p, 10);
+	return count;
+}
+
+#define SHOW_FUNCTION(__FUNC, __VAR, __CONV)				\
+static ssize_t __FUNC(struct elevator_queue *e, char *page)		\
+{									\
+	struct barrier_test_data *dd = e->elevator_data;		\
+	int __data = __VAR;						\
+	if (__CONV)							\
+		__data = jiffies_to_msecs(__data);			\
+	return barrier_test_var_show(__data, (page));			\
+}
+SHOW_FUNCTION(barrier_test_random_reboot_show, dd->random_reboot, 0);
+#undef SHOW_FUNCTION
+
+#define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
+static ssize_t __FUNC(struct elevator_queue *e, const char *page, size_t count)	\
+{									\
+	struct barrier_test_data *dd = e->elevator_data;			\
+	int __data;							\
+	int ret = barrier_test_var_store(&__data, (page), count);		\
+	if (__data < (MIN))						\
+		__data = (MIN);						\
+	else if (__data > (MAX))					\
+		__data = (MAX);						\
+	if (__CONV)							\
+		*(__PTR) = msecs_to_jiffies(__data);			\
+	else								\
+		*(__PTR) = __data;					\
+	return ret;							\
+}
+STORE_FUNCTION(barrier_test_random_reboot_store, &dd->random_reboot, 0, 1, 0);
+#undef STORE_FUNCTION
+
+#define BT_ATTR(name) \
+	__ATTR(name, S_IRUGO|S_IWUSR, barrier_test_##name##_show, \
+				      barrier_test_##name##_store)
+
+static struct elv_fs_entry barrier_test_attrs[] = {
+	BT_ATTR(random_reboot),
+	__ATTR_NULL
+};
+
+
+static struct elevator_type elevator_barrier_test = {
+	.ops = {
+		.elevator_merge_req_fn		= barrier_test_merged_requests,
+		.elevator_dispatch_fn		= barrier_test_dispatch,
+		.elevator_add_req_fn		= barrier_test_add_request,
+		.elevator_add_flush_fn		= barrier_test_add_flush,
+		.elevator_init_fn		= barrier_test_init_queue,
+		.elevator_exit_fn		= barrier_test_exit_queue,
+	},
+	.elevator_attrs = barrier_test_attrs,
+	.elevator_name = "barrier-test",
+	.elevator_owner = THIS_MODULE,
+};
+
+static int __init barrier_test_init(void)
+{
+	elv_register(&elevator_barrier_test);
+	return 0;
+}
+
+static void __exit barrier_test_exit(void)
+{
+	elv_unregister(&elevator_barrier_test);
+}
+
+module_init(barrier_test_init);
+module_exit(barrier_test_exit);
+
+
+MODULE_AUTHOR("Chris Mason");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Barrier-testing IO scheduler");
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 491eb30..16004ba 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -346,6 +346,7 @@ void blk_insert_flush(struct request *rq)
 
 	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
 }
+EXPORT_SYMBOL(blk_insert_flush);
 
 /**
  * blk_abort_flushes - @q is being aborted, abort flush requests
diff --git a/block/elevator.c b/block/elevator.c
index a3b64bc..316719c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -716,7 +716,10 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 
 	case ELEVATOR_INSERT_FLUSH:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
-		blk_insert_flush(rq);
+		if (q->elevator->ops->elevator_add_flush_fn)
+			q->elevator->ops->elevator_add_flush_fn(q, rq);
+		else
+			blk_insert_flush(rq);
 		break;
 	default:
 		printk(KERN_ERR "%s: bad insertion point %d\n",
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index d800d51..9c3f667 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -42,6 +42,7 @@ struct elevator_ops
 
 	elevator_dispatch_fn *elevator_dispatch_fn;
 	elevator_add_req_fn *elevator_add_req_fn;
+	elevator_add_req_fn *elevator_add_flush_fn;
 	elevator_activate_req_fn *elevator_activate_req_fn;
 	elevator_deactivate_req_fn *elevator_deactivate_req_fn;
 
