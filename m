Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab1KBQcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:32:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953Ab1KBQcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:32:21 -0400
Date: Wed, 2 Nov 2011 17:31:41 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@parallels.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Gene Heskett <gene.heskett@gmail.com>
Subject: [rfc 1/3] mm: vmscan: never swap under low memory pressure
Message-ID: <20111102163141.GH19965@redhat.com>
References: <20110808110658.31053.55013.stgit@localhost6>
 <CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com>
 <4E3FD403.6000400@parallels.com>
 <20111102163056.GG19965@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102163056.GG19965@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to prevent floods of used-once file cache pushing us to swap
out anonymous pages.  Never swap under a certain priority level.  The
availability of used-once cache pages should prevent us from reaching
that threshold.

This is needed because subsequent patches will revert some of the
mechanisms that tried to prefer file over anon, and this should not
result in more eager swapping again.

It might also be better to keep the aging machinery going and just not
swap, rather than staying away from anonymous pages in the first place
and having less useful age information at the time of swapout.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a90c603..39d3da3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -831,6 +831,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * Try to allocate it some swap space here.
 		 */
 		if (PageAnon(page) && !PageSwapCache(page)) {
+			if (priority >= DEF_PRIORITY - 2)
+				goto keep_locked;
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (!add_to_swap(page))
-- 
1.7.6.4

