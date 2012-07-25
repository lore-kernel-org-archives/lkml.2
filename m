Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab2GYX0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:26:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63577 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2GYX0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:26:15 -0400
Date: Wed, 25 Jul 2012 16:26:11 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, agk@redhat.com,
        neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v4 08/12] block: Introduce new bio_split()
Message-ID: <20120725232611.GD8673@moria.home.lan>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
 <1343160689-12378-9-git-send-email-koverstreet@google.com>
 <500FDEBC.9050607@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500FDEBC.9050607@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 02:55:40PM +0300, Boaz Harrosh wrote:
> On 07/24/2012 11:11 PM, Kent Overstreet wrote:
> 
> > The new bio_split() can split arbitrary bios - it's not restricted to
> > single page bios, like the old bio_split() (previously renamed to
> > bio_pair_split()). It also has different semantics - it doesn't allocate
> > a struct bio_pair, leaving it up to the caller to handle completions.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > ---
> >  fs/bio.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 99 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index 5d02aa5..a15e121 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -1539,6 +1539,105 @@ struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
> >  EXPORT_SYMBOL(bio_pair_split);
> >  
> >  /**
> > + * bio_split - split a bio
> > + * @bio:	bio to split
> > + * @sectors:	number of sectors to split from the front of @bio
> > + * @gfp:	gfp mask
> > + * @bs:		bio set to allocate from
> > + *
> > + * Allocates and returns a new bio which represents @sectors from the start of
> > + * @bio, and updates @bio to represent the remaining sectors.
> > + *
> > + * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
> > + * unchanged.
> > + *
> > + * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
> > + * bvec boundry; it is the caller's responsibility to ensure that @bio is not
> > + * freed before the split.
> > + *
> > + * If bio_split() is running under generic_make_request(), it's not safe to
> > + * allocate more than one bio from the same bio set. Therefore, if it is running
> > + * under generic_make_request() it masks out __GFP_WAIT when doing the
> > + * allocation. The caller must check for failure if there's any possibility of
> > + * it being called from under generic_make_request(); it is then the caller's
> > + * responsibility to retry from a safe context (by e.g. punting to workqueue).
> > + */
> > +struct bio *bio_split(struct bio *bio, int sectors,
> > +		      gfp_t gfp, struct bio_set *bs)
> > +{
> > +	unsigned idx, vcnt = 0, nbytes = sectors << 9;
> > +	struct bio_vec *bv;
> > +	struct bio *ret = NULL;
> > +
> > +	BUG_ON(sectors <= 0);
> > +
> > +	/*
> > +	 * If we're being called from underneath generic_make_request() and we
> > +	 * already allocated any bios from this bio set, we risk deadlock if we
> > +	 * use the mempool. So instead, we possibly fail and let the caller punt
> > +	 * to workqueue or somesuch and retry in a safe context.
> > +	 */
> > +	if (current->bio_list)
> > +		gfp &= ~__GFP_WAIT;
> 
> 
> NACK!
> 
> If as you said above in the comment:
> 	if there's any possibility of it being called from under generic_make_request();
>         it is then the caller's responsibility to ...
> 
> So all the comment needs to say is: 
> 	... caller's responsibility to not set __GFP_WAIT at gfp.
> 
> And drop this here. It is up to the caller to decide. If the caller wants he can do
> "if (current->bio_list)" by his own.
> 
> This is a general purpose utility you might not know it's context.
> for example with osdblk above will break.

Well I'm highly highly skeptical that using __GFP_WAIT under
generic_make_request() is ever a sane thing to do - it could certainly
be safe in specific circumstances, but it's just such a fragile thing to
rely on, you have to _never_ use the same bio pool more than once. And
even then I bet there's other subtle ways it could break.

But you're not the first to complain about it, and your point about
existing code is compelling.

commit ea124f899af29887e24d07497442066572012e5b
Author: Kent Overstreet <koverstreet@google.com>
Date:   Wed Jul 25 16:25:10 2012 -0700

    block: Introduce new bio_split()
    
    The new bio_split() can split arbitrary bios - it's not restricted to
    single page bios, like the old bio_split() (previously renamed to
    bio_pair_split()). It also has different semantics - it doesn't allocate
    a struct bio_pair, leaving it up to the caller to handle completions.

diff --git a/fs/bio.c b/fs/bio.c
index 0470376..312e5de 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1537,6 +1537,102 @@ struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
 EXPORT_SYMBOL(bio_pair_split);
 
 /**
+ * bio_split - split a bio
+ * @bio:	bio to split
+ * @sectors:	number of sectors to split from the front of @bio
+ * @gfp:	gfp mask
+ * @bs:		bio set to allocate from
+ *
+ * Allocates and returns a new bio which represents @sectors from the start of
+ * @bio, and updates @bio to represent the remaining sectors.
+ *
+ * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
+ * unchanged.
+ *
+ * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
+ * bvec boundry; it is the caller's responsibility to ensure that @bio is not
+ * freed before the split.
+ *
+ * BIG FAT WARNING:
+ *
+ * If you're calling this from under generic_make_request() (i.e.
+ * current->bio_list != NULL), you should mask out __GFP_WAIT and punt to
+ * workqueue if the allocation fails. Otherwise, your code will probably
+ * deadlock.
+ *
+ * You can't allocate more than once from the same bio pool without submitting
+ * the previous allocations (so they'll eventually complete and deallocate
+ * themselves), but if you're under generic_make_request() those previous
+ * allocations won't submit until you return . And if you have to split bios,
+ * you should expect that some bios will require multiple splits.
+ */
+struct bio *bio_split(struct bio *bio, int sectors,
+		      gfp_t gfp, struct bio_set *bs)
+{
+	unsigned idx, vcnt = 0, nbytes = sectors << 9;
+	struct bio_vec *bv;
+	struct bio *ret = NULL;
+
+	BUG_ON(sectors <= 0);
+
+	if (sectors >= bio_sectors(bio))
+		return bio;
+
+	trace_block_split(bdev_get_queue(bio->bi_bdev), bio,
+			  bio->bi_sector + sectors);
+
+	bio_for_each_segment(bv, bio, idx) {
+		vcnt = idx - bio->bi_idx;
+
+		if (!nbytes) {
+			ret = bio_alloc_bioset(gfp, 0, bs);
+			if (!ret)
+				return NULL;
+
+			ret->bi_io_vec = bio_iovec(bio);
+			ret->bi_flags |= 1 << BIO_CLONED;
+			break;
+		} else if (nbytes < bv->bv_len) {
+			ret = bio_alloc_bioset(gfp, ++vcnt, bs);
+			if (!ret)
+				return NULL;
+
+			memcpy(ret->bi_io_vec, bio_iovec(bio),
+			       sizeof(struct bio_vec) * vcnt);
+
+			ret->bi_io_vec[vcnt - 1].bv_len = nbytes;
+			bv->bv_offset	+= nbytes;
+			bv->bv_len	-= nbytes;
+			break;
+		}
+
+		nbytes -= bv->bv_len;
+	}
+
+	ret->bi_bdev	= bio->bi_bdev;
+	ret->bi_sector	= bio->bi_sector;
+	ret->bi_size	= sectors << 9;
+	ret->bi_rw	= bio->bi_rw;
+	ret->bi_vcnt	= vcnt;
+	ret->bi_max_vecs = vcnt;
+	ret->bi_end_io	= bio->bi_end_io;
+	ret->bi_private	= bio->bi_private;
+
+	bio->bi_sector	+= sectors;
+	bio->bi_size	-= sectors << 9;
+	bio->bi_idx	 = idx;
+
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(ret, bio, gfp, bs);
+		bio_integrity_trim(ret, 0, bio_sectors(ret));
+		bio_integrity_trim(bio, bio_sectors(ret), bio_sectors(bio));
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bio_split);
+
+/**
  *      bio_sector_offset - Find hardware sector offset in bio
  *      @bio:           bio to inspect
  *      @index:         bio_vec index
