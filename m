Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab2HIB5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 21:57:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51005 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2HIB5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 21:57:40 -0400
Date: Wed, 8 Aug 2012 18:57:04 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 10/12] block: Add bio_clone_kmalloc()
Message-ID: <20120809015704.GI7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-11-git-send-email-koverstreet@google.com>
 <20120808231552.GJ6983@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808231552.GJ6983@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:15:52PM -0700, Tejun Heo wrote:
> On Mon, Aug 06, 2012 at 03:08:39PM -0700, Kent Overstreet wrote:
> 
> How about the following?
> 
> There was no API to kmalloc bio and clone and osdblk was using
> explicit bio_kmalloc() + __bio_clone().  (my guess here) As this is
> inconvenient and there will be more users of it in the future, add
> bio_clone_kmalloc() and use it in osdblk.

Adding that.

> 
> > Acked-by: Boaz Harrosh <bharrosh@panasas.com>
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > ---
> >  drivers/block/osdblk.c |    3 +--
> >  fs/bio.c               |   13 +++++++++++++
> >  fs/exofs/ore.c         |    5 ++---
> >  include/linux/bio.h    |    1 +
> >  4 files changed, 17 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
> > index 87311eb..1bbc681 100644
> > --- a/drivers/block/osdblk.c
> > +++ b/drivers/block/osdblk.c
> > @@ -266,11 +266,10 @@ static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
> >  	struct bio *tmp, *new_chain = NULL, *tail = NULL;
> >  
> >  	while (old_chain) {
> > -		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
> > +		tmp = bio_clone_kmalloc(old_chain, gfpmask);
> >  		if (!tmp)
> >  			goto err_out;
> >  
> > -		__bio_clone(tmp, old_chain);
> >  		tmp->bi_bdev = NULL;
> >  		gfpmask &= ~__GFP_WAIT;
> >  		tmp->bi_next = NULL;
> > diff --git a/fs/bio.c b/fs/bio.c
> > index f0c865b..77b9313 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -497,6 +497,19 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> >  }
> >  EXPORT_SYMBOL(bio_clone);
> >  
> 
> /**
> 
> PLEASE.
> 
> > +struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
> > +{
> > +	struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);
> 
> Can't we use %NULL bioset as an indication to allocate from kmalloc
> instead of duping interfaces like this?

The two aren't mutually exclusive - but using BIO_KMALLOC_POOL instead
of separate interfaces is an excellent idea, I'll do that.

That means bio_clone_kmalloc will just become:

static inline struct bio *bio_clone_kmalloc(struct bio *bio,
					    gfp_t gfp_mask)
{
	return bio_clone_bioset(bio, gfp_mask, BIO_KMALLOC_POOL)
}

(or maybe NULL there, I think using NULL for the interface makes sense,
I just don't want to use it for bi_pool).

Do you still want the /** for a one line wrapper like that?


> 
> Thanks.
> 
> -- 
> tejun
