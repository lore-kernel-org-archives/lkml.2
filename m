Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1BCOLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:11:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:51350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab1BCOLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:11:35 -0500
Date: Thu, 3 Feb 2011 14:11:10 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix update_curr_rt()
Message-ID: <tip-06c3bc655697b19521901f9254eb0bbb2c67e7e8@git.kernel.org>
Git-Commit-ID: 06c3bc655697b19521901f9254eb0bbb2c67e7e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Feb 2011 14:11:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06c3bc655697b19521901f9254eb0bbb2c67e7e8
Gitweb:     http://git.kernel.org/tip/06c3bc655697b19521901f9254eb0bbb2c67e7e8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 2 Feb 2011 13:19:48 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Feb 2011 12:21:33 +0100

sched: Fix update_curr_rt()

cpu_stopper_thread()
  migration_cpu_stop()
    __migrate_task()
      deactivate_task()
        dequeue_task()
          dequeue_task_rq()
            update_curr_rt()

Will call update_curr_rt() on rq->curr, which at that time is
rq->stop. The problem is that rq->stop.prio matches an RT prio and
thus falsely assumes its a rt_sched_class task.

Reported-Debuged-Tested-Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Cc: stable@kernel.org # .37
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c914ec7..ad62677 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -625,7 +625,7 @@ static void update_curr_rt(struct rq *rq)
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	u64 delta_exec;
 
-	if (!task_has_rt_policy(curr))
+	if (curr->sched_class != &rt_sched_class)
 		return;
 
 	delta_exec = rq->clock_task - curr->se.exec_start;
