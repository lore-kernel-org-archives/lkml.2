Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0EJFzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:55:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:33897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab0EJFy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:54:57 -0400
Date: Mon, 10 May 2010 05:54:36 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, pavel@ucw.cz,
       riel@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, pavel@ucw.cz,
       riel@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100509082651.46914d04@infradead.org>
References: <20100509082651.46914d04@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] ondemand: Make the iowait-is-busy time a sysfs tunable
Message-ID: <tip-19379b11819efc1fc3b602e64f7e7531050aaddb@git.kernel.org>
Git-Commit-ID: 19379b11819efc1fc3b602e64f7e7531050aaddb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 05:54:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19379b11819efc1fc3b602e64f7e7531050aaddb
Gitweb:     http://git.kernel.org/tip/19379b11819efc1fc3b602e64f7e7531050aaddb
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sun, 9 May 2010 08:26:51 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 May 2010 19:35:27 +0200

ondemand: Make the iowait-is-busy time a sysfs tunable

Pavel Machek pointed out that not all CPUs have an efficient
idle at high frequency. Specifically, older Intel and various
AMD cpus would get a higher powerusage when copying files from
USB.

Mike Chan pointed out that the same is true for various ARM
chips as well.

Thomas Renninger suggested to make this a sysfs tunable with a
reasonable default.

This patch adds a sysfs tunable for the new behavior, and uses
a very simple function to determine a reasonable default,
depending on the CPU vendor/type.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
LKML-Reference: <20100509082651.46914d04@infradead.org>
[ minor tidyup ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/cpufreq/cpufreq_ondemand.c |   47 +++++++++++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index ed472f8..8e9dbdc 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -109,6 +109,7 @@ static struct dbs_tuners {
 	unsigned int down_differential;
 	unsigned int ignore_nice;
 	unsigned int powersave_bias;
+	unsigned int io_is_busy;
 } dbs_tuners_ins = {
 	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
 	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
@@ -260,6 +261,7 @@ static ssize_t show_##file_name						\
 	return sprintf(buf, "%u\n", dbs_tuners_ins.object);		\
 }
 show_one(sampling_rate, sampling_rate);
+show_one(io_is_busy, io_is_busy);
 show_one(up_threshold, up_threshold);
 show_one(ignore_nice_load, ignore_nice);
 show_one(powersave_bias, powersave_bias);
@@ -310,6 +312,23 @@ static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
 	return count;
 }
 
+static ssize_t store_io_is_busy(struct kobject *a, struct attribute *b,
+				   const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+
+	mutex_lock(&dbs_mutex);
+	dbs_tuners_ins.io_is_busy = !!input;
+	mutex_unlock(&dbs_mutex);
+
+	return count;
+}
+
 static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
 				  const char *buf, size_t count)
 {
@@ -392,6 +411,7 @@ static struct global_attr _name = \
 __ATTR(_name, 0644, show_##_name, store_##_name)
 
 define_one_rw(sampling_rate);
+define_one_rw(io_is_busy);
 define_one_rw(up_threshold);
 define_one_rw(ignore_nice_load);
 define_one_rw(powersave_bias);
@@ -403,6 +423,7 @@ static struct attribute *dbs_attributes[] = {
 	&up_threshold.attr,
 	&ignore_nice_load.attr,
 	&powersave_bias.attr,
+	&io_is_busy.attr,
 	NULL
 };
 
@@ -527,7 +548,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		 * from the cpu idle time.
 		 */
 
-		if (idle_time >= iowait_time)
+		if (dbs_tuners_ins.io_is_busy && idle_time >= iowait_time)
 			idle_time -= iowait_time;
 
 		if (unlikely(!wall_time || wall_time < idle_time))
@@ -643,6 +664,29 @@ static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
 	cancel_delayed_work_sync(&dbs_info->work);
 }
 
+/*
+ * Not all CPUs want IO time to be accounted as busy; this dependson how
+ * efficient idling at a higher frequency/voltage is.
+ * Pavel Machek says this is not so for various generations of AMD and old
+ * Intel systems.
+ * Mike Chan (androidlcom) calis this is also not true for ARM.
+ * Because of this, whitelist specific known (series) of CPUs by default, and
+ * leave all others up to the user.
+ */
+static int should_io_be_busy(void)
+{
+#if defined(CONFIG_X86)
+	/*
+	 * For Intel, Core 2 (model 15) andl later have an efficient idle.
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+	    boot_cpu_data.x86 == 6 &&
+	    boot_cpu_data.x86_model >= 15)
+		return 1;
+#endif
+	return 0;
+}
+
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				   unsigned int event)
 {
@@ -705,6 +749,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			dbs_tuners_ins.sampling_rate =
 				max(min_sampling_rate,
 				    latency * LATENCY_MULTIPLIER);
+			dbs_tuners_ins.io_is_busy = should_io_be_busy();
 		}
 		mutex_unlock(&dbs_mutex);
 
