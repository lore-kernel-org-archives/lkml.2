Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1CGIVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:21:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:55948 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752235Ab1CGIVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:21:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18H4xggos8Hk0R8uQoJt5HqxCg4fheCjBqAq+joAD
	/AULCgsKM2Kri+
Subject: [patchlet] sched: fix rt throttle runtime borrowing
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 09:21:41 +0100
Message-ID: <1299486101.14465.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

The RT throttle leaves a bit to be desired as a protection mechanism.
With default settings, the thing won't save your bacon if you start a
single hog as RT on SMP box, or if your normally sane app goes nuts.

With the below, my box will limp along so I can kill the RT hog.  May
not be the best solution, but works for me.. modulo bustage I haven't
noticed yet of course.

sched: fix rt throttle runtime borrowing

If allowed to borrow up to rt_period, the throttle has no effect on an out
of control RT task, allowing it to consume 100% CPU indefinitely, blocking
system critical SCHED_NORMAL threads indefinitely.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched_rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -354,7 +354,7 @@ static int do_balance_runtime(struct rt_
 	weight = cpumask_weight(rd->span);
 
 	raw_spin_lock(&rt_b->rt_runtime_lock);
-	rt_period = ktime_to_ns(rt_b->rt_period);
+	rt_period = ktime_to_ns(rt_b->rt_period) - 1;
 	for_each_cpu(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;


