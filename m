Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1DRQrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:47:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28279 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab1DRQrB (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 18 Apr 2011 12:47:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/p2m/m2p/gnttab: Support GNTMAP_host_map in the M2P override.
Date: Mon, 18 Apr 2011 11:20:11 -0400
Message-Id: <1303140011-3623-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
References: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DAC6B01.00D4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only supported the M2P (and P2M) override only for the
GNTMAP_contains_pte type mappings. Meaning that we grants
operations would "contain the machine address of the PTE to update"
If the flag is unset, then the grant operation is
"contains a host virtual address". The latter case means that
the Hypervisor takes care of updating our page table
(specifically the PTE entry) with the guest's MFN. As such we should
not try to do anything with the PTE. Previous to this patch
we would try to clear the PTE which resulted in Xen hypervisor
being upset with us:

(XEN) mm.c:1066:d0 Attempt to implicitly unmap a granted PTE c0100000ccc59067
(XEN) domain_crash called from mm.c:1067
(XEN) Domain 0 (vcpu#0) crashed on cpu#3:
(XEN) ----[ Xen-4.0-110228  x86_64  debug=y  Not tainted ]----

and crashing us.

This patch allows us to inhibit the PTE clearing in the PV guest
if the GNTMAP_contains_pte is not set.

On the m2p_remove_override path we provide the same parameter.

Sadly in the grant-table driver we do not have a mechanism to
tell m2p_remove_override whether to clear the PTE or not. Since
the grant-table driver is used by user-space, we can safely assume
that it operates only on PTE's. Hence the implementation for
it to work on !GNTMAP_contains_pte returns -EOPNOTSUPP. In the future
we can implement the support for this. It will require some extra
accounting structure to keep track of the page[i], and the flag.

[v1: Added documentation details, made it return -EOPNOTSUPP instead
 of trying to do a half-way implementation]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    5 +++--
 arch/x86/xen/p2m.c              |   10 ++++------
 drivers/xen/grant-table.c       |   31 ++++++++++++++++++++++++-------
 3 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index c61934f..64a619d 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -47,8 +47,9 @@ extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 					     unsigned long pfn_e);
 
-extern int m2p_add_override(unsigned long mfn, struct page *page);
-extern int m2p_remove_override(struct page *page);
+extern int m2p_add_override(unsigned long mfn, struct page *page,
+			    bool clear_pte);
+extern int m2p_remove_override(struct page *page, bool clear_pte);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 141eb0d..2d2b32a 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -650,7 +650,7 @@ static unsigned long mfn_hash(unsigned long mfn)
 }
 
 /* Add an MFN override for a particular page */
-int m2p_add_override(unsigned long mfn, struct page *page)
+int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
 {
 	unsigned long flags;
 	unsigned long pfn;
@@ -662,7 +662,6 @@ int m2p_add_override(unsigned long mfn, struct page *page)
 	if (!PageHighMem(page)) {
 		address = (unsigned long)__va(pfn << PAGE_SHIFT);
 		ptep = lookup_address(address, &level);
-
 		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
 					"m2p_add_override: pfn %lx not mapped", pfn))
 			return -EINVAL;
@@ -674,10 +673,9 @@ int m2p_add_override(unsigned long mfn, struct page *page)
 	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
 		return -ENOMEM;
 
-	if (!PageHighMem(page))
+	if (clear_pte && !PageHighMem(page))
 		/* Just zap old mapping for now */
 		pte_clear(&init_mm, address, ptep);
-
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
@@ -685,7 +683,7 @@ int m2p_add_override(unsigned long mfn, struct page *page)
 	return 0;
 }
 
-int m2p_remove_override(struct page *page)
+int m2p_remove_override(struct page *page, bool clear_pte)
 {
 	unsigned long flags;
 	unsigned long mfn;
@@ -713,7 +711,7 @@ int m2p_remove_override(struct page *page)
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
 	set_phys_to_machine(pfn, page->index);
 
-	if (!PageHighMem(page))
+	if (clear_pte && !PageHighMem(page))
 		set_pte_at(&init_mm, address, ptep,
 				pfn_pte(pfn, PAGE_KERNEL));
 		/* No tlb flush necessary because the caller already
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 3745a31..fd725cd 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -466,13 +466,30 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		if (map_ops[i].status)
 			continue;
 
-		/* m2p override only supported for GNTMAP_contains_pte mappings */
-		if (!(map_ops[i].flags & GNTMAP_contains_pte))
-			continue;
-		pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
+		if (map_ops[i].flags & GNTMAP_contains_pte) {
+			pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
 				(map_ops[i].host_addr & ~PAGE_MASK));
-		mfn = pte_mfn(*pte);
-		ret = m2p_add_override(mfn, pages[i]);
+			mfn = pte_mfn(*pte);
+		} else {
+			/* If you really wanted to do this:
+			 * mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
+			 *
+			 * The reason we do not implement it is b/c on the
+			 * unmap path (gnttab_unmap_refs) we have no means of
+			 * checking whether the page is !GNTMAP_contains_pte.
+			 *
+			 * That is without some extra data-structure to carry
+			 * the struct page, bool clear_pte, and list_head next
+			 * tuples and deal with allocation/delallocation, etc.
+			 *
+			 * The users of this API set the GNTMAP_contains_pte
+			 * flag so lets just return not supported until it
+			 * becomes neccessary to implement.
+			 */
+			return -EOPNOTSUPP;
+		}
+		ret = m2p_add_override(mfn, pages[i],
+				       map_ops[i].flags & GNTMAP_contains_pte);
 		if (ret)
 			return ret;
 	}
@@ -494,7 +511,7 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		return ret;
 
 	for (i = 0; i < count; i++) {
-		ret = m2p_remove_override(pages[i]);
+		ret = m2p_remove_override(pages[i], true /* clear the PTE */);
 		if (ret)
 			return ret;
 	}
-- 
1.7.1

