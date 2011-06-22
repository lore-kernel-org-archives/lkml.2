Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab1FVObW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:31:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757922Ab1FVObS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:31:18 -0400
Message-ID: <4E01FD2B.5090008@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:33:15 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 13/22] KVM: MMU: remove bypass_guest_pf
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:30:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:30:50,
	Serialize complete at 2011-06-22 22:30:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is from Avi:
| Maybe it's time to kill off bypass_guest_pf=1.  It's not as effective as
| it used to be, since unsync pages always use shadow_trap_nonpresent_pte,
| and since we convert between the two nonpresent_ptes during sync and unsync.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    4 --
 arch/x86/include/asm/kvm_host.h     |    3 -
 arch/x86/kvm/mmu.c                  |   83 ++++++++++-------------------------
 arch/x86/kvm/mmu_audit.c            |   12 -----
 arch/x86/kvm/paging_tmpl.h          |   51 +++------------------
 arch/x86/kvm/vmx.c                  |   11 +----
 arch/x86/kvm/x86.c                  |    1 -
 7 files changed, 33 insertions(+), 132 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd248a31..a06e4f1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1159,10 +1159,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			for all guests.
 			Default is 1 (enabled) if in 64bit or 32bit-PAE mode
 
-	kvm-intel.bypass_guest_pf=
-			[KVM,Intel] Disables bypassing of guest page faults
-			on Intel chips. Default is 1 (enabled)
-
 	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
 			(virtualized MMU) support on capable Intel chips.
 			Default is 1 (enabled)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b0834a..42e577d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -266,8 +266,6 @@ struct kvm_mmu {
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
 			    struct x86_exception *exception);
 	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access);
-	void (*prefetch_page)(struct kvm_vcpu *vcpu,
-			      struct kvm_mmu_page *page);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva);
@@ -638,7 +636,6 @@ void kvm_mmu_module_exit(void);
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
 int kvm_mmu_setup(struct kvm_vcpu *vcpu);
-void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte);
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask);
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c6fabf0..2c7b7a0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -186,8 +186,6 @@ static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
-static u64 __read_mostly shadow_trap_nonpresent_pte;
-static u64 __read_mostly shadow_notrap_nonpresent_pte;
 static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
@@ -199,13 +197,6 @@ static inline u64 rsvd_bits(int s, int e)
 	return ((1ULL << (e - s + 1)) - 1) << s;
 }
 
-void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte)
-{
-	shadow_trap_nonpresent_pte = trap_pte;
-	shadow_notrap_nonpresent_pte = notrap_pte;
-}
-EXPORT_SYMBOL_GPL(kvm_mmu_set_nonpresent_ptes);
-
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask)
 {
@@ -229,8 +220,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
 
 static int is_shadow_present_pte(u64 pte)
 {
-	return pte != shadow_trap_nonpresent_pte
-		&& pte != shadow_notrap_nonpresent_pte;
+	return pte != 0ull;
 }
 
 static int is_large_pte(u64 pte)
@@ -777,9 +767,9 @@ static int set_spte_track_bits(u64 *sptep, u64 new_spte)
 	return 1;
 }
 
-static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
+static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
-	if (set_spte_track_bits(sptep, new_spte))
+	if (set_spte_track_bits(sptep, 0ull))
 		rmap_remove(kvm, sptep);
 }
 
