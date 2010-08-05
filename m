Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285Ab0HEUkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:40:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:52036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760728Ab0HEUjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:39:55 -0400
Date: Thu, 5 Aug 2010 20:38:04 GMT
Message-Id: <201008052038.o75Kc45l022109@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/mm for 2.6.36
Cc: <stable@kernel.org>, Andres Salomon <dilinger@queued.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Florian Zumbiehl <florz@florz.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Slaby <jslaby@suse.cz>, Jordan Crouse <jordan.crouse@amd.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcin Kocielnicki <koriakin@0x04.net>,
        Marcin Slusarz <marcin.slusarz@gmail.com>, Pekka Paalanen <pq@iki.fi>,
        Shinpei KATO <shinpei@il.is.s.u-tokyo.ac.jp>,
        Stuart Bennett <stuart@freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        nouveau@lists.freedesktop.org
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 20:38:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 540ad6b62b3a188a53b51cac81d8a60d40e29fbd:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb (2010-07-28 20:01:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mm-for-linus

Andres Salomon (1):
      x86, mm: Create symbolic index into address_markers array

Borislav Petkov (1):
      x86, tlb: Clean up and correct used type

Florian Zumbiehl (1):
      x86, iomap: Fix wrong page aligned size calculation in ioremapping code

Jiri Slaby (1):
      x86-64, mm: Initialize VDSO earlier on 64 bits

Kenji Kaneshige (2):
      x86, ioremap: Fix incorrect physical address handling in PAE mode
      x86, ioremap: Fix normal ram range check

Marcin Slusarz (1):
      x86, kmmio/mmiotrace: Fix double free of kmmio_fault_pages

Yasuaki Ishimatsu (1):
      x86: Ioremap: fix wrong physical address handling in PAT code

 arch/x86/mm/dump_pagetables.c |   32 ++++++++++++++++++++++++++------
 arch/x86/mm/ioremap.c         |   14 ++++++--------
 arch/x86/mm/kmmio.c           |   16 +++++++++++++---
 arch/x86/mm/pat.c             |    2 +-
 arch/x86/mm/testmmiotrace.c   |   22 ++++++++++++++++++++++
 arch/x86/mm/tlb.c             |    4 +---
 arch/x86/vdso/vdso32-setup.c  |    2 +-
 arch/x86/vdso/vma.c           |    2 +-
 include/linux/io.h            |    4 ++--
 include/linux/vmalloc.h       |    2 +-
 lib/ioremap.c                 |   10 +++++-----
 mm/vmalloc.c                  |    2 +-
 12 files changed, 80 insertions(+), 32 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index a725b7f..0002a3a 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -37,6 +37,28 @@ struct addr_marker {
 	const char *name;
 };
 
+/* indices for address_markers; keep sync'd w/ address_markers below */
+enum address_markers_idx {
+	USER_SPACE_NR = 0,
+#ifdef CONFIG_X86_64
+	KERNEL_SPACE_NR,
+	LOW_KERNEL_NR,
+	VMALLOC_START_NR,
+	VMEMMAP_START_NR,
+	HIGH_KERNEL_NR,
+	MODULES_VADDR_NR,
+	MODULES_END_NR,
+#else
+	KERNEL_SPACE_NR,
+	VMALLOC_START_NR,
+	VMALLOC_END_NR,
+# ifdef CONFIG_HIGHMEM
+	PKMAP_BASE_NR,
+# endif
+	FIXADDR_START_NR,
+#endif
+};
+
 /* Address space markers hints */
 static struct addr_marker address_markers[] = {
 	{ 0, "User Space" },
@@ -331,14 +353,12 @@ static int pt_dump_init(void)
 
 #ifdef CONFIG_X86_32
 	/* Not a compile-time constant on x86-32 */
-	address_markers[2].start_address = VMALLOC_START;
-	address_markers[3].start_address = VMALLOC_END;
+	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
+	address_markers[VMALLOC_END_NR].start_address = VMALLOC_END;
 # ifdef CONFIG_HIGHMEM
-	address_markers[4].start_address = PKMAP_BASE;
-	address_markers[5].start_address = FIXADDR_START;
-# else
-	address_markers[4].start_address = FIXADDR_START;
+	address_markers[PKMAP_BASE_NR].start_address = PKMAP_BASE;
 # endif
+	address_markers[FIXADDR_START_NR].start_address = FIXADDR_START;
 #endif
 
 	pe = debugfs_create_file("kernel_page_tables", 0600, NULL, NULL,
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12e4d2d..3ba6e06 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -62,8 +62,8 @@ int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		unsigned long size, unsigned long prot_val, void *caller)
 {
-	unsigned long pfn, offset, vaddr;
-	resource_size_t last_addr;
+	unsigned long offset, vaddr;
+	resource_size_t pfn, last_pfn, last_addr;
 	const resource_size_t unaligned_phys_addr = phys_addr;
 	const unsigned long unaligned_size = size;
 	struct vm_struct *area;
@@ -100,10 +100,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
-	for (pfn = phys_addr >> PAGE_SHIFT;
-				(pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
-				pfn++) {
-
+	last_pfn = last_addr >> PAGE_SHIFT;
+	for (pfn = phys_addr >> PAGE_SHIFT; pfn <= last_pfn; pfn++) {
 		int is_ram = page_is_ram(pfn);
 
 		if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
@@ -115,7 +113,7 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
+	phys_addr &= PHYSICAL_PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
 	retval = reserve_memtype(phys_addr, (u64)phys_addr + size,
@@ -613,7 +611,7 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 		return;
 	}
 	offset = virt_addr & ~PAGE_MASK;
-	nrpages = PAGE_ALIGN(offset + size - 1) >> PAGE_SHIFT;
+	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
 
 	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 5d0e67f..e5d5e2c 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -45,6 +45,8 @@ struct kmmio_fault_page {
 	 * Protected by kmmio_lock, when linked into kmmio_page_table.
 	 */
 	int count;
+
+	bool scheduled_for_release;
 };
 
 struct kmmio_delayed_release {
@@ -398,8 +400,11 @@ static void release_kmmio_fault_page(unsigned long page,
 	BUG_ON(f->count < 0);
 	if (!f->count) {
 		disarm_kmmio_fault_page(f);
-		f->release_next = *release_list;
-		*release_list = f;
+		if (!f->scheduled_for_release) {
+			f->release_next = *release_list;
+			*release_list = f;
+			f->scheduled_for_release = true;
+		}
 	}
 }
 
@@ -471,8 +476,10 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
 			prevp = &f->release_next;
 		} else {
 			*prevp = f->release_next;
+			f->release_next = NULL;
+			f->scheduled_for_release = false;
 		}
-		f = f->release_next;
+		f = *prevp;
 	}
 	spin_unlock_irqrestore(&kmmio_lock, flags);
 
@@ -510,6 +517,9 @@ void unregister_kmmio_probe(struct kmmio_probe *p)
 	kmmio_count--;
 	spin_unlock_irqrestore(&kmmio_lock, flags);
 
+	if (!release_list)
+		return;
+
 	drelease = kmalloc(sizeof(*drelease), GFP_ATOMIC);
 	if (!drelease) {
 		pr_crit("leaking kmmio_fault_page objects.\n");
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 64121a1..f6ff57b 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -158,7 +158,7 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 	return req_type;
 }
 
-static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
+static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
 {
 	int ram_page = 0, not_rampage = 0;
 	unsigned long page_nr;
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index 8565d94..38868ad 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -90,6 +90,27 @@ static void do_test(unsigned long size)
 	iounmap(p);
 }
 
+/*
+ * Tests how mmiotrace behaves in face of multiple ioremap / iounmaps in
+ * a short time. We had a bug in deferred freeing procedure which tried
+ * to free this region multiple times (ioremap can reuse the same address
+ * for many mappings).
+ */
+static void do_test_bulk_ioremapping(void)
+{
+	void __iomem *p;
+	int i;
+
+	for (i = 0; i < 10; ++i) {
+		p = ioremap_nocache(mmio_address, PAGE_SIZE);
+		if (p)
+			iounmap(p);
+	}
+
+	/* Force freeing. If it will crash we will know why. */
+	synchronize_rcu();
+}
+
 static int __init init(void)
 {
 	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
@@ -104,6 +125,7 @@ static int __init init(void)
 		   "and writing 16 kB of rubbish in there.\n",
 		   size >> 10, mmio_address);
 	do_test(size);
+	do_test_bulk_ioremapping();
 	pr_info("All done.\n");
 	return 0;
 }
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 426f3a1..c03f14a 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -278,11 +278,9 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 
 static void do_flush_tlb_all(void *info)
 {
-	unsigned long cpu = smp_processor_id();
-
 	__flush_tlb_all();
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
+		leave_mm(smp_processor_id());
 }
 
 void flush_tlb_all(void)
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 02b442e..36df991 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -374,7 +374,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 #ifdef CONFIG_X86_64
 
-__initcall(sysenter_setup);
+subsys_initcall(sysenter_setup);
 
 #ifdef CONFIG_SYSCTL
 /* Register vsyscall32 into the ABI table */
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index ac74869..43456ee 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -74,7 +74,7 @@ static int __init init_vdso_vars(void)
 	vdso_enabled = 0;
 	return -ENOMEM;
 }
-__initcall(init_vdso_vars);
+subsys_initcall(init_vdso_vars);
 
 struct linux_binprm;
 
diff --git a/include/linux/io.h b/include/linux/io.h
index 6c7f0ba..7fd2d21 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -29,10 +29,10 @@ void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
 #ifdef CONFIG_MMU
 int ioremap_page_range(unsigned long addr, unsigned long end,
-		       unsigned long phys_addr, pgprot_t prot);
+		       phys_addr_t phys_addr, pgprot_t prot);
 #else
 static inline int ioremap_page_range(unsigned long addr, unsigned long end,
-				     unsigned long phys_addr, pgprot_t prot)
+				     phys_addr_t phys_addr, pgprot_t prot)
 {
 	return 0;
 }
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 227c2a5..de05e96 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -30,7 +30,7 @@ struct vm_struct {
 	unsigned long		flags;
 	struct page		**pages;
 	unsigned int		nr_pages;
-	unsigned long		phys_addr;
+	phys_addr_t		phys_addr;
 	void			*caller;
 };
 
diff --git a/lib/ioremap.c b/lib/ioremap.c
index 14c6078..5730ecd 100644
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
@@ -13,10 +13,10 @@
 #include <asm/pgtable.h>
 
 static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pte_t *pte;
-	unsigned long pfn;
+	u64 pfn;
 
 	pfn = phys_addr >> PAGE_SHIFT;
 	pte = pte_alloc_kernel(pmd, addr);
@@ -31,7 +31,7 @@ static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
 }
 
 static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -49,7 +49,7 @@ static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
 }
 
 static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -67,7 +67,7 @@ static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
 }
 
 int ioremap_page_range(unsigned long addr,
-		       unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		       unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pgd_t *pgd;
 	unsigned long start;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ae00746..b7e314b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2403,7 +2403,7 @@ static int s_show(struct seq_file *m, void *p)
 		seq_printf(m, " pages=%d", v->nr_pages);
 
 	if (v->phys_addr)
-		seq_printf(m, " phys=%lx", v->phys_addr);
+		seq_printf(m, " phys=%llx", (unsigned long long)v->phys_addr);
 
 	if (v->flags & VM_IOREMAP)
 		seq_printf(m, " ioremap");
