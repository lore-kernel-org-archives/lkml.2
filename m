Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab0LWGVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:21:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:10802 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0LWGVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:21:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,217,1291622400"; 
   d="scan'208";a="690075328"
From: Youquan Song <youquan.song@intel.com>
To: davej@redhat.com, cpufreq@vger.kernel.org
Cc: venki@google.com, arjan@linux.intel.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 5/6] cpufreq: Add down_differential tunable
Date: Thu, 23 Dec 2010 14:23:43 +0800
Message-Id: <1293085424-18212-6-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1293085424-18212-5-git-send-email-youquan.song@intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
 <1293085424-18212-2-git-send-email-youquan.song@intel.com>
 <1293085424-18212-3-git-send-email-youquan.song@intel.com>
 <1293085424-18212-4-git-send-email-youquan.song@intel.com>
 <1293085424-18212-5-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add down_differential tuable for user adjust ondemand governor decrease
frequency threshold. down_differential is used in original ondemand governor
code, but it does not add it as tunable, so I add it as tunable in this patch 

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 5dd3770..85ca136 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -292,6 +292,7 @@ static ssize_t show_##file_name						\
 show_one(sampling_rate, sampling_rate);
 show_one(io_is_busy, io_is_busy);
 show_one(up_threshold, up_threshold);
+show_one(down_differential, down_differential);
 show_one(sampling_down_factor, sampling_down_factor);
 show_one(ignore_nice_load, ignore_nice);
 show_one(powersave_bias, powersave_bias);
@@ -513,9 +514,33 @@ static ssize_t store_window_is_dynamic(struct kobject *a, struct attribute *b,
 	return count;
 }
 
+static ssize_t store_down_differential(struct kobject *a, struct attribute *b,
+				    const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+
+	if (ret != 1)
+		return -EINVAL;
+
+	if (input > 30)
+		input = 30;
+
+	if (input < 0)
+		input = 0;
+
+	mutex_lock(&dbs_mutex);
+	dbs_tuners_ins.down_differential = input;
+	mutex_unlock(&dbs_mutex);
+
+	return count;
+}
+
 define_one_global_rw(sampling_rate);
 define_one_global_rw(io_is_busy);
 define_one_global_rw(up_threshold);
+define_one_global_rw(down_differential);
 define_one_global_rw(sampling_down_factor);
 define_one_global_rw(ignore_nice_load);
 define_one_global_rw(powersave_bias);
@@ -527,6 +552,7 @@ static struct attribute *dbs_attributes[] = {
 	&sampling_rate_min.attr,
 	&sampling_rate.attr,
 	&up_threshold.attr,
+	&down_differential.attr,
 	&sampling_down_factor.attr,
 	&ignore_nice_load.attr,
 	&powersave_bias.attr,
-- 
1.6.4.2