@@ -814,8 +804,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 			BUG_ON((*spte & (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK)) != (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK));
 			pgprintk("rmap_write_protect(large): spte %p %llx %lld\n", spte, *spte, gfn);
 			if (is_writable_pte(*spte)) {
-				drop_spte(kvm, spte,
-					  shadow_trap_nonpresent_pte);
+				drop_spte(kvm, spte);
 				--kvm->stat.lpages;
 				spte = NULL;
 				write_protected = 1;
@@ -836,7 +825,7 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	while ((spte = rmap_next(kvm, rmapp, NULL))) {
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("kvm_rmap_unmap_hva: spte %p %llx\n", spte, *spte);
-		drop_spte(kvm, spte, shadow_trap_nonpresent_pte);
+		drop_spte(kvm, spte);
 		need_tlb_flush = 1;
 	}
 	return need_tlb_flush;
@@ -858,7 +847,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 		rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", spte, *spte);
 		need_flush = 1;
 		if (pte_write(*ptep)) {
-			drop_spte(kvm, spte, shadow_trap_nonpresent_pte);
+			drop_spte(kvm, spte);
 			spte = rmap_next(kvm, rmapp, NULL);
 		} else {
 			new_spte = *spte &~ (PT64_BASE_ADDR_MASK);
@@ -1088,7 +1077,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 			    u64 *parent_pte)
 {
 	mmu_page_remove_parent_pte(sp, parent_pte);
-	__set_spte(parent_pte, shadow_trap_nonpresent_pte);
+	__set_spte(parent_pte, 0ull);
 }
 
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
@@ -1130,15 +1119,6 @@ static void mark_unsync(u64 *spte)
 	kvm_mmu_mark_parents_unsync(sp);
 }
 
-static void nonpaging_prefetch_page(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *sp)
-{
-	int i;
-
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
-		sp->spt[i] = shadow_trap_nonpresent_pte;
-}
-
 static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
 			       struct kvm_mmu_page *sp)
 {
@@ -1420,6 +1400,14 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 	}
 }
 
+static void init_shadow_page_table(struct kvm_mmu_page *sp)
+{
+	int i;
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
+		sp->spt[i] = 0ull;
+}
+
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
@@ -1482,10 +1470,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 		account_shadowed(vcpu->kvm, gfn);
 	}
-	if (shadow_trap_nonpresent_pte != shadow_notrap_nonpresent_pte)
-		vcpu->arch.mmu.prefetch_page(vcpu, sp);
-	else
-		nonpaging_prefetch_page(vcpu, sp);
+	init_shadow_page_table(sp);
 	trace_kvm_mmu_get_page(sp, true);
 	return sp;
 }
@@ -1546,7 +1531,7 @@ static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 {
 	if (is_large_pte(*sptep)) {
-		drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
+		drop_spte(vcpu->kvm, sptep);
 		kvm_flush_remote_tlbs(vcpu->kvm);
 	}
 }
@@ -1582,13 +1567,13 @@ static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	pte = *spte;
 	if (is_shadow_present_pte(pte)) {
 		if (is_last_spte(pte, sp->role.level))
-			drop_spte(kvm, spte, shadow_trap_nonpresent_pte);
+			drop_spte(kvm, spte);
 		else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 		}
 	}
-	__set_spte(spte, shadow_trap_nonpresent_pte);
+
 	if (is_large_pte(pte))
 		--kvm->stat.lpages;
 }
@@ -1769,20 +1754,6 @@ static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
 	__set_bit(slot, sp->slot_bitmap);
 }
 
