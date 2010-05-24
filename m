Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab0EXSY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:24:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:24383 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab0EXSYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:24:16 -0400
X-IronPort-AV: E=Sophos;i="4.53,292,1272859200"; 
   d="scan'208";a="98432041"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Don Dutile <ddutile@redhat.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 10/11] Support VIRQ_TIMER and pvclock on HVM
Date: Mon, 24 May 2010 19:27:36 +0100
Message-Id: <1274725657-1149-10-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
X-OriginalArrivalTime: 24 May 2010 18:24:15.0394 (UTC) FILETIME=[50CB1020:01CAFB6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the paravirtualized timer (VIRQ_TIMER) as timer and the
paravirtualized clock (pvclock) as wallclock on HVM domains too.
Any interaction with emulated hardware is not very fast, so using the
paravirtualized timer instead of the emulated hpet is defenitely a
performance improvement.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c         |   31 +++++++++++++++++++++++++++++++
 arch/x86/xen/suspend.c           |    4 ++++
 include/xen/interface/features.h |    3 +++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index cb316b5..88e8a09 100644
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
index ef517ee..02c3253 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -28,8 +28,12 @@ void xen_pre_suspend(void)
 
 void xen_hvm_post_suspend(int suspend_cancelled)
 {
+	int cpu;
 	init_shared_info();
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
1.5.4.3

