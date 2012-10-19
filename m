Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab2JSUMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 16:12:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48771 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab2JSUMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 16:12:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: return early from __cpufreq_driver_getavg()
Date: Sat, 20 Oct 2012 01:42:05 +0530
Message-Id: <32e5bed743cc6cc4e614291a7080299f5f0d0933.1350677395.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to do cpufreq_get_cpu() and cpufreq_put_cpu() for drivers that
don't support getavg() routine.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 85df538..f552d5f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1511,12 +1511,14 @@ int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
 {
 	int ret = 0;
 
+	if (!(cpu_online(cpu) && cpufreq_driver->getavg))
+		return 0;
+
 	policy = cpufreq_cpu_get(policy->cpu);
 	if (!policy)
 		return -EINVAL;
 
-	if (cpu_online(cpu) && cpufreq_driver->getavg)
-		ret = cpufreq_driver->getavg(policy, cpu);
+	ret = cpufreq_driver->getavg(policy, cpu);
 
 	cpufreq_cpu_put(policy);
 	return ret;
-- 
1.7.12.rc2.18.g61b472e

