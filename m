Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0K3RFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:05:39 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:55478
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755069Ab0K3RFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:05:34 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCPJEY-01-0X4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/6] KVM: SVM: Add manipulation functions for misc intercepts
Date: Tue, 30 Nov 2010 18:04:00 +0100
Message-ID: <1291136641-4874-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wraps changes to the misc intercepts of SVM
into seperate functions to abstract nested-svm better and
prepare the implementation of the vmcb-clean-bits feature.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   84 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 783142e..6b51d31 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -277,6 +277,24 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
+static inline void set_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept |= (1ULL << bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline void clr_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept &= ~(1ULL << bit);
+
+	recalc_intercepts(svm);
+}
+
 static inline void enable_gif(struct vcpu_svm *svm)
 {
 	svm->vcpu.arch.hflags |= HF_GIF_MASK;
@@ -862,29 +880,29 @@ static void init_vmcb(struct vcpu_svm *svm)
 	set_exception_intercept(svm, UD_VECTOR);
 	set_exception_intercept(svm, MC_VECTOR);
 
-	control->intercept =	(1ULL << INTERCEPT_INTR) |
-				(1ULL << INTERCEPT_NMI) |
-				(1ULL << INTERCEPT_SMI) |
-				(1ULL << INTERCEPT_SELECTIVE_CR0) |
-				(1ULL << INTERCEPT_CPUID) |
-				(1ULL << INTERCEPT_INVD) |
-				(1ULL << INTERCEPT_HLT) |
-				(1ULL << INTERCEPT_INVLPG) |
-				(1ULL << INTERCEPT_INVLPGA) |
-				(1ULL << INTERCEPT_IOIO_PROT) |
-				(1ULL << INTERCEPT_MSR_PROT) |
-				(1ULL << INTERCEPT_TASK_SWITCH) |
-				(1ULL << INTERCEPT_SHUTDOWN) |
-				(1ULL << INTERCEPT_VMRUN) |
-				(1ULL << INTERCEPT_VMMCALL) |
-				(1ULL << INTERCEPT_VMLOAD) |
-				(1ULL << INTERCEPT_VMSAVE) |
-				(1ULL << INTERCEPT_STGI) |
-				(1ULL << INTERCEPT_CLGI) |
-				(1ULL << INTERCEPT_SKINIT) |
-				(1ULL << INTERCEPT_WBINVD) |
-				(1ULL << INTERCEPT_MONITOR) |
-				(1ULL << INTERCEPT_MWAIT);
+	set_intercept(svm, INTERCEPT_INTR);
+	set_intercept(svm, INTERCEPT_NMI);
+	set_intercept(svm, INTERCEPT_SMI);
+	set_intercept(svm, INTERCEPT_SELECTIVE_CR0);
+	set_intercept(svm, INTERCEPT_CPUID);
+	set_intercept(svm, INTERCEPT_INVD);
+	set_intercept(svm, INTERCEPT_HLT);
+	set_intercept(svm, INTERCEPT_INVLPG);
+	set_intercept(svm, INTERCEPT_INVLPGA);
+	set_intercept(svm, INTERCEPT_IOIO_PROT);
+	set_intercept(svm, INTERCEPT_MSR_PROT);
+	set_intercept(svm, INTERCEPT_TASK_SWITCH);
+	set_intercept(svm, INTERCEPT_SHUTDOWN);
+	set_intercept(svm, INTERCEPT_VMRUN);
+	set_intercept(svm, INTERCEPT_VMMCALL);
+	set_intercept(svm, INTERCEPT_VMLOAD);
+	set_intercept(svm, INTERCEPT_VMSAVE);
+	set_intercept(svm, INTERCEPT_STGI);
+	set_intercept(svm, INTERCEPT_CLGI);
+	set_intercept(svm, INTERCEPT_SKINIT);
+	set_intercept(svm, INTERCEPT_WBINVD);
+	set_intercept(svm, INTERCEPT_MONITOR);
+	set_intercept(svm, INTERCEPT_MWAIT);
 
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __pa(svm->msrpm);
@@ -935,8 +953,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl = 1;
-		control->intercept &= ~((1ULL << INTERCEPT_TASK_SWITCH) |
-					(1ULL << INTERCEPT_INVLPG));
+		clr_intercept(svm, INTERCEPT_TASK_SWITCH);
+		clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, PF_VECTOR);
 		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
 		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
@@ -951,7 +969,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	if (boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		control->pause_filter_count = 3000;
-		control->intercept |= (1ULL << INTERCEPT_PAUSE);
+		set_intercept(svm, INTERCEPT_PAUSE);
 	}
 
 	enable_gif(svm);
@@ -1125,12 +1143,12 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 
 static void svm_set_vintr(struct vcpu_svm *svm)
 {
-	svm->vmcb->control.intercept |= 1ULL << INTERCEPT_VINTR;
+	set_intercept(svm, INTERCEPT_VINTR);
 }
 
 static void svm_clear_vintr(struct vcpu_svm *svm)
 {
-	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
+	clr_intercept(svm, INTERCEPT_VINTR);
 }
 
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
@@ -2307,7 +2325,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	}
 
 	/* We don't want to see VMMCALLs from a nested guest */
-	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMMCALL);
+	clr_intercept(svm, INTERCEPT_VMMCALL);
 
 	svm->vmcb->control.lbr_ctl = nested_vmcb->control.lbr_ctl;
 	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
@@ -2555,7 +2573,7 @@ static int cpuid_interception(struct vcpu_svm *svm)
 static int iret_interception(struct vcpu_svm *svm)
 {
 	++svm->vcpu.stat.nmi_window_exits;
-	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_IRET);
+	clr_intercept(svm, INTERCEPT_IRET);
 	svm->vcpu.arch.hflags |= HF_IRET_MASK;
 	return 1;
 }
@@ -3101,7 +3119,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
-	svm->vmcb->control.intercept |= (1ULL << INTERCEPT_IRET);
+	set_intercept(svm, INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3168,10 +3186,10 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
 	if (masked) {
 		svm->vcpu.arch.hflags |= HF_NMI_MASK;
-		svm->vmcb->control.intercept |= (1ULL << INTERCEPT_IRET);
+		set_intercept(svm, INTERCEPT_IRET);
 	} else {
 		svm->vcpu.arch.hflags &= ~HF_NMI_MASK;
-		svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_IRET);
+		clr_intercept(svm, INTERCEPT_IRET);
 	}
 }
 
-- 
1.7.1


