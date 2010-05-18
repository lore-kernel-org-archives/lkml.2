Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0ERK35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:29:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:61170 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab0ERK3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:29:46 -0400
X-IronPort-AV: E=Sophos;i="4.53,254,1272859200"; 
   d="scan'208";a="97477214"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 11/12] Support VIRQ_TIMER and pvclock on HVM
Date: Tue, 18 May 2010 11:23:06 +0100
Message-Id: <1274178187-20602-11-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
X-OriginalArrivalTime: 18 May 2010 10:20:13.0513 (UTC) FILETIME=[B4013390:01CAF673]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c         |   39 +++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/time.c              |    3 ++
 drivers/xen/manage.c             |    1 +
 include/xen/interface/features.h |    3 ++
 4 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 77ba321..41677fe 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1274,6 +1274,7 @@ void init_shared_info(void)
 {
 	struct xen_add_to_physmap xatp;
 	static struct shared_info *shared_info_page = 0;
+	int cpu;
 
 	if (!shared_info_page)
 		shared_info_page = (struct shared_info *) alloc_bootmem_pages(PAGE_SIZE);
@@ -1288,7 +1289,42 @@ void init_shared_info(void)
 
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
-	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
+	/* This code is run at resume time so make sure all the online cpus
+	 * have xen_vcpu properly set */
+	for_each_online_cpu(cpu)
+		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
+}
+
+static void xen_hvm_setup_cpu_clockevents(void)
+{
+	int cpu = smp_processor_id();
+	xen_setup_timer(cpu);
+	per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
+	xen_setup_cpu_clockevents();
+}
+
+static void init_hvm_time(void)
+{
+#ifdef CONFIG_SMP
+	/* vector callback is needed otherwise we cannot receive interrupts
+	 * on cpu > 0 */
+	if (!xen_have_vector_callback)
+		return;
+#endif
+	if (!xen_feature(XENFEAT_hvm_safe_pvclock)) {
+		printk(KERN_WARNING "Xen doesn't support pvclock on HVM,"
+				"disable pv timer\n");
+		return;
+	}
+
+	pv_time_ops = xen_time_ops;
+	x86_init.timers.timer_init = xen_time_init;
+	x86_init.timers.setup_percpu_clockev = x86_init_noop;
+	x86_cpuinit.setup_percpu_clockev = xen_hvm_setup_cpu_clockevents;
+
+	x86_platform.calibrate_tsc = xen_tsc_khz;
+	x86_platform.get_wallclock = xen_get_wallclock;
+	x86_platform.set_wallclock = xen_set_wallclock;
 }
 
 int xen_set_callback_via(uint64_t via)
@@ -1373,6 +1409,7 @@ void __init xen_guest_init(void)
 		outw(unplug, XEN_IOPORT_UNPLUG);
 	have_vcpu_info_placement = 0;
 	x86_init.irqs.intr_init = xen_init_IRQ;
+	init_hvm_time();
 }
 
 static int __init parse_unplug(char *arg)
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 32764b8..620e68f 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -19,6 +19,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
+#include <xen/xen.h>
 #include <xen/events.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
@@ -470,6 +471,8 @@ void xen_timer_resume(void)
 	for_each_online_cpu(cpu) {
 		if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL))
 			BUG();
+		if (xen_hvm_domain())
+			xen_setup_runstate_info(cpu);
 	}
 }
 
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 49ee52d..4a8af22 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -60,6 +60,7 @@ static int xen_hvm_suspend(void *data)
 	if (!*cancelled) {
 		xen_irq_resume();
 		platform_pci_resume_hook();
+		xen_timer_resume();
 	}
 
 	return 0;
diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
index 8ab08b9..70d2563 100644
--- a/include/xen/interface/features.h
+++ b/include/xen/interface/features.h
@@ -44,6 +44,9 @@
 /* x86: Does this Xen host support the HVM callback vector type? */
 #define XENFEAT_hvm_callback_vector        8
 
+/* x86: pvclock algorithm is safe to use on HVM */
+#define XENFEAT_hvm_safe_pvclock           9
+
 #define XENFEAT_NR_SUBMAPS 1
 
 #endif /* __XEN_PUBLIC_FEATURES_H__ */
-- 
1.5.4.3

