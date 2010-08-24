Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab0HXXE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:04:27 -0400
Received: from kroah.org ([198.145.64.141]:32932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933758Ab0HXXD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:57 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:11 2010
Message-Id: <20100824224511.226032117@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arjan van de Ven <arjan@linux.intel.com>, xiaoguangrong@cn.fujitsu.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [114/114] tracing: Fix timer tracing
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan van de Ven <arjan@linux.intel.com>

commit ede1b4290781ae82ccf0f2ecc6dada8d3dd35779 upstream.

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
LKML-Reference: <4C6C5FA9.3000405@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/trace/events/timer.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -74,14 +74,16 @@ TRACE_EVENT(timer_expire_entry,
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
@@ -213,14 +215,16 @@ TRACE_EVENT(hrtimer_expire_entry,
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
 


