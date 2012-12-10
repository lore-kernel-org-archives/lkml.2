Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2LJI0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:26:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2LJI0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808752"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 11/18] sched: add sched_policy and it's sysfs interface
Date: Mon, 10 Dec 2012 16:22:27 +0800
Message-Id: <1355127754-8444-12-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the power aware scheduler knob into sysfs:

$cat /sys/devices/system/cpu/sched_policy/available_sched_policy
performance powersaving balance
$cat /sys/devices/system/cpu/sched_policy/current_sched_policy
powersaving

This means the using sched policy is 'powersaving'.

User can change the policy by commend 'echo':
 echo performance > /sys/devices/system/cpu/current_sched_policy

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   24 +++++++
 drivers/base/cpu.c                                 |    2 +
 include/linux/cpu.h                                |    2 +
 kernel/sched/fair.c                                |   71 ++++++++++++++++++++
 4 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 6943133..9c9acbf 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -53,6 +53,30 @@ Description:	Dynamic addition and removal of CPU's.  This is not hotplug
 		the system.  Information writtento the file to remove CPU's
 		is architecture specific.
 
+What:		/sys/devices/system/cpu/sched_policy/current_sched_policy
+		/sys/devices/system/cpu/sched_policy/available_sched_policy
+Date:		Oct 2012
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	CFS scheduler policy showing and setting interface.
+
+		available_sched_policy shows there are 3 kinds of policy now:
+		performance, balance and powersaving.
+		current_sched_policy shows current scheduler policy. And user
+		can change the policy by writing it.
+
+		Policy decides that CFS scheduler how to distribute tasks onto
+		which CPU unit when tasks number less than LCPU number in system
+
+		performance: try to spread tasks onto more CPU sockets,
+		more CPU cores.
+
+		powersaving: try to shrink tasks onto same core or same CPU
+		until every LCPUs are busy.
+
+		balance:     try to shrink tasks onto same core or same CPU
+		until full powered CPUs are busy. This policy also consider
+		system performance when try to save power.
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
index 2cf8673..1b1deb8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5871,6 +5871,77 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 
 /* The default scheduler policy is 'performance'. */
 int __read_mostly sched_policy = SCHED_POLICY_PERFORMANCE;
+
+#ifdef CONFIG_SYSFS
+static ssize_t show_available_sched_policy(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "performance balance powersaving\n");
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
+	else if (sched_policy == SCHED_POLICY_BALANCE)
+		return sprintf(buf, "balance\n");
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
+	else if (!strcmp(str_policy, "balance"))
+		sched_policy = SCHED_POLICY_BALANCE;
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
+#else
+int __init create_sysfs_sched_policy_group(struct device *dev) {}
+#endif /* CONFIG_SYSFS */
+
 /*
  * All the scheduling class methods:
  */
-- 
1.7.5.1

