Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1BJGos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:44:48 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab1BJGoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:11 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 11/15] ARM: tegra: cpufreq: Disable cpufreq during suspend
Date: Wed,  9 Feb 2011 22:43:20 -0800
Message-Id: <1297320204-31882-12-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tegra, calling clk_set_rate on the CPU clock may call into the
regulator API.  If the regulator driver that controls the CPU
voltage rail has been suspended, this can lead to attempted
communication with a hardware block that has already been turned
off.

Adds a SUSPEND_PREPARE notification hook to drop the frequency to
the lowest possible during suspend.

Also adds 216MHz (off of PLLP) as the lowest CPU frequency, which
allows PLLX to be turned off.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/cpu-tegra.c |   75 +++++++++++++++++++++++++++++++--------
 1 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-tegra/cpu-tegra.c b/arch/arm/mach-tegra/cpu-tegra.c
index fea5719..ad26a9f 100644
--- a/arch/arm/mach-tegra/cpu-tegra.c
+++ b/arch/arm/mach-tegra/cpu-tegra.c
@@ -28,6 +28,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/suspend.h>
 
 #include <asm/system.h>
 
@@ -36,14 +37,15 @@
 
 /* Frequency table index must be sequential starting at 0 */
 static struct cpufreq_frequency_table freq_table[] = {
-	{ 0, 312000 },
-	{ 1, 456000 },
-	{ 2, 608000 },
-	{ 3, 760000 },
-	{ 4, 816000 },
-	{ 5, 912000 },
-	{ 6, 1000000 },
-	{ 7, CPUFREQ_TABLE_END },
+	{ 0, 216000 },
+	{ 1, 312000 },
+	{ 2, 456000 },
+	{ 3, 608000 },
+	{ 4, 760000 },
+	{ 5, 816000 },
+	{ 6, 912000 },
+	{ 7, 1000000 },
+	{ 8, CPUFREQ_TABLE_END },
 };
 
 #define NUM_CPUS	2
@@ -51,6 +53,8 @@ static struct cpufreq_frequency_table freq_table[] = {
 static struct clk *cpu_clk;
 
 static unsigned long target_cpu_speed[NUM_CPUS];
+static DEFINE_MUTEX(tegra_cpu_lock);
+static bool is_suspended;
 
 int tegra_verify_speed(struct cpufreq_policy *policy)
 {
@@ -68,16 +72,11 @@ unsigned int tegra_getspeed(unsigned int cpu)
 	return rate;
 }
 
-static int tegra_update_cpu_speed(void)
+static int tegra_update_cpu_speed(unsigned long rate)
 {
-	int i;
-	unsigned long rate = 0;
 	int ret = 0;
 	struct cpufreq_freqs freqs;
 
-	for_each_online_cpu(i)
-		rate = max(rate, target_cpu_speed[i]);
-
 	freqs.old = tegra_getspeed(0);
 	freqs.new = rate;
 
@@ -105,12 +104,30 @@ static int tegra_update_cpu_speed(void)
 	return 0;
 }
 
+static unsigned long tegra_cpu_highest_speed(void)
+{
+	unsigned long rate = 0;
+	int i;
+
+	for_each_online_cpu(i)
+		rate = max(rate, target_cpu_speed[i]);
+	return rate;
+}
+
 static int tegra_target(struct cpufreq_policy *policy,
 		       unsigned int target_freq,
 		       unsigned int relation)
 {
 	int idx;
 	unsigned int freq;
+	int ret = 0;
+
+	mutex_lock(&tegra_cpu_lock);
+
+	if (is_suspended) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	cpufreq_frequency_table_target(policy, freq_table, target_freq,
 		relation, &idx);
@@ -119,9 +136,34 @@ static int tegra_target(struct cpufreq_policy *policy,
 
 	target_cpu_speed[policy->cpu] = freq;
 
-	return tegra_update_cpu_speed();
+	ret = tegra_update_cpu_speed(tegra_cpu_highest_speed());
+
+out:
+	mutex_unlock(&tegra_cpu_lock);
+	return ret;
 }
 
+static int tegra_pm_notify(struct notifier_block *nb, unsigned long event,
+	void *dummy)
+{
+	mutex_lock(&tegra_cpu_lock);
+	if (event == PM_SUSPEND_PREPARE) {
+		is_suspended = true;
+		pr_info("Tegra cpufreq suspend: setting frequency to %d kHz\n",
+			freq_table[0].frequency);
+		tegra_update_cpu_speed(freq_table[0].frequency);
+	} else if (event == PM_POST_SUSPEND) {
+		is_suspended = false;
+	}
+	mutex_unlock(&tegra_cpu_lock);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block tegra_cpu_pm_notifier = {
+	.notifier_call = tegra_pm_notify,
+};
+
 static int tegra_cpu_init(struct cpufreq_policy *policy)
 {
 	if (policy->cpu >= NUM_CPUS)
@@ -142,6 +184,9 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
 	cpumask_copy(policy->related_cpus, cpu_possible_mask);
 
+	if (policy->cpu == 0)
+		register_pm_notifier(&tegra_cpu_pm_notifier);
+
 	return 0;
 }
 
-- 
1.7.3.1

