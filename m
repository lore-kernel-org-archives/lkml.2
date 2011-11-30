Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab1K3LVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:21:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab1K3LVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:21:48 -0500
Date: Wed, 30 Nov 2011 12:21:46 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "Li, Shaohua" <shaohua.li@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] readahead: basic support for backwards prefetching
Message-ID: <20111130112146.GB4541@quack.suse.cz>
References: <20111129130900.628549879@intel.com>
 <20111129131456.925952168@intel.com>
 <20111129153552.GP5635@quack.suse.cz>
 <20111130003716.GA11147@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130003716.GA11147@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-11-11 08:37:16, Wu Fengguang wrote:
> (snip)
> > > @@ -676,6 +677,20 @@ ondemand_readahead(struct address_space 
> > >  	}
> > >  
> > >  	/*
> > > +	 * backwards reading
> > > +	 */
> > > +	if (offset < ra->start && offset + req_size >= ra->start) {
> > > +		ra->pattern = RA_PATTERN_BACKWARDS;
> > > +		ra->size = get_next_ra_size(ra, max);
> > > +		max = ra->start;
> > > +		if (ra->size > max)
> > > +			ra->size = max;
> > > +		ra->async_size = 0;
> > > +		ra->start -= ra->size;
> >   IMHO much more obvious way to write this is:
> > ra->size = get_next_ra_size(ra, max);
> > if (ra->size > ra->start) {
> >   ra->size = ra->start;
> >   ra->start = 0;
> > } else
> >   ra->start -= ra->size;
> 
> Good idea! Here is the updated code:
> 
>         /*
>          * backwards reading
>          */
>         if (offset < ra->start && offset + req_size >= ra->start) {
>                 ra->pattern = RA_PATTERN_BACKWARDS;
>                 ra->size = get_next_ra_size(ra, max);
>                 if (ra->size > ra->start) {
>                         /*
>                          * ra->start may be concurrently set to some huge
>                          * value, the min() at least avoids submitting huge IO
>                          * in this race condition
>                          */
>                         ra->size = min(ra->start, max);
>                         ra->start = 0;
>                 } else
>                         ra->start -= ra->size;
>                 ra->async_size = 0;
>                 goto readit;
>         }
  Looks good. You can add:
Acked-by: Jan Kara <jack@suse.cz>
  to the patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
