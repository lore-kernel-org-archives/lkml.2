Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2LMKHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 05:07:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab2LMKHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 05:07:09 -0500
Date: Thu, 13 Dec 2012 10:07:05 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] mm: memcg: only evict file pages when we have plenty
Message-ID: <20121213100704.GV1009@suse.de>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-2-git-send-email-hannes@cmpxchg.org>
 <50C8FCE0.1060408@redhat.com>
 <20121212222844.GA10257@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121212222844.GA10257@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 05:28:44PM -0500, Johannes Weiner wrote:
> On Wed, Dec 12, 2012 at 04:53:36PM -0500, Rik van Riel wrote:
> > On 12/12/2012 04:43 PM, Johannes Weiner wrote:
> > >dc0422c "mm: vmscan: only evict file pages when we have plenty" makes

You are using some internal tree for that commit. Now that it's upstream
it is commit e9868505987a03a26a3979f27b82911ccc003752.

> > >a point of not going for anonymous memory while there is still enough
> > >inactive cache around.
> > >
> > >The check was added only for global reclaim, but it is just as useful
> > >for memory cgroup reclaim.
> > >
> > >Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > >---
> > >  mm/vmscan.c | 19 ++++++++++---------
> > >  1 file changed, 10 insertions(+), 9 deletions(-)
> > >
> > >diff --git a/mm/vmscan.c b/mm/vmscan.c
> > >index 157bb11..3874dcb 100644
> > >--- a/mm/vmscan.c
> > >+++ b/mm/vmscan.c
> > >@@ -1671,6 +1671,16 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
> > >  		denominator = 1;
> > >  		goto out;
> > >  	}
> > >+	/*
> > >+	 * There is enough inactive page cache, do not reclaim
> > >+	 * anything from the anonymous working set right now.
> > >+	 */
> > >+	if (!inactive_file_is_low(lruvec)) {
> > >+		fraction[0] = 0;
> > >+		fraction[1] = 1;
> > >+		denominator = 1;
> > >+		goto out;
> > >+	}
> > >
> > >  	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
> > >  		get_lru_size(lruvec, LRU_INACTIVE_ANON);
> > >@@ -1688,15 +1698,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
> > >  			fraction[1] = 0;
> > >  			denominator = 1;
> > >  			goto out;
> > >-		} else if (!inactive_file_is_low_global(zone)) {
> > >-			/*
> > >-			 * There is enough inactive page cache, do not
> > >-			 * reclaim anything from the working set right now.
> > >-			 */
> > >-			fraction[0] = 0;
> > >-			fraction[1] = 1;
> > >-			denominator = 1;
> > >-			goto out;
> > >  		}
> > >  	}
> > >
> > >
> > 
> > I believe the if() block should be moved to AFTER
> > the check where we make sure we actually have enough
> > file pages.
> 
> You are absolutely right, this makes more sense.  Although I'd figure
> the impact would be small because if there actually is that little
> file cache, it won't be there for long with force-file scanning... :-)
> 

Does it actually make sense? Lets take the global reclaim case.

low_file         == if (unlikely(file + free <= high_wmark_pages(zone)))
inactive_is_high == if (!inactive_file_is_low_global(zone))

Current
  low_file	inactive_is_high	force reclaim anon
  low_file	!inactive_is_high	force reclaim anon
  !low_file	inactive_is_high	force reclaim file
  !low_file	!inactive_is_high	normal split

Your patch

  low_file	inactive_is_high	force reclaim anon
  low_file	!inactive_is_high	force reclaim anon
  !low_file	inactive_is_high	force reclaim file
  !low_file	!inactive_is_high	normal split

However, if you move the inactive_file_is_low check down you get

Moving the check
  low_file	inactive_is_high	force reclaim file
  low_file	!inactive_is_high	force reclaim anon
  !low_file	inactive_is_high	force reclaim file
  !low_file	!inactive_is_high	normal split

There is a small but important change in results. I easily could have made
a mistake so double check.

I'm not being super thorough because I'm not quite sure this is the right
patch if the motivation is for memcg to use the same logic. Instead of
moving this if, why do you not estimate "free" for the memcg based on the
hard limit and current usage? 

-- 
Mel Gorman
SUSE Labs
