Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1LBV7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 16:59:22 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:13571 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab1LBV7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 16:59:20 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 1/2] Fix user/system tick double accounting
Date: Fri,  2 Dec 2011 19:58:38 -0200
Message-Id: <1322863119-14225-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322863119-14225-1-git-send-email-glommer@parallels.com>
References: <1322863119-14225-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we're  pointing cpuacct's root cgroup to cpustat and accounting
through task_group_account_field(), we should not access cpustat directly.
Since it is done anyway inside the acessor function, we end up accounting
it twice, which is wrong.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched/core.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5181a39..b908df3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2625,8 +2625,6 @@ static inline void task_group_account_field(struct task_struct *p,
 void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-	u64 tmp;
 	int index;
 
 	/* Add user time to process. */
@@ -2634,13 +2632,11 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
 	account_group_user_time(p, cputime);
 
-	/* Add user time to cpustat. */
-	tmp = cputime_to_cputime64(cputime);
-
 	index = (TASK_NICE(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
-	cpustat[index] += tmp;
 
+	/* Add user time to cpustat. */
 	task_group_account_field(p, index, cputime);
+
 	/* Account for user time used */
 	acct_update_integrals(p);
 }
@@ -2686,16 +2682,12 @@ static inline
 void __account_system_time(struct task_struct *p, cputime_t cputime,
 			cputime_t cputime_scaled, int index)
 {
-	u64 tmp = cputime_to_cputime64(cputime);
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
 	/* Add system time to process. */
 	p->stime = cputime_add(p->stime, cputime);
 	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
-	cpustat[index] += tmp;
 	task_group_account_field(p, index, cputime);
 
 	/* Account for system time used */
-- 
1.7.6.4

