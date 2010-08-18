Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081Ab0HRWdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:33:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:37420 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0HRWdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:33:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,229,1280732400"; 
   d="scan'208,223";a="597970580"
Message-ID: <4C6C5FA9.3000405@linux.intel.com>
Date: Wed, 18 Aug 2010 15:33:13 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, xiaoguangrong@cn.fujitsu.com
Subject: [PATCH] tracing: Make timer tracing actually useful
Content-Type: multipart/mixed;
 boundary="------------000301010808080405030201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000301010808080405030201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



 From fe9633af11395d339880417439a1931bb9e7e493 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 18 Aug 2010 15:28:59 -0400
Subject: [PATCH] tracing: Make timer tracing actually useful

PowerTOP would like to be able to trace timers.
Unfortunately, the current timer tracing is not very useful, the actual
timer function is not recorded in the trace at the start of timer execution.

Although this is recorded for timer "start" time (when it gets armed), this
is not useful; most timers get started early, and a tracer like PowerTOP
will never see this event, but will only see the actual running of the 
timer.

This patch just adds the function to the timer tracing; I've verified with
PowerTOP that now it can get useful information about timers.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
  include/trace/events/timer.h |    8 ++++++--
  1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index c624126..94511c8 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -81,14 +81,16 @@ TRACE_EVENT(timer_expire_entry,
      TP_STRUCT__entry(
          __field( void *,    timer    )
          __field( unsigned long,    now    )
+        __field( void *,    function    )
      ),

      TP_fast_assign(
          __entry->timer        = timer;
          __entry->now        = jiffies;
+        __entry->function    = timer->function;
      ),

-    TP_printk("timer=%p now=%lu", __entry->timer, __entry->now)
+    TP_printk("timer=%p function=%pf now=%lu", __entry->timer, 
__entry->function,__entry->now)
  );

  /**
@@ -200,14 +202,16 @@ TRACE_EVENT(hrtimer_expire_entry,
      TP_STRUCT__entry(
          __field( void *,    hrtimer    )
          __field( s64,        now    )
+        __field( void *,    function    )
      ),

      TP_fast_assign(
          __entry->hrtimer    = hrtimer;
          __entry->now        = now->tv64;
+        __entry->function    = hrtimer->function;
      ),

-    TP_printk("hrtimer=%p now=%llu", __entry->hrtimer,
+    TP_printk("hrtimer=%p function=%pf now=%llu", __entry->hrtimer, 
__entry->function,
            (unsigned long long)ktime_to_ns((ktime_t) { .tv64 = 
__entry->now }))
   );

-- 
1.6.1.3


--------------000301010808080405030201
Content-Type: text/plain;
 name="0001-tracing-Make-timer-tracing-actually-useful.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-tracing-Make-timer-tracing-actually-useful.patch"

>From fe9633af11395d339880417439a1931bb9e7e493 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 18 Aug 2010 15:28:59 -0400
Subject: [PATCH] tracing: Make timer tracing actually useful

PowerTOP would like to be able to trace timers.
Unfortunately, the current timer tracing is not very useful, the actual
timer function is not recorded in the trace at the start of timer execution.

Although this is recorded for timer "start" time (when it gets armed), this
is not useful; most timers get started early, and a tracer like PowerTOP
will never see this event, but will only see the actual running of the timer.

This patch just adds the function to the timer tracing; I've verified with
PowerTOP that now it can get useful information about timers.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/trace/events/timer.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index c624126..94511c8 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -81,14 +81,16 @@ TRACE_EVENT(timer_expire_entry,
 	TP_STRUCT__entry(
 		__field( void *,	timer	)
 		__field( unsigned long,	now	)
+		__field( void *,	function	)
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
+		__field( void *,	function	)
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
 
-- 
1.6.1.3


--------------000301010808080405030201--
