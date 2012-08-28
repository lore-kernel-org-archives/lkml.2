Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2H1W2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:28:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2H1W2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:28:34 -0400
Date: Tue, 28 Aug 2012 15:28:00 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120828222800.GG1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <20120828204910.GG24608@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828204910.GG24608@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:49:10PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 28, 2012 at 10:37:36AM -0700, Kent Overstreet wrote:
> > @@ -324,13 +342,37 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> >  		front_pad = 0;
> >  		inline_vecs = nr_iovecs;
> >  	} else {
> > +		/*
> > +		 * generic_make_request() converts recursion to iteration; this
> > +		 * means if we're running beneath it, any bios we allocate and
> > +		 * submit will not be submitted (and thus freed) until after we
> > +		 * return.
> > +		 *
> > +		 * This exposes us to a potential deadlock if we allocate
> > +		 * multiple bios from the same bio_set() while running
> > +		 * underneath generic_make_request(). If we were to allocate
> > +		 * multiple bios (say a stacking block driver that was splitting
> > +		 * bios), we would deadlock if we exhausted the mempool's
> > +		 * reserve.
> > +		 *
> > +		 * We solve this, and guarantee forward progress, with a rescuer
> > +		 * workqueue per bio_set. If we go to allocate and there are
> > +		 * bios on current->bio_list, we first try the allocation
> > +		 * without __GFP_WAIT; if that fails, we punt those bios we
> > +		 * would be blocking to the rescuer workqueue before we retry
> > +		 * with the original gfp_flags.
> > +		 */
> > +
> > +		if (current->bio_list && !bio_list_empty(current->bio_list))
> > +			gfp_mask &= ~__GFP_WAIT;
> > +retry:
> >  		p = mempool_alloc(bs->bio_pool, gfp_mask);
> >  		front_pad = bs->front_pad;
> >  		inline_vecs = BIO_INLINE_VECS;
> >  	}
> >  
> >  	if (unlikely(!p))
> > -		return NULL;
> > +		goto err;
> >  
> >  	bio = p + front_pad;
> >  	bio_init(bio);
> > @@ -351,6 +393,19 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> >  
> >  err_free:
> >  	mempool_free(p, bs->bio_pool);
> > +err:
> > +	if (gfp_mask != saved_gfp) {
> > +		gfp_mask = saved_gfp;
> > +
> > +		spin_lock(&bs->rescue_lock);
> > +		bio_list_merge(&bs->rescue_list, current->bio_list);
> > +		bio_list_init(current->bio_list);
> > +		spin_unlock(&bs->rescue_lock);
> > +
> > +		queue_work(bs->rescue_workqueue, &bs->rescue_work);
> > +		goto retry;
> > +	}
> 
> I wonder whether it would be easier to follow if this part is in-line
> where retry: is.  All that needs to be duplicated is single
> mempool_alloc() call, right?

Actually, what might be better than both of those approaches is shoving
that code into another function. Then it's just:

if (gfp_mask != saved_gfp) {
	gfp_mask = saved_gfp;
	shovel_bios_to_rescuer();
	goto retry;
}

> Overall, I *think* this is correct but need to think more about it to
> be sure.

Please do. As much time as I've spent staring at this kind of stuff,
I'm pretty sure I've got it correct but it still makes my head hurt to
work out all the various possible deadlocks.
