Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2KFNMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:12:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:55294 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2KFNMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:12:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,722,1344236400"; 
   d="scan'208";a="165055837"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, alex.shi@intel.com,
        rjw@sisk.pl, paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com
Subject: [RFC PATCH 1/3] sched: add sched_policy and it's sysfs interface
Date: Tue,  6 Nov 2012 21:09:57 +0800
Message-Id: <1352207399-29497-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the power aware scheduler knob into sysfs:

$cat /sys/devices/system/cpu/sched_policy/available_sched_policy
performance powersaving

$cat /sys/devices/system/cpu/sched_policy/current_sched_policy
powersaving

The using sched policy is 'powersaving'. User can change the policy
by commend 'echo':
 echo performance > /sys/devices/system/cpu/current_sched_policy

Power aware scheduling will has different behavior according to
different policy:

performance: the current scheduling behaviour, try to spread tasks
		on more CPU sockets or cores.
powersaving: will shrink tasks into sched group until the group's
		nr_running is up to group_weight.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu | 21 +++++++
 drivers/base/cpu.c                                 |  2 +
 include/linux/cpu.h                                |  2 +
 kernel/sched/fair.c                                | 68 +++++++++++++++++++++-
 kernel/sched/sched.h                               |  5 ++
 5 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 6943133..1909d3e 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -53,6 +53,27 @@ Description:	Dynamic addition and removal of CPU's.  This is not hotplug
 		the system.  Information writtento the file to remove CPU's
 		is architecture specific.
 
+What:		/sys/devices/system/cpu/sched_policy/current_sched_policy
+		/sys/devices/system/cpu/sched_policy/available_sched_policy
+Date:		Oct 2012
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	CFS scheduler policy showing and setting interface.
+
+		available_sched_policy shows there are 2 kinds of policy now:
+		performance and powersaving.
+		current_sched_policy shows current scheduler policy. And user
+		can change the policy by writing it.
+
+		Policy decides that CFS scheduler how to distribute tasks onto
+		which CPU unit when tasks number less than LCPU number in system
+
+		performance: try to spread tasks onto more CPU sockets,
+		more CPU cores.
+
+		powersaving:     try to shrink tasks onto same core or same CPU
+		until running task number beyond the LCPU number in the core
+		or socket.
+
 What:		/sys/devices/system/cpu/cpu#/node
 Date:		October 2009
 Contact:	Linux memory management mailing list <linux-mm@kvack.org>
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 6345294..5f6a573 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -330,4 +330,6 @@ void __init cpu_dev_init(void)
 		panic("Failed to register CPU subsystem");
 
 	cpu_dev_register_generic();
+
+	create_sysfs_sched_policy_group(cpu_subsys.dev_root);
 }
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..b2e9265 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -36,6 +36,8 @@ extern void cpu_remove_dev_attr(struct device_attribute *attr);
 extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
+extern int create_sysfs_sched_policy_group(struct device *dev);
+
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
 extern ssize_t arch_cpu_probe(const char *, size_t);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2cebc81..dedc576 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6383,7 +6383,6 @@ void unregister_fair_sched_group(struct task_group *tg, int cpu) { }
 
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-
 static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
 	struct sched_entity *se = &task->se;
@@ -6399,6 +6398,73 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	return rr_interval;
 }
 
+/* The default scheduler policy is 'performance'. */
+int __read_mostly sched_policy = SCHED_POLICY_PERFORMANCE;
+
+#ifdef CONFIG_SYSFS
+static ssize_t show_available_sched_policy(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "performance powersaving\n");
+}
+
+static ssize_t show_current_sched_policy(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	if (sched_policy == SCHED_POLICY_PERFORMANCE)
+		return sprintf(buf, "performance\n");
+	else if (sched_policy == SCHED_POLICY_POWERSAVING)
+		return sprintf(buf, "powersaving\n");
+	return 0;
+}
+
+static ssize_t set_sched_policy(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	unsigned int ret = -EINVAL;
+	char    str_policy[16];
+
+	ret = sscanf(buf, "%15s", str_policy);
+	if (ret != 1)
+		return -EINVAL;
+
+	if (!strcmp(str_policy, "performance"))
+		sched_policy = SCHED_POLICY_PERFORMANCE;
+	else if (!strcmp(str_policy, "powersaving"))
+		sched_policy = SCHED_POLICY_POWERSAVING;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+/*
+ *  * Sysfs setup bits:
+ *   */
+static DEVICE_ATTR(current_sched_policy, 0644, show_current_sched_policy,
+						set_sched_policy);
+
+static DEVICE_ATTR(available_sched_policy, 0444,
+		show_available_sched_policy, NULL);
+
+static struct attribute *sched_policy_default_attrs[] = {
+	&dev_attr_current_sched_policy.attr,
+	&dev_attr_available_sched_policy.attr,
+	NULL
+};
+static struct attribute_group sched_policy_attr_group = {
+	.attrs = sched_policy_default_attrs,
+	.name = "sched_policy",
+};
+
+int __init create_sysfs_sched_policy_group(struct device *dev)
+{
+	return sysfs_create_group(&dev->kobj, &sched_policy_attr_group);
+}
+#endif /* CONFIG_SYSFS */
+
 /*
  * All the scheduling class methods:
  */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 508e77e..9a6e06c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -9,6 +9,11 @@
 
 extern __read_mostly int scheduler_running;
 
+#define SCHED_POLICY_PERFORMANCE	(0x1)
+#define SCHED_POLICY_POWERSAVING	(0x2)
+
+extern int __read_mostly sched_policy;
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
-- 
1.7.12

