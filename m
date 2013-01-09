Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3AILUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:20:52 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55396 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab3AILUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:20:50 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: Simplify __cpufreq_remove_dev()
Date: Wed,  9 Jan 2013 16:50:44 +0530
Message-Id: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 09 Jan 2013 11:20:47.0020 (UTC) FILETIME=[5F329EC0:01CDEE5B]
X-MC-Unique: 113010911204704001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r09BKudi005718

__cpufreq_remove_dev() is called on multiple occasions: cpufreq_driver
unregister and cpu removals.

Current implementation of this routine is overly complex without much need. If
the cpu to be removed is the policy->cpu, we remove the policy first and add all
other cpus again from policy->cpus and then finally call __cpufreq_remove_dev()
again to remove the cpu to be deleted. Haahhhh..

There exist a simple solution to removal of a cpu:
- Simply use the old policy structure
- update its fields like: policy->cpu, etc.
- notify any users of cpufreq, which depend on changing policy->cpu

Hence this patch, which tries to implement the above theory. It is tested well
by myself on ARM big.LITTLE TC2 SoC, which has 5 cores (2 A15 and 3 A7). Both
A15's share same struct policy and all A7's share same policy structure.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Guys,

I am just an beginner in cpufreq stuff, please ignore any foolish mistakes. :)

Yesterday, i reviewed a cpufreq driver that had some ugly code in init()
routine:
http://www.spinics.net/lists/arm-kernel/msg215348.html

It wasn't ugly due to the author of the patch, but the way
__cpufreq_remove_dev() is implemented. And then i thought to simplify it.

[Probably need to simplify cpufreq_add_dev() too, but that can be done as next
step.]

I have rebased this patch over some other cpufreq core fixes i had posted
earlier:

https://lkml.org/lkml/2012/12/16/5

ARM mail servers are broken and hence this patch can't be applied as is. :(
I have pushed this and the dependency patch here:

http://git.linaro.org/gitweb?p=arm/big.LITTLE/mp.git;a=shortlog;h=refs/heads/cpufreq-fixes-v2

@Shawn: I believe your driver don't require that ugly code anymore (Though i
know there is a situation for that to happen, if we have two cpus, you remove
second one and then add it back. With this cpufreq_add_dev() would call init()
first and then try to match if there are any managed_policies present. But the
issue you pointed out about unregistering the driver would be solved by this
patch.)

 drivers/cpufreq/cpufreq.c       | 158 +++++++++++++++++-----------------------
 drivers/cpufreq/cpufreq_stats.c |  21 +++++-
 drivers/cpufreq/freq_table.c    |  10 +++
 include/linux/cpufreq.h         |   5 ++
 4 files changed, 101 insertions(+), 93 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 271d3be..8df41ad 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1036,6 +1036,22 @@ module_out:
 	return ret;
 }
 
+static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
+{
+	unsigned int old_cpu = policy->cpu;
+	int j;
+
+	policy->cpu = cpu;
+
+	for_each_cpu(j, policy->cpus) {
+		if (!cpu_online(j))
+			continue;
+		per_cpu(cpufreq_policy_cpu, j) = cpu;
+	}
+
+	cpufreq_frequency_table_update_policy_cpu(old_cpu, cpu);
+	cpufreq_stats_update_policy_cpu(old_cpu, cpu);
+}
 
 /**
  * __cpufreq_remove_dev - remove a CPU device
@@ -1046,132 +1062,92 @@ module_out:
  */
 static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
-	unsigned int cpu = dev->id;
+	unsigned int cpu = dev->id, ret, cpus;
 	unsigned long flags;
 	struct cpufreq_policy *data;
 	struct kobject *kobj;
 	struct completion *cmp;
-#ifdef CONFIG_SMP
 	struct device *cpu_dev;
-	unsigned int j;
-#endif
 
-	pr_debug("unregistering CPU %u\n", cpu);
+	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	data = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!data) {
+		pr_debug("%s: No cpu_data found\n", __func__);
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		unlock_policy_rwsem_write(cpu);
 		return -EINVAL;
 	}
