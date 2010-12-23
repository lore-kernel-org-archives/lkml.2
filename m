Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab0LWGOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:14:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:54294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab0LWGOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:14:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,218,1291622400"; 
   d="scan'208";a="690073815"
From: Youquan Song <youquan.song@intel.com>
To: davej@redhat.com, cpufreq@vger.kernle.org
Cc: venki@google.com, arjan@linux.intel.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 4/6] cpufreq: Add dynamic sampling window tunable
Date: Thu, 23 Dec 2010 14:17:04 +0800
Message-Id: <1293085026-18173-5-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1293085026-18173-4-git-send-email-youquan.song@intel.com>
References: <1293085026-18173-1-git-send-email-youquan.song@intel.com>
 <1293085026-18173-2-git-send-email-youquan.song@intel.com>
 <1293085026-18173-3-git-send-email-youquan.song@intel.com>
 <1293085026-18173-4-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add window_is_dynamic tuable, which will use to enable or disable dynamic
adjust current sampling window size.
It is useful. Such as in my test platform, kernel build benchmark will achieve
better power performance when dynamic sampling window is disabled. While 
compress-7zip will achieve better perforamance when dynamic sampling window is
enabled.


Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 5242d24..5dd3770 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -296,6 +296,7 @@ show_one(sampling_down_factor, sampling_down_factor);
 show_one(ignore_nice_load, ignore_nice);
 show_one(powersave_bias, powersave_bias);
 show_one(sampling_window, sampling_window);
+show_one(window_is_dynamic, window_is_dynamic);
 
 /*** delete after deprecation time ***/
 
@@ -492,6 +493,26 @@ static ssize_t store_sampling_window(struct kobject *a, struct attribute *b,
 	return count;
 }
 
+static ssize_t store_window_is_dynamic(struct kobject *a, struct attribute *b,
+				    const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+
+	if (ret != 1)
+		return -EINVAL;
+
+	if (input != 0)
+		input = 1;
+
+	mutex_lock(&dbs_mutex);
+	dbs_tuners_ins.window_is_dynamic = input;
+	mutex_unlock(&dbs_mutex);
+
+	return count;
+}
+
 define_one_global_rw(sampling_rate);
 define_one_global_rw(io_is_busy);
 define_one_global_rw(up_threshold);
@@ -499,6 +520,7 @@ define_one_global_rw(sampling_down_factor);
 define_one_global_rw(ignore_nice_load);
 define_one_global_rw(powersave_bias);
 define_one_global_rw(sampling_window);
+define_one_global_rw(window_is_dynamic);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_max.attr,
@@ -510,6 +532,7 @@ static struct attribute *dbs_attributes[] = {
 	&powersave_bias.attr,
 	&io_is_busy.attr,
 	&sampling_window.attr,
+	&window_is_dynamic.attr,
 	NULL
 };
 
-- 
1.6.4.2

