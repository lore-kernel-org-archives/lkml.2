Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab2JLQty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:49:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:10139 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759857Ab2JLQtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:49:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,577,1344236400"; 
   d="scan'208";a="233264043"
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
Subject: [PATCH v9 03/12] x86, topology: Don't offline CPU0 if any PIC irq can not be migrated out of it
Date: Fri, 12 Oct 2012 09:09:40 -0700
Message-Id: <1350058189-6769-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

If CONFIG_BOOTPARAM_HOTPLUG_CPU is turned on, CPU0 hotplug feature is enabled
by default.

If CONFIG_BOOTPARAM_HOTPLUG_CPU is not turned on, CPU0 hotplug feature is not
enabled by default. The kernel parameter cpu0_hotplug can enable CPU0 hotplug
feature at boot.

Currently the feature is supported on Intel platforms only.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/topology.c |   50 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 76ee977..0e7b4a7 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -30,23 +30,59 @@
 #include <linux/mmzone.h>
 #include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 #include <asm/cpu.h>
 
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+#ifdef CONFIG_BOOTPARAM_HOTPLUG_CPU0
+static int cpu0_hotpluggable = 1;
+#else
+static int cpu0_hotpluggable;
+static int __init enable_cpu0_hotplug(char *str)
+{
+	cpu0_hotpluggable = 1;
+	return 1;
+}
+
+__setup("cpu0_hotplug", enable_cpu0_hotplug);
+#endif
+
 int __ref arch_register_cpu(int num)
 {
+	struct cpuinfo_x86 *c = &cpu_data(num);
+
+	/*
+	 * Currently CPU0 is only hotpluggable on Intel platforms. Other
+	 * vendors can add hotplug support later.
+	 */
+	if (c->x86_vendor != X86_VENDOR_INTEL)
+		cpu0_hotpluggable = 0;
+
 	/*
-	 * CPU0 cannot be offlined due to several
-	 * restrictions and assumptions in kernel. This basically
-	 * doesn't add a control file, one cannot attempt to offline
-	 * BSP.
+	 * Two known BSP/CPU0 dependencies: Resume from suspend/hibernate
+	 * depends on BSP. PIC interrupts depend on BSP.
 	 *
-	 * Also certain PCI quirks require not to enable hotplug control
-	 * for all CPU's.
+	 * If the BSP depencies are under control, one can tell kernel to
+	 * enable BSP hotplug. This basically adds a control file and
+	 * one can attempt to offline BSP.
 	 */
-	if (num)
+	if (num == 0 && cpu0_hotpluggable) {
+		unsigned int irq;
+		/*
+		 * We won't take down the boot processor on i386 if some
+		 * interrupts only are able to be serviced by the BSP in PIC.
+		 */
+		for_each_active_irq(irq) {
+			if (!IO_APIC_IRQ(irq) && irq_has_action(irq)) {
+				cpu0_hotpluggable = 0;
+				break;
+			}
+		}
+	}
+	if (num || cpu0_hotpluggable)
 		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
 
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
-- 
1.7.2

