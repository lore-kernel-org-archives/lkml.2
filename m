Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2L0O4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:56:42 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56996 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2L0O4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:56:34 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 5/5] cpufreq: ondemand: use all CPUs in update_sampling_rate
Date: Thu, 27 Dec 2012 15:55:42 +0100
Message-Id: <1356620142-8680-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
References: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify update_sampling_rate() to check, and eventually immediately
schedule, all CPU's do_dbs_timer delayed work.

This is required in case of software coordinated CPUs, as we now have a
separate delayed work for each CPU.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/cpufreq_ondemand.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 13ceb3c..1017b90 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -326,7 +326,7 @@ static void update_sampling_rate(unsigned int new_rate)
 			cpufreq_cpu_put(policy);
 			continue;
 		}
-		dbs_info = &per_cpu(od_cpu_dbs_info, policy->cpu);
+		dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
 		cpufreq_cpu_put(policy);
 
 		mutex_lock(&dbs_info->cdbs.timer_mutex);
@@ -345,8 +345,7 @@ static void update_sampling_rate(unsigned int new_rate)
 			cancel_delayed_work_sync(&dbs_info->cdbs.work);
 			mutex_lock(&dbs_info->cdbs.timer_mutex);
 
-			schedule_delayed_work_on(dbs_info->cdbs.cpu,
-					&dbs_info->cdbs.work,
+			schedule_delayed_work_on(cpu, &dbs_info->cdbs.work,
 					usecs_to_jiffies(new_rate));
 
 		}
-- 
1.7.12.1

