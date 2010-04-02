Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab0DBGwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:52:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:54774 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193Ab0DBGwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:52:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,352,1267430400"; 
   d="scan'208";a="609725885"
Date: Fri, 2 Apr 2010 14:52:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] readahead even for FMODE_RANDOM
Message-ID: <20100402065237.GA21508@localhost>
References: <20100401183151.GO23510@kernel.dk> <20100402012338.GA6393@localhost> <20100402063830.GR23510@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402063830.GR23510@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 02:38:30PM +0800, Jens Axboe wrote:
> On Fri, Apr 02 2010, Wu Fengguang wrote:
> > Hi Jens,
> > 
> > On Fri, Apr 02, 2010 at 02:31:51AM +0800, Jens Axboe wrote:
> > > Hi,
> > > 
> > > I got a problem report with fio where larger block size random reads
> > > where markedly slower with buffered IO than with O_DIRECT, and the
> > > initial thought was that perhaps this was some fio oddity. The reporter
> > > eventually discovered that turning off the fadvise hint made it work
> > > fine. So I took a look, and it seems we never do readahead for
> > > FMODE_RANDOM even if the request size is larger than 1 page. That seems
> > > like a bug, if an application is doing eg 16kb random reads, you want to
> > > readahead the 12kb remaining data. On devices where smaller transfer
> > > sizes are slower than larger ones, this can make a large difference.
> > > 
> > > This patch makes us readahead even for FMODE_RANDOM, iff we'll be
> > > reading more pages in that single read. I ran a quick test here, and it
> > > appears to fix the problem (no difference with fadvise POSIX_FADV_RANDOM
> > > being passed in or not).
> >  
> > I guess the application is doing (at least partial) sequential reads,
> > while at the same time tell kernel with POSIX_FADV_RANDOM that it's
> > doing random reads.
> > 
> > If so, it's mainly the application's fault.
> 
> The application is doing large random reads. It's purely random, so
> the POSIX_FADV_RANDOM hint is correct. However, thinking about it, it

How large is it? For random reads > read_ahead_kb,
ondemand_readahead() will break it into read_ahead_kb sized IOs, while
force_page_cache_readahead() won't. That may impact IO performance.

> may be that we later hit a random "block" that has now been cached due
> to this read-ahead. Let me try and rule that out completely and see if
> there's still the difference. The original reporter observed 4kb reads
> hitting the driver, where 128kb was expected.

4kb reads hit the disk (on POSIX_FADV_RANDOM)? That sounds like
behavior in pre .34 kernels that is fixed by commit 0141450f66c:

    readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM

