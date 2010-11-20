Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab0KTCJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:09:25 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37322 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab0KTCJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:09:21 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Mike Chan <mike@android.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4/5] scheduler: cpuacct: Enable platform callbacks for cpuacct power tracking
Date: Fri, 19 Nov 2010 18:08:53 -0800
Message-Id: <1290218934-8544-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Chan <mike@android.com>

Platform must register cpu power function that return power in
milliWatt seconds.

CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
Change-Id: I1caa0335e316c352eee3b1ddf326fcd4942bcbe8
Signed-off-by: Mike Chan <mike@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 Documentation/cgroups/cpuacct.txt |    3 +++
 include/linux/cpuacct.h           |    4 +++-
 kernel/sched.c                    |   24 ++++++++++++++++++++++--
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/cgroups/cpuacct.txt b/Documentation/cgroups/cpuacct.txt
index 600d2d0..84e471b 100644
--- a/Documentation/cgroups/cpuacct.txt
+++ b/Documentation/cgroups/cpuacct.txt
@@ -44,6 +44,9 @@ cpuacct.cpufreq file gives CPU time (in nanoseconds) spent at each CPU
 frequency. Platform hooks must be implemented inorder to properly track
 time at each CPU frequency.
 
+cpuacct.power file gives CPU power consumed (in milliWatt seconds). Platform
+must provide and implement power callback functions.
+
 cpuacct controller uses percpu_counter interface to collect user and
 system times. This has two side effects:
 
diff --git a/include/linux/cpuacct.h b/include/linux/cpuacct.h
index 560df02..8f68e73 100644
--- a/include/linux/cpuacct.h
+++ b/include/linux/cpuacct.h
@@ -31,7 +31,9 @@ struct cpuacct_charge_calls {
 	 */
 	void (*init) (void **cpuacct_data);
 	void (*charge) (void *cpuacct_data,  u64 cputime, unsigned int cpu);
-	void (*show) (void *cpuacct_data, struct cgroup_map_cb *cb);
+	void (*cpufreq_show) (void *cpuacct_data, struct cgroup_map_cb *cb);
+	/* Returns power consumed in milliWatt seconds */
+	u64 (*power_usage) (void *cpuacct_data);
 };
 
 int cpuacct_charge_register(struct cpuacct_charge_calls *fn);
diff --git a/kernel/sched.c b/kernel/sched.c
index 35055fc..270d34a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9282,12 +9282,28 @@ static int cpuacct_cpufreq_show(struct cgroup *cgrp, struct cftype *cft,
 		struct cgroup_map_cb *cb)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
-	if (ca->cpufreq_fn && ca->cpufreq_fn->show)
-		ca->cpufreq_fn->show(ca->cpuacct_data, cb);
+	if (ca->cpufreq_fn && ca->cpufreq_fn->cpufreq_show)
+		ca->cpufreq_fn->cpufreq_show(ca->cpuacct_data, cb);
 
 	return 0;
 }
 
+/* return total cpu power usage (milliWatt second) of a group */
+static u64 cpuacct_powerusage_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	int i;
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	u64 totalpower = 0;
+
+	if (ca->cpufreq_fn && ca->cpufreq_fn->power_usage)
+		for_each_present_cpu(i) {
+			totalpower += ca->cpufreq_fn->power_usage(
+					ca->cpuacct_data);
+		}
+
+	return totalpower;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -9306,6 +9322,10 @@ static struct cftype files[] = {
 		.name =  "cpufreq",
 		.read_map = cpuacct_cpufreq_show,
 	},
+	{
+		.name = "power",
+		.read_u64 = cpuacct_powerusage_read
+	},
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
-- 
1.7.3.2.146.gca209

