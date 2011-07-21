Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1GUVIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:08:49 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.205]:37030 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab1GUVIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:08:47 -0400
From: =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Subject: [PATCH] e_powersaver: Check BIOS limit for CPU frequency
Date: Thu, 21 Jul 2011 22:11:29 +0100
Message-Id: <1311282689-5447-1-git-send-email-rafalbilski@interia.pl>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
X-Interia-Antivirus: OK
X-EMID: a0771958
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call ACPI function to get BIOS limit for CPU frequency.
Fail if processor would like to run at higher frequency.
Allow user to ignore BIOS limit.

eps: Detected VIA Model D C7-M
eps: Current voltage = 1084mV
eps: Current multiplier = 16
eps: Highest voltage = 1084mV
eps: Highest multiplier = 16
eps: Lowest voltage = 844mV
eps: Lowest multiplier = 4
eps: ACPI limit 1.60GHz

Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
---
 drivers/cpufreq/e_powersaver.c |   76 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index cab543b..7638f5d 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -19,6 +19,11 @@
 #include <asm/msr.h>
 #include <asm/tsc.h>
 
+#if defined CONFIG_ACPI_PROCESSOR || defined CONFIG_ACPI_PROCESSOR_MODULE
+#include <linux/acpi.h>
+#include <acpi/processor.h>
+#endif
+
 #define EPS_BRAND_C7M	0
 #define EPS_BRAND_C7	1
 #define EPS_BRAND_EDEN	2
@@ -27,6 +32,9 @@
 
 struct eps_cpu_data {
 	u32 fsb;
+#if defined CONFIG_ACPI_PROCESSOR || defined CONFIG_ACPI_PROCESSOR_MODULE
+	u32 bios_limit;
+#endif
 	struct cpufreq_frequency_table freq_table[];
 };
 
@@ -36,6 +44,46 @@ static struct eps_cpu_data *eps_cpu[NR_CPUS];
 static int freq_failsafe_off;
 static int voltage_failsafe_off;
 
+#if defined CONFIG_ACPI_PROCESSOR || defined CONFIG_ACPI_PROCESSOR_MODULE
+static int ignore_acpi_limit;
+
+static struct acpi_processor_performance *eps_acpi_cpu_perf;
+
+/* Minimum necessary to get acpi_processor_get_bios_limit() working */
+static int eps_acpi_init(void)
+{
+	eps_acpi_cpu_perf = kzalloc(sizeof(struct acpi_processor_performance),
+				      GFP_KERNEL);
+	if (!eps_acpi_cpu_perf)
+		return -ENOMEM;
+
+	if (!zalloc_cpumask_var(&eps_acpi_cpu_perf->shared_cpu_map,
+								GFP_KERNEL)) {
+		kfree(eps_acpi_cpu_perf);
+		eps_acpi_cpu_perf = NULL;
+		return -ENOMEM;
+	}
+
+	if (acpi_processor_register_performance(eps_acpi_cpu_perf, 0)) {
+		free_cpumask_var(eps_acpi_cpu_perf->shared_cpu_map);
+		kfree(eps_acpi_cpu_perf);
+		eps_acpi_cpu_perf = NULL;
+		return -EIO;
+	}
+	return 0;
+}
+
+static int eps_acpi_exit(struct cpufreq_policy *policy)
+{
+	if (eps_acpi_cpu_perf) {
+		acpi_processor_unregister_performance(eps_acpi_cpu_perf, 0);
+		free_cpumask_var(eps_acpi_cpu_perf->shared_cpu_map);
+		kfree(eps_acpi_cpu_perf);
+		eps_acpi_cpu_perf = NULL;
+	}
+	return 0;
+}
+#endif
 
 static unsigned int eps_get(unsigned int cpu)
 {
@@ -168,6 +216,9 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 	int k, step, voltage;
 	int ret;
 	int states;
+#if defined CONFIG_ACPI_PROCESSOR || defined CONFIG_ACPI_PROCESSOR_MODULE
+	unsigned int limit;
+#endif
 
 	if (policy->cpu != 0)
 		return -ENODEV;
@@ -280,6 +331,24 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 
 	/* Calc FSB speed */
 	fsb = cpu_khz / current_multiplier;
+
+#if defined CONFIG_ACPI_PROCESSOR || defined CONFIG_ACPI_PROCESSOR_MODULE
+	/* Check for ACPI processor speed limit */
+	if (!ignore_acpi_limit && !eps_acpi_init()) {
+		if (!acpi_processor_get_bios_limit(policy->cpu, &limit)) {
+			printk(KERN_INFO "eps: ACPI limit %u.%uGHz\n",
+				limit/1000000,
+				(limit%1000000)/10000);
+			eps_acpi_exit(policy);
+			/* Check if max_multiplier is in BIOS limits */
+			if (limit && max_multiplier * fsb > limit) {
+				printk(KERN_INFO "eps: Aborting.\n");
+				return -EINVAL;
+			}
+		}
+	}
+#endif
+
 	/* Calc number of p-states supported */
 	if (brand == EPS_BRAND_C7M)
 		states = max_multiplier - min_multiplier + 1;
@@ -296,6 +365,9 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 
 	/* Copy basic values */
 	centaur->fsb = fsb;
+#if defined CONFIG_ACPI_PROCESSOR || defined CONFIG_ACPI_PROCESSOR_MODULE
+	centaur->bios_limit = limit;
+#endif
 
 	/* Fill frequency and MSR value table */
 	f_table = &centaur->freq_table[0];
@@ -386,6 +458,10 @@ module_param(freq_failsafe_off, int, 0644);
 MODULE_PARM_DESC(freq_failsafe_off, "Disable current vs max frequency check");
 module_param(voltage_failsafe_off, int, 0644);
 MODULE_PARM_DESC(voltage_failsafe_off, "Disable current vs max voltage check");
+#if defined CONFIG_ACPI_PROCESSOR || defined CONFIG_ACPI_PROCESSOR_MODULE
+module_param(ignore_acpi_limit, int, 0644);
+MODULE_PARM_DESC(ignore_acpi_limit, "Don't check ACPI's processor speed limit");
+#endif
 
 MODULE_AUTHOR("Rafal Bilski <rafalbilski@interia.pl>");
 MODULE_DESCRIPTION("Enhanced PowerSaver driver for VIA C7 CPU's.");
-- 
1.7.6


----------------------------------------------------------------
Najwieksza baza samochodow nowych i uzywanych
Sprawdz >> http://linkint.pl/f29e3
