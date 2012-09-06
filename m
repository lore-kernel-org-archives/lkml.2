Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2IFLbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:31:42 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59691 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab2IFLbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:31:38 -0400
X-AuditID: b753bd60-8f6bfba0000047ca-2e-504888e83cac
X-AuditID: b753bd60-8f6bfba0000047ca-2e-504888e83cac
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 14/21] KVM: Directly handle interrupts by guests
 without VM EXIT on slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:28:32 +0900
Message-ID: <20120906112832.13320.84430.stgit@kvmdev>
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

Make interrupts on slave CPUs handled by guests without VM EXIT.
This reduces CPU usage by the host to transfer interrupts of assigned
PCI devices from the host to guests. It also reduces cost of VM EXIT
and quickens response of guests to the interrupts.

When a slave CPU is dedicated to a vCPU, exit on external interrupts is
disabled. Unfortunately, we can only enable/disable exits for whole
external interrupts except NMIs and cannot switch exits based on IRQ#
or vectors. Thus, to avoid IPIs from online CPUs transferred to guests,
this patch modify kvm_vcpu_kick() to use NMI for guests on slave CPUs.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/lapic.c            |    5 +++++
 arch/x86/kvm/vmx.c              |   19 ++++++++++++++++++
 arch/x86/kvm/x86.c              |   41 +++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h        |    1 +
 virt/kvm/kvm_main.c             |    5 +++--
 6 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ce89f1..65242a6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -725,6 +725,7 @@ struct kvm_x86_ops {
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage);
 
+	void (*set_direct_interrupt)(struct kvm_vcpu *vcpu, bool enabled);
 	void (*set_slave_mode)(struct kvm_vcpu *vcpu, bool slave);
 };
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ce87878..73f57f3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -601,6 +601,9 @@ static int apic_set_eoi(struct kvm_lapic *apic)
 		kvm_ioapic_update_eoi(apic->vcpu->kvm, vector, trigger_mode);
 	}
 	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+	if (vcpu_has_slave_cpu(apic->vcpu) &&
+	    kvm_x86_ops->set_direct_interrupt)
+		kvm_x86_ops->set_direct_interrupt(apic->vcpu, 1);
 	return vector;
 }
 
@@ -1569,6 +1572,8 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data)
 	u64 addr = data & ~KVM_MSR_ENABLED;
 	if (!IS_ALIGNED(addr, 4))
 		return 1;
+	if (vcpu_has_slave_cpu(vcpu))
+		return 1;
 
 	vcpu->arch.pv_eoi.msr_val = data;
 	if (!pv_eoi_enabled(vcpu))
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 03a2d02..605abea 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1711,6 +1711,16 @@ static inline void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 #endif
 }
 
+static void vmx_set_direct_interrupt(struct kvm_vcpu *vcpu, bool enabled)
+{
+	if (enabled)
+		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
+				PIN_BASED_EXT_INTR_MASK);
+	else
+		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
+			      PIN_BASED_EXT_INTR_MASK);
+}
+
 static void vmx_set_slave_mode(struct kvm_vcpu *vcpu, bool slave)
 {
 	/* Don't intercept the guest's halt on slave CPU */
@@ -1721,6 +1731,8 @@ static void vmx_set_slave_mode(struct kvm_vcpu *vcpu, bool slave)
 		vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
 			      CPU_BASED_HLT_EXITING);
 	}
