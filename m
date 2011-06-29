Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1F2Piy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:38:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab1F2PiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:38:08 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH v3 4/9] KVM-HV: KVM Steal time implementation
Date: Wed, 29 Jun 2011 11:29:43 -0400
Message-Id: <1309361388-30163-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1309361388-30163-1-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement steal time, we need the hypervisor to pass the guest information
about how much time was spent running other processes outside the VM.
This is per-vcpu, and using the kvmclock structure for that is an abuse
we decided not to make.

In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
holds the memory area address containing information about steal time

This patch contains the hypervisor part for it. I am keeping it separate from
the headers to facilitate backports to people who wants to backport the kernel
part but not the hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 arch/x86/include/asm/kvm_host.h |    8 ++++++
 arch/x86/include/asm/kvm_para.h |    4 +++
 arch/x86/kvm/x86.c              |   53 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index da6bbee..f85ed56 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -389,6 +389,14 @@ struct kvm_vcpu_arch {
 	unsigned int hw_tsc_khz;
 	unsigned int time_offset;
 	struct page *time_page;
+
+	struct {
+		u64 msr_val;
+		u64 this_time_out;
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7167717..df9d274 100644
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
@@ -1491,6 +1491,26 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void record_steal_time(struct kvm_vcpu *vcpu)
+{
+	u64 delta;
+
+	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
+		return;
+
+	if (unlikely(kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.st.stime,
+		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time))))
+		return;
+
+	delta = (get_kernel_ns() - vcpu->arch.st.this_time_out);
+
+	vcpu->arch.st.steal.steal += delta;
+	vcpu->arch.st.steal.version += 2;
+
+	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.st.stime,
+		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time));
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	switch (msr) {
@@ -1573,6 +1593,25 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
+	case MSR_KVM_STEAL_TIME:
+		vcpu->arch.st.msr_val = data;
+
+		if (!(data & KVM_MSR_ENABLED)) {
+			break;
+		}
+
+		if (data & KVM_STEAL_RESERVED_MASK)
+			return 1;
+
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.st.stime,
+							data & KVM_STEAL_VALID_BITS))
+			return 1;
+
+		vcpu->arch.st.this_time_out = get_kernel_ns();
+		record_steal_time(vcpu);
+
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
@@ -1858,6 +1897,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_KVM_ASYNC_PF_EN:
 		data = vcpu->arch.apf.msr_val;
 		break;
+	case MSR_KVM_STEAL_TIME:
+		data = vcpu->arch.st.msr_val;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -2169,6 +2211,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
 	}
+
+	record_steal_time(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -2176,6 +2220,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
+	vcpu->arch.st.this_time_out = get_kernel_ns();
 }
 
 static int is_efer_nx(void)
@@ -2489,7 +2534,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
-			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
+			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+			     (1 << KVM_FEATURE_STEAL_TIME);
 		entry->ebx = 0;
 		entry->ecx = 0;
 		entry->edx = 0;
@@ -6209,6 +6255,7 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	vcpu->arch.apf.msr_val = 0;
+	vcpu->arch.st.msr_val = 0;
 
 	kvmclock_reset(vcpu);
 
-- 
1.7.3.4

