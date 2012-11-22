Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab2KVU5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:57:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab2KVS6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:30 -0500
Date: Wed, 21 Nov 2012 18:18:13 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-4e37a890474b89ca49ad6b3651b1709a17d7c216@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-40-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-40-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Unifying after_bootmem for 32bit and 64bit
Git-Commit-ID: 4e37a890474b89ca49ad6b3651b1709a17d7c216
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:18:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e37a890474b89ca49ad6b3651b1709a17d7c216
Gitweb:     http://git.kernel.org/tip/4e37a890474b89ca49ad6b3651b1709a17d7c216
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:16 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:44 -0800

x86, mm: Unifying after_bootmem for 32bit and 64bit

after_bootmem has different meaning in 32bit and 64bit.
        32bit: after bootmem is ready
        64bit: after bootmem is distroyed
Let's merget them make 32bit the same as 64bit.

for 32bit, it is mixing alloc_bootmem_pages, and alloc_low_page under
after_bootmem is set or not set.

alloc_bootmem is just wrapper for memblock for x86.

Now we have alloc_low_page() with memblock too. We can drop bootmem path
now, and only alloc_low_page only.

At the same time, we make alloc_low_page could handle real after_bootmem
for 32bit, because alloc_bootmem_pages could fallback to use slab too.

At last move after_bootmem set position for 32bit the same as 64bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-40-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c    |  2 --
 arch/x86/mm/init_32.c | 21 ++++-----------------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f410dc6..2a27e5a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -39,7 +39,6 @@ __ref void *alloc_low_pages(unsigned int num)
 	unsigned long pfn;
 	int i;
 
-#ifdef CONFIG_X86_64
 	if (after_bootmem) {
 		unsigned int order;
 
@@ -47,7 +46,6 @@ __ref void *alloc_low_pages(unsigned int num)
 		return (void *)__get_free_pages(GFP_ATOMIC | __GFP_NOTRACK |
 						__GFP_ZERO, order);
 	}
-#endif
 
 	if ((pgt_buf_end + num) >= pgt_buf_top) {
 		unsigned long ret;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 19ef9f0..f4fc4a2 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -73,10 +73,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 
 #ifdef CONFIG_X86_PAE
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
-		if (after_bootmem)
-			pmd_table = (pmd_t *)alloc_bootmem_pages(PAGE_SIZE);
-		else
-			pmd_table = (pmd_t *)alloc_low_page();
+		pmd_table = (pmd_t *)alloc_low_page();
 		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
@@ -98,17 +95,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 static pte_t * __init one_page_table_init(pmd_t *pmd)
 {
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
-		pte_t *page_table = NULL;
-
-		if (after_bootmem) {
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-			page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
-#endif
-			if (!page_table)
-				page_table =
-				(pte_t *)alloc_bootmem_pages(PAGE_SIZE);
-		} else
-			page_table = (pte_t *)alloc_low_page();
+		pte_t *page_table = (pte_t *)alloc_low_page();
 
 		paravirt_alloc_pte(&init_mm, __pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
@@ -708,8 +695,6 @@ void __init setup_bootmem_allocator(void)
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
-
-	after_bootmem = 1;
 }
 
 /*
@@ -795,6 +780,8 @@ void __init mem_init(void)
 		if (page_is_ram(tmp) && PageReserved(pfn_to_page(tmp)))
 			reservedpages++;
 
+	after_bootmem = 1;
+
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
