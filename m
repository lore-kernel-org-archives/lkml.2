Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0HZSO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:14:56 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:52617 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab0HZSOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:47 -0400
Message-Id: <20100826181342.149176927@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>
Subject: [RFC PATCH 11/11] sched: fair sleepers for timer and interactive
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-fair-sleeper-for-timer-and-interactive.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add FAIR_SLEEPERS_TIMER and FAIR_SLEEPERS_INTERACTIVE tuning knobs.

Turning off FAIR_SLEEPERS and turning on FAIR_SLEEPERS_INTERACTIVE does a pretty
good job for interactivity.

Setting FAIR_SLEEPERS to off helps keeping the min_vruntime value somewhere
between MIN_vruntime and max_vruntime rather than somewhere at the right of all
running threads.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched_fair.c     |    5 ++++-
 kernel/sched_features.h |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -748,7 +748,10 @@ place_entity(struct cfs_rq *cfs_rq, stru
 		vruntime += sched_vslice(cfs_rq, se);
 
 	/* sleeps up to a single latency don't count. */
-	if (sched_feat(FAIR_SLEEPERS) && !initial) {
+	if (!initial
+	    && (sched_feat(FAIR_SLEEPERS)
+	       || (sched_feat(FAIR_SLEEPERS_TIMER) && se->timer)
+	       || (sched_feat(FAIR_SLEEPERS_INTERACTIVE) && se->interactive))) {
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
Index: linux-2.6-lttng.git/kernel/sched_features.h
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_features.h
+++ linux-2.6-lttng.git/kernel/sched_features.h
@@ -3,7 +3,9 @@
  * them to run sooner, but does not allow tons of sleepers to
  * rip the spread apart.
  */
-SCHED_FEAT(FAIR_SLEEPERS, 1)
+SCHED_FEAT(FAIR_SLEEPERS, 1)		 /* Apply to all wakeups */
+SCHED_FEAT(FAIR_SLEEPERS_INTERACTIVE, 0) /* Selects interactive wakeups */
+SCHED_FEAT(FAIR_SLEEPERS_TIMER, 0)	 /* Selects timer-driven wakeups */
 SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 
 /*

