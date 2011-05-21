Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab1EUA7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:59:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:46992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab1EUA7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,245,1304319600"; 
   d="scan'208";a="1824591"
Message-Id: <20110521005526.164277071@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 20 May 2011 17:51:18 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        gorcunov@openvz.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 2/4] x86, apic: use .apicdrivers section for the apic drivers list
References: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=probe_apic_using_apicdriver_section.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will eliminate the need for apic_probe[], as the probing now will
happen based on the apic drivers order in the .apcidrivers section.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/probe_32.c |   39 ++++++++++++++++++++-------------------
 arch/x86/kernel/apic/probe_64.c |   28 ++++++++++++++++------------
 2 files changed, 36 insertions(+), 31 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
@@ -54,19 +54,21 @@ static int apicid_phys_pkg_id(int initia
  */
 void __init default_setup_apic_routing(void)
 {
-	int i;
+	struct apic **drv;
 
 	enable_IR_x2apic();
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (apic_probe[i]->probe()) {
-			apic = apic_probe[i];
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if ((*drv)->probe && (*drv)->probe()) {
+			if (apic != *drv) {
+				apic = *drv;
+				pr_info("Switched APIC routing to %s.\n",
+					apic->name);
+			}
 			break;
 		}
 	}
 
-	printk(KERN_INFO "APIC routing finalized to %s.\n", apic->name);
-
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
@@ -82,13 +84,15 @@ void apic_send_IPI_self(int vector)
 
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int i;
+	struct apic **drv;
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
-			apic = apic_probe[i];
-			printk(KERN_INFO "Setting APIC routing to %s.\n",
-				apic->name);
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if ((*drv)->acpi_madt_oem_check(oem_id, oem_table_id)) {
+			if (apic != *drv) {
+				apic = *drv;
+				pr_info("Setting APIC routing to %s.\n",
+					apic->name);
+			}
 			return 1;
 		}
 	}
Index: linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
@@ -206,14 +206,14 @@ static struct apic *apic_probe[] __initd
 static int cmdline_apic __initdata;
 static int __init parse_apic(char *arg)
 {
-	int i;
+	struct apic **drv;
 
 	if (!arg)
 		return -EINVAL;
 
-	for (i = 0; apic_probe[i]; i++) {
-		if (!strcmp(apic_probe[i]->name, arg)) {
-			apic = apic_probe[i];
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if (!strcmp((*drv)->name, arg)) {
+			apic = *drv;
 			cmdline_apic = 1;
 			return 0;
 		}
@@ -247,15 +247,16 @@ void __init generic_bigsmp_probe(void)
 void __init generic_apic_probe(void)
 {
 	if (!cmdline_apic) {
-		int i;
-		for (i = 0; apic_probe[i]; i++) {
-			if (apic_probe[i]->probe()) {
-				apic = apic_probe[i];
+		struct apic **drv;
+
+		for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+			if ((*drv)->probe()) {
+				apic = *drv;
 				break;
 			}
 		}
 		/* Not visible without early console */
-		if (!apic_probe[i])
+		if (drv == __apicdrivers_end)
 			panic("Didn't find an APIC driver");
 	}
 	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
@@ -266,16 +267,16 @@ void __init generic_apic_probe(void)
 int __init
 generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
-	int i;
+	struct apic **drv;
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (!apic_probe[i]->mps_oem_check)
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if (!((*drv)->mps_oem_check))
 			continue;
-		if (!apic_probe[i]->mps_oem_check(mpc, oem, productid))
+		if (!(*drv)->mps_oem_check(mpc, oem, productid))
 			continue;
 
 		if (!cmdline_apic) {
-			apic = apic_probe[i];
+			apic = *drv;
 			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 			       apic->name);
 		}
@@ -286,16 +287,16 @@ generic_mps_oem_check(struct mpc_table *
 
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int i;
+	struct apic **drv;
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (!apic_probe[i]->acpi_madt_oem_check)
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if (!(*drv)->acpi_madt_oem_check)
 			continue;
-		if (!apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id))
+		if (!(*drv)->acpi_madt_oem_check(oem_id, oem_table_id))
 			continue;
 
 		if (!cmdline_apic) {
-			apic = apic_probe[i];
+			apic = *drv;
 			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 			       apic->name);
 		}


