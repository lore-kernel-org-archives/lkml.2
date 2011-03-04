Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab1CDLuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:50:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:41827 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759400Ab1CDLuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:50:35 -0500
Date: Fri, 4 Mar 2011 11:50:11 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, riel@redhat.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, riel@redhat.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1299025701-22168-1-git-send-email-venki@google.com>
References: <1299025701-22168-1-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Resched proper CPU on yield_to()
Message-ID: <tip-6d1cafd8b56ea726c10a5a104de57cc3ed8fa953@git.kernel.org>
Git-Commit-ID: 6d1cafd8b56ea726c10a5a104de57cc3ed8fa953
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:50:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d1cafd8b56ea726c10a5a104de57cc3ed8fa953
Gitweb:     http://git.kernel.org/tip/6d1cafd8b56ea726c10a5a104de57cc3ed8fa953
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Tue, 1 Mar 2011 16:28:21 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:14:31 +0100

sched: Resched proper CPU on yield_to()

yield_to_task_fair() has code to resched the CPU of yielding task when the
intention is to resched the CPU of the task that is being yielded to.

Change here fixes the problem and also makes the resched conditional on
rq != p_rq.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1299025701-22168-1-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    9 ++++++++-
 kernel/sched_fair.c |    4 ----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f303070..61452e8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5522,8 +5522,15 @@ again:
 		goto out;
 
 	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
-	if (yielded)
+	if (yielded) {
 		schedstat_inc(rq, yld_count);
+		/*
+		 * Make p's CPU reschedule; pick_next_entity takes care of
+		 * fairness.
+		 */
+		if (preempt && rq != p_rq)
+			resched_task(p_rq->curr);
+	}
 
 out:
 	double_rq_unlock(rq, p_rq);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1438e13..3f7ec9e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1987,10 +1987,6 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 	/* Tell the scheduler that we'd really like pse to run next. */
 	set_next_buddy(se);
 
-	/* Make p's CPU reschedule; pick_next_entity takes care of fairness. */
-	if (preempt)
-		resched_task(rq->curr);
-
 	yield_task_fair(rq);
 
 	return true;
