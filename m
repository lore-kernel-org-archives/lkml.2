Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967663Ab2ERVOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:14:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52811 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967427Ab2ERVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:14:07 -0400
Date: Fri, 18 May 2012 14:14:03 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 05/13] block: Only clone bio vecs that are in use
Message-ID: <20120518211403.GE9673@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <cb68d8803c2ada3becdf1bd6c9bed280c38d3265.1337308722.git.koverstreet@google.com>
 <20120518161334.GE19388@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518161334.GE19388@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 09:13:34AM -0700, Tejun Heo wrote:
> On Thu, May 17, 2012 at 10:59:52PM -0400, koverstreet@google.com wrote:
> > diff --git a/fs/bio.c b/fs/bio.c
> > index e2c0970..de0733e 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -435,8 +435,9 @@ EXPORT_SYMBOL(bio_phys_segments);
> >   */
> >  void __bio_clone(struct bio *bio, struct bio *bio_src)
> >  {
> > -	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
> > -		bio_src->bi_max_vecs * sizeof(struct bio_vec));
> > +	memcpy(bio->bi_io_vec,
> > +	       bio_iovec(bio_src),
> 
> Unnecessary line break.
> 
> > +	       bio_segments(bio_src) * sizeof(struct bio_vec));
> >  
> >  	/*
> >  	 * most users will be overriding ->bi_bdev with a new target,
> > @@ -445,10 +446,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
> >  	bio->bi_sector = bio_src->bi_sector;
> >  	bio->bi_bdev = bio_src->bi_bdev;
> >  	bio->bi_flags |= 1 << BIO_CLONED;
> > +	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
> 
> Can probably be conditionalized on bi_idx?

I've never been that clear on the semantics of BIO_SEG_VALID. I'll defer
to you on that.
