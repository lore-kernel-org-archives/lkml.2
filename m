Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab0ETSmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:42:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab0ETSmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:42:38 -0400
From: Mike Chan <mike@android.com>
Cc: menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, trenn@suse.de,
       khilman@deeprootsystems.com, linux-omap@vger.kernel.org,
       Mike Chan <mike@android.com>
Subject: [PATCH v2 2/3] scheduler: cpuacct: Enable platform callbacks for cpuacct power tracking
Date: Thu, 20 May 2010 11:42:23 -0700
Message-Id: <1274380944-20947-3-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274380944-20947-1-git-send-email-mike@android.com>
References: <1274380944-20947-1-git-send-email-mike@android.com>
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2:
- Rebased off Thomass Renninger's cgroup_cpuacct refactoring

Platform must register cpu power function that return power in
milliWatt seconds.

New file:
cpuacct.power reports the power consumed in milliWatt seconds

Signed-off-by: Mike Chan <mike@android.com>
---
 Documentation/cgroups/cpuacct.txt |    3 +++
 include/linux/cpuacct.h           |    4 +++-
 kernel/cgroup_cpuaccount.c        |   24 ++++++++++++++++++++++--
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
index 6205d29..c17a634 100644
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
diff --git a/kernel/cgroup_cpuaccount.c b/kernel/cgroup_cpuaccount.c
index 11799a7..d9bf889 100644
--- a/kernel/cgroup_cpuaccount.c
+++ b/kernel/cgroup_cpuaccount.c
@@ -226,12 +226,28 @@ static int cpuacct_cpufreq_show(struct cgroup *cgrp, struct cftype *cft,
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
@@ -250,6 +266,10 @@ static struct cftype files[] = {
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

