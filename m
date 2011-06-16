Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1FPLU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:20:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:50366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab1FPLU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:20:57 -0400
Date: Thu, 16 Jun 2011 11:20:47 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-c7cece89f1b00b56276303942f96ec67cf206e1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED81B.8020506@jp.fujitsu.com>
References: <4DEED81B.8020506@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce: Use mce_sysdev_ prefix to group functions
Git-Commit-ID: c7cece89f1b00b56276303942f96ec67cf206e1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:20:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7cece89f1b00b56276303942f96ec67cf206e1e
Gitweb:     http://git.kernel.org/tip/c7cece89f1b00b56276303942f96ec67cf206e1e
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 11:02:03 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:10:16 +0200

x86, mce: Use mce_sysdev_ prefix to group functions

There are many functions named mce_* so use a new prefix for the subset
of functions related to sysfs support.

And since f3c6ea1b06c71b43f751b36bd99345369fe911af introduces
syscore_ops, use the prefix mce_syscore for some functions related to
power management which were in sysdev_class before.

  Before:			After:
   mce_device   		 mce_sysdev
   mce_sysclass 		 mce_sysdev_class
   mce_attrs    		 mce_sysdev_attrs
   mce_dev_initialized  	 mce_sysdev_initialized
   mce_create_device    	 mce_sysdev_create
   mce_remove_device    	 mce_sysdev_remove

   mce_suspend  		 mce_syscore_suspend
   mce_shutdown 		 mce_syscore_shutdown
   mce_resume   		 mce_syscore_resume

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED81B.8020506@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h           |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c     |   62 ++++++++++++++++++----------------
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   10 +++---
 3 files changed, 39 insertions(+), 35 deletions(-)

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
index 9a73516..08363b0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1697,7 +1697,7 @@ int __init mcheck_init(void)
 }
 
 /*
- * Sysfs support
+ * mce_syscore: PM support
  */
 
 /*
@@ -1717,12 +1717,12 @@ static int mce_disable_error_reporting(void)
 	return 0;
 }
 
-static int mce_suspend(void)
+static int mce_syscore_suspend(void)
 {
 	return mce_disable_error_reporting();
 }
 
-static void mce_shutdown(void)
+static void mce_syscore_shutdown(void)
 {
 	mce_disable_error_reporting();
 }
@@ -1732,18 +1732,22 @@ static void mce_shutdown(void)
  * Only one CPU is active at this time, the others get re-added later using
  * CPU hotplug:
  */
-static void mce_resume(void)
+static void mce_syscore_resume(void)
 {
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(__this_cpu_ptr(&cpu_info));
 }
 
 static struct syscore_ops mce_syscore_ops = {
-	.suspend	= mce_suspend,
-	.shutdown	= mce_shutdown,
-	.resume		= mce_resume,
+	.suspend	= mce_syscore_suspend,
+	.shutdown	= mce_syscore_shutdown,
+	.resume		= mce_syscore_resume,
 };
 
+/*
+ * mce_sysdev: Sysfs support
+ */
+
 static void mce_cpu_restart(void *data)
 {
 	del_timer_sync(&__get_cpu_var(mce_timer));
@@ -1779,11 +1783,11 @@ static void mce_enable_ce(void *all)
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
@@ -1912,7 +1916,7 @@ static struct sysdev_ext_attribute attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
-static struct sysdev_attribute *mce_attrs[] = {
+static struct sysdev_attribute *mce_sysdev_attrs[] = {
 	&attr_tolerant.attr,
 	&attr_check_interval.attr,
 	&attr_trigger,
@@ -1923,12 +1927,12 @@ static struct sysdev_attribute *mce_attrs[] = {
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
 
@@ -1937,14 +1941,14 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 
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
@@ -1953,7 +1957,7 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 		if (err)
 			goto error2;
 	}
-	cpumask_set_cpu(cpu, mce_dev_initialized);
+	cpumask_set_cpu(cpu, mce_sysdev_initialized);
 
 	return 0;
 error2:
@@ -1961,29 +1965,29 @@ error2:
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
@@ -2033,7 +2037,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		mce_create_device(cpu);
+		mce_sysdev_create(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		break;
@@ -2041,7 +2045,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DEAD_FROZEN:
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
-		mce_remove_device(cpu);
+		mce_sysdev_remove(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
@@ -2095,16 +2099,16 @@ static __init int mcheck_init_device(void)
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
 
