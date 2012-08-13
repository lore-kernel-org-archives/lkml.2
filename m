Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2HMQwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:52:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab2HMQw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:52:29 -0400
Date: Mon, 13 Aug 2012 09:52:13 -0700
From: tip-bot for Mike Galbraith <efault@gmx.de>
Message-ID: <tip-e221d028bb08b47e624c5f0a31732c642db9d19a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de
In-Reply-To: <1344326558.6968.25.camel@marge.simpson.net>
References: <1344326558.6968.25.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched,rt:
  fix isolated CPUs leaving root_task_group indefinitely throttled
Git-Commit-ID: e221d028bb08b47e624c5f0a31732c642db9d19a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 09:52:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e221d028bb08b47e624c5f0a31732c642db9d19a
Gitweb:     http://git.kernel.org/tip/e221d028bb08b47e624c5f0a31732c642db9d19a
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 7 Aug 2012 10:02:38 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 18:41:55 +0200

sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled

Root task group bandwidth replenishment must service all CPUs, regardless of
where the timer was last started, and regardless of the isolation mechanism,
lest 'Quoth the Raven, "Nevermore"' become rt scheduling policy.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344326558.6968.25.camel@marge.simpson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/rt.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 573e1ca..944cb68 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -788,6 +788,19 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
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
