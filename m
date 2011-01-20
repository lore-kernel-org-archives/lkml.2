Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1ATQRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:17:22 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:43317 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1ATQRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:17:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=E5SlawqVrw+KCQDrhwnJEl+XPmO+cUaECP3WsZcjg6pi9Aj38JdUKztFMIhIMiElzY
         2H+3hALXlBRYSMSnCeh3yjDnelhX6T2VosxsLZ5LPIletFXzrKbUPwcqzrt9fVZm7dGq
         qLwBxGRQoBnIkn3FxXOJHa559r2drQG7RdCPQ=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 1/3] When migrate_pages returns 0, all pages must have been released
Date: Fri, 21 Jan 2011 01:17:05 +0900
Message-Id: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

From: Andrea Arcangeli <aarcange@redhat.com>

In some cases migrate_pages could return zero while still leaving a
few pages in the pagelist (and some caller wouldn't notice it has to
call putback_lru_pages after commit
cf608ac19c95804dc2df43b1f4f9e068aa9034ab).

Add one missing putback_lru_pages not added by commit
cf608ac19c95804dc2df43b1f4f9e068aa9034ab.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/memory-failure.c |    1 +
 mm/migrate.c        |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 548fbd7..75398b0 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1419,6 +1419,7 @@ int soft_offline_page(struct page *page, int flags)
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
 								0, true);
 		if (ret) {
+			putback_lru_pages(&pagelist);
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 				pfn, ret, page->flags);
 			if (ret > 0)
diff --git a/mm/migrate.c b/mm/migrate.c
index 46fe8cc..7d34237 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -772,6 +772,7 @@ uncharge:
 unlock:
 	unlock_page(page);
 
+move_newpage:
 	if (rc != -EAGAIN) {
  		/*
  		 * A page that has been migrated has all references
@@ -785,8 +786,6 @@ unlock:
 		putback_lru_page(page);
 	}
 
-move_newpage:
-
 	/*
 	 * Move the new page to the LRU. If migration was not successful
 	 * then this will free the page.
-- 
1.7.0.4

