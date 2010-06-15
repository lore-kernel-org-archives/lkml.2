Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab0FOHiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:38:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0FOHe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:29 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 02/17] Make cpu_tsc_khz updates use local CPU.
Date: Mon, 14 Jun 2010 21:34:04 -1000
Message-Id: <1276587259-32319-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
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
 arch/x86/kvm/x86.c |  136 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 100 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05754c1..0a102d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -911,7 +911,7 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 
-static void kvm_write_guest_time(struct kvm_vcpu *v)
+static int kvm_write_guest_time(struct kvm_vcpu *v)
 {
 	struct timespec ts;
 	unsigned long flags;
@@ -920,14 +920,19 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	unsigned long this_tsc_khz;
 
 	if ((!vcpu->time_page))
-		return;
+		return 0;
 
 	this_tsc_khz = get_cpu_var(cpu_tsc_khz);
+	put_cpu_var(cpu_tsc_khz);
+	if (unlikely(this_tsc_khz == 0)) {
+		set_bit(KVM_REQ_KVMCLOCK_UPDATE, &v->requests);
+		return 1;
+	}
+
 	if (unlikely(vcpu->hv_clock_tsc_khz != this_tsc_khz)) {
 		kvm_set_time_scale(this_tsc_khz, &vcpu->hv_clock);
 		vcpu->hv_clock_tsc_khz = this_tsc_khz;
 	}
-	put_cpu_var(cpu_tsc_khz);
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
@@ -958,6 +963,7 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	kunmap_atomic(shared_kaddr, KM_USER0);
 
 	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
+	return 0;
 }
 
 static int kvm_request_guest_time_update(struct kvm_vcpu *v)
@@ -1803,12 +1809,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_migrate_timers(vcpu);
 	}
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
-	if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0)) {
-		unsigned long khz = cpufreq_quick_get(cpu);
-		if (!khz)
-			khz = tsc_khz;
-		per_cpu(cpu_tsc_khz, cpu) = khz;
-	}
 	kvm_request_guest_time_update(vcpu);
 	vcpu->cpu = cpu;
 }
@@ -4053,9 +4053,23 @@ int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size, unsigned short port)
 }
 EXPORT_SYMBOL_GPL(kvm_fast_pio_out);
 
-static void bounce_off(void *info)
+static void tsc_bad(void *info)
 {
-	/* nothing */
+	per_cpu(cpu_tsc_khz, raw_smp_processor_id()) = 0;
+}
+
+static void tsc_khz_changed(void *data)
+{
+	struct cpufreq_freqs *freq = data;
+
+	if (data) {
+		per_cpu(cpu_tsc_khz, freq->cpu) = freq->new;
+	} else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		__get_cpu_var(cpu_tsc_khz) =
+			cpufreq_quick_get(raw_smp_processor_id());
+	}
+	if (!per_cpu(cpu_tsc_khz, raw_smp_processor_id()))
+		per_cpu(cpu_tsc_khz, raw_smp_processor_id()) = tsc_khz;
 }
 
 static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
@@ -4066,11 +4080,51 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
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
+	 * Note that because the guest time update may take place
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
@@ -4080,7 +4134,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 			if (!kvm_request_guest_time_update(vcpu))
 				continue;
 			if (vcpu->cpu != smp_processor_id())
-				send_ipi++;
+				send_ipi = 1;
 		}
 	}
 	spin_unlock(&kvm_lock);
@@ -4098,32 +4152,48 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
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
@@ -4225,6 +4295,7 @@ void kvm_arch_exit(void)
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
+	unregister_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
 }
@@ -4646,8 +4717,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->requests) {
 		if (test_and_clear_bit(KVM_REQ_MIGRATE_TIMER, &vcpu->requests))
 			__kvm_migrate_timers(vcpu);
-		if (test_and_clear_bit(KVM_REQ_KVMCLOCK_UPDATE, &vcpu->requests))
-			kvm_write_guest_time(vcpu);
+		if (test_and_clear_bit(KVM_REQ_KVMCLOCK_UPDATE, &vcpu->requests)) {
+			r = kvm_write_guest_time(vcpu);
+			if (unlikely(r))
+				goto out;
+		}
 		if (test_and_clear_bit(KVM_REQ_MMU_SYNC, &vcpu->requests))
 			kvm_mmu_sync_roots(vcpu);
 		if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
@@ -5339,17 +5413,7 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
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

