Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2LJJNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:13:16 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38820 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2LJJNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:13:13 -0500
Message-ID: <50C5A79F.3020805@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 17:13:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 2/5] KVM: MMU: adjust page size early if gfn used as page
 table
References: <50C5A747.1020105@linux.vnet.ibm.com>
In-Reply-To: <50C5A747.1020105@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121009-1396-0000-0000-000002471502
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have two issues in current code:
- if target gfn is used as its page table, guest will refault then kvm will use
  small page size to map it. We need two #PF to fix its shadow page table

- sometimes, say a exception is triggered during vm-exit caused by #PF
  (see handle_exception() in vmx.c), we remove all the shadow pages shadowed
  by the target gfn before go into page fault path, it will cause infinite
  loop:
  delete shadow pages shadowed by the gfn -> try to use large page size to map
  the gfn -> retry the access ->...

To fix these, We can adjust page size early if the target gfn is used as page
table

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   13 ++++---------
 arch/x86/kvm/paging_tmpl.h |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2a3c890..54fc61e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2380,15 +2380,10 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (pte_access & ACC_WRITE_MASK) {

 		/*
-		 * There are two cases:
-		 * - the one is other vcpu creates new sp in the window
-		 *   between mapping_level() and acquiring mmu-lock.
-		 * - the another case is the new sp is created by itself
-		 *   (page-fault path) when guest uses the target gfn as
-		 *   its page table.
-		 * Both of these cases can be fixed by allowing guest to
-		 * retry the access, it will refault, then we can establish
-		 * the mapping by using small page.
+		 * Other vcpu creates new sp in the window between
+		 * mapping_level() and acquiring mmu-lock. We can
+		 * allow guest to retry the access, the mapping can
+		 * be fixed if guest refault.
 		 */
 		if (level > PT_PAGE_TABLE_LEVEL &&
 		    has_wrprotected_page(vcpu->kvm, gfn, level))
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ec481e9..32d77ff 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -491,6 +491,36 @@ out_gpte_changed:
 	return 0;
 }

+ /*
+ * To see whether the mapped gfn can write its page table in the current
+ * mapping.
+ *
+ * It is the helper function of FNAME(page_fault). When guest uses large page
+ * size to map the writable gfn which is used as current page table, we should
+ * force kvm to use small page size to map it because new shadow page will be
+ * created when kvm establishes shadow page table that stop kvm using large
+ * page size. Do it early can avoid unnecessary #PF and emulation.
+ *
+ * Note: the PDPT page table is not checked for PAE-32 bit guest. It is ok
+ * since the PDPT is always shadowed, that means, we can not use large page
+ * size to map the gfn which is used as PDPT.
+ */
+static bool
+FNAME(mapped_gfn_can_write_current_pagetable)(struct guest_walker *walker)
+{
+	int level;
+	gfn_t mask = ~(KVM_PAGES_PER_HPAGE(walker->level) - 1);
+
+	if (!(walker->pte_access & ACC_WRITE_MASK))
+		return false;
+
+	for (level = walker->level; level <= walker->max_level; level++)
+		if (!((walker->gfn ^ walker->table_gfn[level - 1]) & mask))
+			return true;
+
+	return false;
+}
+
 /*
  * Page fault handler.  There are several causes for a page fault:
  *   - there is no shadow pte for the guest pte
@@ -560,7 +590,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	}

 	if (walker.level >= PT_DIRECTORY_LEVEL)
-		force_pt_level = mapping_level_dirty_bitmap(vcpu, walker.gfn);
+		force_pt_level = mapping_level_dirty_bitmap(vcpu, walker.gfn)
+		      || FNAME(mapped_gfn_can_write_current_pagetable)(&walker);
 	else
 		force_pt_level = 1;
 	if (!force_pt_level) {
-- 
1.7.7.6

