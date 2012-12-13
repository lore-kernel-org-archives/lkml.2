Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2LMKeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 05:34:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2LMKeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 05:34:23 -0500
Date: Thu, 13 Dec 2012 10:34:20 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
Message-ID: <20121213103420.GW1009@suse.de>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 04:43:34PM -0500, Johannes Weiner wrote:
> When a reclaim scanner is doing its final scan before giving up and
> there is swap space available, pay no attention to swappiness
> preference anymore.  Just swap.
> 
> Note that this change won't make too big of a difference for general
> reclaim: anonymous pages are already force-scanned when there is only
> very little file cache left, and there very likely isn't when the
> reclaimer enters this final cycle.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Ok, I see the motivation for your patch but is the block inside still
wrong for what you want? After your patch the block looks like this

                if (sc->priority || noswap) {
                        scan >>= sc->priority;
                        if (!scan && force_scan)
                                scan = SWAP_CLUSTER_MAX;
                        scan = div64_u64(scan * fraction[file], denominator);
                }

if sc->priority == 0 and swappiness==0 then you enter this block but
fraction[0] for anonymous pages will also be 0 and because of the ordering
of statements there, scan will be

scan = scan * 0 / denominator

so you are still not reclaiming anonymous pages in the swappiness=0
case. What did I miss?

-- 
Mel Gorman
SUSE Labs
