Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1BPRyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:54:00 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34623 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab1BPRxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:53:21 -0500
X-IronPort-AV: E=Sophos;i="4.60,480,1291611600"; 
   d="scan'208";a="136190324"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 5/7] xen: PV on HVM: support PV spinlocks
Date: Wed, 16 Feb 2011 17:53:05 +0000
Message-Id: <1297878787-378-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
References: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
X-OriginalArrivalTime: 16 Feb 2011 17:53:20.0135 (UTC) FILETIME=[65AE0170:01CBCE02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Initialize PV spinlocks on boot CPU right after native_smp_prepare_cpus
(that switch to APIC mode and initialize APIC routing); on secondary
CPUs on CPU_UP_PREPARE.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2f67e2e..9c1628b 100644
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
@@ -1341,6 +1343,20 @@ static struct notifier_block __cpuinitdata xen_hvm_cpu_notifier = {
 	.notifier_call	= xen_hvm_cpu_notify,
 };
 
+static void xen_hvm_spinlock_init(void)
+{
+	if (!xen_have_vector_callback)
+		return;
+	xen_init_lock_cpu(0);
+	xen_init_spinlocks();
+}
+
+static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
+{
+	native_smp_prepare_cpus(max_cpus);
+	xen_hvm_spinlock_init();
+}
+
 static void __init xen_hvm_guest_init(void)
 {
 	int r;
@@ -1360,6 +1376,7 @@ static void __init xen_hvm_guest_init(void)
 	x86_init.irqs.intr_init = xen_init_IRQ;
 	xen_hvm_init_time_ops();
 	xen_hvm_init_mmu_ops();
+	smp_ops.smp_prepare_cpus = xen_hvm_smp_prepare_cpus;
 }
 
 static bool __init xen_hvm_platform(void)
-- 
1.5.6.5

