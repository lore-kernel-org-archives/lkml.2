Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1CBQBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:01:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1CBQBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:01:13 -0500
Date: Wed, 2 Mar 2011 11:00:34 -0500
From: Dave Jones <davej@redhat.com>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
        venki@google.com, youquan.song@intel.com, cpufreq-list@vger.kernel.org,
        linux-kernel@vger.kernel.org, vincent.guittot@linaro.org
Subject: Re: [PATCH] cpufreq: Fix ondemand governor powersave_bias execution
 time misuse
Message-ID: <20110302160033.GA27760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Youquan Song <youquan.song@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
	venki@google.com, youquan.song@intel.com,
	cpufreq-list@vger.kernel.org, linux-kernel@vger.kernel.org,
	vincent.guittot@linaro.org
References: <20101105151951.GA10743@linux-youquan.bj.intel.com>
 <20110301170740.2b4a8288.akpm@linux-foundation.org>
 <20110302185801.GA31349@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302185801.GA31349@linux-youquan.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 01:58:02PM -0500, Youquan Song wrote:
 >  
 > > Where are we with this patch?  Still needed in curent mainline?
 > Do need it by current mainline. Without the patch, the ondemand
 > power_bias feature is broken and does not work at all.
 > Please take it.

This patch from Vincent Guittot is also pending, which seems to achieve
the same thing ?


commit 1f5a2969af7e0d040876c7ff25308c840eef18d4
Author: Vincent Guittot <vincent.guittot@linaro.org>
Date:   Mon Feb 7 17:14:25 2011 +0100

    [CPUFREQ] calculate delay after dbs_check_cpu
    
    calculate ondemand delay after dbs_check_cpu call because it can
    modify rate_mult value
    
    use freq_lo_jiffies value for the sub sample period of powersave_bias mode
    
    Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index c631f27..b4e1f98 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -644,12 +644,7 @@ static void do_dbs_timer(struct work_struct *work)
 	unsigned int cpu = dbs_info->cpu;
 	int sample_type = dbs_info->sample_type;
 
-	/* We want all CPUs to do sampling nearly on same jiffy */
-	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate
-		* dbs_info->rate_mult);
-
-	if (num_online_cpus() > 1)
-		delay -= jiffies % delay;
+	int delay;
 
 	mutex_lock(&dbs_info->timer_mutex);
 
@@ -662,10 +657,20 @@ static void do_dbs_timer(struct work_struct *work)
 			/* Setup timer for SUB_SAMPLE */
 			dbs_info->sample_type = DBS_SUB_SAMPLE;
 			delay = dbs_info->freq_hi_jiffies;
+		} else {
+			/* We want all CPUs to do sampling nearly on
+			 * same jiffy
+			 */
+			delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate
+				* dbs_info->rate_mult);
+
+			if (num_online_cpus() > 1)
+				delay -= jiffies % delay;
 		}
 	} else {
 		__cpufreq_driver_target(dbs_info->cur_policy,
 			dbs_info->freq_lo, CPUFREQ_RELATION_H);
+		delay = dbs_info->freq_lo_jiffies;
 	}
 	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
 	mutex_unlock(&dbs_info->timer_mutex);
