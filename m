Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0H1LUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:20:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52698 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0H1LUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:20:16 -0400
Message-ID: <4C78F1DD.2010907@cn.fujitsu.com>
Date: Sat, 28 Aug 2010 19:24:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/5] KVM: MMU: rewrite audit_mappings_page() function
References: <4C78F07E.1040709@cn.fujitsu.com>
In-Reply-To: <4C78F07E.1040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bugs in this function, we call gfn_to_pfn() and kvm_mmu_gva_to_gpa_read() in
atomic context(kvm_mmu_audit() is called under the spinlock(mmu_lock)'s protection).

This patch fix it by:
- introduce gfn_to_pfn_atomic instead of gfn_to_pfn
- get the mapping gfn from kvm_mmu_page_get_gfn()

And it adds 'notrap' ptes check in unsync/direct sps

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c       |   75 ++++++++++++++++++++++++---------------------
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   15 ++++++++-
 3 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 68575dc..0d91f60 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3487,15 +3487,6 @@ EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
 
 static const char *audit_msg;
 
-static gva_t canonicalize(gva_t gva)
-{
-#ifdef CONFIG_X86_64
-	gva = (long long)(gva << 16) >> 16;
-#endif
-	return gva;
-}
-
-
 typedef void (*inspect_spte_fn) (struct kvm *kvm, u64 *sptep);
 
 static void __mmu_spte_walk(struct kvm *kvm, struct kvm_mmu_page *sp,
@@ -3550,39 +3541,53 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 	gva_t va_delta = 1ul << (PAGE_SHIFT + 9 * (level - 1));
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i, va += va_delta) {
-		u64 ent = pt[i];
+		u64 *sptep = pt + i;
+		struct kvm_mmu_page *sp;
+		gfn_t gfn;
+		pfn_t pfn;
+		hpa_t hpa;
 
-		if (ent == shadow_trap_nonpresent_pte)
-			continue;
+		sp = page_header(__pa(sptep));
 
-		va = canonicalize(va);
-		if (is_shadow_present_pte(ent) && !is_last_spte(ent, level))
-			audit_mappings_page(vcpu, ent, va, level - 1);
-		else {
-			gpa_t gpa = kvm_mmu_gva_to_gpa_read(vcpu, va, NULL);
-			gfn_t gfn = gpa >> PAGE_SHIFT;
-			pfn_t pfn = gfn_to_pfn(vcpu->kvm, gfn);
-			hpa_t hpa = (hpa_t)pfn << PAGE_SHIFT;
+		if (sp->unsync) {
+			if (level != PT_PAGE_TABLE_LEVEL) {
+				printk(KERN_ERR "audit: (%s) error: unsync sp: %p level = %d\n",
+						audit_msg, sp, level);
+				return;
+			}
 
-			if (is_error_pfn(pfn)) {
-				kvm_release_pfn_clean(pfn);
-				continue;
+			if (*sptep == shadow_notrap_nonpresent_pte) {
+				printk(KERN_ERR "audit: (%s) error: notrap spte in unsync sp: %p\n",
+						audit_msg, sp);
+				return;
 			}
+		}
 
-			if (is_shadow_present_pte(ent)
-			    && (ent & PT64_BASE_ADDR_MASK) != hpa)
-				printk(KERN_ERR "xx audit error: (%s) levels %d"
-				       " gva %lx gpa %llx hpa %llx ent %llx %d\n",
-				       audit_msg, vcpu->arch.mmu.root_level,
-				       va, gpa, hpa, ent,
-				       is_shadow_present_pte(ent));
-			else if (ent == shadow_notrap_nonpresent_pte
-				 && !is_error_hpa(hpa))
-				printk(KERN_ERR "audit: (%s) notrap shadow,"
-				       " valid guest gva %lx\n", audit_msg, va);
-			kvm_release_pfn_clean(pfn);
+		if (sp->role.direct && *sptep == shadow_notrap_nonpresent_pte) {
+			printk(KERN_ERR "audit: (%s) error: notrap spte in direct sp: %p\n",
+					audit_msg, sp);
+			return;
+		}
+
+		if (!is_shadow_present_pte(*sptep) ||
+		      !is_last_spte(*sptep, level))
+			return;
+
+		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
 
+		if (is_error_pfn(pfn)) {
+			kvm_release_pfn_clean(pfn);
+			return;
 		}
+
+		hpa =  pfn << PAGE_SHIFT;
+
+		if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
+			printk(KERN_ERR "xx audit error: (%s) levels %d"
+					   " gva %lx pfn %llx hpa %llx ent %llxn",
+					   audit_msg, vcpu->arch.mmu.root_level,
+					   va, pfn, hpa, *sptep);
 	}
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b837ec8..f2ecdd5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -300,6 +300,7 @@ void kvm_set_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
 
 pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr);
+pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d08b740..9a73b98 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -999,7 +999,7 @@ pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(hva_to_pfn_atomic);
 
-pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
+static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic)
 {
 	unsigned long addr;
 
@@ -1009,7 +1009,18 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 		return page_to_pfn(bad_page);
 	}
 
-	return hva_to_pfn(kvm, addr, false);
+	return hva_to_pfn(kvm, addr, atomic);
+}
+
+pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
+{
+	return __gfn_to_pfn(kvm, gfn, true);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_atomic);
+
+pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
+{
+	return __gfn_to_pfn(kvm, gfn, false);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
-- 
1.7.0.4

