Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab0CVSix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:38:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45249 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab0CVSiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:38:52 -0400
From: Borislav Petkov <bp@amd64.org>
To: <akpm@linux-foundation.org>, davej@redhat.com
Cc: cpufreq@vger.kernel.org, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] cpufreq: Add support for actual freq
Date: Mon, 22 Mar 2010 19:38:41 +0100
Message-Id: <1269283121-11894-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269283121-11894-1-git-send-email-bp@amd64.org>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Modify the scaling_cur_freq interface to show the actual core frequency
when boosting is supported and enabled on the core.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   18 ++++++++++++++++++
 drivers/cpufreq/cpufreq.c                 |    9 ++++++++-
 include/linux/cpufreq.h                   |    1 +
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index f411250..a36a18c 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -58,6 +58,8 @@ static int cpu_family = CPU_OPTERON;
 static bool cpb_capable, cpb_disabled;
 static struct msr __percpu *msrs;
 
+static bool can_aperf_mperf;
+
 static struct cpufreq_driver cpufreq_amd64_driver;
 
 #ifndef CONFIG_SMP
@@ -1465,6 +1467,18 @@ static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
 
 define_one_freq_rw(cpb);
 
+static ssize_t show_actual_freq(struct cpufreq_policy *policy, char *buf)
+{
+	unsigned long freq;
+
+	if (can_aperf_mperf)
+		freq = cpufreq_get_measured_perf(policy, policy->cpu);
+	else
+		freq = policy->cur;
+
+	return sprintf(buf, "%lu\n", freq);
+}
+
 static struct freq_attr *powernow_k8_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
 	&cpb,
@@ -1478,6 +1492,7 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
 	.init		= powernowk8_cpu_init,
 	.exit		= __devexit_p(powernowk8_cpu_exit),
 	.get		= powernowk8_get,
+	.cur_freq	= show_actual_freq,
 	.name		= "powernow-k8",
 	.owner		= THIS_MODULE,
 	.attr		= powernow_k8_attr,
@@ -1531,6 +1546,9 @@ static int __cpuinit powernowk8_init(void)
 			printk(KERN_CONT "on.\n");
 	}
 
+	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
+		can_aperf_mperf = true;
+
 	return cpufreq_register_driver(&cpufreq_amd64_driver);
 }
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6bfea8d..bf34307 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -457,7 +457,14 @@ show_one(cpuinfo_max_freq, cpuinfo.max_freq);
 show_one(cpuinfo_transition_latency, cpuinfo.transition_latency);
 show_one(scaling_min_freq, min);
 show_one(scaling_max_freq, max);
-show_one(scaling_cur_freq, cur);
+
+static ssize_t show_scaling_cur_freq(struct cpufreq_policy *policy, char *buf)
+{
+	if (cpufreq_driver->cur_freq)
+		return cpufreq_driver->cur_freq(policy, buf);
+
+	return sprintf(buf, "%u\n", policy->cur);
+}
 
 static int __cpufreq_set_policy(struct cpufreq_policy *data,
 				struct cpufreq_policy *policy);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index c8d731c..5744312 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -237,6 +237,7 @@ struct cpufreq_driver {
 	int	(*exit)		(struct cpufreq_policy *policy);
 	int	(*suspend)	(struct cpufreq_policy *policy, pm_message_t pmsg);
 	int	(*resume)	(struct cpufreq_policy *policy);
+	ssize_t (*cur_freq)	(struct cpufreq_policy *policy, char *buf);
 	struct freq_attr	**attr;
 };
 
-- 
1.7.0

