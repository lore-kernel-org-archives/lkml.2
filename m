Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab0IRTrG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:47:06 -0400
Received: from kroah.org ([198.145.64.141]:51552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab0IRTBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:55 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185958.704054867@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [069/123] sched: Clean up ttwu() rq locking
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-clean-up-ttwu-rq-locking.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit ab19cb23313733c55e0517607844b86720b35f5f upstream

Since set_task_clock() doesn't rely on rq->clock anymore we can simplyfy
the mess in ttwu().

Optimize things a bit by not fiddling with the IRQ state there.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2379,16 +2379,14 @@ static int try_to_wake_up(struct task_st
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
 
-	rq = task_rq_lock(p, &flags);
-
-	if (rq != orig_rq)
-		update_rq_clock(rq);
+	rq = __task_rq_lock(p);
+	update_rq_clock(rq);
 
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);


