Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2C0PgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:36:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39950 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2C0PgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:36:19 -0400
Date: Tue, 27 Mar 2012 08:35:59 -0700
From: tip-bot for Michael J Wang <mjwang@broadcom.com>
Message-ID: <tip-1b028abc779b67b699daff55e27d2432f8d92666@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, mjwang@broadcom.com,
        tglx@linutronix.de, yong.zhang0@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, mjwang@broadcom.com,
        tglx@linutronix.de, yong.zhang0@gmail.com
In-Reply-To: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/rt: Improve pick_next_highest_task_rt()
Git-Commit-ID: 1b028abc779b67b699daff55e27d2432f8d92666
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 27 Mar 2012 08:36:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b028abc779b67b699daff55e27d2432f8d92666
Gitweb:     http://git.kernel.org/tip/1b028abc779b67b699daff55e27d2432f8d92666
Author:     Michael J Wang <mjwang@broadcom.com>
AuthorDate: Mon, 19 Mar 2012 22:26:19 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 27 Mar 2012 14:52:12 +0200

sched/rt: Improve pick_next_highest_task_rt()

Avoid extra work by continuing on to the next rt_rq if the highest
prio task in current rt_rq is the same priority as our candidate
task.

More detailed explanation:  if next is not NULL, then we have found a
candidate task, and its priority is next->prio.  Now we are looking
for an even higher priority task in the other rt_rq's.  idx is the
highest priority in the current candidate rt_rq.  In the current 3.3
code, if idx is equal to next->prio, we would start scanning the tasks
in that rt_rq and replace the current candidate task with a task from
that rt_rq.  But the new task would only have a priority that is equal
to our previous candidate task, so we have not advanced our goal of
finding a higher prio task.  So we should avoid the extra work by
continuing on to the next rt_rq if idx is equal to next->prio.

Signed-off-by: Michael J Wang <mjwang@broadcom.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index b60dad7..44af55e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1428,7 +1428,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 next_idx:
 		if (idx >= MAX_RT_PRIO)
 			continue;
-		if (next && next->prio < idx)
+		if (next && next->prio <= idx)
 			continue;
 		list_for_each_entry(rt_se, array->queue + idx, run_list) {
 			struct task_struct *p;
