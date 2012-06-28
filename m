Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab2F1GH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:07:59 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37386 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab2F1GHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:07:55 -0400
X-AuditID: b753bd60-996f1ba000000f6c-f1-4febf4b9db76
X-AuditID: b753bd60-996f1ba000000f6c-f1-4febf4b9db76
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 05/18] KVM: Enable/Disable virtualization on slave CPUs
 are activated/dying
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:07:45 +0900
Message-ID: <20120628060745.19298.9699.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
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

 arch/x86/kvm/x86.c  |   20 ++++++++++++++++++++
 virt/kvm/kvm_main.c |   38 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a69c66..9bb2f8f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -61,6 +61,7 @@
 #include <asm/xcr.h>
 #include <asm/pvclock.h>
 #include <asm/div64.h>
+#include <asm/cpu.h>
 
 #define MAX_IO_MSRS 256
 #define KVM_MAX_MCE_BANKS 32
@@ -4769,9 +4770,15 @@ static int kvmclock_cpu_notifier(struct notifier_block *nfb,
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
@@ -4783,12 +4790,20 @@ static struct notifier_block kvmclock_cpu_notifier_block = {
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
+#ifdef CONFIG_SLAVE_CPU
+	register_slave_cpu_notifier(&kvmclock_slave_cpu_notifier_block);
+#endif
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 #ifdef CONFIG_CPU_FREQ
 		struct cpufreq_policy policy;
@@ -4805,6 +4820,8 @@ static void kvm_timer_init(void)
 	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
 	for_each_online_cpu(cpu)
 		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
+	for_each_slave_cpu(cpu)
+		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
 }
 
 static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
@@ -4930,6 +4947,9 @@ void kvm_arch_exit(void)
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
 	unregister_hotcpu_notifier(&kvmclock_cpu_notifier_block);
+#ifdef CONFIG_SLAVE_CPU
+	unregister_slave_cpu_notifier(&kvmclock_slave_cpu_notifier_block);
+#endif
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7e14068..f5890f0 100644
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
@@ -2323,11 +2326,17 @@ static void hardware_disable(void *junk)
 
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
@@ -2340,6 +2349,7 @@ static void hardware_disable_all(void)
 static int hardware_enable_all(void)
 {
 	int r = 0;
+	int cpu;
 
 	raw_spin_lock(&kvm_lock);
 
@@ -2347,6 +2357,9 @@ static int hardware_enable_all(void)
 	if (kvm_usage_count == 1) {
 		atomic_set(&hardware_enable_failed, 0);
 		on_each_cpu(hardware_enable_nolock, NULL, 1);
+		for_each_slave_cpu(cpu)
+			smp_call_function_single(cpu, hardware_enable_nolock,
+						 NULL, 1);
 
 		if (atomic_read(&hardware_enable_failed)) {
 			hardware_disable_all_nolock();
@@ -2370,11 +2383,17 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
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
@@ -2592,6 +2611,12 @@ static struct notifier_block kvm_cpu_notifier = {
 	.notifier_call = kvm_cpu_hotplug,
 };
 
+#ifdef CONFIG_SLAVE_CPU
+static struct notifier_block kvm_slave_cpu_notifier = {
+	.notifier_call = kvm_cpu_hotplug,
+};
+#endif
+
 static int vm_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
@@ -2755,7 +2780,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r < 0)
 		goto out_free_0a;
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, cpu_online_or_slave_mask) {
 		smp_call_function_single(cpu,
 				kvm_arch_check_processor_compat,
 				&r, 1);
@@ -2766,6 +2791,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	r = register_cpu_notifier(&kvm_cpu_notifier);
 	if (r)
 		goto out_free_2;
+#ifdef CONFIG_SLAVE_CPU
+	register_slave_cpu_notifier(&kvm_slave_cpu_notifier);
+#endif
 	register_reboot_notifier(&kvm_reboot_notifier);
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
@@ -2813,6 +2841,9 @@ out_free:
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
+#ifdef CONFIG_SLAVE_CPU
+	unregister_slave_cpu_notifier(&kvm_slave_cpu_notifier);
+#endif
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_2:
 out_free_1:
@@ -2840,6 +2871,9 @@ void kvm_exit(void)
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
+#ifdef CONFIG_SLAVE_CPU
+	unregister_slave_cpu_notifier(&kvm_slave_cpu_notifier);
+#endif
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_arch_hardware_unsetup();


