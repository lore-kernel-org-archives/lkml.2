Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2F1GKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:10:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51747 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab2F1GJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:09:57 -0400
X-AuditID: b753bd60-a0885ba000000655-b4-4febf4e89d7e
X-AuditID: b753bd60-a0885ba000000655-b4-4febf4e89d7e
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 14/18] KVM: Directly handle interrupts by guests without
 VM EXIT on slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:08:32 +0900
Message-ID: <20120628060832.19298.38753.stgit@localhost.localdomain>
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

 arch/x86/kvm/vmx.c       |    4 ++++
 arch/x86/kvm/x86.c       |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    5 +++--
 4 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f0c6532..3aea448 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7154,9 +7154,13 @@ static void vmx_set_slave_mode(struct kvm_vcpu *vcpu, bool slave)
 	if (slave) {
 		vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
 				CPU_BASED_HLT_EXITING);
+		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
+				PIN_BASED_EXT_INTR_MASK);
 	} else {
 		vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
 			      CPU_BASED_HLT_EXITING);
+		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
+			      PIN_BASED_EXT_INTR_MASK);
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df5eb05..2e414a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -63,6 +63,7 @@
 #include <asm/pvclock.h>
 #include <asm/div64.h>
 #include <asm/cpu.h>
+#include <asm/nmi.h>
 #include <asm/mmu.h>
 
 #define MAX_IO_MSRS 256
@@ -2635,6 +2636,8 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_SLAVE_CPU
 
+static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs);
+
 static int kvm_arch_vcpu_ioctl_set_slave_cpu(struct kvm_vcpu *vcpu,
 					     int slave, int set_slave_mode)
 {
@@ -4998,6 +5001,11 @@ int kvm_arch_init(void *opaque)
 	if (cpu_has_xsave)
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 
+#ifdef CONFIG_SLAVE_CPU
+	register_nmi_handler(NMI_LOCAL, kvm_arch_kicked_by_nmi, 0,
+			     "kvm_kick");
+#endif
+
 	return 0;
 
 out:
@@ -5014,6 +5022,7 @@ void kvm_arch_exit(void)
 	unregister_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 #ifdef CONFIG_SLAVE_CPU
 	unregister_slave_cpu_notifier(&kvmclock_slave_cpu_notifier_block);
+	unregister_nmi_handler(NMI_LOCAL, "kvm_kick");
 #endif
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
@@ -5311,6 +5320,28 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
+#ifdef CONFIG_SLAVE_CPU
+/* vcpu currently running on each slave CPU */
+static DEFINE_PER_CPU(struct kvm_vcpu *, slave_vcpu);
+
+static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs)
+{
+	struct kvm_vcpu *vcpu;
+	int cpu = smp_processor_id();
+
+	if (!cpu_slave(cpu))
+		return NMI_DONE;
+
+	/* if called from NMI handler after VM exit, no need to prevent run */
+	vcpu = __this_cpu_read(slave_vcpu);
+	if (!vcpu || vcpu->mode == OUTSIDE_GUEST_MODE || kvm_is_in_guest())
+		return NMI_HANDLED;
+
+	return NMI_HANDLED;
+}
+
+#endif
+
 enum vcpu_enter_guest_slave_retval {
 	EXIT_TO_USER = 0,
 	LOOP_ONLINE,		/* vcpu_post_run is done in online cpu */
@@ -5542,7 +5573,10 @@ static void __vcpu_enter_guest_slave(void *_arg)
 	kvm_arch_vcpu_load(vcpu, cpu);
 
 	while (r == LOOP_SLAVE) {
+		__this_cpu_write(slave_vcpu, vcpu);
+		smp_wmb();
 		r = vcpu_enter_guest(vcpu, arg->task);
+		__this_cpu_write(slave_vcpu, NULL);
 
 		if (unlikely(!irqs_disabled())) {
 			pr_err("irq is enabled on slave vcpu_etner_guest! - forcely disable\n");
@@ -6692,6 +6726,12 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
+void kvm_arch_vcpu_kick_slave(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE)
+		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), NMI_VECTOR);
+}
+
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
 	return kvm_x86_ops->interrupt_allowed(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c44a7be..9906908 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -533,6 +533,7 @@ void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_kick_slave(struct kvm_vcpu *vcpu);
 
 void kvm_free_physmem(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff8b418..6a989e9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1531,10 +1531,11 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
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


