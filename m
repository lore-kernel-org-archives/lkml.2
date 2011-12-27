Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1L0Gf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 01:35:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41345 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1L0GfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 01:35:03 -0500
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] ACPI: Do cpufreq clamping for throttling per package instead of per CPU
Date: Mon, 26 Dec 2011 22:34:47 -0800
Message-Id: <1324967687-10559-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324967687-10559-1-git-send-email-andi@firstfloor.org>
References: <1324967687-10559-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Intel CPUs the processor typically uses the highest frequency
set by any logical CPU. When the system overheats
Linux first forces the frequency to the lowest available one
to lower the temperature.

However this was done only per logical CPU, which means all
logical CPUs in a package would need to go through this before
the frequency is actually lowered.

Worse this delay actually prevents real throttling, because
the real throttle code only proceeds when the lowest frequency
is already reached.

So when a throttle event happens force the lowest frequency
for all CPUs in the package where it happened. The per CPU
state is now kept per package, not per logical CPU. An alternative
would be to do it per cpufreq unit, but since we want to bring
down the temperature of the complete chip it's better
to do it for all.

In principle it may even make sense to do it for all CPUs,
but I kept it on the package for now.

With this change the frequency is actually lowered, which
in terms also allows real throttling to proceed.

I also removed an unnecessary per cpu variable initialization.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/acpi/processor_thermal.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 870550d..d5dd141 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -58,6 +58,9 @@ ACPI_MODULE_NAME("processor_thermal");
 static DEFINE_PER_CPU(unsigned int, cpufreq_thermal_reduction_pctg);
 static unsigned int acpi_thermal_cpufreq_is_init = 0;
 
+#define reduction_pctg(cpu) \
+	per_cpu(cpufreq_thermal_reduction_pctg, topology_physical_package_id(cpu))
+
 static int cpu_has_cpufreq(unsigned int cpu)
 {
 	struct cpufreq_policy policy;
@@ -72,12 +75,15 @@ static int acpi_thermal_cpufreq_notifier(struct notifier_block *nb,
 	struct cpufreq_policy *policy = data;
 	unsigned long max_freq = 0;
 
+	if (reduction_pctg(policy->cpu))
+		printk("cpufreq notifier %ld\n", event);
+
 	if (event != CPUFREQ_ADJUST)
 		goto out;
 
 	max_freq = (
 	    policy->cpuinfo.max_freq *
-	    (100 - per_cpu(cpufreq_thermal_reduction_pctg, policy->cpu) * 20)
+	    (100 - reduction_pctg(policy->cpu) * 20)
 	) / 100;
 
 	cpufreq_verify_within_limits(policy, 0, max_freq);
@@ -103,16 +109,26 @@ static int cpufreq_get_cur_state(unsigned int cpu)
 	if (!cpu_has_cpufreq(cpu))
 		return 0;
 
-	return per_cpu(cpufreq_thermal_reduction_pctg, cpu);
+	return reduction_pctg(cpu);
 }
 
 static int cpufreq_set_cur_state(unsigned int cpu, int state)
 {
+	int i;
+
 	if (!cpu_has_cpufreq(cpu))
 		return 0;
 
-	per_cpu(cpufreq_thermal_reduction_pctg, cpu) = state;
-	cpufreq_update_policy(cpu);
+	reduction_pctg(cpu) = state;
+
+	/* Update all the CPUs in the same package because they all
+	 * contribute to the temperature.
+	 */
+	for_each_online_cpu (i) {
+		if (topology_physical_package_id(i) == 
+		    topology_physical_package_id(cpu))
+			cpufreq_update_policy(i);
+	}
 	return 0;
 }
 
@@ -120,10 +136,6 @@ void acpi_thermal_cpufreq_init(void)
 {
 	int i;
 
-	for (i = 0; i < nr_cpu_ids; i++)
-		if (cpu_present(i))
-			per_cpu(cpufreq_thermal_reduction_pctg, i) = 0;
-
 	i = cpufreq_register_notifier(&acpi_thermal_cpufreq_notifier_block,
 				      CPUFREQ_POLICY_NOTIFIER);
 	if (!i)
-- 
1.7.7

