Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab1EMSVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:21:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:47009 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab1EMSVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:21:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="1936473"
Message-Id: <20110513181008.953923915@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 13 May 2011 11:04:51 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/5] x86, x2apic: Remove duplicate code for IPI mask routines
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=consolidate_x2apic_ipi_mask_routines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, x2apic: Remove duplicate code for IPI mask routines

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c |   48 +++++++++++-----------------------
 arch/x86/kernel/apic/x2apic_phys.c    |   45 ++++++++++---------------------
 2 files changed, 31 insertions(+), 62 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
@@ -54,64 +54,48 @@ static void
  * at once. We have 16 cpu's in a cluster. This will minimize IPI register
  * writes.
  */
-static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+static void
+__x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 {
 	unsigned long query_cpu;
+	unsigned long this_cpu;
 	unsigned long flags;
 
 	x2apic_wrmsr_fence();
 
 	local_irq_save(flags);
+
+	this_cpu = smp_processor_id();
 	for_each_cpu(query_cpu, mask) {
+		if (apic_dest == APIC_DEST_ALLBUT && query_cpu == this_cpu)
+			continue;
 		__x2apic_send_IPI_dest(
 			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
 			vector, apic->dest_logical);
 	}
+
 	local_irq_restore(flags);
 }
 
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
+}
+
 static void
  x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->dest_logical);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_allbutself(int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_online_cpu(query_cpu) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->dest_logical);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_mask, vector);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
 static int x2apic_apic_id_registered(void)
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_phys.c
@@ -55,61 +55,46 @@ static void __x2apic_send_IPI_dest(unsig
 	native_x2apic_icr_write(cfg, apicid);
 }
 
-static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+static void
+__x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 {
 	unsigned long query_cpu;
+	unsigned long this_cpu;
 	unsigned long flags;
 
 	x2apic_wrmsr_fence();
 
 	local_irq_save(flags);
+
+	this_cpu = smp_processor_id();
 	for_each_cpu(query_cpu, mask) {
+		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
+			continue;
 		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
 				       vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
+}
+
 static void
  x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu != this_cpu)
-			__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_apicid, query_cpu),
-				vector, APIC_DEST_PHYSICAL);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_allbutself(int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_online_cpu(query_cpu) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
-				       vector, APIC_DEST_PHYSICAL);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_mask, vector);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
 static int x2apic_apic_id_registered(void)


