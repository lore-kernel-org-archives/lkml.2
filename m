Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2G0AvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 20:51:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab2G0AvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 20:51:07 -0400
Date: Thu, 26 Jul 2012 20:50:46 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Kent Overstreet <koverstreet@google.com>
cc: Boaz Harrosh <bharrosh@panasas.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, sage@newdream.net,
        yehuda@hq.newdream.net
Subject: [PATCH] A possible deadlock with stacked devices (was: [PATCH v4
 08/12] block: Introduce new bio_split())
In-Reply-To: <20120725232611.GD8673@moria.home.lan>
Message-ID: <Pine.LNX.4.64.1207262005450.28322@file.rdu.redhat.com>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
 <1343160689-12378-9-git-send-email-koverstreet@google.com> <500FDEBC.9050607@panasas.com>
 <20120725232611.GD8673@moria.home.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jul 2012, Kent Overstreet wrote:

> On Wed, Jul 25, 2012 at 02:55:40PM +0300, Boaz Harrosh wrote:
> > On 07/24/2012 11:11 PM, Kent Overstreet wrote:
> > 
> > > The new bio_split() can split arbitrary bios - it's not restricted to
> > > single page bios, like the old bio_split() (previously renamed to
> > > bio_pair_split()). It also has different semantics - it doesn't allocate
> > > a struct bio_pair, leaving it up to the caller to handle completions.
> > > 
> > > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > > ---
> > >  fs/bio.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 99 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/fs/bio.c b/fs/bio.c
> > > index 5d02aa5..a15e121 100644
> > > --- a/fs/bio.c
> > > +++ b/fs/bio.c
> > > @@ -1539,6 +1539,105 @@ struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
> > >  EXPORT_SYMBOL(bio_pair_split);
> > >  
> > >  /**
> > > + * bio_split - split a bio
> > > + * @bio:	bio to split
> > > + * @sectors:	number of sectors to split from the front of @bio
> > > + * @gfp:	gfp mask
> > > + * @bs:		bio set to allocate from
> > > + *
> > > + * Allocates and returns a new bio which represents @sectors from the start of
> > > + * @bio, and updates @bio to represent the remaining sectors.
> > > + *
> > > + * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
> > > + * unchanged.
> > > + *
> > > + * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
> > > + * bvec boundry; it is the caller's responsibility to ensure that @bio is not
> > > + * freed before the split.
> > > + *
> > > + * If bio_split() is running under generic_make_request(), it's not safe to
> > > + * allocate more than one bio from the same bio set. Therefore, if it is running
> > > + * under generic_make_request() it masks out __GFP_WAIT when doing the
> > > + * allocation. The caller must check for failure if there's any possibility of
> > > + * it being called from under generic_make_request(); it is then the caller's
> > > + * responsibility to retry from a safe context (by e.g. punting to workqueue).
> > > + */
> > > +struct bio *bio_split(struct bio *bio, int sectors,
> > > +		      gfp_t gfp, struct bio_set *bs)
> > > +{
> > > +	unsigned idx, vcnt = 0, nbytes = sectors << 9;
> > > +	struct bio_vec *bv;
> > > +	struct bio *ret = NULL;
> > > +
> > > +	BUG_ON(sectors <= 0);
> > > +
> > > +	/*
> > > +	 * If we're being called from underneath generic_make_request() and we
> > > +	 * already allocated any bios from this bio set, we risk deadlock if we
> > > +	 * use the mempool. So instead, we possibly fail and let the caller punt
> > > +	 * to workqueue or somesuch and retry in a safe context.
> > > +	 */
> > > +	if (current->bio_list)
> > > +		gfp &= ~__GFP_WAIT;
> > 
> > 
> > NACK!
> > 
> > If as you said above in the comment:
> > 	if there's any possibility of it being called from under generic_make_request();
> >         it is then the caller's responsibility to ...
> > 
> > So all the comment needs to say is: 
> > 	... caller's responsibility to not set __GFP_WAIT at gfp.
> > 
> > And drop this here. It is up to the caller to decide. If the caller wants he can do
> > "if (current->bio_list)" by his own.
> > 
> > This is a general purpose utility you might not know it's context.
> > for example with osdblk above will break.
> 
> Well I'm highly highly skeptical that using __GFP_WAIT under
> generic_make_request() is ever a sane thing to do - it could certainly
> be safe in specific circumstances, but it's just such a fragile thing to
> rely on, you have to _never_ use the same bio pool more than once. And
> even then I bet there's other subtle ways it could break.
> 
> But you're not the first to complain about it, and your point about
> existing code is compelling.

Both md and dm use __GFP_WAIT allocations from mempools in 
generic_make_request.

I think you found an interesting bug here. Suppose that we have three 
stacked devices: d1 depends on d2 and d2 depends on d3.

Now, a bio b1 comes to d1. d1 splits it to two bios: b2.1 and b2.2 and 
sends them to the device d2 - these bios end up in current->bio_list. The 
driver for d2 receives bio b2.1 and sends bio b3.1 to d3. Now, 
current->bio_list contains bios b2.2, b3.1. Now, bio b2.2 is popped off 
the bio list and the driver for d2 is called with b2.2 - suppose that for 
some reason mempool in d2 is exhausted and the driver needs to wait until 
b2.1 finishes. b2.1 never finishes, because b2.1 depends on b3.1 and b3.1 
is still in current->bio_list. So it deadlocks.

Turning off __GFP_WAIT fixes nothing - it just turns one bug (a possible 
deadlock) into another bug (a possible bio failure with -ENOMEM).

Increasing mempool sizes doesn't fix it either, the bio would just have to 
be split to more pieces in the above example to make it deadlock.

I think the above possible deadlock scenario could be fixed by reversing 
current->bio_list processing - i.e. when some device's make_request_fn 
adds some bios to current->bio_list, these bios are processed before other 
bios that were on the list before. This way, bio list would contain "b3.1, 
b2.2" instead of "b2.2, b3.1" in the above example and the deadlock would 
not happen.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-3.5-fast/block/blk-core.c
===================================================================
--- linux-3.5-fast.orig/block/blk-core.c	2012-07-27 02:20:25.000000000 +0200
+++ linux-3.5-fast/block/blk-core.c	2012-07-27 02:34:37.000000000 +0200
@@ -1740,6 +1740,7 @@ end_io:
 void generic_make_request(struct bio *bio)
 {
 	struct bio_list bio_list_on_stack;
+	struct bio_list current_bio_list;
 
 	if (!generic_make_request_checks(bio))
 		return;
@@ -1789,14 +1790,22 @@ void generic_make_request(struct bio *bi
 	 * bio_list, and call into ->make_request() again.
 	 */
 	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_list_on_stack);
+	bio_list_init(&current_bio_list);
 	current->bio_list = &bio_list_on_stack;
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
+		bio_list_init(&bio_list_on_stack);
+
 		q->make_request_fn(q, bio);
 
-		bio = bio_list_pop(current->bio_list);
+		/*
+		 * To avoid a possible deadlock, bios that were added by
+		 * the most recent make_request_fn must be processed first.
+		 */
+		bio_list_merge_head(&current_bio_list, &bio_list_on_stack);
+
+		bio = bio_list_pop(&current_bio_list);
 	} while (bio);
 	current->bio_list = NULL; /* deactivate */
 }
