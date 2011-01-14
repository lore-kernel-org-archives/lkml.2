Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1ANCND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:13:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38789 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab1ANCMy (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 13 Jan 2011 21:12:54 -0500
Date: Thu, 13 Jan 2011 21:10:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>
Subject: [GIT PULL] (xen) stable/gntdev for 2.6.38
Message-ID: <20110114021047.GA4034@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please git pull the following git tree:
  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/gntdev

which has patches since git commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:
Linus Torvalds (1):
      Linux 2.6.37

This patchset includes a driver (/dev/xen/gntdev) and infrastructure changes
to allow pages in one guest to be shared with another. In the past this
page accounting was done through some horrible hacks in the generic code.
This patchset presents a much cleaner approach where we keep track of ownership
in Xen MMU code. The drivers/xen/gntdev.c is the main driver for user-space
programs (QEMU) to orchestra this. The benefits of this driver is that users
can start VM guest with QEMU, or use userspace backends in QEMU.


Daniel De Graaf (1):
      xen/gntdev: Fix circular locking dependency

Gerd Hoffmann (1):
      xen/gntdev: allow usermode to map granted pages

Ian Campbell (2):
      xen: define gnttab_set_map_op/unmap_op
      xen: gntdev: move use of GNTMAP_contains_pte next to the map_op

Jeremy Fitzhardinge (5):
      xen/gntdev: add VM_PFNMAP to vma
      xen: move p2m handling to separate file
      xen: add m2p override mechanism
      xen/gntdev: stop using "token" argument
      xen p2m: clear the old pte when adding a page to m2p_override

Konrad Rzeszutek Wilk (1):
      xen/p2m: Fix module linking error.

Stefano Stabellini (3):
      xen p2m: transparently change the p2m mappings in the m2p override
      xen: introduce gnttab_map_refs and gnttab_unmap_refs
      xen gntdev: use gnttab_map_refs and gnttab_unmap_refs

 arch/x86/include/asm/xen/page.h |   16 +-
 arch/x86/xen/Makefile           |    3 +-
 arch/x86/xen/mmu.c              |  365 ---------------------
 arch/x86/xen/p2m.c              |  510 ++++++++++++++++++++++++++++++
 drivers/xen/Kconfig             |    7 +
 drivers/xen/Makefile            |    2 +
 drivers/xen/gntdev.c            |  665 +++++++++++++++++++++++++++++++++++++++
 drivers/xen/grant-table.c       |   46 +++
 include/xen/gntdev.h            |  119 +++++++
 include/xen/grant_table.h       |   44 +++-
 10 files changed, 1407 insertions(+), 370 deletions(-)


diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 8760cc6..f25bdf2 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -42,6 +42,11 @@ extern unsigned int   machine_to_phys_order;
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 
+extern int m2p_add_override(unsigned long mfn, struct page *page);
+extern int m2p_remove_override(struct page *page);
+extern struct page *m2p_find_override(unsigned long mfn);
+extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
+
 static inline unsigned long pfn_to_mfn(unsigned long pfn)
 {
 	unsigned long mfn;
@@ -72,9 +77,6 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return mfn;
 
-	if (unlikely((mfn >> machine_to_phys_order) != 0))
-		return ~0;
-
 	pfn = 0;
 	/*
 	 * The array access can fail (e.g., device space beyond end of RAM).
@@ -83,6 +85,14 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	 */
 	__get_user(pfn, &machine_to_phys_mapping[mfn]);
 
+	/*
+	 * If this appears to be a foreign mfn (because the pfn
+	 * doesn't map back to the mfn), then check the local override
+	 * table to see if there's a better pfn to use.
+	 */
+	if (get_phys_to_machine(pfn) != mfn)
+		pfn = m2p_find_override_pfn(mfn, pfn);
+
 	return pfn;
 }
 
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 7793851..17c565d 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -12,7 +12,8 @@ CFLAGS_mmu.o			:= $(nostackp)
 
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
-			grant-table.o suspend.o platform-pci-unplug.o
+			grant-table.o suspend.o platform-pci-unplug.o \
+			p2m.o
 
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 44924e5..7575e55 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -173,371 +173,6 @@ DEFINE_PER_CPU(unsigned long, xen_current_cr3);	 /* actual vcpu cr3 */
  */
 #define USER_LIMIT	((STACK_TOP_MAX + PGDIR_SIZE - 1) & PGDIR_MASK)
 
-/*
- * Xen leaves the responsibility for maintaining p2m mappings to the
- * guests themselves, but it must also access and update the p2m array
- * during suspend/resume when all the pages are reallocated.
- *
- * The p2m table is logically a flat array, but we implement it as a
- * three-level tree to allow the address space to be sparse.
- *
- *                               Xen
- *                                |
- *     p2m_top              p2m_top_mfn
- *       /  \                   /   \
- * p2m_mid p2m_mid	p2m_mid_mfn p2m_mid_mfn
- *    / \      / \         /           /
- *  p2m p2m p2m p2m p2m p2m p2m ...
- *
- * The p2m_mid_mfn pages are mapped by p2m_top_mfn_p.
- *
- * The p2m_top and p2m_top_mfn levels are limited to 1 page, so the
- * maximum representable pseudo-physical address space is:
- *  P2M_TOP_PER_PAGE * P2M_MID_PER_PAGE * P2M_PER_PAGE pages
- *
- * P2M_PER_PAGE depends on the architecture, as a mfn is always
- * unsigned long (8 bytes on 64-bit, 4 bytes on 32), leading to
- * 512 and 1024 entries respectively. 
- */
-
-unsigned long xen_max_p2m_pfn __read_mostly;
-
-#define P2M_PER_PAGE		(PAGE_SIZE / sizeof(unsigned long))
-#define P2M_MID_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long *))
-#define P2M_TOP_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long **))
-
-#define MAX_P2M_PFN		(P2M_TOP_PER_PAGE * P2M_MID_PER_PAGE * P2M_PER_PAGE)
-
-/* Placeholders for holes in the address space */
-static RESERVE_BRK_ARRAY(unsigned long, p2m_missing, P2M_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_missing, P2M_MID_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long, p2m_mid_missing_mfn, P2M_MID_PER_PAGE);
-
-static RESERVE_BRK_ARRAY(unsigned long **, p2m_top, P2M_TOP_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long, p2m_top_mfn, P2M_TOP_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long *, p2m_top_mfn_p, P2M_TOP_PER_PAGE);
-
-RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
-RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
-
-static inline unsigned p2m_top_index(unsigned long pfn)
-{
-	BUG_ON(pfn >= MAX_P2M_PFN);
-	return pfn / (P2M_MID_PER_PAGE * P2M_PER_PAGE);
-}
-
-static inline unsigned p2m_mid_index(unsigned long pfn)
-{
-	return (pfn / P2M_PER_PAGE) % P2M_MID_PER_PAGE;
-}
-
-static inline unsigned p2m_index(unsigned long pfn)
-{
-	return pfn % P2M_PER_PAGE;
-}
-
-static void p2m_top_init(unsigned long ***top)
-{
-	unsigned i;
-
-	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
-		top[i] = p2m_mid_missing;
-}
-
-static void p2m_top_mfn_init(unsigned long *top)
-{
-	unsigned i;
-
-	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
-		top[i] = virt_to_mfn(p2m_mid_missing_mfn);
-}
-
-static void p2m_top_mfn_p_init(unsigned long **top)
-{
-	unsigned i;
-
-	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
-		top[i] = p2m_mid_missing_mfn;
-}
-
-static void p2m_mid_init(unsigned long **mid)
-{
-	unsigned i;
-
-	for (i = 0; i < P2M_MID_PER_PAGE; i++)
-		mid[i] = p2m_missing;
-}
-
-static void p2m_mid_mfn_init(unsigned long *mid)
-{
-	unsigned i;
-
-	for (i = 0; i < P2M_MID_PER_PAGE; i++)
-		mid[i] = virt_to_mfn(p2m_missing);
-}
-
-static void p2m_init(unsigned long *p2m)
-{
-	unsigned i;
-
-	for (i = 0; i < P2M_MID_PER_PAGE; i++)
-		p2m[i] = INVALID_P2M_ENTRY;
-}
-
-/*
- * Build the parallel p2m_top_mfn and p2m_mid_mfn structures
- *
- * This is called both at boot time, and after resuming from suspend:
- * - At boot time we're called very early, and must use extend_brk()
- *   to allocate memory.
- *
- * - After resume we're called from within stop_machine, but the mfn
- *   tree should alreay be completely allocated.
- */
-void xen_build_mfn_list_list(void)
-{
-	unsigned long pfn;
-
-	/* Pre-initialize p2m_top_mfn to be completely missing */
-	if (p2m_top_mfn == NULL) {
-		p2m_mid_missing_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
-		p2m_mid_mfn_init(p2m_mid_missing_mfn);
-
-		p2m_top_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
-		p2m_top_mfn_p_init(p2m_top_mfn_p);
-
-		p2m_top_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
-		p2m_top_mfn_init(p2m_top_mfn);
-	} else {
-		/* Reinitialise, mfn's all change after migration */
-		p2m_mid_mfn_init(p2m_mid_missing_mfn);
-	}
-
-	for (pfn = 0; pfn < xen_max_p2m_pfn; pfn += P2M_PER_PAGE) {
-		unsigned topidx = p2m_top_index(pfn);
-		unsigned mididx = p2m_mid_index(pfn);
-		unsigned long **mid;
-		unsigned long *mid_mfn_p;
-
-		mid = p2m_top[topidx];
-		mid_mfn_p = p2m_top_mfn_p[topidx];
-
-		/* Don't bother allocating any mfn mid levels if
-		 * they're just missing, just update the stored mfn,
-		 * since all could have changed over a migrate.
-		 */
-		if (mid == p2m_mid_missing) {
-			BUG_ON(mididx);
-			BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
-			p2m_top_mfn[topidx] = virt_to_mfn(p2m_mid_missing_mfn);
-			pfn += (P2M_MID_PER_PAGE - 1) * P2M_PER_PAGE;
-			continue;
-		}
-
-		if (mid_mfn_p == p2m_mid_missing_mfn) {
-			/*
-			 * XXX boot-time only!  We should never find
-			 * missing parts of the mfn tree after
-			 * runtime.  extend_brk() will BUG if we call
-			 * it too late.
-			 */
-			mid_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
-			p2m_mid_mfn_init(mid_mfn_p);
-
-			p2m_top_mfn_p[topidx] = mid_mfn_p;
-		}
-
-		p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
-		mid_mfn_p[mididx] = virt_to_mfn(mid[mididx]);
-	}
-}
-
-void xen_setup_mfn_list_list(void)
-{
-	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
-
-	HYPERVISOR_shared_info->arch.pfn_to_mfn_frame_list_list =
-		virt_to_mfn(p2m_top_mfn);
-	HYPERVISOR_shared_info->arch.max_pfn = xen_max_p2m_pfn;
-}
-
-/* Set up p2m_top to point to the domain-builder provided p2m pages */
-void __init xen_build_dynamic_phys_to_machine(void)
-{
-	unsigned long *mfn_list = (unsigned long *)xen_start_info->mfn_list;
-	unsigned long max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
-	unsigned long pfn;
-
-	xen_max_p2m_pfn = max_pfn;
-
-	p2m_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
-	p2m_init(p2m_missing);
-
-	p2m_mid_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
-	p2m_mid_init(p2m_mid_missing);
-
-	p2m_top = extend_brk(PAGE_SIZE, PAGE_SIZE);
-	p2m_top_init(p2m_top);
-
-	/*
-	 * The domain builder gives us a pre-constructed p2m array in
-	 * mfn_list for all the pages initially given to us, so we just
-	 * need to graft that into our tree structure.
-	 */
-	for (pfn = 0; pfn < max_pfn; pfn += P2M_PER_PAGE) {
-		unsigned topidx = p2m_top_index(pfn);
-		unsigned mididx = p2m_mid_index(pfn);
-
-		if (p2m_top[topidx] == p2m_mid_missing) {
-			unsigned long **mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
-			p2m_mid_init(mid);
-
-			p2m_top[topidx] = mid;
-		}
-
-		p2m_top[topidx][mididx] = &mfn_list[pfn];
-	}
-}
-
-unsigned long get_phys_to_machine(unsigned long pfn)
-{
-	unsigned topidx, mididx, idx;
-
-	if (unlikely(pfn >= MAX_P2M_PFN))
-		return INVALID_P2M_ENTRY;
-
-	topidx = p2m_top_index(pfn);
-	mididx = p2m_mid_index(pfn);
-	idx = p2m_index(pfn);
-
-	return p2m_top[topidx][mididx][idx];
-}
-EXPORT_SYMBOL_GPL(get_phys_to_machine);
-
-static void *alloc_p2m_page(void)
-{
-	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
-}
-
-static void free_p2m_page(void *p)
-{
-	free_page((unsigned long)p);
-}
-
-/* 
- * Fully allocate the p2m structure for a given pfn.  We need to check
- * that both the top and mid levels are allocated, and make sure the
- * parallel mfn tree is kept in sync.  We may race with other cpus, so
- * the new pages are installed with cmpxchg; if we lose the race then
- * simply free the page we allocated and use the one that's there.
- */
-static bool alloc_p2m(unsigned long pfn)
-{
-	unsigned topidx, mididx;
-	unsigned long ***top_p, **mid;
-	unsigned long *top_mfn_p, *mid_mfn;
-
-	topidx = p2m_top_index(pfn);
-	mididx = p2m_mid_index(pfn);
-
-	top_p = &p2m_top[topidx];
-	mid = *top_p;
-
-	if (mid == p2m_mid_missing) {
-		/* Mid level is missing, allocate a new one */
-		mid = alloc_p2m_page();
-		if (!mid)
-			return false;
-
-		p2m_mid_init(mid);
-
-		if (cmpxchg(top_p, p2m_mid_missing, mid) != p2m_mid_missing)
-			free_p2m_page(mid);
-	}
-
-	top_mfn_p = &p2m_top_mfn[topidx];
-	mid_mfn = p2m_top_mfn_p[topidx];
-
-	BUG_ON(virt_to_mfn(mid_mfn) != *top_mfn_p);
-
-	if (mid_mfn == p2m_mid_missing_mfn) {
-		/* Separately check the mid mfn level */
-		unsigned long missing_mfn;
-		unsigned long mid_mfn_mfn;
-
-		mid_mfn = alloc_p2m_page();
-		if (!mid_mfn)
-			return false;
-
-		p2m_mid_mfn_init(mid_mfn);
-
-		missing_mfn = virt_to_mfn(p2m_mid_missing_mfn);
-		mid_mfn_mfn = virt_to_mfn(mid_mfn);
-		if (cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn) != missing_mfn)
-			free_p2m_page(mid_mfn);
-		else
-			p2m_top_mfn_p[topidx] = mid_mfn;
-	}
-
-	if (p2m_top[topidx][mididx] == p2m_missing) {
-		/* p2m leaf page is missing */
-		unsigned long *p2m;
-
-		p2m = alloc_p2m_page();
-		if (!p2m)
-			return false;
-
-		p2m_init(p2m);
-
-		if (cmpxchg(&mid[mididx], p2m_missing, p2m) != p2m_missing)
-			free_p2m_page(p2m);
-		else
-			mid_mfn[mididx] = virt_to_mfn(p2m);
-	}
-
-	return true;
-}
-
-/* Try to install p2m mapping; fail if intermediate bits missing */
-bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
-{
-	unsigned topidx, mididx, idx;
-
-	if (unlikely(pfn >= MAX_P2M_PFN)) {
-		BUG_ON(mfn != INVALID_P2M_ENTRY);
-		return true;
-	}
-
-	topidx = p2m_top_index(pfn);
-	mididx = p2m_mid_index(pfn);
-	idx = p2m_index(pfn);
-
-	if (p2m_top[topidx][mididx] == p2m_missing)
-		return mfn == INVALID_P2M_ENTRY;
-
-	p2m_top[topidx][mididx][idx] = mfn;
-
-	return true;
-}
-
-bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
-{
-	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
-		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
-		return true;
-	}
-
-	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
-		if (!alloc_p2m(pfn))
-			return false;
-
-		if (!__set_phys_to_machine(pfn, mfn))
-			return false;
-	}
-
-	return true;
-}
-
 unsigned long arbitrary_virt_to_mfn(void *vaddr)
 {
 	xmaddr_t maddr = arbitrary_virt_to_machine(vaddr);
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
new file mode 100644
index 0000000..8f2251d
--- /dev/null
+++ b/arch/x86/xen/p2m.c
@@ -0,0 +1,510 @@
+/*
+ * Xen leaves the responsibility for maintaining p2m mappings to the
+ * guests themselves, but it must also access and update the p2m array
+ * during suspend/resume when all the pages are reallocated.
+ *
+ * The p2m table is logically a flat array, but we implement it as a
+ * three-level tree to allow the address space to be sparse.
+ *
+ *                               Xen
+ *                                |
+ *     p2m_top              p2m_top_mfn
+ *       /  \                   /   \
+ * p2m_mid p2m_mid	p2m_mid_mfn p2m_mid_mfn
+ *    / \      / \         /           /
+ *  p2m p2m p2m p2m p2m p2m p2m ...
+ *
+ * The p2m_mid_mfn pages are mapped by p2m_top_mfn_p.
+ *
+ * The p2m_top and p2m_top_mfn levels are limited to 1 page, so the
+ * maximum representable pseudo-physical address space is:
+ *  P2M_TOP_PER_PAGE * P2M_MID_PER_PAGE * P2M_PER_PAGE pages
+ *
+ * P2M_PER_PAGE depends on the architecture, as a mfn is always
+ * unsigned long (8 bytes on 64-bit, 4 bytes on 32), leading to
+ * 512 and 1024 entries respectively. 
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/hash.h>
+#include <linux/sched.h>
+
+#include <asm/cache.h>
+#include <asm/setup.h>
+
+#include <asm/xen/page.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
+
+#include "xen-ops.h"
+
+static void __init m2p_override_init(void);
+
+unsigned long xen_max_p2m_pfn __read_mostly;
+
+#define P2M_PER_PAGE		(PAGE_SIZE / sizeof(unsigned long))
+#define P2M_MID_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long *))
+#define P2M_TOP_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long **))
+
+#define MAX_P2M_PFN		(P2M_TOP_PER_PAGE * P2M_MID_PER_PAGE * P2M_PER_PAGE)
+
+/* Placeholders for holes in the address space */
+static RESERVE_BRK_ARRAY(unsigned long, p2m_missing, P2M_PER_PAGE);
+static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_missing, P2M_MID_PER_PAGE);
+static RESERVE_BRK_ARRAY(unsigned long, p2m_mid_missing_mfn, P2M_MID_PER_PAGE);
+
+static RESERVE_BRK_ARRAY(unsigned long **, p2m_top, P2M_TOP_PER_PAGE);
+static RESERVE_BRK_ARRAY(unsigned long, p2m_top_mfn, P2M_TOP_PER_PAGE);
+static RESERVE_BRK_ARRAY(unsigned long *, p2m_top_mfn_p, P2M_TOP_PER_PAGE);
+
+RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
+RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
+
+static inline unsigned p2m_top_index(unsigned long pfn)
+{
+	BUG_ON(pfn >= MAX_P2M_PFN);
+	return pfn / (P2M_MID_PER_PAGE * P2M_PER_PAGE);
+}
+
+static inline unsigned p2m_mid_index(unsigned long pfn)
+{
+	return (pfn / P2M_PER_PAGE) % P2M_MID_PER_PAGE;
+}
+
+static inline unsigned p2m_index(unsigned long pfn)
+{
+	return pfn % P2M_PER_PAGE;
+}
+
+static void p2m_top_init(unsigned long ***top)
+{
+	unsigned i;
+
+	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
+		top[i] = p2m_mid_missing;
+}
+
+static void p2m_top_mfn_init(unsigned long *top)
+{
+	unsigned i;
+
+	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
+		top[i] = virt_to_mfn(p2m_mid_missing_mfn);
+}
+
+static void p2m_top_mfn_p_init(unsigned long **top)
+{
+	unsigned i;
+
+	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
+		top[i] = p2m_mid_missing_mfn;
+}
+
+static void p2m_mid_init(unsigned long **mid)
+{
+	unsigned i;
+
+	for (i = 0; i < P2M_MID_PER_PAGE; i++)
+		mid[i] = p2m_missing;
+}
+
+static void p2m_mid_mfn_init(unsigned long *mid)
+{
+	unsigned i;
+
+	for (i = 0; i < P2M_MID_PER_PAGE; i++)
+		mid[i] = virt_to_mfn(p2m_missing);
+}
+
+static void p2m_init(unsigned long *p2m)
+{
+	unsigned i;
+
+	for (i = 0; i < P2M_MID_PER_PAGE; i++)
+		p2m[i] = INVALID_P2M_ENTRY;
+}
+
+/*
+ * Build the parallel p2m_top_mfn and p2m_mid_mfn structures
+ *
+ * This is called both at boot time, and after resuming from suspend:
+ * - At boot time we're called very early, and must use extend_brk()
+ *   to allocate memory.
+ *
+ * - After resume we're called from within stop_machine, but the mfn
+ *   tree should alreay be completely allocated.
+ */
+void xen_build_mfn_list_list(void)
+{
+	unsigned long pfn;
+
+	/* Pre-initialize p2m_top_mfn to be completely missing */
+	if (p2m_top_mfn == NULL) {
+		p2m_mid_missing_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		p2m_mid_mfn_init(p2m_mid_missing_mfn);
+
+		p2m_top_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		p2m_top_mfn_p_init(p2m_top_mfn_p);
+
+		p2m_top_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		p2m_top_mfn_init(p2m_top_mfn);
+	} else {
+		/* Reinitialise, mfn's all change after migration */
+		p2m_mid_mfn_init(p2m_mid_missing_mfn);
+	}
+
+	for (pfn = 0; pfn < xen_max_p2m_pfn; pfn += P2M_PER_PAGE) {
+		unsigned topidx = p2m_top_index(pfn);
+		unsigned mididx = p2m_mid_index(pfn);
+		unsigned long **mid;
+		unsigned long *mid_mfn_p;
+
+		mid = p2m_top[topidx];
+		mid_mfn_p = p2m_top_mfn_p[topidx];
+
+		/* Don't bother allocating any mfn mid levels if
+		 * they're just missing, just update the stored mfn,
+		 * since all could have changed over a migrate.
+		 */
+		if (mid == p2m_mid_missing) {
+			BUG_ON(mididx);
+			BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
+			p2m_top_mfn[topidx] = virt_to_mfn(p2m_mid_missing_mfn);
+			pfn += (P2M_MID_PER_PAGE - 1) * P2M_PER_PAGE;
+			continue;
+		}
+
+		if (mid_mfn_p == p2m_mid_missing_mfn) {
+			/*
+			 * XXX boot-time only!  We should never find
+			 * missing parts of the mfn tree after
+			 * runtime.  extend_brk() will BUG if we call
+			 * it too late.
+			 */
+			mid_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
+			p2m_mid_mfn_init(mid_mfn_p);
+
+			p2m_top_mfn_p[topidx] = mid_mfn_p;
+		}
+
+		p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
+		mid_mfn_p[mididx] = virt_to_mfn(mid[mididx]);
+	}
+}
+
+void xen_setup_mfn_list_list(void)
+{
+	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
+
+	HYPERVISOR_shared_info->arch.pfn_to_mfn_frame_list_list =
+		virt_to_mfn(p2m_top_mfn);
+	HYPERVISOR_shared_info->arch.max_pfn = xen_max_p2m_pfn;
+}
+
+/* Set up p2m_top to point to the domain-builder provided p2m pages */
+void __init xen_build_dynamic_phys_to_machine(void)
+{
+	unsigned long *mfn_list = (unsigned long *)xen_start_info->mfn_list;
+	unsigned long max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
+	unsigned long pfn;
+
+	xen_max_p2m_pfn = max_pfn;
+
+	p2m_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_init(p2m_missing);
+
+	p2m_mid_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_mid_init(p2m_mid_missing);
+
+	p2m_top = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_top_init(p2m_top);
+
+	/*
+	 * The domain builder gives us a pre-constructed p2m array in
+	 * mfn_list for all the pages initially given to us, so we just
+	 * need to graft that into our tree structure.
+	 */
+	for (pfn = 0; pfn < max_pfn; pfn += P2M_PER_PAGE) {
+		unsigned topidx = p2m_top_index(pfn);
+		unsigned mididx = p2m_mid_index(pfn);
+
+		if (p2m_top[topidx] == p2m_mid_missing) {
+			unsigned long **mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
+			p2m_mid_init(mid);
+
+			p2m_top[topidx] = mid;
+		}
+
+		p2m_top[topidx][mididx] = &mfn_list[pfn];
+	}
+
+	m2p_override_init();
+}
+
+unsigned long get_phys_to_machine(unsigned long pfn)
+{
+	unsigned topidx, mididx, idx;
+
+	if (unlikely(pfn >= MAX_P2M_PFN))
+		return INVALID_P2M_ENTRY;
+
+	topidx = p2m_top_index(pfn);
+	mididx = p2m_mid_index(pfn);
+	idx = p2m_index(pfn);
+
+	return p2m_top[topidx][mididx][idx];
+}
+EXPORT_SYMBOL_GPL(get_phys_to_machine);
+
+static void *alloc_p2m_page(void)
+{
+	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
+}
+
+static void free_p2m_page(void *p)
+{
+	free_page((unsigned long)p);
+}
+
+/* 
+ * Fully allocate the p2m structure for a given pfn.  We need to check
+ * that both the top and mid levels are allocated, and make sure the
+ * parallel mfn tree is kept in sync.  We may race with other cpus, so
+ * the new pages are installed with cmpxchg; if we lose the race then
+ * simply free the page we allocated and use the one that's there.
+ */
+static bool alloc_p2m(unsigned long pfn)
+{
+	unsigned topidx, mididx;
+	unsigned long ***top_p, **mid;
+	unsigned long *top_mfn_p, *mid_mfn;
+
+	topidx = p2m_top_index(pfn);
+	mididx = p2m_mid_index(pfn);
+
+	top_p = &p2m_top[topidx];
+	mid = *top_p;
+
+	if (mid == p2m_mid_missing) {
+		/* Mid level is missing, allocate a new one */
+		mid = alloc_p2m_page();
+		if (!mid)
+			return false;
+
+		p2m_mid_init(mid);
+
+		if (cmpxchg(top_p, p2m_mid_missing, mid) != p2m_mid_missing)
+			free_p2m_page(mid);
+	}
+
+	top_mfn_p = &p2m_top_mfn[topidx];
+	mid_mfn = p2m_top_mfn_p[topidx];
+
+	BUG_ON(virt_to_mfn(mid_mfn) != *top_mfn_p);
+
+	if (mid_mfn == p2m_mid_missing_mfn) {
+		/* Separately check the mid mfn level */
+		unsigned long missing_mfn;
+		unsigned long mid_mfn_mfn;
+
+		mid_mfn = alloc_p2m_page();
+		if (!mid_mfn)
+			return false;
+
+		p2m_mid_mfn_init(mid_mfn);
+
+		missing_mfn = virt_to_mfn(p2m_mid_missing_mfn);
+		mid_mfn_mfn = virt_to_mfn(mid_mfn);
+		if (cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn) != missing_mfn)
+			free_p2m_page(mid_mfn);
+		else
+			p2m_top_mfn_p[topidx] = mid_mfn;
+	}
+
+	if (p2m_top[topidx][mididx] == p2m_missing) {
+		/* p2m leaf page is missing */
+		unsigned long *p2m;
+
+		p2m = alloc_p2m_page();
+		if (!p2m)
+			return false;
+
+		p2m_init(p2m);
+
+		if (cmpxchg(&mid[mididx], p2m_missing, p2m) != p2m_missing)
+			free_p2m_page(p2m);
+		else
+			mid_mfn[mididx] = virt_to_mfn(p2m);
+	}
+
+	return true;
+}
+
+/* Try to install p2m mapping; fail if intermediate bits missing */
+bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	unsigned topidx, mididx, idx;
+
+	if (unlikely(pfn >= MAX_P2M_PFN)) {
+		BUG_ON(mfn != INVALID_P2M_ENTRY);
+		return true;
+	}
+
+	topidx = p2m_top_index(pfn);
+	mididx = p2m_mid_index(pfn);
+	idx = p2m_index(pfn);
+
+	if (p2m_top[topidx][mididx] == p2m_missing)
+		return mfn == INVALID_P2M_ENTRY;
+
+	p2m_top[topidx][mididx][idx] = mfn;
+
+	return true;
+}
+
+bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return true;
+	}
+
+	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
+		if (!alloc_p2m(pfn))
+			return false;
+
+		if (!__set_phys_to_machine(pfn, mfn))
+			return false;
+	}
+
+	return true;
+}
+
+#define M2P_OVERRIDE_HASH_SHIFT	10
+#define M2P_OVERRIDE_HASH	(1 << M2P_OVERRIDE_HASH_SHIFT)
+
+static RESERVE_BRK_ARRAY(struct list_head, m2p_overrides, M2P_OVERRIDE_HASH);
+static DEFINE_SPINLOCK(m2p_override_lock);
+
+static void __init m2p_override_init(void)
+{
+	unsigned i;
+
+	m2p_overrides = extend_brk(sizeof(*m2p_overrides) * M2P_OVERRIDE_HASH,
+				   sizeof(unsigned long));
+
+	for (i = 0; i < M2P_OVERRIDE_HASH; i++)
+		INIT_LIST_HEAD(&m2p_overrides[i]);
+}
+
+static unsigned long mfn_hash(unsigned long mfn)
+{
+	return hash_long(mfn, M2P_OVERRIDE_HASH_SHIFT);
+}
+
+/* Add an MFN override for a particular page */
+int m2p_add_override(unsigned long mfn, struct page *page)
+{
+	unsigned long flags;
+	unsigned long pfn;
+	unsigned long address;
+	unsigned level;
+	pte_t *ptep = NULL;
+
+	pfn = page_to_pfn(page);
+	if (!PageHighMem(page)) {
+		address = (unsigned long)__va(pfn << PAGE_SHIFT);
+		ptep = lookup_address(address, &level);
+
+		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
+					"m2p_add_override: pfn %lx not mapped", pfn))
+			return -EINVAL;
+	}
+
+	page->private = mfn;
+	page->index = pfn_to_mfn(pfn);
+
+	__set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
+	if (!PageHighMem(page))
+		/* Just zap old mapping for now */
+		pte_clear(&init_mm, address, ptep);
+
+	spin_lock_irqsave(&m2p_override_lock, flags);
+	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
+	spin_unlock_irqrestore(&m2p_override_lock, flags);
+
+	return 0;
+}
+
+int m2p_remove_override(struct page *page)
+{
+	unsigned long flags;
+	unsigned long mfn;
+	unsigned long pfn;
+	unsigned long address;
+	unsigned level;
+	pte_t *ptep = NULL;
+
+	pfn = page_to_pfn(page);
+	mfn = get_phys_to_machine(pfn);
+	if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT))
+		return -EINVAL;
+
+	if (!PageHighMem(page)) {
+		address = (unsigned long)__va(pfn << PAGE_SHIFT);
+		ptep = lookup_address(address, &level);
+
+		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
+					"m2p_remove_override: pfn %lx not mapped", pfn))
+			return -EINVAL;
+	}
+
+	spin_lock_irqsave(&m2p_override_lock, flags);
+	list_del(&page->lru);
+	spin_unlock_irqrestore(&m2p_override_lock, flags);
+	__set_phys_to_machine(pfn, page->index);
+
+	if (!PageHighMem(page))
+		set_pte_at(&init_mm, address, ptep,
+				pfn_pte(pfn, PAGE_KERNEL));
+		/* No tlb flush necessary because the caller already
+		 * left the pte unmapped. */
+
+	return 0;
+}
+
+struct page *m2p_find_override(unsigned long mfn)
+{
+	unsigned long flags;
+	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
+	struct page *p, *ret;
+
+	ret = NULL;
+
+	spin_lock_irqsave(&m2p_override_lock, flags);
+
+	list_for_each_entry(p, bucket, lru) {
+		if (p->private == mfn) {
+			ret = p;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&m2p_override_lock, flags);
+
+	return ret;
+}
+
+unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn)
+{
+	struct page *p = m2p_find_override(mfn);
+	unsigned long ret = pfn;
+
+	if (p)
+		ret = page_to_pfn(p);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(m2p_find_override_pfn);
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 6e6180c..bd3095f 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -62,6 +62,13 @@ config XEN_SYS_HYPERVISOR
 	 virtual environment, /sys/hypervisor will still be present,
 	 but will have no xen contents.
 
+config XEN_GNTDEV
+	tristate "userspace grant access device driver"
+	depends on XEN
+	select MMU_NOTIFIER
+	help
+	  Allows userspace processes to use grants.
+
 config XEN_PLATFORM_PCI
 	tristate "xen platform pci device driver"
 	depends on XEN_PVHVM
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 533a199..674fdb5 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
 obj-$(CONFIG_XEN_DEV_EVTCHN)	+= xen-evtchn.o
+obj-$(CONFIG_XEN_GNTDEV)	+= xen-gntdev.o
 obj-$(CONFIG_XENFS)		+= xenfs/
 obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
 obj-$(CONFIG_XEN_PLATFORM_PCI)	+= platform-pci.o
@@ -16,4 +17,5 @@ obj-$(CONFIG_SWIOTLB_XEN)	+= swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)		+= pci.o
 
 xen-evtchn-y			:= evtchn.o
