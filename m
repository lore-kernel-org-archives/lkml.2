Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab2GDKIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:08:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55386 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab2GDKIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:08:12 -0400
Date: Wed, 4 Jul 2012 11:08:09 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, jaschut@sandia.gov,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH -mm v2] mm: have order > 0 compaction start off where it
 left
Message-ID: <20120704100809.GK13141@csn.ul.ie>
References: <20120628135520.0c48b066@annuminas.surriel.com>
 <4FECE844.2050803@kernel.org>
 <4FF308CE.4070209@redhat.com>
 <4FF3AA43.1000500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4FF3AA43.1000500@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 11:28:19AM +0900, Minchan Kim wrote:
> >>> +                      zone->compact_cached_free_pfn>
> >>> +                      cc->start_free_pfn))
> >>> +            pfn = min(pfn, zone->compact_cached_free_pfn);
> >>
> >>
> >> The pfn can be where migrate_pfn below?
> >> I mean we need this?
> >>
> >> if (pfn<= low_pfn)
> >>     goto out;
> > 
> > That is a good point. I guess there is a small possibility that
> > another compaction thread is below us with cc->free_pfn and
> > cc->migrate_pfn, and we just inherited its cc->free_pfn via
> > zone->compact_cached_free_pfn, bringing us to below our own
> > cc->migrate_pfn.
> > 
> > Given that this was already possible with parallel compaction
> > in the past, I am not sure how important it is. It could result
> > in wasting a little bit of CPU, but your fix for it looks easy
> > enough.
> 
> In the past, it was impossible since we have per-compaction context free_pfn.
>  
> 
> > 
> > Mel, any downside to compaction bailing (well, wrapping around)
> > a little earlier, like Minchan suggested?
> 
> 
> I can't speak for Mel. But IMHO, if we meet such case, we can ignore compact_cached_free_pfn
> , then go with just pfn instead of early bailing.
> 

Wrapping early is not a problem. As Minchan pointed out this applies in
the case where the migrate scanner and free scanner have almost met or
have overlapped. In this case, it might even be better to wrap early
because there is no point isolating free pages that will then have to be
migrated a second time when the free scanner wraps and the migrate
scanner moves in.

-- 
Mel Gorman
SUSE Labs
