Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1ARRHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:07:04 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46971 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab1ARRHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:07:03 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: compaction: prevent division-by-zero during user-requested compaction
Date: Tue, 18 Jan 2011 18:06:52 +0100
Message-Id: <1295370412-2645-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up until '3e7d344 mm: vmscan: reclaim order-0 and use compaction
instead of lumpy reclaim', compaction skipped calculating the
fragmentation index of a zone when compaction was explicitely
requested through the procfs knob.

However, when compaction_suitable was introduced, it did not come with
an extra check for order == -1, set on explicit compaction requests,
and passed this order on to the fragmentation index calculation, where
it overshifts the number of requested pages, leading to a division by
zero.

This patch makes sure that order == -1 is recognized as the flag it is
rather than passing it along as valid order parameter.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/compaction.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6d592a0..114c145 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -453,6 +453,9 @@ unsigned long compaction_suitable(struct zone *zone, int order)
 	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 		return COMPACT_SKIPPED;
 
+	if (order == -1)
+		return COMPACT_CONTINUE;
+
 	/*
 	 * fragmentation index determines if allocation failures are due to
 	 * low memory or external fragmentation
-- 
1.7.3.4

