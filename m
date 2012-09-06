Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2IFNX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:23:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45337 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531Ab2IFNXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:23:24 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2012 09:23:23 EDT
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4meCarretero?= <cJ-ko@zougloub.eu>,
        Jan Beulich <jbeulich@suse.com>, Matthew Garrett <mjg@redhat.com>,
        Vasco Dias <rafa.vasco@gmail.com>
Subject: [PATCH] x86, efi: 1:1 pagetable mapping for virtual EFI calls
Date: Thu,  6 Sep 2012 14:15:09 +0100
Message-Id: <1346937309-1581-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Some firmware still needs a 1:1 (virt->phys) mapping even after we've
called SetVirtualAddressMap(). So install the mapping alongside our
existing kernel mapping whenever we make EFI calls in virtual mode.

This bug was discovered on ASUS machines where the firmware
implementation of GetTime() accesses the RTC device via physical
addresses, even though that's bogus per the UEFI spec since we've
informed the firmware via SetVirtualAddressMap() that the boottime
memory map is no longer valid.

This bug seems to be present in a lot of consumer devices, so there's
not a lot we can do about this spec violation apart from workaround
it.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: JérômeCarretero <cJ-ko@zougloub.eu>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Vasco Dias <rafa.vasco@gmail.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/efi.h     |   28 ++++++--
 arch/x86/include/asm/pgalloc.h |    2 +
 arch/x86/mm/pgtable.c          |    2 -
 arch/x86/platform/efi/efi.c    |  132 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi_64.c |   45 ++++++++++++++
 5 files changed, 200 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index c9dcc18..2ba6f86 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -69,23 +69,37 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5), (u64)(a6))
 
+extern pgd_t *efi_call_virt_prelog(void);
+extern void efi_call_virt_epilog(pgd_t *);
+
+#define efi_callx(x, func, ...)					\
+	({							\
+		efi_status_t __status;				\
+		pgd_t *__pgd;					\
+								\
+		__pgd = efi_call_virt_prelog();			\
+		__status = efi_call##x(func, __VA_ARGS__);	\
+		efi_call_virt_epilog(__pgd);			\
+		__status;					\
+	})
+
 #define efi_call_virt0(f)				\
-	efi_call0((void *)(efi.systab->runtime->f))
+	efi_callx(0, (void *)(efi.systab->runtime->f))
 #define efi_call_virt1(f, a1)					\
-	efi_call1((void *)(efi.systab->runtime->f), (u64)(a1))
+	efi_callx(1, (void *)(efi.systab->runtime->f), (u64)(a1))
 #define efi_call_virt2(f, a1, a2)					\
