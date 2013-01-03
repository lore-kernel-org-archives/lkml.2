Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3ACE2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 23:28:38 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62218 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3ACE2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 23:28:15 -0500
X-AuditID: 9c930197-b7c5bae000000e31-d5-50e508da118c
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 8/8] extend PGVOLATILE vmstat to kswapd
Date: Thu,  3 Jan 2013 13:28:06 +0900
Message-Id: <1357187286-18759-9-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357187286-18759-1-git-send-email-minchan@kernel.org>
References: <1357187286-18759-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now kswapd can discard volatile pages so let's cover it for vmstat.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/vm_event_item.h |    3 ++-
 mm/mvolatile.c                |    5 ++++-
 mm/vmstat.c                   |    3 ++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 721d096..4efa3bf 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -26,7 +26,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGFREE, PGACTIVATE, PGDEACTIVATE,
 		PGFAULT, PGMAJFAULT,
 #ifdef CONFIG_VOLATILE_PAGE
-		PGVOLATILE,
+		PGVOLATILE_DIRECT,
+		PGVOLATILE_KSWAPD,
 #endif
 		FOR_ALL_ZONES(PGREFILL),
 		FOR_ALL_ZONES(PGSTEAL_KSWAPD),
diff --git a/mm/mvolatile.c b/mm/mvolatile.c
index 1c7bf5a..08a7eb3 100644
--- a/mm/mvolatile.c
+++ b/mm/mvolatile.c
@@ -246,7 +246,10 @@ int discard_volatile_page(struct page *page, enum ttu_flags ttu_flags)
 	if (try_to_volatile_page(page, ttu_flags)) {
 		if (page_freeze_refs(page, 1)) {
 			unlock_page(page);
-			count_vm_event(PGVOLATILE);
+			if (current_is_kswapd())
+				count_vm_event(PGVOLATILE_KSWAPD);
+			else
+				count_vm_event(PGVOLATILE_DIRECT);
 			return 1;
 		}
 	}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 3d08e1a..416f550 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -754,7 +754,8 @@ const char * const vmstat_text[] = {
 	"pgmajfault",
 
 #ifdef CONFIG_VOLATILE_PAGE
-	"pgvolatile",
+	"pgvolatile_direct",
+	"pgvolatile_kswapd",
 #endif
 	TEXTS_FOR_ZONES("pgrefill")
 	TEXTS_FOR_ZONES("pgsteal_kswapd")
-- 
1.7.9.5

