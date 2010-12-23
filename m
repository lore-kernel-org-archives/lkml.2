Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0LWGOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:14:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:54294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab0LWGOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:14:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,218,1291622400"; 
   d="scan'208";a="690073801"
From: Youquan Song <youquan.song@intel.com>
To: davej@redhat.com, cpufreq@vger.kernle.org
Cc: venki@google.com, arjan@linux.intel.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 3/6] cpufreq: Add roll back non-sampling_window
Date: Thu, 23 Dec 2010 14:17:03 +0800
Message-Id: <1293085026-18173-4-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1293085026-18173-3-git-send-email-youquan.song@intel.com>
References: <1293085026-18173-1-git-send-email-youquan.song@intel.com>
 <1293085026-18173-2-git-send-email-youquan.song@intel.com>
 <1293085026-18173-3-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When sampling window is set to default sampling rate, the sampling window will
roll back to orignal behaviour. The up_threshold and down_differential also set
to original ones.


Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 87aec7f..5242d24 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -469,11 +469,24 @@ static ssize_t store_sampling_window(struct kobject *a, struct attribute *b,
 	if (input > 1000000)
 		input = 1000000;
 
-	if (input < 10000)
-		input = 10000;
+	if (input < dbs_tuners_ins.sampling_rate)
+		input = dbs_tuners_ins.sampling_rate;
 
 	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.sampling_window = input;
+	/* User set sampling window equal default sampling rate,
+	 * It means that user want disable sampling window, so
+	 * return to legacy sampling mode
+	 * */
+	if (input == dbs_tuners_ins.sampling_rate) {
+		dbs_tuners_ins.up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
+		dbs_tuners_ins.down_differential =
+			MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
+	} else {
+		dbs_tuners_ins.up_threshold = SAMPLING_WINDOW_UP_THRESHOLD;
+		dbs_tuners_ins.down_differential =
+			SAMPLING_WINDOW_DOWN_DIFFERENTIAL;
+	}
 	mutex_unlock(&dbs_mutex);
 
 	return count;
@@ -720,7 +733,8 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		}
 	}
 
-	if (sampling_window_enable)
+	if (sampling_window_enable && (dbs_tuners_ins.sampling_window !=
+						dbs_tuners_ins.sampling_rate))
 		/* Get the average load in the lastest sampling window */
 		max_load_freq = get_load_freq_during_sampling_window(
 				this_dbs_info, max_load_freq,
-- 
1.6.4.2

