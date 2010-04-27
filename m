Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0D0Kmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:42:49 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:51326
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754575Ab0D0Kix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:53 -0400
X-SpamScore: 9
X-BigFish: VPS9(zzab9bh78fbpzz1202hzz6ff19hz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WI-01-32N-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/22] KVM: MMU: Add infrastructure for two-level page walker
Date: Tue, 27 Apr 2010 12:38:21 +0200
Message-ID: <1272364712-17425-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0886 (UTC) FILETIME=[CA6538E0:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a mmu-callback to translate gpa
addresses in the walk_addr code. This is later used to
translate l2_gpa addresses into l1_gpa addresses.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    7 +++++++
 arch/x86/kvm/paging_tmpl.h      |    1 +
 include/linux/kvm_host.h        |    5 +++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f1d46e6..ccdbd2f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -242,6 +242,7 @@ struct kvm_mmu {
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
 			    u32 *error);
+	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error);
 	void (*prefetch_page)(struct kvm_vcpu *vcpu,
 			      struct kvm_mmu_page *page);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 615c78f..4e0bfdb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2131,6 +2131,11 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	spin_unlock(&vcpu->kvm->mmu_lock);
 }
 
+static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error)
+{
+	return gpa;
+}
+
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 				  u32 access, u32 *error)
 {
@@ -2387,6 +2392,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = tdp_page_fault;
 	context->free = nonpaging_free;
+	context->translate_gpa = translate_gpa;
 	context->prefetch_page = nonpaging_prefetch_page;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
@@ -2434,6 +2440,7 @@ int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 
 	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
 	vcpu->arch.mmu.direct_map        = false;
+	vcpu->arch.mmu.translate_gpa     = translate_gpa;
 
 	return r;
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index b1086fe..101849a 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -122,6 +122,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	unsigned index, pt_access, pte_access;
 	gpa_t pte_gpa;
 	int rsvd_fault = 0;
+	u32 error;
 
 	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
 				     fetch_fault);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ce027d5..70025d1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -520,6 +520,11 @@ static inline gpa_t gfn_to_gpa(gfn_t gfn)
 	return (gpa_t)gfn << PAGE_SHIFT;
 }
 
+static inline gfn_t gpa_to_gfn(gpa_t gpa)
+{
+	return (gfn_t)gpa >> PAGE_SHIFT;
+}
+
 static inline hpa_t pfn_to_hpa(pfn_t pfn)
 {
 	return (hpa_t)pfn << PAGE_SHIFT;
-- 
1.7.0.4


