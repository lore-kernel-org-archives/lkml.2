Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965448Ab2EXV1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:27:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33361 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965394Ab2EXV10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:27:26 -0400
Date: Thu, 24 May 2012 14:27:23 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 11/14] block: Rework bio splitting
Message-ID: <20120524212723.GA22664@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-12-git-send-email-koverstreet@google.com>
 <4FBE6823.50904@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBE6823.50904@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 07:56:03PM +0300, Boaz Harrosh wrote:
> Again could you please take this bio_split and just put
> it down below the implementation of bio_pair_split. This way
> we can better review what the changes actually are. Now it
> is a complete mess in the diff, where the deleted lines of the
> bio_pair_release are in between the new lines of bio_split().
> Please ???

Ahh, I saw that comment but I missed what it was that you wanted me to
reorder. Will do.

> 
> > +struct bio *bio_split(struct bio *bio, int sectors,
> > +		      gfp_t gfp, struct bio_set *bs)
> >  {
> 
> 
> 
> 
> This is a freaking important and capable exported function.
> Could you please put some comment on what it does and what are
> it's limitation.

Yeah, I'll do that.

> For example the returned bio is the beginning of the chain
> and the original is the reminder, right?

Yes. 

> 
> > -	if (atomic_dec_and_test(&bp->cnt)) {
> > -		struct bio *master = bp->bio1.bi_private;
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
> 
> 
> Is this true also when @bio is not from @bs ?

Yes. Not masking out __GFP_WAIT would only be safe if you could
guarantee that you never tried to split a bio more than once (from the
same bio set), and IMO that'd be a terrible thing to rely on.

> 
> Is it at all supported when they are not the same?

When what's not the same?

> 
> Are kmalloc bios not split-able?

They are.

> 
> Please put answer to these in above comment.
> 
> In the split you have a single bio with or without bvects allocation
> should you not let the caller make sure not to set __GFP_WAIT.
> 
> For me, inspecting current->bio_list is out of context and a complete
> hack. The caller should take care of it, which has more context.

I agree that it is hacky, but shifting the responsibility onto the
caller would IMO be much more likely to lead to buggy code in the
future (and those deadlocks are not going to be easy to track down).

It might be better to mask out __GFP_WAIT in bio_alloc_bioset(), I'm not
sure.

> For example I might want to use split from OSD code where I do
> not use an elevator at all, and current->bio_list could belong
> to a completely different device. (Maybe)

Doesn't matter. If you allocate a split, it won't free itself until the
IO is submitted and completes; current->bio_list != NULL the bio cannot
complete until you return.

> I don't see below any references taken by "ret" on @bio.
> What protects us from @bio not been freed before "ret" ?
> 
> If it's the caller responsibility please say so in
> comment above 

Yeah, caller responsibility. Will do.

> 
> > +		} else if (nbytes < bv->bv_len) {
> > +			ret = bio_alloc_bioset(gfp, ++vcnt, bs);
> > +			if (!ret)
> > +				return NULL;
> 
> 
> 
> 
> We could in this case save and only allocate one more bio with a single
> bio_vec and chain it to the end.

I thought about that, but this works for now - my preferred solution is
to make bi_io_vec immutable (that'll require a bi_bvec_offset field in
struct bio, and the end result is we'd be able to split mid bvec and
share the bvec with both bios).

> 
> And if you change it around, where the reminder is "ret" and the
> beginning of the chain is left @bio. you wouldn't even need the
> extra bio. (Trim the last and a single-bvec bio holds the reminder + remainder-chain)

Don't follow... If you're processing a bio starting from the smallest
sector though, you want the split to be the front of the bio otherwise
if you split multiple times you'll try to split a split, and deadlock.
