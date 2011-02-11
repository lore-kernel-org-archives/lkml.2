Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1BKSVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:21:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab1BKSVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:21:24 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH v3 2/6] KVM-HV: KVM Steal time implementation
Date: Fri, 11 Feb 2011 13:19:20 -0500
Message-Id: <1297448364-14051-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1297448364-14051-1-git-send-email-glommer@redhat.com>
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>
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
---
 arch/x86/include/asm/kvm_host.h |    5 +++++
 arch/x86/kvm/x86.c              |   39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffd7f8d..be6e0e2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -377,6 +377,11 @@ struct kvm_vcpu_arch {
 	unsigned int hw_tsc_khz;
 	unsigned int time_offset;
 	struct page *time_page;
+
+	gpa_t stime;
+	struct kvm_steal_time steal;
+	u64 this_time_out;
+
 	u64 last_host_tsc;
 	u64 last_guest_tsc;
 	u64 last_kernel_ns;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a326cb..7f14900 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -787,12 +787,12 @@ EXPORT_SYMBOL_GPL(kvm_get_dr);
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
@@ -1546,6 +1546,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
+	case MSR_KVM_STEAL_TIME:
+
+		if (!(data & 1)) {
+			vcpu->arch.stime = 0;
+			break;
+		}
+
+		vcpu->arch.stime = data & ~1;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
@@ -1831,6 +1841,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_KVM_ASYNC_PF_EN:
 		data = vcpu->arch.apf.msr_val;
 		break;
+	case MSR_KVM_STEAL_TIME:
+		data = vcpu->arch.stime;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -1993,6 +2006,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
+	case KVM_CAP_STEAL_TIME:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2108,6 +2122,9 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	struct kvm_steal_time *st;
+	st = (struct kvm_steal_time *)vcpu->arch.stime;
+
 	/* Address WBINVD may be executed by guest */
 	if (need_emulate_wbinvd(vcpu)) {
 		if (kvm_x86_ops->has_wbinvd_exit())
@@ -2133,6 +2150,21 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
 	}
+
+	if (vcpu->arch.this_time_out) {
+		u64 to = (get_kernel_ns() - vcpu->arch.this_time_out);
+
+		kvm_read_guest(vcpu->kvm, (gpa_t)st, &vcpu->arch.steal,
+				sizeof(*st));
+
+		vcpu->arch.steal.steal += to;
+		vcpu->arch.steal.version += 2;
+
+		kvm_write_guest(vcpu->kvm, (gpa_t)st, &vcpu->arch.steal,
+				sizeof(*st));
+		/* is it possible to have 2 loads in sequence? */
+		vcpu->arch.this_time_out = 0;
+	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -2140,6 +2172,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	vcpu->arch.last_host_tsc = native_read_tsc();
+	vcpu->arch.this_time_out = get_kernel_ns();
 }
 
 static int is_efer_nx(void)
@@ -5882,6 +5915,8 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	kvmclock_reset(vcpu);
 
+	vcpu->arch.stime = 0;
+
 	kvm_clear_async_pf_completion_queue(vcpu);
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
-- 
1.7.2.3

