Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2GLB61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 21:58:27 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59840 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2GLB6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 21:58:25 -0400
Date: Wed, 11 Jul 2012 18:57:43 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 -mm] memcg: prevent from OOM with too many dirty
 pages
In-Reply-To: <20120620101119.GC5541@tiehlicka.suse.cz>
Message-ID: <alpine.LSU.2.00.1207111818380.1299@eggly.anvils>
References: <1340117404-30348-1-git-send-email-mhocko@suse.cz> <20120619150014.1ebc108c.akpm@linux-foundation.org> <20120620101119.GC5541@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Wed, 20 Jun 2012, Michal Hocko wrote:
> Hi Andrew,
> here is an updated version if it is easier for you to drop the previous
> one.
> changes since v1
> * added Mel's Reviewed-by
> * updated changelog as per Andrew
> * updated the condition to be optimized for no-memcg case

I mentioned in Johannes's [03/11] thread a couple of days ago, that
I was having a problem with your wait_on_page_writeback() in mmotm.

It turns out that your original patch was fine, but you let dark angels
whisper into your ear, to persuade you to remove the "&& may_enter_fs".

Part of my load builds kernels on extN over loop over tmpfs: loop does
mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS))
because it knows it will deadlock, if the loop thread enters reclaim,
and reclaim tries to write back a dirty page, one which needs the loop
thread to perform the write.

With the may_enter_fs check restored, all is well.  I don't entirely
like your patch: I think it would be much better to wait in the same
place as the wait_iff_congested(), when the pages gathered have been
sent for writing and unlocked and putback and freed; and I also wonder
if it should go beyond the !global_reclaim case for swap pages, because
they don't participate in dirty limiting.

But those are things I should investigate later - I did write a patch
like that before, when I was having some unexpected OOM trouble with a
private kernel; but my OOMs then were because of something silly that
I'd left out, and I'm not at present sure if we have a problem in this
regard or not.

The important thing is to get the may_enter_fs back into your patch:
I can't really Sign-off the below because it's yours, but
Acked-by: Hugh Dickins <hughd@google.com>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 3.5-rc6-mm1/mm/vmscan.c	2012-07-11 14:42:13.668335884 -0700
+++ linux/mm/vmscan.c	2012-07-11 16:01:20.712814127 -0700
@@ -726,7 +726,8 @@ static unsigned long shrink_page_list(st
 			 * writeback from reclaim and there is nothing else to
 			 * reclaim.
 			 */
-			if (!global_reclaim(sc) && PageReclaim(page))
+			if (!global_reclaim(sc) && PageReclaim(page) &&
+					may_enter_fs)
 				wait_on_page_writeback(page);
 			else {
 				nr_writeback++;
