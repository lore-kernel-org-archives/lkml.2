Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2BGOxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:53:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab2BGOxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:53:44 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, jacob.jun.pan@linux.intel.com, alan@linux.intel.com,
        feng.tang@intel.com, konrad.wilk@oracle.com, avi@redhat.com,
        glommer@redhat.com, johnstul@us.ibm.com, riel@redhat.com,
        tj@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org
Subject: [PATCH] Introduce x86_cpuinit.early_percpu_clock_init hook
Date: Tue,  7 Feb 2012 15:52:44 +0100
Message-Id: <1328626364-22591-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kvm guest uses kvmclock, it may hang on vcpu hot-plug.
This is caused by an overflow in pvclock_get_nsec_offset,

    u64 delta = tsc - shadow->tsc_timestamp;

which in turn is caused by an undefined values from percpu
hv_clock that hasn't been initialized yet.
Uninitialized clock on being booted cpu is accessed from
   start_secondary
    -> smp_callin
      ->  smp_store_cpu_info
        -> identify_secondary_cpu
          -> mtrr_ap_init
            -> mtrr_restore
              -> stop_machine_from_inactive_cpu
                -> queue_stop_cpus_work
                  ...
                    -> sched_clock
                      -> kvm_clock_read
which is well before x86_cpuinit.setup_percpu_clockev call in
start_secondary, where percpu clock is initialized.

This patch introduces a hook that allows to setup/initialize
per_cpu clock early and avoid overflow due to reading
  - undefined values
  - old values if cpu was offlined and then onlined again

Another possible early user of this clock source is ftrace that
accesses it to get timestamps for ring buffer entries. So if
mtrr_ap_init is moved from identify_secondary_cpu to past
x86_cpuinit.setup_percpu_clockev in start_secondary, ftrace
may cause the same overflow/hang on cpu hot-plug anyway.

More complete description of the problem:
  https://lkml.org/lkml/2012/2/2/101

Credits to Marcelo Tosatti <mtosatti@redhat.com> for hook idea.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/kvmclock.c      |    4 +---
 arch/x86/kernel/smpboot.c       |    1 +
 arch/x86/kernel/x86_init.c      |    1 +
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 517d476..5d0afac 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -145,9 +145,11 @@ struct x86_init_ops {
 /**
  * struct x86_cpuinit_ops - platform specific cpu hotplug setups
  * @setup_percpu_clockev:	set up the per cpu clock event device
+ * @early_percpu_clock_init:	early init of the per cpu clock event device
  */
 struct x86_cpuinit_ops {
 	void (*setup_percpu_clockev)(void);
+	void (*early_percpu_clock_init)(void);
 	void (*fixup_cpu_id)(struct cpuinfo_x86 *c, int node);
 };
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 44842d7..ca4e735 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -144,8 +144,6 @@ static void __cpuinit kvm_setup_secondary_clock(void)
 	 * we shouldn't fail.
 	 */
 	WARN_ON(kvm_register_clock("secondary cpu clock"));
-	/* ok, done with our trickery, call native */
-	setup_secondary_APIC_clock();
 }
 #endif
 
@@ -194,7 +192,7 @@ void __init kvmclock_init(void)
 	x86_platform.get_wallclock = kvm_get_wallclock;
 	x86_platform.set_wallclock = kvm_set_wallclock;
 #ifdef CONFIG_X86_LOCAL_APIC
-	x86_cpuinit.setup_percpu_clockev =
+	x86_cpuinit.early_percpu_clock_init =
 		kvm_setup_secondary_clock;
 #endif
 	machine_ops.shutdown  = kvm_shutdown;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..a05d6fd 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -255,6 +255,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 * most necessary things.
 	 */
 	cpu_init();
+	x86_cpuinit.early_percpu_clock_init();
 	preempt_disable();
 	smp_callin();
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 947a06c..6f2ec53 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -91,6 +91,7 @@ struct x86_init_ops x86_init __initdata = {
 };
 
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
+	.early_percpu_clock_init	= x86_init_noop,
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
 	.fixup_cpu_id			= x86_default_fixup_cpu_id,
 };
-- 
1.7.7.6

