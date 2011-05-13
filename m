Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1EMSVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:21:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:22648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab1EMSVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="642407811"
Message-Id: <20110513181008.859892593@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 13 May 2011 11:04:50 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/5] x84_64, apic: Use probe routines to simplify apic selection
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=x64_apic_probe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x84_64, apic: Use probe routines to simplify apic selection

Use the unused probe routine in the apic driver to finalize the apic model
selection. This cleans up the default_setup_apic_routing() and this probe
routine in future can also be used for doing any apic model specific
initialization.

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/apic_flat_64.c   |   10 +++++++++-
 arch/x86/kernel/apic/probe_64.c       |   22 +++++++---------------
 arch/x86/kernel/apic/x2apic_cluster.c |    7 ++++++-
 arch/x86/kernel/apic/x2apic_phys.c    |   10 +++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    7 ++++++-
 5 files changed, 37 insertions(+), 19 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ linux-2.6-tip/arch/x86/kernel/apic/apic_flat_64.c
@@ -312,10 +312,18 @@ physflat_cpu_mask_to_apicid_and(const st
 	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
+static int physflat_probe(void)
+{
+	if (apic == &apic_physflat || num_possible_cpus() > 8)
+		return 1;
+
+	return 0;
+}
+
 struct apic apic_physflat =  {
 
 	.name				= "physical flat",
-	.probe				= NULL,
+	.probe				= physflat_probe,
 	.acpi_madt_oem_check		= physflat_acpi_madt_oem_check,
 	.apic_id_registered		= flat_apic_id_registered,
 
Index: linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
@@ -54,26 +54,18 @@ static int apicid_phys_pkg_id(int initia
  */
 void __init default_setup_apic_routing(void)
 {
+	int i;
 
 	enable_IR_x2apic();
 
-#ifdef CONFIG_X86_X2APIC
-	if (x2apic_mode
-#ifdef CONFIG_X86_UV
-		       && apic != &apic_x2apic_uv_x
-#endif
-		       ) {
-		if (x2apic_phys)
-			apic = &apic_x2apic_phys;
-		else
-			apic = &apic_x2apic_cluster;
+	for (i = 0; apic_probe[i]; ++i) {
+		if (apic_probe[i]->probe()) {
+			apic = apic_probe[i];
+			break;
+		}
 	}
-#endif
-
-	if (apic == &apic_flat && num_possible_cpus() > 8)
-			apic = &apic_physflat;
 
-	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
+	printk(KERN_INFO "APIC routing finalized to %s.\n", apic->name);
 
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
@@ -184,10 +184,15 @@ static void init_x2apic_ldr(void)
 	per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
 }
 
+static int x2apic_cluster_probe(void)
+{
+	return x2apic_mode;
+}
+
 struct apic apic_x2apic_cluster = {
 
 	.name				= "cluster x2apic",
-	.probe				= NULL,
+	.probe				= x2apic_cluster_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_phys.c
@@ -173,10 +173,18 @@ static void init_x2apic_ldr(void)
 {
 }
 
+static int x2apic_phys_probe(void)
+{
+	if (x2apic_mode && x2apic_phys)
+		return 1;
+
+	return apic == &apic_x2apic_phys;
+}
+
 struct apic apic_x2apic_phys = {
 
 	.name				= "physical x2apic",
-	.probe				= NULL,
+	.probe				= x2apic_phys_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -326,10 +326,15 @@ static void uv_send_IPI_self(int vector)
 	apic_write(APIC_SELF_IPI, vector);
 }
 
+static int uv_probe(void)
+{
+	return apic == &apic_x2apic_uv_x;
+}
+
 struct apic __refdata apic_x2apic_uv_x = {
 
 	.name				= "UV large system",
-	.probe				= NULL,
+	.probe				= uv_probe,
 	.acpi_madt_oem_check		= uv_acpi_madt_oem_check,
 	.apic_id_registered		= uv_apic_id_registered,
 


