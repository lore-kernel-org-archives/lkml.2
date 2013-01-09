Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab3AIPqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:46:09 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:57271 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab3AIPqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:46:07 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 10:46:07 EST
MIME-Version: 1.0
In-Reply-To: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
References: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
Date: Wed, 9 Jan 2013 21:09:25 +0530
Message-ID: <CAKohpo=ajxxanDPNpdxiJO8vvcQPxeQA29sZgeRtRg85F4CVGg@mail.gmail.com>
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
> [Probably need to simplify cpufreq_add_dev() too, but that can be done as next
> step.]

I have tried that too, it is also pushed at:

https://lkml.org/lkml/2012/12/16/5

[Untested for now, will be doing it tomorrow]

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Wed, 9 Jan 2013 21:02:50 +0530
Subject: [PATCH] cpufreq: Simplify cpufreq_add_dev()

Currently cpufreq_add_dev() firsts allocated policy, calls ->init() and then
checks if this cpu should be already managed or not. And if it already managed,
free its policy.

We can save all this if we somehow know if this cpu is managed or not in
advance. policy->related_cpus contains list of all valid sibling cpus of
policy->cpu. We can check this to know if current cpu is already managed.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 150 ++++++++++++++++------------------------------
 1 file changed, 52 insertions(+), 98 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b8709899..e3f7c7b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -701,92 +701,6 @@ static struct kobj_type ktype_cpufreq = {
 	.release	= cpufreq_sysfs_release,
 };

-/*
- * Returns:
- *   Negative: Failure
- *   0:        Success
- *   Positive: When we have a managed CPU and the sysfs got symlinked
- */
-static int cpufreq_add_dev_policy(unsigned int cpu,
-				  struct cpufreq_policy *policy,
-				  struct device *dev)
-{
-	int ret = 0;
-#ifdef CONFIG_SMP
-	unsigned long flags;
-	unsigned int j;
-#ifdef CONFIG_HOTPLUG_CPU
-	struct cpufreq_governor *gov;
-
-	gov = __find_governor(per_cpu(cpufreq_cpu_governor, cpu));
-	if (gov) {
-		policy->governor = gov;
-		pr_debug("Restoring governor %s for cpu %d\n",
-		       policy->governor->name, cpu);
-	}
-#endif
-
-	for_each_cpu(j, policy->cpus) {
-		struct cpufreq_policy *managed_policy;
-
-		if (cpu == j)
-			continue;
-
-		/* Check for existing affected CPUs.
-		 * They may not be aware of it due to CPU Hotplug.
-		 * cpufreq_cpu_put is called when the device is removed
-		 * in __cpufreq_remove_dev()
-		 */
-		managed_policy = cpufreq_cpu_get(j);
-		if (unlikely(managed_policy)) {
-
-			/* Set proper policy_cpu */
-			unlock_policy_rwsem_write(cpu);
-			per_cpu(cpufreq_policy_cpu, cpu) = managed_policy->cpu;
-
-			if (lock_policy_rwsem_write(cpu) < 0) {
-				/* Should not go through policy unlock path */
-				if (cpufreq_driver->exit)
-					cpufreq_driver->exit(policy);
-				cpufreq_cpu_put(managed_policy);
-				return -EBUSY;
-			}
-
-			__cpufreq_governor(managed_policy, CPUFREQ_GOV_STOP);
-
-			spin_lock_irqsave(&cpufreq_driver_lock, flags);
-			cpumask_copy(managed_policy->cpus, policy->cpus);
-			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
-			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
-			__cpufreq_governor(managed_policy, CPUFREQ_GOV_START);
-			__cpufreq_governor(managed_policy, CPUFREQ_GOV_LIMITS);
-
-			pr_debug("CPU already managed, adding link\n");
-			ret = sysfs_create_link(&dev->kobj,
-						&managed_policy->kobj,
-						"cpufreq");
-			if (ret)
-				cpufreq_cpu_put(managed_policy);
-			/*
-			 * Success. We only needed to be added to the mask.
-			 * Call driver->exit() because only the cpu parent of
-			 * the kobj needed to call init().
-			 */
-			if (cpufreq_driver->exit)
-				cpufreq_driver->exit(policy);
-
-			if (!ret)
-				return 1;
-			else
-				return ret;
-		}
-	}
-#endif
-	return ret;
-}
-
-
 /* symlink affected CPUs */
 static int cpufreq_add_dev_symlink(unsigned int cpu,
 				   struct cpufreq_policy *policy)
