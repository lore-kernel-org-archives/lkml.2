Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0HWQOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:14:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56482 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab0HWQOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:14:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HOtn4O0Lo2z39O+i0LbCYPAVpG04xiWtKGZLSUkuYwAb58U3/okrGF89GiK2wTgPoF
         0Ls5FsJakVNykyg03QeCE2ceFBc/h+IpY95RMyzDbetv/VZEKUD7KpWrZk4ycP8j2VHm
         FWA2r4nhSN2E+CPuDNj1/7FWkwFsnMHAaVHaQ=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Iram Shahzad <iram.shahzad@jp.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH] compaction: handle active and inactive fairly in too_many_isolated
Date: Tue, 24 Aug 2010 01:13:48 +0900
Message-Id: <1282580028-1940-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iram reported compaction's too_many_isolated loops forever.
(http://www.spinics.net/lists/linux-mm/msg08123.html)

The meminfo of situation happened was inactive anon is zero.
That's because the system has no memory pressure until then.
While all anon pages was in active lru, compaction could select
active lru as well as inactive lru. That's different things
with vmscan's isolated. So we has been two too_many_isolated.

While compaction can isolated pages in both active and inactive,
current implementation of too_many_isolated only considers inactive.
It made Iram's problem.

This patch handles active and inactive with fair.
That's because we can't expect where from and how many compaction would
isolated pages.

This patch changes (nr_isolated > nr_inactive) with
nr_isolated > (nr_active + nr_inactive) / 2.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 94cce51..4d709ee 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -214,15 +214,16 @@ static void acct_isolated(struct zone *zone, struct compact_control *cc)
 /* Similar to reclaim, but different enough that they don't share logic */
 static bool too_many_isolated(struct zone *zone)
 {
-
-	unsigned long inactive, isolated;
+	unsigned long active, inactive, isolated;
 
 	inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
 					zone_page_state(zone, NR_INACTIVE_ANON);
+	active = zone_page_state(zone, NR_ACTIVE_FILE) +
+					zone_page_state(zone, NR_ACTIVE_ANON);
 	isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
 					zone_page_state(zone, NR_ISOLATED_ANON);
 
-	return isolated > inactive;
+	return isolated > (inactive + active) / 2;
 }
 
 /*
-- 
1.7.0.5