-	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
-#ifdef CONFIG_SMP
-	/* if this isn't the CPU which is the parent of the kobj, we
-	 * only need to unlink, put and exit
-	 */
-	if (unlikely(cpu != data->cpu)) {
-		pr_debug("removing link\n");
+	if (cpufreq_driver->target)
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
-		cpumask_clear_cpu(cpu, data->cpus);
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
-		__cpufreq_governor(data, CPUFREQ_GOV_START);
-		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
-
-		kobj = &dev->kobj;
-		cpufreq_cpu_put(data);
-		unlock_policy_rwsem_write(cpu);
-		sysfs_remove_link(kobj, "cpufreq");
-		return 0;
-	}
-#endif
-
-#ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
 	strncpy(per_cpu(cpufreq_cpu_governor, cpu), data->governor->name,
 			CPUFREQ_NAME_LEN);
 #endif
 
-	/* if we have other CPUs still registered, we need to unlink them,
-	 * or else wait_for_completion below will lock up. Clean the
-	 * per_cpu(cpufreq_cpu_data) while holding the lock, and remove
-	 * the sysfs links afterwards.
-	 */
-	if (unlikely(cpumask_weight(data->cpus) > 1)) {
-		for_each_cpu(j, data->cpus) {
-			if (j == cpu)
-				continue;
-			per_cpu(cpufreq_cpu_data, j) = NULL;
-		}
-	}
-
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	per_cpu(cpufreq_cpu_data, cpu) = NULL;
+	cpus = cpumask_weight(data->cpus);
+	cpumask_clear_cpu(cpu, data->cpus);
 
