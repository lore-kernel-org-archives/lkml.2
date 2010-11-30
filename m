Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0K3Ib1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:31:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58002 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab0K3Ib0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:31:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CF4B628.7060903@jp.fujitsu.com>
Date: Tue, 30 Nov 2010 17:30:32 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        suresh.b.siddha@intel.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org, indou.takao@jp.fujitsu.com
Subject: [PATCH 1/2] dmar: fix fault interrupt setup
References: <4CF4B597.4030708@jp.fujitsu.com>
In-Reply-To: <4CF4B597.4030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the problem dmar fault event is not notified in x2apic cluster mode.

In the current code, dmar fault event is configured before setting up
the x86_cpu_to_logical_apicid percpu variable in x2apic cluster
mode. Because of this, invalid apic ID is used for dmar fault
interrupt and this cuases the problem.

To fix the problem, do dmar fault event configuration after local apic
setup (after end_local_APIC_setup()).

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>


---
 arch/x86/kernel/apic/apic.c     |    9 +++++++++
 arch/x86/kernel/apic/probe_64.c |    7 -------
 2 files changed, 9 insertions(+), 7 deletions(-)

Index: linux-next-20101125/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-next-20101125.orig/arch/x86/kernel/apic/apic.c
+++ linux-next-20101125/arch/x86/kernel/apic/apic.c
@@ -1745,6 +1745,15 @@ int __init APIC_init_uniprocessor(void)
 
 	end_local_APIC_setup();
 
+#ifdef CONFIG_INTR_REMAP
+	/*
+	 * Now that local APIC setup is completed, configure the fault
+	 * handling for interrupt remapping.
+	 */
+	if (intr_remapping_enabled)
+		enable_drhd_fault_handling();
+#endif
+
 #ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
 		setup_IO_APIC();
Index: linux-next-20101125/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-next-20101125.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-next-20101125/arch/x86/kernel/apic/probe_64.c
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


