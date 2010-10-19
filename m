Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986Ab0JSLSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:18:02 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49801 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968Ab0JSLSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:18:00 -0400
X-IronPort-AV: E=Sophos;i="4.57,350,1283745600"; 
   d="scan'208";a="118686959"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com, Juan Quintela <quintela@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 07/10] xen: add the direct mapping area for ISA bus access
Date: Tue, 19 Oct 2010 12:17:15 +0100
Message-Id: <1287487038-6643-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
X-OriginalArrivalTime: 19 Oct 2010 11:17:59.0828 (UTC) FILETIME=[49B46540:01CB6F7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juan Quintela <quintela@redhat.com>

add the direct mapping area for ISA bus access when running as initial
domain

Signed-off-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c |    1 +
 arch/x86/xen/mmu.c       |   24 ++++++++++++++++++++++++
 arch/x86/xen/setup.c     |    3 +++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1ccfa1b..9efb004 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1186,6 +1186,7 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
+	xen_ident_map_ISA();
 
 	init_mm.pgd = pgd;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ffc5e24..eed9c7c 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1682,6 +1682,7 @@ static void *m2v(phys_addr_t maddr)
 	return __ka(m2p(maddr));
 }
 
+/* Set the page permissions on an identity-mapped pages */
 static void set_page_prot(void *addr, pgprot_t prot)
 {
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
@@ -1929,6 +1930,29 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #endif
 }
 
+__init void xen_ident_map_ISA(void)
+{
+	unsigned long pa;
+
+	/*
+	 * If we're dom0, then linear map the ISA machine addresses into
+	 * the kernel's address space.
+	 */
+	if (!xen_initial_domain())
+		return;
+
+	xen_raw_printk("Xen: setup ISA identity maps\n");
+
+	for (pa = ISA_START_ADDRESS; pa < ISA_END_ADDRESS; pa += PAGE_SIZE) {
+		pte_t pte = mfn_pte(PFN_DOWN(pa), PAGE_KERNEL_IO);
+
+		if (HYPERVISOR_update_va_mapping(PAGE_OFFSET + pa, pte, 0))
+			BUG();
+	}
+
+	xen_flush_tlb();
+}
+
 static __init void xen_post_allocator_init(void)
 {
 	pv_mmu_ops.set_pte = xen_set_pte;
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index c413132..62ceb78 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -119,6 +119,9 @@ char * __init xen_memory_setup(void)
 	 * Even though this is normal, usable memory under Xen, reserve
 	 * ISA memory anyway because too many things think they can poke
 	 * about in there.
+	 *
+	 * In a dom0 kernel, this region is identity mapped with the
+	 * hardware ISA area, so it really is out of bounds.
 	 */
 	e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
 			E820_RESERVED);
-- 
1.5.6.5