-	if (unlikely(cpumask_weight(data->cpus) > 1)) {
-		for_each_cpu(j, data->cpus) {
-			if (j == cpu)
-				continue;
-			pr_debug("removing link for cpu %u\n", j);
-#ifdef CONFIG_HOTPLUG_CPU
-			strncpy(per_cpu(cpufreq_cpu_governor, j),
-				data->governor->name, CPUFREQ_NAME_LEN);
-#endif
-			cpu_dev = get_cpu_device(j);
-			kobj = &cpu_dev->kobj;
+	if (unlikely((cpu == data->cpu) && (cpus > 1))) {
+		/* first sibling now owns the new sysfs dir */
+		cpu_dev = get_cpu_device(cpumask_first(data->cpus));
+		sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
+		ret = kobject_move(&data->kobj, &cpu_dev->kobj);
+		if (ret) {
+			pr_err("%s: Failed to move kobj: %d", __func__, ret);
+			cpumask_set_cpu(cpu, data->cpus);
+			ret = sysfs_create_link(&cpu_dev->kobj, &data->kobj,
+					"cpufreq");
+			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 			unlock_policy_rwsem_write(cpu);
-			sysfs_remove_link(kobj, "cpufreq");
-			lock_policy_rwsem_write(cpu);
-			cpufreq_cpu_put(data);
+			return -EINVAL;
 		}
+
+		update_policy_cpu(data, cpu_dev->id);
+		pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
+				__func__, cpu_dev->id, cpu);
 	}
-#else
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-#endif
 
-	if (cpufreq_driver->target)
-		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	kobj = &data->kobj;
-	cmp = &data->kobj_unregister;
+	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
+	cpufreq_cpu_put(data);
 	unlock_policy_rwsem_write(cpu);
-	kobject_put(kobj);
+	sysfs_remove_link(&dev->kobj, "cpufreq");
 
-	/* we need to make sure that the underlying kobj is actually
-	 * not referenced anymore by anybody before we proceed with
-	 * unloading.
-	 */
-	pr_debug("waiting for dropping of refcount\n");
-	wait_for_completion(cmp);
-	pr_debug("wait complete\n");
-
-	lock_policy_rwsem_write(cpu);
-	if (cpufreq_driver->exit)
-		cpufreq_driver->exit(data);
-	unlock_policy_rwsem_write(cpu);
+	/* If cpu is last user of policy, free policy */
+	if (cpus == 1) {
+		lock_policy_rwsem_write(cpu);
+		kobj = &data->kobj;
+		cmp = &data->kobj_unregister;
+		unlock_policy_rwsem_write(cpu);
+		kobject_put(kobj);
 
-#ifdef CONFIG_HOTPLUG_CPU
-	/* when the CPU which is the parent of the kobj is hotplugged
-	 * offline, check for siblings, and create cpufreq sysfs interface
-	 * and symlinks
-	 */
-	if (unlikely(cpumask_weight(data->cpus) > 1)) {
-		/* first sibling now owns the new sysfs dir */
-		cpumask_clear_cpu(cpu, data->cpus);
-		cpufreq_add_dev(get_cpu_device(cpumask_first(data->cpus)), NULL);
+		/* we need to make sure that the underlying kobj is actually
+		 * not referenced anymore by anybody before we proceed with
+		 * unloading.
+		 */
+		pr_debug("waiting for dropping of refcount\n");
+		wait_for_completion(cmp);
+		pr_debug("wait complete\n");
 
-		/* finally remove our own symlink */
 		lock_policy_rwsem_write(cpu);
-		__cpufreq_remove_dev(dev, sif);
-	}
-#endif
+		if (cpufreq_driver->exit)
+			cpufreq_driver->exit(data);
+		unlock_policy_rwsem_write(cpu);
 
-	free_cpumask_var(data->related_cpus);
-	free_cpumask_var(data->cpus);
-	kfree(data);
+		free_cpumask_var(data->related_cpus);
+		free_cpumask_var(data->cpus);
+		kfree(data);
+	} else if (cpufreq_driver->target) {
+		__cpufreq_governor(data, CPUFREQ_GOV_START);
+		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
+	}
 
 	return 0;
 }
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index e40e508..0afface 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -170,11 +170,13 @@ static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 static void cpufreq_stats_free_table(unsigned int cpu)
 {
 	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
+
 	if (stat) {
+		pr_debug("%s: Free stat table\n", __func__);
 		kfree(stat->time_in_state);
 		kfree(stat);
+		per_cpu(cpufreq_stats_table, cpu) = NULL;
 	}
-	per_cpu(cpufreq_stats_table, cpu) = NULL;
 }
 
 /* must be called early in the CPU removal sequence (before
@@ -183,8 +185,10 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 static void cpufreq_stats_free_sysfs(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
-	if (policy && policy->cpu == cpu)
+	if (policy && (cpumask_weight(policy->cpus) == 1)) {
+		pr_debug("%s: Free sysfs stat\n", __func__);
 		sysfs_remove_group(&policy->kobj, &stats_attr_group);
+	}
 	if (policy)
 		cpufreq_cpu_put(policy);
 }
@@ -262,6 +266,19 @@ error_get_fail:
 	return ret;
 }
 
+void cpufreq_stats_update_policy_cpu(unsigned int old_cpu,
+		unsigned int new_cpu)
+{
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, old_cpu);
+
+	pr_debug("Updating stats_table for new_cpu %u from old_cpu %u\n",
+			new_cpu, old_cpu);
+	per_cpu(cpufreq_stats_table, new_cpu) = per_cpu(cpufreq_stats_table,
+			old_cpu);
+	per_cpu(cpufreq_stats_table, old_cpu) = NULL;
+	stat->cpu = new_cpu;
+}
+
 static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
 		unsigned long val, void *data)
 {
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 49cda25..a4b384f 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -227,6 +227,16 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu)
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_put_attr);
 
+void cpufreq_frequency_table_update_policy_cpu(unsigned int old_cpu,
+		unsigned int new_cpu)
+{
+	pr_debug("Updating show_table for new_cpu %u from old_cpu %u\n",
+			new_cpu, old_cpu);
+	per_cpu(cpufreq_show_table, new_cpu) = per_cpu(cpufreq_show_table,
+			old_cpu);
+	per_cpu(cpufreq_show_table, old_cpu) = NULL;
+}
+
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu)
 {
 	return per_cpu(cpufreq_show_table, cpu);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index a55b88e..a42aa05 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -405,6 +405,11 @@ extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
 
 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
+void cpufreq_frequency_table_update_policy_cpu(unsigned int old_cpu,
+		unsigned int new_cpu);
 
 void cpufreq_frequency_table_put_attr(unsigned int cpu);
+
+void cpufreq_stats_update_policy_cpu(unsigned int old_cpu,
+		unsigned int new_cpu);
 #endif /* _LINUX_CPUFREQ_H */
-- 
1.7.12.rc2.18.g61b472e


