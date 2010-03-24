Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0CXAgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:36:25 -0400
Received: from relay1.sgi.com ([192.48.179.29]:40177 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab0CXAgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:36:23 -0400
Message-Id: <20100324003621.121017205@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 23 Mar 2010 19:36:09 -0500
From: holt@sgi.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Rafael Wysocki <rjw@novell.com>
Subject: [patch 1/2] x86,pat Update the page flags for memtype atomically instead of using memtype_lock. -V4
References: <20100324003608.811051277@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=memtype_atomic_update_V4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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


To: Ingo Molnar <mingo@redhat.com>
To: H. Peter Anvin <hpa@zytor.com>
To: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Cc: Rafael Wysocki <rjw@novell.com>

---

Changes since -V3:
1) Fix the _PGMT macros to actuall by bit masks instead of the
bit numbers.


Changes since -V2:
1) Cleared up the naming of the masks used in setting and clearing
the flags.


Changes since -V1:
1) Introduce atomically setting and clearing the page flags and not
using the global memtype_lock to protect page->flags.

2) This allowed me the opportunity to convert the rwlock back into a
spinlock and not affect _MY_ tests performance as all the pages my test
was utilizing are tracked by struct pages.

3) Corrected the commit log.  The timings were for 32 cpus and not 256.

 arch/x86/include/asm/cacheflush.h |   44 +++++++++++++++++++++-----------------
 arch/x86/mm/pat.c                 |    8 ------
 2 files changed, 25 insertions(+), 27 deletions(-)

Index: memtype_lock_V4/arch/x86/include/asm/cacheflush.h
===================================================================
--- memtype_lock_V4.orig/arch/x86/include/asm/cacheflush.h	2010-03-23 19:32:20.042467673 -0500
+++ memtype_lock_V4/arch/x86/include/asm/cacheflush.h	2010-03-23 19:34:23.914765715 -0500
@@ -44,9 +44,6 @@ static inline void copy_from_user_page(s
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
@@ -72,25 +77,26 @@ static inline unsigned long get_page_mem
 
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
Index: memtype_lock_V4/arch/x86/mm/pat.c
===================================================================
--- memtype_lock_V4.orig/arch/x86/mm/pat.c	2010-03-23 19:34:13.459445018 -0500
+++ memtype_lock_V4/arch/x86/mm/pat.c	2010-03-23 19:34:23.914765715 -0500
@@ -190,8 +190,6 @@ static int pat_pagerange_is_ram(unsigned
  * Here we do two pass:
  * - Find the memtype of all the pages in the range, look for any conflicts
  * - In case of no conflicts, set the new memtype for pages in the range
- *
- * Caller must hold memtype_lock for atomicity.
  */
 static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
 				  unsigned long *new_type)
@@ -297,9 +295,7 @@ int reserve_memtype(u64 start, u64 end, 
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
@@ -394,10 +388,8 @@ static unsigned long lookup_memtype(u64 
 
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
 		struct page *page;
-		spin_lock(&memtype_lock);
 		page = pfn_to_page(paddr >> PAGE_SHIFT);
 		rettype = get_page_memtype(page);
-		spin_unlock(&memtype_lock);
 		/*
 		 * -1 from get_page_memtype() implies RAM page is in its
 		 * default state and not reserved, and hence of type WB

