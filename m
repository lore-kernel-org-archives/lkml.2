Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0LWGVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:21:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:9769 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0LWGVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:21:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,217,1291622400"; 
   d="scan'208";a="690075349"
From: Youquan Song <youquan.song@intel.com>
To: davej@redhat.com, cpufreq@vger.kernel.org
Cc: venki@google.com, arjan@linux.intel.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 6/6] cpufreq: Evaluate P1 before enter turbo mode
Date: Thu, 23 Dec 2010 14:23:44 +0800
Message-Id: <1293085424-18212-7-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1293085424-18212-6-git-send-email-youquan.song@intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
 <1293085424-18212-2-git-send-email-youquan.song@intel.com>
 <1293085424-18212-3-git-send-email-youquan.song@intel.com>
 <1293085424-18212-4-git-send-email-youquan.song@intel.com>
 <1293085424-18212-5-git-send-email-youquan.song@intel.com>
 <1293085424-18212-6-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Turbo Mode (P0) will comsume much more power compare with second largest
frequency (P1) and P1 frequency is often double, even more, with Pn lowest
frequency; Current logic will increase sharply to highest frequency Turbo Mode
when workload reach to up_threshold of current frequency capacity, even current
frequency at lowest frequency. In this patchset, it will firstly evaluate P1 if
it is enough to support current workload before directly enter into Turbo Mode.
If P1 can meet workload requirement, it will save power compare of being Turbo
Mode.  

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |    7 ++++++-
 drivers/cpufreq/freq_table.c       |    9 +++++++++
 include/linux/cpufreq.h            |    1 +
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 85ca136..682b2ea 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -797,7 +797,12 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		if (policy->cur < policy->max)
 			this_dbs_info->rate_mult =
 				dbs_tuners_ins.sampling_down_factor;
-		dbs_freq_increase(policy, policy->max);
+		/* Before go to turbo, try P1 first */
+		if ((policy->max > policy->sec_max) &&
+				(policy->cur == policy->sec_max))
+			dbs_freq_increase(policy, policy->max);
+		else
+			dbs_freq_increase(policy, policy->sec_max);
 		return;
 	}
 
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 0543221..d7dc010 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -26,6 +26,7 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 {
 	unsigned int min_freq = ~0;
 	unsigned int max_freq = 0;
+	unsigned int sec_max_freq = 0;
 	unsigned int i;
 
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
@@ -41,10 +42,18 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 			min_freq = freq;
 		if (freq > max_freq)
 			max_freq = freq;
+		/* Find the second largest frequency */
+		if ((freq < max_freq) && (freq > sec_max_freq))
+			sec_max_freq = freq;
 	}
 
 	policy->min = policy->cpuinfo.min_freq = min_freq;
 	policy->max = policy->cpuinfo.max_freq = max_freq;
+	/* Check CPU turbo mode enabled */
+	if (max_freq - sec_max_freq == 1000)
+		policy->sec_max = sec_max_freq;
+	else
+		policy->sec_max = max_freq;
 
 	if (policy->min == ~0)
 		return -EINVAL;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index c3e9de8..0087e56 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -92,6 +92,7 @@ struct cpufreq_policy {
 
 	unsigned int		min;    /* in kHz */
 	unsigned int		max;    /* in kHz */
+	unsigned int		sec_max; /* in kHz*/
 	unsigned int		cur;    /* in kHz, only needed if cpufreq
 					 * governors are used */
         unsigned int		policy; /* see above */
-- 
1.6.4.2

