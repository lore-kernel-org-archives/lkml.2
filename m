Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1IFQL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:11:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:11060 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab1IFQLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:11:16 -0400
X-IronPort-AV: E=Sophos;i="4.68,339,1312171200"; 
   d="scan'208";a="16726481"
From: <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
CC: konrad.wilk@oracle.com, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@eu.citrix.com,
        Jeremy.Fitzhardinge@citrix.com
Subject: [PATCH v2 2/2] xen: use multicalls for m2p override grant table ops
Date: Tue, 6 Sep 2011 17:19:29 +0100
Message-ID: <1315325969-32346-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315325969-32346-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1315325969-32346-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Replace the HYPERVISOR_grant_table_op hypercalls with multicalls.

Use the kmap_op pointer directly as argument to do the mapping as it is
guaranteed to be present up until the unmapping is done.
The mapping can be done either by m2p_add_override, in case of
!PageHighMem, or in __xen_set_pte otherwise.

Before issuing any unmapping multicalls, we need to make sure that the
mapping has already being done, because we need the kmap->handle to be
set correctly.
Also we need to do the unmapping before the page is removed from the m2p
override, so we force the unmapping in m2p_remove_override even if
PageHighMem. The value of map_op->host_addr can be used to know if the
unmapping has already happened.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/mmu.c |   49 +++++++++++++++++++++++++++++-------------
 arch/x86/xen/p2m.c |   60 ++++++++++++++++++++++++++++++++-------------------
 2 files changed, 72 insertions(+), 37 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e80dad5..b142315 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -317,18 +317,36 @@ static int xen_unmap_granted_page(pte_t *ptep)
 	mfn = (ptep->pte & PTE_PFN_MASK) >> PAGE_SHIFT;
 	page = m2p_find_override(mfn);
 	if (page != NULL && (page->private & GRANT_FRAME_BIT)) {
-		int ret;
-		struct gnttab_unmap_grant_ref kunmap_op;
 		struct gnttab_map_grant_ref *kmap_op =
 			(struct gnttab_map_grant_ref *) page->index;
-		kunmap_op.host_addr = kmap_op->host_addr;
-		kunmap_op.handle = kmap_op->handle;
-		kunmap_op.dev_bus_addr = 0;
-		ret = HYPERVISOR_grant_table_op(
-				GNTTABOP_unmap_grant_ref, &kunmap_op, 1);
-		WARN(ret, "m2p_remove_override: pfn %lx mfn %lx, failed to "
-			"modify kernel mappings", page_to_pfn(page), mfn);
-		return ret;
+		struct multicall_space mcs =
+			xen_mc_entry(sizeof(struct gnttab_unmap_grant_ref));
+		struct gnttab_unmap_grant_ref *kunmap_op = mcs.args;
+
+		if (kmap_op->host_addr == 0)
+			return 0;
+		/* 
+		 * Has the grant_op mapping multicall being issued? If not,
+		 * make sure it is called now.
+		 */
+		if (kmap_op->handle == -1)
+			xen_mc_flush();
+		if (kmap_op->handle == -1) {
+			printk(KERN_WARNING "xen_unmap_granted_page: mfn %lx, "
+					"failed to modify kernel mappings", mfn);
+			return -1;
+		}
+
+		kunmap_op->host_addr = kmap_op->host_addr;
+		kunmap_op->handle = kmap_op->handle;
+		kunmap_op->dev_bus_addr = 0;
+
+		MULTI_grant_table_op(mcs.mc,
+				GNTTABOP_unmap_grant_ref, kunmap_op, 1);
+
+		xen_mc_issue(PARAVIRT_LAZY_MMU);
+		kmap_op->host_addr = 0;
+		return 0;
 	}
 	return 1;
 }
