Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3AITAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:00:19 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59840 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab3AITAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:00:17 -0500
Subject: [RFCv3][PATCH 1/3] create slow_virt_to_phys()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 09 Jan 2013 13:59:04 -0500
Message-Id: <20130109185904.DD641DCE@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010919-3620-0000-0000-000000DA6873
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Broadening the cc list here a bit...  This bug is still present,
and I still need these patches to boot 32-bit NUMA kernels.  They
might be obscure, but if we don't care about them any more, perhaps
we should go remove the NUMA remapping code instead of this.

--

This is necessary because __pa() does not work on some kinds of
memory, like vmalloc() or the alloc_remap() areas on 32-bit
NUMA systems.  We have some functions to do conversions _like_
this in the vmalloc() code (like vmalloc_to_page()), but they
do not work on sizes other than 4k pages.  We would potentially
need to be able to handle all the page sizes that we use for
the kernel linear mapping (4k, 2M, 1G).

In practice, on 32-bit NUMA systems, the percpu areas get stuck
in the alloc_remap() area.  Any __pa() call on them will break
and basically return garbage.

This patch introduces a new function slow_virt_to_phys(), which
walks the kernel page tables on x86 and should do precisely
the same logical thing as __pa(), but actually work on a wider
range of memory.  It should work on the normal linear mapping,
vmalloc(), kmap(), etc...


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/include/asm/pgtable_types.h |    1 
 linux-2.6.git-dave/arch/x86/mm/pageattr.c               |   47 ++++++++++++++++
 2 files changed, 48 insertions(+)

diff -puN arch/x86/include/asm/pgtable_types.h~create-slow_virt_to_phys arch/x86/include/asm/pgtable_types.h
--- linux-2.6.git/arch/x86/include/asm/pgtable_types.h~create-slow_virt_to_phys	2013-01-09 13:55:39.370629437 -0500
+++ linux-2.6.git-dave/arch/x86/include/asm/pgtable_types.h	2013-01-09 13:55:39.386629577 -0500
@@ -352,6 +352,7 @@ static inline void update_page_count(int
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
+extern phys_addr_t slow_virt_to_phys(void *__address);
 
 #endif	/* !__ASSEMBLY__ */
 
diff -puN arch/x86/mm/pageattr.c~create-slow_virt_to_phys arch/x86/mm/pageattr.c
--- linux-2.6.git/arch/x86/mm/pageattr.c~create-slow_virt_to_phys	2013-01-09 13:55:39.370629437 -0500
+++ linux-2.6.git-dave/arch/x86/mm/pageattr.c	2013-01-09 13:55:39.386629577 -0500
@@ -364,6 +364,53 @@ pte_t *lookup_address(unsigned long addr
 EXPORT_SYMBOL_GPL(lookup_address);
 
 /*
+ * This is necessary because __pa() does not work on some
+ * kinds of memory, like vmalloc() or the alloc_remap()
+ * areas on 32-bit NUMA systems.  The percpu areas can
+ * end up in this kind of memory, for instance.
+ *
+ * This could be optimized, but it is only intended to be
+ * used at inititalization time, and keeping it
+ * unoptimized should increase the testing coverage for
+ * the more obscure platforms.
+ */
+phys_addr_t slow_virt_to_phys(void *__virt_addr)
+{
+	unsigned long virt_addr = (unsigned long)__virt_addr;
+	phys_addr_t phys_addr;
+	unsigned long offset;
+	unsigned int level = -1;
+	unsigned long psize = 0;
+	unsigned long pmask = 0;
+	pte_t *pte;
+
+	pte = lookup_address(virt_addr, &level);
+	BUG_ON(!pte);
+	switch (level) {
+	case PG_LEVEL_4K:
+		psize = PAGE_SIZE;
+		pmask = PAGE_MASK;
+		break;
+	case PG_LEVEL_2M:
+		psize = PMD_PAGE_SIZE;
+		pmask = PMD_PAGE_MASK;
+		break;
+#ifdef CONFIG_X86_64
+	case PG_LEVEL_1G:
+		psize = PUD_PAGE_SIZE;
+		pmask = PUD_PAGE_MASK;
+		break;
+#endif
+	default:
+		BUG();
+	}
+	offset = virt_addr & ~pmask;
+	phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
+	return (phys_addr | offset);
+}
+EXPORT_SYMBOL_GPL(slow_virt_to_phys);
+
+/*
  * Set the new pmd in all the pgds we know about:
  */
 static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
_

