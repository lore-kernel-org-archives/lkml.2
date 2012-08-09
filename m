Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2HIC4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 22:56:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57476 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2HIC4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 22:56:44 -0400
Date: Wed, 8 Aug 2012 19:56:10 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 11/12] block: Add bio_clone_bioset()
Message-ID: <20120809025610.GK7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-12-git-send-email-koverstreet@google.com>
 <20120808232120.GK6983@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808232120.GK6983@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:21:20PM -0700, Tejun Heo wrote:
> On Mon, Aug 06, 2012 at 03:08:40PM -0700, Kent Overstreet wrote:
> > This consolidates some code, and will help in a later patch changing how
> > bio cloning works.
> 
> I think it would be better to introduce bio_clone*() functions in a
> separate patch and convert the users in a different one.
> 
> >  /**
> > - *	bio_clone	-	clone a bio
> > + *	bio_clone_bioset -	clone a bio
> >   *	@bio: bio to clone
> >   *	@gfp_mask: allocation priority
> > + *	@bs: bio_set to allocate from
> >   *
> >   * 	Like __bio_clone, only also allocates the returned bio
> >   */
> > -struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> > +struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
> > +			     struct bio_set *bs)
> >  {
> > -	struct bio *b = bio_alloc(gfp_mask, bio->bi_max_vecs);
> > +	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
> >  
> >  	if (!b)
> >  		return NULL;
> > @@ -485,7 +487,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> >  	if (bio_integrity(bio)) {
> >  		int ret;
> >  
> > -		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
> > +		ret = bio_integrity_clone(b, bio, gfp_mask, bs);
> >  
> >  		if (ret < 0) {
> >  			bio_put(b);
> > @@ -495,6 +497,12 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> >  
> >  	return b;
> >  }
> > +EXPORT_SYMBOL(bio_clone_bioset);
> > +
> > +struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> > +{
> > +	return bio_clone_bioset(bio, gfp_mask, fs_bio_set);
> > +}
> 
> So, bio_clone() loses its function comment.  Also, does it even make
> sense to call bio_clone() from fs_bio_set?

I'll re add the function comment if you want, just for a single line
wrapper I don't know if it's worth the cost - comments get out of date,
and they're more stuff to wade through.

> Let's say it's so, then
> what's the difference from using _kmalloc variant?

bio_kmalloc() fails if nr_iovecs > 1024, bio_alloc_bioset() fails if
nr_iovecs > 256

and bio_alloc_bioset() is mempool backed, bio_kmalloc() is not.

AFAICT that's it.