@@ -345,7 +363,6 @@ static inline void __xen_set_pte(pte_t *ptep, pte_t pteval)
 	xen_unmap_granted_page(ptep);
 
 	if (!(pte_flags(pteval) & _PAGE_USER)) {
-		int ret;
 		struct page *page;
 		unsigned long mfn = (pteval.pte & PTE_PFN_MASK) >> PAGE_SHIFT;
 		page = m2p_find_override(mfn);
@@ -354,17 +371,19 @@ static inline void __xen_set_pte(pte_t *ptep, pte_t pteval)
 		 * hypercall to map it instead
 		 */
 		if (page != NULL && (page->private & GRANT_FRAME_BIT)) {
+			struct multicall_space mcs =
+				xen_mc_entry(sizeof(struct gnttab_unmap_grant_ref));
 			struct gnttab_map_grant_ref *kmap_op =
 				(struct gnttab_map_grant_ref *) page->index;
 			unsigned long old_mfn = kmap_op->dev_bus_addr;
 			kmap_op->host_addr =
 				arbitrary_virt_to_machine(ptep).maddr;
 			kmap_op->dev_bus_addr = 0;
-			ret = HYPERVISOR_grant_table_op(
+
+			MULTI_grant_table_op(mcs.mc,
 					GNTTABOP_map_grant_ref, kmap_op, 1);
-			WARN(ret, "xen_set_pte: pfn %lx mfn %lx, failed to "
-				"modify kernel mappings",
-				page_to_pfn(page), mfn);
+
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
 			kmap_op->dev_bus_addr = old_mfn;
 			return;
 		}
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 1c4d2b5..287fa77 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -163,6 +163,7 @@
 #include <asm/xen/hypervisor.h>
 #include <xen/grant_table.h>
 
+#include "multicalls.h"
 #include "xen-ops.h"
 
 static void __init m2p_override_init(void);
@@ -703,10 +704,12 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 
 	if (kmap_op != NULL) {
 		if (!PageHighMem(page)) {
-			int ret = HYPERVISOR_grant_table_op(
+			struct multicall_space mcs = xen_mc_entry(sizeof(*kmap_op));
+
+			MULTI_grant_table_op(mcs.mc,
 					GNTTABOP_map_grant_ref, kmap_op, 1);
-			WARN(ret, "m2p_add_override: pfn %lx mfn %lx, "
-				"failed to modify kernel mappings", pfn, mfn);
+
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
 		}
 		page->private |= GRANT_FRAME_BIT;
 		/* let's use dev_bus_addr to record the old mfn instead */
@@ -734,15 +737,6 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 	if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT))
 		return -EINVAL;
 
-	if (!PageHighMem(page)) {
-		address = (unsigned long)__va(pfn << PAGE_SHIFT);
-		ptep = lookup_address(address, &level);
-
-		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
-					"m2p_remove_override: pfn %lx not mapped", pfn))
-			return -EINVAL;
-	}
-
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
@@ -751,16 +745,38 @@ int m2p_remove_override(struct page *page, bool clear_pte)
 		struct gnttab_map_grant_ref *map_op =
 			(struct gnttab_map_grant_ref *) page->index;
 		set_phys_to_machine(pfn, map_op->dev_bus_addr);
-		if (!PageHighMem(page)) {
-			int ret;
-			struct gnttab_unmap_grant_ref unmap_op;
-			unmap_op.host_addr = map_op->host_addr;
-			unmap_op.handle = map_op->handle;
-			unmap_op.dev_bus_addr = 0;
-			ret = HYPERVISOR_grant_table_op(
-					GNTTABOP_unmap_grant_ref, &unmap_op, 1);
-			WARN(ret, "m2p_remove_override: pfn %lx mfn %lx, "
-				"failed to modify kernel mappings", pfn, mfn);
+		if (map_op->host_addr != 0) {
+			struct multicall_space mcs =
+				xen_mc_entry(sizeof(struct gnttab_unmap_grant_ref));
+			struct gnttab_unmap_grant_ref *unmap_op = mcs.args;
+
+			/* 
+			 * Has the grant_op mapping multicall being issued? If not,
+			 * make sure it is called now.
+			 */
+			if (map_op->handle == -1)
+				xen_mc_flush();
+			if (map_op->handle == -1) {
+				printk(KERN_WARNING "m2p_remove_override: pfn %lx mfn %lx, "
+						"failed to modify kernel mappings", pfn, mfn);
+				return -1;
+			}
+
+			unmap_op->host_addr = map_op->host_addr;
+			unmap_op->handle = map_op->handle;
+			unmap_op->dev_bus_addr = 0;
+
+			MULTI_grant_table_op(mcs.mc,
+					GNTTABOP_unmap_grant_ref, unmap_op, 1);
+
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+			map_op->host_addr = 0;
+			address = (unsigned long)__va(pfn << PAGE_SHIFT);
+			ptep = lookup_address(address, &level);
+			if (WARN(ptep == NULL || level != PG_LEVEL_4K,
+						"m2p_remove_override: pfn %lx not mapped", pfn))
+				return -2;
 			set_pte_at(&init_mm, address, ptep,
 					pfn_pte(pfn, PAGE_KERNEL));
 			__flush_tlb_single(address);
-- 
1.7.2.3