-static void mmu_convert_notrap(struct kvm_mmu_page *sp)
-{
-	int i;
-	u64 *pt = sp->spt;
-
-	if (shadow_trap_nonpresent_pte == shadow_notrap_nonpresent_pte)
-		return;
-
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-		if (pt[i] == shadow_notrap_nonpresent_pte)
-			__set_spte(&pt[i], shadow_trap_nonpresent_pte);
-	}
-}
-
 /*
  * The function is based on mtrr_type_lookup() in
  * arch/x86/kernel/cpu/mtrr/generic.c
@@ -1895,7 +1866,6 @@ static void __kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	sp->unsync = 1;
 
 	kvm_mmu_mark_parents_unsync(sp);
-	mmu_convert_notrap(sp);
 }
 
 static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
@@ -1980,7 +1950,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (level > PT_PAGE_TABLE_LEVEL &&
 		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
 			ret = 1;
-			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
+			drop_spte(vcpu->kvm, sptep);
 			goto done;
 		}
 
@@ -2066,7 +2036,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		} else if (pfn != spte_to_pfn(*sptep)) {
 			pgprintk("hfn old %llx new %llx\n",
 				 spte_to_pfn(*sptep), pfn);
-			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
+			drop_spte(vcpu->kvm, sptep);
 			kvm_flush_remote_tlbs(vcpu->kvm);
 		} else
 			was_rmapped = 1;
@@ -2162,7 +2132,7 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 	spte = sp->spt + i;
 
 	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
-		if (*spte != shadow_trap_nonpresent_pte || spte == sptep) {
+		if (is_shadow_present_pte(*spte) || spte == sptep) {
 			if (!start)
 				continue;
 			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
@@ -2214,7 +2184,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			break;
 		}
 
-		if (*iterator.sptep == shadow_trap_nonpresent_pte) {
+		if (!is_shadow_present_pte(*iterator.sptep)) {
 			u64 base_addr = iterator.addr;
 
 			base_addr &= PT64_LVL_ADDR_MASK(iterator.level);
@@ -2748,7 +2718,6 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->free = nonpaging_free;
-	context->prefetch_page = nonpaging_prefetch_page;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
 	context->update_pte = nonpaging_update_pte;
@@ -2878,7 +2847,6 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
-	context->prefetch_page = paging64_prefetch_page;
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
 	context->update_pte = paging64_update_pte;
@@ -2907,7 +2875,6 @@ static int paging32_init_context(struct kvm_vcpu *vcpu,
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->free = paging_free;
-	context->prefetch_page = paging32_prefetch_page;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
 	context->update_pte = paging32_update_pte;
@@ -2932,7 +2899,6 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = tdp_page_fault;
 	context->free = nonpaging_free;
-	context->prefetch_page = nonpaging_prefetch_page;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
 	context->update_pte = nonpaging_update_pte;
@@ -3453,8 +3419,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 				continue;
 
 			if (is_large_pte(pt[i])) {
-				drop_spte(kvm, &pt[i],
-					  shadow_trap_nonpresent_pte);
+				drop_spte(kvm, &pt[i]);
 				--kvm->stat.lpages;
 				continue;
 			}
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 5f6223b..2460a26 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -99,18 +99,6 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 				     "level = %d\n", sp, level);
 			return;
 		}
-
-		if (*sptep == shadow_notrap_nonpresent_pte) {
-			audit_printk(vcpu->kvm, "notrap spte in unsync "
-				     "sp: %p\n", sp);
-			return;
-		}
-	}
-
-	if (sp->role.direct && *sptep == shadow_notrap_nonpresent_pte) {
-		audit_printk(vcpu->kvm, "notrap spte in direct sp: %p\n",
-			     sp);
-		return;
 	}
 
 	if (!is_shadow_present_pte(*sptep) || !is_last_spte(*sptep, level))
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 1e534e0..58a29d0 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -343,16 +343,11 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp, u64 *spte,
 				    pt_element_t gpte)
 {
-	u64 nonpresent = shadow_trap_nonpresent_pte;
-
 	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
 		goto no_present;
 
-	if (!is_present_gpte(gpte)) {
-		if (!sp->unsync)
-			nonpresent = shadow_notrap_nonpresent_pte;
+	if (!is_present_gpte(gpte))
 		goto no_present;
-	}
 
 	if (!(gpte & PT_ACCESSED_MASK))
 		goto no_present;
@@ -360,7 +355,7 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 	return false;
 
 no_present:
-	drop_spte(vcpu->kvm, spte, nonpresent);
+	drop_spte(vcpu->kvm, spte);
 	return true;
 }
 
@@ -443,7 +438,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		if (spte == sptep)
 			continue;
 
-		if (*spte != shadow_trap_nonpresent_pte)
+		if (is_shadow_present_pte(*spte))
 			continue;
 
 		gpte = gptep[i];
@@ -693,11 +688,10 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 			if (is_shadow_present_pte(*sptep)) {
 				if (is_large_pte(*sptep))
 					--vcpu->kvm->stat.lpages;
-				drop_spte(vcpu->kvm, sptep,
-					  shadow_trap_nonpresent_pte);
+				drop_spte(vcpu->kvm, sptep);
 				need_flush = 1;
-			} else
-				__set_spte(sptep, shadow_trap_nonpresent_pte);
+			}
+
 			break;
 		}
 
@@ -757,36 +751,6 @@ static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
 	return gpa;
 }
 
-static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
-				 struct kvm_mmu_page *sp)
-{
-	int i, j, offset, r;
-	pt_element_t pt[256 / sizeof(pt_element_t)];
-	gpa_t pte_gpa;
-
-	if (sp->role.direct
-	    || (PTTYPE == 32 && sp->role.level > PT_PAGE_TABLE_LEVEL)) {
-		nonpaging_prefetch_page(vcpu, sp);
-		return;
-	}
-
-	pte_gpa = gfn_to_gpa(sp->gfn);
-	if (PTTYPE == 32) {
-		offset = sp->role.quadrant << PT64_LEVEL_BITS;
-		pte_gpa += offset * sizeof(pt_element_t);
-	}
-
-	for (i = 0; i < PT64_ENT_PER_PAGE; i += ARRAY_SIZE(pt)) {
-		r = kvm_read_guest_atomic(vcpu->kvm, pte_gpa, pt, sizeof pt);
-		pte_gpa += ARRAY_SIZE(pt) * sizeof(pt_element_t);
-		for (j = 0; j < ARRAY_SIZE(pt); ++j)
-			if (r || is_present_gpte(pt[j]))
-				sp->spt[i+j] = shadow_trap_nonpresent_pte;
-			else
-				sp->spt[i+j] = shadow_notrap_nonpresent_pte;
-	}
-}
-
 /*
  * Using the cached information from sp->gfns is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
@@ -839,8 +803,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		}
 
 		if (gfn != sp->gfns[i]) {
-			drop_spte(vcpu->kvm, &sp->spt[i],
-				      shadow_trap_nonpresent_pte);
+			drop_spte(vcpu->kvm, &sp->spt[i]);
 			vcpu->kvm->tlbs_dirty++;
 			continue;
 		}
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f5b49c7..a644acb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -49,9 +49,6 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
-static int __read_mostly bypass_guest_pf = 1;
-module_param(bypass_guest_pf, bool, S_IRUGO);
-
 static int __read_mostly enable_vpid = 1;
 module_param_named(vpid, enable_vpid, bool, 0444);
 
@@ -3632,8 +3629,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmcs_write32(PLE_WINDOW, ple_window);
 	}
 
-	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, !!bypass_guest_pf);
-	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, !!bypass_guest_pf);
+	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
+	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
 	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
 
 	vmcs_write16(HOST_FS_SELECTOR, 0);            /* 22.2.4 */
@@ -7103,16 +7100,12 @@ static int __init vmx_init(void)
 	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
 
 	if (enable_ept) {
-		bypass_guest_pf = 0;
 		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
 				VMX_EPT_EXECUTABLE_MASK);
 		kvm_enable_tdp();
 	} else
 		kvm_disable_tdp();
 
-	if (bypass_guest_pf)
-		kvm_mmu_set_nonpresent_ptes(~0xffeull, 0ull);
-
 	return 0;
 
 out3:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 40ffbc5..78d5519 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5065,7 +5065,6 @@ int kvm_arch_init(void *opaque)
 	kvm_init_msr_list();
 
 	kvm_x86_ops = ops;
-	kvm_mmu_set_nonpresent_ptes(0ull, 0ull);
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
 			PT_DIRTY_MASK, PT64_NX_MASK, 0);
 
-- 
1.7.5.4

