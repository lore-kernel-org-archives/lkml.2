Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0CVSio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:38:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45212 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab0CVSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:38:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: <akpm@linux-foundation.org>, davej@redhat.com
Cc: cpufreq@vger.kernel.org, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] cpufreq: Unify sysfs attribute definition macros
Date: Mon, 22 Mar 2010 19:38:37 +0100
Message-Id: <1269283121-11894-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269283121-11894-1-git-send-email-bp@amd64.org>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Multiple modules used to define those which are with identical
functionality and were needlessly replicated among the different cpufreq
drivers. Push them into the header and remove duplication.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/cpufreq/cpufreq.c              |   40 +++++++++-----------------
 drivers/cpufreq/cpufreq_conservative.c |   48 ++++++++++---------------------
 drivers/cpufreq/cpufreq_ondemand.c     |   40 ++++++++------------------
 include/linux/cpufreq.h                |   30 ++++++++++++++++++++
 4 files changed, 72 insertions(+), 86 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d5d575..6bfea8d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -662,32 +662,20 @@ static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
 	return sprintf(buf, "%u\n", policy->cpuinfo.max_freq);
 }
 
-#define define_one_ro(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0444, show_##_name, NULL)
-
-#define define_one_ro0400(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0400, show_##_name, NULL)
-
-#define define_one_rw(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_ro0400(cpuinfo_cur_freq);
-define_one_ro(cpuinfo_min_freq);
-define_one_ro(cpuinfo_max_freq);
-define_one_ro(cpuinfo_transition_latency);
-define_one_ro(scaling_available_governors);
-define_one_ro(scaling_driver);
-define_one_ro(scaling_cur_freq);
-define_one_ro(bios_limit);
-define_one_ro(related_cpus);
-define_one_ro(affected_cpus);
-define_one_rw(scaling_min_freq);
-define_one_rw(scaling_max_freq);
-define_one_rw(scaling_governor);
-define_one_rw(scaling_setspeed);
+define_one_freq_ro_perm(cpuinfo_cur_freq, 0400);
+define_one_freq_ro(cpuinfo_min_freq);
+define_one_freq_ro(cpuinfo_max_freq);
+define_one_freq_ro(cpuinfo_transition_latency);
+define_one_freq_ro(scaling_available_governors);
+define_one_freq_ro(scaling_driver);
+define_one_freq_ro(scaling_cur_freq);
+define_one_freq_ro(bios_limit);
+define_one_freq_ro(related_cpus);
+define_one_freq_ro(affected_cpus);
+define_one_freq_rw(scaling_min_freq);
+define_one_freq_rw(scaling_max_freq);
+define_one_freq_rw(scaling_governor);
+define_one_freq_rw(scaling_setspeed);
 
 static struct attribute *default_attrs[] = {
 	&cpuinfo_min_freq.attr,
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 599a40b..0fddbca 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -178,12 +178,8 @@ static ssize_t show_sampling_rate_min(struct kobject *kobj,
 	return sprintf(buf, "%u\n", min_sampling_rate);
 }
 
-#define define_one_ro(_name)		\
-static struct global_attr _name =	\
-__ATTR(_name, 0444, show_##_name, NULL)
-
-define_one_ro(sampling_rate_max);
-define_one_ro(sampling_rate_min);
+define_one_global_ro(sampling_rate_max);
+define_one_global_ro(sampling_rate_min);
 
 /* cpufreq_conservative Governor Tunables */
 #define show_one(file_name, object)					\
@@ -221,12 +217,8 @@ show_one_old(freq_step);
 show_one_old(sampling_rate_min);
 show_one_old(sampling_rate_max);
 
-#define define_one_ro_old(object, _name)	\
-static struct freq_attr object =		\
-__ATTR(_name, 0444, show_##_name##_old, NULL)
-
-define_one_ro_old(sampling_rate_min_old, sampling_rate_min);
-define_one_ro_old(sampling_rate_max_old, sampling_rate_max);
+define_one_freq_ro_old(sampling_rate_min);
+define_one_freq_ro_old(sampling_rate_max);
 
 /*** delete after deprecation time ***/
 
@@ -364,16 +356,12 @@ static ssize_t store_freq_step(struct kobject *a, struct attribute *b,
 	return count;
 }
 
-#define define_one_rw(_name) \
-static struct global_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_rw(sampling_rate);
-define_one_rw(sampling_down_factor);
-define_one_rw(up_threshold);
-define_one_rw(down_threshold);
-define_one_rw(ignore_nice_load);
-define_one_rw(freq_step);
+define_one_global_rw(sampling_rate);
+define_one_global_rw(sampling_down_factor);
+define_one_global_rw(up_threshold);
+define_one_global_rw(down_threshold);
+define_one_global_rw(ignore_nice_load);
+define_one_global_rw(freq_step);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_max.attr,
@@ -409,16 +397,12 @@ write_one_old(down_threshold);
 write_one_old(ignore_nice_load);
 write_one_old(freq_step);
 
-#define define_one_rw_old(object, _name)	\
-static struct freq_attr object =		\
-__ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
-
-define_one_rw_old(sampling_rate_old, sampling_rate);
-define_one_rw_old(sampling_down_factor_old, sampling_down_factor);
-define_one_rw_old(up_threshold_old, up_threshold);
-define_one_rw_old(down_threshold_old, down_threshold);
-define_one_rw_old(ignore_nice_load_old, ignore_nice_load);
-define_one_rw_old(freq_step_old, freq_step);
+define_one_freq_rw_old(sampling_rate);
+define_one_freq_rw_old(sampling_down_factor);
+define_one_freq_rw_old(up_threshold);
+define_one_freq_rw_old(down_threshold);
+define_one_freq_rw_old(ignore_nice_load);
+define_one_freq_rw_old(freq_step);
 
 static struct attribute *dbs_attributes_old[] = {
 	&sampling_rate_max_old.attr,
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index bd444dc..cb07f48 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -234,12 +234,8 @@ static ssize_t show_sampling_rate_min(struct kobject *kobj,
 	return sprintf(buf, "%u\n", min_sampling_rate);
 }
 
-#define define_one_ro(_name)		\
-static struct global_attr _name =	\
-__ATTR(_name, 0444, show_##_name, NULL)
-
-define_one_ro(sampling_rate_max);
-define_one_ro(sampling_rate_min);
+define_one_global_ro(sampling_rate_max);
+define_one_global_ro(sampling_rate_min);
 
 /* cpufreq_ondemand Governor Tunables */
 #define show_one(file_name, object)					\
@@ -274,12 +270,8 @@ show_one_old(powersave_bias);
 show_one_old(sampling_rate_min);
 show_one_old(sampling_rate_max);
 
-#define define_one_ro_old(object, _name)       \
-static struct freq_attr object =               \
-__ATTR(_name, 0444, show_##_name##_old, NULL)
-
-define_one_ro_old(sampling_rate_min_old, sampling_rate_min);
-define_one_ro_old(sampling_rate_max_old, sampling_rate_max);
+define_one_freq_ro_old(sampling_rate_min);
+define_one_freq_ro_old(sampling_rate_max);
 
 /*** delete after deprecation time ***/
 
@@ -376,14 +368,10 @@ static ssize_t store_powersave_bias(struct kobject *a, struct attribute *b,
 	return count;
 }
 
-#define define_one_rw(_name) \
-static struct global_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_rw(sampling_rate);
-define_one_rw(up_threshold);
-define_one_rw(ignore_nice_load);
-define_one_rw(powersave_bias);
+define_one_global_rw(sampling_rate);
+define_one_global_rw(up_threshold);
+define_one_global_rw(ignore_nice_load);
+define_one_global_rw(powersave_bias);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_max.attr,
@@ -415,14 +403,10 @@ write_one_old(up_threshold);
 write_one_old(ignore_nice_load);
 write_one_old(powersave_bias);
 
-#define define_one_rw_old(object, _name)       \
-static struct freq_attr object =               \
-__ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
-
-define_one_rw_old(sampling_rate_old, sampling_rate);
-define_one_rw_old(up_threshold_old, up_threshold);
-define_one_rw_old(ignore_nice_load_old, ignore_nice_load);
-define_one_rw_old(powersave_bias_old, powersave_bias);
+define_one_freq_rw_old(sampling_rate);
+define_one_freq_rw_old(up_threshold);
+define_one_freq_rw_old(ignore_nice_load);
+define_one_freq_rw_old(powersave_bias);
 
 static struct attribute *dbs_attributes_old[] = {
        &sampling_rate_max_old.attr,
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4de02b1..c8d731c 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -278,6 +278,27 @@ struct freq_attr {
 	ssize_t (*store)(struct cpufreq_policy *, const char *, size_t count);
 };
 
+#define define_one_freq_ro(_name)		\
+static struct freq_attr _name =			\
+__ATTR(_name, 0444, show_##_name, NULL)
+
+#define define_one_freq_ro_perm(_name, _perm)	\
+static struct freq_attr _name =			\
+__ATTR(_name, _perm, show_##_name, NULL)
+
+#define define_one_freq_ro_old(_name)		\
+static struct freq_attr _name##_old =		\
+__ATTR(_name, 0444, show_##_name##_old, NULL)
+
+#define define_one_freq_rw(_name)		\
+static struct freq_attr _name =			\
+__ATTR(_name, 0644, show_##_name, store_##_name)
+
+#define define_one_freq_rw_old(_name)		\
+static struct freq_attr _name##_old =		\
+__ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
+
+
 struct global_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct kobject *kobj,
@@ -286,6 +307,15 @@ struct global_attr {
 			 const char *c, size_t count);
 };
 
+#define define_one_global_ro(_name)		\
+static struct global_attr _name =		\
+__ATTR(_name, 0444, show_##_name, NULL)
+
+#define define_one_global_rw(_name)		\
+static struct global_attr _name =		\
+__ATTR(_name, 0644, show_##_name, store_##_name)
+
+
 /*********************************************************************
  *                        CPUFREQ 2.6. INTERFACE                     *
  *********************************************************************/
-- 
1.7.0

