Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1A1TyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:54:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433Ab1A1Txu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:53:50 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH v2 4/6] KVM-GST: KVM Steal time registration
Date: Fri, 28 Jan 2011 14:52:18 -0500
Message-Id: <1296244340-15173-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1296244340-15173-1-git-send-email-glommer@redhat.com>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register steal time within KVM. Everytime we sample the steal time
information, we update a local variable that tells what was the
last time read. We then account the difference.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    1 +
 arch/x86/kernel/kvm.c           |   61 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kvmclock.c      |    2 +
 3 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 8ba33ed..8210122 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -89,6 +89,7 @@ struct kvm_vcpu_pv_apf_data {
 
 extern void kvmclock_init(void);
 extern int kvm_register_clock(char *txt);
+extern int kvm_register_steal_time(void);
 
 
 /* This instruction is vmcall.  On non-VT architectures, it will generate a
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 33c07b0..30c0fa7 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -58,6 +58,8 @@ struct kvm_para_state {
 
 static DEFINE_PER_CPU(struct kvm_para_state, para_state);
 static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct kvm_steal_time, steal_time);
+static DEFINE_PER_CPU(u64, steal_info);
 
 static struct kvm_para_state *kvm_para_state(void)
 {
@@ -489,18 +491,21 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 #ifdef CONFIG_KVM_CLOCK
 	WARN_ON(kvm_register_clock("primary cpu clock"));
 #endif
+	WARN_ON(kvm_register_steal_time());
 	kvm_guest_cpu_init();
 	native_smp_prepare_boot_cpu();
 }
 
 static void __cpuinit kvm_guest_cpu_online(void *dummy)
 {
+	WARN_ON(kvm_register_steal_time());
 	kvm_guest_cpu_init();
 }
 
 static void kvm_guest_cpu_offline(void *dummy)
 {
 	kvm_pv_disable_apf(NULL);
+	native_write_msr(MSR_KVM_STEAL_TIME, 0, 0);
 	apf_task_wake_all();
 }
 
@@ -534,6 +539,59 @@ static void __init kvm_apf_trap_init(void)
 	set_intr_gate(14, &async_page_fault);
 }
 
+static u64 kvm_account_steal_time(void)
+{
+	u64 delta = 0;
+	u64 *last_steal_info, this_steal_info;
+	struct kvm_steal_time *src;
+	int version;
+
+	src = &get_cpu_var(steal_time);
+	do {
+		version = src->version;
+		rmb();
+		this_steal_info = src->steal;
+		rmb();
+	} while ((src->version & 1) || (version != src->version));
+	put_cpu_var(steal_time);
+
+	last_steal_info = &get_cpu_var(steal_info);
+
+	if (likely(*last_steal_info))
+		delta = this_steal_info - *last_steal_info;
+	*last_steal_info = this_steal_info;
+
+	put_cpu_var(steal_info);
+
+	/*
+	 * using nanoseconds introduces noise, which accumulates easily
+	 * leading to big steal time values. We want, however, to keep the
+	 * interface nanosecond-based for future-proofness. The hypervisor may
+	 * adopt a similar strategy, but we can't rely on that.
+	 */
+	delta /= NSEC_PER_MSEC;
+	delta *= NSEC_PER_MSEC;
+
+	return delta;
+}
+
+
+int kvm_register_steal_time(void)
+{
+	int cpu = smp_processor_id();
+	int low, high, ret;
+
+	if (!hypervisor_steal_time)
+		return 0;
+
+	low = (int)__pa(&per_cpu(steal_time, cpu)) | 1;
+	high = ((u64)__pa(&per_cpu(steal_time, cpu)) >> 32);
+	ret = native_write_msr_safe(MSR_KVM_STEAL_TIME, low, high);
+	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %x:%x\n",
+		cpu, high, low);
+	return ret;
+}
+
 void __init kvm_guest_init(void)
 {
 	int i;
@@ -548,6 +606,9 @@ void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
 		x86_init.irqs.trap_init = kvm_apf_trap_init;
 
+	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))
+		hypervisor_steal_time = kvm_account_steal_time;
+
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
 	register_cpu_notifier(&kvm_cpu_notifier);
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index f98d3ea..08661c6 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -164,6 +164,7 @@ static void __cpuinit kvm_setup_secondary_clock(void)
 static void kvm_crash_shutdown(struct pt_regs *regs)
 {
 	native_write_msr(msr_kvm_system_time, 0, 0);
+	native_write_msr(MSR_KVM_STEAL_TIME, 0, 0);
 	native_machine_crash_shutdown(regs);
 }
 #endif
@@ -171,6 +172,7 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
 static void kvm_shutdown(void)
 {
 	native_write_msr(msr_kvm_system_time, 0, 0);
+	native_write_msr(MSR_KVM_STEAL_TIME, 0, 0);
 	native_machine_shutdown();
 }
 
-- 
1.7.2.3

