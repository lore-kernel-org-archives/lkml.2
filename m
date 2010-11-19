Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0KSAkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:40:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:38318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab0KSAkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:40:21 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, David Sterba <dsterba@suse.cz>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>, Andy Whitcroft <apw@canonical.com>,
        David Rientjes <rientjes@google.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] mm: remove call to find_vma in pagewalk for non-hugetlbfs
Date: Fri, 19 Nov 2010 01:39:57 +0100
Message-Id: <1290127197-20360-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.3.2.168.gd6b63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d33b9f45 introduces a check if a vma is a hugetlbfs one and
later in 5dc37642 is moved under #ifdef CONFIG_HUGETLB_PAGE but
a needless find_vma call is left behind and it's result not used
anywhere else in the function.

The sideefect of caching vma for @addr inside walk->mm is neither
utilized in walk_page_range() nor in called functions.

Signed-off-by: David Sterba <dsterba@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/pagewalk.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 8b1a2ce..38cc58b 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -139,7 +139,6 @@ int walk_page_range(unsigned long addr, unsigned long end,
 	pgd_t *pgd;
 	unsigned long next;
 	int err = 0;
-	struct vm_area_struct *vma;
 
 	if (addr >= end)
 		return err;
@@ -149,15 +148,17 @@ int walk_page_range(unsigned long addr, unsigned long end,
 
 	pgd = pgd_offset(walk->mm, addr);
 	do {
+		struct vm_area_struct *uninitialized_var(vma);
+
 		next = pgd_addr_end(addr, end);
 
+#ifdef CONFIG_HUGETLB_PAGE
 		/*
 		 * handle hugetlb vma individually because pagetable walk for
 		 * the hugetlb page is dependent on the architecture and
 		 * we can't handled it in the same manner as non-huge pages.
 		 */
 		vma = find_vma(walk->mm, addr);
-#ifdef CONFIG_HUGETLB_PAGE
 		if (vma && is_vm_hugetlb_page(vma)) {
 			if (vma->vm_end < next)
 				next = vma->vm_end;
-- 
1.7.1

