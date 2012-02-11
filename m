Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2BKG4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 01:56:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45485 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751190Ab2BKG4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 01:56:34 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19xWdYff8NxuUitOS+DjHvywhNEKymfQlBzwOmZ62
	vqedN4hPWvIlIk
Message-ID: <1328943389.7340.29.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] sched: Optimize cgroup pick_next_task_fair
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Venkatesh Pallipadi <venki@google.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 11 Feb 2012 07:56:29 +0100
In-Reply-To: <1328936700.2476.17.camel@laptop>
References: <1328936700.2476.17.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-11 at 06:05 +0100, Peter Zijlstra wrote: 
> Since commit 2f36825b1 ("sched: Next buddy hint on sleep and preempt
> path") it is likely we pick a new task from the same cgroup, doing a put
> and then set on all intermediate entities is a waste of time, so try to
> avoid this.

Good idea, we need to lose some weight.

> XXX check put_prev_task()'s update_rq_clock() magic..

I made that even more lovable ;-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d7c4322..7c1cfa6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3175,6 +3175,7 @@ need_resched:
 		} else {
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
+			rq->skip_clock_update = 1;
 
 			/*
 			 * If a worker went to sleep, notify and ask workqueue
@@ -3200,9 +3201,9 @@ need_resched:
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 	clear_tsk_need_resched(prev);
-	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
+		rq->skip_clock_update = 0;
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
@@ -3220,6 +3221,7 @@ need_resched:
 		raw_spin_unlock_irq(&rq->lock);
 
 	post_schedule(rq);
+	rq->skip_clock_update = 0;
 
 	preempt_enable_no_resched();
 	if (need_resched())

> Compile tested only.. inspired by pjt's fast switch stories.

I was looking forward to seeing those fast switch patches, nice spot to
cut lard.

> Not-quite-signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I'll see if I can give it some runtime.

-Mike

