Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0HTIMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0HTIJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:03 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 25/35] Add clock catchup mode
Date: Thu, 19 Aug 2010 22:07:39 -1000
Message-Id: <1282291669-25709-26-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the clock update handler handle generic clock synchronization,
not just KVM clock.  We add a catchup mode which keeps passthrough
TSC in line with absolute guest TSC.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   55 ++++++++++++++++++++++++++------------
 2 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3a54cc1..ec1dc3a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -343,6 +343,7 @@ struct kvm_vcpu_arch {
 	u64 last_kernel_ns;
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
+	bool tsc_rebase;
 
 	bool nmi_pending;
 	bool nmi_injected;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac0b2d9..a4215d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -927,6 +927,15 @@ static void kvm_arch_set_tsc_khz(struct kvm *kvm, u32 this_tsc_khz)
 	kvm->arch.virtual_tsc_khz = this_tsc_khz;
 }
 
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
@@ -984,22 +993,29 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	unsigned long this_tsc_khz;
 	s64 kernel_ns, max_kernel_ns;
 	u64 tsc_timestamp;
-
-	if ((!vcpu->time_page))
-		return 0;
+	bool catchup = (!vcpu->time_page);
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
 	kernel_ns = getnsboottime();
 	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
-	local_irq_restore(flags);
 
 	if (unlikely(this_tsc_khz == 0)) {
+		local_irq_restore(flags);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 		return 1;
 	}
 
+	if (catchup) {
+		u64 tsc = compute_guest_tsc(v, kernel_ns);
+		if (tsc > tsc_timestamp)
+			kvm_x86_ops->adjust_tsc_offset(v, tsc-tsc_timestamp);
+	}
+	local_irq_restore(flags);
+	if (catchup)
+		return 0;
+
 	/*
 	 * Time as measured by the TSC may go backwards when resetting the base
 	 * tsc_timestamp.  The reason for this is that the TSC resolution is
@@ -1065,14 +1081,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	return 0;
 }
 
-static int kvm_request_guest_time_update(struct kvm_vcpu *v)
+static void kvm_request_clock_update(struct kvm_vcpu *v)
 {
-	struct kvm_vcpu_arch *vcpu = &v->arch;
-
-	if (!vcpu->time_page)
-		return 0;
 	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
-	return 1;
 }
 
 static bool msr_mtrr_valid(unsigned msr)
@@ -1398,6 +1409,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		}
 
 		vcpu->arch.time = data;
+		kvm_request_clock_update(vcpu);
 
 		/* we verify if the enable bit is set... */
 		if (!(data & 1))
@@ -1413,8 +1425,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			kvm_release_page_clean(vcpu->arch.time_page);
 			vcpu->arch.time_page = NULL;
 		}
-
-		kvm_request_guest_time_update(vcpu);
 		break;
 	}
 	case MSR_IA32_MCG_CTL:
@@ -1929,16 +1939,20 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
-	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
+	if (unlikely(vcpu->cpu != cpu) || vcpu->arch.tsc_rebase) {
 		/* Make sure TSC doesn't go backwards */
 		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
 				native_read_tsc() - vcpu->arch.last_host_tsc;
 		if (tsc_delta < 0)
 			mark_tsc_unstable("KVM discovered backwards TSC");
-		if (check_tsc_unstable())
+		if (check_tsc_unstable()) {
 			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
-		kvm_migrate_timers(vcpu);
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		}
+		if (vcpu->cpu != cpu)
+			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
+		vcpu->arch.tsc_rebase = 0;
 	}
 }
 
@@ -1947,6 +1961,12 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	vcpu->arch.last_host_tsc = native_read_tsc();
+
+	/* For unstable TSC, force compensation and catchup on next CPU */
+	if (check_tsc_unstable()) {
+		vcpu->arch.tsc_rebase = 1;
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+	}
 }
 
 static int is_efer_nx(void)
@@ -4307,8 +4327,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (vcpu->cpu != freq->cpu)
 				continue;
-			if (!kvm_request_guest_time_update(vcpu))
-				continue;
+			kvm_request_clock_update(vcpu);
 			if (vcpu->cpu != smp_processor_id())
 				send_ipi = 1;
 		}
@@ -5597,7 +5616,7 @@ int kvm_arch_hardware_enable(void *garbage)
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_for_each_vcpu(i, vcpu, kvm)
 			if (vcpu->cpu == smp_processor_id())
-				kvm_request_guest_time_update(vcpu);
+				kvm_request_clock_update(vcpu);
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
-- 
1.7.1

