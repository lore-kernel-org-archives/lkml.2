Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab2KVWWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:22:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab2KVSiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:10 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        akpm@linux-foundation.org, Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2 v5] loop: Limit the number of requests in the bio list
Date: Thu, 22 Nov 2012 09:18:35 +0100
Message-Id: <1353572315-4508-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1353572315-4508-1-git-send-email-lczerner@redhat.com>
References: <1353572315-4508-1-git-send-email-lczerner@redhat.com>
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
bios in the loop bio list would exceed 'nr_congestion_on'.
We'll wake up the process as we process the bios form the list. Some
threshold hysteresis is in place to avoid high frequency oscillation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Dave Chinner <dchinner@redhat.com>
---
v2: add threshold hysteresis
v3: Wait uninterruptible, use nr_congestion_off/on
v4: use wait_event_lock_irq()
v5: no change

 drivers/block/loop.c |   10 ++++++++++
 include/linux/loop.h |    3 +++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 54046e5..ae12512 100644
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
 
@@ -489,6 +491,10 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
 		goto out;
 	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
 		goto out;
+	if (lo->lo_bio_count >= q->nr_congestion_on)
+		wait_event_lock_irq(lo->lo_req_wait,
+				    lo->lo_bio_count < q->nr_congestion_off,
+				    lo->lo_lock);
 	loop_add_bio(lo, old_bio);
 	wake_up(&lo->lo_event);
 	spin_unlock_irq(&lo->lo_lock);
@@ -546,6 +552,8 @@ static int loop_thread(void *data)
 			continue;
 		spin_lock_irq(&lo->lo_lock);
 		bio = loop_get_bio(lo);
+		if (lo->lo_bio_count < lo->lo_queue->nr_congestion_off)
+			wake_up(&lo->lo_req_wait);
 		spin_unlock_irq(&lo->lo_lock);
 
 		BUG_ON(!bio);
@@ -873,6 +881,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->transfer = transfer_none;
 	lo->ioctl = NULL;
 	lo->lo_sizelimit = 0;
+	lo->lo_bio_count = 0;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
@@ -1673,6 +1682,7 @@ static int loop_add(struct loop_device **l, int i)
 	lo->lo_number		= i;
 	lo->lo_thread		= NULL;
 	init_waitqueue_head(&lo->lo_event);
+	init_waitqueue_head(&lo->lo_req_wait);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i << part_shift;
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 6492181..460b60f 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -53,10 +53,13 @@ struct loop_device {
 
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

