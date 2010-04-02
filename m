Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0DBTMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:12:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:38822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab0DBTMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:12:41 -0400
Date: Fri, 2 Apr 2010 19:12:17 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100315091014.GA9138@redhat.com>
References: <20100315091014.GA9138@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: move_task_off_dead_cpu(): Remove retry logic
Message-ID: <tip-c1804d547dc098363443667609c272d1e4d15ee8@git.kernel.org>
Git-Commit-ID: c1804d547dc098363443667609c272d1e4d15ee8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:12:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1804d547dc098363443667609c272d1e4d15ee8
Gitweb:     http://git.kernel.org/tip/c1804d547dc098363443667609c272d1e4d15ee8
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 15 Mar 2010 10:10:14 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:02 +0200

sched: move_task_off_dead_cpu(): Remove retry logic

The previous patch preserved the retry logic, but it looks unneeded.

__migrate_task() can only fail if we raced with migration after we dropped
the lock, but in this case the caller of set_cpus_allowed/etc must initiate
migration itself if ->on_rq == T.

We already fixed p->cpus_allowed, the changes in active/online masks must
be visible to racer, it should migrate the task to online cpu correctly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100315091014.GA9138@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 27774b5..f475c60 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5456,7 +5456,7 @@ static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 	struct rq *rq = cpu_rq(dead_cpu);
 	int needs_cpu, uninitialized_var(dest_cpu);
 	unsigned long flags;
-again:
+
 	local_irq_save(flags);
 
 	raw_spin_lock(&rq->lock);
@@ -5464,14 +5464,13 @@ again:
 	if (needs_cpu)
 		dest_cpu = select_fallback_rq(dead_cpu, p);
 	raw_spin_unlock(&rq->lock);
-
-	/* It can have affinity changed while we were choosing. */
+	/*
+	 * It can only fail if we race with set_cpus_allowed(),
+	 * in the racer should migrate the task anyway.
+	 */
 	if (needs_cpu)
-		needs_cpu = !__migrate_task(p, dead_cpu, dest_cpu);
+		__migrate_task(p, dead_cpu, dest_cpu);
 	local_irq_restore(flags);
-
-	if (unlikely(needs_cpu))
-		goto again;
 }
 
 /*
