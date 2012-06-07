Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2FGEPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:15:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2FGEP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:15:29 -0400
Message-Id: <20120607040337.475946502@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:43 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: [ 07/82] mm: consider all swapped back pages in used-once logic
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit e48982734ea0500d1eba4f9d96195acc5406cad6 upstream.

Commit 645747462435 ("vmscan: detect mapped file pages used only once")
made mapped pages have another round in inactive list because they might
be just short lived and so we could consider them again next time.  This
heuristic helps to reduce pressure on the active list with a streaming
IO worklods.

This patch fixes a regression introduced by this commit for heavy shmem
based workloads because unlike Anon pages, which are excluded from this
heuristic because they are usually long lived, shmem pages are handled
as a regular page cache.

This doesn't work quite well, unfortunately, if the workload is mostly
backed by shmem (in memory database sitting on 80% of memory) with a
streaming IO in the background (backup - up to 20% of memory).  Anon
inactive list is full of (dirty) shmem pages when watermarks are hit.
Shmem pages are kept in the inactive list (they are referenced) in the
first round and it is hard to reclaim anything else so we reach lower
scanning priorities very quickly which leads to an excessive swap out.

Let's fix this by excluding all swap backed pages (they tend to be long
lived wrt.  the regular page cache anyway) from used-once heuristic and
rather activate them if they are referenced.

The customer's workload is shmem backed database (80% of RAM) and they
are measuring transactions/s with an IO in the background (20%).
Transactions touch more or less random rows in the table.  The
transaction rate fell by a factor of 3 (in the worst case) because of
commit 64574746.  This patch restores the previous numbers.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -722,7 +722,7 @@ static enum page_references page_check_r
 		return PAGEREF_RECLAIM;
 
 	if (referenced_ptes) {
-		if (PageAnon(page))
+		if (PageSwapBacked(page))
 			return PAGEREF_ACTIVATE;
 		/*
 		 * All mapped pages start out with page table


