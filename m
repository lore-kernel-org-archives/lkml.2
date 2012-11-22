Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016Ab2KVS6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964980Ab2KVS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:48 -0500
Date: Wed, 21 Nov 2012 17:38:26 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-fa62aafea9e415cd1efd8c4054106112fe809f19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <1353123563-3103-2-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-2-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Add global page_size_mask and probe one time only
Git-Commit-ID: fa62aafea9e415cd1efd8c4054106112fe809f19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:38:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa62aafea9e415cd1efd8c4054106112fe809f19
Gitweb:     http://git.kernel.org/tip/fa62aafea9e415cd1efd8c4054106112fe809f19
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:38 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:00 -0800

x86, mm: Add global page_size_mask and probe one time only

Now we pass around use_gbpages and use_pse for calculating page table size,
Later we will need to call init_memory_mapping for every ram range one by one,
that mean those calculation will be done several times.

Those information are the same for all ram range and could be stored in
page_size_mask and could be probed it one time only.

Move that probing code out of init_memory_mapping into separated function
probe_page_size_mask(), and call it before all init_memory_mapping.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-2-git-send-email-yinghai@kernel.org
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/pgtable.h |  1 +
 arch/x86/kernel/setup.c        |  1 +
 arch/x86/mm/init.c             | 55 +++++++++++++++++++-----------------------
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a1f780d..98ac76d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -602,6 +602,7 @@ static inline int pgd_none(pgd_t pgd)
 #ifndef __ASSEMBLY__
 
 extern int direct_gbpages;
+void probe_page_size_mask(void);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca45696..01fb5f9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -913,6 +913,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	init_gbpages();
+	probe_page_size_mask();
 
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d7aea41..aa5b0da 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -35,6 +35,7 @@ struct map_range {
 	unsigned page_size_mask;
 };
 
+static int page_size_mask;
 /*
  * First calculate space needed for kernel direct mapping page tables to cover
  * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
@@ -94,6 +95,30 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
+void probe_page_size_mask(void)
+{
+#if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	if (direct_gbpages)
+		page_size_mask |= 1 << PG_LEVEL_1G;
+	if (cpu_has_pse)
+		page_size_mask |= 1 << PG_LEVEL_2M;
+#endif
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+}
 void __init native_pagetable_reserve(u64 start, u64 end)
 {
 	memblock_reserve(start, end - start);
@@ -129,45 +154,15 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
-	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
 	unsigned long ret = 0;
 	unsigned long pos;
-
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
-	int use_pse, use_gbpages;
 
 	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
 	       start, end - 1);
 
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-	/*
-	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
-	 * This will simplify cpa(), which otherwise needs to support splitting
-	 * large pages into small in interrupt context, etc.
-	 */
-	use_pse = use_gbpages = 0;
-#else
-	use_pse = cpu_has_pse;
-	use_gbpages = direct_gbpages;
-#endif
-
-	/* Enable PSE if available */
-	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
-
-	/* Enable PGE if available */
-	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
-		__supported_pte_mask |= _PAGE_GLOBAL;
-	}
-
-	if (use_gbpages)
-		page_size_mask |= 1 << PG_LEVEL_1G;
-	if (use_pse)
-		page_size_mask |= 1 << PG_LEVEL_2M;
-
 	memset(mr, 0, sizeof(mr));
 	nr_range = 0;
 
