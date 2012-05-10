Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2EJQdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:33:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:27165 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab2EJQ2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:28:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142389128"
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
Subject: [PATCH v6 03/12] x86/topology.c: Support functions for CPU0 online/offline
Date: Thu, 10 May 2012 09:16:45 -0700
Message-Id: <1336666614-21090-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

If CONFIG_BOOTPARAM_HOTPLUG_CPU is turned on, CPU0 hotplug feature is enabled
by default.

If CONFIG_BOOTPARAM_HOTPLUG_CPU is not turned on, CPU0 hotplug feature is not
enabled by default. The kernel parameter cpu0_hotplug can enable CPU0 hotplug
feature at boot.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/topology.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 76ee977..8cec15c 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -35,18 +35,31 @@
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+#ifdef CONFIG_BOOTPARAM_HOTPLUG_CPU0
+static int __initdata cpu0_hotpluggable = 1;
+#else
+static int __initdata cpu0_hotpluggable;
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
+	if (num || cpu0_hotpluggable)
 		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
 
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
-- 
1.6.0.3

