Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2F1GIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:08:07 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51407 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2F1GIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:08:01 -0400
X-AuditID: b753bd60-996f1ba000000f6c-0f-4febf4beadb7
X-AuditID: b753bd60-996f1ba000000f6c-0f-4febf4beadb7
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 06/18] KVM: Add facility to run guests on slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:07:51 +0900
Message-ID: <20120628060751.19298.39801.stgit@localhost.localdomain>
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

Add path to migrate execution of vcpu_enter_guest to a slave CPU when
vcpu->arch.slave_cpu is set.

After moving to the slave CPU, it goes back to the online CPU when the
guest is exited by reasons that cannot be handled by the slave CPU only
(e.g. handling async page faults).

On migration, kvm_arch_vcpu_put_migrate is used to avoid using IPI to
clear loaded vmcs from the old CPU. Instead, this immediately clears
vmcs.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/kvm_host.h |    9 ++
 arch/x86/kernel/smp.c           |    2 
 arch/x86/kvm/vmx.c              |   10 ++
 arch/x86/kvm/x86.c              |  190 ++++++++++++++++++++++++++++++++++-----
 include/linux/kvm_host.h        |    1 
 kernel/smp.c                    |    1 
 virt/kvm/async_pf.c             |    9 +-
 virt/kvm/kvm_main.c             |    3 -
 8 files changed, 196 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index db7c1f2..4291954 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -346,6 +346,14 @@ struct kvm_vcpu_arch {
 	u64 ia32_misc_enable_msr;
 	bool tpr_access_reporting;
 
+#ifdef CONFIG_SLAVE_CPU
+	/* slave cpu dedicated to this vcpu */
+	int slave_cpu;
+#endif
+
+	/* user process tied to each vcpu */
+	struct task_struct *task;
+
 	/*
 	 * Paging state of the vcpu
 	 *
@@ -604,6 +612,7 @@ struct kvm_x86_ops {
 	void (*prepare_guest_switch)(struct kvm_vcpu *vcpu);
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
+	void (*vcpu_put_migrate)(struct kvm_vcpu *vcpu);
 
 	void (*set_guest_debug)(struct kvm_vcpu *vcpu,
 				struct kvm_guest_debug *dbg);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..a58dead 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -119,7 +119,7 @@ static bool smp_no_nmi_ipi = false;
  */
 static void native_smp_send_reschedule(int cpu)
 {
-	if (unlikely(cpu_is_offline(cpu))) {
+	if (unlikely(cpu_is_offline(cpu) && !cpu_slave(cpu))) {
 		WARN_ON(1);
 		return;
 	}
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6ea77e4..9ee2d9a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1547,6 +1547,13 @@ static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_vcpu_put_migrate(struct kvm_vcpu *vcpu)
+{
+	vmx_vcpu_put(vcpu);
+	__loaded_vmcs_clear(to_vmx(vcpu)->loaded_vmcs);
+	vcpu->cpu = -1;
+}
+
 static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
 {
 	ulong cr0;
@@ -4928,7 +4935,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (err != EMULATE_DONE)
 			return 0;
 
-		if (signal_pending(current))
+		if (signal_pending(vcpu->arch.task))
 			goto out;
 		if (need_resched())
 			schedule();
@@ -7144,6 +7151,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.prepare_guest_switch = vmx_save_host_state,
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
+	.vcpu_put_migrate = vmx_vcpu_put_migrate,
 
 	.set_guest_debug = set_guest_debug,
 	.get_msr = vmx_get_msr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9bb2f8f2..ecd474a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -46,6 +46,7 @@
 #include <linux/uaccess.h>
 #include <linux/hash.h>
 #include <linux/pci.h>
+#include <linux/mmu_context.h>
 #include <trace/events/kvm.h>
 
 #define CREATE_TRACE_POINTS
@@ -62,6 +63,7 @@
 #include <asm/pvclock.h>
 #include <asm/div64.h>
 #include <asm/cpu.h>
+#include <asm/mmu.h>
 
 #define MAX_IO_MSRS 256
 #define KVM_MAX_MCE_BANKS 32
@@ -1633,6 +1635,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		if (unlikely(!sched_info_on()))
 			return 1;
 
+#ifdef CONFIG_SLAVE_CPU
+		if (vcpu->arch.slave_cpu)
+			break;
+#endif
+
 		if (data & KVM_STEAL_RESERVED_MASK)
 			return 1;
 
@@ -2319,6 +2326,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->arch.last_host_tsc = native_read_tsc();
 }
 
+void kvm_arch_vcpu_put_migrate(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops->vcpu_put_migrate(vcpu);
+	kvm_put_guest_fpu(vcpu);
+	vcpu->arch.last_host_tsc = native_read_tsc();
+}
+
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
@@ -5246,7 +5260,46 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
-static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
+enum vcpu_enter_guest_slave_retval {
+	EXIT_TO_USER = 0,
+	LOOP_ONLINE,		/* vcpu_post_run is done in online cpu */
+	LOOP_SLAVE,		/* vcpu_post_run is done in slave cpu */
+	LOOP_APF,		    /* must handle async_pf in online cpu */
+	LOOP_RETRY,		    /* may in hlt state */
+};
+
+static int vcpu_post_run(struct kvm_vcpu *vcpu, struct task_struct *task,
+			 int *can_complete_async_pf)
+{
+	int r = LOOP_ONLINE;
+
+	clear_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
+	if (kvm_cpu_has_pending_timer(vcpu))
+		kvm_inject_pending_timer_irqs(vcpu);
+
+	if (dm_request_for_irq_injection(vcpu)) {
+		r = -EINTR;
+		vcpu->run->exit_reason = KVM_EXIT_INTR;
+		++vcpu->stat.request_irq_exits;
+	}
+
+	if (can_complete_async_pf) {
+		*can_complete_async_pf = kvm_can_complete_async_pf(vcpu);
+		if (r == LOOP_ONLINE)
+			r = *can_complete_async_pf ? LOOP_APF : LOOP_SLAVE;
+	} else
+		kvm_check_async_pf_completion(vcpu);
+
+	if (signal_pending(task)) {
+		r = -EINTR;
+		vcpu->run->exit_reason = KVM_EXIT_INTR;
+		++vcpu->stat.signal_exits;
+	}
+
+	return r;
+}
+
+static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct task_struct *task)
 {
 	int r;
 	unsigned long flags;
@@ -5338,7 +5391,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_save(flags);
 
 	if (vcpu->mode == EXITING_GUEST_MODE || vcpu->requests
-	    || need_resched() || signal_pending(current)) {
+	    || need_resched() || signal_pending(task)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
 		local_irq_restore(flags);
@@ -5416,10 +5469,97 @@ out:
 	return r;
 }
 
+#ifdef CONFIG_SLAVE_CPU
+
+struct __vcpu_enter_guest_args {
+	struct kvm_vcpu *vcpu;
+	struct task_struct *task;
+	struct completion wait;
+	int ret, apf_pending;
+};
+
+static void __vcpu_enter_guest_slave(void *_arg)
+{
+	struct __vcpu_enter_guest_args *arg = _arg;
+	struct kvm_vcpu *vcpu = arg->vcpu;
+	int r = LOOP_SLAVE;
+	int cpu = smp_processor_id();
+
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	use_mm(arg->task->mm);
+	kvm_arch_vcpu_load(vcpu, cpu);
+
+	while (r == LOOP_SLAVE) {
+		r = vcpu_enter_guest(vcpu, arg->task);
+
+		if (unlikely(!irqs_disabled())) {
+			pr_err("irq is enabled on slave vcpu_etner_guest! - forcely disable\n");
+			local_irq_disable();
+		}
+
+		if (r <= 0)
+			break;
+
+		/* determine if slave cpu can handle the exit alone */
+		r = vcpu_post_run(vcpu, arg->task, &arg->apf_pending);
+
+		if (arg->ret == LOOP_SLAVE &&
+		    (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE ||
+		     vcpu->arch.apf.halted)) {
+			arg->ret = LOOP_RETRY;
+		}
+	}
+
+	kvm_arch_vcpu_put_migrate(vcpu);
+	unuse_mm(arg->task->mm);
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 
-static int __vcpu_run(struct kvm_vcpu *vcpu)
+	arg->ret = r;
+	complete(&arg->wait);
+}
+
+static int vcpu_enter_guest_slave(struct kvm_vcpu *vcpu,
+				  struct task_struct *task, int *apf_pending)
 {
+	struct __vcpu_enter_guest_args arg = {vcpu, task};
+	struct call_single_data csd = {.func = __vcpu_enter_guest_slave,
+				       .info = &arg, .flags = 0};
+	int slave = vcpu->arch.slave_cpu;
 	int r;
+
+	BUG_ON((unsigned)slave >= nr_cpu_ids || !cpu_slave(slave));
+
+	preempt_disable();
+	preempt_notifier_unregister(&vcpu->preempt_notifier);
+	kvm_arch_vcpu_put_migrate(vcpu);
+	preempt_enable();
+
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	init_completion(&arg.wait);
+	__smp_call_function_single(slave, &csd, 0);
+	r = wait_for_completion_interruptible(&arg.wait);
+	if (r) {
+		/* interrupted: kick and wait VM on the slave cpu */
+		kvm_vcpu_kick(vcpu);
+		wait_for_completion(&arg.wait);
+	}
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	preempt_notifier_register(&vcpu->preempt_notifier);
+	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+
+	r = arg.ret;
+	*apf_pending = arg.apf_pending;
+
+	return r;
+}
+
+#endif /* CONFIG_SLAVE_CPU */
+
+static int __vcpu_run(struct kvm_vcpu *vcpu, struct task_struct *task)
+{
+	int r, apf_pending = 0;
 	struct kvm *kvm = vcpu->kvm;
 
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED)) {
@@ -5438,9 +5578,18 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	r = 1;
 	while (r > 0) {
 		if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
-		    !vcpu->arch.apf.halted)
-			r = vcpu_enter_guest(vcpu);
-		else {
+		    !vcpu->arch.apf.halted) {
+#ifdef CONFIG_SLAVE_CPU
+			apf_pending = 0;
+			if (vcpu->arch.slave_cpu >= 0) {
+				r = vcpu_enter_guest_slave(vcpu, task,
+							   &apf_pending);
+				if (r == LOOP_RETRY)
+					continue;
+			} else
+#endif
+				r = vcpu_enter_guest(vcpu, task);
+		} else {
 			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			kvm_vcpu_block(vcpu);
 			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
@@ -5461,26 +5610,15 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 			}
 		}
 
+		if (apf_pending)
+			kvm_check_async_pf_completion(vcpu);
+
 		if (r <= 0)
 			break;
 
-		clear_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
-		if (kvm_cpu_has_pending_timer(vcpu))
-			kvm_inject_pending_timer_irqs(vcpu);
+		if (r == LOOP_ONLINE)
+			r = vcpu_post_run(vcpu, task, NULL);
 
-		if (dm_request_for_irq_injection(vcpu)) {
-			r = -EINTR;
-			vcpu->run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.request_irq_exits;
-		}
-
-		kvm_check_async_pf_completion(vcpu);
-
-		if (signal_pending(current)) {
-			r = -EINTR;
-			vcpu->run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.signal_exits;
-		}
 		if (need_resched()) {
 			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			kvm_resched(vcpu);
@@ -5582,8 +5720,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (r <= 0)
 		goto out;
 
-	r = __vcpu_run(vcpu);
-
+	r = __vcpu_run(vcpu, current);
 out:
 	post_kvm_run_save(vcpu);
 	if (vcpu->sigset_active)
@@ -6022,6 +6159,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	r = kvm_arch_vcpu_reset(vcpu);
 	if (r == 0)
 		r = kvm_mmu_setup(vcpu);
+	vcpu->arch.task = current;
 	vcpu_put(vcpu);
 
 	return r;
@@ -6204,6 +6342,10 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_set_tsc_khz(vcpu, max_tsc_khz);
 
+#ifdef CONFIG_SLAVE_CPU
+	vcpu->arch.slave_cpu = -1;
+#endif
+
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
 		goto fail_free_pio_data;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c446435..c44a7be 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -119,6 +119,7 @@ struct kvm_async_pf {
 };
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
+int kvm_can_complete_async_pf(struct kvm_vcpu *vcpu);
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
 int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 		       struct kvm_arch_async_pf *arch);
diff --git a/kernel/smp.c b/kernel/smp.c
index 6e42573..081d700 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -431,6 +431,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
 	}
 	put_cpu();
 }
+EXPORT_SYMBOL(__smp_call_function_single);
 
 /**
  * smp_call_function_many(): Run a function on a set of other CPUs.
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 74268b4..feb5e76 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -120,12 +120,17 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 	vcpu->async_pf.queued = 0;
 }
 
+int kvm_can_complete_async_pf(struct kvm_vcpu *vcpu)
+{
+	return !list_empty_careful(&vcpu->async_pf.done) &&
+		kvm_arch_can_inject_async_page_present(vcpu);
+}
+
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
 
-	while (!list_empty_careful(&vcpu->async_pf.done) &&
-	      kvm_arch_can_inject_async_page_present(vcpu)) {
+	while (kvm_can_complete_async_pf(vcpu)) {
 		spin_lock(&vcpu->async_pf.lock);
 		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
 					      link);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f5890f0..ff8b418 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1531,7 +1531,8 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	}
 
 	me = get_cpu();
-	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
+	if (cpu != me && (unsigned)cpu < nr_cpu_ids &&
+	    (cpu_online(cpu) || cpu_slave(cpu)))
 		if (kvm_arch_vcpu_should_kick(vcpu))
 			smp_send_reschedule(cpu);
 	put_cpu();


