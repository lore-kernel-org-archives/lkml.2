Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2HIB1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 21:27:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47140 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2HIB1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 21:27:41 -0400
Date: Wed, 8 Aug 2012 18:19:28 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Message-ID: <20120809011928.GG7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-9-git-send-email-koverstreet@google.com>
 <20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:58:39PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 06, 2012 at 03:08:37PM -0700, Kent Overstreet wrote:
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
> 
> Umm.... I don't know.  This is rather confusing.  The function may
> return new or old bios?  What's the rationale behind it?  Return
> ERR_PTR(-EINVAL) instead?

Returning the old bio would be semantically equivalent to returning an
error, but IME when you're actually using it it does make sense and
leads to slightly cleaner code.

The reason is that when you're splitting, sectors is typically just the
maximum number of sectors you can handle here - you calculate the device
limit, or the number of sectors you can read from this location, or
whatever.

So the code ends up looking like:

while (1) {
	split = bio_split(bio, sectors);

	/* do some stuff to split and submit it */

	/* check if that was the last split and break */
}

If bio_split returned an error, it'd make the code more convoluted -
you'd have to do work on either the split or the original bio, and then
repeat the same check later when it's time to break out of the loop.


> 
> > + *
> > + * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
> > + * bvec boundry; it is the caller's responsibility to ensure that @bio is not
> > + * freed before the split.
> 
> This is somewhat error-prone.  Given how splits are used now, this
> might not be a big issue but it isn't difficult to imagine how this
> could go subtly wrong.  More on this.

I can't find anything else in your emails on the subject...

So, I do agree, but there is a rationale:

Due to the way bio completions have to be chained, I'm not convinced
it's much of an issue in practice; if you're processing a bio by
splitting it, you can't complete it until all the splits have
completed, so you have to have a hook there.

In order for this to lead to a bug, you'd have to be cloning the
original bio (i.e. you can't be splitting a bio that someone else owns
and passed you, because that won't be freed until after you complete it)
and then you have to fail to put/free that clone in your hook, where
you're going to have other state to free too.

Cloning a bio and then not explicitly freeing it ought to be fairly
obviously wrong, IMO.

I think there's a more positive reason to do it this way long term, too.
I'm working towards getting rid of arbitrary restrictions in the block
layer, and forcing bio_split() to allocate the bvec introduces one;
allocating a bio with more than BIO_MAX_VECS will fail, and that _is_
the kind of tricky restriction that's likely to trip callers up (it's
certainly happened to me, I think multiple times).

Currently this is still an issue if the split isn't aligned on a bvec
boundary, but that's also fixable - by making the bvec immutable, which
would have a lot of other benefits too.

Making bio vecs immutable would also solve the original problem, because
cloning a bio would no longer clone the bvec as well - so the bvec the
split points to would _always_ be owned by something higher up that
couldn't free it until after the split completes.

> 
> > + *
> > + * BIG FAT WARNING:
> > + *
> > + * If you're calling this from under generic_make_request() (i.e.
> > + * current->bio_list != NULL), you should mask out __GFP_WAIT and punt to
> > + * workqueue if the allocation fails. Otherwise, your code will probably
> > + * deadlock.
> 
> If the condition is detectable, WARN_ON_ONCE() please.

Ok, I like that.

