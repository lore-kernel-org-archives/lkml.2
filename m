Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab1E0ENa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:13:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39336 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1E0EN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:13:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF24D9.40607@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:13:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 12/12] x86, mce: use prefix mce_sysdev_ to group functions
References: <4DDF21DE.9040705@jp.fujitsu.com>
In-Reply-To: <4DDF21DE.9040705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many functions named mce_*, so use new prefix for
subset of functions to make it clear that the function is
related to sysfs support.

  Before:			After:
   mce_device   		 mce_sysdev
   mce_suspend  		 mce_sysdev_suspend
   mce_shutdown 		 mce_sysdev_shutdown
   mce_resume   		 mce_sysdev_resume
   mce_sysclass 		 mce_sysdev_class
   mce_attrs    		 mce_sysdev_attrs
   mce_dev_initialized  	 mce_sysdev_initialized
   mce_create_device    	 mce_sysdev_create
   mce_remove_device    	 mce_sysdev_remove

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h           |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c     |   58 +++++++++++++++++-----------------
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   10 +++---
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index bbb328f..716b48a 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -149,7 +149,7 @@ static inline void enable_p5_mce(void) {}
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
-DECLARE_PER_CPU(struct sys_device, mce_dev);
+DECLARE_PER_CPU(struct sys_device, mce_sysdev);
 
 /*
  * Maximum banks number.
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ba2fc2d..357aae8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1693,7 +1693,7 @@ int __init mcheck_init(void)
 }
 
 /*
- * Sysfs support
+ * mce_sysdev: Sysfs support
  */
 
 /*
@@ -1713,12 +1713,12 @@ static int mce_disable_error_reporting(void)
 	return 0;
 }
 
-static int mce_suspend(void)
+static int mce_sysdev_suspend(void)
 {
 	return mce_disable_error_reporting();
 }
 
-static void mce_shutdown(void)
+static void mce_sysdev_shutdown(void)
 {
 	mce_disable_error_reporting();
 }
@@ -1728,16 +1728,16 @@ static void mce_shutdown(void)
  * Only one CPU is active at this time, the others get re-added later using
  * CPU hotplug:
  */
-static void mce_resume(void)
+static void mce_sysdev_resume(void)
 {
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(__this_cpu_ptr(&cpu_info));
 }
 
 static struct syscore_ops mce_syscore_ops = {
-	.suspend	= mce_suspend,
-	.shutdown	= mce_shutdown,
-	.resume		= mce_resume,
+	.suspend	= mce_sysdev_suspend,
+	.shutdown	= mce_sysdev_shutdown,
+	.resume		= mce_sysdev_resume,
 };
 
 static void mce_cpu_restart(void *data)
@@ -1775,11 +1775,11 @@ static void mce_enable_ce(void *all)
 		__mcheck_cpu_init_timer();
 }
 