+xen-gntdev-y				:= gntdev.o
 
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
new file mode 100644
index 0000000..1e31cdc
--- /dev/null
+++ b/drivers/xen/gntdev.c
@@ -0,0 +1,665 @@
+/******************************************************************************
+ * gntdev.c
+ *
+ * Device for accessing (in user-space) pages that have been granted by other
+ * domains.
+ *
+ * Copyright (c) 2006-2007, D G Murray.
+ *           (c) 2009 Gerd Hoffmann <kraxel@redhat.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#undef DEBUG
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/mmu_notifier.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+
+#include <xen/xen.h>
+#include <xen/grant_table.h>
+#include <xen/gntdev.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/page.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Derek G. Murray <Derek.Murray@cl.cam.ac.uk>, "
+	      "Gerd Hoffmann <kraxel@redhat.com>");
+MODULE_DESCRIPTION("User-space granted page access driver");
+
+static int limit = 1024;
+module_param(limit, int, 0644);
+MODULE_PARM_DESC(limit, "Maximum number of grants that may be mapped at "
+		"once by a gntdev instance");
+
+struct gntdev_priv {
+	struct list_head maps;
+	uint32_t used;
+	uint32_t limit;
+	/* lock protects maps from concurrent changes */
+	spinlock_t lock;
+	struct mm_struct *mm;
+	struct mmu_notifier mn;
+};
+
+struct grant_map {
+	struct list_head next;
+	struct gntdev_priv *priv;
+	struct vm_area_struct *vma;
+	int index;
+	int count;
+	int flags;
+	int is_mapped;
+	struct ioctl_gntdev_grant_ref *grants;
+	struct gnttab_map_grant_ref   *map_ops;
+	struct gnttab_unmap_grant_ref *unmap_ops;
+	struct page **pages;
+};
+
+/* ------------------------------------------------------------------ */
+
+static void gntdev_print_maps(struct gntdev_priv *priv,
+			      char *text, int text_index)
+{
+#ifdef DEBUG
+	struct grant_map *map;
+
+	pr_debug("maps list (priv %p, usage %d/%d)\n",
+	       priv, priv->used, priv->limit);
+
+	list_for_each_entry(map, &priv->maps, next)
+		pr_debug("  index %2d, count %2d %s\n",
+		       map->index, map->count,
+		       map->index == text_index && text ? text : "");
+#endif
+}
+
+static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
+{
+	struct grant_map *add;
+	int i;
+
+	add = kzalloc(sizeof(struct grant_map), GFP_KERNEL);
+	if (NULL == add)
+		return NULL;
+
+	add->grants    = kzalloc(sizeof(add->grants[0])    * count, GFP_KERNEL);
+	add->map_ops   = kzalloc(sizeof(add->map_ops[0])   * count, GFP_KERNEL);
+	add->unmap_ops = kzalloc(sizeof(add->unmap_ops[0]) * count, GFP_KERNEL);
+	add->pages     = kzalloc(sizeof(add->pages[0])     * count, GFP_KERNEL);
+	if (NULL == add->grants    ||
+	    NULL == add->map_ops   ||
+	    NULL == add->unmap_ops ||
+	    NULL == add->pages)
+		goto err;
+
+	for (i = 0; i < count; i++) {
+		add->pages[i] = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+		if (add->pages[i] == NULL)
+			goto err;
+	}
+
+	add->index = 0;
+	add->count = count;
+	add->priv  = priv;
+
+	if (add->count + priv->used > priv->limit)
+		goto err;
+
+	return add;
+
+err:
+	if (add->pages)
+		for (i = 0; i < count; i++) {
+			if (add->pages[i])
+				__free_page(add->pages[i]);
+		}
+	kfree(add->pages);
+	kfree(add->grants);
+	kfree(add->map_ops);
+	kfree(add->unmap_ops);
+	kfree(add);
+	return NULL;
+}
+
+static void gntdev_add_map(struct gntdev_priv *priv, struct grant_map *add)
+{
+	struct grant_map *map;
+
+	list_for_each_entry(map, &priv->maps, next) {
+		if (add->index + add->count < map->index) {
+			list_add_tail(&add->next, &map->next);
+			goto done;
+		}
+		add->index = map->index + map->count;
+	}
+	list_add_tail(&add->next, &priv->maps);
+
+done:
+	priv->used += add->count;
+	gntdev_print_maps(priv, "[new]", add->index);
+}
+
+static struct grant_map *gntdev_find_map_index(struct gntdev_priv *priv,
+		int index, int count)
+{
+	struct grant_map *map;
+
+	list_for_each_entry(map, &priv->maps, next) {
+		if (map->index != index)
+			continue;
+		if (map->count != count)
+			continue;
+		return map;
+	}
+	return NULL;
+}
+
+static struct grant_map *gntdev_find_map_vaddr(struct gntdev_priv *priv,
+					       unsigned long vaddr)
+{
+	struct grant_map *map;
+
+	list_for_each_entry(map, &priv->maps, next) {
+		if (!map->vma)
+			continue;
+		if (vaddr < map->vma->vm_start)
+			continue;
+		if (vaddr >= map->vma->vm_end)
+			continue;
+		return map;
+	}
+	return NULL;
+}
+
+static int gntdev_del_map(struct grant_map *map)
+{
+	int i;
+
+	if (map->vma)
+		return -EBUSY;
+	for (i = 0; i < map->count; i++)
+		if (map->unmap_ops[i].handle)
+			return -EBUSY;
+
+	map->priv->used -= map->count;
+	list_del(&map->next);
+	return 0;
+}
+
+static void gntdev_free_map(struct grant_map *map)
+{
+	int i;
+
+	if (!map)
+		return;
+
+	if (map->pages)
+		for (i = 0; i < map->count; i++) {
+			if (map->pages[i])
+				__free_page(map->pages[i]);
+		}
+	kfree(map->pages);
+	kfree(map->grants);
+	kfree(map->map_ops);
+	kfree(map->unmap_ops);
+	kfree(map);
+}
+
+/* ------------------------------------------------------------------ */
+
+static int find_grant_ptes(pte_t *pte, pgtable_t token,
+		unsigned long addr, void *data)
+{
+	struct grant_map *map = data;
+	unsigned int pgnr = (addr - map->vma->vm_start) >> PAGE_SHIFT;
+	u64 pte_maddr;
+
+	BUG_ON(pgnr >= map->count);
+	pte_maddr = arbitrary_virt_to_machine(pte).maddr;
+
+	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr,
+			  GNTMAP_contains_pte | map->flags,
+			  map->grants[pgnr].ref,
+			  map->grants[pgnr].domid);
+	gnttab_set_unmap_op(&map->unmap_ops[pgnr], pte_maddr,
+			    GNTMAP_contains_pte | map->flags,
+			    0 /* handle */);
+	return 0;
+}
+
+static int map_grant_pages(struct grant_map *map)
+{
+	int i, err = 0;
+
+	pr_debug("map %d+%d\n", map->index, map->count);
+	err = gnttab_map_refs(map->map_ops, map->pages, map->count);
+	if (err)
+		return err;
+
+	for (i = 0; i < map->count; i++) {
+		if (map->map_ops[i].status)
+			err = -EINVAL;
+		map->unmap_ops[i].handle = map->map_ops[i].handle;
+	}
+	return err;
+}
+
+static int unmap_grant_pages(struct grant_map *map, int offset, int pages)
+{
+	int i, err = 0;
+
+	pr_debug("map %d+%d [%d+%d]\n", map->index, map->count, offset, pages);
+	err = gnttab_unmap_refs(map->unmap_ops + offset, map->pages, pages);
+	if (err)
+		return err;
+
+	for (i = 0; i < pages; i++) {
+		if (map->unmap_ops[offset+i].status)
+			err = -EINVAL;
+		map->unmap_ops[offset+i].handle = 0;
+	}
+	return err;
+}
+
+/* ------------------------------------------------------------------ */
+
+static void gntdev_vma_close(struct vm_area_struct *vma)
+{
+	struct grant_map *map = vma->vm_private_data;
+
+	pr_debug("close %p\n", vma);
+	map->is_mapped = 0;
+	map->vma = NULL;
+	vma->vm_private_data = NULL;
+}
+
+static int gntdev_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	pr_debug("vaddr %p, pgoff %ld (shouldn't happen)\n",
+			vmf->virtual_address, vmf->pgoff);
+	vmf->flags = VM_FAULT_ERROR;
+	return 0;
+}
+
+static struct vm_operations_struct gntdev_vmops = {
+	.close = gntdev_vma_close,
+	.fault = gntdev_vma_fault,
+};
+
+/* ------------------------------------------------------------------ */
+
+static void mn_invl_range_start(struct mmu_notifier *mn,
+				struct mm_struct *mm,
+				unsigned long start, unsigned long end)
+{
+	struct gntdev_priv *priv = container_of(mn, struct gntdev_priv, mn);
+	struct grant_map *map;
+	unsigned long mstart, mend;
+	int err;
+
+	spin_lock(&priv->lock);
+	list_for_each_entry(map, &priv->maps, next) {
+		if (!map->vma)
+			continue;
+		if (!map->is_mapped)
+			continue;
+		if (map->vma->vm_start >= end)
+			continue;
+		if (map->vma->vm_end <= start)
+			continue;
+		mstart = max(start, map->vma->vm_start);
+		mend   = min(end,   map->vma->vm_end);
+		pr_debug("map %d+%d (%lx %lx), range %lx %lx, mrange %lx %lx\n",
+				map->index, map->count,
+				map->vma->vm_start, map->vma->vm_end,
+				start, end, mstart, mend);
+		err = unmap_grant_pages(map,
+					(mstart - map->vma->vm_start) >> PAGE_SHIFT,
+					(mend - mstart) >> PAGE_SHIFT);
+		WARN_ON(err);
+	}
+	spin_unlock(&priv->lock);
+}
+
+static void mn_invl_page(struct mmu_notifier *mn,
+			 struct mm_struct *mm,
+			 unsigned long address)
+{
+	mn_invl_range_start(mn, mm, address, address + PAGE_SIZE);
+}
+
+static void mn_release(struct mmu_notifier *mn,
+		       struct mm_struct *mm)
+{
+	struct gntdev_priv *priv = container_of(mn, struct gntdev_priv, mn);
+	struct grant_map *map;
+	int err;
+
+	spin_lock(&priv->lock);
+	list_for_each_entry(map, &priv->maps, next) {
+		if (!map->vma)
+			continue;
+		pr_debug("map %d+%d (%lx %lx)\n",
+				map->index, map->count,
+				map->vma->vm_start, map->vma->vm_end);
+		err = unmap_grant_pages(map, /* offset */ 0, map->count);
+		WARN_ON(err);
+	}
+	spin_unlock(&priv->lock);
+}
+
+struct mmu_notifier_ops gntdev_mmu_ops = {
+	.release                = mn_release,
+	.invalidate_page        = mn_invl_page,
+	.invalidate_range_start = mn_invl_range_start,
+};
+
+/* ------------------------------------------------------------------ */
+
+static int gntdev_open(struct inode *inode, struct file *flip)
+{
+	struct gntdev_priv *priv;
+	int ret = 0;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&priv->maps);
+	spin_lock_init(&priv->lock);
+	priv->limit = limit;
+
+	priv->mm = get_task_mm(current);
+	if (!priv->mm) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+	priv->mn.ops = &gntdev_mmu_ops;
+	ret = mmu_notifier_register(&priv->mn, priv->mm);
+	mmput(priv->mm);
+
+	if (ret) {
+		kfree(priv);
+		return ret;
+	}
+
+	flip->private_data = priv;
+	pr_debug("priv %p\n", priv);
+
+	return 0;
+}
+
+static int gntdev_release(struct inode *inode, struct file *flip)
+{
+	struct gntdev_priv *priv = flip->private_data;
+	struct grant_map *map;
+	int err;
+
+	pr_debug("priv %p\n", priv);
+
+	spin_lock(&priv->lock);
+	while (!list_empty(&priv->maps)) {
+		map = list_entry(priv->maps.next, struct grant_map, next);
+		err = gntdev_del_map(map);
+		if (WARN_ON(err))
+			gntdev_free_map(map);
+
+	}
+	spin_unlock(&priv->lock);
+
+	mmu_notifier_unregister(&priv->mn, priv->mm);
+	kfree(priv);
+	return 0;
+}
+
+static long gntdev_ioctl_map_grant_ref(struct gntdev_priv *priv,
+				       struct ioctl_gntdev_map_grant_ref __user *u)
+{
+	struct ioctl_gntdev_map_grant_ref op;
+	struct grant_map *map;
+	int err;
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
+	pr_debug("priv %p, add %d\n", priv, op.count);
+	if (unlikely(op.count <= 0))
+		return -EINVAL;
+	if (unlikely(op.count > priv->limit))
+		return -EINVAL;
+
+	err = -ENOMEM;
+	map = gntdev_alloc_map(priv, op.count);
+	if (!map)
+		return err;
+	if (copy_from_user(map->grants, &u->refs,
+			   sizeof(map->grants[0]) * op.count) != 0) {
+		gntdev_free_map(map);
+		return err;
+	}
+
+	spin_lock(&priv->lock);
+	gntdev_add_map(priv, map);
+	op.index = map->index << PAGE_SHIFT;
+	spin_unlock(&priv->lock);
+
+	if (copy_to_user(u, &op, sizeof(op)) != 0) {
+		spin_lock(&priv->lock);
+		gntdev_del_map(map);
+		spin_unlock(&priv->lock);
+		gntdev_free_map(map);
+		return err;
+	}
+	return 0;
+}
+
+static long gntdev_ioctl_unmap_grant_ref(struct gntdev_priv *priv,
+					 struct ioctl_gntdev_unmap_grant_ref __user *u)
+{
+	struct ioctl_gntdev_unmap_grant_ref op;
+	struct grant_map *map;
+	int err = -ENOENT;
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
+	pr_debug("priv %p, del %d+%d\n", priv, (int)op.index, (int)op.count);
+
+	spin_lock(&priv->lock);
+	map = gntdev_find_map_index(priv, op.index >> PAGE_SHIFT, op.count);
+	if (map)
+		err = gntdev_del_map(map);
+	spin_unlock(&priv->lock);
+	if (!err)
+		gntdev_free_map(map);
+	return err;
+}
+
+static long gntdev_ioctl_get_offset_for_vaddr(struct gntdev_priv *priv,
+					      struct ioctl_gntdev_get_offset_for_vaddr __user *u)
+{
+	struct ioctl_gntdev_get_offset_for_vaddr op;
+	struct grant_map *map;
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
+	pr_debug("priv %p, offset for vaddr %lx\n", priv, (unsigned long)op.vaddr);
+
+	spin_lock(&priv->lock);
+	map = gntdev_find_map_vaddr(priv, op.vaddr);
+	if (map == NULL ||
+	    map->vma->vm_start != op.vaddr) {
+		spin_unlock(&priv->lock);
+		return -EINVAL;
+	}
+	op.offset = map->index << PAGE_SHIFT;
+	op.count = map->count;
+	spin_unlock(&priv->lock);
+
+	if (copy_to_user(u, &op, sizeof(op)) != 0)
+		return -EFAULT;
+	return 0;
+}
+
+static long gntdev_ioctl_set_max_grants(struct gntdev_priv *priv,
+					struct ioctl_gntdev_set_max_grants __user *u)
+{
+	struct ioctl_gntdev_set_max_grants op;
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
+	pr_debug("priv %p, limit %d\n", priv, op.count);
+	if (op.count > limit)
+		return -E2BIG;
+
+	spin_lock(&priv->lock);
+	priv->limit = op.count;
+	spin_unlock(&priv->lock);
+	return 0;
+}
+
+static long gntdev_ioctl(struct file *flip,
+			 unsigned int cmd, unsigned long arg)
+{
+	struct gntdev_priv *priv = flip->private_data;
+	void __user *ptr = (void __user *)arg;
+
+	switch (cmd) {
+	case IOCTL_GNTDEV_MAP_GRANT_REF:
+		return gntdev_ioctl_map_grant_ref(priv, ptr);
+
+	case IOCTL_GNTDEV_UNMAP_GRANT_REF:
+		return gntdev_ioctl_unmap_grant_ref(priv, ptr);
+
+	case IOCTL_GNTDEV_GET_OFFSET_FOR_VADDR:
+		return gntdev_ioctl_get_offset_for_vaddr(priv, ptr);
+
+	case IOCTL_GNTDEV_SET_MAX_GRANTS:
+		return gntdev_ioctl_set_max_grants(priv, ptr);
+
+	default:
+		pr_debug("priv %p, unknown cmd %x\n", priv, cmd);
+		return -ENOIOCTLCMD;
+	}
+
+	return 0;
+}
+
+static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
+{
+	struct gntdev_priv *priv = flip->private_data;
+	int index = vma->vm_pgoff;
+	int count = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	struct grant_map *map;
+	int err = -EINVAL;
+
+	if ((vma->vm_flags & VM_WRITE) && !(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	pr_debug("map %d+%d at %lx (pgoff %lx)\n",
+			index, count, vma->vm_start, vma->vm_pgoff);
+
+	spin_lock(&priv->lock);
+	map = gntdev_find_map_index(priv, index, count);
+	if (!map)
+		goto unlock_out;
+	if (map->vma)
+		goto unlock_out;
+	if (priv->mm != vma->vm_mm) {
+		printk(KERN_WARNING "Huh? Other mm?\n");
+		goto unlock_out;
+	}
+
+	vma->vm_ops = &gntdev_vmops;
+
+	vma->vm_flags |= VM_RESERVED|VM_DONTCOPY|VM_DONTEXPAND|VM_PFNMAP;
+
+	vma->vm_private_data = map;
+	map->vma = vma;
+
+	map->flags = GNTMAP_host_map | GNTMAP_application_map;
+	if (!(vma->vm_flags & VM_WRITE))
+		map->flags |= GNTMAP_readonly;
+
+	spin_unlock(&priv->lock);
+
+	err = apply_to_page_range(vma->vm_mm, vma->vm_start,
+				  vma->vm_end - vma->vm_start,
+				  find_grant_ptes, map);
+	if (err) {
+		printk(KERN_WARNING "find_grant_ptes() failure.\n");
+		return err;
+	}
+
+	err = map_grant_pages(map);
+	if (err) {
+		printk(KERN_WARNING "map_grant_pages() failure.\n");
+		return err;
+	}
+
+	map->is_mapped = 1;
+
+	return 0;
+
+unlock_out:
+	spin_unlock(&priv->lock);
+	return err;
+}
+
+static const struct file_operations gntdev_fops = {
+	.owner = THIS_MODULE,
+	.open = gntdev_open,
+	.release = gntdev_release,
+	.mmap = gntdev_mmap,
+	.unlocked_ioctl = gntdev_ioctl
+};
+
+static struct miscdevice gntdev_miscdev = {
+	.minor        = MISC_DYNAMIC_MINOR,
+	.name         = "xen/gntdev",
+	.fops         = &gntdev_fops,
+};
+
+/* ------------------------------------------------------------------ */
+
+static int __init gntdev_init(void)
+{
+	int err;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	err = misc_register(&gntdev_miscdev);
+	if (err != 0) {
+		printk(KERN_ERR "Could not register gntdev device\n");
+		return err;
+	}
+	return 0;
+}
+
+static void __exit gntdev_exit(void)
+{
+	misc_deregister(&gntdev_miscdev);
+}
+
+module_init(gntdev_init);
+module_exit(gntdev_exit);
+
+/* ------------------------------------------------------------------ */
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 6c45318..9ef54eb 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -447,6 +447,52 @@ unsigned int gnttab_max_grant_frames(void)
 }
 EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
 
+int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
+		    struct page **pages, unsigned int count)
+{
+	int i, ret;
+	pte_t *pte;
+	unsigned long mfn;
+
+	ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map_ops, count);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < count; i++) {
+		/* m2p override only supported for GNTMAP_contains_pte mappings */
+		if (!(map_ops[i].flags & GNTMAP_contains_pte))
+			continue;
+		pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
+				(map_ops[i].host_addr & ~PAGE_MASK));
+		mfn = pte_mfn(*pte);
+		ret = m2p_add_override(mfn, pages[i]);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gnttab_map_refs);
+
+int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
+		struct page **pages, unsigned int count)
+{
+	int i, ret;
+
+	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < count; i++) {
+		ret = m2p_remove_override(pages[i]);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
+
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 {
 	struct gnttab_setup_table setup;
diff --git a/include/xen/gntdev.h b/include/xen/gntdev.h
new file mode 100644
index 0000000..eb23f41
--- /dev/null
+++ b/include/xen/gntdev.h
@@ -0,0 +1,119 @@
+/******************************************************************************
+ * gntdev.h
+ * 
+ * Interface to /dev/xen/gntdev.
+ * 
+ * Copyright (c) 2007, D G Murray
+ * 
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ * 
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ * 
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ * 
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef __LINUX_PUBLIC_GNTDEV_H__
+#define __LINUX_PUBLIC_GNTDEV_H__
+
+struct ioctl_gntdev_grant_ref {
+	/* The domain ID of the grant to be mapped. */
+	uint32_t domid;
+	/* The grant reference of the grant to be mapped. */
+	uint32_t ref;
+};
+
+/*
+ * Inserts the grant references into the mapping table of an instance
+ * of gntdev. N.B. This does not perform the mapping, which is deferred
+ * until mmap() is called with @index as the offset.
+ */
+#define IOCTL_GNTDEV_MAP_GRANT_REF \
+_IOC(_IOC_NONE, 'G', 0, sizeof(struct ioctl_gntdev_map_grant_ref))
+struct ioctl_gntdev_map_grant_ref {
+	/* IN parameters */
+	/* The number of grants to be mapped. */
+	uint32_t count;
+	uint32_t pad;
+	/* OUT parameters */
+	/* The offset to be used on a subsequent call to mmap(). */
+	uint64_t index;
+	/* Variable IN parameter. */
+	/* Array of grant references, of size @count. */
+	struct ioctl_gntdev_grant_ref refs[1];
+};
+
+/*
+ * Removes the grant references from the mapping table of an instance of
+ * of gntdev. N.B. munmap() must be called on the relevant virtual address(es)
+ * before this ioctl is called, or an error will result.
+ */
+#define IOCTL_GNTDEV_UNMAP_GRANT_REF \
+_IOC(_IOC_NONE, 'G', 1, sizeof(struct ioctl_gntdev_unmap_grant_ref))
+struct ioctl_gntdev_unmap_grant_ref {
+	/* IN parameters */
+	/* The offset was returned by the corresponding map operation. */
+	uint64_t index;
+	/* The number of pages to be unmapped. */
+	uint32_t count;
+	uint32_t pad;
+};
+
+/*
+ * Returns the offset in the driver's address space that corresponds
+ * to @vaddr. This can be used to perform a munmap(), followed by an
+ * UNMAP_GRANT_REF ioctl, where no state about the offset is retained by
+ * the caller. The number of pages that were allocated at the same time as
+ * @vaddr is returned in @count.
+ *
+ * N.B. Where more than one page has been mapped into a contiguous range, the
+ *      supplied @vaddr must correspond to the start of the range; otherwise
+ *      an error will result. It is only possible to munmap() the entire
+ *      contiguously-allocated range at once, and not any subrange thereof.
+ */
+#define IOCTL_GNTDEV_GET_OFFSET_FOR_VADDR \
+_IOC(_IOC_NONE, 'G', 2, sizeof(struct ioctl_gntdev_get_offset_for_vaddr))
+struct ioctl_gntdev_get_offset_for_vaddr {
+	/* IN parameters */
+	/* The virtual address of the first mapped page in a range. */
+	uint64_t vaddr;
+	/* OUT parameters */
+	/* The offset that was used in the initial mmap() operation. */
+	uint64_t offset;
+	/* The number of pages mapped in the VM area that begins at @vaddr. */
+	uint32_t count;
+	uint32_t pad;
+};
+
+/*
+ * Sets the maximum number of grants that may mapped at once by this gntdev
+ * instance.
+ *
+ * N.B. This must be called before any other ioctl is performed on the device.
+ */
+#define IOCTL_GNTDEV_SET_MAX_GRANTS \
+_IOC(_IOC_NONE, 'G', 3, sizeof(struct ioctl_gntdev_set_max_grants))
+struct ioctl_gntdev_set_max_grants {
+	/* IN parameter */
+	/* The maximum number of grants that may be mapped at once. */
+	uint32_t count;
+};
+
+#endif /* __LINUX_PUBLIC_GNTDEV_H__ */
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 9a73170..b1fab6b 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -37,10 +37,16 @@
 #ifndef __ASM_GNTTAB_H__
 #define __ASM_GNTTAB_H__
 
-#include <asm/xen/hypervisor.h>
+#include <asm/page.h>
+
+#include <xen/interface/xen.h>
 #include <xen/interface/grant_table.h>
+
+#include <asm/xen/hypervisor.h>
 #include <asm/xen/grant_table.h>
 
+#include <xen/features.h>
+
 /* NR_GRANT_FRAMES must be less than or equal to that configured in Xen */
 #define NR_GRANT_FRAMES 4
 
@@ -107,6 +113,37 @@ void gnttab_grant_foreign_access_ref(grant_ref_t ref, domid_t domid,
 void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
 				       unsigned long pfn);
 
+static inline void
+gnttab_set_map_op(struct gnttab_map_grant_ref *map, phys_addr_t addr,
+		  uint32_t flags, grant_ref_t ref, domid_t domid)
+{
+	if (flags & GNTMAP_contains_pte)
+		map->host_addr = addr;
+	else if (xen_feature(XENFEAT_auto_translated_physmap))
+		map->host_addr = __pa(addr);
+	else
+		map->host_addr = addr;
+
+	map->flags = flags;
+	map->ref = ref;
+	map->dom = domid;
+}
+
+static inline void
+gnttab_set_unmap_op(struct gnttab_unmap_grant_ref *unmap, phys_addr_t addr,
+		    uint32_t flags, grant_handle_t handle)
+{
+	if (flags & GNTMAP_contains_pte)
+		unmap->host_addr = addr;
+	else if (xen_feature(XENFEAT_auto_translated_physmap))
+		unmap->host_addr = __pa(addr);
+	else
+		unmap->host_addr = addr;
+
+	unmap->handle = handle;
+	unmap->dev_bus_addr = 0;
+}
+
 int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
 			   struct grant_entry **__shared);
@@ -118,4 +155,9 @@ unsigned int gnttab_max_grant_frames(void);
 
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
+int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
+		    struct page **pages, unsigned int count);
+int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
+		      struct page **pages, unsigned int count);
+
 #endif /* __ASM_GNTTAB_H__ */
