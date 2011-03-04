Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab1CDLuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:50:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:41797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab1CDLt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:49:59 -0500
Date: Fri, 4 Mar 2011 11:49:24 GMT
From: tip-bot for Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, dvhart@linux.intel.com, efault@gmx.de,
        richard.purdie@linuxfoundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        richard.purdie@linuxfoundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1298408674-3130-2-git-send-email-dvhart@linux.intel.com>
References: <1298408674-3130-2-git-send-email-dvhart@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Allow SCHED_BATCH to preempt SCHED_IDLE tasks
Message-ID: <tip-a2f5c9ab79f78e8b91ac993e0543d65b661dd19b@git.kernel.org>
Git-Commit-ID: a2f5c9ab79f78e8b91ac993e0543d65b661dd19b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:49:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2f5c9ab79f78e8b91ac993e0543d65b661dd19b
Gitweb:     http://git.kernel.org/tip/a2f5c9ab79f78e8b91ac993e0543d65b661dd19b
Author:     Darren Hart <dvhart@linux.intel.com>
AuthorDate: Tue, 22 Feb 2011 13:04:33 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:14:29 +0100

sched: Allow SCHED_BATCH to preempt SCHED_IDLE tasks

Perform the test for SCHED_IDLE before testing for SCHED_BATCH (and
ensure idle tasks don't preempt idle tasks) so the non-interactive,
but still important, SCHED_BATCH tasks will run in favor of the very
low priority SCHED_IDLE tasks.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mike Galbraith <efault@gmx.de>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
LKML-Reference: <1298408674-3130-2-git-send-email-dvhart@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3a88dee..1438e13 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1870,16 +1870,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (test_tsk_need_resched(curr))
 		return;
 
+	/* Idle tasks are by definition preempted by non-idle tasks. */
+	if (unlikely(curr->policy == SCHED_IDLE) &&
+	    likely(p->policy != SCHED_IDLE))
+		goto preempt;
+
 	/*
-	 * Batch and idle tasks do not preempt (their preemption is driven by
-	 * the tick):
+	 * Batch and idle tasks do not preempt non-idle tasks (their preemption
+	 * is driven by the tick):
 	 */
 	if (unlikely(p->policy != SCHED_NORMAL))
 		return;
 
-	/* Idle tasks are by definition preempted by everybody. */
-	if (unlikely(curr->policy == SCHED_IDLE))
-		goto preempt;
 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
