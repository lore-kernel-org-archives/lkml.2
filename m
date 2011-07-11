Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab1GKThI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:37:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885Ab1GKThA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:37:00 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH v6 4/9] KVM-HV: KVM Steal time implementation
Date: Mon, 11 Jul 2011 15:28:14 -0400
Message-Id: <1310412499-3873-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1310412499-3873-1-git-send-email-glommer@redhat.com>
References: <1310412499-3873-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement steal time, we need the hypervisor to pass the guest
information about how much time was spent running other processes
outside the VM, while the vcpu had meaningful work to do - halt
time does not count.

This information is acquired through the run_delay field of
delayacct/schedstats infrastructure, that counts time spent in a
runqueue but not running.

Steal time is a per-cpu information, so the traditional MSR-based
infrastructure is used. A new msr, KVM_MSR_STEAL_TIME, holds the
memory area address containing information about steal time

This patch contains the hypervisor part of the steal time infrasructure,
and can be backported independently of the guest portion.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Tested-by: Eric B Munson <emunson@mgebm.net>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    9 +++++
 arch/x86/include/asm/kvm_para.h |    4 ++
 arch/x86/kvm/Kconfig            |    1 +
 arch/x86/kvm/x86.c              |   74 +++++++++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h        |    1 +
 5 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index da6bbee..59086a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -389,6 +389,15 @@ struct kvm_vcpu_arch {
 	unsigned int hw_tsc_khz;
 	unsigned int time_offset;
 	struct page *time_page;
+
+	struct {
+		u64 msr_val;
+		u64 last_steal;
+		u64 accum_steal;
+		struct gfn_to_hva_cache stime;
+		struct kvm_steal_time steal;
+	} st;
+
 	u64 last_guest_tsc;
 	u64 last_kernel_ns;
 	u64 last_tsc_nsec;
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 65f8bb9..c484ba8 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -45,6 +45,10 @@ struct kvm_steal_time {
 	__u32 pad[12];
 };
 
+#define KVM_STEAL_ALIGNMENT_BITS 5
+#define KVM_STEAL_VALID_BITS ((-1ULL << (KVM_STEAL_ALIGNMENT_BITS + 1)))
+#define KVM_STEAL_RESERVED_MASK (((1 << KVM_STEAL_ALIGNMENT_BITS) - 1 ) << 1)
+
 #define KVM_MAX_MMU_OP_BATCH           32
 
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 50f6364..99c3f05 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -31,6 +31,7 @@ config KVM
 	select KVM_ASYNC_PF
 	select USER_RETURN_NOTIFIER
 	select KVM_MMIO
+	select TASK_DELAY_ACCT
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7167717..6282f6c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -808,12 +808,12 @@ EXPORT_SYMBOL_GPL(kvm_get_dr);
  * kvm-specific. Those are put in the beginning of the list.
  */
 
-#define KVM_SAVE_MSRS_BEGIN	8
+#define KVM_SAVE_MSRS_BEGIN	9
 static u32 msrs_to_save[] = {
 	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
 	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
-	HV_X64_MSR_APIC_ASSIST_PAGE, MSR_KVM_ASYNC_PF_EN,
+	HV_X64_MSR_APIC_ASSIST_PAGE, MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_STAR,
 #ifdef CONFIG_X86_64
@@ -1491,6 +1491,35 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void accumulate_steal_time(struct kvm_vcpu *vcpu)
+{
+	u64 delta;
+
+	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
+		return;
+
+	delta = current->sched_info.run_delay - vcpu->arch.st.last_steal;
+	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	vcpu->arch.st.accum_steal = delta;
+}
+
+static void record_steal_time(struct kvm_vcpu *vcpu)
+{
+	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
+		return;
+
+	if (unlikely(kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.st.stime,
+		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time))))
+		return;
+
+	vcpu->arch.st.steal.steal += vcpu->arch.st.accum_steal;
+	vcpu->arch.st.steal.version += 2;
+	vcpu->arch.st.accum_steal = 0;
+
+	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.st.stime,
+		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time));
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	switch (msr) {
@@ -1573,6 +1602,33 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
+	case MSR_KVM_STEAL_TIME:
+
+		if (unlikely(!sched_info_on()))
+			return 1;
+
+		if (data & KVM_STEAL_RESERVED_MASK)
+			return 1;
+
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.st.stime,
+							data & KVM_STEAL_VALID_BITS))
+			return 1;
+
+		vcpu->arch.st.msr_val = data;
+
+		if (!(data & KVM_MSR_ENABLED))
+			break;
+
+		vcpu->arch.st.last_steal = current->sched_info.run_delay;
+
+		preempt_disable();
+		accumulate_steal_time(vcpu);
+		preempt_enable();
+
+		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
+
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
@@ -1858,6 +1914,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_KVM_ASYNC_PF_EN:
 		data = vcpu->arch.apf.msr_val;
 		break;
+	case MSR_KVM_STEAL_TIME:
+		data = vcpu->arch.st.msr_val;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -2169,6 +2228,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
 	}
+
+	accumulate_steal_time(vcpu);
+	kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -2490,6 +2552,10 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
+
+		if (likely(sched_info_on()))
+		     entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
+
 		entry->ebx = 0;
 		entry->ecx = 0;
 		entry->edx = 0;
@@ -5473,6 +5539,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 1;
 			goto out;
 		}
+		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
+			record_steal_time(vcpu);
+
 	}
 
 	r = kvm_mmu_reload(vcpu);
@@ -6209,6 +6278,7 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	vcpu->arch.apf.msr_val = 0;
+	vcpu->arch.st.msr_val = 0;
 
 	kvmclock_reset(vcpu);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f7df0a3..c8e0239 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -47,6 +47,7 @@
 #define KVM_REQ_DEACTIVATE_FPU    10
 #define KVM_REQ_EVENT             11
 #define KVM_REQ_APF_HALT          12
+#define KVM_REQ_STEAL_UPDATE      13
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID	0
 
-- 
1.7.3.4

