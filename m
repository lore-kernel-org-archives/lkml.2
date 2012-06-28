Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab2F1GIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:08:36 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37443 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab2F1GId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:08:33 -0400
X-AuditID: 0ac90646-9aac7ba000003485-d1-4febf4d82243
X-AuditID: 0ac90646-9aac7ba000003485-d1-4febf4d82243
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 11/18] KVM: no exiting from guest when slave CPU halted
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:08:17 +0900
Message-ID: <20120628060817.19298.42651.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
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

 arch/x86/kvm/vmx.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e24392c..f0c6532 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1688,6 +1688,17 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	vmx_set_interrupt_shadow(vcpu, 0);
 }
 
+static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
+{
+	/* Ensure that we clear the HLT state in the VMCS.  We don't need to
+	 * explicitly skip the instruction because if the HLT state is set, then
+	 * the instruction is already executing and RIP has already been
+	 * advanced. */
+	if (vcpu->arch.slave_cpu >= 0 &&
+	    vmcs_read32(GUEST_ACTIVITY_STATE) == GUEST_ACTIVITY_HLT)
+		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
+}
+
 /*
  * KVM wants to inject page-faults which it got to the guest. This function
  * checks whether in a nested guest, we need to inject them to L1 or L2.
@@ -1740,6 +1751,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
+	vmx_clear_hlt(vcpu);
 }
 
 static bool vmx_rdtscp_supported(void)
@@ -4045,6 +4057,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 	} else
 		intr |= INTR_TYPE_EXT_INTR;
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr);
+	vmx_clear_hlt(vcpu);
 }
 
 static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
@@ -4076,6 +4089,7 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 	}
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
+	vmx_clear_hlt(vcpu);
 }
 
 static int vmx_nmi_allowed(struct kvm_vcpu *vcpu)
@@ -7137,7 +7151,13 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 
 static void vmx_set_slave_mode(struct kvm_vcpu *vcpu, bool slave)
 {
-	/* Nothing */
+	if (slave) {
+		vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
+				CPU_BASED_HLT_EXITING);
+	} else {
+		vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
+			      CPU_BASED_HLT_EXITING);
+	}
 }
 
 static struct kvm_x86_ops vmx_x86_ops = {


