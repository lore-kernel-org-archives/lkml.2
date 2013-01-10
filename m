Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3AJJTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:19:14 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43256 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3AJJTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:19:11 -0500
MIME-Version: 1.0
In-Reply-To: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
References: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
Date: Thu, 10 Jan 2013 14:49:10 +0530
Message-ID: <CAKohpo=1drznitjyZ=JbUgh_vn10D-BhgahPWPobCtmW1uxwiQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Simplify __cpufreq_remove_dev()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 January 2013 16:50, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> +static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
> +{

> +       cpufreq_frequency_table_update_policy_cpu(old_cpu, cpu);
> +       cpufreq_stats_update_policy_cpu(old_cpu, cpu);

This looked a bit ugly to me, as there may be other users too who want
to get this notification and so have below patch for this: pushed in my repo.

Tested on TC2. I have tested my patches well now and the activity is over from
my end now, unless somebody finds something objectionable :)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index e3f7c7b..8a0b65e0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -990,9 +990,9 @@ module_out:

 static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 {
-	unsigned int old_cpu = policy->cpu;
 	int j;

+	policy->last_cpu = policy->cpu;
 	policy->cpu = cpu;

 	for_each_cpu(j, policy->cpus) {
@@ -1001,8 +1001,9 @@ static void update_policy_cpu(struct
cpufreq_policy *policy, unsigned int cpu)
 		per_cpu(cpufreq_policy_cpu, j) = cpu;
 	}

-	cpufreq_frequency_table_update_policy_cpu(old_cpu, cpu);
-	cpufreq_stats_update_policy_cpu(old_cpu, cpu);
+	cpufreq_frequency_table_update_policy_cpu(policy);
+	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+			CPUFREQ_UPDATE_POLICY_CPU, policy);
 }

 /**
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index b0df77a..2665f0a 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -267,17 +267,17 @@ error_get_fail:
 	return ret;
 }

-void cpufreq_stats_update_policy_cpu(unsigned int old_cpu,
-		unsigned int new_cpu)
+static void cpufreq_stats_update_policy_cpu(struct cpufreq_policy *policy)
 {
-	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, old_cpu);
-
-	pr_debug("Updating stats_table for new_cpu %u from old_cpu %u\n",
-			new_cpu, old_cpu);
-	per_cpu(cpufreq_stats_table, new_cpu) = per_cpu(cpufreq_stats_table,
-			old_cpu);
-	per_cpu(cpufreq_stats_table, old_cpu) = NULL;
-	stat->cpu = new_cpu;
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table,
+			policy->last_cpu);
+
+	pr_debug("Updating stats_table for new_cpu %u from last_cpu %u\n",
+			policy->cpu, policy->last_cpu);
+	per_cpu(cpufreq_stats_table, policy->cpu) = per_cpu(cpufreq_stats_table,
+			policy->last_cpu);
+	per_cpu(cpufreq_stats_table, policy->last_cpu) = NULL;
+	stat->cpu = policy->cpu;
 }

 static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
@@ -287,6 +287,12 @@ static int cpufreq_stat_notifier_policy(struct
notifier_block *nb,
 	struct cpufreq_policy *policy = data;
 	struct cpufreq_frequency_table *table;
 	unsigned int cpu = policy->cpu;
+
+	if (val == CPUFREQ_UPDATE_POLICY_CPU) {
+		cpufreq_stats_update_policy_cpu(policy);
+		return 0;
+	}
+
 	if (val != CPUFREQ_NOTIFY)
 		return 0;
 	table = cpufreq_frequency_get_table(cpu);
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 2c3b07b..281e3b4 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -225,14 +225,13 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu)
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_put_attr);

-void cpufreq_frequency_table_update_policy_cpu(unsigned int old_cpu,
-		unsigned int new_cpu)
+void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy)
 {
-	pr_debug("Updating show_table for new_cpu %u from old_cpu %u\n",
-			new_cpu, old_cpu);
-	per_cpu(cpufreq_show_table, new_cpu) = per_cpu(cpufreq_show_table,
-			old_cpu);
-	per_cpu(cpufreq_show_table, old_cpu) = NULL;
+	pr_debug("Updating show_table for new_cpu %u from last_cpu %u\n",
+			policy->cpu, policy->last_cpu);
+	per_cpu(cpufreq_show_table, policy->cpu) = per_cpu(cpufreq_show_table,
+			policy->last_cpu);
+	per_cpu(cpufreq_show_table, policy->last_cpu) = NULL;
 }

 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu)
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index af50dbd..7a3192a 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -90,7 +90,9 @@ struct cpufreq_policy {
 	cpumask_var_t		related_cpus; /* CPUs with any coordination */
 	unsigned int		shared_type; /* ANY or ALL affected CPUs
 						should set cpufreq */
-	unsigned int		cpu;    /* cpu nr of registered CPU */
+	unsigned int		cpu;    /* cpu nr of CPU managing this policy */
+	unsigned int		last_cpu; /* cpu nr of previous CPU that managed
+					   * this policy */
 	struct cpufreq_cpuinfo	cpuinfo;/* see above */

 	unsigned int		min;    /* in kHz */
@@ -109,10 +111,11 @@ struct cpufreq_policy {
 	struct completion	kobj_unregister;
 };

-#define CPUFREQ_ADJUST		(0)
-#define CPUFREQ_INCOMPATIBLE	(1)
-#define CPUFREQ_NOTIFY		(2)
-#define CPUFREQ_START		(3)
+#define CPUFREQ_ADJUST			(0)
+#define CPUFREQ_INCOMPATIBLE		(1)
+#define CPUFREQ_NOTIFY			(2)
+#define CPUFREQ_START			(3)
+#define CPUFREQ_UPDATE_POLICY_CPU	(4)

 #define CPUFREQ_SHARED_TYPE_NONE (0) /* None */
 #define CPUFREQ_SHARED_TYPE_HW	 (1) /* HW does needed coordination */
@@ -405,12 +408,8 @@ extern struct freq_attr
cpufreq_freq_attr_scaling_available_freqs;

 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
-void cpufreq_frequency_table_update_policy_cpu(unsigned int old_cpu,
-		unsigned int new_cpu);
+void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy);

 void cpufreq_frequency_table_put_attr(unsigned int cpu);

-void cpufreq_stats_update_policy_cpu(unsigned int old_cpu,
-		unsigned int new_cpu);
-
