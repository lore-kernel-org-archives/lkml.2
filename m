Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2FDFHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:07:06 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45216 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2FDFHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:07:03 -0400
Subject: [PATCH v2 2/7] KVM-HV: Add VCPU running/pre-empted state for guest
To: peterz@infradead.org, mingo@elte.hu, mtosatti@redhat.com, avi@redhat.com
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Date: Mon, 04 Jun 2012 10:36:24 +0530
Message-ID: <20120604050613.4560.97485.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060405-4790-0000-0000-000003115828
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hypervisor code to indicate guest running/pre-empteded status through
msr.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    7 ++++++
 arch/x86/kvm/cpuid.c            |    1 +
 arch/x86/kvm/x86.c              |   45 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dad475b..12fe3c7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -418,6 +418,13 @@ struct kvm_vcpu_arch {
 		struct kvm_steal_time steal;
 	} st;
 
+	/* indicates vcpu is running or preempted */
+	struct {
+		u64 msr_val;
+		struct gfn_to_hva_cache data;
+		struct kvm_vcpu_state vs;
+	} v_state;
+
 	u64 last_guest_tsc;
 	u64 last_kernel_ns;
 	u64 last_host_tsc;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7c93806..0588984 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -409,6 +409,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+			     (1 << KVM_FEATURE_VCPU_STATE) |
 			     (1 << KVM_FEATURE_PV_UNHALT);
 
 		if (sched_info_on())
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e5f57b..264f172 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -789,12 +789,13 @@ EXPORT_SYMBOL_GPL(kvm_rdpmc);
  * kvm-specific. Those are put in the beginning of the list.
  */
 
-#define KVM_SAVE_MSRS_BEGIN	9
+#define KVM_SAVE_MSRS_BEGIN	10
 static u32 msrs_to_save[] = {
 	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
 	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
 	HV_X64_MSR_APIC_ASSIST_PAGE, MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
+	MSR_KVM_VCPU_STATE,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_STAR,
 #ifdef CONFIG_X86_64
@@ -1539,6 +1540,32 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time));
 }
 
+static void kvm_set_vcpu_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_state *vs = &vcpu->arch.v_state.vs;
+	struct gfn_to_hva_cache *ghc = &vcpu->arch.v_state.data;
+
+	if (!(vcpu->arch.v_state.msr_val & KVM_MSR_ENABLED))
+		return;
+
+	vs->state = 1;
+	kvm_write_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
+	smp_wmb();
+}
+
+static void kvm_clear_vcpu_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_state *vs = &vcpu->arch.v_state.vs;
+	struct gfn_to_hva_cache *ghc = &vcpu->arch.v_state.data;
+
+	if (!(vcpu->arch.v_state.msr_val & KVM_MSR_ENABLED))
+		return;
+
+	vs->state = 0;
+	kvm_write_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
+	smp_wmb();
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	bool pr = false;
@@ -1654,6 +1681,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 
 		break;
 
+	case MSR_KVM_VCPU_STATE:
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.v_state.data,
+					      data & KVM_VCPU_STATE_VALID_BITS))
+			return 1;
+
+		vcpu->arch.v_state.msr_val = data;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
@@ -1974,6 +2009,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_KVM_STEAL_TIME:
 		data = vcpu->arch.st.msr_val;
 		break;
+	case MSR_KVM_VCPU_STATE:
+		data = vcpu->arch.v_state.msr_val;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -5324,6 +5362,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_load_guest_fpu(vcpu);
 	kvm_load_guest_xcr0(vcpu);
 
+	kvm_set_vcpu_state(vcpu);
+
 	vcpu->mode = IN_GUEST_MODE;
 
 	/* We should set ->mode before check ->requests,
@@ -5340,6 +5380,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		local_irq_enable();
 		preempt_enable();
 		kvm_x86_ops->cancel_injection(vcpu);
+		kvm_clear_vcpu_state(vcpu);
 		r = 1;
 		goto out;
 	}
@@ -5374,6 +5415,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.last_guest_tsc = kvm_x86_ops->read_l1_tsc(vcpu);
 
+	kvm_clear_vcpu_state(vcpu);
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 	local_irq_enable();
@@ -6029,6 +6071,7 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	vcpu->arch.apf.msr_val = 0;
 	vcpu->arch.st.msr_val = 0;
+	vcpu->arch.v_state.msr_val = 0;
 
 	kvmclock_reset(vcpu);
 

