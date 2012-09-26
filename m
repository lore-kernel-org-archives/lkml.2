Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab2IZU2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab2IZU2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:28:53 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andi Kleen <andi.kleen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] kpageflags: fix wrong KPF_THP on non-huge compound pages
Date: Wed, 26 Sep 2012 16:27:14 -0400
Message-Id: <1348691234-31729-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KPF_THP can be set on non-huge compound pages (like slab pages or pages
allocated by drivers with __GFP_COMP) because PageTransCompound only
checks PG_head and PG_tail. Obviously this is a bug and breaks user space
applications which look for thp via /proc/kpageflags.

This patch rules out setting KPF_THP wrongly by additionally checking
PageLRU on the head pages.

Changelog in v4:
  - check PageLRU with compound_trans_head()
  - fix patch subject again

Changelog in v3:
  - check PageSlab instead of PageAnon
  - fix patch subject

Changelog in v2:
  - add a comment in code

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 fs/proc/page.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git v3.6-rc6.orig/fs/proc/page.c v3.6-rc6/fs/proc/page.c
index 7fcd0d6..b8730d9 100644
--- v3.6-rc6.orig/fs/proc/page.c
+++ v3.6-rc6/fs/proc/page.c
@@ -115,7 +115,13 @@ u64 stable_page_flags(struct page *page)
 		u |= 1 << KPF_COMPOUND_TAIL;
 	if (PageHuge(page))
 		u |= 1 << KPF_HUGE;
-	else if (PageTransCompound(page))
+	/*
+	 * PageTransCompound can be true for non-huge compound pages (slab
+	 * pages or pages allocated by drivers with __GFP_COMP) because it
+	 * just checks PG_head/PG_tail, so we need to check PageLRU to make
+	 * sure a given page is a thp, not a non-huge compound page.
+	 */
+	else if (PageTransCompound(page) && PageLRU(compound_trans_head(page)))
 		u |= 1 << KPF_THP;
 
 	/*
-- 
1.7.11.4

