Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab0EMD6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 23:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab0EMD6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 23:58:07 -0400
Date: Wed, 12 May 2010 23:57:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Message-ID: <20100513035750.GA25523@redhat.com>
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
 <1273532139-23043-2-git-send-email-snitzer@redhat.com>
 <4BE8DBB0.5060701@ct.jp.nec.com>
 <20100511131502.GA25211@redhat.com>
 <4BEA659F.9050206@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEA659F.9050206@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12 2010 at  4:23am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 05/11/2010 10:15 PM +0900, Mike Snitzer wrote:
> > It is clear we need to resolve the current full request_queue
> > initialization that occurs even for bio-based DM devices.
> > 
> > I believe the 2 patches I posted accomplish this in a stright-forward
> > way.  We can always improve on it (by looking at what you proposed
> > below) but we need a minimlaist fix that doesn't depend on userspace
> > LVM2 changes right now.
> 
> Humm, OK.
> Indeed, showing iosched directory in bio-based device's sysfs is
> confusing users actually, and we need something to resolve that soon.
> So I don't strongly object to your approach as the first step, as long
> as we can accept the risk of the maintenance cost which I mentioned.

OK, I understand your concern (especially after having gone through this
further over the past couple days).  I'm hopeful maintenance will be
minimal.

> By the way, your current patch has a problem below.
> It needs to be fixed at least.

Thanks for the review.  I've addressed both your points with additional
changes (split between 2 patches).

> > Similarly, my proposed DM changes are also quite natural. By using
> > dm_table_set_type() as the hook to initialize the request-based DM
> > device's elevator we perform allocations during table load.
> 
> Your patch initializes queue everytime request-based table is loaded.
> I think that could cause a problem (although I haven't tested your
> patch yet).

Yes, that was definitely a problem.  I've included an incremental patch
that shows the fixes to dm_init_request_based_queue below.  I'll send
out a revised patch: [PATCH 2/2 v2] ...

If you're comfortable with it please respond with your Acked-by.

> Also, as you know, the table load can be canceled.
> So initializing queue at table loading time may cause some weird
> behaviors for users.  For example,
>     # dmsetup create --notable bio-based
>     # echo "0 100 multipath ..." | dmsetup load bio-based
>     # echo "0 100 linear ..."    | dmsetup load bio-based
>     # dmsetup resume bio-based
>     # ls /sys/block/dm-0/queue/
>     ... iosched ...
> If you (and Alasdair) think this behavior is acceptable, it might
> be OK.  I just feel it's weird though...

Agreed, we don't think this is ideal.. I have a follow-on patch that
I'll mail out separately for your consideration ([RFC PATCH 3/2]).

> > Having just looked at Nikanth's proposed DM patch 2/2 again it shows
> > that blk_init_allocated_queue(), which allocates memory, was being
> > called during resume (dm_swap_table).  Allocations are not allowed
> > during resume.
> 
> Right, in general.
> However, in this special case, I think initializing queue (allocating
> memory) during resume should be OK as I mentioned like below in:
>     http://marc.info/?l=linux-kernel&m=124999806420663&w=2
> 
>     > Generally, dm must not allocate memory during resume because
>     > it may cause a deadlock in no memory situation.
>     > However, there is no I/O on this device at this point,
>     > so the allocation should be ok for this special case.
>     > I think some comments are needed here to describe that.
> 
> So you should be able to take this approach.

I confirmed with Alasdair that we don't want to conditionally relax DM's
allocation constraints for request-based DM.  Best to be consistent
about not allowing allocations during resume.

Here is the incremental patch I mentioned above.
---
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Wed May 12 18:52:01 2010 -0400

    idempotent dm_init_request_based_queue

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6df7f6c..b2171be 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1951,14 +1951,30 @@ bad_module_get:
 	return NULL;
 }
 
+/*
+ * Fully initialize the request_queue (elevator, ->request_fn, etc).
+ */
 int dm_init_request_based_queue(struct mapped_device *md)
 {
 	struct request_queue *q = NULL;
 
-	q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
-	if (!q)
+	if (!md->queue)
 		return 0;
-	md->queue = q;
+
+	/*
+	 * Avoid re-initializing the queue (and leaking the existing
+	 * elevator) if dm_init_request_based_queue() was already used.
+	 */
+	if (!md->queue->elevator) {
+		/* Fully initialize the queue */
+		q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
+		if (!q)
+			return 0;
+		md->queue = q;
+		md->saved_make_request_fn = md->queue->make_request_fn;
+		blk_queue_make_request(md->queue, dm_request);
+		elv_register_queue(md->queue);
+	}
 
 	/*
 	 * Request-based dm devices cannot be stacked on top of bio-based dm
@@ -1970,7 +1986,6 @@ int dm_init_request_based_queue(struct mapped_device *md)
 	 * This queue is new, so no concurrency on the queue_flags.
 	 */
 	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
-	md->saved_make_request_fn = md->queue->make_request_fn;
 
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
@@ -1978,9 +1993,6 @@ int dm_init_request_based_queue(struct mapped_device *md)
 	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
 			  dm_rq_prepare_flush);
 
-	/* Register the request-based queue's elevator with sysfs */
-	elv_register_queue(md->queue);
-
 	return 1;
 }
 
