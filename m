Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab1KJAve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:51:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:1731 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab1KJAvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:51:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,486,1315206000"; 
   d="scan'208";a="35103411"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan van de Ven" <arjan.van.de.ven@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v3 1/7] x86/topology.c: Support functions for BSP online/offline
Date: Wed,  9 Nov 2011 16:34:11 -0800
Message-Id: <1320885257-16647-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
References: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

By default, BSP can't be hotpluggable because bsp_hotpluggable is 0. Kernel
parameter bsp_hotplug can enable BSP hotplug feature.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/topology.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 76ee977..a3fc939 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -35,18 +35,28 @@
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+static int bsp_hotpluggable;
+
+static int __init enable_bsp_hotplug(char *str)
+{
+	bsp_hotpluggable = 1;
+	return 1;
+}
+
+__setup("bsp_hotplug", enable_bsp_hotplug);
+
 int __ref arch_register_cpu(int num)
 {
 	/*
-	 * CPU0 cannot be offlined due to several
-	 * restrictions and assumptions in kernel. This basically
-	 * doesn't add a control file, one cannot attempt to offline
-	 * BSP.
+	 * Resume from suspend/hibernate depends on BSP. PIC interrupts depend
+	 * on BSP.
 	 *
-	 * Also certain PCI quirks require not to enable hotplug control
-	 * for all CPU's.
+	 * If the BSP depencies are under control, one can tell kernel to
+	 * enable BSP hotplug. This basically adds a control file and
+	 * one can attempt to offline BSP.
 	 */
-	if (num)
+	if (num || bsp_hotpluggable)
 		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
 
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
-- 
1.6.0.3

