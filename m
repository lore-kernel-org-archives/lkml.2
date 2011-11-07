Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1KGViB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:38:01 -0500
Received: from www.linutronix.de ([62.245.132.108]:42266 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1KGVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:37:59 -0500
Date: Mon, 7 Nov 2011 22:37:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.0.8-rt22
Message-ID: <alpine.LFD.2.02.1111072225340.2694@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.0.8-rt21 release.

3.0.8-rt21 is an not announced intermediate release, which only
updates to 3.0.8. No rt changes except dropping patches which made it
into 3.0.8.

Changes from 3.0.8-rt21 to 3.0.8-rt22

  * Revert cpufreq changes

  * Fix some hotplug issues (Yong, myself)

  * Require constant freq TSC for KVM on RT (replaces the cpufreq
    tinkering which led to other nasty issues)

Delta patch against 3.0.8-rt21

  https://tglx.de/~tglx/rt/incr/patch-3.0.8-rt21-rt22.patch.gz

also appended below.


Patch against 3.0.8 can be found here:

  https://tglx.de/~tglx/rt/patch-3.0.8-rt22.patch.gz


The split quilt queue is available at:

  https://tglx.de/~tglx/rt/patches-3.0.8-rt22.tar.gz


Some folks were asking about an 3.1 based RT. I'm not going to release
one (though it should be trivial). I really want to stabilize 3.0 and
not create a side show which diverts testing. Next version I'm
targeting is 3.2 starting soon after the merge window closes.

Enjoy,

	tglx

--------------->
Index: linux-2.6/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-2.6.orig/drivers/cpufreq/cpufreq.c
+++ linux-2.6/drivers/cpufreq/cpufreq.c
@@ -43,7 +43,7 @@ static DEFINE_PER_CPU(struct cpufreq_pol
 /* This one keeps track of the previously set governor of a removed CPU */
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
-static DEFINE_RAW_SPINLOCK(cpufreq_driver_lock);
+static DEFINE_SPINLOCK(cpufreq_driver_lock);
 
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -138,7 +138,7 @@ struct cpufreq_policy *cpufreq_cpu_get(u
 		goto err_out;
 
 	/* get the cpufreq driver */
-	raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	if (!cpufreq_driver)
 		goto err_out_unlock;
@@ -156,13 +156,13 @@ struct cpufreq_policy *cpufreq_cpu_get(u
 	if (!kobject_get(&data->kobj))
 		goto err_out_put_module;
 
-	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	return data;
 
 err_out_put_module:
 	module_put(cpufreq_driver->owner);
 err_out_unlock:
-	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 err_out:
 	return NULL;
 }
@@ -722,10 +722,10 @@ static int cpufreq_add_dev_policy(unsign
 				return -EBUSY;
 			}
 
-			raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
+			spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			cpumask_copy(managed_policy->cpus, policy->cpus);
 			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
-			raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 			pr_debug("CPU already managed, adding link\n");
 			ret = sysfs_create_link(&sys_dev->kobj,
@@ -821,16 +821,14 @@ static int cpufreq_add_dev_interface(uns
 			goto err_out_kobj_put;
 	}
 
-	get_online_cpus();
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
 		if (!cpu_online(j))
 			continue;
-		raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
-		raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	}
-	put_online_cpus();
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
@@ -972,13 +970,10 @@ static int cpufreq_add_dev(struct sys_de
 
 
 err_out_unregister:
-	get_online_cpus();
-	for_each_cpu(j, policy->cpus) {
-		raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
-		raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-	}
-	put_online_cpus();
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
@@ -1018,11 +1013,11 @@ static int __cpufreq_remove_dev(struct s
 
 	pr_debug("unregistering CPU %u\n", cpu);
 
-	raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	data = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!data) {
-		raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		unlock_policy_rwsem_write(cpu);
 		return -EINVAL;
 	}
@@ -1036,7 +1031,7 @@ static int __cpufreq_remove_dev(struct s
 	if (unlikely(cpu != data->cpu)) {
 		pr_debug("removing link\n");
 		cpumask_clear_cpu(cpu, data->cpus);
-		raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		kobj = &sys_dev->kobj;
 		cpufreq_cpu_put(data);
 		unlock_policy_rwsem_write(cpu);
@@ -1045,7 +1040,6 @@ static int __cpufreq_remove_dev(struct s
 	}
 #endif
 
-	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1058,17 +1052,15 @@ static int __cpufreq_remove_dev(struct s
 	 * per_cpu(cpufreq_cpu_data) while holding the lock, and remove
 	 * the sysfs links afterwards.
 	 */
-	get_online_cpus();
 	if (unlikely(cpumask_weight(data->cpus) > 1)) {
 		for_each_cpu(j, data->cpus) {
 			if (j == cpu)
 				continue;
-			raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			per_cpu(cpufreq_cpu_data, j) = NULL;
-			raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		}
 	}
-	put_online_cpus();
+
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (unlikely(cpumask_weight(data->cpus) > 1)) {
 		for_each_cpu(j, data->cpus) {
@@ -1087,6 +1079,8 @@ static int __cpufreq_remove_dev(struct s
 			cpufreq_cpu_put(data);
 		}
 	}
+#else
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 
 	if (cpufreq_driver->target)
@@ -1808,13 +1802,13 @@ int cpufreq_register_driver(struct cpufr
 	if (driver_data->setpolicy)
 		driver_data->flags |= CPUFREQ_CONST_LOOPS;
 
-	raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	if (cpufreq_driver) {
-		raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		return -EBUSY;
 	}
 	cpufreq_driver = driver_data;
-	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	ret = sysdev_driver_register(&cpu_sysdev_class,
 					&cpufreq_sysdev_driver);
@@ -1848,9 +1842,9 @@ err_sysdev_unreg:
 	sysdev_driver_unregister(&cpu_sysdev_class,
 			&cpufreq_sysdev_driver);
 err_null_driver:
-	raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
-	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpufreq_register_driver);
@@ -1876,9 +1870,9 @@ int cpufreq_unregister_driver(struct cpu
 	sysdev_driver_unregister(&cpu_sysdev_class, &cpufreq_sysdev_driver);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
-	raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
+	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
-	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	return 0;
 }
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -337,22 +337,20 @@ static int __ref _cpu_down(unsigned int 
 		return -EBUSY;
 	}
 
-	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
+	cpu_hotplug_begin();
+	err = cpu_unplug_begin(cpu);
 	if (err) {
-		nr_calls--;
-		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
-		printk("%s: attempt to take down CPU %u failed\n",
-				__func__, cpu);
+		printk("cpu_unplug_begin(%d) failed\n", cpu);
 		goto out_cancel;
 	}
 
-	cpu_hotplug_begin();
-	err = cpu_unplug_begin(cpu);
+	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (err) {
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
-		printk("cpu_unplug_begin(%d) failed\n", cpu);
-		goto out_cancel;
+		printk("%s: attempt to take down CPU %u failed\n",
+				__func__, cpu);
+		goto out_release;
 	}
 
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2403,7 +2403,12 @@ static int select_fallback_rq(int cpu, s
 		printk(KERN_INFO "process %d (%s) no longer affine to cpu%d\n",
 				task_pid_nr(p), p->comm, cpu);
 	}
-
+	/*
+	 * Clear PF_THREAD_BOUND, otherwise we wreckage
+	 * migrate_disable/enable. See optimization for
+	 * PF_THREAD_BOUND tasks there.
+	 */
+	p->flags &= ~PF_THREAD_BOUND;
 	return dest_cpu;
 }
 
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -3192,6 +3192,11 @@ static int __devinit workqueue_cpu_up_ca
 		new_worker = create_worker(gcwq, false);
 		if (!new_worker)
 			return NOTIFY_BAD;
+	case CPU_UP_CANCELED:
+	case CPU_ONLINE:
+		break;
+	default:
+		return notifier_from_errno(0);
 	}
 
 	/* some are called w/ irq disabled, don't disturb irq status */
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt21
+-rt22
Index: linux-2.6/arch/x86/kvm/x86.c
===================================================================
--- linux-2.6.orig/arch/x86/kvm/x86.c
+++ linux-2.6/arch/x86/kvm/x86.c
@@ -4900,6 +4900,13 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		printk(KERN_ERR "RT requires X86_FEATURE_CONSTANT_TSC\n");
+		return -EOPNOTSUPP;
+	}
+#endif
+
 	r = kvm_mmu_module_init();
 	if (r)
 		goto out;
