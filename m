Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0GMC3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab0GMCZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:25:52 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: [PATCH 04/18] Make cpu_tsc_khz updates use local CPU
Date: Mon, 12 Jul 2010 16:25:24 -1000
Message-Id: <1278987938-23873-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies much of the init code; we can now simply always
call tsc_khz_changed, optionally passing it a new value, or letting
it figure out the existing value (while interrupts are disabled, and
thus, by inference from the rule, not raceful against CPU hotplug or
frequency updates, which will issue IPIs to the local CPU to perform
this very same task).

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |  157 +++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 114 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb7451b..2d5b97a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -893,6 +893,15 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 
+static inline int kvm_tsc_changes_freq(void)
+{
+	int cpu = get_cpu();
+	int ret = !boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+		  cpufreq_quick_get(cpu) != 0;
+	put_cpu();
+	return ret;
+}
+
 void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -937,7 +946,7 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 }
 EXPORT_SYMBOL_GPL(guest_write_tsc);
 
-static void kvm_write_guest_time(struct kvm_vcpu *v)
+static int kvm_write_guest_time(struct kvm_vcpu *v)
 {
 	struct timespec ts;
 	unsigned long flags;
@@ -946,24 +955,27 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	unsigned long this_tsc_khz;
 
 	if ((!vcpu->time_page))
-		return;
-
-	this_tsc_khz = get_cpu_var(cpu_tsc_khz);
-	if (unlikely(vcpu->hv_clock_tsc_khz != this_tsc_khz)) {
-		kvm_set_time_scale(this_tsc_khz, &vcpu->hv_clock);
-		vcpu->hv_clock_tsc_khz = this_tsc_khz;
-	}
-	put_cpu_var(cpu_tsc_khz);
+		return 0;
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &vcpu->hv_clock.tsc_timestamp);
 	ktime_get_ts(&ts);
 	monotonic_to_bootbased(&ts);
+	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
 	local_irq_restore(flags);
 
-	/* With all the info we got, fill in the values */
+	if (unlikely(this_tsc_khz == 0)) {
+		kvm_make_request(KVM_REQ_KVMCLOCK_UPDATE, v);
+		return 1;
+	}
 
+	if (unlikely(vcpu->hv_clock_tsc_khz != this_tsc_khz)) {
+		kvm_set_time_scale(this_tsc_khz, &vcpu->hv_clock);
+		vcpu->hv_clock_tsc_khz = this_tsc_khz;
+	}
+
+	/* With all the info we got, fill in the values */
 	vcpu->hv_clock.system_time = ts.tv_nsec +
 				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
 
@@ -984,6 +996,7 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	kunmap_atomic(shared_kaddr, KM_USER0);
 
 	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
+	return 0;
 }
 
 static int kvm_request_guest_time_update(struct kvm_vcpu *v)
@@ -1850,12 +1863,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
-	if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0)) {
-		unsigned long khz = cpufreq_quick_get(cpu);
-		if (!khz)
-			khz = tsc_khz;
-		per_cpu(cpu_tsc_khz, cpu) = khz;
-	}
 	kvm_request_guest_time_update(vcpu);
 }
 
@@ -4131,9 +4138,23 @@ int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size, unsigned short port)
 }
 EXPORT_SYMBOL_GPL(kvm_fast_pio_out);
 
-static void bounce_off(void *info)
+static void tsc_bad(void *info)
+{
+	__get_cpu_var(cpu_tsc_khz) = 0;
+}
+
+static void tsc_khz_changed(void *data)
 {
-	/* nothing */
+	struct cpufreq_freqs *freq = data;
+	unsigned long khz = 0;
+
+	if (data)
+		khz = freq->new;
+	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		khz = cpufreq_quick_get(raw_smp_processor_id());
+	if (!khz)
+		khz = tsc_khz;
+	__get_cpu_var(cpu_tsc_khz) = khz;
 }
 
 static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
@@ -4144,11 +4165,51 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	struct kvm_vcpu *vcpu;
 	int i, send_ipi = 0;
 
