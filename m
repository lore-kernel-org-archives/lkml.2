Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2BGRvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:51:14 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59582 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab2BGRvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:51:12 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Anthony Liguori <aliguori@us.ibm.com>, KVM <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Tue, 07 Feb 2012 23:19:20 +0530
Message-Id: <20120207174919.3848.99779.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH 1/1] kvm : vmx : Remove yield_on_hlt
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020717-7408-0000-0000-000002777612
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  yield_on_hlt was introduced for CPU bandwidth capping. now it is redundant
with CFS hardlimit.

yield_on_hlt also complicates the scenario in paravirtual environment, that
needs to trap halt. for e.g. paravirtualized ticket spinlocks.

Changelog:
Remove the support for yield_on_hlt.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d29216c..2fb3009 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -70,9 +70,6 @@ module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 static bool __read_mostly vmm_exclusive = 1;
 module_param(vmm_exclusive, bool, S_IRUGO);
 
-static bool __read_mostly yield_on_hlt = 1;
-module_param(yield_on_hlt, bool, S_IRUGO);
-
 static bool __read_mostly fasteoi = 1;
 module_param(fasteoi, bool, S_IRUGO);
 
@@ -1655,17 +1652,6 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	vmx_set_interrupt_shadow(vcpu, 0);
 }
 
-static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
-{
-	/* Ensure that we clear the HLT state in the VMCS.  We don't need to
-	 * explicitly skip the instruction because if the HLT state is set, then
-	 * the instruction is already executing and RIP has already been
-	 * advanced. */
-	if (!yield_on_hlt &&
-	    vmcs_read32(GUEST_ACTIVITY_STATE) == GUEST_ACTIVITY_HLT)
-		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
-}
-
 /*
  * KVM wants to inject page-faults which it got to the guest. This function
  * checks whether in a nested guest, we need to inject them to L1 or L2.
@@ -1718,7 +1704,6 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
-	vmx_clear_hlt(vcpu);
 }
 
 static bool vmx_rdtscp_supported(void)
@@ -2399,7 +2384,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 				&_pin_based_exec_control) < 0)
 		return -EIO;
 
-	min =
+	min = CPU_BASED_HLT_EXITING |
 #ifdef CONFIG_X86_64
 	      CPU_BASED_CR8_LOAD_EXITING |
 	      CPU_BASED_CR8_STORE_EXITING |
@@ -2414,9 +2399,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 	      CPU_BASED_INVLPG_EXITING |
 	      CPU_BASED_RDPMC_EXITING;
 
-	if (yield_on_hlt)
-		min |= CPU_BASED_HLT_EXITING;
-
 	opt = CPU_BASED_TPR_SHADOW |
 	      CPU_BASED_USE_MSR_BITMAPS |
 	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
@@ -4003,7 +3985,6 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 	} else
 		intr |= INTR_TYPE_EXT_INTR;
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr);
-	vmx_clear_hlt(vcpu);
 }
 
 static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
@@ -4035,7 +4016,6 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 	}
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
-	vmx_clear_hlt(vcpu);
 }
 
 static int vmx_nmi_allowed(struct kvm_vcpu *vcpu)

