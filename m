Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2ITSCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:02:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:55082 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab2ITSB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:01:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,455,1344236400"; 
   d="scan'208";a="195134809"
Subject: Re: [PATCH 3/6] x86, kvm: use kernel_fpu_begin/end() in
 kvm_load/put_guest_fpu()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Sep 2012 11:01:49 -0700
In-Reply-To: <505AE6C8.90905@redhat.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
	  <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>
	  <50599AE2.80601@redhat.com>
	 <1348099839.26695.327.camel@sbsiddha-desk.sc.intel.com>
	 <505AE6C8.90905@redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1348164109.26695.338.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 12:50 +0300, Avi Kivity wrote:
> On 09/20/2012 03:10 AM, Suresh Siddha wrote:
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index b06737d..8ff328b 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -1493,7 +1493,8 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
> >  #ifdef CONFIG_X86_64
> >  	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
> >  #endif
> > -	if (user_has_fpu())
> > +	/* Did the host task or the guest vcpu has FPU restored lazily? */
> > +	if (!use_eager_fpu() && (user_has_fpu() || vmx->vcpu.guest_fpu_loaded))
> >  		clts();
> 
> Why do the clts() if guest_fpu_loaded()?
> 
> An interrupt might arrive after this, look at TS
> (interrupted_kernel_fpu_idle()), and stomp on the the guest's fpu.

Actually clts() is harmless, as this condition,
(read_cr0() & X86_CR0_TS)
in interrupted_kernel_fpu_idle() will return false.

But you raise a good point, any interrupt between the vmexit and the
__vmx_load_host_state() can stomp on the guest FPU as the vmexit was
unconditionally setting host's cr0.TS bit and with the kvm using
kernel_fpu_begin/end(), !__thread_has_fpu(current) in the
interrupted_kernel_fpu_idle() will be always true.

So the right thing to do here is to always have the cr0.TS bit clear
during vmexit and set that bit back in __vmx_load_host_state() if the
FPU state is not active.

Appended the modified patch.

thanks,
suresh
--8<--
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, kvm: fix kvm's usage of kernel_fpu_begin/end()

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
index b06737d..851aa7c 100644
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
 
@@ -3743,7 +3747,7 @@ static void vmx_set_constant_host_state(void)
 	unsigned long tmpl;
 	struct desc_ptr dt;
 
-	vmcs_writel(HOST_CR0, read_cr0() | X86_CR0_TS);  /* 22.2.3 */
+	vmcs_writel(HOST_CR0, read_cr0() & ~X86_CR0_TS);  /* 22.2.3 */
 	vmcs_writel(HOST_CR4, read_cr4());  /* 22.2.3, 22.2.5 */
 	vmcs_writel(HOST_CR3, read_cr3());  /* 22.2.3  FIXME: shadow tables */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ddefb4..1f09552 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5979,7 +5979,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
-	kernel_fpu_begin();
+	__kernel_fpu_begin();
 	fpu_restore_checking(&vcpu->arch.guest_fpu);
 	trace_kvm_fpu(1);
 }
@@ -5993,7 +5993,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	vcpu->guest_fpu_loaded = 0;
 	fpu_save_init(&vcpu->arch.guest_fpu);
-	kernel_fpu_end();
+	__kernel_fpu_end();
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);