@@ -891,6 +805,41 @@ err_out_kobj_put:
 	return ret;
 }

+static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
+				  struct device *dev)
+{
+	struct cpufreq_policy *policy;
+	int ret = 0;
+	unsigned long flags;
+
+	policy = cpufreq_cpu_get(sibling);
+	WARN_ON(!policy);
+
+	per_cpu(cpufreq_policy_cpu, cpu) = policy->cpu;
+
+	lock_policy_rwsem_write(cpu);
+
+	__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
+
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	cpumask_set_cpu(cpu, policy->cpus);
+	per_cpu(cpufreq_cpu_data, cpu) = policy;
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+	__cpufreq_governor(policy, CPUFREQ_GOV_START);
+	__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
+
+	unlock_policy_rwsem_write(cpu);
+
+	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
+	if (ret) {
+		cpufreq_cpu_put(policy);
+		return ret;
+	}
+
+	return 0;
+}
+

 /**
  * cpufreq_add_dev - add a CPU device
@@ -903,12 +852,12 @@ err_out_kobj_put:
  */
 static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 {
-	unsigned int cpu = dev->id;
-	int ret = 0, found = 0;
+	unsigned int j, cpu = dev->id;
+	int ret = -ENOMEM, found = 0;
 	struct cpufreq_policy *policy;
 	unsigned long flags;
-	unsigned int j;
 #ifdef CONFIG_HOTPLUG_CPU
+	struct cpufreq_governor *gov;
 	int sibling;
 #endif

@@ -925,6 +874,13 @@ static int cpufreq_add_dev(struct device *dev,
struct subsys_interface *sif)
 		cpufreq_cpu_put(policy);
 		return 0;
 	}
+
+	/* Check if this cpu was hot-unplugged earlier and has siblings */
+	for_each_online_cpu(sibling) {
+		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
+		if (cp && cpumask_test_cpu(cpu, cp->related_cpus))
+			return cpufreq_add_policy_cpu(cpu, sibling, dev);
+	}
 #endif

 	if (!try_module_get(cpufreq_driver->owner)) {
@@ -932,7 +888,6 @@ static int cpufreq_add_dev(struct device *dev,
struct subsys_interface *sif)
 		goto module_out;
 	}

-	ret = -ENOMEM;
 	policy = kzalloc(sizeof(struct cpufreq_policy), GFP_KERNEL);
 	if (!policy)
 		goto nomem_out;
@@ -990,14 +945,14 @@ static int cpufreq_add_dev(struct device *dev,
struct subsys_interface *sif)
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);

-	ret = cpufreq_add_dev_policy(cpu, policy, dev);
-	if (ret) {
-		if (ret > 0)
-			/* This is a managed cpu, symlink created,
-			   exit with 0 */
-			ret = 0;
-		goto err_unlock_policy;
+#ifdef CONFIG_HOTPLUG_CPU
+	gov = __find_governor(per_cpu(cpufreq_cpu_governor, cpu));
+	if (gov) {
+		policy->governor = gov;
+		pr_debug("Restoring governor %s for cpu %d\n",
+		       policy->governor->name, cpu);
 	}
+#endif

 	ret = cpufreq_add_dev_interface(cpu, policy, dev);
 	if (ret)
@@ -1011,7 +966,6 @@ static int cpufreq_add_dev(struct device *dev,
struct subsys_interface *sif)

 	return 0;

-
 err_out_unregister:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus)
