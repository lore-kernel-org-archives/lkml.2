Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2DJJIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:08:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46348 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751150Ab2DJJIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:08:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18INBdL/3AIMHq1/fViYRbUItO+luMXMeL7wjbDiV
	I/2twYN8utvQdi
Message-ID: <1334048925.7524.21.camel@marge.simpson.net>
Subject: Re: RFC [patch] sched,cgroup_sched: convince RT_GROUP_SCHED
 throttle to work
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Date: Tue, 10 Apr 2012 11:08:45 +0200
In-Reply-To: <1333792489.12677.58.camel@marge.simpson.net>
References: <1333444106.9072.4.camel@marge.simpson.net>
	 <1333444788.9072.9.camel@marge.simpson.net>
	 <1333789124.12677.15.camel@marge.simpson.net>
	 <1333792489.12677.58.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-07 at 11:54 +0200, Mike Galbraith wrote:

> With this patch, the thing appears to work perfectly, but it doesn't
> look correct, since I'm futzing with ->rt_time where I should not.

s/doesn't look/definitely isn't.  This failed the "definitely works so
may live on despite horrific appearance" test anyway, so how about just
stop pretending root isn't global instead?

sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled

Root task group bandwidth replenishment must service all CPUs regardless of
where it was last started.

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched/rt.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -782,6 +782,19 @@ static int do_sched_rt_period_timer(stru
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


