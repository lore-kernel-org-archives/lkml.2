Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab0HEL1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:27:31 -0400
Received: from mail001.aei.ca ([206.123.6.130]:58002 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759051Ab0HEL13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:27:29 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Transparent Hugepage Support #29
Date: Thu, 5 Aug 2010 07:27:24 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-crc+; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100803135615.GG6071@random.random> <201008040815.02368.edt@aei.ca> <20100804124442.GO6071@random.random>
In-Reply-To: <20100804124442.GO6071@random.random>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008050727.25253.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 August 2010 08:44:42 Andrea Arcangeli wrote:
> Hi Ed,
> 
> On Wed, Aug 04, 2010 at 08:15:02AM -0400, Ed Tomlinson wrote:
> > Andrea,
> > 
> > I have been tracking & testing this for a while.   It looks very much like Linus wants to merge (or a big chunk of it):
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working
> > 
> > When I pull an aa-29 on top of this there is one conflict in vmscan.c that git cannot resolve.
> > It would be really nice to have a version of the THS patchs that can be tested with the vfs scaling
> > tree.
> 
> please try:
> 
> zcat transparent-hugepage-29.gz  |patch -p1
> 
> It didn't spawn rejects here, maybe something's wrong in some
> intra-patch or git is too picky. If it doesn't build let me know and I
> will look into it, thanks!

On a tree with:

commit 9d9cec888c3c4a2d5b5f01c3f3984fc4bc602681
Merge: dd6c927 9edd35f
Author: Ed <edt@aei.ca>
Date:   Wed Aug 4 15:18:53 2010 -0400

    Merge branch 'vfs-scale-working' of git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin into vfs-scaling

merged on top of

commit 9fe6206f400646a2322096b56c59891d530e8d51
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Aug 1 15:11:14 2010 -0700

    Linux 2.6.35

doing: bzcat ../transparent-hugepage-29.bz2 | patch -p1

I get one reject:

patching file mm/vmscan.c
Hunk #3 succeeded at 612 (offset 43 lines).
Hunk #4 succeeded at 968 (offset 43 lines).
Hunk #5 succeeded at 1026 (offset 43 lines).
Hunk #6 succeeded at 1063 (offset 43 lines).
Hunk #7 succeeded at 1168 (offset 43 lines).
Hunk #8 succeeded at 1179 (offset 43 lines).
Hunk #9 succeeded at 1198 (offset 43 lines).
Hunk #10 succeeded at 1236 (offset 43 lines).
Hunk #11 succeeded at 1263 (offset 43 lines).
Hunk #12 succeeded at 1333 (offset 43 lines).
Hunk #13 succeeded at 1401 (offset 43 lines).
Hunk #14 succeeded at 1658 (offset 43 lines).
Hunk #15 FAILED at 1629.
Hunk #16 succeeded at 2112 with fuzz 2 (offset 51 lines).
Hunk #17 FAILED at 2093.
Hunk #18 succeeded at 2169 (offset 46 lines).
2 out of 18 hunks FAILED -- saving rejects to file mm/vmscan.c.rej
patching file mm/vmstat.c

---
cat mm/vmscan.c.rej
--- mm/vmscan.c
+++ mm/vmscan.c
@@ -1629,8 +1586,6 @@
 
        get_scan_count(zone, sc, nr, priority);
 
-       set_lumpy_reclaim_mode(priority, sc);
-
        while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
                                        nr[LRU_INACTIVE_FILE]) {
                for_each_evictable_lru(l) {
@@ -2093,9 +2049,25 @@
                                                lru_pages);
                        sc.nr_reclaimed += reclaim_state->reclaimed_slab;
                        total_scanned += sc.nr_scanned;
+                       compaction = 0;
+
+                       if (order &&
+                           zone_watermark_ok(zone, 0,
+                                              high_wmark_pages(zone),
+                                             end_zone, 0) &&
+                           !zone_watermark_ok(zone, order,
+                                              high_wmark_pages(zone),
+                                              end_zone, 0)) {
+                               compact_zone_order(zone,
+                                                  order,
+                                                  sc.gfp_mask,
+                                                  COMPACT_MODE_KSWAPD);
+                               compaction = 1;
+                       }
+
                        if (zone->all_unreclaimable)
                                continue;
-                       if (nr_slab == 0 &&
+                       if (!compaction && nr_slab == 0 &&
                            zone->pages_scanned >= (zone_reclaimable_pages(zone) * 6))
                                zone->all_unreclaimable = 1;
                        /*

--

Ideas?
Ed Tomlinson
