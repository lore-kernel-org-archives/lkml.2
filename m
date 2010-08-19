Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0HSLZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:25:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:43842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab0HSLZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:25:47 -0400
Date: Thu, 19 Aug 2010 11:25:14 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, arjan@linux.intel.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, arjan@linux.intel.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C6C5FA9.3000405@linux.intel.com>
References: <4C6C5FA9.3000405@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix timer tracing
Message-ID: <tip-ede1b4290781ae82ccf0f2ecc6dada8d3dd35779@git.kernel.org>
Git-Commit-ID: ede1b4290781ae82ccf0f2ecc6dada8d3dd35779
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 11:25:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ede1b4290781ae82ccf0f2ecc6dada8d3dd35779
Gitweb:     http://git.kernel.org/tip/ede1b4290781ae82ccf0f2ecc6dada8d3dd35779
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Wed, 18 Aug 2010 15:33:13 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Aug 2010 13:00:41 +0200

tracing: Fix timer tracing

PowerTOP would like to be able to trace timers.

Unfortunately, the current timer tracing is not very useful: the
actual timer function is not recorded in the trace at the start
of timer execution.

Although this is recorded for timer "start" time (when it gets
armed), this is not useful; most timers get started early, and a
tracer like PowerTOP will never see this event, but will only
see the actual running of the  timer.

This patch just adds the function to the timer tracing; I've
verified with PowerTOP that now it can get useful information
about timers.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: xiaoguangrong@cn.fujitsu.com
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org> # .35.x, .34.x, .33.x
LKML-Reference: <4C6C5FA9.3000405@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/timer.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index c624126..425bcfe 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -81,14 +81,16 @@ TRACE_EVENT(timer_expire_entry,
 	TP_STRUCT__entry(
 		__field( void *,	timer	)
 		__field( unsigned long,	now	)
+		__field( void *,	function)
 	),
 
 	TP_fast_assign(
 		__entry->timer		= timer;
 		__entry->now		= jiffies;
+		__entry->function	= timer->function;
 	),
 
-	TP_printk("timer=%p now=%lu", __entry->timer, __entry->now)
+	TP_printk("timer=%p function=%pf now=%lu", __entry->timer, __entry->function,__entry->now)
 );
 
 /**
@@ -200,14 +202,16 @@ TRACE_EVENT(hrtimer_expire_entry,
 	TP_STRUCT__entry(
 		__field( void *,	hrtimer	)
 		__field( s64,		now	)
+		__field( void *,	function)
 	),
 
 	TP_fast_assign(
 		__entry->hrtimer	= hrtimer;
 		__entry->now		= now->tv64;
+		__entry->function	= hrtimer->function;
 	),
 
-	TP_printk("hrtimer=%p now=%llu", __entry->hrtimer,
+	TP_printk("hrtimer=%p function=%pf now=%llu", __entry->hrtimer, __entry->function,
 		  (unsigned long long)ktime_to_ns((ktime_t) { .tv64 = __entry->now }))
  );
 
