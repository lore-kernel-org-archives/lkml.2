Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab2F1GLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:11:19 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51748 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab2F1GJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:09:57 -0400
X-AuditID: b753bd60-932c5ba0000047ca-f1-4febf4f2c8c0
X-AuditID: b753bd60-932c5ba0000047ca-f1-4febf4f2c8c0
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 16/18] KVM: add kvm_arch_vcpu_prevent_run to prevent VM
 ENTER when NMI is received
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:08:43 +0900
Message-ID: <20120628060842.19298.14653.stgit@localhost.localdomain>
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

 arch/x86/include/asm/kvm_host.h |    5 +++++
 arch/x86/kvm/vmx.c              |   22 +++++++++++++++++++++-
 arch/x86/kvm/x86.c              |   29 +++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6745057..3d5028f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -421,6 +421,8 @@ struct kvm_vcpu_arch {
 		void *insn;
 		int insn_len;
 	} page_fault;
+
+	bool prevent_run;
 #endif
 
 	int halt_request; /* real mode on Intel only */
@@ -668,6 +670,7 @@ struct kvm_x86_ops {
 
 	void (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu);
+	void (*prevent_run)(struct kvm_vcpu *vcpu, int prevent);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
@@ -999,4 +1002,6 @@ int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 void kvm_handle_pmu_event(struct kvm_vcpu *vcpu);
 void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
 
+int kvm_arch_vcpu_run_prevented(struct kvm_vcpu *vcpu);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2c987d1..4d0d547 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4349,7 +4349,7 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
-	/* Nothing */
+	kvm_arch_vcpu_run_prevented(vcpu);
 	return 1;
 }
 
@@ -5929,6 +5929,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	}
 
 	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
+		if (vcpu->arch.prevent_run)
+			return kvm_arch_vcpu_run_prevented(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason;
@@ -5936,6 +5938,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	}
 
 	if (unlikely(vmx->fail)) {
+		if (vcpu->arch.prevent_run)
+			return kvm_arch_vcpu_run_prevented(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
@@ -6337,6 +6341,21 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 #undef R
 #undef Q
 
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
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7220,6 +7239,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
+	.prevent_run = vmx_prevent_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e414a1..cae8025 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4961,6 +4961,13 @@ static void kvm_set_mmio_spte_mask(void)
 	kvm_mmu_set_mmio_spte_mask(mask);
 }
 
+static int kvm_arch_vcpu_prevent_run(struct kvm_vcpu *vcpu, int prevent)
+{
+	vcpu->arch.prevent_run = prevent;
+	kvm_x86_ops->prevent_run(vcpu, prevent);
+	return 1;
+}
+
 int kvm_arch_init(void *opaque)
 {
 	int r;
@@ -5337,6 +5344,11 @@ static int kvm_arch_kicked_by_nmi(unsigned int cmd, struct pt_regs *regs)
 	if (!vcpu || vcpu->mode == OUTSIDE_GUEST_MODE || kvm_is_in_guest())
 		return NMI_HANDLED;
 
+	/*
+	 * We may be about to entering VM. To prevent entering,
+	 * mark to exit as soon as possible.
+	 */
+	kvm_arch_vcpu_prevent_run(vcpu, 1);
 	return NMI_HANDLED;
 }
 
@@ -5573,6 +5585,14 @@ static void __vcpu_enter_guest_slave(void *_arg)
 	kvm_arch_vcpu_load(vcpu, cpu);
 
 	while (r == LOOP_SLAVE) {
+		/*
+		 * After setting slave_vcpu, the guest may be receive NMI when
+		 * the vCPU is kicked in kvm_vcpu_kick(). Receiving NMI, the
+		 * guest will exit with vcpu->arch.interrupted = true, then
+		 * we must go back to online CPUs. Even if we receive NMI
+		 * before entering to the guest, kvm_arch_vcpu_prevent_run()
+		 * will exit from the guest as soon as enter.
+		 */
 		__this_cpu_write(slave_vcpu, vcpu);
 		smp_wmb();
 		r = vcpu_enter_guest(vcpu, arg->task);
@@ -5607,6 +5627,7 @@ static void __vcpu_enter_guest_slave(void *_arg)
 		}
 	}
 
+	kvm_arch_vcpu_prevent_run(vcpu, 0);
 	kvm_arch_vcpu_put_migrate(vcpu);
 	unuse_mm(arg->task->mm);
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
@@ -6721,6 +6742,14 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
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


