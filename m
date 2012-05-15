Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211Ab2EOCRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:49084 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964879Ab2EOCQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 022/179] mm/page_alloc.c: prevent unending loop in __alloc_pages_slowpath()
Date: Mon, 14 May 2012 22:11:58 -0400
Message-ID: <1337048075-6132-23-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Barry <abarry@cray.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cfa54a0fcfc1017c6f122b6f21aaba36daa07f71 upstream.

I believe I found a problem in __alloc_pages_slowpath, which allows a
process to get stuck endlessly looping, even when lots of memory is
available.

Running an I/O and memory intensive stress-test I see a 0-order page
allocation with __GFP_IO and __GFP_WAIT, running on a system with very
little free memory.  Right about the same time that the stress-test gets
killed by the OOM-killer, the utility trying to allocate memory gets stuck
in __alloc_pages_slowpath even though most of the systems memory was freed
by the oom-kill of the stress-test.

The utility ends up looping from the rebalance label down through the
wait_iff_congested continiously.  Because order=0,
__alloc_pages_direct_compact skips the call to get_page_from_freelist.
Because all of the reclaimable memory on the system has already been
reclaimed, __alloc_pages_direct_reclaim skips the call to
get_page_from_freelist.  Since there is no __GFP_FS flag, the block with
__alloc_pages_may_oom is skipped.  The loop hits the wait_iff_congested,
then jumps back to rebalance without ever trying to
get_page_from_freelist.  This loop repeats infinitely.

The test case is pretty pathological.  Running a mix of I/O stress-tests
that do a lot of fork() and consume all of the system memory, I can pretty
reliably hit this on 600 nodes, in about 12 hours.  32GB/node.

Signed-off-by: Andrew Barry <abarry@cray.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9826a8d..1418be7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1863,6 +1863,7 @@ restart:
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
+rebalance:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
@@ -1870,7 +1871,6 @@ restart:
 	if (page)
 		goto got_pg;
 
-rebalance:
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
 		page = __alloc_pages_high_priority(gfp_mask, order,
-- 
1.7.9.6

