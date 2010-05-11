Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0EKQVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:21:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab0EKQV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:21:27 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH 6/9] Try using new kvm clock msrs
Date: Tue, 11 May 2010 12:17:44 -0400
Message-Id: <1273594667-17175-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1273594667-17175-6-git-send-email-glommer@redhat.com>
References: <1273594667-17175-1-git-send-email-glommer@redhat.com>
 <1273594667-17175-2-git-send-email-glommer@redhat.com>
 <1273594667-17175-3-git-send-email-glommer@redhat.com>
 <1273594667-17175-4-git-send-email-glommer@redhat.com>
 <1273594667-17175-5-git-send-email-glommer@redhat.com>
 <1273594667-17175-6-git-send-email-glommer@redhat.com>
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
 arch/x86/kernel/kvmclock.c |   53 ++++++++++++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index feaeb0d..59c740f 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -29,6 +29,8 @@
 #define KVM_SCALE 22
 
 static int kvmclock = 1;
+static int msr_kvm_system_time = MSR_KVM_SYSTEM_TIME;
+static int msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK;
 
 static int parse_no_kvmclock(char *arg)
 {
@@ -54,7 +56,8 @@ static unsigned long kvm_get_wallclock(void)
 
 	low = (int)__pa_symbol(&wall_clock);
 	high = ((u64)__pa_symbol(&wall_clock) >> 32);
-	native_write_msr(MSR_KVM_WALL_CLOCK, low, high);
+
+	native_write_msr(msr_kvm_wall_clock, low, high);
 
 	vcpu_time = &get_cpu_var(hv_clock);
 	pvclock_read_wallclock(&wall_clock, vcpu_time, &ts);
@@ -130,7 +133,8 @@ static int kvm_register_clock(char *txt)
 	high = ((u64)__pa(&per_cpu(hv_clock, cpu)) >> 32);
 	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
 	       cpu, high, low, txt);
-	return native_write_msr_safe(MSR_KVM_SYSTEM_TIME, low, high);
+
+	return native_write_msr_safe(msr_kvm_system_time, low, high);
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -165,14 +169,14 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 #ifdef CONFIG_KEXEC
 static void kvm_crash_shutdown(struct pt_regs *regs)
 {
-	native_write_msr_safe(MSR_KVM_SYSTEM_TIME, 0, 0);
+	native_write_msr(msr_kvm_system_time, 0, 0);
 	native_machine_crash_shutdown(regs);
 }
 #endif
 
 static void kvm_shutdown(void)
 {
-	native_write_msr_safe(MSR_KVM_SYSTEM_TIME, 0, 0);
+	native_write_msr(msr_kvm_system_time, 0, 0);
 	native_machine_shutdown();
 }
 
@@ -181,27 +185,34 @@ void __init kvmclock_init(void)
 	if (!kvm_para_available())
 		return;
 
-	if (kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)) {
-		if (kvm_register_clock("boot clock"))
-			return;
-		pv_time_ops.sched_clock = kvm_clock_read;
-		x86_platform.calibrate_tsc = kvm_get_tsc_khz;
-		x86_platform.get_wallclock = kvm_get_wallclock;
-		x86_platform.set_wallclock = kvm_set_wallclock;
+	if (kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
+		msr_kvm_system_time = MSR_KVM_SYSTEM_TIME_NEW;
+		msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK_NEW;
+	} else if (!(kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)))
+		return;
+
+	printk(KERN_INFO "kvm-clock: Using msrs %x and %x",
+		msr_kvm_system_time, msr_kvm_wall_clock);
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

