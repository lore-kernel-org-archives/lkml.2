Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1DORib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:38:31 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54773 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab1DORi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:38:29 -0400
Subject: [RFC][PATCH 2/3] track numbers of pagetable pages
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 15 Apr 2011 10:38:23 -0700
References: <20110415173821.62660715@kernel>
In-Reply-To: <20110415173821.62660715@kernel>
Message-Id: <20110415173823.EA7A7473@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we have the mm in the constructor and destructor, it's
simple to to bump a counter.  Add the counter to the mm and use
the existing MM_* counter infrastructure.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/mm.h       |    2 ++
 linux-2.6.git-dave/include/linux/mm_types.h |    1 +
 2 files changed, 3 insertions(+)

diff -puN include/linux/mm.h~track-pagetable-pages include/linux/mm.h
--- linux-2.6.git/include/linux/mm.h~track-pagetable-pages	2011-04-15 10:37:10.768832396 -0700
+++ linux-2.6.git-dave/include/linux/mm.h	2011-04-15 10:37:10.780832393 -0700
@@ -1245,12 +1245,14 @@ static inline pmd_t *pmd_alloc(struct mm
 static inline void pgtable_page_ctor(struct mm_struct *mm, struct page *page)
 {
 	pte_lock_init(page);
+	inc_mm_counter(mm, MM_PTEPAGES);
 	inc_zone_page_state(page, NR_PAGETABLE);
 }
 
 static inline void pgtable_page_dtor(struct mm_struct *mm, struct page *page)
 {
 	pte_lock_deinit(page);
+	dec_mm_counter(mm, MM_PTEPAGES);
 	dec_zone_page_state(page, NR_PAGETABLE);
 }
 
diff -puN include/linux/mm_types.h~track-pagetable-pages include/linux/mm_types.h
--- linux-2.6.git/include/linux/mm_types.h~track-pagetable-pages	2011-04-15 10:37:10.772832395 -0700
+++ linux-2.6.git-dave/include/linux/mm_types.h	2011-04-15 10:37:10.780832393 -0700
@@ -200,6 +200,7 @@ enum {
 	MM_FILEPAGES,
 	MM_ANONPAGES,
 	MM_SWAPENTS,
+	MM_PTEPAGES,
 	NR_MM_COUNTERS
 };
 
_
