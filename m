Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2JBWC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:02:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478Ab2JBWC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:02:26 -0400
Date: Tue, 2 Oct 2012 18:02:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Message-ID: <20121002220216.GC14471@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
 <20121002153736.GA3283@redhat.com>
 <20121002210006.GS26488@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002210006.GS26488@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 02:00:06PM -0700, Kent Overstreet wrote:
> On Tue, Oct 02, 2012 at 11:37:37AM -0400, Vivek Goyal wrote:
> > On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:
> > 
> > [..]
> > >  /**
> > >   * bio_integrity_alloc - Allocate integrity payload and attach it to bio
> > >   * @bio:	bio to attach integrity metadata to
> > > @@ -84,37 +47,39 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
> > >  						  unsigned int nr_vecs)
> > >  {
> > >  	struct bio_integrity_payload *bip;
> > > -	unsigned int idx = vecs_to_idx(nr_vecs);
> > >  	struct bio_set *bs = bio->bi_pool;
> > > +	unsigned long idx = BIO_POOL_NONE;
> > > +	unsigned inline_vecs;
> > > +
> > > +	if (!bs) {
> > > +		bip = kmalloc(sizeof(struct bio_integrity_payload) +
> > > +			      sizeof(struct bio_vec) * nr_vecs, gfp_mask);
> > > +		inline_vecs = nr_vecs;
> > > +	} else {
> > > +		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
> > > +		inline_vecs = BIP_INLINE_VECS;
> > > +	}
> > >  
> > > -	if (!bs)
> > > -		bs = fs_bio_set;
> > 
> > Ok, this is change of behavior. Previously we will fall back to fs_bio_set
> > and now you do kmalloc. This change looks to be independent of bip_vec
> > pointer. Can you please break it out in a separate patch and also explain
> > that how does this change help.
> 
> I'm not sure it's worth breaking out into a separate patch, but I
> definitely should've mentioned it in the patch description.

It helps a lot with reviewing the patches. 
> 
> It just didn't make sense to be using fs_bio_set if a bio_set wasn't
> specified before - if a bio set wasn't specified we're still using
> kmalloc for the bio_integrity_payload, so we're not protected from
> memory allocation failures and it doesn't buy us anything.
> 
> All it does is introduce the possibility of deadlock, if we weren't
> supposed to be using fs_bio_set for whatever reason.

I think more people will be willing to review patches if you break
them down in to small patches with proper explanation. This particular
change is orthogonal to allocating integrity vecs from bioset. So
really think it does make sense to keep this change in a separate
patch with proper changelog.

Thanks
Vivek
