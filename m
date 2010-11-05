Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0KEDF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:05:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:65534 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0KEDFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:05:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,300,1286175600"; 
   d="scan'208";a="344914671"
Date: Fri, 5 Nov 2010 11:19:51 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: davej@redhat.com
Cc: arjan@linux.intel.com, venki@google.com, youquan.song@intel.com,
        cpufreq-list@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: Fix ondemand governor powersave_bias execution
	time misuse
Message-ID: <20101105151951.GA10743@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondemand governor use powersave_bias tunable to do aggressive power save by
decrease CPU average frequency. The average frequency achieve by adjust low and
high frequency's execution time proportion during one sample time interval.  

Current kernel, only the high frequency executes in time proportion, but the low
frequency wrongly execute in one whole sample time interval when powersave_bias
is set.  

The patch fix it by set low frequency execution time to it deserved. 

Signed-off-by: Youquan Song <youquan.song@intel.com>
---

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index c631f27..01d84fa 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -666,6 +666,8 @@ static void do_dbs_timer(struct work_struct *work)
 	} else {
 		__cpufreq_driver_target(dbs_info->cur_policy,
 			dbs_info->freq_lo, CPUFREQ_RELATION_H);
+		if (dbs_info->sample_type == DBS_SUB_SAMPLE)
+			delay = dbs_info->freq_lo_jiffies;
 	}
 	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
 	mutex_unlock(&dbs_info->timer_mutex);
