Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1AJKfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:35:46 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13863 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1AJKf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:26 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293739"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 04/12] xen: move p2m handling to separate file
Date: Mon, 10 Jan 2011 10:36:33 +0000
Message-Id: <1294655801-16230-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:24.0065 (UTC) FILETIME=[16A32910:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile |    3 +-
 arch/x86/xen/mmu.c    |  365 -----------------------------------------------
 arch/x86/xen/p2m.c    |  376 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 378 insertions(+), 366 deletions(-)
 create mode 100644 arch/x86/xen/p2m.c

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
index 0000000..259ec3b
--- /dev/null
+++ b/arch/x86/xen/p2m.c
@@ -0,0 +1,376 @@
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
-- 
1.5.6.5

