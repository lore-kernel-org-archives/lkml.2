Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695Ab2AKRYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:24:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:1574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757865Ab2AKRYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:24:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106055483"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan van de Ven" <arjan.van.de.ven@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 12/12] x86/topology.c: debug CPU0 hotplug
Date: Wed, 11 Jan 2012 09:04:53 -0800
Message-Id: <1326301493-28760-13-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

CONFIG_DEBUG_HOTPLUG_CPU0 is for debuging the CPU0 hotplug feature. The switch
offlines CPU0 as soon as possible and boots userspace up with CPU0 offlined.
User can online CPU0 back after boot time. The default value of the switch is
off.

To debug CPU0 hotplug, you need to enable CPU0 offline/online feature by either
turning on CONFIG_BOOTPARAM_HOTPLUG_CPU0 during compilation or giving
cpu0_hotplug kernel parameter at boot.

It's safe and early place to take down CPU0 after all hotplug notifiers
are installed and SMP is booted.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/Kconfig           |   15 +++++++++++++++
 arch/x86/kernel/topology.c |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c2cf195..36b6a2c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1748,6 +1748,21 @@ config BOOTPARAM_HOTPLUG_CPU0
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
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 8cec15c..3f697dd 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -49,6 +49,45 @@ static int __init enable_cpu0_hotplug(char *str)
 __setup("cpu0_hotplug", enable_cpu0_hotplug);
 #endif
 
+#ifdef CONFIG_DEBUG_HOTPLUG_CPU0
+/*
+ * This function offlines CPU0 as early as possible and allows userspace to
+ * boot up without CPU0. CPU0 can be onlined back by user after boot.
+ *
+ * This is only called for debugging CPU0 offline feature.
+ */
+static void __init _debug_hotplug_cpu(int num)
+{
+	int ret;
+	struct sys_device *dev = get_cpu_sysdev(num);
+
+	/*
+	 * Take hotpluggable online CPU0 down.
+	 */
+	if (num || !per_cpu(cpu_devices, num).cpu.hotpluggable || !dev ||
+	    !cpu_online(num)) {
+		pr_debug("CPU0 can't be offlined.\n");
+		return;
+	}
+
+	cpu_hotplug_driver_lock();
+
+	ret = cpu_down(num);
+	if (!ret)
+		kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
+	else
+		pr_debug("Can't offline CPU%d.\n", num);
+
+	cpu_hotplug_driver_unlock();
+}
+static int __init debug_hotplug_cpu(void)
+{
+	_debug_hotplug_cpu(0);
+	return 0;
+}
+device_initcall_sync(debug_hotplug_cpu);
+#endif /* CONFIG_DEBUG_HOTPLUG_CPU0 */
+
 int __ref arch_register_cpu(int num)
 {
 	/*
-- 
1.6.0.3

