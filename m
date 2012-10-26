Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab2JZMfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:35:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39172 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab2JZMf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:35:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH RESEND] cpufreq: Make sure target freq is within limits
Date: Fri, 26 Oct 2012 18:05:21 +0530
Message-Id: <f79c0841be1ae16e1f2bd9084ed9a158eb171eb0.1351254846.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpufreq_driver_target() must not pass target frequency beyond the limits of
current policy.

Today most of cpufreq platform drivers are doing this check in their target
routines. Why not move it to __cpufreq_driver_target().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Rafael,

Resend doesn't contain any change, but fixed commit log

 drivers/cpufreq/cpufreq.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 28dc134..2f5ac2d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1470,12 +1470,19 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			    unsigned int relation)
 {
 	int retval = -EINVAL;
+	unsigned int old_target_freq = target_freq;
 
 	if (cpufreq_disabled())
 		return -ENODEV;
 
-	pr_debug("target for CPU %u: %u kHz, relation %u\n", policy->cpu,
-		target_freq, relation);
+	/* Make sure that target_freq is within supported range */
+	if (target_freq > policy->max)
+		target_freq = policy->max;
+	if (target_freq < policy->min)
+		target_freq = policy->min;
+
+	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
+			policy->cpu, target_freq, relation, old_target_freq);
 
 	if (target_freq == policy->cur)
 		return 0;
-- 
1.7.12.rc2.18.g61b472e

