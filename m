Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab1INUG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:06:28 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:47868 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab1INUG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:06:26 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 8/9] per-cgroup boot time
Date: Wed, 14 Sep 2011 17:04:54 -0300
Message-Id: <1316030695-19826-9-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record the time in which the cgroup was created. This can be
used to provide a more accurate boottime information in
cpuacct.proc.stat.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4611c54..8f254d0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9120,6 +9120,7 @@ struct cpuacct {
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 __percpu *cpuusage;
 	u64 __percpu *cpustat;
+	struct timespec start_time;
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -9172,6 +9173,8 @@ static struct cgroup_subsys_state *cpuacct_create(
 		acct[CPUACCT_STAT_IDLE] = kstat_cpu(i).cpustat.idle;
 		acct[CPUACCT_STAT_IOWAIT] = kstat_cpu(i).cpustat.iowait;
 	}
+
+	get_monotonic_boottime(&ca->start_time);
 	return &ca->css;
 
 out_free_usage:
@@ -9316,13 +9319,16 @@ static int cpuacct_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
 	struct cpuacct *ca = cgroup_ca(cgrp);
+	struct timespec ts;
 	u64 *cpustat;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
 	guest = guest_nice = cputime64_zero;
 	getboottime(&boottime);
-	jif = boottime.tv_sec;
+	getboottime(&boottime);
+	ts = timespec_add(boottime, ca->start_time);
+	jif = ts.tv_sec;
 
 	for_each_possible_cpu(i) {
 		cpustat = per_cpu_ptr(ca->cpustat, i);
-- 
1.7.6

