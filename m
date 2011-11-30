Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab1K3AhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 19:37:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:34325 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab1K3AhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 19:37:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,594,1315206000"; 
   d="scan'208";a="80434297"
Date: Wed, 30 Nov 2011 08:37:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "Li, Shaohua" <shaohua.li@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] readahead: basic support for backwards prefetching
Message-ID: <20111130003716.GA11147@localhost>
References: <20111129130900.628549879@intel.com>
 <20111129131456.925952168@intel.com>
 <20111129153552.GP5635@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129153552.GP5635@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(snip)
> > @@ -676,6 +677,20 @@ ondemand_readahead(struct address_space 
> >  	}
> >  
> >  	/*
> > +	 * backwards reading
> > +	 */
> > +	if (offset < ra->start && offset + req_size >= ra->start) {
> > +		ra->pattern = RA_PATTERN_BACKWARDS;
> > +		ra->size = get_next_ra_size(ra, max);
> > +		max = ra->start;
> > +		if (ra->size > max)
> > +			ra->size = max;
> > +		ra->async_size = 0;
> > +		ra->start -= ra->size;
>   IMHO much more obvious way to write this is:
> ra->size = get_next_ra_size(ra, max);
> if (ra->size > ra->start) {
>   ra->size = ra->start;
>   ra->start = 0;
> } else
>   ra->start -= ra->size;

Good idea! Here is the updated code:

        /*
         * backwards reading
         */
        if (offset < ra->start && offset + req_size >= ra->start) {
                ra->pattern = RA_PATTERN_BACKWARDS;
                ra->size = get_next_ra_size(ra, max);
                if (ra->size > ra->start) {
                        /*
                         * ra->start may be concurrently set to some huge
                         * value, the min() at least avoids submitting huge IO
                         * in this race condition
                         */
                        ra->size = min(ra->start, max);
                        ra->start = 0;
                } else
                        ra->start -= ra->size;
                ra->async_size = 0;
                goto readit;
        }

Thanks,
Fengguang
