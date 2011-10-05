Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935132Ab1JEQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:56:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:9204 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935074Ab1JEQzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:55:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,492,1312182000"; 
   d="scan'208";a="23558376"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <lenb@kernel.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 6/8] x86, topology.c: Enable CPU0 online/offline
Date: Wed,  5 Oct 2011 09:39:17 -0700
Message-Id: <1317832759-10223-7-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Enable CPU0 online/offline by setting up its sysfs control file. By default,
this feature is disabled. You can enabled it by bsp_hotplug kernel option.

Resume from hibernate, standby, or suspend needs CPU0 online. According to
arch/x86/kernel/topology.c, some PCI quirks(??) need CPU0 online as well. Anyone
knows which PCI quirks depends on CPU0 online?

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 arch/x86/kernel/topology.c          |   22 +++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 854ed5c..bf011ee 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1805,6 +1805,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
 
+	bsp_hotplug	[X86] BSP (aka CPU0) is hotpluggable.
+			Suspend/resume depends on BSP. It's said some PCI
+			quirks depend on BSP too. But not sure which quirks.
+			If don't care the dependencies, you can turn on
+			bsp_ hotplug. Suspend will fail if BSP is offlined and
+			you need to online BSP before suspend/resume.
+
 	nptcg=		[IA-64] Override max number of concurrent global TLB
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 8927486..ed2da5c 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -34,18 +34,26 @@
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+static int __init enable_bsp_hotplug(char *str)
+{
+	bsp_hotpluggable = 1;
+	return 0;
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
+	 * Suspend/resume depends on BSP. Certain PCI quirks (which PCI
+	 * quirks??) require not to enable hotplug control for all CPU's.
 	 *
-	 * Also certain PCI quirks require not to enable hotplug control
-	 * for all CPU's.
+	 * If one don't care those BSP depencies, tell kernel to
+	 * enable BSP hotplug. This basically adds a control file and
+	 * one can attempt to offline BSP.
 	 */
-	if (num)
+	if (num || bsp_hotpluggable)
 		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
 
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
-- 
1.6.0.3

