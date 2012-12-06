Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424778Ab2LFUYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 15:24:33 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35842 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423237Ab2LFUYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 15:24:31 -0500
Date: Thu, 6 Dec 2012 15:23:25 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bruno Wolff III <bruno@wolff.to>, Thorsten Leemhuis <fedora@leemhuis.info>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jiri Slaby <jslaby@suse.cz>, Zdenek Kabelac <zkabelac@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Ellson <john.ellson@comcast.net>
Subject: Re: kswapd craziness in 3.7
Message-ID: <20121206202325.GA1498@cmpxchg.org>
References: <50B77F84.1030907@leemhuis.info>
 <20121129170512.GI2301@cmpxchg.org>
 <50B8A8E7.4030108@leemhuis.info>
 <20121201004520.GK2301@cmpxchg.org>
 <50BC6314.7060106@leemhuis.info>
 <20121203194208.GZ24381@cmpxchg.org>
 <20121204214210.GB20253@cmpxchg.org>
 <20121205030133.GA17438@wolff.to>
 <20121206173742.GA27297@wolff.to>
 <CA+55aFzZsCUk6snrsopWQJQTXLO__G7=SjrGNyK3ePCEtZo7Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzZsCUk6snrsopWQJQTXLO__G7=SjrGNyK3ePCEtZo7Sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 11:31:21AM -0800, Linus Torvalds wrote:
> Ok, people seem to be reporting success.
> 
> I've applied Johannes' last patch with the new tested-by tags.
> 
> Johannes (or anybody else, for that matter), please holler LOUDLY if
> you disagreed.. (or if I used the wrong version of the patch, there's
> been several, afaik).

I just went back one more time and of course that's when I spot that I
forgot to remove the zone congestion clearing that depended on the now
removed checks to ensure the zone is balanced.  It's not too big of a
deal, just the /risk/ of increased CPU use from reclaim because we go
back to scanning zones that we previously deemed congested and slept a
little bit before continuing reclaim.

Sorry, I should have seen that earlier.

Removing it is a low risk fix, the clearing was kinda redundant anyway
(the preliminary zone check clears it for OK zones, so does the
reclaim loop under the same criteria), letting it stay is probably
more problematic for 3.8 than just dropping it...

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: vmscan: fix inappropriate zone congestion clearing

c702418 ("mm: vmscan: do not keep kswapd looping forever due to
individual uncompactable zones") removed zone watermark checks from
the compaction code in kswapd but left in the zone congestion
clearing, which now happens unconditionally on higher order reclaim.

This messes up the reclaim throttling logic for zones with
dirty/writeback pages, where zones should only lose their congestion
status when their watermarks have been restored.

Remove the clearing from the zone compaction section entirely.  The
preliminary zone check and the reclaim loop in kswapd will clear it if
the zone is considered balanced.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 124bbfe..b7ed376 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2827,9 +2827,6 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 			if (zone_watermark_ok(zone, order,
 				    low_wmark_pages(zone), *classzone_idx, 0))
 				zones_need_compaction = 0;
-
-			/* If balanced, clear the congested flag */
-			zone_clear_flag(zone, ZONE_CONGESTED);
 		}
 
 		if (zones_need_compaction)
-- 
1.7.11.7