-static struct sysdev_class mce_sysclass = {
+static struct sysdev_class mce_sysdev_class = {
 	.name		= "machinecheck",
 };
 
-DEFINE_PER_CPU(struct sys_device, mce_dev);
+DEFINE_PER_CPU(struct sys_device, mce_sysdev);
 
 __cpuinitdata
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
@@ -1908,7 +1908,7 @@ static struct sysdev_ext_attribute attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
-static struct sysdev_attribute *mce_attrs[] = {
+static struct sysdev_attribute *mce_sysdev_attrs[] = {
 	&attr_tolerant.attr,
 	&attr_check_interval.attr,
 	&attr_trigger,
@@ -1919,12 +1919,12 @@ static struct sysdev_attribute *mce_attrs[] = {
 	NULL
 };
 
-static cpumask_var_t mce_dev_initialized;
+static cpumask_var_t mce_sysdev_initialized;
 
 /* Per cpu sysdev init. All of the cpus still share the same ctrl bank: */
-static __cpuinit int mce_create_device(unsigned int cpu)
+static __cpuinit int mce_sysdev_create(unsigned int cpu)
 {
-	struct sys_device *sysdev = &per_cpu(mce_dev, cpu);
+	struct sys_device *sysdev = &per_cpu(mce_sysdev, cpu);
 	int err;
 	int i, j;
 
@@ -1933,14 +1933,14 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 
 	memset(&sysdev->kobj, 0, sizeof(struct kobject));
 	sysdev->id  = cpu;
-	sysdev->cls = &mce_sysclass;
+	sysdev->cls = &mce_sysdev_class;
 
 	err = sysdev_register(sysdev);
 	if (err)
 		return err;
 
-	for (i = 0; mce_attrs[i]; i++) {
-		err = sysdev_create_file(sysdev, mce_attrs[i]);
+	for (i = 0; mce_sysdev_attrs[i]; i++) {
+		err = sysdev_create_file(sysdev, mce_sysdev_attrs[i]);
 		if (err)
 			goto error;
 	}
@@ -1949,7 +1949,7 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 		if (err)
 			goto error2;
 	}
-	cpumask_set_cpu(cpu, mce_dev_initialized);
+	cpumask_set_cpu(cpu, mce_sysdev_initialized);
 
 	return 0;
 error2:
@@ -1957,29 +1957,29 @@ error2:
 		sysdev_remove_file(sysdev, &mce_banks[j].attr);
 error:
 	while (--i >= 0)
-		sysdev_remove_file(sysdev, mce_attrs[i]);
+		sysdev_remove_file(sysdev, mce_sysdev_attrs[i]);
 
 	sysdev_unregister(sysdev);
 
 	return err;
 }
 
-static __cpuinit void mce_remove_device(unsigned int cpu)
+static __cpuinit void mce_sysdev_remove(unsigned int cpu)
 {
-	struct sys_device *sysdev = &per_cpu(mce_dev, cpu);
+	struct sys_device *sysdev = &per_cpu(mce_sysdev, cpu);
 	int i;
 
-	if (!cpumask_test_cpu(cpu, mce_dev_initialized))
+	if (!cpumask_test_cpu(cpu, mce_sysdev_initialized))
 		return;
 
-	for (i = 0; mce_attrs[i]; i++)
-		sysdev_remove_file(sysdev, mce_attrs[i]);
+	for (i = 0; mce_sysdev_attrs[i]; i++)
+		sysdev_remove_file(sysdev, mce_sysdev_attrs[i]);
 
 	for (i = 0; i < banks; i++)
 		sysdev_remove_file(sysdev, &mce_banks[i].attr);
 
 	sysdev_unregister(sysdev);
-	cpumask_clear_cpu(cpu, mce_dev_initialized);
+	cpumask_clear_cpu(cpu, mce_sysdev_initialized);
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
@@ -2029,7 +2029,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		mce_create_device(cpu);
+		mce_sysdev_create(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		break;
@@ -2037,7 +2037,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DEAD_FROZEN:
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
-		mce_remove_device(cpu);
+		mce_sysdev_remove(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
@@ -2091,16 +2091,16 @@ static __init int mcheck_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	zalloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
+	zalloc_cpumask_var(&mce_sysdev_initialized, GFP_KERNEL);
 
 	mce_init_banks();
 
-	err = sysdev_class_register(&mce_sysclass);
+	err = sysdev_class_register(&mce_sysdev_class);
 	if (err)
 		return err;
 
 	for_each_online_cpu(i) {
-		err = mce_create_device(i);
+		err = mce_sysdev_create(i);
 		if (err)
 			return err;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index bb0adad..f547421 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -548,7 +548,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (!b)
 			goto out;
 
-		err = sysfs_create_link(&per_cpu(mce_dev, cpu).kobj,
+		err = sysfs_create_link(&per_cpu(mce_sysdev, cpu).kobj,
 					b->kobj, name);
 		if (err)
 			goto out;
@@ -571,7 +571,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		goto out;
 	}
 
-	b->kobj = kobject_create_and_add(name, &per_cpu(mce_dev, cpu).kobj);
+	b->kobj = kobject_create_and_add(name, &per_cpu(mce_sysdev, cpu).kobj);
 	if (!b->kobj)
 		goto out_free;
 
@@ -591,7 +591,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (i == cpu)
 			continue;
 
-		err = sysfs_create_link(&per_cpu(mce_dev, i).kobj,
+		err = sysfs_create_link(&per_cpu(mce_sysdev, i).kobj,
 					b->kobj, name);
 		if (err)
 			goto out;
@@ -669,7 +669,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 #ifdef CONFIG_SMP
 	/* sibling symlink */
 	if (shared_bank[bank] && b->blocks->cpu != cpu) {
-		sysfs_remove_link(&per_cpu(mce_dev, cpu).kobj, name);
+		sysfs_remove_link(&per_cpu(mce_sysdev, cpu).kobj, name);
 		per_cpu(threshold_banks, cpu)[bank] = NULL;
 
 		return;
@@ -681,7 +681,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 		if (i == cpu)
 			continue;
 
-		sysfs_remove_link(&per_cpu(mce_dev, i).kobj, name);
+		sysfs_remove_link(&per_cpu(mce_sysdev, i).kobj, name);
 		per_cpu(threshold_banks, i)[bank] = NULL;
 	}
 
-- 
1.7.1


