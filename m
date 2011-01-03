Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab1ACN4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:56:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab1ACNuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Y2Vsp0l7TI90RyzLyhaShlsASJTLD5YdTkP82KrSP+AoMr/cq+tU0WebjgLnQ1P87B
         oyIFeYve0X+re1w9rBlm+N+fiaZMdEvnOfeBQ1E3iutPNNRg8tp5cjH2XgLbowllUbfX
         W1YiRD0AUqTas5HdlusjemU/4tNqYIvOaJRjA=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Subject: [PATCH 07/32] cpufreq: use system_wq instead of dedicated workqueues
Date: Mon,  3 Jan 2011 14:49:30 +0100
Message-Id: <1294062595-30097-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason for cpufreq drivers to use separate
workqueues.  Remove the dedicated workqueues from cpufreq_conservative
and cpufreq_ondemand and use system_wq instead.  The work items are
already sync canceled on stop, so it's already guaranteed that no work
is running on module exit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/cpufreq/cpufreq_conservative.c |   22 +++-------------------
 drivers/cpufreq/cpufreq_ondemand.c     |   20 +++-----------------
 2 files changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 526bfbf..94284c8 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -81,8 +81,6 @@ static unsigned int dbs_enable;	/* number of CPUs using this policy */
  */
 static DEFINE_MUTEX(dbs_mutex);
 
-static struct workqueue_struct	*kconservative_wq;
-
 static struct dbs_tuners {
 	unsigned int sampling_rate;
 	unsigned int sampling_down_factor;
@@ -560,7 +558,7 @@ static void do_dbs_timer(struct work_struct *work)
 
 	dbs_check_cpu(dbs_info);
 
-	queue_delayed_work_on(cpu, kconservative_wq, &dbs_info->work, delay);
+	schedule_delayed_work_on(cpu, &dbs_info->work, delay);
 	mutex_unlock(&dbs_info->timer_mutex);
 }
 
@@ -572,8 +570,7 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 
 	dbs_info->enable = 1;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
-	queue_delayed_work_on(dbs_info->cpu, kconservative_wq, &dbs_info->work,
-				delay);
+	schedule_delayed_work_on(dbs_info->cpu, &dbs_info->work, delay);
 }
 
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
@@ -716,25 +713,12 @@ struct cpufreq_governor cpufreq_gov_conservative = {
 
 static int __init cpufreq_gov_dbs_init(void)
 {
-	int err;
-
-	kconservative_wq = create_workqueue("kconservative");
-	if (!kconservative_wq) {
-		printk(KERN_ERR "Creation of kconservative failed\n");
-		return -EFAULT;
-	}
-
-	err = cpufreq_register_governor(&cpufreq_gov_conservative);
-	if (err)
-		destroy_workqueue(kconservative_wq);
-
-	return err;
+	return cpufreq_register_governor(&cpufreq_gov_conservative);
 }
 
 static void __exit cpufreq_gov_dbs_exit(void)
 {
 	cpufreq_unregister_governor(&cpufreq_gov_conservative);
-	destroy_workqueue(kconservative_wq);
 }
 
 
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index c631f27..58aa85e 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -104,8 +104,6 @@ static unsigned int dbs_enable;	/* number of CPUs using this policy */
  */
 static DEFINE_MUTEX(dbs_mutex);
 
-static struct workqueue_struct	*kondemand_wq;
-
 static struct dbs_tuners {
 	unsigned int sampling_rate;
 	unsigned int up_threshold;
@@ -667,7 +665,7 @@ static void do_dbs_timer(struct work_struct *work)
 		__cpufreq_driver_target(dbs_info->cur_policy,
 			dbs_info->freq_lo, CPUFREQ_RELATION_H);
 	}
-	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
+	schedule_delayed_work_on(cpu, &dbs_info->work, delay);
 	mutex_unlock(&dbs_info->timer_mutex);
 }
 
@@ -681,8 +679,7 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
-	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
-		delay);
+	schedule_delayed_work_on(dbs_info->cpu, &dbs_info->work, delay);
 }
 
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
@@ -814,7 +811,6 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 static int __init cpufreq_gov_dbs_init(void)
 {
-	int err;
 	cputime64_t wall;
 	u64 idle_time;
 	int cpu = get_cpu();
@@ -838,22 +834,12 @@ static int __init cpufreq_gov_dbs_init(void)
 			MIN_SAMPLING_RATE_RATIO * jiffies_to_usecs(10);
 	}
 
-	kondemand_wq = create_workqueue("kondemand");
-	if (!kondemand_wq) {
-		printk(KERN_ERR "Creation of kondemand failed\n");
-		return -EFAULT;
-	}
-	err = cpufreq_register_governor(&cpufreq_gov_ondemand);
-	if (err)
-		destroy_workqueue(kondemand_wq);
-
-	return err;
+	return cpufreq_register_governor(&cpufreq_gov_ondemand);
 }
 
 static void __exit cpufreq_gov_dbs_exit(void)
 {
 	cpufreq_unregister_governor(&cpufreq_gov_ondemand);
-	destroy_workqueue(kondemand_wq);
 }
 
 
-- 
1.7.1

