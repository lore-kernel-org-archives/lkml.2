Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2KVUna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:43:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab2KVS6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:46 -0500
Date: Wed, 21 Nov 2012 17:41:33 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-22ddfcaa0dbae992332381d41b8a1fbc72269a13@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1353123563-3103-5-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-5-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Move init_memory_mapping calling out of setup.c
Git-Commit-ID: 22ddfcaa0dbae992332381d41b8a1fbc72269a13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:41:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22ddfcaa0dbae992332381d41b8a1fbc72269a13
Gitweb:     http://git.kernel.org/tip/22ddfcaa0dbae992332381d41b8a1fbc72269a13
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:41 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:03 -0800

x86, mm: Move init_memory_mapping calling out of setup.c

Now init_memory_mapping is called two times, later will be called for every
ram ranges.

Could put all related init_mem calling together and out of setup.c.

Actually, it reverts commit 1bbbbe7
    x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.
will address that later with complete solution include handling hole under 4g.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-5-git-send-email-yinghai@kernel.org
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/init.h    |  1 -
 arch/x86/include/asm/pgtable.h |  2 +-
 arch/x86/kernel/setup.c        | 27 +--------------------------
 arch/x86/mm/init.c             | 19 ++++++++++++++++++-
 4 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index adcc0ae..4f13998 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -12,7 +12,6 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask);
 
-
 extern unsigned long __initdata pgt_buf_start;
 extern unsigned long __meminitdata pgt_buf_end;
 extern unsigned long __meminitdata pgt_buf_top;
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 98ac76d..dd1a888 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -602,7 +602,7 @@ static inline int pgd_none(pgd_t pgd)
 #ifndef __ASSEMBLY__
 
 extern int direct_gbpages;
-void probe_page_size_mask(void);
+void init_mem_mapping(void);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 01fb5f9..23b079f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -913,34 +913,9 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	init_gbpages();
-	probe_page_size_mask();
 
-	/* max_pfn_mapped is updated here */
-	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
-	max_pfn_mapped = max_low_pfn_mapped;
+	init_mem_mapping();
 
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		int i;
-		unsigned long start, end;
-		unsigned long start_pfn, end_pfn;
-
-		for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn,
-							 NULL) {
-
-			end = PFN_PHYS(end_pfn);
-			if (end <= (1UL<<32))
-				continue;
-
-			start = PFN_PHYS(start_pfn);
-			max_pfn_mapped = init_memory_mapping(
-						max((1UL<<32), start), end);
-		}
-
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
 	memblock.current_limit = get_max_mapped();
 	dma_contiguous_reserve(0);
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 701abbc..9e17f9e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -37,7 +37,7 @@ struct map_range {
 
 static int page_size_mask;
 
-void probe_page_size_mask(void)
+static void __init probe_page_size_mask(void)
 {
 #if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
 	/*
@@ -315,6 +315,23 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	return ret >> PAGE_SHIFT;
 }
 
+void __init init_mem_mapping(void)
+{
+	probe_page_size_mask();
+
+	/* max_pfn_mapped is updated here */
+	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
+	max_pfn_mapped = max_low_pfn_mapped;
+
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		max_pfn_mapped = init_memory_mapping(1UL<<32,
+						     max_pfn<<PAGE_SHIFT);
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
+}
 
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
