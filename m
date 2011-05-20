Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472Ab1ETNlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:41:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:36103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab1ETNlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:41:08 -0400
Date: Fri, 20 May 2011 13:40:51 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-9ebd680bd029a9fc47399ca61c950f8b6730ac40@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110519234637.247458931@sbsiddha-MOBL3.sc.intel.com>
References: <20110519234637.247458931@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Use probe routines to simplify apic selection
Git-Commit-ID: 9ebd680bd029a9fc47399ca61c950f8b6730ac40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:40:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ebd680bd029a9fc47399ca61c950f8b6730ac40
Gitweb:     http://git.kernel.org/tip/9ebd680bd029a9fc47399ca61c950f8b6730ac40
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 19 May 2011 16:45:46 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:41:04 +0200

x86, apic: Use probe routines to simplify apic selection

Use the unused probe routine in the apic driver to finalize the
apic model selection. This cleans up the
default_setup_apic_routing() and this probe routine in future
can also be used for doing any apic model specific
initialisation.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: steiner@sgi.com
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/20110519234637.247458931@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic_flat_64.c   |   10 +++++++++-
 arch/x86/kernel/apic/probe_64.c       |   22 +++++++---------------
 arch/x86/kernel/apic/x2apic_cluster.c |    7 ++++++-
 arch/x86/kernel/apic/x2apic_phys.c    |   10 +++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    7 ++++++-
 5 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 5652d31..025921f 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -312,10 +312,18 @@ physflat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
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
 
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index d8c4a6f..39fb42b 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -54,26 +54,18 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
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
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 90949bb..2967bab 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
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
 
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index c7e6d66..8f21771 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
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
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 7acd2d2..6bb80b1 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
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
 