+	/*
+	 * We allow guests to temporarily run on slowing clocks,
+	 * provided we notify them after, or to run on accelerating
+	 * clocks, provided we notify them before.  Thus time never
+	 * goes backwards.
+	 *
+	 * However, we have a problem.  We can't atomically update
+	 * the frequency of a given CPU from this function; it is
+	 * merely a notifier, which can be called from any CPU.
+	 * Changing the TSC frequency at arbitrary points in time
+	 * requires a recomputation of local variables related to
+	 * the TSC for each VCPU.  We must flag these local variables
+	 * to be updated and be sure the update takes place with the
+	 * new frequency before any guests proceed.
+	 *
+	 * Unfortunately, the combination of hotplug CPU and frequency
+	 * change creates an intractable locking scenario; the order
+	 * of when these callouts happen is undefined with respect to
+	 * CPU hotplug, and they can race with each other.  As such,
+	 * merely setting per_cpu(cpu_tsc_khz) = X during a hotadd is
+	 * undefined; you can actually have a CPU frequency change take
+	 * place in between the computation of X and the setting of the
+	 * variable.  To protect against this problem, all updates of
+	 * the per_cpu tsc_khz variable are done in an interrupt
+	 * protected IPI, and all callers wishing to update the value
+	 * must wait for a synchronous IPI to complete (which is trivial
+	 * if the caller is on the CPU already).  This establishes the
+	 * necessary total order on variable updates.
+	 *
+	 * Note that because a guest time update may take place
+	 * anytime after the setting of the VCPU's request bit, the
+	 * correct TSC value must be set before the request.  However,
+	 * to ensure the update actually makes it to any guest which
+	 * starts running in hardware virtualization between the set
+	 * and the acquisition of the spinlock, we must also ping the
+	 * CPU after setting the request bit.
+	 *
+	 */
+
 	if (val == CPUFREQ_PRECHANGE && freq->old > freq->new)
 		return 0;
 	if (val == CPUFREQ_POSTCHANGE && freq->old < freq->new)
 		return 0;
-	per_cpu(cpu_tsc_khz, freq->cpu) = freq->new;
+
+	smp_call_function_single(freq->cpu, tsc_khz_changed, freq, 1);
 
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
@@ -4158,7 +4219,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 			if (!kvm_request_guest_time_update(vcpu))
 				continue;
 			if (vcpu->cpu != smp_processor_id())
-				send_ipi++;
+				send_ipi = 1;
 		}
 	}
 	spin_unlock(&kvm_lock);
@@ -4176,32 +4237,48 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 		 * guest context is entered kvmclock will be updated,
 		 * so the guest will not see stale values.
 		 */
-		smp_call_function_single(freq->cpu, bounce_off, NULL, 1);
+		smp_call_function_single(freq->cpu, tsc_khz_changed, freq, 1);
 	}
 	return 0;
 }
 
 static struct notifier_block kvmclock_cpufreq_notifier_block = {
-        .notifier_call  = kvmclock_cpufreq_notifier
+	.notifier_call  = kvmclock_cpufreq_notifier
+};
+
+static int kvmclock_cpu_notifier(struct notifier_block *nfb,
+					unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+
+	switch (action) {
+		case CPU_ONLINE:
+		case CPU_DOWN_FAILED:
+			smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
+			break;
+		case CPU_DOWN_PREPARE:
+			smp_call_function_single(cpu, tsc_bad, NULL, 1);
+			break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kvmclock_cpu_notifier_block = {
+	.notifier_call  = kvmclock_cpu_notifier,
+	.priority = -INT_MAX
 };
 
 static void kvm_timer_init(void)
 {
 	int cpu;
 
+	register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
-		for_each_online_cpu(cpu) {
-			unsigned long khz = cpufreq_get(cpu);
-			if (!khz)
-				khz = tsc_khz;
-			per_cpu(cpu_tsc_khz, cpu) = khz;
-		}
-	} else {
-		for_each_possible_cpu(cpu)
-			per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
 	}
+	for_each_online_cpu(cpu)
+		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
 }
 
 static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
@@ -4303,6 +4380,7 @@ void kvm_arch_exit(void)
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
+	unregister_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
 }
@@ -4718,8 +4796,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_mmu_unload(vcpu);
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
 			__kvm_migrate_timers(vcpu);
-		if (kvm_check_request(KVM_REQ_KVMCLOCK_UPDATE, vcpu))
-			kvm_write_guest_time(vcpu);
+		if (kvm_check_request(KVM_REQ_KVMCLOCK_UPDATE, vcpu)) {
+			r = kvm_write_guest_time(vcpu);
+			if (unlikely(r))
+				goto out;
+		}
 		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
 			kvm_mmu_sync_roots(vcpu);
 		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
@@ -5415,17 +5496,7 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
 int kvm_arch_hardware_enable(void *garbage)
 {
-	/*
-	 * Since this may be called from a hotplug notifcation,
-	 * we can't get the CPU frequency directly.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
-		int cpu = raw_smp_processor_id();
-		per_cpu(cpu_tsc_khz, cpu) = 0;
-	}
-
 	kvm_shared_msr_cpu_online();
-
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
-- 
1.7.1

