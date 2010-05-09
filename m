Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0EIPYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:24:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:40385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EIPY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:24:29 -0400
Date: Sun, 9 May 2010 08:26:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
Subject: [PATCH v2  8/8] ondemand: Make the iowait-is-busy time a sysfs
 tunable
Message-ID: <20100509082651.46914d04@infradead.org>
In-Reply-To: <20100509082126.4a080d46@infradead.org>
References: <20100509082126.4a080d46@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 3 May 2010 21:40:32 -0400
Subject: [PATCH] ondemand: Make the iowait-is-busy-time a sysfs tunable

Pavel Machek pointed out that not all CPUs have an efficient idle
at high frequency. Specifically, older Intel and various AMD cpus
would get a higher powerusage when copying files from USB.

Mike Chan pointed out that the same is true for various ARM chips
as well.

Thomas Renninger suggested to make this a sysfs tunable with a
reasonable default.

This patch adds a sysfs tunable for the new behavior, and uses
a very simple function to determine a reasonable default, depending
on the CPU vendor/type.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/cpufreq/cpufreq_ondemand.c |   46 +++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index ed472f8..4877e8f 100644
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
@@ -310,6 +312,22 @@ static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
 	return count;
 }
 
+static ssize_t store_io_is_busy(struct kobject *a, struct attribute *b,
+				   const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
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
@@ -392,6 +410,7 @@ static struct global_attr _name = \
 __ATTR(_name, 0644, show_##_name, store_##_name)
 
 define_one_rw(sampling_rate);
+define_one_rw(io_is_busy);
 define_one_rw(up_threshold);
 define_one_rw(ignore_nice_load);
 define_one_rw(powersave_bias);
@@ -403,6 +422,7 @@ static struct attribute *dbs_attributes[] = {
 	&up_threshold.attr,
 	&ignore_nice_load.attr,
 	&powersave_bias.attr,
+	&io_is_busy.attr,
 	NULL
 };
 
@@ -527,7 +547,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		 * from the cpu idle time.
 		 */
 
-		if (idle_time >= iowait_time)
+		if (dbs_tuners_ins.io_is_busy && idle_time >= iowait_time)
 			idle_time -= iowait_time;
 
 		if (unlikely(!wall_time || wall_time < idle_time))
@@ -643,6 +663,29 @@ static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
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
@@ -705,6 +748,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			dbs_tuners_ins.sampling_rate =
 				max(min_sampling_rate,
 				    latency * LATENCY_MULTIPLIER);
+			dbs_tuners_ins.io_is_busy = should_io_be_busy();
 		}
 		mutex_unlock(&dbs_mutex);
 
-- 
1.6.1.3

