Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2JPJV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:21:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab2JPJVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:21:54 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: axboe@kernel.dk
Cc: dchinner@redhat.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] loop: Limit the number of requests in the bio list
Date: Tue, 16 Oct 2012 11:21:45 +0200
Message-Id: <1350379305-13858-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is not limitation of number of requests in the loop bio
list. This can lead into some nasty situations when the caller spawns
tons of bio requests taking huge amount of memory. This is even more
obvious with discard where blkdev_issue_discard() will submit all bios
for the range and wait for them to finish afterwards. On really big loop
devices and slow backing file system this can lead to OOM situation as
reported by Dave Chinner.

With this patch we will wait in loop_make_request() if the number of
bios in the loop bio list would exceed 'nr_requests' number of requests.
We'll wake up the process as we process the bios form the list. Some
threshold hysteresis is in place to avoid high frequency oscillation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Dave Chinner <dchinner@redhat.com>
---
v2: add threshold hysteresis

 drivers/block/loop.c |   16 ++++++++++++++++
 include/linux/loop.h |    3 +++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index e9d594f..0589976 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -463,6 +463,7 @@ out:
  */
 static void loop_add_bio(struct loop_device *lo, struct bio *bio)
 {
+	lo->lo_bio_count++;
 	bio_list_add(&lo->lo_bio_list, bio);
 }
 
@@ -471,6 +472,7 @@ static void loop_add_bio(struct loop_device *lo, struct bio *bio)
  */
 static struct bio *loop_get_bio(struct loop_device *lo)
 {
+	lo->lo_bio_count--;
 	return bio_list_pop(&lo->lo_bio_list);
 }
 
@@ -489,6 +491,14 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
 		goto out;
 	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
 		goto out;
+	if (lo->lo_bio_count >= lo->lo_queue->nr_requests) {
+		unsigned int nr;
+		spin_unlock_irq(&lo->lo_lock);
+		nr = lo->lo_queue->nr_requests - (lo->lo_queue->nr_requests/8);
+		wait_event_interruptible(lo->lo_req_wait,
+					 lo->lo_bio_count < nr);
+		spin_lock_irq(&lo->lo_lock);
+	}
 	loop_add_bio(lo, old_bio);
 	wake_up(&lo->lo_event);
 	spin_unlock_irq(&lo->lo_lock);
@@ -532,6 +542,7 @@ static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
 static int loop_thread(void *data)
 {
 	struct loop_device *lo = data;
+	unsigned int nr;
 	struct bio *bio;
 
 	set_user_nice(current, -20);
@@ -546,6 +557,9 @@ static int loop_thread(void *data)
 			continue;
 		spin_lock_irq(&lo->lo_lock);
 		bio = loop_get_bio(lo);
+		nr = lo->lo_queue->nr_requests - (lo->lo_queue->nr_requests/8);
+		if (lo->lo_bio_count < nr)
+			wake_up(&lo->lo_req_wait);
 		spin_unlock_irq(&lo->lo_lock);
 
 		BUG_ON(!bio);
@@ -873,6 +887,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->transfer = transfer_none;
 	lo->ioctl = NULL;
 	lo->lo_sizelimit = 0;
+	lo->lo_bio_count = 0;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
@@ -1660,6 +1675,7 @@ static int loop_add(struct loop_device **l, int i)
 	lo->lo_number		= i;
 	lo->lo_thread		= NULL;
 	init_waitqueue_head(&lo->lo_event);
+	init_waitqueue_head(&lo->lo_req_wait);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i << part_shift;
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 9635116..4ba4789 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -57,10 +57,13 @@ struct loop_device {
 
 	spinlock_t		lo_lock;
 	struct bio_list		lo_bio_list;
+	unsigned int		lo_bio_count;
 	int			lo_state;
 	struct mutex		lo_ctl_mutex;
 	struct task_struct	*lo_thread;
 	wait_queue_head_t	lo_event;
+	/* wait queue for incoming requests */
+	wait_queue_head_t	lo_req_wait;
 
 	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
-- 
1.7.7.6

