Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab1LFJvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:51:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34914 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063Ab1LFJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:51:41 -0500
Date: Tue, 6 Dec 2011 01:51:09 -0800
From: tip-bot for Mike Galbraith <mgalbraith@suse.de>
Message-ID: <tip-916671c08b7808aebec87cc56c85788e665b3c6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mgalbraith@suse.de, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1321971686.6855.18.camel@marge.simson.net>
References: <1321971686.6855.18.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Set skip_clock_update in yield_task_fair()
Git-Commit-ID: 916671c08b7808aebec87cc56c85788e665b3c6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:51:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  916671c08b7808aebec87cc56c85788e665b3c6b
Gitweb:     http://git.kernel.org/tip/916671c08b7808aebec87cc56c85788e665b3c6b
Author:     Mike Galbraith <mgalbraith@suse.de>
AuthorDate: Tue, 22 Nov 2011 15:21:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:06:24 +0100

sched: Set skip_clock_update in yield_task_fair()

This is another case where we are on our way to schedule(),
so can save a useless clock update and resulting microscopic
vruntime update.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1321971686.6855.18.camel@marge.simson.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |    7 +++++++
 kernel/sched/fair.c |    6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ca8fd44..db313c3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4547,6 +4547,13 @@ again:
 		 */
 		if (preempt && rq != p_rq)
 			resched_task(p_rq->curr);
+	} else {
+		/*
+		 * We might have set it in task_yield_fair(), but are
+		 * not going to schedule(), so don't want to skip
+		 * the next update.
+		 */
+		rq->skip_clock_update = 0;
 	}
 
 out:
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8e534a0..81ccb81 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3075,6 +3075,12 @@ static void yield_task_fair(struct rq *rq)
 		 * Update run-time statistics of the 'current'.
 		 */
 		update_curr(cfs_rq);
+		/*
+		 * Tell update_rq_clock() that we've just updated,
+		 * so we don't do microscopic update in schedule()
+		 * and double the fastpath cost.
+		 */
+		 rq->skip_clock_update = 1;
 	}
 
 	set_skip_buddy(se);
