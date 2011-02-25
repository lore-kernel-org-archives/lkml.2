Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab1BYRL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:11:56 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:53802 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab1BYRLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:11:34 -0500
X-IronPort-AV: E=Sophos;i="4.62,226,1297054800"; 
   d="scan'208";a="137550363"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 5/6] xen: PV on HVM: support PV spinlocks and IPIs
Date: Fri, 25 Feb 2011 17:11:59 +0000
Message-Id: <1298653920-20299-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
References: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
X-OriginalArrivalTime: 25 Feb 2011 17:11:33.0361 (UTC) FILETIME=[0D3E6610:01CBD50F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Initialize PV spinlocks on boot CPU right after native_smp_prepare_cpus
(that switch to APIC mode and initialize APIC routing); on secondary
CPUs on CPU_UP_PREPARE.

Enable the usage of event channels to send and receive IPIs when
running as a PV on HVM guest.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c |    3 +++
 arch/x86/xen/smp.c       |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h   |    2 ++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2f67e2e..fe02574 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1330,6 +1330,8 @@ static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_UP_PREPARE:
 		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
+		if (xen_have_vector_callback)
+			xen_init_lock_cpu(cpu);
 		break;
 	default:
 		break;
@@ -1354,6 +1356,7 @@ static void __init xen_hvm_guest_init(void)
 
 	if (xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
+	xen_hvm_smp_init();
 	register_cpu_notifier(&xen_hvm_cpu_notifier);
 	xen_unplug_emulated_devices();
 	have_vcpu_info_placement = 0;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 72a4c79..3061244 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -509,3 +509,41 @@ void __init xen_smp_init(void)
 	xen_fill_possible_map();
 	xen_init_spinlocks();
 }
+
+static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
+{
+	native_smp_prepare_cpus(max_cpus);
+	WARN_ON(xen_smp_intr_init(0));
+
+	if (!xen_have_vector_callback)
+		return;
+	xen_init_lock_cpu(0);
+	xen_init_spinlocks();
+}
+
+static int __cpuinit xen_hvm_cpu_up(unsigned int cpu)
+{
+	int rc;
+	rc = native_cpu_up(cpu);
+	WARN_ON (xen_smp_intr_init(cpu));
+	return rc;
+}
+
+static void xen_hvm_cpu_die(unsigned int cpu)
+{
+	unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
+	native_cpu_die(cpu);
+}
+
+void __init xen_hvm_smp_init(void)
+{
+	smp_ops.smp_prepare_cpus = xen_hvm_smp_prepare_cpus;
+	smp_ops.smp_send_reschedule = xen_smp_send_reschedule;
+	smp_ops.cpu_up = xen_hvm_cpu_up;
+	smp_ops.cpu_die = xen_hvm_cpu_die;
+	smp_ops.send_call_func_ipi = xen_smp_send_call_function_ipi;
+	smp_ops.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi;
+}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 9d41bf9..3112f55 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -64,10 +64,12 @@ void xen_setup_vcpu_info_placement(void);
 
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
+void __init xen_hvm_smp_init(void);
 
 extern cpumask_var_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
+static inline void xen_hvm_smp_init(void) {}
 #endif
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
-- 
1.5.6.5

