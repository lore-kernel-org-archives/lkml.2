Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819Ab1KJOWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:22:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934648Ab1KJOWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:22:07 -0500
Date: Thu, 10 Nov 2011 14:22:03 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111110142202.GE3083@suse.de>
References: <20111110100616.GD3083@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111110100616.GD3083@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:06:16AM +0000, Mel Gorman wrote:
> than stall. It was suggested that __GFP_NORETRY be used instead of
> __GFP_NO_KSWAPD. This would look less like a special case but would
> still cause compaction to run at least once with sync compaction.
> 

This comment is bogus - __GFP_NORETRY would have caught THP allocations
and would not call sync compaction. The issue was that it would also
have caught any hypothetical high-order GFP_THISNODE allocations that
end up calling compaction here

                /*
                 * High-order allocations do not necessarily loop after
                 * direct reclaim and reclaim/compaction depends on
                 * compaction being called after reclaim so call directly if
                 * necessary
                 */
                page = __alloc_pages_direct_compact(gfp_mask, order,
                                        zonelist, high_zoneidx,
                                        nodemask,
                                        alloc_flags, preferred_zone,
                                        migratetype, &did_some_progress,
                                        sync_migration);

__GFP_NORETRY is used in a bunch of places and while the most
of them are not high-order, some of them potentially are like in
sound/core/memalloc.c. Using __GFP_NO_KSWAPD as the flag allows
these callers to continue using sync compaction.  It could be argued
that they would prefer __GFP_NORETRY but the potential side-effects
should be taken should be taken into account and the comment updated
if that happens.

-- 
Mel Gorman
SUSE Labs
