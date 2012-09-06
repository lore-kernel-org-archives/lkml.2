Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2IFLcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:32:13 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59855 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2IFLcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:32:10 -0400
X-AuditID: b753bd60-900c0ba0000047ca-8e-504888f71f06
X-AuditID: b753bd60-900c0ba0000047ca-8e-504888f71f06
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 17/21] KVM: add kvm_arch_vcpu_prevent_run to prevent VM
 ENTER when NMI is received
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:28:48 +0900
Message-ID: <20120906112848.13320.90106.stgit@kvmdev>
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

Since NMI can not be disabled around VM enter, there is a race between
receiving NMI to kick a guest and entering the guests on slave CPUs.If the
NMI is received just before entering VM, after the NMI handler is invoked,
it continues entering the guest and the effect of the NMI will be lost.

This patch adds kvm_arch_vcpu_prevent_run(), which causes VM exit right
after VM enter. The NMI handler uses this to ensure the execution of the
guest is cancelled after NMI.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/kvm_host.h |    6 ++++++
 arch/x86/kvm/vmx.c              |   42 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |   31 +++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 65242a6..624e5ad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -429,6 +429,9 @@ struct kvm_vcpu_arch {
 		void *insn;
 		int insn_len;
 	} page_fault;
+
+	bool prevent_run;
+	bool prevent_needed;
 #endif
 
 	int halt_request; /* real mode on Intel only */
@@ -681,6 +684,7 @@ struct kvm_x86_ops {
 
 	void (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu);
+	void (*prevent_run)(struct kvm_vcpu *vcpu, int prevent);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
@@ -1027,4 +1031,6 @@ int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 void kvm_handle_pmu_event(struct kvm_vcpu *vcpu);
 void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
 
+int kvm_arch_vcpu_run_prevented(struct kvm_vcpu *vcpu);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2130cbd..39a4cb4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1713,6 +1713,9 @@ static inline void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 
 static void vmx_set_direct_interrupt(struct kvm_vcpu *vcpu, bool enabled)
 {
+#ifdef CONFIG_SLAVE_CPU
+	void *msr_bitmap;
+
 	if (enabled)
 		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
 				PIN_BASED_EXT_INTR_MASK);
@@ -1721,6 +1724,7 @@ static void vmx_set_direct_interrupt(struct kvm_vcpu *vcpu, bool enabled)
 			      PIN_BASED_EXT_INTR_MASK);
 
 	trace_kvm_set_direct_interrupt(vcpu, enabled);
+#endif
 }
 
 static void vmx_set_slave_mode(struct kvm_vcpu *vcpu, bool slave)
@@ -4458,7 +4462,7 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
-	/* Nothing */
+	kvm_arch_vcpu_run_prevented(vcpu);
 	return 1;
 }
 
@@ -6052,6 +6056,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	}
 
 	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
+#ifdef CONFIG_SLAVE_CPU
+		if (vcpu->arch.prevent_run)
+			return kvm_arch_vcpu_run_prevented(vcpu);
+#endif
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason;
@@ -6059,6 +6067,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	}
 
 	if (unlikely(vmx->fail)) {
+#ifdef CONFIG_SLAVE_CPU
+		if (vcpu->arch.prevent_run)
+			return kvm_arch_vcpu_run_prevented(vcpu);
+#endif
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
@@ -6275,6 +6287,21 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host);
 }
 
+/*
+ * Make VMRESUME fail using preemption timer with timer value = 0.
+ * On processors that doesn't support preemption timer, VMRESUME will fail
+ * by internal error.
+ */
+static void vmx_prevent_run(struct kvm_vcpu *vcpu, int prevent)
+{
+	if (prevent)
+		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
+			      PIN_BASED_PREEMPTION_TIMER);
+	else
+		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
+				PIN_BASED_PREEMPTION_TIMER);
+}
+
 #ifdef CONFIG_X86_64
 #define R "r"
 #define Q "q"
