Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1ATQR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:17:29 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38367 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1ATQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:17:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TzziwCnIKW7yGhSXdpIvVB1VAkbjIAkXWm6ifBTEM3WfLA9naKZcfO2hhyb4EX7E9E
         97Tmx0Y0quj9HutB6LCqkoyY6ifQgMvMhU71cF+v7BOieLBo9UKHt8SRR+4tR0ub5KyT
         3lTjWDMdGQCQEriIHDp4qhYiICqeojMmvS/Ps=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 3/3] compaction: Check migrate_pages's return value instead of list_empty
Date: Fri, 21 Jan 2011 01:17:07 +0900
Message-Id: <8d3d2470533ab99564cdcec88bfb7fcc96b383d3.1295539829.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
References: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
In-Reply-To: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
References: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many migrate_page's caller check return value instead of list_empy by
cf608ac19c95804dc2.
This patch makes compaction's migrate_pages consistent with others.
This patch should not change old behavior.

NOTE : This patch depends on [1/3].

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6d592a0..cd0c7fc 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -497,12 +497,13 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 
 	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
 		unsigned long nr_migrate, nr_remaining;
+		int err;
 
 		if (!isolate_migratepages(zone, cc))
 			continue;
 
 		nr_migrate = cc->nr_migratepages;
-		migrate_pages(&cc->migratepages, compaction_alloc,
+		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				(unsigned long)cc, false,
 				cc->sync);
 		update_nr_listpages(cc);
@@ -516,7 +517,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 						nr_remaining);
 
 		/* Release LRU pages not migrated */
-		if (!list_empty(&cc->migratepages)) {
+		if (err) {
 			putback_lru_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
 		}
-- 
1.7.0.4

