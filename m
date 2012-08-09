Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2HIGo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:44:56 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50195 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2HIGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:44:54 -0400
Date: Wed, 8 Aug 2012 23:44:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Message-ID: <20120809064448.GC2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-9-git-send-email-koverstreet@google.com>
 <20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809011928.GG7262@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809011928.GG7262@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, Aug 08, 2012 at 06:19:28PM -0700, Kent Overstreet wrote:
> If bio_split returned an error, it'd make the code more convoluted -
> you'd have to do work on either the split or the original bio, and then
> repeat the same check later when it's time to break out of the loop.

I really dislike this reasonsing.  The interface might streamline
certain use cases a bit but at the cost of confusing semantics.  It's
called bio_split() which takes a bio and returns a bio.  Any sane
person would expect it to return the split bio iff the original bio is
successfully split and NULL or ERR_PTR() value if splitting didn't
happen for whatever reason.  Please don't try to make code look
elegant by twisting obvious things.  Saving three lines is never
worthwhile it it costs obviousness.

This reminds me of, unfortunately, kobject_get() which returns the
parameter it got passed in verbatim.  The rationale was that it makes
code like the following *look* more elegant.

	my_kobj = kobject_get(&blahblah.kobj);

Some people liked how things like the above looked.  Unfortunately, it
unnecessarily made people wonder whether the return value could be
different from the parameter (can it ever fail?) and led to cases
where people misunderstood the semantics and assumed that kobj somehow
handles zero refcnt racing and kobject_get() would magically return
NULL if refcnt reaches zero.  I hope we don't have those bugs anymore
but code built on top of kobject unfortunately propagated this
stupidity multiple layers upwards and I'm not sure.

So, please don't do things like this.

> > This is somewhat error-prone.  Given how splits are used now, this
> > might not be a big issue but it isn't difficult to imagine how this
> > could go subtly wrong.  More on this.
> 
> I can't find anything else in your emails on the subject...

Oh, it was the chaining thing.  If you bump ref on the original bio
and let the split one put it on completion, the caller doesn't have to
worry about this.

> > > +	bio_for_each_segment(bv, bio, idx) {
> > > +		vcnt = idx - bio->bi_idx;
> > > +
> > > +		if (!nbytes) {
> > > +			ret = bio_alloc_bioset(gfp, 0, bs);
> > > +			if (!ret)
> > > +				return NULL;
> > > +
> > > +			ret->bi_io_vec = bio_iovec(bio);
> > > +			ret->bi_flags |= 1 << BIO_CLONED;
> > > +			break;
> > > +		} else if (nbytes < bv->bv_len) {
> > > +			ret = bio_alloc_bioset(gfp, ++vcnt, bs);
> > > +			if (!ret)
> > > +				return NULL;
> > > +
> > > +			memcpy(ret->bi_io_vec, bio_iovec(bio),
> > > +			       sizeof(struct bio_vec) * vcnt);
> > > +
> > > +			ret->bi_io_vec[vcnt - 1].bv_len = nbytes;
> > > +			bv->bv_offset	+= nbytes;
> > > +			bv->bv_len	-= nbytes;
> > > +			break;
> > > +		}
...
> > I find the code a bit confusing.  Wouldn't it be better to structure
> > it as
> >
> >	bio_for_each_segment() {
> >		find splitting point;
> >	}
> >
> >	Do all of the splitting.
> 
> Definitely, except I don't see how to sanely do it that way with the
> different cases for splitting on a bvec boundry and not.

I really don't buy that.  Just break out on the common condition and
differentiate the two cases afterwards.

> > So, before, split wouldn't override orig->bi_private.  Now, it does so
> > while the bio is in flight.  I don't know.  If the only benefit of
> > temporary override is avoiding have a separate end_io call, I think
> > not doing so is better.  Also, behavior changes as subtle as this
> > *must* be noted in the patch description.
> 
> Already said more about this below, but to elaborate a bit - there are
> situations where the caller really wouldn't want the completions chained 
> (i.e, if the splits are going to different devices or otherwise are
> going to have different error handling, the caller really needs to
> supply its own endio function(s)).

Then let it take @chain parameter and if @chain is %false, clear endio
(or introduce bio_split_chain()).  Copying endio of the original bio
is useless and dangerous.

> Outside the scope of this function - if you want the completions
> chained, you'd use bio_pair_split().
> 
> With this bio_split() it's perfectly reasonable to split a bio an
> arbitrary number of times, and if that's what you're doing it's much
> cleaner (and more efficient) to just use a refcount instead of chaining
> the completions a bunch of times.
> 
> So if that's what the caller is doing, this will do exactly what they
> want - if the caller wants to chain the completions, the caller can
> still do that (like how bio_pair_split() does in the next patch).

bio_pair doesn't really make much sense after this change.  Originally
it made sense as the container holding everything necessary for the
clone, now it's just a proxy to keep the old interface.  It doesn't
even succeed at that.  The interface changes.  Let's just roll it into
the default bio_clone() interface.

Thanks.

-- 
tejun
