Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1BRCkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:40:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:44784 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1BRCkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:40:35 -0500
Date: Fri, 18 Feb 2011 13:40:25 +1100
From: NeilBrown <neilb@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110218134025.2a2e5bbb@notabene.brown>
In-Reply-To: <20110217165906.GE9075@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
	<20110216155305.GC14653@redhat.com>
	<20110217113536.2bbf308e@notabene.brown>
	<20110217011029.GA6793@redhat.com>
	<20110217165501.47f3c26f@notabene.brown>
	<20110217165906.GE9075@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 11:59:06 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Feb 17, 2011 at 04:55:01PM +1100, NeilBrown wrote:
> > On Wed, 16 Feb 2011 20:10:29 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > So is it possible to keep the spinlock intact when md is calling up
> > > blk_cleanup_queue()?
> > > 
> > 
> > It would be possible, yes - but messy.  I would probably end up just making
> > ->queue_lock always point to __queue_lock, and then only take it at the
> > places where I call 'block' code which wants to test to see if it is
> > currently held (like the plugging routines).
> > 
> > The queue lock (and most of the request queue) is simply irrelevant for md.
> > I would prefer to get away from having to touch it at all...
> 
> If queue lock is mostly irrelevant for md, then why md should provide an
> external lock and not use queue's internal spin lock?

See other email - historical reasons mostly.

> 
> > 
> > I'll see how messy it would be to stop using it completely and it can just be
> > __queue_lock.
> > 
> > Though for me - it would be much easier if you just used __queue_lock .....
> 
> Ok, here is the simple patch which splits the queue lock and uses
> throtl_lock for throttling logic. I booted and it seems to be working.
> 
> Having said that, this now introduces the possibility of races for any
> services I take from request queue. I need to see if I need to take
> queue lock and that makes me little uncomfortable. 
> 
> I am using kblockd_workqueue to queue throtl work. Looks like I don't
> need queue lock for that. I am also using block tracing infrastructure
> and my understanding is that I don't need queue lock for that as well.
> 
> So if we do this change for performance reasons, it still makes sense
> but doing this change because md provided a q->queue_lock and took away that
> lock without notifying block layer hence we do this change, is still not
> the right reason, IMHO.

Well...I like that patch, as it makes my life easier....

But I agree that md is doing something wrong.  Now that ->queue_lock is
always initialised, it is wrong to leave it in a state where it not defined.

So maybe I'll apply this (after testing it a bit.  The only reason for taking
the lock queue_lock in a couple of places is to silence some warnings.

Thanks,
NeilBrown


diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 8a2f767..0ed7f6b 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -216,7 +216,6 @@ static int linear_run (mddev_t *mddev)
 
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
-	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 	conf = linear_conf(mddev, mddev->raid_disks);
 
 	if (!conf)
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 6d7ddf3..3a62d44 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -435,7 +435,6 @@ static int multipath_run (mddev_t *mddev)
 	 * bookkeeping area. [whatever we allocate in multipath_run(),
 	 * should be freed in multipath_stop()]
 	 */
-	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	conf = kzalloc(sizeof(multipath_conf_t), GFP_KERNEL);
 	mddev->private = conf;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 75671df..c0ac457 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -361,7 +361,6 @@ static int raid0_run(mddev_t *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
-	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a23ffa3..909282d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -593,7 +593,9 @@ static int flush_pending_writes(conf_t *conf)
 	if (conf->pending_bio_list.head) {
 		struct bio *bio;
 		bio = bio_list_get(&conf->pending_bio_list);
+		spin_lock(conf->mddev->queue->queue_lock);
 		blk_remove_plug(conf->mddev->queue);
+		spin_unlock(conf->mddev->queue->queue_lock);
 		spin_unlock_irq(&conf->device_lock);
 		/* flush any pending bitmap writes to
 		 * disk before proceeding w/ I/O */
@@ -959,7 +961,9 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		atomic_inc(&r1_bio->remaining);
 		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
+		spin_lock(mddev->queue->queue_lock);
 		blk_plug_device(mddev->queue);
+		spin_unlock(mddev->queue->queue_lock);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 	r1_bio_write_done(r1_bio, bio->bi_vcnt, behind_pages, behind_pages != NULL);
@@ -2021,7 +2025,6 @@ static int run(mddev_t *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	mddev->queue->queue_lock = &conf->device_lock;
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3b607b2..60e6cb1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -662,7 +662,9 @@ static int flush_pending_writes(conf_t *conf)
 	if (conf->pending_bio_list.head) {
 		struct bio *bio;
 		bio = bio_list_get(&conf->pending_bio_list);
+		spin_lock(conf->mddev->queue->queue_lock);
 		blk_remove_plug(conf->mddev->queue);
+		spin_unlock(conf->mddev->queue->queue_lock);
 		spin_unlock_irq(&conf->device_lock);
 		/* flush any pending bitmap writes to disk
 		 * before proceeding w/ I/O */
@@ -970,8 +972,10 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 
 		atomic_inc(&r10_bio->remaining);
 		spin_lock_irqsave(&conf->device_lock, flags);
+		spin_lock(mddev->queue->queue_lock);
 		bio_list_add(&conf->pending_bio_list, mbio);
 		blk_plug_device(mddev->queue);
+		spin_unlock(mddev->queue->queue_lock);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 
@@ -2304,8 +2308,6 @@ static int run(mddev_t *mddev)
 	if (!conf)
 		goto out;
 
-	mddev->queue->queue_lock = &conf->device_lock;
-
 	mddev->thread = conf->thread;
 	conf->thread = NULL;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7028128..78536fd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5204,7 +5204,6 @@ static int run(mddev_t *mddev)
 
 		mddev->queue->backing_dev_info.congested_data = mddev;
 		mddev->queue->backing_dev_info.congested_fn = raid5_congested;
-		mddev->queue->queue_lock = &conf->device_lock;
 		mddev->queue->unplug_fn = raid5_unplug_queue;
 
 		chunk_size = mddev->chunk_sectors << 9;

