Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab2IKT0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:26:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2IKT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:26:45 -0400
Date: Tue, 11 Sep 2012 12:26:41 -0700
From: Kent Overstreet <koverstreet@google.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org
Subject: Re: [PATCH v2 13/26] raid5: use bio_reset()
Message-ID: <20120911192641.GH19739@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-14-git-send-email-koverstreet@google.com>
 <20120911150326.79f066c0@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911150326.79f066c0@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 03:03:26PM +1000, NeilBrown wrote:
> On Mon, 10 Sep 2012 17:22:24 -0700 Kent Overstreet <koverstreet@google.com>
> wrote:
> 
> > Had to shuffle the code around a bit (where bi_rw and bi_end_io were
> > set), but shouldn't really be anything tricky here
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: NeilBrown <neilb@suse.de>
> > ---
> >  drivers/md/raid5.c | 28 ++++++++++++++--------------
> >  1 file changed, 14 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 7c19dbe..ebe43f7 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -561,14 +561,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  		bi = &sh->dev[i].req;
> >  		rbi = &sh->dev[i].rreq; /* For writing to replacement */
> >  
> > -		bi->bi_rw = rw;
> > -		rbi->bi_rw = rw;
> > -		if (rw & WRITE) {
> > -			bi->bi_end_io = raid5_end_write_request;
> > -			rbi->bi_end_io = raid5_end_write_request;
> > -		} else
> > -			bi->bi_end_io = raid5_end_read_request;
> > -
> >  		rcu_read_lock();
> >  		rrdev = rcu_dereference(conf->disks[i].replacement);
> >  		smp_mb(); /* Ensure that if rrdev is NULL, rdev won't be */
> > @@ -643,7 +635,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  
> >  			set_bit(STRIPE_IO_STARTED, &sh->state);
> >  
> > +			bio_reset(bi);
> >  			bi->bi_bdev = rdev->bdev;
> > +			bi->bi_rw = rw;
> > +			bi->bi_end_io = (rw & WRITE)
> > +				? raid5_end_write_request
> > +				: raid5_end_read_request;
> > +			bi->bi_private = sh;
> > +
> >  			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
> >  				__func__, (unsigned long long)sh->sector,
> >  				bi->bi_rw, i);
> > @@ -657,12 +656,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> >  				bi->bi_rw |= REQ_FLUSH;
> >  
> > -			bi->bi_flags = 1 << BIO_UPTODATE;
> > -			bi->bi_idx = 0;
> >  			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> >  			bi->bi_io_vec[0].bv_offset = 0;
> >  			bi->bi_size = STRIPE_SIZE;
> > -			bi->bi_next = NULL;
> >  			if (rrdev)
> >  				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
> >  			generic_make_request(bi);
> > @@ -674,7 +670,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  
> >  			set_bit(STRIPE_IO_STARTED, &sh->state);
> >  
> > +			bio_reset(rbi);
> >  			rbi->bi_bdev = rrdev->bdev;
> > +			rbi->bi_rw = rw;
> > +			rbi->bi_end_io = (rw & WRITE)
> > +				? raid5_end_write_request
> > +				: raid5_end_read_request;
> 
> 'rbi->bi_end_io' can only ever be raid5_end_write_request.  We only get here
> on a write.
> I'd be OK with 
>     BUG_ON(!(rw & WRITE));
> but I don't want the condition in the assignment.

I was thinking to myself that if I was doing a bit more with that code,
I'd factor out all the code in the if (rdev) {} into a separate function
that was called twice there. But, I didn't do that here so you're right
- I'll change it and stick a BUG_ON() there.

> The rest looks quite sane.

Thanks!
