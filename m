Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0ESBa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:30:56 -0400
Received: from smtp-out.google.com ([74.125.121.35]:10986 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab0ESBag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:30:36 -0400
From: Mike Chan <mike@android.com>
Cc: khilman@deeprootsystems.com, menage@google.com, balbir@in.ibm.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Mike Chan <mike@android.com>
Subject: [PATCH 3/4] scheduler: cpuacct: Enable platform callbacks for cpuacct power tracking
Date: Tue, 18 May 2010 18:30:19 -0700
Message-Id: <1274232620-23003-4-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274232620-23003-1-git-send-email-mike@android.com>
References: <1274232620-23003-1-git-send-email-mike@android.com>
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform must register cpu power function that return power in
milliWatt seconds.

Signed-off-by: Mike Chan <mike@android.com>
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
index 9ff479e..effe842 100644
--- a/include/linux/cpuacct.h
+++ b/include/linux/cpuacct.h
@@ -31,7 +31,9 @@ struct cpuacct_cpufreq_calls {
 	 */
 	void (*init) (void **cpuacct_data);
 	void (*charge) (void *cpuacct_data,  u64 cputime, unsigned int cpu);
-	void (*show) (void *cpuacct_data, struct cgroup_map_cb *cb);
+	void (*cpufreq_show) (void *cpuacct_data, struct cgroup_map_cb *cb);
+	/* Returns power consumed in milliWatt seconds */
+	u64 (*power_usage) (void *cpuacct_data);
 };
 
 int cpuacct_register_cpufreq(struct cpuacct_cpufreq_calls *fn);
diff --git a/kernel/sched.c b/kernel/sched.c
index 6b6c45a..d55d8af 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8838,12 +8838,28 @@ static int cpuacct_cpufreq_show(struct cgroup *cgrp, struct cftype *cft,
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
@@ -8862,6 +8878,10 @@ static struct cftype files[] = {
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
1.7.0.1

