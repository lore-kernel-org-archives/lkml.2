Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1FUAAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:00:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230Ab1FUAAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:00:07 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Zachary Amsden <zamsden@gmail.com>
Subject: [KVM TSC emulation 6/9] Allow adjust_tsc_offset to be in host or guest cycles
Date: Mon, 20 Jun 2011 16:59:34 -0700
Message-Id: <1308614377-18627-7-git-send-email-zamsden@redhat.com>
In-Reply-To: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
References: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redefine the API to take a parameter indicating whether an
adjustment is in host or guest cycles.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   13 ++++++++++++-
 arch/x86/kvm/svm.c              |    6 +++++-
 arch/x86/kvm/vmx.c              |    2 +-
 arch/x86/kvm/x86.c              |    2 +-
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3b9fdb5..c2854da 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -599,7 +599,7 @@ struct kvm_x86_ops {
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
-	void (*adjust_tsc_offset)(struct kvm_vcpu *vcpu, s64 adjustment);
+	void (*adjust_tsc_offset)(struct kvm_vcpu *vcpu, s64 adjustment, bool host);
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
@@ -630,6 +630,17 @@ struct kvm_arch_async_pf {
 
 extern struct kvm_x86_ops *kvm_x86_ops;
 
+static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
+					   s64 adjustment)
+{
+	kvm_x86_ops->adjust_tsc_offset(vcpu, adjustment, false);
+}
+
+static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
+{
+	kvm_x86_ops->adjust_tsc_offset(vcpu, adjustment, true);
+}
+
 int kvm_mmu_module_init(void);
 void kvm_mmu_module_exit(void);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 47f557e..dcab00e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -957,10 +957,14 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
-static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
+static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment, bool host)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	WARN_ON(adjustment < 0);
+	if (host)
+		adjustment = svm_scale_tsc(vcpu, adjustment);
+
 	svm->vmcb->control.tsc_offset += adjustment;
 	if (is_guest_mode(vcpu))
 		svm->nested.hsave->control.tsc_offset += adjustment;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bc3ecfd..780fe12 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1782,7 +1782,7 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 			to_vmx(vcpu)->nested.vmcs01_tsc_offset;
 }
 
-static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
+static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment, bool host)
 {
 	u64 offset = vmcs_read64(TSC_OFFSET);
 	vmcs_write64(TSC_OFFSET, offset + adjustment);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8fe988a..10950f7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1125,7 +1125,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	if (vcpu->tsc_catchup) {
 		u64 tsc = compute_guest_tsc(v, kernel_ns);
 		if (tsc > tsc_timestamp) {
-			kvm_x86_ops->adjust_tsc_offset(v, tsc - tsc_timestamp);
+			adjust_tsc_offset_guest(v, tsc - tsc_timestamp);
 			tsc_timestamp = tsc;
 		}
 	}
-- 
1.7.1

