Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0IRTKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:10:54 -0400
Received: from kroah.org ([198.145.64.141]:51789 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab0IRTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:18 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190001.553535929@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [102/123] sched: Fix rq->clock synchronization when migrating tasks
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-rq-clock-synchronization-when-migrating-tasks.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 861d034ee814917a83bd5de4b26e3b8336ddeeb8 upstream

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
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_fair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1963,6 +1963,8 @@ static void task_fork_fair(struct task_s
 
 	spin_lock_irqsave(&rq->lock, flags);
 
+	update_rq_clock(rq);
+
 	if (unlikely(task_cpu(p) != this_cpu))
 		__set_task_cpu(p, this_cpu);
 


