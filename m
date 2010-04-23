Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0DWXBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 19:01:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:57325 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab0DWXBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 19:01:04 -0400
Date: Fri, 23 Apr 2010 23:00:45 GMT
From: tip-bot for Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       holt@sgi.com, rjw@novell.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, venkatesh.pallipadi@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       holt@sgi.com, rjw@novell.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, venkatesh.pallipadi@gmail.com
In-Reply-To: <20100423153627.751194346@gulag1.americas.sgi.com>
References: <20100423153627.751194346@gulag1.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] x86, pat: Update the page flags for memtype atomically instead of using memtype_lock
Message-ID: <tip-1f9cc3cb6a27521edfe0a21abf97d2bb11c4d237@git.kernel.org>
Git-Commit-ID: 1f9cc3cb6a27521edfe0a21abf97d2bb11c4d237
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Apr 2010 23:00:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f9cc3cb6a27521edfe0a21abf97d2bb11c4d237
Gitweb:     http://git.kernel.org/tip/1f9cc3cb6a27521edfe0a21abf97d2bb11c4d237
Author:     Robin Holt <holt@sgi.com>
AuthorDate: Fri, 23 Apr 2010 10:36:22 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 23 Apr 2010 15:57:23 -0700

x86, pat: Update the page flags for memtype atomically instead of using memtype_lock

While testing an application using the xpmem (out of kernel) driver, we
noticed a significant page fault rate reduction of x86_64 with respect
to ia64.  For one test running with 32 cpus, one thread per cpu, it
took 01:08 for each of the threads to vm_insert_pfn 2GB worth of pages.
For the same test running on 256 cpus, one thread per cpu, it took 14:48
to vm_insert_pfn 2 GB worth of pages.

The slowdown was tracked to lookup_memtype which acquires the
spinlock memtype_lock.  This heavily contended lock was slowing down
vm_insert_pfn().

With the cmpxchg on page->flags method, both the 32 cpu and 256 cpu
cases take approx 00:01.3 seconds to complete.

Signed-off-by: Robin Holt <holt@sgi.com>
LKML-Reference: <20100423153627.751194346@gulag1.americas.sgi.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Cc: Rafael Wysocki <rjw@novell.com>
Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cacheflush.h |   44 +++++++++++++++++++++----------------
 arch/x86/mm/pat.c                 |    8 ------
 2 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 634c40a..c70068d 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -44,9 +44,6 @@ static inline void copy_from_user_page(struct vm_area_struct *vma,
 	memcpy(dst, src, len);
 }
 
-#define PG_WC				PG_arch_1
-PAGEFLAG(WC, WC)
-
 #ifdef CONFIG_X86_PAT
 /*
  * X86 PAT uses page flags WC and Uncached together to keep track of
@@ -55,16 +52,24 @@ PAGEFLAG(WC, WC)
  * _PAGE_CACHE_UC_MINUS and fourth state where page's memory type has not
  * been changed from its default (value of -1 used to denote this).
  * Note we do not support _PAGE_CACHE_UC here.
- *
- * Caller must hold memtype_lock for atomicity.
  */
+
+#define _PGMT_DEFAULT		0
+#define _PGMT_WC		(1UL << PG_arch_1)
+#define _PGMT_UC_MINUS		(1UL << PG_uncached)
+#define _PGMT_WB		(1UL << PG_uncached | 1UL << PG_arch_1)
+#define _PGMT_MASK		(1UL << PG_uncached | 1UL << PG_arch_1)
+#define _PGMT_CLEAR_MASK	(~_PGMT_MASK)
+
 static inline unsigned long get_page_memtype(struct page *pg)
 {
-	if (!PageUncached(pg) && !PageWC(pg))
+	unsigned long pg_flags = pg->flags & _PGMT_MASK;
+
+	if (pg_flags == _PGMT_DEFAULT)
 		return -1;
-	else if (!PageUncached(pg) && PageWC(pg))
+	else if (pg_flags == _PGMT_WC)
 		return _PAGE_CACHE_WC;
-	else if (PageUncached(pg) && !PageWC(pg))
+	else if (pg_flags == _PGMT_UC_MINUS)
 		return _PAGE_CACHE_UC_MINUS;
 	else
 		return _PAGE_CACHE_WB;
@@ -72,25 +77,26 @@ static inline unsigned long get_page_memtype(struct page *pg)
 
 static inline void set_page_memtype(struct page *pg, unsigned long memtype)
 {
+	unsigned long memtype_flags = _PGMT_DEFAULT;
+	unsigned long old_flags;
+	unsigned long new_flags;
+
 	switch (memtype) {
 	case _PAGE_CACHE_WC:
-		ClearPageUncached(pg);
-		SetPageWC(pg);
+		memtype_flags = _PGMT_WC;
 		break;
 	case _PAGE_CACHE_UC_MINUS:
-		SetPageUncached(pg);
-		ClearPageWC(pg);
+		memtype_flags = _PGMT_UC_MINUS;
 		break;
 	case _PAGE_CACHE_WB:
-		SetPageUncached(pg);
-		SetPageWC(pg);
-		break;
-	default:
-	case -1:
-		ClearPageUncached(pg);
-		ClearPageWC(pg);
+		memtype_flags = _PGMT_WB;
 		break;
 	}
+
+	do {
+		old_flags = pg->flags;
+		new_flags = (old_flags & _PGMT_CLEAR_MASK) | memtype_flags;
+	} while (cmpxchg(&pg->flags, old_flags, new_flags) != old_flags);
 }
 #else
 static inline unsigned long get_page_memtype(struct page *pg) { return -1; }
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 9510111..501fc60 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -190,8 +190,6 @@ static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
  * Here we do two pass:
  * - Find the memtype of all the pages in the range, look for any conflicts
  * - In case of no conflicts, set the new memtype for pages in the range
- *
- * Caller must hold memtype_lock for atomicity.
  */
 static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
 				  unsigned long *new_type)
@@ -297,9 +295,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	is_range_ram = pat_pagerange_is_ram(start, end);
 	if (is_range_ram == 1) {
 
-		spin_lock(&memtype_lock);
 		err = reserve_ram_pages_type(start, end, req_type, new_type);
-		spin_unlock(&memtype_lock);
 
 		return err;
 	} else if (is_range_ram < 0) {
@@ -351,9 +347,7 @@ int free_memtype(u64 start, u64 end)
 	is_range_ram = pat_pagerange_is_ram(start, end);
 	if (is_range_ram == 1) {
 
-		spin_lock(&memtype_lock);
 		err = free_ram_pages_type(start, end);
-		spin_unlock(&memtype_lock);
 
 		return err;
 	} else if (is_range_ram < 0) {
@@ -394,10 +388,8 @@ static unsigned long lookup_memtype(u64 paddr)
 
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
 		struct page *page;
-		spin_lock(&memtype_lock);
 		page = pfn_to_page(paddr >> PAGE_SHIFT);
 		rettype = get_page_memtype(page);
-		spin_unlock(&memtype_lock);
 		/*
 		 * -1 from get_page_memtype() implies RAM page is in its
 		 * default state and not reserved, and hence of type WB
