Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0IBOcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:32:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:33709 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0IBOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nD8ESD9EsHB55E1rqH+xE+DNeM/JqtAi0+4uVZ+s+yXV0SbIy7WdLUrnvirOq9srRl
         NL4Qb+ME+reHWlr0KuQMDtdyvy3Y9n2LFq4YJ4YTWaNf9Jx8u5/xJfg4DtOFsEK344aQ
         mVOQqgvTKSyuZfFPvCBNO1xEsMfos3SYXnicg=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Iram Shahzad <iram.shahzad@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [RESEND PATCH v2] compaction: handle active and inactive fairly in too_many_isolated
Date: Thu,  2 Sep 2010 23:32:11 +0900
Message-Id: <1283437931-11754-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iram reported compaction's too_many_isolated loops forever.
(http://www.spinics.net/lists/linux-mm/msg08123.html)

The meminfo of situation happened was inactive anon is zero.
That's because the system has no memory pressure until then.
While all anon pages was in active lru, compaction could select
active lru as well as inactive lru. That's a different thing
with vmscan's isolated. So we has been two too_many_isolated.

While compaction can isolated pages in both active and inactive,
current implementation of too_many_isolated only considers inactive.
It made Iram's problem.

This patch handles active and inactive with fair.
That's because we can't expect where from and how many compaction would
isolated pages.

This patch changes (nr_isolated > nr_inactive) with
nr_isolated > (nr_active + nr_inactive) / 2.

P.S : Mel said "it should be merged and arguably is a stable candidate for 2.6.35"

Cc: Iram Shahzad <iram.shahzad@jp.fujitsu.com>
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

