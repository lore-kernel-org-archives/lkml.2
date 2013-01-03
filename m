Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3ACE3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 23:29:09 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62218 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3ACE2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 23:28:14 -0500
X-AuditID: 9c930197-b7c5bae000000e31-d2-50e508da38f7
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 6/8] add PGVOLATILE vmstat count
Date: Thu,  3 Jan 2013 13:28:04 +0900
Message-Id: <1357187286-18759-7-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357187286-18759-1-git-send-email-minchan@kernel.org>
References: <1357187286-18759-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add pgvolatile vmstat so admin can see how many of volatile
pages are discarded by VM until now.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/vm_event_item.h |    3 +++
 mm/mvolatile.c                |    1 +
 mm/vmstat.c                   |    3 +++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 3d31145..721d096 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -25,6 +25,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
 		PGFREE, PGACTIVATE, PGDEACTIVATE,
 		PGFAULT, PGMAJFAULT,
+#ifdef CONFIG_VOLATILE_PAGE
+		PGVOLATILE,
+#endif
 		FOR_ALL_ZONES(PGREFILL),
 		FOR_ALL_ZONES(PGSTEAL_KSWAPD),
 		FOR_ALL_ZONES(PGSTEAL_DIRECT),
diff --git a/mm/mvolatile.c b/mm/mvolatile.c
index 6bc9f7e..c66c3bc 100644
--- a/mm/mvolatile.c
+++ b/mm/mvolatile.c
@@ -201,6 +201,7 @@ int discard_volatile_page(struct page *page, enum ttu_flags ttu_flags)
 	if (try_to_volatile_page(page, ttu_flags)) {
 		if (page_freeze_refs(page, 1)) {
 			unlock_page(page);
+			count_vm_event(PGVOLATILE);
 			return 1;
 		}
 	}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c737057..3d08e1a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -753,6 +753,9 @@ const char * const vmstat_text[] = {
 	"pgfault",
 	"pgmajfault",
 
+#ifdef CONFIG_VOLATILE_PAGE
+	"pgvolatile",
+#endif
 	TEXTS_FOR_ZONES("pgrefill")
 	TEXTS_FOR_ZONES("pgsteal_kswapd")
 	TEXTS_FOR_ZONES("pgsteal_direct")
-- 
1.7.9.5

