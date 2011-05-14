Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab1ENVnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 17:43:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49191 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab1ENVnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 17:43:33 -0400
Message-ID: <4DCEF7F1.5020806@cn.fujitsu.com>
Date: Sun, 15 May 2011 05:45:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 6/7] KVM: MMU: cleanup for kvm_mmu_page_unlink_children
References: <4DCEF5B1.3050706@cn.fujitsu.com>
In-Reply-To: <4DCEF5B1.3050706@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:43:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:43:44,
	Serialize complete at 2011-05-15 05:43:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the same operation between kvm_mmu_page_unlink_children and
mmu_pte_write_zap_pte

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   66 ++++++++++++++++++---------------------------------
 1 files changed, 23 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b68f42c..a8def38 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1566,32 +1566,33 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	}
 }
 
+static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
+			     u64 *spte)
+{
+	u64 pte;
+	struct kvm_mmu_page *child;
+
+	pte = *spte;
+	if (is_shadow_present_pte(pte)) {
+		if (is_last_spte(pte, sp->role.level))
+			drop_spte(kvm, spte, shadow_trap_nonpresent_pte);
+		else {
+			child = page_header(pte & PT64_BASE_ADDR_MASK);
+			mmu_page_remove_parent_pte(child, spte);
+		}
+	}
+	__set_spte(spte, shadow_trap_nonpresent_pte);
+	if (is_large_pte(pte))
+		--kvm->stat.lpages;
+}
+
 static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 					 struct kvm_mmu_page *sp)
 {
 	unsigned i;
-	u64 *pt;
-	u64 ent;
-
-	pt = sp->spt;
 
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-		ent = pt[i];
-
-		if (is_shadow_present_pte(ent)) {
-			if (!is_last_spte(ent, sp->role.level)) {
-				ent &= PT64_BASE_ADDR_MASK;
-				mmu_page_remove_parent_pte(page_header(ent),
-							   &pt[i]);
-			} else {
-				if (is_large_pte(ent))
-					--kvm->stat.lpages;
-				drop_spte(kvm, &pt[i],
-					  shadow_trap_nonpresent_pte);
-			}
-		}
-		pt[i] = shadow_trap_nonpresent_pte;
-	}
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
+		mmu_page_zap_pte(kvm, sp, sp->spt + i);
 }
 
 static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
@@ -3069,27 +3070,6 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
-static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu_page *sp,
-				  u64 *spte)
-{
-	u64 pte;
-	struct kvm_mmu_page *child;
-
-	pte = *spte;
-	if (is_shadow_present_pte(pte)) {
-		if (is_last_spte(pte, sp->role.level))
-			drop_spte(vcpu->kvm, spte, shadow_trap_nonpresent_pte);
-		else {
-			child = page_header(pte & PT64_BASE_ADDR_MASK);
-			mmu_page_remove_parent_pte(child, spte);
-		}
-	}
-	__set_spte(spte, shadow_trap_nonpresent_pte);
-	if (is_large_pte(pte))
-		--vcpu->kvm->stat.lpages;
-}
-
 static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp, u64 *spte,
 				  const void *new)
@@ -3271,7 +3251,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		spte = &sp->spt[page_offset / sizeof(*spte)];
 		while (npte--) {
 			entry = *spte;
-			mmu_pte_write_zap_pte(vcpu, sp, spte);
+			mmu_page_zap_pte(vcpu->kvm, sp, spte);
 			if (gentry &&
 			      !((sp->role.word ^ vcpu->arch.mmu.base_role.word)
 			      & mask.word))
-- 
1.7.4.4

