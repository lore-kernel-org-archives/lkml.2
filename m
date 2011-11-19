Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1KSTzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:55:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1KSTzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:55:05 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] Revert "vmscan: limit direct reclaim for higher order allocations"
Date: Sat, 19 Nov 2011 20:54:20 +0100
Message-Id: <1321732460-14155-9-git-send-email-aarcange@redhat.com>
In-Reply-To: <1321635524-8586-1-git-send-email-mgorman@suse.de>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e0887c19b2daa140f20ca8104bdc5740f39dbb86.

If reclaim runs with an high order allocation, it means compaction
failed. That means something went wrong with compaction so we can't
stop reclaim too. We can't assume it failed and was deferred only
because of the too low watermarks in compaction_suitable, it may have
failed for other reasons.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/vmscan.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b1a3cb0..a9d1ba4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2128,22 +2128,6 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
 				continue;
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
-			if (COMPACTION_BUILD) {
-				/*
-				 * If we already have plenty of memory
-				 * free for compaction, don't free any
-				 * more.  Even though compaction is
-				 * invoked for any non-zero order,
-				 * only frequent costly order
-				 * reclamation is disruptive enough to
-				 * become a noticable problem, like
-				 * transparent huge page allocations.
-				 */
-				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
-					(compaction_suitable(zone, sc->order) ||
-					 compaction_deferred(zone)))
-					continue;
-			}
 			/*
 			 * This steals pages from memory cgroups over softlimit
 			 * and returns the number of reclaimed pages and
