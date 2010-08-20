Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0HTOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 10:16:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:55643 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab0HTOQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 10:16:56 -0400
Date: Fri, 20 Aug 2010 14:16:14 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, pjohn@mvista.com,
        wanders.thirst@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, pjohn@mvista.com,
        wanders.thirst@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1281002322.1923.1708.camel@laptop>
References: <1281002322.1923.1708.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix rq->clock synchronization when migrating tasks
Message-ID: <tip-861d034ee814917a83bd5de4b26e3b8336ddeeb8@git.kernel.org>
Git-Commit-ID: 861d034ee814917a83bd5de4b26e3b8336ddeeb8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 Aug 2010 14:16:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  861d034ee814917a83bd5de4b26e3b8336ddeeb8
Gitweb:     http://git.kernel.org/tip/861d034ee814917a83bd5de4b26e3b8336ddeeb8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 19 Aug 2010 13:31:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Aug 2010 14:59:01 +0200

sched: Fix rq->clock synchronization when migrating tasks

sched_fork() -- we do task placement in ->task_fork_fair() ensure we
  update_rq_clock() so we work with current time. We leave the vruntime
  in relative state, so the time delay until wake_up_new_task() doesn't
  matter.

wake_up_new_task() -- Since task_fork_fair() left p->vruntime in
  relative state we can safely migrate, the activate_task() on the
  remote rq will call update_rq_clock() and causes the clock to be
  synced (enough).

Tested-by: Jack Daniel <wanders.thirst@gmail.com>
Tested-by: Philby John <pjohn@mvista.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1281002322.1923.1708.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 806d1b2..ab661eb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3752,6 +3752,8 @@ static void task_fork_fair(struct task_struct *p)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
+	update_rq_clock(rq);
+
 	if (unlikely(task_cpu(p) != this_cpu))
 		__set_task_cpu(p, this_cpu);
 
