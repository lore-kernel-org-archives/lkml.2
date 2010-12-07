Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0LGQPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:15:46 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:58492
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753996Ab0LGQPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:15:42 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zzbb2cK14ffOzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LD2FTY-01-XMV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Add xsetbv intercept
Date: Tue, 7 Dec 2010 17:15:06 +0100
Message-ID: <1291738506-16278-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101207161211.GD13125@amd.com>
References: <20101207161211.GD13125@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the xsetbv intercept to the AMD part
of KVM. This makes AVX usable in a save way for the guest on
AVX capable AMD hardware.
The patch is tested by using AVX in the guest and host in
parallel and checking for data corruption. I also used the
KVM xsave unit-tests and they all pass.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/svm.h |    2 ++
 arch/x86/kvm/svm.c         |   20 ++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 11dbca7..7f3a304 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -47,6 +47,7 @@ enum {
 	INTERCEPT_MONITOR,
 	INTERCEPT_MWAIT,
 	INTERCEPT_MWAIT_COND,
+	INTERCEPT_XSETBV,
 };
 
 
@@ -326,6 +327,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXIT_MONITOR	0x08a
 #define SVM_EXIT_MWAIT		0x08b
 #define SVM_EXIT_MWAIT_COND	0x08c
+#define SVM_EXIT_XSETBV		0x08d
 #define SVM_EXIT_NPF  		0x400
 
 #define SVM_EXIT_ERR		-1
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8aeda9f..4a5e584 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -904,6 +904,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	set_intercept(svm, INTERCEPT_WBINVD);
 	set_intercept(svm, INTERCEPT_MONITOR);
 	set_intercept(svm, INTERCEPT_MWAIT);
+	set_intercept(svm, INTERCEPT_XSETBV);
 
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __pa(svm->msrpm);
@@ -2494,6 +2495,19 @@ static int skinit_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int xsetbv_interception(struct vcpu_svm *svm)
+{
+	u64 new_bv = kvm_read_edx_eax(&svm->vcpu);
+	u32 index = kvm_register_read(&svm->vcpu, VCPU_REGS_RCX);
+
+	if (kvm_set_xcr(&svm->vcpu, index, new_bv) == 0) {
+		svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
+		skip_emulated_instruction(&svm->vcpu);
+	}
+
+	return 1;
+}
+
 static int invalid_op_interception(struct vcpu_svm *svm)
 {
 	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
@@ -2917,6 +2931,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
+	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_NPF]				= pf_interception,
 };
 
@@ -3556,10 +3571,6 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	switch (func) {
-	case 0x00000001:
-		/* Mask out xsave bit as long as it is not supported by SVM */
-		entry->ecx &= ~(bit(X86_FEATURE_XSAVE));
-		break;
 	case 0x80000001:
 		if (nested)
 			entry->ecx |= (1 << 2); /* Set SVM bit */
@@ -3633,6 +3644,7 @@ static const struct trace_print_flags svm_exit_reasons_str[] = {
 	{ SVM_EXIT_WBINVD,			"wbinvd" },
 	{ SVM_EXIT_MONITOR,			"monitor" },
 	{ SVM_EXIT_MWAIT,			"mwait" },
+	{ SVM_EXIT_XSETBV,			"xsetbv" },
 	{ SVM_EXIT_NPF,				"npf" },
 	{ -1, NULL }
 };
-- 
1.7.1


