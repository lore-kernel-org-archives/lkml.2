Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0GFKtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:49:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0GFKtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:49:23 -0400
Message-ID: <4C330948.1070305@cn.fujitsu.com>
Date: Tue, 06 Jul 2010 18:45:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v5 2/9] KVM: MMU: fix race between 'walk_addr' and 'fetch'
References: <4C330918.6040709@cn.fujitsu.com>
In-Reply-To: <4C330918.6040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'walk_addr' is out of mmu_lock's protection, so while we handle 'fetch',
then guest's mapping has modifited by other vcpu's write path, such as
invlpg, pte_write and other fetch path

Fixed by checking all level's mapping

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   73 ++++++++++++++++++++++++++------------------
 1 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 19f0077..f58a5c4 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -300,7 +300,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 int *ptwrite, pfn_t pfn)
 {
 	unsigned access = gw->pt_access;
-	struct kvm_mmu_page *sp;
+	struct kvm_mmu_page *sp = NULL;
 	u64 spte, *sptep = NULL;
 	int direct;
 	gfn_t table_gfn;
@@ -319,22 +319,23 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		direct_access &= ~ACC_WRITE_MASK;
 
 	for_each_shadow_entry(vcpu, addr, iterator) {
+		bool nonpresent = false, last_mapping = false;
+
 		level = iterator.level;
 		sptep = iterator.sptep;
-		if (iterator.level == hlevel) {
-			mmu_set_spte(vcpu, sptep, access,
-				     gw->pte_access & access,
-				     user_fault, write_fault,
-				     dirty, ptwrite, level,
-				     gw->gfn, pfn, false, true);
-			break;
+
+		if (level == hlevel) {
+			last_mapping = true;
+			goto check_set_spte;
 		}
 
-		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
-			struct kvm_mmu_page *child;
+		if (is_large_pte(*sptep)) {
+			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
+			kvm_flush_remote_tlbs(vcpu->kvm);
+		}
 
-			if (level != gw->level)
-				continue;
+		if (is_shadow_present_pte(*sptep) && level == gw->level) {
+			struct kvm_mmu_page *child;
 
 			/*
 			 * For the direct sp, if the guest pte's dirty bit
@@ -344,19 +345,17 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 * a new sp with the correct access.
 			 */
 			child = page_header(*sptep & PT64_BASE_ADDR_MASK);
-			if (child->role.access == direct_access)
-				continue;
-
-			mmu_page_remove_parent_pte(child, sptep);
-			__set_spte(sptep, shadow_trap_nonpresent_pte);
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			if (child->role.access != direct_access) {
+				mmu_page_remove_parent_pte(child, sptep);
+				__set_spte(sptep, shadow_trap_nonpresent_pte);
+				kvm_flush_remote_tlbs(vcpu->kvm);
+			}
 		}
 
-		if (is_large_pte(*sptep)) {
-			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
-			kvm_flush_remote_tlbs(vcpu->kvm);
-		}
+		if (is_shadow_present_pte(*sptep))
+			goto check_set_spte;
 
+		nonpresent = true;
 		if (level <= gw->level) {
 			direct = 1;
 			access = direct_access;
@@ -374,22 +373,36 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		}
 		sp = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
 					       direct, access, sptep);
-		if (!direct) {
+check_set_spte:
+		if (level >= gw->level) {
 			r = kvm_read_guest_atomic(vcpu->kvm,
-						  gw->pte_gpa[level - 2],
+						  gw->pte_gpa[level - 1],
 						  &curr_pte, sizeof(curr_pte));
-			if (r || curr_pte != gw->ptes[level - 2]) {
-				kvm_mmu_put_page(sp, sptep);
+			if (r || curr_pte != gw->ptes[level - 1]) {
+				if (nonpresent)
+					kvm_mmu_put_page(sp, sptep);
 				kvm_release_pfn_clean(pfn);
 				sptep = NULL;
 				break;
 			}
 		}
 
-		spte = __pa(sp->spt)
-			| PT_PRESENT_MASK | PT_ACCESSED_MASK
-			| PT_WRITABLE_MASK | PT_USER_MASK;
-		*sptep = spte;
+		if (nonpresent) {
+			spte = __pa(sp->spt)
+				| PT_PRESENT_MASK | PT_ACCESSED_MASK
+				| PT_WRITABLE_MASK | PT_USER_MASK;
+			*sptep = spte;
+			continue;
+		}
+
+		if (last_mapping) {
+			mmu_set_spte(vcpu, sptep, access,
+				     gw->pte_access & access,
+				     user_fault, write_fault,
+				     dirty, ptwrite, level,
+				     gw->gfn, pfn, false, true);
+			break;
+		}
 	}
 
 	return sptep;
-- 
1.6.1.2


