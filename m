Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0EQR1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:27:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab0EQR1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:27:51 -0400
Date: Mon, 17 May 2010 13:27:37 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Alasdair Kergon <agk@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Message-ID: <20100517172737.GA24591@redhat.com>
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
 <1273532139-23043-2-git-send-email-snitzer@redhat.com>
 <4BE8DBB0.5060701@ct.jp.nec.com>
 <20100511131502.GA25211@redhat.com>
 <4BEA659F.9050206@ct.jp.nec.com>
 <20100513035750.GA25523@redhat.com>
 <4BED049C.5040409@ct.jp.nec.com>
 <20100514140852.GA10373@redhat.com>
 <4BF10BF1.3040108@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF10BF1.3040108@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17 2010 at  5:27am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 05/14/2010 11:08 PM +0900, Mike Snitzer wrote:
> > On Fri, May 14 2010 at  4:06am -0400,
> > Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> > 
> >> Hi Mike,
> >>
> >> On 05/13/2010 12:57 PM +0900, Mike Snitzer wrote:
> >>> On Wed, May 12 2010 at  4:23am -0400,
> >>> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> >>>
> >>>> Hi Mike,
> >>>>
> >>>> On 05/11/2010 10:15 PM +0900, Mike Snitzer wrote:
> >>>>> It is clear we need to resolve the current full request_queue
> >>>>> initialization that occurs even for bio-based DM devices.
> >>>>>
> >>>>> I believe the 2 patches I posted accomplish this in a stright-forward
> >>>>> way.  We can always improve on it (by looking at what you proposed
> >>>>> below) but we need a minimlaist fix that doesn't depend on userspace
> >>>>> LVM2 changes right now.
> >>>>
> >>>> Humm, OK.
> >>>> Indeed, showing iosched directory in bio-based device's sysfs is
> >>>> confusing users actually, and we need something to resolve that soon.
> >>>> So I don't strongly object to your approach as the first step, as long
> >>>> as we can accept the risk of the maintenance cost which I mentioned.
> >>>
> >>> OK, I understand your concern (especially after having gone through this
> >>> further over the past couple days).  I'm hopeful maintenance will be
> >>> minimal.
> snip
> >> I feel your patch-set is growing and becoming complex fix rather than
> >> minimalist/simple fix.
> >> 
> >> I think touching mapped_device/queue at table loading time makes
> >> things complex.  It is natural that table's arguments are reflected
> >> to mapped_device/queue at table binding time instead.
> >
> > Seems the numerous patches I've posted over the past couple days have
> > given a false impression.  But I do understand your concern.
> > 
> > The longer-term direction you want to take DM (known type during
> > alloc_dev) illustrates that we share a common goal: only do the precise
> > work that is needed to initialize the request_queue for a DM device
> > (whether it is bio-based or request-based).
> > 
> > My changes do accomplish that in the near-term without requiring
> > userspace change.  Many of my proposed changes are just refactoring
> > existing code to clearly split out what is needed for request-based vs
> > bio-based.
> 
> As far as I understand, the current model of device-mapper is:
>   - a table (precisely, a target) has various attributes,
>     bio-based/request-based is one of such attributes
>   - a table and its attributes are bound to the block device on resume
> If we want to fix a problem, I think we should either work based on
> this model or change the model.
> 
> Your patch makes that loading table affects the block device, so you
> are changing the model.
> 
> If you change the model, it should be done carefully.
> For example, the current model allows most of the table loading code
> to run without exclusive lock on the device because it doesn't affect
> the device itself.  If you change this model, table loading needs to
> be serialized with appropriate locking.

Nice catch, yes md->queue needs protection (see patch below).
 
> My suggestion was (and is) to change the current model by determining
> bio-based/request-based at device creation time, not by a table.
> 
> 
> > I'll post a single patch that contains my changes (no need to have 2
> > patches any more).  With that patch I'm hopeful you'll see my changes
> > aren't as complex as they might have seemed over the past few days.
>  
> The number of patches doesn't matter.
> I still feel it's becoming complex, for example it now has to take
> care of reverting md/queue changes by previous preload.

