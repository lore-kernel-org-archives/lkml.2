Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab0LCKtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:49:05 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:38838
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757614Ab0LCKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:22 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULWZ-01-H08-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/12] KVM: SVM: Add clean-bits infrastructure code
Date: Fri, 3 Dec 2010 11:45:48 +0100
Message-ID: <1291373159-4822-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the infrastructure for the implementation of
the individual clean-bits.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/svm.h |    6 +++++-
 arch/x86/kvm/svm.c         |   31 +++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 11dbca7..d786399 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -49,6 +49,9 @@ enum {
 	INTERCEPT_MWAIT_COND,
 };
 
+enum {
+	VMCB_CLEAN_MAX,
+};
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercept_cr;
@@ -79,7 +82,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj_err;
 	u64 nested_cr3;
 	u64 lbr_ctl;
-	u64 reserved_5;
+	u32 clean;
+	u32 reserved_5;
 	u64 next_rip;
 	u8 reserved_6[816];
 };
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c00ea90..3ee59b0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -185,6 +185,28 @@ static int nested_svm_vmexit(struct vcpu_svm *svm);
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code);
 
+enum {
+	VMCB_DIRTY_MAX,
+};
+
+#define VMCB_ALWAYS_DIRTY_MASK	0U
+
+static inline void mark_all_dirty(struct vmcb *vmcb)
+{
+	vmcb->control.clean = 0;
+}
+
+static inline void mark_all_clean(struct vmcb *vmcb)
+{
+	vmcb->control.clean = ((1 << VMCB_DIRTY_MAX) - 1)
+			       & ~VMCB_ALWAYS_DIRTY_MASK;
+}
+
+static inline void mark_dirty(struct vmcb *vmcb, int bit)
+{
+	vmcb->control.clean &= ~(1 << bit);
+}
+
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
@@ -973,6 +995,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		set_intercept(svm, INTERCEPT_PAUSE);
 	}
 
+	mark_all_dirty(svm->vmcb);
+
 	enable_gif(svm);
 }
 
@@ -1089,6 +1113,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	if (unlikely(cpu != vcpu->cpu)) {
 		svm->asid_generation = 0;
+		mark_all_dirty(svm->vmcb);
 	}
 
 #ifdef CONFIG_X86_64
@@ -2139,6 +2164,8 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
+	mark_all_dirty(svm->vmcb);
+
 	nested_svm_unmap(page);
 
 	nested_svm_uninit_mmu_context(&svm->vcpu);
@@ -2350,6 +2377,8 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	enable_gif(svm);
 
+	mark_all_dirty(svm->vmcb);
+
 	return true;
 }
 
@@ -3487,6 +3516,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vmcb->control.exit_code ==
 		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
 		svm_handle_mce(svm);
+
+	mark_all_clean(svm->vmcb);
 }
 
 #undef R
-- 
1.7.1


