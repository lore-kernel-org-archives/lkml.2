Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0HZSO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:14:58 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:35450 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab0HZSOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:48 -0400
Message-Id: <20100826181340.147395621@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>
Subject: [RFC PATCH 03/11] sched: FAIR_SLEEPERS feature
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-add-sleeper.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the fair sleeper feature which disables sleeper extra vruntime boost on
wakeup. This is makes the DYN_MIN_VRUNTIME feature behave better by keeping the
min_vruntime value somewhere between MIN_vruntime and max_vruntime (see
/proc/sched_debug output with CONFIG_SCHED_DEBUG=y).

Turning on this knob is typically bad for interactivity. This is why a later
patch introduces the "FAIR_SLEEPERS_INTERACTIVE" feature, which provides this
combination of features:

NO_FAIR_SLEEPERS
FAIR_SLEEPERS_INTERACTIVE

So that fair sleeper fairness is only given to interactive wakeup chains.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched_fair.c     |    2 +-
 kernel/sched_features.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -735,7 +735,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 		vruntime += sched_vslice(cfs_rq, se);
 
 	/* sleeps up to a single latency don't count. */
-	if (!initial) {
+	if (sched_feat(FAIR_SLEEPERS) && !initial) {
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
Index: linux-2.6-lttng.git/kernel/sched_features.h
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_features.h
+++ linux-2.6-lttng.git/kernel/sched_features.h
@@ -3,6 +3,7 @@
  * them to run sooner, but does not allow tons of sleepers to
  * rip the spread apart.
  */
+SCHED_FEAT(FAIR_SLEEPERS, 1)
 SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 
 /*

