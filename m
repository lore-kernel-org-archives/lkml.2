Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1LCSf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:35:29 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38221 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab1LCSfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:35:24 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 6/7] driver-core/cpu: Add cpu_is_hotpluggable() for rcutorture error analysis
Date: Sat,  3 Dec 2011 10:34:41 -0800
Message-Id: <1322937282-19846-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111203183417.GA18914@linux.vnet.ibm.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
x-cbid: 11120318-5806-0000-0000-0000103C5683
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The rcutorture test now can automatically exercise CPU hotplug and
collect success statistics, which can be correlated with other rcutorture
activity.  This permits rcutorture to completely exercise RCU regardless
of what sort of userspace and filesystem layout is in use.  Unfortunately,
rcutorture is happy to attempt to offline CPUs that cannot be offlined,
for example, CPU 0 in both the x86 and ARM architectures.  Although this
allows rcutorture testing to proceed normally, it confounds attempts at
error analysis due to the resulting flood of spurious CPU-hotplug errors.

Therefore, this commit creates a cpu_is_hotpluggable() function that
allows rcutorture to avoid attempting to offline CPUs that are not
hotpluggable, which in turn allows rcutorture to avoid reporting spurious
CPU-hotplug errors.  Note that this function is EXPORT_SYMBOL_GPL()
to allow rcutorture to use it when compiled as a kernel module.
This commit also includes modifications to rcutorture to use this
new function.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 drivers/base/cpu.c  |   12 +++++++++++-
 include/linux/cpu.h |    1 +
 kernel/rcutorture.c |    4 ++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..17f9b58 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -23,6 +23,7 @@ struct sysdev_class cpu_sysdev_class = {
 EXPORT_SYMBOL(cpu_sysdev_class);
 
 static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
+static DEFINE_PER_CPU(bool, is_hotpluggable);
 
 #ifdef CONFIG_HOTPLUG_CPU
 static ssize_t show_online(struct sys_device *dev, struct sysdev_attribute *attr,
@@ -76,6 +77,7 @@ void unregister_cpu(struct cpu *cpu)
 
 	sysdev_unregister(&cpu->sysdev);
 	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
+	per_cpu(is_hotpluggable, logical_cpu) = 0;
 	return;
 }
 
@@ -224,8 +226,10 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 
 	error = sysdev_register(&cpu->sysdev);
 
-	if (!error && cpu->hotpluggable)
+	if (!error && cpu->hotpluggable) {
 		register_cpu_control(cpu);
+		per_cpu(is_hotpluggable, num) = 1;
+	}
 	if (!error)
 		per_cpu(cpu_sys_devices, num) = &cpu->sysdev;
 	if (!error)
@@ -238,6 +242,12 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 	return error;
 }
 
+bool cpu_is_hotpluggable(int num)
+{
+	return per_cpu(is_hotpluggable, num);
+}
+EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
+
 struct sys_device *get_cpu_sysdev(unsigned cpu)
 {
 	if (cpu < nr_cpu_ids && cpu_possible(cpu))
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 6cb60fd..be140ef 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -26,6 +26,7 @@ struct cpu {
 };
 
 extern int register_cpu(struct cpu *cpu, int num);
+extern bool cpu_is_hotpluggable(int num);
 extern struct sys_device *get_cpu_sysdev(unsigned cpu);
 
 extern int cpu_add_sysdev_attr(struct sysdev_attribute *attr);
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 1e422ae..186ead9 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1388,7 +1388,7 @@ rcu_torture_onoff(void *arg)
 	WARN_ON(maxcpu < 0);
 	while (!kthread_should_stop()) {
 		cpu = (rcu_random(&rand) >> 4) % (maxcpu + 1);
-		if (cpu_online(cpu)) {
+		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
 			if (verbose)
 				printk(KERN_ALERT "%s" TORTURE_FLAG
 				       "rcu_torture_onoff task: offlining %d\n",
@@ -1402,7 +1402,7 @@ rcu_torture_onoff(void *arg)
 					       torture_type, cpu);
 				n_offline_successes++;
 			}
-		} else {
+		} else if (cpu_is_hotpluggable(cpu)) {
 			if (verbose)
 				printk(KERN_ALERT "%s" TORTURE_FLAG
 				       "rcu_torture_onoff task: onlining %d\n",
-- 
1.7.3.2

