Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0ISAi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 20:38:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab0ISAi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 20:38:26 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping fixes 4/4] TSC catchup mode
Date: Sat, 18 Sep 2010 14:38:15 -1000
Message-Id: <1284856695-19438-4-git-send-email-zamsden@redhat.com>
In-Reply-To: <1284856695-19438-3-git-send-email-zamsden@redhat.com>
References: <1284856695-19438-1-git-send-email-zamsden@redhat.com>
 <1284856695-19438-2-git-send-email-zamsden@redhat.com>
 <1284856695-19438-3-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Negate the effects of AN TYM spell while kvm thread is preempted by tracking
conversion factor to the highest TSC rate and catching the TSC up when it has
fallen behind the kernel view of time.  Note that once triggered, we don't
turn off catchup mode.

A slightly more clever version of this is possible, which only does catchup
when TSC rate drops, and which specifically targets only CPUs with broken
TSC, but since these all are considered unstable_tsc(), this patch covers
all necessary cases.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    6 +++
 arch/x86/kvm/x86.c              |   87 +++++++++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8c5779d..e209078 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -384,6 +384,9 @@ struct kvm_vcpu_arch {
 	u64 last_host_tsc;
 	u64 last_guest_tsc;
 	u64 last_kernel_ns;
+	u64 last_tsc_nsec;
+	u64 last_tsc_write;
+	bool tsc_catchup;
 
 	bool nmi_pending;
 	bool nmi_injected;
@@ -444,6 +447,9 @@ struct kvm_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_offset;
 	u64 last_tsc_write;
+	u32 virtual_tsc_khz;
+	u32 virtual_tsc_mult;
+	s8 virtual_tsc_shift;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09f468a..9152156 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -962,6 +962,7 @@ static inline u64 get_kernel_ns(void)
 }
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
+unsigned long max_tsc_khz;
 
 static inline int kvm_tsc_changes_freq(void)
 {
@@ -985,6 +986,24 @@ static inline u64 nsec_to_cycles(u64 nsec)
 	return ret;
 }
 
+static void kvm_arch_set_tsc_khz(struct kvm *kvm, u32 this_tsc_khz)
+{
+	/* Compute a scale to convert nanoseconds in TSC cycles */
+	kvm_get_time_scale(this_tsc_khz, NSEC_PER_SEC / 1000,
+			   &kvm->arch.virtual_tsc_shift,
+			   &kvm->arch.virtual_tsc_mult);
+	kvm->arch.virtual_tsc_khz = this_tsc_khz;
+}
+
+static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
+{
+	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.last_tsc_nsec,
+				      vcpu->kvm->arch.virtual_tsc_mult,
+				      vcpu->kvm->arch.virtual_tsc_shift);
+	tsc += vcpu->arch.last_tsc_write;
+	return tsc;
+}
+
 void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1029,6 +1048,8 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 
 	/* Reset of TSC must disable overshoot protection below */
 	vcpu->arch.hv_clock.tsc_timestamp = 0;
+	vcpu->arch.last_tsc_write = data;
+	vcpu->arch.last_tsc_nsec = ns;
 }
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
@@ -1041,22 +1062,42 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	s64 kernel_ns, max_kernel_ns;
 	u64 tsc_timestamp;
 
-	if ((!vcpu->time_page))
-		return 0;
-
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
 	kernel_ns = get_kernel_ns();
 	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
-	local_irq_restore(flags);
 
 	if (unlikely(this_tsc_khz == 0)) {
+		local_irq_restore(flags);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 		return 1;
 	}
 
 	/*
+	 * We may have to catch up the TSC to match elapsed wall clock
+	 * time for two reasons, even if kvmclock is used.
+	 *   1) CPU could have been running below the maximum TSC rate
+	 *   2) Broken TSC compensation resets the base at each VCPU
+	 *      entry to avoid unknown leaps of TSC even when running
+	 *      again on the same CPU.  This may cause apparent elapsed
+	 *      time to disappear, and the guest to stand still or run
+	 *	very slowly.
+	 */
+	if (vcpu->tsc_catchup) {
+		u64 tsc = compute_guest_tsc(v, kernel_ns);
+		if (tsc > tsc_timestamp) {
+			kvm_x86_ops->adjust_tsc_offset(v, tsc - tsc_timestamp);
+			tsc_timestamp = tsc;
+		}
+	}
+	
+	local_irq_restore(flags);
+
+	if (!vcpu->time_page)
+		return 0;
+
+	/*
 	 * Time as measured by the TSC may go backwards when resetting the base
 	 * tsc_timestamp.  The reason for this is that the TSC resolution is
 	 * higher than the resolution of the other clock scales.  Thus, many
@@ -1122,16 +1163,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	return 0;
 }
 
-static int kvm_request_guest_time_update(struct kvm_vcpu *v)
-{
-	struct kvm_vcpu_arch *vcpu = &v->arch;
-
-	if (!vcpu->time_page)
-		return 0;
-	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
-	return 1;
-}
-
 static bool msr_mtrr_valid(unsigned msr)
 {
 	switch (msr) {
@@ -1455,6 +1486,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		}
 
 		vcpu->arch.time = data;
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
 		/* we verify if the enable bit is set... */
 		if (!(data & 1))
@@ -1470,8 +1502,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			kvm_release_page_clean(vcpu->arch.time_page);
 			vcpu->arch.time_page = NULL;
 		}
-
-		kvm_request_guest_time_update(vcpu);
 		break;
 	}
 	case MSR_IA32_MCG_CTL:
@@ -2028,9 +2058,13 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 				native_read_tsc() - vcpu->arch.last_host_tsc;
 		if (tsc_delta < 0)
 			mark_tsc_unstable("KVM discovered backwards TSC");
-		if (check_tsc_unstable())
+		if (check_tsc_unstable()) {
 			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
-		kvm_migrate_timers(vcpu);
+			vcpu->arch.tsc_catchup = 1;
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		}
+		if (vcpu->cpu != cpu)
+			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
 	}
 }
@@ -4432,8 +4466,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (vcpu->cpu != freq->cpu)
 				continue;
-			if (!kvm_request_guest_time_update(vcpu))
-				continue;
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			if (vcpu->cpu != smp_processor_id())
 				send_ipi = 1;
 		}
@@ -4488,11 +4521,20 @@ static void kvm_timer_init(void)
 {
 	int cpu;
 
+	max_tsc_khz = tsc_khz;
 	register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+#ifdef CONFIG_CPU_FREQ
+		struct cpufreq_policy policy;
+		memset(&policy, 0, sizeof(policy));
+		cpufreq_get_policy(&policy, get_cpu());
+		if (policy.cpuinfo.max_freq)
+			max_tsc_khz = policy.cpuinfo.max_freq;
+#endif
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
 	}
+	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
 	for_each_online_cpu(cpu)
 		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
 }
@@ -5723,7 +5765,7 @@ int kvm_arch_hardware_enable(void *garbage)
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_for_each_vcpu(i, vcpu, kvm)
 			if (vcpu->cpu == smp_processor_id())
-				kvm_request_guest_time_update(vcpu);
+				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
@@ -5774,6 +5816,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	}
 	vcpu->arch.pio_data = page_address(page);
 
+	if (!kvm->arch.virtual_tsc_khz)
+		kvm_arch_set_tsc_khz(kvm, max_tsc_khz);
+
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
 		goto fail_free_pio_data;
-- 
1.6.6.1

