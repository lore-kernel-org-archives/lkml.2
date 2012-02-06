Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2BFQS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:18:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50972 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2BFQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:17:25 -0500
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com,
        Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] ACPI: Do cpufreq clamping for throttling per package v2
Date: Mon,  6 Feb 2012 08:17:11 -0800
Message-Id: <1328545032-21373-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
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

v2: Fix package mapping
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/acpi/processor_thermal.c |   45 +++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 3b599ab..b149b6e 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -57,6 +57,27 @@ ACPI_MODULE_NAME("processor_thermal");
 static DEFINE_PER_CPU(unsigned int, cpufreq_thermal_reduction_pctg);
 static unsigned int acpi_thermal_cpufreq_is_init = 0;
 
+#define reduction_pctg(cpu) \
+	per_cpu(cpufreq_thermal_reduction_pctg, phys_package_first_cpu(cpu))
+
+/*
+ * Emulate "per package data" using per cpu data (which should be really provided 
+ * elsewhere)
+ *
+ * Note we can lose a CPU on cpu hotunplug, in this case we forget the state
+ * temporarily. Fortunately that's not a big issue here (I hope)
+ */
+static int phys_package_first_cpu(int cpu)
+{
+	int i;
+	int id = topology_physical_package_id(cpu);
+
+	for_each_online_cpu (i)
+		if (topology_physical_package_id(i) == id)
+			return i;
+	return 0;
+}
+
 static int cpu_has_cpufreq(unsigned int cpu)
 {
 	struct cpufreq_policy policy;
@@ -76,7 +97,7 @@ static int acpi_thermal_cpufreq_notifier(struct notifier_block *nb,
 
 	max_freq = (
 	    policy->cpuinfo.max_freq *
-	    (100 - per_cpu(cpufreq_thermal_reduction_pctg, policy->cpu) * 20)
+	    (100 - reduction_pctg(policy->cpu) * 20)
 	) / 100;
 
 	cpufreq_verify_within_limits(policy, 0, max_freq);
@@ -102,16 +123,28 @@ static int cpufreq_get_cur_state(unsigned int cpu)
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
+	/* 
+	 * Update all the CPUs in the same package because they all
+	 * contribute to the temperature and often share the same
+	 * frequency.
+	 */
+	for_each_online_cpu (i) {
+		if (topology_physical_package_id(i) == 
+		    topology_physical_package_id(cpu))
+			cpufreq_update_policy(i);
+	}
 	return 0;
 }
 
@@ -119,10 +152,6 @@ void acpi_thermal_cpufreq_init(void)
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

