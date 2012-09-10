Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2IJPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:25:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab2IJPZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:25:25 -0400
Date: Mon, 10 Sep 2012 11:25:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        david@fromorbit.com
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120910152508.GD639@redhat.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
 <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910002810.GA23241@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 05:28:10PM -0700, Kent Overstreet wrote:

[..]
> > > +retry:
> > >  		p = mempool_alloc(bs->bio_pool, gfp_mask);
> > >  		front_pad = bs->front_pad;
> > >  		inline_vecs = BIO_INLINE_VECS;
> > >  	}
> > 
> > Wouldn't the following be better?
> > 
> > 	p = mempool_alloc(bs->bi_pool, gfp_mask);
> > 	if (unlikely(!p) && gfp_mask != saved_gfp) {
> > 		punt_bios_to_rescuer(bs);
> > 		p = mempool_alloc(bs->bi_pool, saved_gfp);
> > 	}
> 
> That'd require duplicating the error handling in two different places -
> once for the initial allocation, once for the bvec allocation. And I
> really hate that writing code that does
> 
> alloc_something()
> if (fail) {
> 	alloc_something_again()
> }
> 
> it just screams ugly to me.

Personally I kind of like Tejun's suggestion. Yes, it means that you
will have to do it twice (once for bio and once for bvecs). But at
the same time, if bvec allocation fails, then you don't have to free
already allocated bio and retry bio allocation again.  Current code
is doing that and I am not sure why should we free allocated bio and
retry again in case of bvec allocation failure.

Secondly current code is doing following.

                if (unlikely(!bvl))
                        goto err_free;

err_free:
	mempool_free(p, bs->bio_pool);
err:
	retry_allocation.

Not sure but err_free kind of gives impression that free up whatever
is allocated path, and return NULL. Instead of we end up retrying
allocation.

Implementing Tejun's idea atleast keeps error and retry code separate.
I am not too particular about it. Just a thought. Though I do want to
know why to free up already allocated bio and retry in case of bvec
allocation failure.

Thanks
Vivek
