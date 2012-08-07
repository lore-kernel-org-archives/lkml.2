Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab2HGICr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:02:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40058 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750752Ab2HGICm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:02:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19frLF/SuNfUJk0Zx5/xUrdMEvNb7POLNz0AaPZRl
	4iRn+C5pCAObKp
Message-ID: <1344326558.6968.25.camel@marge.simpson.net>
Subject: [patch] sched,rt: fix isolated CPUs leaving root_task_group
 indefinitely throttled
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 07 Aug 2012 10:02:38 +0200
In-Reply-To: <1344321010.6968.10.camel@marge.simpson.net>
References: <1344261539.6853.1.camel@marge.simpson.net>
	 <1344321010.6968.10.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speaking of old "parches" lying about, the below fixes a real problem if
you're using either 'should die' isolcpus or 'should work' cpusets to
isolate cores.

sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled

Root task group bandwidth replenishment must service all CPUs, regardless of
where the timer was last started, and regardless of the isolation mechanism,
lest 'Quoth the Raven, "Nevermore"' become rt scheduling policy.

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched/rt.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -788,6 +788,19 @@ static int do_sched_rt_period_timer(stru
 	const struct cpumask *span;
 
 	span = sched_rt_period_mask();
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * FIXME: isolated CPUs should really leave the root task group,
+	 * whether they are isolcpus or were isolated via cpusets, lest
+	 * the timer run on a CPU which does not service all runqueues,
+	 * potentially leaving other CPUs indefinitely throttled.  If
+	 * isolation is really required, the user will turn the throttle
+	 * off to kill the perturbations it causes anyway.  Meanwhile,
+	 * this maintains functionality for boot and/or troubleshooting.
+	 */
+	if (rt_b == &root_task_group.rt_bandwidth)
+		span = cpu_online_mask;
+#endif
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);


