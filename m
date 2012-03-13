Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab2CMXWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:22:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49137 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2CMXWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:22:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        JBeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] [CPUFREQ]: provide disable_cpufreq() function to disable the API.
Date: Tue, 13 Mar 2012 19:18:39 -0400
Message-Id: <1331680720-18268-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1331680720-18268-1-git-send-email-konrad.wilk@oracle.com>
References: <1331680720-18268-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F5FD6C2.005B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

useful for disabling cpufreq altogether. The cpu frequency
scaling drivers and cpu frequency governors will fail to register.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/cpufreq/cpufreq.c |   24 ++++++++++++++++++++++++
 include/linux/cpufreq.h   |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 622013f..7f2f149 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -126,6 +126,15 @@ static int __init init_cpufreq_transition_notifier_list(void)
 }
 pure_initcall(init_cpufreq_transition_notifier_list);
 
+static int off __read_mostly;
+int cpufreq_disabled(void)
+{
+	return off;
+}
+void disable_cpufreq(void)
+{
+	off = 1;
+}
 static LIST_HEAD(cpufreq_governor_list);
 static DEFINE_MUTEX(cpufreq_governor_mutex);
 
@@ -1441,6 +1450,9 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 {
 	int retval = -EINVAL;
 
+	if (cpufreq_disabled())
+		return -ENODEV;
+
 	pr_debug("target for CPU %u: %u kHz, relation %u\n", policy->cpu,
 		target_freq, relation);
 	if (cpu_online(policy->cpu) && cpufreq_driver->target)
@@ -1549,6 +1561,9 @@ int cpufreq_register_governor(struct cpufreq_governor *governor)
 	if (!governor)
 		return -EINVAL;
 
+	if (cpufreq_disabled())
+		return -ENODEV;
+
 	mutex_lock(&cpufreq_governor_mutex);
 
 	err = -EBUSY;
@@ -1572,6 +1587,9 @@ void cpufreq_unregister_governor(struct cpufreq_governor *governor)
 	if (!governor)
 		return;
 
+	if (cpufreq_disabled())
+		return;
+
 #ifdef CONFIG_HOTPLUG_CPU
 	for_each_present_cpu(cpu) {
 		if (cpu_online(cpu))
@@ -1814,6 +1832,9 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	unsigned long flags;
 	int ret;
 
+	if (cpufreq_disabled())
+		return -ENODEV;
+
 	if (!driver_data || !driver_data->verify || !driver_data->init ||
 	    ((!driver_data->setpolicy) && (!driver_data->target)))
 		return -EINVAL;
@@ -1901,6 +1922,9 @@ static int __init cpufreq_core_init(void)
 {
 	int cpu;
 
+	if (cpufreq_disabled())
+		return -ENODEV;
+
 	for_each_possible_cpu(cpu) {
 		per_cpu(cpufreq_policy_cpu, cpu) = -1;
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 6216115..8ff4427 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -35,6 +35,7 @@
 #ifdef CONFIG_CPU_FREQ
 int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
 int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
+extern void disable_cpufreq(void);
 #else		/* CONFIG_CPU_FREQ */
 static inline int cpufreq_register_notifier(struct notifier_block *nb,
 						unsigned int list)
@@ -46,6 +47,7 @@ static inline int cpufreq_unregister_notifier(struct notifier_block *nb,
 {
 	return 0;
 }
+static inline void disable_cpufreq(void) { }
 #endif		/* CONFIG_CPU_FREQ */
 
 /* if (cpufreq_driver->target) exists, the ->governor decides what frequency
-- 
1.7.9.48.g85da4d

