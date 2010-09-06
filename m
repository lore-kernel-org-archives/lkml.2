Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0IFPC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:02:56 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:4939 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab0IFPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:38 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2R-01-AOM-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/27] KVM: MMU: Add kvm_mmu parameter to load_pdptrs function
Date: Mon, 6 Sep 2010 17:01:55 +0200
Message-ID: <1283785322-26898-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function need to be able to load the pdptrs from any
mmu context currently in use. So change this function to
take an kvm_mmu parameter to fit these needs.
As a side effect this patch also moves the cached pdptrs
from vcpu_arch into the kvm_mmu struct.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    5 +++--
 arch/x86/kvm/kvm_cache_regs.h   |    2 +-
 arch/x86/kvm/svm.c              |    2 +-
 arch/x86/kvm/vmx.c              |   16 ++++++++--------
 arch/x86/kvm/x86.c              |   26 ++++++++++++++------------
 5 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 173834b..1080c0f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -259,6 +259,8 @@ struct kvm_mmu {
 
 	u64 *pae_root;
 	u64 rsvd_bits_mask[2][4];
+
+	u64 pdptrs[4]; /* pae */
 };
 
 struct kvm_vcpu_arch {
@@ -278,7 +280,6 @@ struct kvm_vcpu_arch {
 	unsigned long cr4_guest_owned_bits;
 	unsigned long cr8;
 	u32 hflags;
-	u64 pdptrs[4]; /* pae */
 	u64 efer;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
@@ -594,7 +595,7 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
-int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
+int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 6491ac8..a37abe2 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -42,7 +42,7 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 		      (unsigned long *)&vcpu->arch.regs_avail))
 		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_PDPTR);
 
-	return vcpu->arch.pdptrs[index];
+	return vcpu->arch.walk_mmu->pdptrs[index];
 }
 
 static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 094df31..a98ac52 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1010,7 +1010,7 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	switch (reg) {
 	case VCPU_EXREG_PDPTR:
 		BUG_ON(!npt_enabled);
-		load_pdptrs(vcpu, vcpu->arch.cr3);
+		load_pdptrs(vcpu, vcpu->arch.walk_mmu, vcpu->arch.cr3);
 		break;
 	default:
 		BUG();
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0e62d8a..0a70194 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1848,20 +1848,20 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 		return;
 
 	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
-		vmcs_write64(GUEST_PDPTR0, vcpu->arch.pdptrs[0]);
-		vmcs_write64(GUEST_PDPTR1, vcpu->arch.pdptrs[1]);
-		vmcs_write64(GUEST_PDPTR2, vcpu->arch.pdptrs[2]);
-		vmcs_write64(GUEST_PDPTR3, vcpu->arch.pdptrs[3]);
+		vmcs_write64(GUEST_PDPTR0, vcpu->arch.mmu.pdptrs[0]);
+		vmcs_write64(GUEST_PDPTR1, vcpu->arch.mmu.pdptrs[1]);
+		vmcs_write64(GUEST_PDPTR2, vcpu->arch.mmu.pdptrs[2]);
+		vmcs_write64(GUEST_PDPTR3, vcpu->arch.mmu.pdptrs[3]);
 	}
 }
 
 static void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 {
 	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
-		vcpu->arch.pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
-		vcpu->arch.pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
-		vcpu->arch.pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
-		vcpu->arch.pdptrs[3] = vmcs_read64(GUEST_PDPTR3);
+		vcpu->arch.mmu.pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
+		vcpu->arch.mmu.pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
+		vcpu->arch.mmu.pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
+		vcpu->arch.mmu.pdptrs[3] = vmcs_read64(GUEST_PDPTR3);
 	}
 
 	__set_bit(VCPU_EXREG_PDPTR,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca69dcc..337f59f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -418,17 +418,17 @@ int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 /*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
-int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
+int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 {
 	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
 	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
 	int i, error;
 	int ret;
-	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
+	u64 pdpte[ARRAY_SIZE(mmu->pdptrs)];
 
-	ret = kvm_read_nested_guest_page(vcpu, pdpt_gfn, pdpte,
-					 offset * sizeof(u64),
-					 sizeof(pdpte), &error);
+	ret = kvm_read_guest_page_mmu(vcpu, mmu, pdpt_gfn, pdpte,
+				      offset * sizeof(u64),
+				      sizeof(pdpte), &error);
 	if (ret < 0) {
 		ret = 0;
 		goto out;
@@ -442,7 +442,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 	ret = 1;
 
-	memcpy(vcpu->arch.pdptrs, pdpte, sizeof(vcpu->arch.pdptrs));
+	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	__set_bit(VCPU_EXREG_PDPTR,
 		  (unsigned long *)&vcpu->arch.regs_avail);
 	__set_bit(VCPU_EXREG_PDPTR,
@@ -455,7 +455,7 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 
 static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 {
-	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
+	u64 pdpte[ARRAY_SIZE(vcpu->arch.walk_mmu->pdptrs)];
 	bool changed = true;
 	int offset;
 	u32 error;
@@ -475,7 +475,7 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 				       sizeof(pdpte), &error);
 	if (r < 0)
 		goto out;
-	changed = memcmp(pdpte, vcpu->arch.pdptrs, sizeof(pdpte)) != 0;
+	changed = memcmp(pdpte, vcpu->arch.walk_mmu->pdptrs, sizeof(pdpte)) != 0;
 out:
 
 	return changed;
@@ -514,7 +514,8 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 				return 1;
 		} else
 #endif
-		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->arch.cr3))
+		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu,
+						 vcpu->arch.cr3))
 			return 1;
 	}
 
@@ -603,7 +604,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
 		   && ((cr4 ^ old_cr4) & pdptr_bits)
-		   && !load_pdptrs(vcpu, vcpu->arch.cr3))
+		   && !load_pdptrs(vcpu, vcpu->arch.walk_mmu, vcpu->arch.cr3))
 		return 1;
 
 	if (cr4 & X86_CR4_VMXE)
@@ -636,7 +637,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		if (is_pae(vcpu)) {
 			if (cr3 & CR3_PAE_RESERVED_BITS)
 				return 1;
-			if (is_paging(vcpu) && !load_pdptrs(vcpu, cr3))
+			if (is_paging(vcpu) &&
+			    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 				return 1;
 		}
 		/*
@@ -5412,7 +5414,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
 	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
 	if (!is_long_mode(vcpu) && is_pae(vcpu)) {
-		load_pdptrs(vcpu, vcpu->arch.cr3);
+		load_pdptrs(vcpu, vcpu->arch.walk_mmu, vcpu->arch.cr3);
 		mmu_reset_needed = 1;
 	}
 
-- 
1.7.0.4


