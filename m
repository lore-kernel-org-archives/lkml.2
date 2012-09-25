Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2IYN5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:57:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab2IYN5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:57:32 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi.kleen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pagemap: fix wrong KPF_THP on slab pages
Date: Tue, 25 Sep 2012 09:56:54 -0400
Message-Id: <1348581414-19103-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KPF_THP can be set on non-huge compound pages like slab pages, because
PageTransCompound only sees PG_head and PG_tail. Obviously this is a bug
and breaks user space applications which look for thp via /proc/kpageflags.
Currently thp is constructed only on anonymous pages, so this patch makes
KPF_THP be set when both of PageAnon and PageTransCompound are true.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/proc/page.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git v3.6-rc6.orig/fs/proc/page.c v3.6-rc6/fs/proc/page.c
index 7fcd0d6..613102d 100644
--- v3.6-rc6.orig/fs/proc/page.c
+++ v3.6-rc6/fs/proc/page.c
@@ -115,7 +115,7 @@ u64 stable_page_flags(struct page *page)
 		u |= 1 << KPF_COMPOUND_TAIL;
 	if (PageHuge(page))
 		u |= 1 << KPF_HUGE;
-	else if (PageTransCompound(page))
+	else if (PageTransCompound(page) && PageAnon(page))
 		u |= 1 << KPF_THP;
 
 	/*
-- 
1.7.11.4

