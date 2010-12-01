Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab0LAG4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:56:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:5632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0LAG4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:56:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="631887845"
Message-Id: <20101201062244.541996375@intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 30 Nov 2010 22:22:28 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>, indou.takao@jp.fujitsu.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org
Subject: [patch 3/4] x86: enable the intr-remap fault handling after local apic setup
References: <20101201062225.292364637@intel.com>
Content-Disposition: inline; filename=vtd_fault_handling_after_local_apic_setup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: x86: enable the intr-remap fault handling after local apic setup

Interrupt-remapping gets enabled very early in the boot, as it determines the
apic mode that the processor can use. And the current code enables the vt-d
fault handling before the setup_local_APIC(). And hence the APIC LDR registers
and data structure in the memory may not be initialized. So the vt-d fault
handling in logical xapic/x2apic modes were broken.

Fix this by enabling the vt-d fault handling in the end_local_APIC_setup()

A cleaner fix of enabling fault handling while enabling intr-remapping
will be addressed for v2.6.38. [ Enabling intr-remapping determines the
usage of x2apic mode and the apic mode determines the fault-handling
configuration. ]

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org [v2.6.32+]
---
 arch/x86/kernel/apic/apic.c     |    8 ++++++++
 arch/x86/kernel/apic/probe_64.c |    7 -------
 2 files changed, 8 insertions(+), 7 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1384,6 +1384,14 @@ void __cpuinit end_local_APIC_setup(void
 #endif
 
 	apic_pm_activate();
+
+	/*
+	 * Now that local APIC setup is completed for BP, configure the fault
+	 * handling for interrupt remapping.
+	 */
+	if (!smp_processor_id() && intr_remapping_enabled)
+		enable_drhd_fault_handling();
+
 }
 
 #ifdef CONFIG_X86_X2APIC
Index: tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/probe_64.c
+++ tip/arch/x86/kernel/apic/probe_64.c
@@ -79,13 +79,6 @@ void __init default_setup_apic_routing(v
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
 	}
-
-	/*
-	 * Now that apic routing model is selected, configure the
-	 * fault handling for intr remapping.
-	 */
-	if (intr_remapping_enabled)
-		enable_drhd_fault_handling();
 }
 
 /* Same for both flat and physical. */