> > However the kernel can behave more smart and less "dumb" :)
> > It can inherit the current good behavior of "submit one single 16kb io
> > request for a 16kb random read() syscall", while still be able to
> > start _larger sized_ readahead if it's actually a sequential one.
> 
> Yeah, that's an ancient issue and pretty sad.
> 
> > > diff --git a/mm/readahead.c b/mm/readahead.c
> > > index 337b20e..d4b201c 100644
> > > --- a/mm/readahead.c
> > > +++ b/mm/readahead.c
> > > @@ -501,8 +501,11 @@ void page_cache_sync_readahead(struct address_space *mapping,
> > >  	if (!ra->ra_pages)
> > >  		return;
> > >  
> > > -	/* be dumb */
> > > -	if (filp->f_mode & FMODE_RANDOM) {
> > > +	/*
> > > +	 * Be dumb for files marked as randomly accessed, but do readahead
> > > +	 * inside the original request (req_size > 1).
> > > +	 */
> > > +	if ((filp->f_mode & FMODE_RANDOM) && req_size == 1) {
> > >  		force_page_cache_readahead(mapping, filp, offset, req_size);
> > >  		return;
> > >  	}
> > 
> > The patch only fixes the (req_size != 1) case that exposed by your
> > application. A complete fix would be 
> > 
> > @@ -820,12 +825,6 @@ void page_cache_sync_readahead(struct ad
> >  	if (!ra->ra_pages)
> >  		return;
> >  
> > -	/* be dumb */
> > -	if (filp->f_mode & FMODE_RANDOM) {
> > -		force_page_cache_readahead(mapping, filp, offset, req_size);
> > -		return;
> > -	}
> > -
> 
> Hmm, are we talking about the same thing? I want to hit read-ahead for
> the remaining pages inside that random read, eg ensure that read-ahead
> gets activated inside that window of the random request.

I think Yes. When the above block is gone, ondemand_readahead() will
be invoked, and the readahead heuristic will find that it's an
oversize read (whose size is > 128k) and start 128kb readahead for it.

Thanks,
Fengguang

> >  	/* do read-ahead */
> >  	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
> >  }
> > 
> > And a more optimized patch would look like this.  Note that only the
> > last chunk is necessary for bug fixing, and only this chunk can be
> > applied to vanilla 2.6.34-rc3.
> > 
> > If no problem, I'll submit a patch with only the last chunk for
> > 2.6.34, and submit the remaining chunks for 2.6.35.
> > 
> > Thanks,
> > Fengguang
> > ---
> > Subject: readahead: more smart readahead on POSIX_FADV_RANDOM
> > From: Wu Fengguang <fengguang.wu@intel.com>
> > Date: Fri Apr 02 08:52:42 CST 2010
> > 
> > Some times user space applications will tell POSIX_FADV_RANDOM
> > while still doing some sequential reads.
> > 
> > The kernel can behave a bit smarter in this case, by letting the
> > readahead heuristics handle the POSIX_FADV_RANDOM case, but with
> > less aggressive assumption on sequential reads.
> 
> I'll try and give this a spin. On the laptop, I cannot reproduce the
> problem of smaller < reqsize ios, so hard to say just now.
> 
> > 
> > CC: Jens Axboe <jens.axboe@oracle.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  mm/readahead.c |   17 ++++++++---------
> >  1 file changed, 8 insertions(+), 9 deletions(-)
> > 
> > --- linux.orig/mm/readahead.c	2010-04-02 08:43:53.000000000 +0800
> > +++ linux/mm/readahead.c	2010-04-02 09:00:51.000000000 +0800
> > @@ -664,6 +664,7 @@ ondemand_readahead(struct address_space 
> >  	unsigned long max = max_sane_readahead(ra->ra_pages);
> >  	unsigned long tt;  /* thrashing shreshold */
> >  	pgoff_t start;
> > +	bool random_hint = (filp && (filp->f_mode & FMODE_RANDOM));
> >  
> >  	/*
> >  	 * start of file
> > @@ -671,7 +672,8 @@ ondemand_readahead(struct address_space 
> >  	if (!offset) {
> >  		ra_set_pattern(ra, RA_PATTERN_INITIAL);
> >  		ra->start = offset;
> > -		if ((ra->ra_flags & READAHEAD_LSEEK) && req_size <= max) {
> > +		if ((random_hint || (ra->ra_flags & READAHEAD_LSEEK)) &&
> > +		    req_size <= max) {
> >  			ra->size = req_size;
> >  			ra->async_size = 0;
> >  			goto readit;
> > @@ -743,8 +745,11 @@ context_readahead:
> >  	} else
> >  		start = offset;
> >  
> > -	tt = count_history_pages(mapping, ra, offset,
> > -				 READAHEAD_ASYNC_RATIO * max);
> > +	if (unlikely(random_hint))
> > +		tt = 0;
> > +	else
> > +		tt = count_history_pages(mapping, ra, offset,
> > +					 READAHEAD_ASYNC_RATIO * max);
> >  	/*
> >  	 * no history pages cached, could be
> >  	 * 	- a random read
> > @@ -820,12 +825,6 @@ void page_cache_sync_readahead(struct ad
> >  	if (!ra->ra_pages)
> >  		return;
> >  
> > -	/* be dumb */
> > -	if (filp->f_mode & FMODE_RANDOM) {
> > -		force_page_cache_readahead(mapping, filp, offset, req_size);
> > -		return;
> > -	}
> > -
> >  	/* do read-ahead */
> >  	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
> >  }
> 
> -- 
> Jens Axboe
