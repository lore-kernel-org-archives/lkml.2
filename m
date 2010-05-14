Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab0ENOJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:09:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab0ENOJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:09:06 -0400
Date: Fri, 14 May 2010 10:08:52 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Alasdair Kergon <agk@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Message-ID: <20100514140852.GA10373@redhat.com>
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
 <1273532139-23043-2-git-send-email-snitzer@redhat.com>
 <4BE8DBB0.5060701@ct.jp.nec.com>
 <20100511131502.GA25211@redhat.com>
 <4BEA659F.9050206@ct.jp.nec.com>
 <20100513035750.GA25523@redhat.com>
 <4BED049C.5040409@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BED049C.5040409@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14 2010 at  4:06am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 05/13/2010 12:57 PM +0900, Mike Snitzer wrote:
> > On Wed, May 12 2010 at  4:23am -0400,
> > Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> > 
> >> Hi Mike,
> >>
> >> On 05/11/2010 10:15 PM +0900, Mike Snitzer wrote:
> >>> It is clear we need to resolve the current full request_queue
> >>> initialization that occurs even for bio-based DM devices.
> >>>
> >>> I believe the 2 patches I posted accomplish this in a stright-forward
> >>> way.  We can always improve on it (by looking at what you proposed
> >>> below) but we need a minimlaist fix that doesn't depend on userspace
> >>> LVM2 changes right now.
> >> Humm, OK.
> >> Indeed, showing iosched directory in bio-based device's sysfs is
> >> confusing users actually, and we need something to resolve that soon.
> >> So I don't strongly object to your approach as the first step, as long
> >> as we can accept the risk of the maintenance cost which I mentioned.
> > 
> > OK, I understand your concern (especially after having gone through this
> > further over the past couple days).  I'm hopeful maintenance will be
> > minimal.
> > 
> >> By the way, your current patch has a problem below.
> >> It needs to be fixed at least.
> > 
> > Thanks for the review.  I've addressed both your points with additional
> > changes (split between 2 patches).
> 
> I found another bug; blk_init_allocated_queue() overwrites q->unplug_fn
> with generic one. (Although it's currently harmless for multipath target.)

Thanks again for your review!

Here is a simple incremental fix:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5390754..985dd9c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1854,6 +1854,17 @@ static const struct block_device_operations dm_blk_dops;
 static void dm_wq_work(struct work_struct *work);
 static void dm_rq_barrier_work(struct work_struct *work);
 
+static void dm_init_md_queue(struct mapped_device *md)
+{
+	md->queue->queuedata = md;
+	md->queue->backing_dev_info.congested_fn = dm_any_congested;
+	md->queue->backing_dev_info.congested_data = md;
+	blk_queue_make_request(md->queue, dm_request);
+	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
+	md->queue->unplug_fn = dm_unplug_all;
+	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
+}
+
 /*
  * Allocate and initialise a blank device with a given minor.
  */
@@ -1895,13 +1906,7 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->queue)
 		goto bad_queue;
 
-	md->queue->queuedata = md;
-	md->queue->backing_dev_info.congested_fn = dm_any_congested;
-	md->queue->backing_dev_info.congested_data = md;
-	blk_queue_make_request(md->queue, dm_request);
-	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
-	md->queue->unplug_fn = dm_unplug_all;
-	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
+	dm_init_md_queue(md);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
@@ -1974,7 +1979,7 @@ int dm_init_request_based_queue(struct mapped_device *md)
 			return 0;
 		md->queue = q;
 		md->saved_make_request_fn = md->queue->make_request_fn;
-		blk_queue_make_request(md->queue, dm_request);
+		dm_init_md_queue(md);
 		register_elevator = 1;
 	} else if (dm_bio_based_md(md)) {
 		/*

> I feel your patch-set is growing and becoming complex fix rather than
> minimalist/simple fix.

Seems the numerous patches I've posted over the past couple days have
given a false impression.  But I do understand your concern.

The longer-term direction you want to take DM (known type during
alloc_dev) illustrates that we share a common goal: only do the precise
work that is needed to initialize the request_queue for a DM device
(whether it is bio-based or request-based).

My changes do accomplish that in the near-term without requiring
userspace change.  Many of my proposed changes are just refactoring
existing code to clearly split out what is needed for request-based vs
bio-based.

I'll post a single patch that contains my changes (no need to have 2
patches any more).  With that patch I'm hopeful you'll see my changes
aren't as complex as they might have seemed over the past few days.

> I think touching mapped_device/queue at table loading time makes
> things complex.  It is natural that table's arguments are reflected
> to mapped_device/queue at table binding time instead.
> 
> > I confirmed with Alasdair that we don't want to conditionally relax DM's
> > allocation constraints for request-based DM.  Best to be consistent
> > about not allowing allocations during resume.
> 
> OK.
> Then, how about the patch below?
> It still fully initializes queue at device creation time for both
> bio-based and request-based.  Then, it drops elevator when the device
> type is decided as bio-based at table binding time.
> So no memory allocation during resume (freeing instead).

I'm inclined to believe that the extra work for bio-based DM is not
ideal.  And even freeing during resume _could_ pose a problem during a
resume (if it triggers unknown additional housekeeping).
elv_unregister_queue() and elevator_exit() do quite a bit more than
simply freeing memory.  We can't safely assume those methods will never
allocate memory to accomplish their cleanup (now or in the future).

> I hope this simple work-around approach is acceptable for you and
> Alasdair (and others).

While it is certainly a small change it carries with it the disadvantage
of still requiring more work than is needed for bio-based request_queue
initialization.  It also poses a risk by requiring additional work when
resuming a bio-based device.

> (Then, let's focus on making a right fix rather than hacking
>  the block layer.)

I haven't been hacking the block layer.  Please don't misrepresent what
I proposed.

Regards,
Mike
