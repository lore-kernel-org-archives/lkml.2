Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab1CEBPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:15:32 -0500
Received: from kroah.org ([198.145.64.141]:50217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148Ab1CEBAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005636.923246161@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [24/73] md: avoid spinlock problem in blk_throtl_exit
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit da9cf5050a2e3dbc3cf26a8d908482eb4485ed49 upstream.

blk_throtl_exit assumes that ->queue_lock still exists,
so make sure that it does.
To do this, we stop redirecting ->queue_lock to conf->device_lock
and leave it pointing where it is initialised - __queue_lock.

As the blk_plug functions check the ->queue_lock is held, we now
take that spin_lock explicitly around the plug functions.  We don't
need the locking, just the warning removal.

This is needed for any kernel with the blk_throtl code, which is
which is 2.6.37 and later.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/linear.c    |    1 -
 drivers/md/multipath.c |    1 -
 drivers/md/raid0.c     |    1 -
 drivers/md/raid1.c     |    6 ++++--
 drivers/md/raid10.c    |    7 ++++---
 drivers/md/raid5.c     |    1 -
 6 files changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -216,7 +216,6 @@ static int linear_run (mddev_t *mddev)
 
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
-	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 	conf = linear_conf(mddev, mddev->raid_disks);
 
 	if (!conf)
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -435,7 +435,6 @@ static int multipath_run (mddev_t *mddev
 	 * bookkeeping area. [whatever we allocate in multipath_run(),
 	 * should be freed in multipath_stop()]
 	 */
-	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	conf = kzalloc(sizeof(multipath_conf_t), GFP_KERNEL);
 	mddev->private = conf;
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -353,7 +353,6 @@ static int raid0_run(mddev_t *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
-	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -593,7 +593,10 @@ static int flush_pending_writes(conf_t *
 	if (conf->pending_bio_list.head) {
 		struct bio *bio;
 		bio = bio_list_get(&conf->pending_bio_list);
+		/* Only take the spinlock to quiet a warning */
+		spin_lock(conf->mddev->queue->queue_lock);
 		blk_remove_plug(conf->mddev->queue);
+		spin_unlock(conf->mddev->queue->queue_lock);
 		spin_unlock_irq(&conf->device_lock);
 		/* flush any pending bitmap writes to
 		 * disk before proceeding w/ I/O */
@@ -959,7 +962,7 @@ static int make_request(mddev_t *mddev,
 		atomic_inc(&r1_bio->remaining);
 		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
-		blk_plug_device(mddev->queue);
+		blk_plug_device_unlocked(mddev->queue);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 	r1_bio_write_done(r1_bio, bio->bi_vcnt, behind_pages, behind_pages != NULL);
@@ -2024,7 +2027,6 @@ static int run(mddev_t *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	mddev->queue->queue_lock = &conf->device_lock;
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -662,7 +662,10 @@ static int flush_pending_writes(conf_t *
 	if (conf->pending_bio_list.head) {
 		struct bio *bio;
 		bio = bio_list_get(&conf->pending_bio_list);
+		/* Spinlock only taken to quiet a warning */
+		spin_lock(conf->mddev->queue->queue_lock);
 		blk_remove_plug(conf->mddev->queue);
+		spin_unlock(conf->mddev->queue->queue_lock);
 		spin_unlock_irq(&conf->device_lock);
 		/* flush any pending bitmap writes to disk
 		 * before proceeding w/ I/O */
@@ -971,7 +974,7 @@ static int make_request(mddev_t *mddev,
 		atomic_inc(&r10_bio->remaining);
 		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
-		blk_plug_device(mddev->queue);
+		blk_plug_device_unlocked(mddev->queue);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 
@@ -2303,8 +2306,6 @@ static int run(mddev_t *mddev)
 	if (!conf)
 		goto out;
 
-	mddev->queue->queue_lock = &conf->device_lock;
-
 	mddev->thread = conf->thread;
 	conf->thread = NULL;
 
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5205,7 +5205,6 @@ static int run(mddev_t *mddev)
 
 		mddev->queue->backing_dev_info.congested_data = mddev;
 		mddev->queue->backing_dev_info.congested_fn = raid5_congested;
-		mddev->queue->queue_lock = &conf->device_lock;
 		mddev->queue->unplug_fn = raid5_unplug_queue;
 
 		chunk_size = mddev->chunk_sectors << 9;