AFAIK, no md/queue changes would need to be reverted.  The last table
load wins and the DM device's queue is left in the correct state for
that winning table (assuming the patch at the end of this mail).

As for the overall complexity of my proposed changes, I'm inclined to
address this issue without userspace changes.  But I do understand we're
at a cross-roads (and likely need Alasdair, and/or others, to weigh in):

1) Are my proposed kernel-only changes somehow detrimental to DM right
   now?
   - We cannot let known bugs go unfixed because of unknown future
     requirements.

2) Is requiring the DM create ioctl to know that a device will be
   request-based vs bio-based really a reasonable requirement?
   - To me a DM device's queue type is a DM (kernel) implementation
     detail that userspace shouldn't _ever_ need to know about.  If
     userspace knew it'd make the kernel's life easier but that doesn't
     make it the correct solution on its own.

> Also, you have to take care of race condition between concurrent table
> loadings which was mentioned above, because the table which was used to
> initialized the queue may not be set in hc->new_map.
> Although such races may not happen in real usages, they could cause
> some critical problems (maybe kernel panic, maybe memory leak).

In the worst case, the hypothetical concurrent table loadings (of
conflicting types: request vs bio) will just cause the request_queue to
be fully initialized (allocated elevator) for bio-based devices.  There
aren't any other concerns with panics or memory leaks.  Granted
something like the following patch is required:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 143082c..02966ef 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -123,6 +123,11 @@ struct mapped_device {
 	unsigned long flags;
 
 	struct request_queue *queue;
+	/*
+	 * Protect queue from concurrent initialization during
+	 * table load
+	 */
+	struct mutex queue_lock;
 	struct gendisk *disk;
 	char name[16];
 
@@ -1892,6 +1897,7 @@ static struct mapped_device *alloc_dev(int minor)
 
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
+	mutex_init(&md->queue_lock);
 	spin_lock_init(&md->deferred_lock);
 	spin_lock_init(&md->barrier_error_lock);
 	rwlock_init(&md->map_lock);
@@ -1966,14 +1972,16 @@ bad_module_get:
  */
 int dm_init_request_based_queue(struct mapped_device *md)
 {
+	int r = 0;
 	struct request_queue *q = NULL;
 
+	mutex_lock(&md->queue_lock);
 	/* Avoid re-initializing the queue if already fully initialized */
 	if (!md->queue->elevator) {
 		/* Fully initialize the queue */
 		q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
 		if (!q)
-			return 0;
+			goto out;
 		md->queue = q;
 		md->saved_make_request_fn = md->queue->make_request_fn;
 		dm_init_md_queue(md);
@@ -1984,8 +1992,11 @@ int dm_init_request_based_queue(struct mapped_device *md)
 		 * bio-based back to request-based, e.g.: rq -> bio -> rq
 		 */
 		md->queue->request_fn = dm_request_fn;
-	} else
-		return 1; /* already request-based */
+	} else {
+		/* already request-based */
+		r = 1;
+		goto out;
+	}
 
 	elv_register_queue(md->queue);
 
@@ -2006,7 +2017,10 @@ int dm_init_request_based_queue(struct mapped_device *md)
 	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
 			  dm_rq_prepare_flush);
 
-	return 1;
+	r = 1;
+out:
+	mutex_unlock(&md->queue_lock);
+	return r;
 }
 
 void dm_clear_request_based_queue(struct mapped_device *md)
@@ -2015,8 +2029,10 @@ void dm_clear_request_based_queue(struct mapped_device *md)
 		return; /* already bio-based */
 
 	/* Unregister elevator from sysfs and clear ->request_fn */
+	mutex_lock(&md->queue_lock);
 	elv_unregister_queue(md->queue);
 	md->queue->request_fn = NULL;
+	mutex_unlock(&md->queue_lock);
 }
 
 static void unlock_fs(struct mapped_device *md);
