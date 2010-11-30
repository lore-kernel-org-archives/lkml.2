Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0K3RFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:05:19 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:37703
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965Ab0K3RFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:05:12 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCPJEX-01-0WX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/6] KVM: SVM: Add manipulation functions for DRx intercepts
Date: Tue, 30 Nov 2010 18:03:58 +0100
Message-ID: <1291136641-4874-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wraps changes to the DRx intercepts of SVM into
seperate functions to abstract nested-svm better and prepare
the implementation of the vmcb-clean-bits feature.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/svm.h |   27 +++++++++-----
 arch/x86/kvm/svm.c         |   80 ++++++++++++++++++++++++--------------------
 2 files changed, 61 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 39f9ddf..11dbca7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -52,8 +52,7 @@ enum {
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercept_cr;
-	u16 intercept_dr_read;
-	u16 intercept_dr_write;
+	u32 intercept_dr;
 	u32 intercept_exceptions;
 	u64 intercept;
 	u8 reserved_1[42];
@@ -212,14 +211,22 @@ struct __attribute__ ((__packed__)) vmcb {
 #define INTERCEPT_CR4_WRITE	(16 + 4)
 #define INTERCEPT_CR8_WRITE	(16 + 8)
 
-#define INTERCEPT_DR0_MASK 1
-#define INTERCEPT_DR1_MASK (1 << 1)
-#define INTERCEPT_DR2_MASK (1 << 2)
-#define INTERCEPT_DR3_MASK (1 << 3)
-#define INTERCEPT_DR4_MASK (1 << 4)
-#define INTERCEPT_DR5_MASK (1 << 5)
-#define INTERCEPT_DR6_MASK (1 << 6)
-#define INTERCEPT_DR7_MASK (1 << 7)
+#define INTERCEPT_DR0_READ	0
+#define INTERCEPT_DR1_READ	1
+#define INTERCEPT_DR2_READ	2
+#define INTERCEPT_DR3_READ	3
+#define INTERCEPT_DR4_READ	4
+#define INTERCEPT_DR5_READ	5
+#define INTERCEPT_DR6_READ	6
+#define INTERCEPT_DR7_READ	7
+#define INTERCEPT_DR0_WRITE	(16 + 0)
+#define INTERCEPT_DR1_WRITE	(16 + 1)
+#define INTERCEPT_DR2_WRITE	(16 + 2)
+#define INTERCEPT_DR3_WRITE	(16 + 3)
+#define INTERCEPT_DR4_WRITE	(16 + 4)
+#define INTERCEPT_DR5_WRITE	(16 + 5)
+#define INTERCEPT_DR6_WRITE	(16 + 6)
+#define INTERCEPT_DR7_WRITE	(16 + 7)
 
 #define SVM_EVTINJ_VEC_MASK 0xff
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 53d24ea..5250a2b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -99,8 +99,7 @@ struct nested_state {
 
 	/* cache for intercepts of the guest */
 	u32 intercept_cr;
-	u16 intercept_dr_read;
-	u16 intercept_dr_write;
+	u32 intercept_dr;
 	u32 intercept_exceptions;
 	u64 intercept;
 
@@ -204,8 +203,7 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	g = &svm->nested;
 
 	c->intercept_cr = h->intercept_cr | g->intercept_cr;
-	c->intercept_dr_read = h->intercept_dr_read | g->intercept_dr_read;
-	c->intercept_dr_write = h->intercept_dr_write | g->intercept_dr_write;
+	c->intercept_dr = h->intercept_dr | g->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions | g->intercept_exceptions;
 	c->intercept = h->intercept | g->intercept;
 }
@@ -243,6 +241,24 @@ static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
 	return vmcb->control.intercept_cr & (1U << bit);
 }
 
+static inline void set_dr_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept_dr |= (1U << bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline void clr_dr_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept_dr &= ~(1U << bit);
+
+	recalc_intercepts(svm);
+}
+
 static inline void enable_gif(struct vcpu_svm *svm)
 {
 	svm->vcpu.arch.hflags |= HF_GIF_MASK;
@@ -806,23 +822,23 @@ static void init_vmcb(struct vcpu_svm *svm)
 	set_cr_intercept(svm, INTERCEPT_CR4_WRITE);
 	set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
 
-	control->intercept_dr_read =	INTERCEPT_DR0_MASK |
-					INTERCEPT_DR1_MASK |
-					INTERCEPT_DR2_MASK |
-					INTERCEPT_DR3_MASK |
-					INTERCEPT_DR4_MASK |
-					INTERCEPT_DR5_MASK |
-					INTERCEPT_DR6_MASK |
-					INTERCEPT_DR7_MASK;
-
-	control->intercept_dr_write =	INTERCEPT_DR0_MASK |
-					INTERCEPT_DR1_MASK |
-					INTERCEPT_DR2_MASK |
-					INTERCEPT_DR3_MASK |
-					INTERCEPT_DR4_MASK |
-					INTERCEPT_DR5_MASK |
-					INTERCEPT_DR6_MASK |
-					INTERCEPT_DR7_MASK;
+	set_dr_intercept(svm, INTERCEPT_DR0_READ);
+	set_dr_intercept(svm, INTERCEPT_DR1_READ);
+	set_dr_intercept(svm, INTERCEPT_DR2_READ);
+	set_dr_intercept(svm, INTERCEPT_DR3_READ);
+	set_dr_intercept(svm, INTERCEPT_DR4_READ);
+	set_dr_intercept(svm, INTERCEPT_DR5_READ);
+	set_dr_intercept(svm, INTERCEPT_DR6_READ);
+	set_dr_intercept(svm, INTERCEPT_DR7_READ);
+
+	set_dr_intercept(svm, INTERCEPT_DR0_WRITE);
+	set_dr_intercept(svm, INTERCEPT_DR1_WRITE);
+	set_dr_intercept(svm, INTERCEPT_DR2_WRITE);
+	set_dr_intercept(svm, INTERCEPT_DR3_WRITE);
+	set_dr_intercept(svm, INTERCEPT_DR4_WRITE);
+	set_dr_intercept(svm, INTERCEPT_DR5_WRITE);
+	set_dr_intercept(svm, INTERCEPT_DR6_WRITE);
+	set_dr_intercept(svm, INTERCEPT_DR7_WRITE);
 
 	control->intercept_exceptions = (1 << PF_VECTOR) |
 					(1 << UD_VECTOR) |
@@ -1921,15 +1937,9 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
-	case SVM_EXIT_READ_DR0 ... SVM_EXIT_READ_DR7: {
-		u32 dr_bits = 1 << (exit_code - SVM_EXIT_READ_DR0);
-		if (svm->nested.intercept_dr_read & dr_bits)
-			vmexit = NESTED_EXIT_DONE;
-		break;
-	}
-	case SVM_EXIT_WRITE_DR0 ... SVM_EXIT_WRITE_DR7: {
-		u32 dr_bits = 1 << (exit_code - SVM_EXIT_WRITE_DR0);
-		if (svm->nested.intercept_dr_write & dr_bits)
+	case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
+		u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
+		if (svm->nested.intercept_dr & bit)
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
@@ -1975,8 +1985,7 @@ static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *fr
 	struct vmcb_control_area *from = &from_vmcb->control;
 
 	dst->intercept_cr         = from->intercept_cr;
-	dst->intercept_dr_read    = from->intercept_dr_read;
-	dst->intercept_dr_write   = from->intercept_dr_write;
+	dst->intercept_dr         = from->intercept_dr;
 	dst->intercept_exceptions = from->intercept_exceptions;
 	dst->intercept            = from->intercept;
 	dst->iopm_base_pa         = from->iopm_base_pa;
@@ -2278,8 +2287,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	/* cache intercepts */
 	svm->nested.intercept_cr         = nested_vmcb->control.intercept_cr;
-	svm->nested.intercept_dr_read    = nested_vmcb->control.intercept_dr_read;
-	svm->nested.intercept_dr_write   = nested_vmcb->control.intercept_dr_write;
+	svm->nested.intercept_dr         = nested_vmcb->control.intercept_dr;
 	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
@@ -2904,8 +2912,8 @@ void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("VMCB Control Area:\n");
 	pr_err("cr_read:            %04x\n", control->intercept_cr & 0xffff);
 	pr_err("cr_write:           %04x\n", control->intercept_cr >> 16);
-	pr_err("dr_read:            %04x\n", control->intercept_dr_read);
-	pr_err("dr_write:           %04x\n", control->intercept_dr_write);
+	pr_err("dr_read:            %04x\n", control->intercept_dr & 0xffff);
+	pr_err("dr_write:           %04x\n", control->intercept_dr >> 16);
 	pr_err("exceptions:         %08x\n", control->intercept_exceptions);
 	pr_err("intercepts:         %016llx\n", control->intercept);
 	pr_err("pause filter count: %d\n", control->pause_filter_count);
-- 
1.7.1


