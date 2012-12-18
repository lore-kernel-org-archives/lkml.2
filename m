Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2LRIzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 03:55:52 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48575 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2LRIzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 03:55:51 -0500
From: Sonny Rao <sonnyrao@chromium.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Sameer Nanda <snanda@chromium.org>, Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] [RFC] cpufreq: can't raise max frequency with cpu_thermal
Date: Tue, 18 Dec 2012 00:29:44 -0800
Message-Id: <1355819384-25983-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu_thermal generic thermal management code has a bug where once
max cpu frequency has been lowered in sysfs (scaling_max_freq) it is
not possible to raise the max back up later.  The bug is that the
notifer gets called by __cpufreq_set_policy() before the user policy
max is raised, and is incorrectly trying to enforce the max frequency
policy even when we are trying to change the policy.  It is also not
clear why this driver is looking at the user policy since it is
primarily supposed to enforce thermal policy, not user set policy.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 drivers/thermal/cpu_cooling.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 836828e..63bc708 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -219,10 +219,6 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
 	if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
 		max_freq = notify_device->cpufreq_val;
 
-	/* Never exceed user_policy.max*/
-	if (max_freq > policy->user_policy.max)
-		max_freq = policy->user_policy.max;
-
 	if (policy->max != max_freq)
 		cpufreq_verify_within_limits(policy, 0, max_freq);
 
-- 
1.7.7.3