+
+	vmx_set_direct_interrupt(vcpu, slave);
 }
 
 /*
@@ -1776,6 +1788,8 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 	vmx_clear_hlt(vcpu);
+	if (vcpu_has_slave_cpu(vcpu))
+		vmx_set_direct_interrupt(vcpu, 0);
 }
 
 static bool vmx_rdtscp_supported(void)
@@ -4147,6 +4161,8 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 		intr |= INTR_TYPE_EXT_INTR;
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr);
 	vmx_clear_hlt(vcpu);
+	if (vcpu_has_slave_cpu(vcpu))
+		vmx_set_direct_interrupt(vcpu, 0);
 }
 
 static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
@@ -4179,6 +4195,8 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 	vmx_clear_hlt(vcpu);
+	if (vcpu_has_slave_cpu(vcpu))
+		vmx_set_direct_interrupt(vcpu, 0);
 }
 
 static int vmx_nmi_allowed(struct kvm_vcpu *vcpu)
@@ -7374,6 +7392,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.check_intercept = vmx_check_intercept,
 
+	.set_direct_interrupt = vmx_set_direct_interrupt,
 	.set_slave_mode = vmx_set_slave_mode,
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b2521..b7d28df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -63,6 +63,7 @@
 #include <asm/pvclock.h>
 #include <asm/div64.h>
 #include <asm/cpu.h>
+#include <asm/nmi.h>
 #include <asm/mmu.h>
 
 #define MAX_IO_MSRS 256
@@ -2664,6 +2665,8 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 /* vcpu currently running on each slave CPU */
 static DEFINE_PER_CPU(struct kvm_vcpu *, slave_vcpu);
 
+static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs);
+
 static int kvm_arch_vcpu_ioctl_set_slave_cpu(struct kvm_vcpu *vcpu,
 					     int slave, int set_slave_mode)
 {
@@ -5011,6 +5014,11 @@ int kvm_arch_init(void *opaque)
 	if (cpu_has_xsave)
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 
+#ifdef CONFIG_SLAVE_CPU
+	register_nmi_handler(NMI_LOCAL, kvm_arch_kicked_by_nmi, 0,
+			     "kvm_kick");
+#endif
+
 	return 0;
 
 out:
@@ -5026,6 +5034,9 @@ void kvm_arch_exit(void)
 					    CPUFREQ_TRANSITION_NOTIFIER);
 	unregister_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 	unregister_slave_cpu_notifier(&kvmclock_slave_cpu_notifier_block);
+#ifdef CONFIG_SLAVE_CPU
+	unregister_nmi_handler(NMI_LOCAL, "kvm_kick");
+#endif
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
 }
@@ -5322,6 +5333,27 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
+#ifdef CONFIG_SLAVE_CPU
+static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs)
+{
+	struct kvm_vcpu *vcpu;
+	int cpu = smp_processor_id();
+
+	if (!cpu_slave(cpu))
+		return NMI_DONE;
+
+	vcpu = __this_cpu_read(slave_vcpu);
+	if (!vcpu)
+		return NMI_DONE;
+
+	/* if called from NMI handler after VM exit, no need to prevent run */
+	if (vcpu->mode == OUTSIDE_GUEST_MODE || kvm_is_in_guest())
+		return NMI_HANDLED;
+
+	return NMI_HANDLED;
+}
+#endif
+
 enum vcpu_enter_guest_slave_retval {
 	EXIT_TO_USER = 0,
 	LOOP_ONLINE,		/* vcpu_post_run is done in online cpu */
@@ -6706,6 +6738,15 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
+int kvm_arch_vcpu_kick_slave(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_exiting_guest_mode(vcpu) != OUTSIDE_GUEST_MODE) {
+		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), NMI_VECTOR);
+		return 1;
+	}
+	return 0;
+}
+
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
 	return kvm_x86_ops->interrupt_allowed(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a60743f..5fd9c64 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -539,6 +539,7 @@ void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_kick_slave(struct kvm_vcpu *vcpu);
 
 void kvm_free_physmem(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index debbee1..858b7a9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1543,10 +1543,11 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	}
 
 	me = get_cpu();
-	if (cpu != me && (unsigned)cpu < nr_cpu_ids &&
-	    (cpu_online(cpu) || cpu_slave(cpu)))
+	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 		if (kvm_arch_vcpu_should_kick(vcpu))
 			smp_send_reschedule(cpu);
+	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_slave(cpu))
+		kvm_arch_vcpu_kick_slave(vcpu);
 	put_cpu();
 }
 #endif /* !CONFIG_S390 */


