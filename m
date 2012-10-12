Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096Ab2JLQve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:51:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:2449 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759935Ab2JLQtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:49:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,577,1344236400"; 
   d="scan'208";a="233264081"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v9 12/12] x86, topology: Debug CPU00 hotplug
Date: Fri, 12 Oct 2012 09:09:49 -0700
Message-Id: <1350058189-6769-13-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

CONFIG_DEBUG_HOTPLUG_CPU0 is for debugging the CPU0 hotplug feature. The switch
offlines CPU0 as soon as possible and boots userspace up with CPU0 offlined.
User can online CPU0 back after boot time. The default value of the switch is
off.

To debug CPU0 hotplug, you need to enable CPU0 offline/online feature by either
turning on CONFIG_BOOTPARAM_HOTPLUG_CPU0 during compilation or giving
cpu0_hotplug kernel parameter at boot.

It's safe and early place to take down CPU0 after all hotplug notifiers
are installed and SMP is booted.

Please note that some applications or drivers, e.g. some versions of udevd,
during boot time may put CPU0 online again in this CPU0 hotplug debug mode.

In this debug mode, setup_local_APIC() may report a warning on max_loops<=0
when CPU0 is onlined back after boot time. This is because pending interrupt in
IRR can not move to ISR. The warning is not CPU0 specfic and it can happen on
other CPUs as well. It is harmless except the first CPU0 online takes a bit
longer time. And so this debug mode is useful to expose this issue. I'll send
a seperate patch to fix this generic warning issue.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/Kconfig           |   15 +++++++++++++
 arch/x86/include/asm/cpu.h |    3 ++
 arch/x86/kernel/topology.c |   51 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/power/cpu.c       |   38 ++++++++++++++++++++++++++++++++
 4 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cf53f0f..1abcae4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1755,6 +1755,21 @@ config BOOTPARAM_HOTPLUG_CPU0
 	  You still can enable the CPU0 hotplug feature at boot by kernel
 	  parameter cpu0_hotplug.
 
+config DEBUG_HOTPLUG_CPU0
+	def_bool n
+	prompt "Debug CPU0 hotplug"
+	depends on HOTPLUG_CPU && EXPERIMENTAL
+	---help---
+	  Enabling this option offlines CPU0 (if CPU0 can be offlined) as
+	  soon as possible and boots up userspace with CPU0 offlined. User
+	  can online CPU0 back after boot time.
+
+	  To debug CPU0 hotplug, you need to enable CPU0 offline/online
+	  feature by either turning on CONFIG_BOOTPARAM_HOTPLUG_CPU0 during
+	  compilation or giving cpu0_hotplug kernel parameter at boot.
+
+	  If unuser, say N.
+
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index a119572..5f9a124 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -29,6 +29,9 @@ struct x86_cpu {
 extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
 extern void __cpuinit start_cpu0(void);
+#ifdef CONFIG_DEBUG_HOTPLUG_CPU0
+extern int _debug_hotplug_cpu(int cpu, int action);
+#endif
 #endif
 
 DECLARE_PER_CPU(int, cpu_state);
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 0e7b4a7..6e60b5f 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -50,6 +50,57 @@ static int __init enable_cpu0_hotplug(char *str)
 __setup("cpu0_hotplug", enable_cpu0_hotplug);
 #endif
 
+#ifdef CONFIG_DEBUG_HOTPLUG_CPU0
+/*
+ * This function offlines a CPU as early as possible and allows userspace to
+ * boot up without the CPU. The CPU can be onlined back by user after boot.
+ *
+ * This is only called for debugging CPU offline/online feature.
+ */
+int __ref _debug_hotplug_cpu(int cpu, int action)
+{
+	struct device *dev = get_cpu_device(cpu);
+	int ret;
+
+	if (!cpu_is_hotpluggable(cpu))
+		return -EINVAL;
+
+	cpu_hotplug_driver_lock();
+
+	switch (action) {
+	case 0:
+		ret = cpu_down(cpu);
+		if (!ret) {
+			pr_info("CPU %u is now offline\n", cpu);
+			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
+		} else
+			pr_debug("Can't offline CPU%d.\n", cpu);
+		break;
+	case 1:
+		ret = cpu_up(cpu);
+		if (!ret)
+			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
+		else
+			pr_debug("Can't online CPU%d.\n", cpu);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	cpu_hotplug_driver_unlock();
+
+	return ret;
+}
+
+static int __init debug_hotplug_cpu(void)
+{
+	_debug_hotplug_cpu(0, 0);
+	return 0;
+}
+
+late_initcall_sync(debug_hotplug_cpu);
+#endif /* CONFIG_DEBUG_HOTPLUG_CPU0 */
+
 int __ref arch_register_cpu(int num)
 {
 	struct cpuinfo_x86 *c = &cpu_data(num);
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index adde775..120cee1 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -21,6 +21,7 @@
 #include <asm/suspend.h>
 #include <asm/debugreg.h>
 #include <asm/fpu-internal.h> /* pcntxt_mask */
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_32
 static struct saved_context saved_context;
@@ -263,6 +264,43 @@ static int bsp_pm_callback(struct notifier_block *nb, unsigned long action,
 	case PM_HIBERNATION_PREPARE:
 		ret = bsp_check();
 		break;
+#ifdef CONFIG_DEBUG_HOTPLUG_CPU0
+	case PM_RESTORE_PREPARE:
+		/*
+		 * When system resumes from hibernation, online CPU0 because
+		 * 1. it's required for resume and
+		 * 2. the CPU was online before hibernation
+		 */
+		if (!cpu_online(0))
+			_debug_hotplug_cpu(0, 1);
+		break;
+	case PM_POST_RESTORE:
+		/*
+		 * When a resume really happens, this code won't be called.
+		 *
+		 * This code is called only when user space hibernation software
+		 * prepares for snapshot device during boot time. So we just
+		 * call _debug_hotplug_cpu() to restore to CPU0's state prior to
+		 * preparing the snapshot device.
+		 *
+		 * This works for normal boot case in our CPU0 hotplug debug
+		 * mode, i.e. CPU0 is offline and user mode hibernation
+		 * software initializes during boot time.
+		 *
+		 * If CPU0 is online and user application accesses snapshot
+		 * device after boot time, this will offline CPU0 and user may
+		 * see different CPU0 state before and after accessing
+		 * the snapshot device. But hopefully this is not a case when
+		 * user debugging CPU0 hotplug. Even if users hit this case,
+		 * they can easily online CPU0 back.
+		 *
+		 * To simplify this debug code, we only consider normal boot
+		 * case. Otherwise we need to remember CPU0's state and restore
+		 * to that state and resolve racy conditions etc.
+		 */
+		_debug_hotplug_cpu(0, 0);
+		break;
+#endif
 	default:
 		break;
 	}
-- 
1.7.2