@@ -6326,6 +6353,13 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	atomic_switch_perf_msrs(vmx);
 
+#ifdef CONFIG_SLAVE_CPU
+	barrier();	/* Avoid vmcs modification by NMI before here */
+	vcpu->arch.prevent_needed = 1;
+	if (vcpu->arch.prevent_run)
+		vmx_prevent_run(vcpu, 1);
+#endif
+
 	vmx->__launched = vmx->loaded_vmcs->launched;
 	asm(
 		/* Store host registers */
@@ -6439,6 +6473,11 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	loadsegment(es, __USER_DS);
 #endif
 
+#ifdef CONFIG_SLAVE_CPU
+	vcpu->arch.prevent_needed = 0;
+	barrier();	/* Avoid vmcs modification by NMI after here */
+#endif
+
 	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
 				  | (1 << VCPU_EXREG_RFLAGS)
 				  | (1 << VCPU_EXREG_CPL)
@@ -7358,6 +7397,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
+	.prevent_run = vmx_prevent_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1449187..eb2e5c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2667,6 +2667,19 @@ static DEFINE_PER_CPU(struct kvm_vcpu *, slave_vcpu);
 
 static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs);
 
+struct kvm_vcpu *get_slave_vcpu(int cpu)
+{
+	return per_cpu(slave_vcpu, cpu);
+}
+
+static int kvm_arch_vcpu_prevent_run(struct kvm_vcpu *vcpu, int prevent)
+{
+	vcpu->arch.prevent_run = prevent;
+	if (!prevent || vcpu->arch.prevent_needed)
+		kvm_x86_ops->prevent_run(vcpu, prevent);
+	return 1;
+}
+
 static int kvm_arch_vcpu_ioctl_set_slave_cpu(struct kvm_vcpu *vcpu,
 					     int slave, int set_slave_mode)
 {
@@ -4873,10 +4886,12 @@ static struct notifier_block kvmclock_cpu_notifier_block = {
 	.priority = -INT_MAX
 };
 
+#ifdef CONFIG_SLAVE_CPU
 static struct notifier_block kvmclock_slave_cpu_notifier_block = {
 	.notifier_call  = kvmclock_cpu_notifier,
 	.priority = -INT_MAX
 };
+#endif
 
 static void kvm_timer_init(void)
 {
@@ -5350,6 +5365,11 @@ static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs)
 	if (vcpu->mode == OUTSIDE_GUEST_MODE || kvm_is_in_guest())
 		return NMI_HANDLED;
 
+	/*
+	 * We may be about to entering VM. To prevent entering,
+	 * mark to exit as soon as possible.
+	 */
+	kvm_arch_vcpu_prevent_run(vcpu, 1);
 	return NMI_HANDLED;
 }
 #endif
@@ -5592,6 +5612,8 @@ static void __vcpu_enter_guest_slave(void *_arg)
 	kvm_arch_vcpu_load(vcpu, cpu);
 
 	while (r == LOOP_SLAVE) {
+		vcpu->arch.prevent_run = 0;
+
 		r = vcpu_enter_guest(vcpu, arg->task);
 
 		if (r <= 0)
@@ -5618,6 +5640,7 @@ static void __vcpu_enter_guest_slave(void *_arg)
 		}
 	}
 
+	kvm_arch_vcpu_prevent_run(vcpu, 0);
 	kvm_arch_vcpu_put_migrate(vcpu);
 	unuse_mm(arg->task->mm);
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
@@ -6733,6 +6756,14 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 		 kvm_cpu_has_interrupt(vcpu));
 }
 
+int kvm_arch_vcpu_run_prevented(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops->prevent_run(vcpu, 0);
+	vcpu->arch.interrupted = true;
+	return 1;
+}
+EXPORT_SYMBOL_GPL(kvm_arch_vcpu_run_prevented);
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;


