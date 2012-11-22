Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab2KVUvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:51:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2KVS6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:38 -0500
Date: Wed, 21 Nov 2012 18:02:38 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-5c51bdbe4c74dce7996d0bbfa39974775cc3f13c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-25-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-25-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Merge alloc_low_page between 64bit and 32bit
Git-Commit-ID: 5c51bdbe4c74dce7996d0bbfa39974775cc3f13c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:02:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c51bdbe4c74dce7996d0bbfa39974775cc3f13c
Gitweb:     http://git.kernel.org/tip/5c51bdbe4c74dce7996d0bbfa39974775cc3f13c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:01 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:23 -0800

x86, mm: Merge alloc_low_page between 64bit and 32bit

They are almost same except 64 bit need to handle after_bootmem case.

Add mm_internal.h to make that alloc_low_page() only to be accessible
from arch/x86/mm/init*.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-25-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c        | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_32.c     | 26 ++------------------------
 arch/x86/mm/init_64.c     | 32 ++------------------------------
 arch/x86/mm/mm_internal.h |  6 ++++++
 4 files changed, 44 insertions(+), 54 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 2393d00..8481892 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -17,10 +17,44 @@
 #include <asm/proto.h>
 #include <asm/dma.h>		/* for MAX_DMA_PFN */
 
+#include "mm_internal.h"
+
 unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
 unsigned long __meminitdata pgt_buf_top;
 
+__ref void *alloc_low_page(void)
+{
+	unsigned long pfn;
+	void *adr;
+
+#ifdef CONFIG_X86_64
+	if (after_bootmem) {
+		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
+
+		return adr;
+	}
+#endif
+
+	if ((pgt_buf_end + 1) >= pgt_buf_top) {
+		unsigned long ret;
+		if (min_pfn_mapped >= max_pfn_mapped)
+			panic("alloc_low_page: ran out of memory");
+		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
+					max_pfn_mapped << PAGE_SHIFT,
+					PAGE_SIZE, PAGE_SIZE);
+		if (!ret)
+			panic("alloc_low_page: can not alloc memory");
+		memblock_reserve(ret, PAGE_SIZE);
+		pfn = ret >> PAGE_SHIFT;
+	} else
+		pfn = pgt_buf_end++;
+
+	adr = __va(pfn * PAGE_SIZE);
+	clear_page(adr);
+	return adr;
+}
+
 /* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
 #define INIT_PGT_BUF_SIZE	(5 * PAGE_SIZE)
 RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 7bb1106..a7f2df1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -53,36 +53,14 @@
 #include <asm/page_types.h>
 #include <asm/init.h>
 
+#include "mm_internal.h"
+
 unsigned long highstart_pfn, highend_pfn;
 
 static noinline int do_test_wp_bit(void);
 
 bool __read_mostly __vmalloc_start_set = false;
 
-static __init void *alloc_low_page(void)
-{
-	unsigned long pfn;
-	void *adr;
-
-	if ((pgt_buf_end + 1) >= pgt_buf_top) {
-		unsigned long ret;
-		if (min_pfn_mapped >= max_pfn_mapped)
-			panic("alloc_low_page: ran out of memory");
-		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
-					max_pfn_mapped << PAGE_SHIFT,
-					PAGE_SIZE, PAGE_SIZE);
-		if (!ret)
-			panic("alloc_low_page: can not alloc memory");
-		memblock_reserve(ret, PAGE_SIZE);
-		pfn = ret >> PAGE_SHIFT;
-	} else
-		pfn = pgt_buf_end++;
-
-	adr = __va(pfn * PAGE_SIZE);
-	clear_page(adr);
-	return adr;
-}
-
 /*
  * Creates a middle page table and puts a pointer to it in the
  * given global directory entry. This only returns the gd entry
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1960820..1d53def 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -54,6 +54,8 @@
 #include <asm/uv/uv.h>
 #include <asm/setup.h>
 
+#include "mm_internal.h"
+
 static int __init parse_direct_gbpages_off(char *arg)
 {
 	direct_gbpages = 0;
@@ -314,36 +316,6 @@ void __init cleanup_highmap(void)
 	}
 }
 
-static __ref void *alloc_low_page(void)
-{
-	unsigned long pfn;
-	void *adr;
-
-	if (after_bootmem) {
-		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
-
-		return adr;
-	}
-
-	if ((pgt_buf_end + 1) >= pgt_buf_top) {
-		unsigned long ret;
-		if (min_pfn_mapped >= max_pfn_mapped)
-			panic("alloc_low_page: ran out of memory");
-		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
-					max_pfn_mapped << PAGE_SHIFT,
-					PAGE_SIZE, PAGE_SIZE);
-		if (!ret)
-			panic("alloc_low_page: can not alloc memory");
-		memblock_reserve(ret, PAGE_SIZE);
-		pfn = ret >> PAGE_SHIFT;
-	} else
-		pfn = pgt_buf_end++;
-
-	adr = __va(pfn * PAGE_SIZE);
-	clear_page(adr);
-	return adr;
-}
-
 static unsigned long __meminit
 phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 	      pgprot_t prot)
diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
new file mode 100644
index 0000000..b3f993a
--- /dev/null
+++ b/arch/x86/mm/mm_internal.h
@@ -0,0 +1,6 @@
+#ifndef __X86_MM_INTERNAL_H
+#define __X86_MM_INTERNAL_H
+
+void *alloc_low_page(void);
+
+#endif	/* __X86_MM_INTERNAL_H */
