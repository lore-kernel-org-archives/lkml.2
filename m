Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1ABH5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:57:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:35295 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1ABHXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:06 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 091/260] sched: Fix rq->clock synchronization when migrating tasks
Date: Sun,  2 Jan 2011 02:16:27 -0500
Message-Id: <1293952756-15010-92-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:50.0024 (UTC) FILETIME=[B8D32480:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 861d034ee814917a83bd5de4b26e3b8336ddeeb8 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched_fair.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 684e173..461d312 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3588,6 +3588,8 @@ static void task_fork_fair(struct task_struct *p)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
+	update_rq_clock(rq);
+
 	if (unlikely(task_cpu(p) != this_cpu))
 		__set_task_cpu(p, this_cpu);
 
-- 
1.7.3.3

