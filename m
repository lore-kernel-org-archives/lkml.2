Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0FCNLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:11:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30773 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0FCNLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:36 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99908979"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 11/12] Use xen_vcpuop_clockevent, xen_clocksource and xen wallclock.
Date: Thu,  3 Jun 2010 14:10:44 +0100
Message-Id: <1275570645-27189-11-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:35.0147 (UTC) FILETIME=[4AF20BB0:01CB031E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Use xen_vcpuop_clockevent instead of hpet and APIC timers as main
clockevent device on all vcpus, use the xen wallclock time as wallclock
instead of rtc and use xen_clocksource as clocksource.
The pv clock algorithm needs to work correctly for the xen_clocksource
and xen wallclock to be usable, only modern Xen versions offer a
reliable pv clock in HVM guests (XENFEAT_hvm_safe_pvclock).

Using the hpet as clocksource means a VMEXIT every time we read/write to
the hpet mmio addresses, pvclock give us a better rating without
VMEXITs. Same goes for the xen wallclock and xen_vcpuop_clockevent

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c         |   31 +++++++++++++++++++++++++++++++
 arch/x86/xen/suspend.c           |    4 ++++
 include/xen/interface/features.h |    3 +++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c71b0fa..e90dfcd 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1307,6 +1307,36 @@ static struct notifier_block __cpuinitdata xen_hvm_cpu_notifier = {
 	.notifier_call	= xen_hvm_cpu_notify,
 };
 
+static void xen_hvm_setup_cpu_clockevents(void)
+{
+	int cpu = smp_processor_id();
+	xen_setup_runstate_info(cpu);
+	xen_setup_timer(cpu);
+	xen_setup_cpu_clockevents();
+}
+
+static void init_hvm_time(void)
+{
+	/* vector callback is needed otherwise we cannot receive interrupts
+	 * on cpu > 0 */
+	if (!xen_have_vector_callback && num_present_cpus() > 1)
+		return;
+	if (!xen_feature(XENFEAT_hvm_safe_pvclock)) {
+		printk(KERN_INFO "Xen doesn't support pvclock on HVM,"
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
+}
+
 void __init xen_guest_init(void)
 {
 	int r;
@@ -1326,4 +1356,5 @@ void __init xen_guest_init(void)
 	register_cpu_notifier(&xen_hvm_cpu_notifier);
 	have_vcpu_info_placement = 0;
 	x86_init.irqs.intr_init = xen_init_IRQ;
+	init_hvm_time();
 }
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 6ff9665..0774c67 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -28,8 +28,12 @@ void xen_pre_suspend(void)
 
 void xen_hvm_post_suspend(int suspend_cancelled)
 {
+	int cpu;
 	xen_hvm_init_shared_info();
 	xen_callback_vector();
+	for_each_online_cpu(cpu) {
+		xen_setup_runstate_info(cpu);
+	}
 }
 
 void xen_post_suspend(int suspend_cancelled)
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
1.7.0.4

