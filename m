Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab2GIKNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:13:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43994 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2GIKNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:13:04 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/hugetlb: split out is_hugetlb_entry_migration_or_hwpoison
Date: Mon,  9 Jul 2012 18:12:41 +0800
Message-Id: <1341828761-11195-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Code was duplicated in two functions, clean it up.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/hugetlb.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e198831..4f9ce3f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2282,30 +2282,28 @@ nomem:
 	return -ENOMEM;
 }
 
-static int is_hugetlb_entry_migration(pte_t pte)
+static int is_hugetlb_entry_migration_or_hwpoison(pte_t pte, bool migration)
 {
 	swp_entry_t swp;
 
 	if (huge_pte_none(pte) || pte_present(pte))
 		return 0;
 	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_migration_entry(swp))
+	if (non_swap_entry(pte) && ((migration && is_migration_entry(pte))
+				|| !migration && is_hwpoison_entry(pte)))
 		return 1;
 	else
 		return 0;
 }
 
-static int is_hugetlb_entry_hwpoisoned(pte_t pte)
+static int is_hugetlb_entry_migration(pte_t pte)
 {
-	swp_entry_t swp;
+	return is_hugetlb_entry_migration_or_hwpoison(pte, true);
+}
 
-	if (huge_pte_none(pte) || pte_present(pte))
-		return 0;
-	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
-		return 1;
-	else
-		return 0;
+static int is_hugetlb_entry_hwpoisoned(pte_t pte)
+{
+	return is_hugetlb_entry_migration_or_hwpoison(pte, false);
 }
 
 void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
-- 
1.7.5.4

