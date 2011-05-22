Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1EVKnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:43:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:52650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab1EVKns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:43:48 -0400
Date: Sun, 22 May 2011 10:43:27 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-8b37e88061e229e78959fe3257649fd5ce05f8af@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110521005526.164277071@sbsiddha-MOBL3.sc.intel.com>
References: <20110521005526.164277071@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Use .apicdrivers section for the apic drivers list
Git-Commit-ID: 8b37e88061e229e78959fe3257649fd5ce05f8af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 22 May 2011 10:43:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b37e88061e229e78959fe3257649fd5ce05f8af
Gitweb:     http://git.kernel.org/tip/8b37e88061e229e78959fe3257649fd5ce05f8af
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 20 May 2011 17:51:18 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 May 2011 11:48:03 +0200

x86, apic: Use .apicdrivers section for the apic drivers list

This will eliminate the need for apic_probe[], as the probing
now will happen based on the apic drivers order in the
.apcidrivers section.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: steiner@sgi.com
Cc: gorcunov@openvz.org
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/20110521005526.164277071@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/probe_32.c |   39 ++++++++++++++++++++-------------------
 arch/x86/kernel/apic/probe_64.c |   28 ++++++++++++++++------------
 2 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index a319b33..8796e1d 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -206,14 +206,14 @@ static struct apic *apic_probe[] __initdata = {
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
@@ -286,16 +287,16 @@ generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 
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
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 39fb42b..e2c361d 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -54,19 +54,21 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
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
