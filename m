Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2IFLi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:38:56 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59514 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2IFLau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:30:50 -0400
X-AuditID: b753bd60-97ddaba000000c4c-68-504888b83080
X-AuditID: b753bd60-97ddaba000000c4c-68-504888b83080
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 05/21] KVM: Enable/Disable virtualization on slave CPUs
 are activated/dying
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:27:45 +0900
Message-ID: <20120906112745.13320.74240.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable virtualization when slave CPUs are activated, and disable when
the CPUs are dying using slave CPU notifier call chain.

In x86, TSC kHz must also be initialized by tsc_khz_changed when the
new slave CPUs are activated.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kvm/x86.c  |   16 ++++++++++++++++
 virt/kvm/kvm_main.c |   30 ++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 148ed66..7501cc4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -61,6 +61,7 @@
 #include <asm/xcr.h>
 #include <asm/pvclock.h>
 #include <asm/div64.h>
+#include <asm/cpu.h>
 
 #define MAX_IO_MSRS 256
 #define KVM_MAX_MCE_BANKS 32
@@ -4782,9 +4783,15 @@ static int kvmclock_cpu_notifier(struct notifier_block *nfb,
 	switch (action) {
 		case CPU_ONLINE:
 		case CPU_DOWN_FAILED:
+#ifdef CONFIG_SLAVE_CPU
+		case CPU_SLAVE_UP:
+#endif
 			smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
 			break;
 		case CPU_DOWN_PREPARE:
+#ifdef CONFIG_SLAVE_CPU
+		case CPU_SLAVE_DYING:
+#endif
 			smp_call_function_single(cpu, tsc_bad, NULL, 1);
 			break;
 	}
@@ -4796,12 +4803,18 @@ static struct notifier_block kvmclock_cpu_notifier_block = {
 	.priority = -INT_MAX
 };
 
+static struct notifier_block kvmclock_slave_cpu_notifier_block = {
+	.notifier_call  = kvmclock_cpu_notifier,
+	.priority = -INT_MAX
+};
+
 static void kvm_timer_init(void)
 {
 	int cpu;
 
 	max_tsc_khz = tsc_khz;
 	register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
+	register_slave_cpu_notifier(&kvmclock_slave_cpu_notifier_block);
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 #ifdef CONFIG_CPU_FREQ
 		struct cpufreq_policy policy;
@@ -4818,6 +4831,8 @@ static void kvm_timer_init(void)
 	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
 	for_each_online_cpu(cpu)
 		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
+	for_each_slave_cpu(cpu)
+		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
 }
 
 static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
@@ -4943,6 +4958,7 @@ void kvm_arch_exit(void)
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
 	unregister_hotcpu_notifier(&kvmclock_cpu_notifier_block);
+	unregister_slave_cpu_notifier(&kvmclock_slave_cpu_notifier_block);
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d617f69..dc86e9a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -54,6 +54,9 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
+#ifdef CONFIG_X86
+#include <asm/cpu.h>
+#endif
 
 #include "coalesced_mmio.h"
 #include "async_pf.h"
@@ -2336,11 +2339,17 @@ static void hardware_disable(void *junk)
 
 static void hardware_disable_all_nolock(void)
 {
+	int cpu;
+
 	BUG_ON(!kvm_usage_count);
 
 	kvm_usage_count--;
-	if (!kvm_usage_count)
+	if (!kvm_usage_count) {
 		on_each_cpu(hardware_disable_nolock, NULL, 1);
+		for_each_slave_cpu(cpu)
+			smp_call_function_single(cpu, hardware_disable_nolock,
+						 NULL, 1);
+	}
 }
 
 static void hardware_disable_all(void)
@@ -2353,6 +2362,7 @@ static void hardware_disable_all(void)
 static int hardware_enable_all(void)
 {
 	int r = 0;
+	int cpu;
 
 	raw_spin_lock(&kvm_lock);
 
@@ -2360,6 +2370,9 @@ static int hardware_enable_all(void)
 	if (kvm_usage_count == 1) {
 		atomic_set(&hardware_enable_failed, 0);
 		on_each_cpu(hardware_enable_nolock, NULL, 1);
+		for_each_slave_cpu(cpu)
+			smp_call_function_single(cpu, hardware_enable_nolock,
+						 NULL, 1);
 
 		if (atomic_read(&hardware_enable_failed)) {
 			hardware_disable_all_nolock();
@@ -2383,11 +2396,17 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	val &= ~CPU_TASKS_FROZEN;
 	switch (val) {
 	case CPU_DYING:
+#ifdef CONFIG_SLAVE_CPU
+	case CPU_SLAVE_DYING:
+#endif
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
 		hardware_disable(NULL);
 		break;
 	case CPU_STARTING:
+#ifdef CONFIG_SLAVE_CPU
+	case CPU_SLAVE_UP:
+#endif
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
 		hardware_enable(NULL);
@@ -2605,6 +2624,10 @@ static struct notifier_block kvm_cpu_notifier = {
 	.notifier_call = kvm_cpu_hotplug,
 };
 
+static struct notifier_block kvm_slave_cpu_notifier = {
+	.notifier_call = kvm_cpu_hotplug,
+};
+
 static int vm_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
@@ -2768,7 +2791,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r < 0)
 		goto out_free_0a;
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, cpu_online_or_slave_mask) {
 		smp_call_function_single(cpu,
 				kvm_arch_check_processor_compat,
 				&r, 1);
@@ -2779,6 +2802,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	r = register_cpu_notifier(&kvm_cpu_notifier);
 	if (r)
 		goto out_free_2;
+	register_slave_cpu_notifier(&kvm_slave_cpu_notifier);
 	register_reboot_notifier(&kvm_reboot_notifier);
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
@@ -2826,6 +2850,7 @@ out_free:
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
+	unregister_slave_cpu_notifier(&kvm_slave_cpu_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_2:
 out_free_1:
@@ -2853,6 +2878,7 @@ void kvm_exit(void)
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
+	unregister_slave_cpu_notifier(&kvm_slave_cpu_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_arch_hardware_unsetup();


