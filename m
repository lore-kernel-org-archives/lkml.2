Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030311Ab2HXUIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:08:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51560 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab2HXUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:08:40 -0400
Date: Fri, 24 Aug 2012 13:08:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 06/13] block: Consolidate bio_alloc_bioset(),
 bio_kmalloc()
Message-ID: <20120824200835.GD21325@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-7-git-send-email-koverstreet@google.com>
 <20120822201730.GI19212@google.com>
 <20120824050400.GA11977@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824050400.GA11977@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 23, 2012 at 10:04:00PM -0700, Kent Overstreet wrote:
> > >  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> > >  {
> > > +	unsigned front_pad;
> > > +	unsigned inline_vecs;
> > >  	unsigned long idx = BIO_POOL_NONE;
> > >  	struct bio_vec *bvl = NULL;
> > >  	struct bio *bio;
> > >  	void *p;
> > >  
> > > -	p = mempool_alloc(bs->bio_pool, gfp_mask);
> > > +	if (nr_iovecs > UIO_MAXIOV)
> > > +		return NULL;
> > 
> > This test used to only happen for bio_kmalloc().  If I follow the code
> > I can see that UIO_MAXIOV is larger than BIOVEC_MAX_IDX, so this
> > doesn't really affect the capability of bioset allocs; however, given
> > that bioset allocation already checks against BIOVEC_MAX_IDX, I don't
> > see why this test is now also applied to them.
> 
> Having arbitrary limits that are different for kmalloced bios and bioset
> allocated bios seems _very_ sketchy to me. I tend to think that
> UIO_MAXIOV check shouldn't be there at all... but if it is IMO it makes
> slightly more sense for it to apply to all bio allocations.
> 
> As you mentioned it doesn't affect the behaviour of the code, but
> supposing UIO_MAXIOV was less than BIO_MAX_PAGES, whatever was depending
> on that check would then implicitly depend on the bios not being
> allocated from a bioset. Ugly.

Please keep UIO_MAXIOV test on kmalloc case only.  If you want to
change that, please do that in a separate patch with its own
justification.

> > And we lose /** comments on two exported functions and
> > bio_alloc_bioset() comment doesn't explain that it now also handles
> > NULL bioset case.  Now that they share common implementation, you can
> > update bio_alloc_bioset() and refer to it from its wrappers but please
> > don't drop them like this.
> 
> So if I follow you, you're fine with dropping the comments from the
> single line wrappers provided their information is rolled into
> bio_alloc_bioset()'s documentation? That's what I should have done,
> I'll do that now.

Not really, for example, if you had

	/* explain A in detail */
	a() {};

and if you introduce __a() which does __A and make a its wrapper.

	/* explain __A in detail */
	__a() {};

	/* explain A briefly and refer to __a() for details */
	a() {};

Thanks.

-- 
tejun
