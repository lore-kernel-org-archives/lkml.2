Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab2DKRwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:52:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508Ab2DKRwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:52:20 -0400
Date: Wed, 11 Apr 2012 18:52:15 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Removal of lumpy reclaim V2
Message-ID: <20120411175215.GI3789@suse.de>
References: <1334162298-18942-1-git-send-email-mgorman@suse.de>
 <4F85BC8E.3020400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4F85BC8E.3020400@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 01:17:02PM -0400, Rik van Riel wrote:
> On 04/11/2012 12:38 PM, Mel Gorman wrote:
> 
> >Success rates are completely hosed for 3.4-rc2 which is almost certainly
> >due to [fe2c2a10: vmscan: reclaim at order 0 when compaction is enabled]. I
> >expected this would happen for kswapd and impair allocation success rates
> >(https://lkml.org/lkml/2012/1/25/166) but I did not anticipate this much
> >a difference: 80% less scanning, 37% less reclaim by kswapd
> 
> Also, no gratuitous pageouts of anonymous memory.
> That was what really made a difference on a somewhat
> heavily loaded desktop + kvm workload.
> 

Indeed.

> >In comparison, reclaim/compaction is not aggressive and gives up easily
> >which is the intended behaviour. hugetlbfs uses __GFP_REPEAT and would be
> >much more aggressive about reclaim/compaction than THP allocations are. The
> >stress test above is allocating like neither THP or hugetlbfs but is much
> >closer to THP.
> 
> Next step: get rid of __GFP_NO_KSWAPD for THP, first
> in the -mm kernel
> 

Initially the flag was introduced because kswapd reclaimed too
aggressively. One would like to believe that it would be less of a problem
now but we must avoid a situation where the CPU and reclaim cost of kswapd
exceeds the benefit of allocating a THP.

> >Mainline is now impaired in terms of high order allocation under heavy load
> >although I do not know to what degree as I did not test with __GFP_REPEAT.
> >Keep this in mind for bugs related to hugepage pool resizing, THP allocation
> >and high order atomic allocation failures from network devices.
> 
> This might be due to smaller allocations not bumping
> the compaction deferring code, when we have deferred
> compaction for a higher order allocation.
> 

It's one possibility but in this case I am not inclined to blame memory
compaction as such although there is some indication that there is a bug in
the free scanner that would make compaction less effective than it should be.

> I wonder if the compaction deferring code is simply
> too defer-happy, now that we ignore compaction at
> lower orders than where compaction failed?

I do not think it's a compaction deferral problem. We do not record
statistics on how often we defer compaction but if you look at the compaction
statistics you'll see that "Compaction stalls" and "Compaction pages moved"
figures are much higher. This implies that we are using compaction more
aggressively in 3.4-rc2 instead of deferring more.

You may also note that "Compaction success" figures are more or less the
same as 3.3 but that "Compaction failures" are higher. This indicates that
in 3.2 the high success rate was partially due to lumpy reclaim freeing
up the contiguous page before memory compaction was needed in memory
pressure situations.  If that is accurate then adjusting the logic in
should_continue_reclaim() for reclaim/compaction may partially address
the issue but not 100% of the way as reclaim/compaction will still be
racing with other allocation requests. This race is likely to be tigher
now because an accidental side-effect of lumpy reclaim was to throttle
parallel allocations requests in swap. It may not be very
straight-forward to fix :)

-- 
Mel Gorman
SUSE Labs
