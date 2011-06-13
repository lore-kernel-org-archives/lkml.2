Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1FMXj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:39:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab1FMXjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:39:11 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 7/7] KVM-GST: KVM Steal time registration
Date: Mon, 13 Jun 2011 19:31:37 -0400
Message-Id: <1308007897-17013-8-git-send-email-glommer@redhat.com>
In-Reply-To: <1308007897-17013-1-git-send-email-glommer@redhat.com>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
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
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 Documentation/kernel-parameters.txt |    4 ++
 arch/x86/include/asm/kvm_para.h     |    1 +
 arch/x86/kernel/kvm.c               |   72 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kvmclock.c          |    2 +
 4 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd248a31..a722574 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1737,6 +1737,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	no-kvmapf	[X86,KVM] Disable paravirtualized asynchronous page
 			fault handling.
 
+	no-steal-acc    [X86,KVM] Disable paravirtualized steal time accounting.
+			steal time is computed, but won't influence scheduler
+			behaviour
+
 	nolapic		[X86-32,APIC] Do not enable or use the local APIC.
 
 	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 0341e61..2a8f2a5 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -94,6 +94,7 @@ struct kvm_vcpu_pv_apf_data {
 
 extern void kvmclock_init(void);
 extern int kvm_register_clock(char *txt);
+extern void kvm_disable_steal_time(void);
 
 
 /* This instruction is vmcall.  On non-VT architectures, it will generate a
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 33c07b0..5a5ac19 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -51,6 +51,15 @@ static int parse_no_kvmapf(char *arg)
 
 early_param("no-kvmapf", parse_no_kvmapf);
 
+static int steal_acc = 1;
+static int parse_no_stealacc(char *arg)
+{
+        steal_acc = 0;
+        return 0;
+}
+
+early_param("no-steal-acc", parse_no_stealacc);
+
 struct kvm_para_state {
 	u8 mmu_queue[MMU_QUEUE_SIZE];
 	int mmu_queue_len;
@@ -58,6 +67,8 @@ struct kvm_para_state {
 
 static DEFINE_PER_CPU(struct kvm_para_state, para_state);
 static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
+static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
+static int has_steal_clock = 0;
 
 static struct kvm_para_state *kvm_para_state(void)
 {
@@ -483,23 +494,66 @@ static struct notifier_block kvm_pv_reboot_nb = {
 	.notifier_call = kvm_pv_reboot_notify,
 };
 
+static void kvm_register_steal_time(void)
+{
+	int cpu = smp_processor_id();
+	struct kvm_steal_time *st = &per_cpu(steal_time, cpu);
+
+	if (!has_steal_clock)
+		return;
+
+	memset(st, 0, sizeof(*st));
+
+	wrmsrl(MSR_KVM_STEAL_TIME, (__pa(st) | KVM_MSR_ENABLED));
+	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %lx\n",
+		cpu, __pa(st));
+}
+
+static u64 kvm_steal_clock(int cpu)
+{
+	u64 steal;
+	struct kvm_steal_time *src;
+	int version;
+
+	src = &per_cpu(steal_time, cpu);
+	do {
+		version = src->version;
+		rmb();
+		steal = src->steal;
+		rmb();
+	} while ((version & 1) || (version != src->version));
+
+	return steal;
+}
+
 #ifdef CONFIG_SMP
 static void __init kvm_smp_prepare_boot_cpu(void)
 {
 #ifdef CONFIG_KVM_CLOCK
 	WARN_ON(kvm_register_clock("primary cpu clock"));
 #endif
+	kvm_register_steal_time();
 	kvm_guest_cpu_init();
 	native_smp_prepare_boot_cpu();
 }
 
 static void __cpuinit kvm_guest_cpu_online(void *dummy)
 {
+	kvm_register_steal_time();
 	kvm_guest_cpu_init();
 }
 
+void kvm_disable_steal_time(void)
+{
+	if (!has_steal_clock)
+		return;
+
+	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
+}
+
 static void kvm_guest_cpu_offline(void *dummy)
 {
+	kvm_disable_steal_time();
 	kvm_pv_disable_apf(NULL);
 	apf_task_wake_all();
 }
@@ -548,6 +602,11 @@ void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
 		x86_init.irqs.trap_init = kvm_apf_trap_init;
 
+	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+		has_steal_clock = 1;
+		pv_time_ops.steal_clock = kvm_steal_clock;
+	}
+
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
 	register_cpu_notifier(&kvm_cpu_notifier);
@@ -555,3 +614,16 @@ void __init kvm_guest_init(void)
 	kvm_guest_cpu_init();
 #endif
 }
+
+static __init int activate_jump_labels(void)
+{
+	if (has_steal_clock) {
+		jump_label_inc(&paravirt_steal_enabled);
+		if (steal_acc)
+			jump_label_inc(&paravirt_steal_rq_enabled);
+	}
+
+	return 0;
+}
+arch_initcall(activate_jump_labels);
+
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 6389a6b..c1a0188 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -160,6 +160,7 @@ static void __cpuinit kvm_setup_secondary_clock(void)
 static void kvm_crash_shutdown(struct pt_regs *regs)
 {
 	native_write_msr(msr_kvm_system_time, 0, 0);
+	kvm_disable_steal_time();
 	native_machine_crash_shutdown(regs);
 }
 #endif
@@ -167,6 +168,7 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
 static void kvm_shutdown(void)
 {
 	native_write_msr(msr_kvm_system_time, 0, 0);
+	kvm_disable_steal_time();
 	native_machine_shutdown();
 }
 
-- 
1.7.3.4

