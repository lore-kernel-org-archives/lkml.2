Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab1INUGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:06:18 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19196 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab1INUGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:06:14 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 6/9] Include idle and iowait fields in cpuacct
Date: Wed, 14 Sep 2011 17:04:52 -0300
Message-Id: <1316030695-19826-7-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are slightly different from the others though:
(note to reviewers: might be better to put those in a separate
array?)

Since idle/iowait are a property of the system - by definition,
no process from any cgroup is running when the system is idle,
they are system wide. So what these fields really mean, are baselines
for when the cgroup was created. It allows the cgroup to start
counting idle/iowait from 0.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f0309a0..6c953f5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1452,6 +1452,8 @@ enum cpuacct_stat_index {
 	CPUACCT_STAT_SOFTIRQ,	/* ... softirq ticks */
 	CPUACCT_STAT_GUEST,	/* ... guest mode */
 	CPUACCT_STAT_GUEST_NICE,	/* ... guest nice */
+	CPUACCT_STAT_IDLE,	/* ... idle base ticks when created */
+	CPUACCT_STAT_IOWAIT,	/* ... iowait when created */
 
 	CPUACCT_STAT_NSTATS,
 };
@@ -9151,6 +9153,8 @@ static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	u64 *acct;
+	int i;
 
 	if (!ca)
 		goto out;
@@ -9163,6 +9167,11 @@ static struct cgroup_subsys_state *cpuacct_create(
 	if (!ca->cpustat)
 		goto out_free_usage;
 
+	for_each_possible_cpu(i) {
+		acct = per_cpu_ptr(ca->cpustat, i);
+		acct[CPUACCT_STAT_IDLE] = kstat_cpu(i).cpustat.idle;
+		acct[CPUACCT_STAT_IOWAIT] = kstat_cpu(i).cpustat.iowait;
+	}
 	return &ca->css;
 
 out_free_usage:
-- 
1.7.6