> 
> > + * You can't allocate more than once from the same bio pool without submitting
> > + * the previous allocations (so they'll eventually complete and deallocate
> > + * themselves), but if you're under generic_make_request() those previous
> > + * allocations won't submit until you return . And if you have to split bios,
>                                                ^
> 					       extra space
> > + * you should expect that some bios will require multiple splits.
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
> > +	if (sectors >= bio_sectors(bio))
> > +		return bio;
> > +
> > +	trace_block_split(bdev_get_queue(bio->bi_bdev), bio,
> > +			  bio->bi_sector + sectors);
> > +
> > +	bio_for_each_segment(bv, bio, idx) {
> > +		vcnt = idx - bio->bi_idx;
> > +
> > +		if (!nbytes) {
> > +			ret = bio_alloc_bioset(gfp, 0, bs);
> > +			if (!ret)
> > +				return NULL;
> > +
> > +			ret->bi_io_vec = bio_iovec(bio);
> > +			ret->bi_flags |= 1 << BIO_CLONED;
> > +			break;
> > +		} else if (nbytes < bv->bv_len) {
> > +			ret = bio_alloc_bioset(gfp, ++vcnt, bs);
> > +			if (!ret)
> > +				return NULL;
> > +
> > +			memcpy(ret->bi_io_vec, bio_iovec(bio),
> > +			       sizeof(struct bio_vec) * vcnt);
> > +
> > +			ret->bi_io_vec[vcnt - 1].bv_len = nbytes;
> > +			bv->bv_offset	+= nbytes;
> > +			bv->bv_len	-= nbytes;
> > +			break;
> > +		}
> 
> Ummm... ISTR reviewing this code and getting confused by bio_alloc
> inside bio_for_each_segment() loop and commenting something about
> that.  Yeah, this one.
> 
>   http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/15790/focus=370
> 
> So, I actually have reviewed this but didn't get any response and
> majority of the issues I raised aren't addressed and you sent the
> patch to me again?  What the hell, Kent?

Argh. I apologize, I knew I'd missing something. Cutting and pasting the
stuff I haven't already responded to/fixed:

>> +			ret->bi_io_vec[vcnt - 1].bv_len = nbytes;
>> +			bv->bv_offset	+= nbytes;
>> +			bv->bv_len	-= nbytes;
>
> Please don't indent assignments.

Ok, unindented those.

>
>> +			break;
>> +		}
>> +
>> +		nbytes -= bv->bv_len;
>> +	}
>
> I find the code a bit confusing.  Wouldn't it be better to structure
> it as
>
>	bio_for_each_segment() {
>		find splitting point;
>	}
>
>	Do all of the splitting.

Definitely, except I don't see how to sanely do it that way with the
different cases for splitting on a bvec boundry and not.

I would like to get rid of that conditional eventually, but by making
bvecs immutable.

>
>> +	ret->bi_bdev	= bio->bi_bdev;
>> +	ret->bi_sector	= bio->bi_sector;
>> +	ret->bi_size	= sectors << 9;
>> +	ret->bi_rw	= bio->bi_rw;
>> +	ret->bi_vcnt	= vcnt;
>> +	ret->bi_max_vecs = vcnt;
>> +	ret->bi_end_io	= bio->bi_end_io;
>> +	ret->bi_private	= bio->bi_private;
>>  
>> -		bio_endio(master, bp->error);
>> -		mempool_free(bp, bp->bio2.bi_private);
>> +	bio->bi_sector	+= sectors;
>> +	bio->bi_size	-= sectors << 9;
>> +	bio->bi_idx	 = idx;
>
> I personally would prefer not having indentations here either.

These I'd prefer to keep - it is a dozen assignments in a row, I
_really_ find the indented version more readable.

> So, before, split wouldn't override orig->bi_private.  Now, it does so
> while the bio is in flight.  I don't know.  If the only benefit of
> temporary override is avoiding have a separate end_io call, I think
> not doing so is better.  Also, behavior changes as subtle as this
> *must* be noted in the patch description.

Already said more about this below, but to elaborate a bit - there are
situations where the caller really wouldn't want the completions chained 
(i.e, if the splits are going to different devices or otherwise are
going to have different error handling, the caller really needs to
supply its own endio function(s)).

The old behaviour is still available (certainly there are cases where it
_is_ what you want) - it's just been decoupled a bit.

> 
> > +
> > +		nbytes -= bv->bv_len;
> > +	}
> > +
> > +	ret->bi_bdev	= bio->bi_bdev;
> > +	ret->bi_sector	= bio->bi_sector;
> > +	ret->bi_size	= sectors << 9;
> > +	ret->bi_rw	= bio->bi_rw;
> > +	ret->bi_vcnt	= vcnt;
> > +	ret->bi_max_vecs = vcnt;
> > +	ret->bi_end_io	= bio->bi_end_io;
> 
> Is this safe?  Why isn't this chaining completion of split bio to the
> original one?

Outside the scope of this function - if you want the completions
chained, you'd use bio_pair_split().

With this bio_split() it's perfectly reasonable to split a bio an
arbitrary number of times, and if that's what you're doing it's much
cleaner (and more efficient) to just use a refcount instead of chaining
the completions a bunch of times.

So if that's what the caller is doing, this will do exactly what they
want - if the caller wants to chain the completions, the caller can
still do that (like how bio_pair_split() does in the next patch).

> 
> Thanks.
> 
> -- 
> tejun
