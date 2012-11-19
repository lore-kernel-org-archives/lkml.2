Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2KSFcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:32:15 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43694 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2KSFcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:32:12 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 44/58] mm: Only define is_pageblock_removable_nolock when needed
Date: Sun, 18 Nov 2012 21:28:23 -0800
Message-Id: <1353302917-13995-45-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/page_alloc.c defines is_pageblock_removable_nolock unconditionally,
but include/linux/memory_hotplug.h only prototypes it when
CONFIG_MEMORY_HOTPLUG=y and CONFIG_MEMORY_HOTREMOVE=y.  Add the
corresponding conditions around the definition, too.

This also eliminates warnings from GCC (-Wmissing-prototypes) and Sparse
(-Wdecl).

mm/page_alloc.c:5634:6: warning: no previous prototype for ‘is_pageblock_removable_nolock’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d857953..706bd5f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5631,6 +5631,7 @@ bool has_unmovable_pages(struct zone *zone, struct page *page, int count)
 	return false;
 }
 
+#if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_MEMORY_HOTREMOVE)
 bool is_pageblock_removable_nolock(struct page *page)
 {
 	struct zone *zone;
@@ -5654,6 +5655,7 @@ bool is_pageblock_removable_nolock(struct page *page)
 
 	return !has_unmovable_pages(zone, page, 0);
 }
+#endif /* defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_MEMORY_HOTREMOVE) */
 
 #ifdef CONFIG_CMA
 
-- 
1.7.10.4

