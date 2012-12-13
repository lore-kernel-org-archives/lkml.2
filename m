Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2LMPaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:30:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab2LMPaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:30:01 -0500
Date: Thu, 13 Dec 2012 16:29:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
Message-ID: <20121213152959.GE21644@dhcp22.suse.cz>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
 <20121213103420.GW1009@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213103420.GW1009@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-12-12 10:34:20, Mel Gorman wrote:
> On Wed, Dec 12, 2012 at 04:43:34PM -0500, Johannes Weiner wrote:
> > When a reclaim scanner is doing its final scan before giving up and
> > there is swap space available, pay no attention to swappiness
> > preference anymore.  Just swap.
> > 
> > Note that this change won't make too big of a difference for general
> > reclaim: anonymous pages are already force-scanned when there is only
> > very little file cache left, and there very likely isn't when the
> > reclaimer enters this final cycle.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Ok, I see the motivation for your patch but is the block inside still
> wrong for what you want? After your patch the block looks like this
> 
>                 if (sc->priority || noswap) {
>                         scan >>= sc->priority;
>                         if (!scan && force_scan)
>                                 scan = SWAP_CLUSTER_MAX;
>                         scan = div64_u64(scan * fraction[file], denominator);
>                 }
> 
> if sc->priority == 0 and swappiness==0 then you enter this block but
> fraction[0] for anonymous pages will also be 0 and because of the ordering
> of statements there, scan will be
> 
> scan = scan * 0 / denominator
> 
> so you are still not reclaiming anonymous pages in the swappiness=0
> case. What did I miss?

Yes, now that you have mentioned that I realized that it really doesn't
make any sense. fraction[0] is _always_ 0 for swappiness==0. So we just
made a bigger pressure on file LRUs. So this sounds like a misuse of the
swappiness. This all has been introduced with fe35004f (mm: avoid
swapping out with swappiness==0).

I think that removing swappiness check make sense but I am not sure it
does what the changelog says. It should have said that checking
swappiness doesn't make any sense for small LRUs.
-- 
Michal Hocko
SUSE Labs
