Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab2LPFuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 00:50:24 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65339 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2LPFuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 00:50:23 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, rafael.j.wysocki@intel.com
Cc: linaro-dev@lists.linaro.org, nicolas.pitre@linaro.org,
        amit.kucheria@linaro.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        pdsw-power-team@arm.com, linux-pm@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] cpufreq: Manage only online cpus
Date: Sun, 16 Dec 2012 11:20:08 +0530
Message-Id: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq core doesn't manage offline cpus and if driver->init() has returned
mask including offline cpus, it may result in unwanted behavior by cpufreq core
or governors.

We need to get only online cpus in this mask. There are two places to fix this
mask, cpufreq core and cpufreq driver. It makes sense to do this at common place
and hence is done in core.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1f93dbd..de99517 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -970,6 +970,13 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		pr_debug("initialization failed\n");
 		goto err_unlock_policy;
 	}
+
+	/*
+	 * affected cpus must always be the one, which are online. We aren't
+	 * managing offline cpus here.
+	 */
+	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
+
 	policy->user_policy.min = policy->min;
 	policy->user_policy.max = policy->max;
 
-- 
1.7.12.rc2.18.g61b472e

