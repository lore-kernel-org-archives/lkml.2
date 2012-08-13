Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2HMUVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:21:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61639 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2HMUVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:21:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Ying Han <yinghan@google.com>, Greg Thelen <gthelen@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Theodore Tso <tytso@mit.edu>
Subject: [ 17/82] memcg: further prevent OOM with too many dirty pages
Date: Mon, 13 Aug 2012 13:18:53 -0700
Message-Id: <20120813201747.950071528@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit c3b94f44fcb0725471ecebb701c077a0ed67bd07 upstream.

The may_enter_fs test turns out to be too restrictive: though I saw no
problem with it when testing on 3.5-rc6, it very soon OOMed when I tested
on 3.5-rc6-mm1.  I don't know what the difference there is, perhaps I just
slightly changed the way I started off the testing: dd if=/dev/zero
of=/mnt/temp bs=1M count=1024; rm -f /mnt/temp; sync repeatedly, in 20M
memory.limit_in_bytes cgroup to ext4 on USB stick.

ext4 (and gfs2 and xfs) turn out to allocate new pages for writing with
AOP_FLAG_NOFS: that seems a little worrying, and it's unclear to me why
the transaction needs to be started even before allocating pagecache
memory.  But it may not be worth worrying about these days: if direct
reclaim avoids FS writeback, does __GFP_FS now mean anything?

Anyway, we insisted on the may_enter_fs test to avoid hangs with the loop
device; but since that also masks off __GFP_IO, we can test for __GFP_IO
directly, ignoring may_enter_fs and __GFP_FS.

But even so, the test still OOMs sometimes: when originally testing on
3.5-rc6, it OOMed about one time in five or ten; when testing just now on
3.5-rc6-mm1, it OOMed on the first iteration.

This residual problem comes from an accumulation of pages under ordinary
writeback, not marked PageReclaim, so rightly not causing the memcg check
to wait on their writeback: these too can prevent shrink_page_list() from
freeing any pages, so many times that memcg reclaim fails and OOMs.

Deal with these in the same way as direct reclaim now deals with dirty FS
pages: mark them PageReclaim.  It is appropriate to rotate these to tail
of list when writepage completes, but more importantly, the PageReclaim
flag makes memcg reclaim wait on them if encountered again.  Increment
NR_VMSCAN_IMMEDIATE?  That's arguable: I chose not.

Setting PageReclaim here may occasionally race with end_page_writeback()
clearing it: lru_deactivate_fn() already faced the same race, and
correctly concluded that the window is small and the issue non-critical.

With these changes, the test runs indefinitely without OOMing on ext4,
ext3 and ext2: I'll move on to test with other filesystems later.

Trivia: invert conditions for a clearer block without an else, and goto
keep_locked to do the unlock_page.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -723,23 +723,38 @@ static unsigned long shrink_page_list(st
 			/*
 			 * memcg doesn't have any dirty pages throttling so we
 			 * could easily OOM just because too many pages are in
-			 * writeback from reclaim and there is nothing else to
-			 * reclaim.
+			 * writeback and there is nothing else to reclaim.
 			 *
-			 * Check may_enter_fs, certainly because a loop driver
+			 * Check __GFP_IO, certainly because a loop driver
 			 * thread might enter reclaim, and deadlock if it waits
 			 * on a page for which it is needed to do the write
 			 * (loop masks off __GFP_IO|__GFP_FS for this reason);
 			 * but more thought would probably show more reasons.
+			 *
+			 * Don't require __GFP_FS, since we're not going into
+			 * the FS, just waiting on its writeback completion.
+			 * Worryingly, ext4 gfs2 and xfs allocate pages with
+			 * grab_cache_page_write_begin(,,AOP_FLAG_NOFS), so
+			 * testing may_enter_fs here is liable to OOM on them.
 			 */
-			if (!global_reclaim(sc) && PageReclaim(page) &&
-					may_enter_fs)
-				wait_on_page_writeback(page);
-			else {
+			if (global_reclaim(sc) ||
+			    !PageReclaim(page) || !(sc->gfp_mask & __GFP_IO)) {
+				/*
+				 * This is slightly racy - end_page_writeback()
+				 * might have just cleared PageReclaim, then
+				 * setting PageReclaim here end up interpreted
+				 * as PageReadahead - but that does not matter
+				 * enough to care.  What we do want is for this
+				 * page to have PageReclaim set next time memcg
+				 * reclaim reaches the tests above, so it will
+				 * then wait_on_page_writeback() to avoid OOM;
+				 * and it's also appropriate in global reclaim.
+				 */
+				SetPageReclaim(page);
 				nr_writeback++;
-				unlock_page(page);
-				goto keep;
+				goto keep_locked;
 			}
+			wait_on_page_writeback(page);
 		}
 
 		references = page_check_references(page, sc);


