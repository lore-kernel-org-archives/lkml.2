Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1A1Tyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:54:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab1A1Txt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:53:49 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH v2 2/6] KVM-HV: KVM Steal time implementation
Date: Fri, 28 Jan 2011 14:52:16 -0500
Message-Id: <1296244340-15173-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1296244340-15173-1-git-send-email-glommer@redhat.com>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
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
 arch/x86/include/asm/kvm_host.h |    6 +++++
 arch/x86/kvm/x86.c              |   48 ++++++++++++++++++++++++++++++++++-----
 include/linux/kvm.h             |    1 +
 3 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffd7f8d..675f7ae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -377,6 +377,12 @@ struct kvm_vcpu_arch {
 	unsigned int hw_tsc_khz;
 	unsigned int time_offset;
 	struct page *time_page;
+
+	gpa_t stime;
+	u32 sversion;
+	u64 time_out;
+	u64 this_time_out;
+
 	u64 last_host_tsc;
 	u64 last_guest_tsc;
 	u64 last_kernel_ns;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38b55b3..0f8a529 100644
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
@@ -1528,16 +1528,23 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		vcpu->arch.time_page =
 				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
 
-		if (is_error_page(vcpu->arch.time_page)) {
-			kvm_release_page_clean(vcpu->arch.time_page);
-			vcpu->arch.time_page = NULL;
-		}
 		break;
 	}
 	case MSR_KVM_ASYNC_PF_EN:
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
+		vcpu->arch.sversion = 0;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
@@ -1817,6 +1824,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_KVM_ASYNC_PF_EN:
 		data = vcpu->arch.apf.msr_val;
 		break;
+	case MSR_KVM_STEAL_TIME:
+		data = vcpu->arch.stime;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -1966,6 +1976,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
+	case KVM_CAP_STEAL_TIME:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2081,6 +2092,9 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	struct kvm_steal_time *st;
+	st = (struct kvm_steal_time *)vcpu->arch.stime;
+
 	/* Address WBINVD may be executed by guest */
 	if (need_emulate_wbinvd(vcpu)) {
 		if (kvm_x86_ops->has_wbinvd_exit())
@@ -2106,6 +2120,25 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
 	}
+
+	if (vcpu->arch.this_time_out) {
+		u64 to = (get_kernel_ns() - vcpu->arch.this_time_out);
+		/*
+		 * using nanoseconds introduces noise, which accumulates easily
+		 * leading to big steal time values. We want, however, to keep the
+		 * interface nanosecond-based for future-proofness.
+		 */
+		to /= NSEC_PER_USEC;
+		to *= NSEC_PER_USEC;
+		vcpu->arch.time_out += to;
+		kvm_write_guest(vcpu->kvm, (gpa_t)&st->steal,
+				&vcpu->arch.time_out, sizeof(st->steal));
+		vcpu->arch.sversion += 2;
+		kvm_write_guest(vcpu->kvm, (gpa_t)&st->version,
+				&vcpu->arch.sversion, sizeof(st->version));
+		/* is it possible to have 2 loads in sequence? */
+		vcpu->arch.this_time_out = 0;
+	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -2113,6 +2146,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	vcpu->arch.last_host_tsc = native_read_tsc();
+	vcpu->arch.this_time_out = get_kernel_ns();
 }
 
 static int is_efer_nx(void)
@@ -5878,6 +5912,8 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	vcpu->arch.apf.msr_val = 0;
 
+	vcpu->arch.stime = 0;
+
 	if (vcpu->arch.time_page) {
 		kvm_release_page_dirty(vcpu->arch.time_page);
 		vcpu->arch.time_page = NULL;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ea2dc1a..1009060 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -541,6 +541,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_GET_PVINFO 57
 #define KVM_CAP_PPC_IRQ_LEVEL 58
 #define KVM_CAP_ASYNC_PF 59
+#define KVM_CAP_STEAL_TIME 60 
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.7.2.3

