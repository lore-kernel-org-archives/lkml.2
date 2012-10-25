Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934603Ab2JYGd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:33:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47953 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097Ab2JYGdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:33:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC] cpufreq: Make sure target freq is within limits
Date: Thu, 25 Oct 2012 12:03:34 +0530
Message-Id: <f0099171c1c4f3048d0f29b7deb42144f26ac5d5.1351146515.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 25 Oct 2012 06:33:36.0660 (UTC) FILETIME=[A9B55540:01CDB27A]
X-MC-Unique: 112102507333902401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9P6XxqR015626

Hi Rafael,

__cpufreq_driver_target() must not pass target frequency beyond the limits of
current policy.

Today most of cpufreq platform drivers are doing this check in their target
routines. Why not move it to __cpufreq_driver_target().

I wanted to get your opinion on this before making changes in all driver files.
That's why this is an RFC.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f552d5f..59264f1 100644
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
 	if (cpu_online(policy->cpu) && cpufreq_driver->target)
 		retval = cpufreq_driver->target(policy, target_freq, relation);
 
-- 
1.7.12.rc2.18.g61b472e


