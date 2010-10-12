Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab0JLQoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:44:25 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32802 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab0JLQnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:43:02 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283745600"; 
   d="scan'208";a="117745983"
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 04/10] xen: map a dummy page for local apic and ioapic in xen_set_fixmap
Date: Tue, 12 Oct 2010 17:42:44 +0100
Message-Id: <1286901770-8612-4-git-send-email-Stefano.Stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop>
References: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop>
X-OriginalArrivalTime: 12 Oct 2010 16:43:01.0817 (UTC) FILETIME=[88E78290:01CB6A2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/mmu.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 42086ac..ffc5e24 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1861,6 +1861,8 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 }
 #endif	/* CONFIG_X86_64 */
 
+static unsigned char dummy_mapping[PAGE_SIZE] __page_aligned_bss;
+
 static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 {
 	pte_t pte;
@@ -1881,15 +1883,28 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #else
 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
 #endif
-#ifdef CONFIG_X86_LOCAL_APIC
-	case FIX_APIC_BASE:	/* maps dummy local APIC */
-#endif
 	case FIX_TEXT_POKE0:
 	case FIX_TEXT_POKE1:
 		/* All local page mappings */
 		pte = pfn_pte(phys, prot);
 		break;
 
+#ifdef CONFIG_X86_LOCAL_APIC
+	case FIX_APIC_BASE:	/* maps dummy local APIC */
+		pte = pfn_pte(PFN_DOWN(__pa(dummy_mapping)), PAGE_KERNEL);
+		break;
+#endif
+
+#ifdef CONFIG_X86_IO_APIC
+	case FIX_IO_APIC_BASE_0 ... FIX_IO_APIC_BASE_END:
+		/*
+		 * We just don't map the IO APIC - all access is via
+		 * hypercalls.  Keep the address in the pte for reference.
+		 */
+		pte = pfn_pte(PFN_DOWN(__pa(dummy_mapping)), PAGE_KERNEL);
+		break;
+#endif
+
 	case FIX_PARAVIRT_BOOTMAP:
 		/* This is an MFN, but it isn't an IO mapping from the
 		   IO domain */
@@ -2027,6 +2042,8 @@ void __init xen_init_mmu_ops(void)
 	pv_mmu_ops = xen_mmu_ops;
 
 	vmap_lazy_unmap = false;
+
+	memset(dummy_mapping, 0xff, PAGE_SIZE);
 }
 
 /* Protected by xen_reservation_lock. */
-- 
1.5.6.5

