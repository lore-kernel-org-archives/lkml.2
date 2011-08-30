Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab1H3Twz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212Ab1H3Twy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:52:54 -0400
Date: Tue, 30 Aug 2011 15:52:02 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Dave Chinner <david@fromorbit.com>
cc: Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shrinker: fix a bug when callback returns -1
In-Reply-To: <20110830021333.GL3162@dastard>
Message-ID: <Pine.LNX.4.64.1108301511110.9551@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108291534140.19003@hs20-bc2-1.build.redhat.com>
 <20110830021333.GL3162@dastard>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011, Dave Chinner wrote:

> On Mon, Aug 29, 2011 at 03:36:48PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > This patch fixes a lockup when shrinker callback returns -1.
> 
> What lockup is that? I haven't seen any bug reports, and this code
> has been like this for several years, so I'm kind of wondering why
> this is suddenly an issue....

I got the lockups when modifying my own dm-bufio code to use the shrinker. 
The reason for lockups was that the variable total_scan contained 
extremely high values.

The only possible way how such extreme values could be stored in 
total_scan was this:

max_pass = do_shrinker_shrink(shrinker, shrink, 0);
delta = (4 * nr_pages_scanned) / shrinker->seeks;
delta *= max_pass;
do_div(delta, lru_pages + 1);
total_scan += delta;

--- you don't test if do_shinker_shrink retuned -1 here. The variables are 
unsigned long, so you end up adding extreme value (approximately 
2^64/(lru_pages+1) to total_scan.

Note that some existing shrinkers contain workaround for this (something 
like "return nr_to_scan ? -1 : 0", while some can still return -1 when 
nr_to_scan is 0 and trigger this bug (prune_super).

> > BTW. shouldn't the value returned by callback be long instead of int? On 
> > 64-bit architectures, there may be more than 2^32 entries allocated.
> 
> The API hasn't changed since the early 2.5 series, so that wasn't a
> consideration when it was originally written. As it is, I make this
> exact change in the shrinker API update patchset I proposed
> recently for exactly the reasons you suggest:
> 
> http://thread.gmane.org/gmane.linux.kernel.mm/67326
> 
> 
> > Mikulas
> > 
> > ---
> > 
> > shrinker: fix a bug when callback returns -1
> > 
> > Shrinker callback can return -1 if it is at a risk of deadlock.
> > However, this is not tested at some places.
> > 
> > If do_shrinker_shrink returns -1 here
> > "max_pass = do_shrinker_shrink(shrinker, shrink, 0)",
> > it is converted to an unsigned long integer. This may result in excessive
> > total_scan value and a lockup due to code looping too much in
> > "while (total_scan >= batch_size)" cycle.
> 
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  mm/vmscan.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > Index: linux-3.1-rc3-fast/mm/vmscan.c
> > ===================================================================
> > --- linux-3.1-rc3-fast.orig/mm/vmscan.c	2011-08-29 20:34:27.000000000 +0200
> > +++ linux-3.1-rc3-fast/mm/vmscan.c	2011-08-29 20:37:38.000000000 +0200
> > @@ -250,6 +250,7 @@ unsigned long shrink_slab(struct shrink_
> >  		unsigned long long delta;
> >  		unsigned long total_scan;
> >  		unsigned long max_pass;
> > +		int sr;
> >  		int shrink_ret = 0;
> >  		long nr;
> >  		long new_nr;
> > @@ -266,7 +267,10 @@ unsigned long shrink_slab(struct shrink_
> >  		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
> >  
> >  		total_scan = nr;
> > -		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
> > +		sr = do_shrinker_shrink(shrinker, shrink, 0);
> > +		if (sr == -1)
> > +			continue;
> 
> IIRC from my recent shrinker audit, none of the existing shrinkers
> return return -1 when nr_to_scan == 0, so this check has never been
> necessary.
> 
> > +		max_pass = sr;
> >  		delta = (4 * nr_pages_scanned) / shrinker->seeks;
> >  		delta *= max_pass;
> >  		do_div(delta, lru_pages + 1);
> > @@ -309,6 +313,8 @@ unsigned long shrink_slab(struct shrink_
> >  			int nr_before;
> >  
> >  			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
> > +			if (nr_before == -1)
> > +				break;
> 
> Same here.
> 
> >  			shrink_ret = do_shrinker_shrink(shrinker, shrink,
> >  							batch_size);
> >  			if (shrink_ret == -1)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
