Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab1CBAaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:30:19 -0500
Received: from smtp-out.google.com ([74.125.121.67]:62721 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab1CBAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:30:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JvU7o0PDFyamsPqWFoTH4aSVZaIVzUgttjhTU5AGo+998aJZvOmuVaaPpzGvwqroK9
         6cPX9cjAI/X5J+hbNKrA==
From: Venkatesh Pallipadi <venki@google.com>
To: Mike Galbraith <efault@gmx.de>, Rik van Riel <riel@redhat.com>,
        a.p.zijlstra@chello.nl
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] sched: resched proper CPU on yield_to
Date: Tue,  1 Mar 2011 16:28:21 -0800
Message-Id: <1299025701-22168-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298885189.9501.2.camel@marge.simson.net>
References: <1298885189.9501.2.camel@marge.simson.net>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yield_to_task_fair() has code to resched the CPU of yielding task when the
intention is to resched the CPU of the task that is being yielded to.

Change here fixes the problem and also makes the resched conditional on
rq != p_rq.

I don't have a setup to test this code path. So, this is only compile tested
right now.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c      |    9 ++++++++-
 kernel/sched_fair.c |    4 ----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5fb5aa2..afdbd09 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5495,8 +5495,15 @@ again:
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
index 36e8f02..1b1c780 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2001,10 +2001,6 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 	/* Tell the scheduler that we'd really like pse to run next. */
 	set_next_buddy(se);
 
-	/* Make p's CPU reschedule; pick_next_entity takes care of fairness. */
-	if (preempt)
-		resched_task(rq->curr);
-
 	yield_task_fair(rq);
 
 	return true;
-- 
1.7.3.1

