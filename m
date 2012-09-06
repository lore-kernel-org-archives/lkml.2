Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2IFLcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:32:54 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59866 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2IFLcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:32:47 -0400
X-AuditID: b753bd60-91ec3ba0000047ca-e2-504888da0c75
X-AuditID: b753bd60-91ec3ba0000047ca-e2-504888da0c75
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 11/21] KVM: no exiting from guest when slave CPU halted
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:28:16 +0900
Message-ID: <20120906112816.13320.71132.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid exiting from a guest on slave CPU even if HLT instruction is
executed. Since the slave CPU is dedicated to a vCPU, exit on HLT is
not required, and avoiding VM exit will improve the guest's performance.

This is a partial revert of

        10166744b80a ("KVM: VMX: remove yield_on_hlt")

Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kvm/vmx.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d99bee6..03a2d02 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1698,9 +1698,29 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	vmx_set_interrupt_shadow(vcpu, 0);
 }
 
+static inline void vmx_clear_hlt(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_SLAVE_CPU
+	/* Ensure that we clear the HLT state in the VMCS.  We don't need to
+	 * explicitly skip the instruction because if the HLT state is set,
+	 * then the instruction is already executing and RIP has already been
+	 * advanced. */
+	if (vcpu->arch.slave_cpu >= 0 &&
+	    vmcs_read32(GUEST_ACTIVITY_STATE) == GUEST_ACTIVITY_HLT)
+		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
+#endif
+}
+
 static void vmx_set_slave_mode(struct kvm_vcpu *vcpu, bool slave)
 {
-	/* Nothing */
+	/* Don't intercept the guest's halt on slave CPU */
+	if (slave) {
+		vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
+				CPU_BASED_HLT_EXITING);
+	} else {
+		vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
+			      CPU_BASED_HLT_EXITING);
+	}
 }
 
 /*
@@ -1755,6 +1775,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
+	vmx_clear_hlt(vcpu);
 }
 
 static bool vmx_rdtscp_supported(void)
@@ -4125,6 +4146,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 	} else
 		intr |= INTR_TYPE_EXT_INTR;
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr);
+	vmx_clear_hlt(vcpu);
 }
 
 static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
@@ -4156,6 +4178,7 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 	}
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
+	vmx_clear_hlt(vcpu);
 }
 
 static int vmx_nmi_allowed(struct kvm_vcpu *vcpu)


