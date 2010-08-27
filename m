Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0H0SNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:13:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:35824 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0H0SNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:13:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,279,1280732400"; 
   d="scan'208";a="601117112"
Message-Id: <20100827181049.173087246@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 27 Aug 2010 11:09:50 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/3] x86, x2apic: simplify apic init in SMP and UP builds
References: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=cleanup_enable_IR_seq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move enable_IR_x2apic() inside the default_setup_apic_routing()

And for smp platforms, move the default_setup_apic_routing() after
smp_sanity_check(). This cleans up the code that tries to avoid multiple
calls to default_setup_apic_routing() when smp_sanity_check() fails (which
goes through the APIC_init_uniprocessor() path)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/apic.c     |    3 ---
 arch/x86/kernel/apic/probe_64.c |    3 +++
 arch/x86/kernel/smpboot.c       |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1665,10 +1665,7 @@ int __init APIC_init_uniprocessor(void)
 	}
 #endif
 
-#ifndef CONFIG_SMP
-	enable_IR_x2apic();
 	default_setup_apic_routing();
-#endif
 
 	verify_local_APIC();
 	connect_bsp_APIC();
Index: tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/probe_64.c
+++ tip/arch/x86/kernel/apic/probe_64.c
@@ -54,6 +54,9 @@ static int apicid_phys_pkg_id(int initia
  */
 void __init default_setup_apic_routing(void)
 {
+
+	enable_IR_x2apic();
+
 #ifdef CONFIG_X86_X2APIC
 	if (x2apic_mode
 #ifdef CONFIG_X86_UV
Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -1107,8 +1107,6 @@ void __init native_smp_prepare_cpus(unsi
 	}
 	set_cpu_sibling_map(0);
 
-	enable_IR_x2apic();
-	default_setup_apic_routing();
 
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
@@ -1116,6 +1114,8 @@ void __init native_smp_prepare_cpus(unsi
 		goto out;
 	}
 
+	default_setup_apic_routing();
+
 	preempt_disable();
 	if (read_apic_id() != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",


