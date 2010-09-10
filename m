Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0IJPdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:33:09 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34130 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab0IJPc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:58 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h43h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF3Z-02-JPU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/29] KVM: MMU: Let is_rsvd_bits_set take mmu context instead of vcpu
Date: Fri, 10 Sep 2010 17:30:45 +0200
Message-ID: <1284132667-18620-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes is_rsvd_bits_set() function prototype to
take only a kvm_mmu context instead of a full vcpu.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |    6 +++---
 arch/x86/kvm/paging_tmpl.h |    7 ++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9e48a77..86f7557 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2578,12 +2578,12 @@ static void paging_free(struct kvm_vcpu *vcpu)
 	nonpaging_free(vcpu);
 }
 
-static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
+static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
 {
 	int bit7;
 
 	bit7 = (gpte >> 7) & 1;
-	return (gpte & vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
+	return (gpte & mmu->rsvd_bits_mask[bit7][level-1]) != 0;
 }
 
 #define PTTYPE 64
@@ -2859,7 +2859,7 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 		return;
         }
 
-	if (is_rsvd_bits_set(vcpu, *(u64 *)new, PT_PAGE_TABLE_LEVEL))
+	if (is_rsvd_bits_set(&vcpu->arch.mmu, *(u64 *)new, PT_PAGE_TABLE_LEVEL))
 		return;
 
 	++vcpu->kvm->stat.mmu_pte_updated;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 13d0c06..68ee1b7 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -168,7 +168,7 @@ walk:
 			break;
 		}
 
-		if (is_rsvd_bits_set(vcpu, pte, walker->level)) {
+		if (is_rsvd_bits_set(&vcpu->arch.mmu, pte, walker->level)) {
 			rsvd_fault = true;
 			break;
 		}
@@ -327,6 +327,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 				u64 *sptep)
 {
 	struct kvm_mmu_page *sp;
+	struct kvm_mmu *mmu = &vcpu->arch.mmu;
 	pt_element_t *gptep = gw->prefetch_ptes;
 	u64 *spte;
 	int i;
@@ -358,7 +359,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		gpte = gptep[i];
 
 		if (!is_present_gpte(gpte) ||
-		      is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL)) {
+		      is_rsvd_bits_set(mmu, gpte, PT_PAGE_TABLE_LEVEL)) {
 			if (!sp->unsync)
 				__set_spte(spte, shadow_notrap_nonpresent_pte);
 			continue;
@@ -713,7 +714,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			return -EINVAL;
 
 		gfn = gpte_to_gfn(gpte);
-		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL)
+		if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL)
 		      || gfn != sp->gfns[i] || !is_present_gpte(gpte)
 		      || !(gpte & PT_ACCESSED_MASK)) {
 			u64 nonpresent;
-- 
1.7.0.4


