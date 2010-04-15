Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0DOSkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:40:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab0DOSjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:39:10 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH 3/5] Try using new kvm clock msrs
Date: Thu, 15 Apr 2010 14:37:26 -0400
Message-Id: <1271356648-5108-4-git-send-email-glommer@redhat.com>
In-Reply-To: <1271356648-5108-3-git-send-email-glommer@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
 <1271356648-5108-3-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now added a new set of clock-related msrs in replacement of the old
ones. In theory, we could just try to use them and get a return value
indicating they do not exist, due to our use of kvm_write_msr_save.

However, kvm clock registration happens very early, and if we ever
try to write to a non-existant MSR, we raise a lethal #GP, since our
idt handlers are not in place yet.

So this patch tests for a cpuid feature exported by the host to
decide which set of msrs are supported.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    4 ++
 arch/x86/kernel/kvmclock.c      |   68 +++++++++++++++++++++++++++------------
 2 files changed, 51 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 0cffb96..a32710a 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -16,6 +16,10 @@
 #define KVM_FEATURE_CLOCKSOURCE		0
 #define KVM_FEATURE_NOP_IO_DELAY	1
 #define KVM_FEATURE_MMU_OP		2
+/* We could just try to use new msr values, but they are queried very early,
+ * kernel does not have idt handlers yet, and failures are fatal */
+#define KVM_FEATURE_CLOCKSOURCE2	3
+
 
 #define MSR_KVM_WALL_CLOCK_OLD  0x11
 #define MSR_KVM_SYSTEM_TIME_OLD 0x12
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index feaeb0d..6d814ce 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -29,6 +29,7 @@
 #define KVM_SCALE 22
 
 static int kvmclock = 1;
+static int kvm_use_new_msrs = 0;
 
 static int parse_no_kvmclock(char *arg)
 {
@@ -41,6 +42,18 @@ early_param("no-kvmclock", parse_no_kvmclock);
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct pvclock_vcpu_time_info, hv_clock);
 static struct pvclock_wall_clock wall_clock;
 
+static int kvm_system_time_write_value(int low, int high)
+{
+	if (kvm_use_new_msrs)
+		return native_write_msr_safe(MSR_KVM_SYSTEM_TIME_OLD, low, high);
+	else
+		return native_write_msr_safe(MSR_KVM_SYSTEM_TIME, low, high);
+}
+
+static void kvm_turnoff_clock(void)
+{
+	kvm_system_time_write_value(0, 0);
+}
 /*
  * The wallclock is the time of day when we booted. Since then, some time may
  * have elapsed since the hypervisor wrote the data. So we try to account for
@@ -54,7 +67,11 @@ static unsigned long kvm_get_wallclock(void)
 
 	low = (int)__pa_symbol(&wall_clock);
 	high = ((u64)__pa_symbol(&wall_clock) >> 32);
-	native_write_msr(MSR_KVM_WALL_CLOCK, low, high);
+
+	if (kvm_use_new_msrs)
+		native_write_msr_safe(MSR_KVM_WALL_CLOCK, low, high);
+	else
+		native_write_msr(MSR_KVM_WALL_CLOCK_OLD, low, high);
 
 	vcpu_time = &get_cpu_var(hv_clock);
 	pvclock_read_wallclock(&wall_clock, vcpu_time, &ts);
@@ -130,7 +147,8 @@ static int kvm_register_clock(char *txt)
 	high = ((u64)__pa(&per_cpu(hv_clock, cpu)) >> 32);
 	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
 	       cpu, high, low, txt);
-	return native_write_msr_safe(MSR_KVM_SYSTEM_TIME, low, high);
+
+	return kvm_system_time_write_value(low, high);
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -165,14 +183,14 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 #ifdef CONFIG_KEXEC
 static void kvm_crash_shutdown(struct pt_regs *regs)
 {
-	native_write_msr_safe(MSR_KVM_SYSTEM_TIME, 0, 0);
+	kvm_turnoff_clock();
 	native_machine_crash_shutdown(regs);
 }
 #endif
 
 static void kvm_shutdown(void)
 {
-	native_write_msr_safe(MSR_KVM_SYSTEM_TIME, 0, 0);
+	kvm_turnoff_clock();
 	native_machine_shutdown();
 }
 
@@ -181,27 +199,35 @@ void __init kvmclock_init(void)
 	if (!kvm_para_available())
 		return;
 
-	if (kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)) {
-		if (kvm_register_clock("boot clock"))
-			return;
-		pv_time_ops.sched_clock = kvm_clock_read;
-		x86_platform.calibrate_tsc = kvm_get_tsc_khz;
-		x86_platform.get_wallclock = kvm_get_wallclock;
-		x86_platform.set_wallclock = kvm_set_wallclock;
+	if (kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2))
+		kvm_use_new_msrs = 1;
+	else if (kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE))
+		kvm_use_new_msrs = 0;
+	else
+		return;
+
+	printk(KERN_INFO "kvm-clock: %ssing clocksource new msrs",
+		kvm_use_new_msrs ? "U": "Not u");
+
+	if (kvm_register_clock("boot clock"))
+		return;
+	pv_time_ops.sched_clock = kvm_clock_read;
+	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
+	x86_platform.get_wallclock = kvm_get_wallclock;
+	x86_platform.set_wallclock = kvm_set_wallclock;
 #ifdef CONFIG_X86_LOCAL_APIC
-		x86_cpuinit.setup_percpu_clockev =
-			kvm_setup_secondary_clock;
+	x86_cpuinit.setup_percpu_clockev =
+		kvm_setup_secondary_clock;
 #endif
 #ifdef CONFIG_SMP
-		smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
+	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
 #endif
-		machine_ops.shutdown  = kvm_shutdown;
+	machine_ops.shutdown  = kvm_shutdown;
 #ifdef CONFIG_KEXEC
-		machine_ops.crash_shutdown  = kvm_crash_shutdown;
+	machine_ops.crash_shutdown  = kvm_crash_shutdown;
 #endif
-		kvm_get_preset_lpj();
-		clocksource_register(&kvm_clock);
-		pv_info.paravirt_enabled = 1;
-		pv_info.name = "KVM";
-	}
+	kvm_get_preset_lpj();
+	clocksource_register(&kvm_clock);
+	pv_info.paravirt_enabled = 1;
+	pv_info.name = "KVM";
 }
-- 
1.6.2.2

