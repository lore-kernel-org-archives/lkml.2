Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1ABIAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:00:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:35180 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab1ABHW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 084/260] sched: move_task_off_dead_cpu(): Remove retry logic
Date: Sun,  2 Jan 2011 02:16:20 -0500
Message-Id: <1293952756-15010-85-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:41.0758 (UTC) FILETIME=[B3E5D9E0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit c1804d547dc098363443667609c272d1e4d15ee8 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 743af02..59ef8a1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5535,7 +5535,7 @@ static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 	struct rq *rq = cpu_rq(dead_cpu);
 	int needs_cpu, uninitialized_var(dest_cpu);
 	unsigned long flags;
-again:
+
 	local_irq_save(flags);
 
 	raw_spin_lock(&rq->lock);
@@ -5543,14 +5543,13 @@ again:
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
-- 
1.7.3.3

