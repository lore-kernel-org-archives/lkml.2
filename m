Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2GZUni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:43:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29609 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2GZUnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:43:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] xen/x86: Use memblock_reserve for sensitive areas.
Date: Thu, 26 Jul 2012 16:34:03 -0400
Message-Id: <1343334845-5340-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343334845-5340-1-git-send-email-konrad.wilk@oracle.com>
References: <1343334845-5340-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of a big memblock_reserve. This way we can be more
selective in freeing regions (and it also makes it easier
to understand where is what).

[v1: Move the auto_translate_physmap to proper line]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/p2m.c       |    5 +++++
 arch/x86/xen/setup.c     |    9 ---------
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ff962d4..9b1afa4 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -998,7 +998,44 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 
 	return ret;
 }
+static void __init xen_reserve_mfn(unsigned long mfn)
+{
+	unsigned long pfn;
+
+	if (!mfn)
+		return;
+	pfn = mfn_to_pfn(mfn);
+	if (phys_to_machine_mapping_valid(pfn))
+		memblock_reserve(PFN_PHYS(pfn), PAGE_SIZE);
+}
+static void __init xen_reserve_internals(void)
+{
+	unsigned long size;
+
+	if (!xen_pv_domain())
+		return;
+
+	memblock_reserve(__pa(xen_start_info), PAGE_SIZE);
+
+	xen_reserve_mfn(PFN_DOWN(xen_start_info->shared_info));
+	xen_reserve_mfn(xen_start_info->store_mfn);
 
+	if (!xen_initial_domain())
+		xen_reserve_mfn(xen_start_info->console.domU.mfn);
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
+	/*
+	 * ALIGN up to compensate for the p2m_page pointing to an array that
+	 * can partially filled (look in xen_build_dynamic_phys_to_machine).
+	 */
+
+	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
+	memblock_reserve(__pa(xen_start_info->mfn_list), size);
+
+	/* The pagetables are reserved in mmu.c */
+}
 void xen_setup_shared_info(void)
 {
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
@@ -1362,6 +1399,7 @@ asmlinkage void __init xen_start_kernel(void)
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
 
+	xen_reserve_internals();
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
 
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index e4adbfb..6a2bfa4 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -388,6 +388,11 @@ void __init xen_build_dynamic_phys_to_machine(void)
 	}
 
 	m2p_override_init();
+
+	/* NOTE: We cannot call memblock_reserve here for the mfn_list as there
+	 * isn't enough pieces to make it work (for one - we are still using the
+	 * Xen provided pagetable). Do it later in xen_reserve_internals.
+	 */
 }
 
 unsigned long get_phys_to_machine(unsigned long pfn)
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index a4790bf..9efca75 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -424,15 +424,6 @@ char * __init xen_memory_setup(void)
 	e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
 			E820_RESERVED);
 
-	/*
-	 * Reserve Xen bits:
-	 *  - mfn_list
-	 *  - xen_start_info
-	 * See comment above "struct start_info" in <xen/interface/xen.h>
-	 */
-	memblock_reserve(__pa(xen_start_info->mfn_list),
-			 xen_start_info->pt_base - xen_start_info->mfn_list);
-
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
 	return "Xen";
-- 
1.7.7.6

