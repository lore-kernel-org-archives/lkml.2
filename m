Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2IVATi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 20:19:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2IVATf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 20:19:35 -0400
Date: Fri, 21 Sep 2012 17:19:21 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-b1a74bf8212367be2b1d6685c11a84e056eaaaf1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        avi@redhat.com
In-Reply-To: <1348164109.26695.338.camel@sbsiddha-desk.sc.intel.com>
References: <1348164109.26695.338.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, kvm: fix kvm's usage of kernel_fpu_begin/end()
Git-Commit-ID: b1a74bf8212367be2b1d6685c11a84e056eaaaf1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 17:19:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1a74bf8212367be2b1d6685c11a84e056eaaaf1
Gitweb:     http://git.kernel.org/tip/b1a74bf8212367be2b1d6685c11a84e056eaaaf1
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 20 Sep 2012 11:01:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 16:59:04 -0700

x86, kvm: fix kvm's usage of kernel_fpu_begin/end()

Preemption is disabled between kernel_fpu_begin/end() and as such
it is not a good idea to use these routines in kvm_load/put_guest_fpu()
which can be very far apart.

kvm_load/put_guest_fpu() routines are already called with
preemption disabled and KVM already uses the preempt notifier to save
the guest fpu state using kvm_put_guest_fpu().

So introduce __kernel_fpu_begin/end() routines which don't touch
preemption and use them instead of kernel_fpu_begin/end()
for KVM's use model of saving/restoring guest FPU state.

Also with this change (and with eagerFPU model), fix the host cr0.TS vm-exit
state in the case of VMX. For eagerFPU case, host cr0.TS is always clear.
So no need to worry about it. For the traditional lazyFPU restore case,
change the cr0.TS bit for the host state during vm-exit to be always clear
and cr0.TS bit is set in the __vmx_load_host_state() when the FPU
(guest FPU or the host task's FPU) state is not active. This ensures
that the host/guest FPU state is properly saved, restored
during context-switch and with interrupts (using irq_fpu_usable()) not
stomping on the active FPU state.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1348164109.26695.338.camel@sbsiddha-desk.sc.intel.com
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h |   28 ++++++++++++++++++++++++++--
 arch/x86/kernel/i387.c      |   13 +++++--------
 arch/x86/kvm/vmx.c          |   10 +++++++---
 arch/x86/kvm/x86.c          |    4 ++--
 4 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 6c3bd37..ed8089d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -24,8 +24,32 @@ extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 extern void math_state_restore(void);
 
 extern bool irq_fpu_usable(void);
-extern void kernel_fpu_begin(void);
-extern void kernel_fpu_end(void);
+
+/*
+ * Careful: __kernel_fpu_begin/end() must be called with preempt disabled
+ * and they don't touch the preempt state on their own.
+ * If you enable preemption after __kernel_fpu_begin(), preempt notifier
+ * should call the __kernel_fpu_end() to prevent the kernel/user FPU
+ * state from getting corrupted. KVM for example uses this model.
+ *
+ * All other cases use kernel_fpu_begin/end() which disable preemption
+ * during kernel FPU usage.
+ */
+extern void __kernel_fpu_begin(void);
+extern void __kernel_fpu_end(void);
+
+static inline void kernel_fpu_begin(void)
+{
+	WARN_ON_ONCE(!irq_fpu_usable());
+	preempt_disable();
+	__kernel_fpu_begin();
+}
+
+static inline void kernel_fpu_end(void)
+{
+	__kernel_fpu_end();
+	preempt_enable();
+}
 
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 6782e39..675a050 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -73,32 +73,29 @@ bool irq_fpu_usable(void)
 }
 EXPORT_SYMBOL(irq_fpu_usable);
 
-void kernel_fpu_begin(void)
+void __kernel_fpu_begin(void)
 {
 	struct task_struct *me = current;
 
-	WARN_ON_ONCE(!irq_fpu_usable());
-	preempt_disable();
 	if (__thread_has_fpu(me)) {
 		__save_init_fpu(me);
 		__thread_clear_has_fpu(me);
-		/* We do 'stts()' in kernel_fpu_end() */
+		/* We do 'stts()' in __kernel_fpu_end() */
 	} else if (!use_eager_fpu()) {
 		this_cpu_write(fpu_owner_task, NULL);
 		clts();
 	}
 }
-EXPORT_SYMBOL(kernel_fpu_begin);
+EXPORT_SYMBOL(__kernel_fpu_begin);
 
-void kernel_fpu_end(void)
+void __kernel_fpu_end(void)
 {
 	if (use_eager_fpu())
 		math_state_restore();
 	else
 		stts();
-	preempt_enable();
 }
-EXPORT_SYMBOL(kernel_fpu_end);
+EXPORT_SYMBOL(__kernel_fpu_end);
 
 void unlazy_fpu(struct task_struct *tsk)
 {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c00f03d..70dfcec 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1493,8 +1493,12 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
-	if (user_has_fpu())
-		clts();
+	/*
+	 * If the FPU is not active (through the host task or
+	 * the guest vcpu), then restore the cr0.TS bit.
+	 */
+	if (!user_has_fpu() && !vmx->vcpu.guest_fpu_loaded)
+		stts();
 	load_gdt(&__get_cpu_var(host_gdt));
 }
 
@@ -3730,7 +3734,7 @@ static void vmx_set_constant_host_state(void)
 	unsigned long tmpl;
 	struct desc_ptr dt;
 
-	vmcs_writel(HOST_CR0, read_cr0() | X86_CR0_TS);  /* 22.2.3 */
+	vmcs_writel(HOST_CR0, read_cr0() & ~X86_CR0_TS);  /* 22.2.3 */
 	vmcs_writel(HOST_CR4, read_cr4());  /* 22.2.3, 22.2.5 */
 	vmcs_writel(HOST_CR3, read_cr3());  /* 22.2.3  FIXME: shadow tables */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf637f5..02b2cd5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5972,7 +5972,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
-	kernel_fpu_begin();
+	__kernel_fpu_begin();
 	fpu_restore_checking(&vcpu->arch.guest_fpu);
 	trace_kvm_fpu(1);
 }
@@ -5986,7 +5986,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	vcpu->guest_fpu_loaded = 0;
 	fpu_save_init(&vcpu->arch.guest_fpu);
-	kernel_fpu_end();
+	__kernel_fpu_end();
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);
