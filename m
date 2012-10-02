Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab2JBVAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:00:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33760 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2JBVAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:00:10 -0400
Date: Tue, 2 Oct 2012 14:00:06 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Message-ID: <20121002210006.GS26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
 <20121002153736.GA3283@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002153736.GA3283@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:37:37AM -0400, Vivek Goyal wrote:
> On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:
> 
> [..]
> >  /**
> >   * bio_integrity_alloc - Allocate integrity payload and attach it to bio
> >   * @bio:	bio to attach integrity metadata to
> > @@ -84,37 +47,39 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
> >  						  unsigned int nr_vecs)
> >  {
> >  	struct bio_integrity_payload *bip;
> > -	unsigned int idx = vecs_to_idx(nr_vecs);
> >  	struct bio_set *bs = bio->bi_pool;
> > +	unsigned long idx = BIO_POOL_NONE;
> > +	unsigned inline_vecs;
> > +
> > +	if (!bs) {
> > +		bip = kmalloc(sizeof(struct bio_integrity_payload) +
> > +			      sizeof(struct bio_vec) * nr_vecs, gfp_mask);
> > +		inline_vecs = nr_vecs;
> > +	} else {
> > +		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
> > +		inline_vecs = BIP_INLINE_VECS;
> > +	}
> >  
> > -	if (!bs)
> > -		bs = fs_bio_set;
> 
> Ok, this is change of behavior. Previously we will fall back to fs_bio_set
> and now you do kmalloc. This change looks to be independent of bip_vec
> pointer. Can you please break it out in a separate patch and also explain
> that how does this change help.

I'm not sure it's worth breaking out into a separate patch, but I
definitely should've mentioned it in the patch description.

It just didn't make sense to be using fs_bio_set if a bio_set wasn't
specified before - if a bio set wasn't specified we're still using
kmalloc for the bio_integrity_payload, so we're not protected from
memory allocation failures and it doesn't buy us anything.

All it does is introduce the possibility of deadlock, if we weren't
supposed to be using fs_bio_set for whatever reason.
