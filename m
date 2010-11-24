Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0KXSgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:36:15 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:12435
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab0KXSgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:36:14 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIUY-02-3OD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/9] KVM: Add infrastructure to emulate instruction intercepts
Date: Wed, 24 Nov 2010 19:18:27 +0100
Message-ID: <1290622715-8382-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary infrastructure to KVM to
implement instruction intercepts when the vcpu in in
emulated guest mode.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_emulate.h |    2 ++
 arch/x86/include/asm/kvm_host.h    |    3 +++
 arch/x86/kvm/svm.c                 |    8 ++++++++
 arch/x86/kvm/vmx.c                 |    8 ++++++++
 arch/x86/kvm/x86.c                 |    5 +++++
 5 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index b48c133..3498431 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -54,6 +54,8 @@ struct x86_emulate_ctxt;
 #define X86EMUL_RETRY_INSTR     3 /* retry the instruction for some reason */
 #define X86EMUL_CMPXCHG_FAILED  4 /* cmpxchg did not see expected value */
 #define X86EMUL_IO_NEEDED       5 /* IO is needed to complete emulation */
+#define X86EMUL_INTERCEPTED     6 /* VCPU is in guest mode and the
+				     instruction is intercepted */
 
 struct x86_emulate_ops {
 	/*
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 54e42c8..bcc781b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -596,6 +596,9 @@ struct kvm_x86_ops {
 
 	void (*get_exit_info)(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2);
 	const struct trace_print_flags *exit_reasons_str;
+
+	int (*insn_intercepted)(struct kvm_vcpu *vcpu,
+				struct x86_emulate_ctxt *ctxt);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2fd2f4d..d1721c2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3619,6 +3619,12 @@ static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 	update_cr0_intercept(svm);
 }
 
+static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
+				struct x86_emulate_ctxt *ctxt)
+{
+	return X86EMUL_CONTINUE;
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -3703,6 +3709,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.adjust_tsc_offset = svm_adjust_tsc_offset,
 
 	.set_tdp_cr3 = set_tdp_cr3,
+
+	.insn_intercepted = svm_insn_intercepted,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index caa967e..81de3a9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4278,6 +4278,12 @@ static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 }
 
+static int vmx_insn_intercepted(struct kvm_vcpu *vcpu,
+				struct x86_emulate_ctxt *ctxt)
+{
+	return X86EMUL_CONTINUE;
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -4362,6 +4368,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.adjust_tsc_offset = vmx_adjust_tsc_offset,
 
 	.set_tdp_cr3 = vmx_set_cr3,
+
+	.insn_intercepted = vmx_insn_intercepted,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 410d2d1..759cc19 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4383,6 +4383,11 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		if (r == X86EMUL_PROPAGATE_FAULT)
 			goto done;
 
+		r = kvm_x86_ops->insn_intercepted(vcpu,
+						  &vcpu->arch.emulate_ctxt);
+		if (r == X86EMUL_INTERCEPTED)
+			return EMULATE_DONE;
+
 		trace_kvm_emulate_insn_start(vcpu);
 
 		/* Only allow emulation of specific instructions on #UD
-- 
1.7.1


