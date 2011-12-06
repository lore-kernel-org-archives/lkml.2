Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1LFUWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:22:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1LFUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:22:12 -0500
Date: Tue, 6 Dec 2011 12:21:51 -0800
From: tip-bot for Glauber Costa <glommer@parallels.com>
Message-ID: <tip-1c77f38ad623d8c3bc062f0ff9b8c5a2dfb2f1a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, glommer@parallels.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        glommer@parallels.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1322863119-14225-2-git-send-email-glommer@parallels.com>
References: <1322863119-14225-2-git-send-email-glommer@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/accounting: Fix user/system tick double accounting
Git-Commit-ID: 1c77f38ad623d8c3bc062f0ff9b8c5a2dfb2f1a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:21:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c77f38ad623d8c3bc062f0ff9b8c5a2dfb2f1a2
Gitweb:     http://git.kernel.org/tip/1c77f38ad623d8c3bc062f0ff9b8c5a2dfb2f1a2
Author:     Glauber Costa <glommer@parallels.com>
AuthorDate: Fri, 2 Dec 2011 19:58:38 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:51:23 +0100

sched/accounting: Fix user/system tick double accounting

Now that we're  pointing cpuacct's root cgroup to cpustat and accounting
through task_group_account_field(), we should not access cpustat directly.
Since it is done anyway inside the acessor function, we end up accounting
it twice, which is wrong.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1322863119-14225-2-git-send-email-glommer@parallels.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3e078f2..6e86010 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2601,8 +2601,6 @@ static inline void task_group_account_field(struct task_struct *p,
 void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-	u64 tmp;
 	int index;
 
 	/* Add user time to process. */
@@ -2610,13 +2608,11 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
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
@@ -2662,16 +2658,12 @@ static inline
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