-	efi_call2((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
+	efi_callx(2, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
 #define efi_call_virt3(f, a1, a2, a3)					\
-	efi_call3((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(3, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3))
 #define efi_call_virt4(f, a1, a2, a3, a4)				\
-	efi_call4((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(4, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4))
 #define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(5, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5))
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(6, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index b4389a4..ade0804 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -5,6 +5,8 @@
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
 
+#define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
+
 static inline int  __paravirt_pgd_alloc(struct mm_struct *mm) { return 0; }
 
 #ifdef CONFIG_PARAVIRT
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..e999bb5 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -5,8 +5,6 @@
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
 
-#define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
-
 #ifdef CONFIG_HIGHPTE
 #define PGALLOC_USER_GFP __GFP_HIGHMEM
 #else
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2dc29f5..d17243f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -47,6 +47,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
+#include <asm/pgalloc.h>
 
 #define EFI_DEBUG	1
 
@@ -741,6 +742,114 @@ static void __init runtime_code_page_mkexec(void)
 	}
 }
 
+#ifdef CONFIG_X86_64
+pgd_t *efi_one_to_one_pgd;
+int efi_one_to_one_index = 0;
+
+struct efi_pgtable {
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	u64 addr;
+};
+
+static int efi_pgd_entry(pgd_t *virt_pgd, unsigned long addr,
+			 unsigned long next, struct mm_walk *walk)
+{
+	struct efi_pgtable *ep = (struct efi_pgtable *)walk->private;
+
+	ep->pgd = efi_one_to_one_pgd + pgd_index(ep->addr);
+	if (!pgd_present(*ep->pgd)) {
+		if (!pud_alloc(walk->mm, ep->pgd, ep->addr))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int efi_pte_entry(pte_t *virt_pte, unsigned long addr,
+			 unsigned long next, struct mm_walk *walk)
+{
+	struct efi_pgtable *ep = (struct efi_pgtable *)walk->private;
+	pte_t *phys_pte;
+
+	phys_pte = pte_offset_kernel(ep->pmd, ep->addr);
+	set_pte(phys_pte, *virt_pte);
+	ep->addr += PAGE_SIZE;
+
+	return 0;
+}
+
+static int efi_pmd_entry(pmd_t *virt_pmd, unsigned long addr,
+			 unsigned long next, struct mm_walk *walk)
+{
+	struct efi_pgtable *ep = (struct efi_pgtable *)walk->private;
+
+	ep->pmd = pmd_offset(ep->pud, ep->addr);
+	if (pmd_large(*virt_pmd)) {
+		set_pmd(ep->pmd, *virt_pmd);
+		ep->addr += (1 << PG_LEVEL_2M);
+
+		/* Skip the pte */
+		walk->pte_entry = NULL;
+		return 0;
+	}
+
+	walk->pte_entry = efi_pte_entry;
+
+	if (!pmd_present(*ep->pmd)) {
+		if (!pte_alloc_kernel(ep->pmd, ep->addr))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int efi_pud_entry(pud_t *virt_pud, unsigned long addr,
+			 unsigned long next, struct mm_walk *walk)
+{
+	struct efi_pgtable *ep = (struct efi_pgtable *)walk->private;
+
+	ep->pud = pud_offset(ep->pgd, ep->addr);
+	if (pud_large(*virt_pud)) {
+		set_pud(ep->pud, *virt_pud);
+		ep->addr += (1 << PG_LEVEL_1G);
+
+		/* Skip the pmd/pte */
+		walk->pmd_entry = NULL;
+		walk->pte_entry = NULL;
+		return 0;
+	}
+
+	walk->pmd_entry = efi_pmd_entry;
+	walk->pte_entry = efi_pte_entry;
+
+	if (!pud_present(*ep->pud)) {
+		if (!pmd_alloc(walk->mm, ep->pud, ep->addr))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int efi_insert_one_to_one_mapping(u64 phys_addr, u64 virt_addr,
+					 unsigned long size)
+{
+	struct efi_pgtable ep;
+	struct mm_walk walk = {
+		.pgd_entry = efi_pgd_entry,
+		.pud_entry = efi_pud_entry,
+		.pmd_entry = efi_pmd_entry,
+		.pte_entry = efi_pte_entry,
+		.mm = &init_mm,
+		.private = (void *)&ep,
+	};
+
+	ep.addr = phys_addr;
+	return walk_page_range(virt_addr, virt_addr + size, &walk);
+}
+#endif /* CONFIG_X86_64 */
+
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
@@ -795,6 +904,11 @@ void __init efi_enter_virtual_mode(void)
 		prev_md = md;
 	}
 
+
+#ifdef CONFIG_X86_64
+	efi_one_to_one_pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
+#endif
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
@@ -839,6 +953,24 @@ void __init efi_enter_virtual_mode(void)
 		memcpy(new_memmap + (count * memmap.desc_size), md,
 		       memmap.desc_size);
 		count++;
+
+#ifdef CONFIG_X86_64
+		/*
+		 * Some firmware, notably that from ASUS, still
+		 * attempts to access the physical address space after
+		 * we've called SetVirtualAddressMap().
+		 *
+		 * Maintain a 1:1 mapping virt->phys which only exists
+		 * for the benefit of this broken firmware, the kernel
+		 * MUST NOT access addresses via the 1:1 mapping
+		 * directly, doing so has been known to cause issues
+		 * on Apple firmware.
+		 */
+		if (efi_insert_one_to_one_mapping(md->phys_addr,
+						  md->virt_addr, size))
+			pr_alert("Unable to map address 1:1 0x%llx\n",
+				 md->phys_addr);
+#endif /* CONFIG_X86_64 */
 	}
 
 	BUG_ON(!efi.systab);
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ac3aa54..b11d40f 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -37,6 +37,10 @@
 #include <asm/efi.h>
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
+#include <asm/pgalloc.h>
+
+extern pgd_t *efi_one_to_one_pgd;
+extern int efi_one_to_one_index;
 
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
@@ -58,6 +62,47 @@ static void __init early_code_mapping_set_exec(int executable)
 	}
 }
 
+pgd_t *efi_call_virt_prelog(void)
+{
+	pgd_t *save;
+	int i;
+
+	save = kmalloc(sizeof(pgd_t) * (efi_one_to_one_index + 1), GFP_KERNEL);
+	if (!save) {
+		pr_alert("Unable to save pgd entries\n");
+		return NULL;
+	}
+
+	for (i = 0; i <= efi_one_to_one_index; i++) {
+		pgd_t *pgd = __va(read_cr3() & PHYSICAL_PAGE_MASK);
+
+		pgd += i;
+		save[i] = *pgd;
+		set_pgd(pgd, efi_one_to_one_pgd[i]);
+	}
+
+	__flush_tlb_all();
+	return save;
+}
+
+void efi_call_virt_epilog(pgd_t *save)
+{
+	int i;
+
+	if (!save)
+		return;
+
+	for (i = 0; i <= efi_one_to_one_index; i++) {
+		pgd_t *pgd = __va(read_cr3() & PHYSICAL_PAGE_MASK);
+
+		pgd += i;
+		set_pgd(pgd, save[i]);
+	}
+
+	kfree(save);
+	__flush_tlb_all();
+}
+
 void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
-- 
1.7.4.4

