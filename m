Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946Ab2KVS6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab2KVS6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:40 -0500
Date: Wed, 21 Nov 2012 18:05:45 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-22c8ca2ac256bb681be791858b35502b5d37e73b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1353123563-3103-28-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-28-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Add alloc_low_pages(num)
Git-Commit-ID: 22c8ca2ac256bb681be791858b35502b5d37e73b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:05:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22c8ca2ac256bb681be791858b35502b5d37e73b
Gitweb:     http://git.kernel.org/tip/22c8ca2ac256bb681be791858b35502b5d37e73b
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:04 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:27 -0800

x86, mm: Add alloc_low_pages(num)

32bit kmap mapping needs pages to be used for low to high.
At this point those pages are still from pgt_buf_* from BRK, so it is
ok now.
But we want to move early_ioremap_page_table_range_init() out of
init_memory_mapping() and only call it one time later, that will
make page_table_range_init/page_table_kmap_check/alloc_low_page to
use memblock to get page.

memblock allocation for pages are from high to low.
So will get panic from page_table_kmap_check() that has BUG_ON to do
ordering checking.

This patch add alloc_low_pages to make it possible to allocate serveral
pages at first, and hand out pages one by one from low to high.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-28-git-send-email-yinghai@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c        | 33 +++++++++++++++++++++------------
 arch/x86/mm/mm_internal.h |  6 +++++-
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 21173fc..02cea14 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -25,36 +25,45 @@ unsigned long __meminitdata pgt_buf_top;
 
 static unsigned long min_pfn_mapped;
 
-__ref void *alloc_low_page(void)
+__ref void *alloc_low_pages(unsigned int num)
 {
 	unsigned long pfn;
-	void *adr;
+	int i;
 
 #ifdef CONFIG_X86_64
 	if (after_bootmem) {
-		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
+		unsigned int order;
 
-		return adr;
+		order = get_order((unsigned long)num << PAGE_SHIFT);
+		return (void *)__get_free_pages(GFP_ATOMIC | __GFP_NOTRACK |
+						__GFP_ZERO, order);
 	}
 #endif
 
-	if ((pgt_buf_end + 1) >= pgt_buf_top) {
+	if ((pgt_buf_end + num) >= pgt_buf_top) {
 		unsigned long ret;
 		if (min_pfn_mapped >= max_pfn_mapped)
 			panic("alloc_low_page: ran out of memory");
 		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
 					max_pfn_mapped << PAGE_SHIFT,
-					PAGE_SIZE, PAGE_SIZE);
+					PAGE_SIZE * num , PAGE_SIZE);
 		if (!ret)
 			panic("alloc_low_page: can not alloc memory");
-		memblock_reserve(ret, PAGE_SIZE);
+		memblock_reserve(ret, PAGE_SIZE * num);
 		pfn = ret >> PAGE_SHIFT;
-	} else
-		pfn = pgt_buf_end++;
+	} else {
+		pfn = pgt_buf_end;
+		pgt_buf_end += num;
+	}
+
+	for (i = 0; i < num; i++) {
+		void *adr;
+
+		adr = __va((pfn + i) << PAGE_SHIFT);
+		clear_page(adr);
+	}
 
-	adr = __va(pfn * PAGE_SIZE);
-	clear_page(adr);
-	return adr;
+	return __va(pfn << PAGE_SHIFT);
 }
 
 /* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index b3f993a..7e3b88e 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -1,6 +1,10 @@
 #ifndef __X86_MM_INTERNAL_H
 #define __X86_MM_INTERNAL_H
 
-void *alloc_low_page(void);
+void *alloc_low_pages(unsigned int num);
+static inline void *alloc_low_page(void)
+{
+	return alloc_low_pages(1);
+}
 
 #endif	/* __X86_MM_INTERNAL_H */
