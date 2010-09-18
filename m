Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0IRTMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:12:44 -0400
Received: from kroah.org ([198.145.64.141]:51733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab0IRTCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:13 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190000.964013055@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [095/123] sched: move_task_off_dead_cpu(): Remove retry logic
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-move_task_off_dead_cpu-remove-retry-logic.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit c1804d547dc098363443667609c272d1e4d15ee8 upstream

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
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7407,7 +7407,7 @@ static void move_task_off_dead_cpu(int d
 	struct rq *rq = cpu_rq(dead_cpu);
 	int needs_cpu, uninitialized_var(dest_cpu);
 	unsigned long flags;
-again:
+
 	local_irq_save(flags);
 
 	spin_lock(&rq->lock);
@@ -7415,14 +7415,13 @@ again:
 	if (needs_cpu)
 		dest_cpu = select_fallback_rq(dead_cpu, p);
 	spin_unlock(&rq->lock);
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


