Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1HQUg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:36:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45135 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab1HQUgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:36:54 -0400
From: Alex Neronskiy <zakmagnus@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.org>
Subject: [PATCH/RFC v9 2/2] Use trace events to report stalls
Date: Wed, 17 Aug 2011 13:36:09 -0700
Message-Id: <1313613369-16165-2-git-send-email-zakmagnus@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313613369-16165-1-git-send-email-zakmagnus@chromium.org>
References: <1313613369-16165-1-git-send-email-zakmagnus@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Neronskiy <zakmagnus@chromium.org>
---
This outputs both the numerical representation of the stall as well
as a stack trace. The trace, unlike the number, is always output,
regardless of what debug/tracing/events/watchdog/enable says. I
don't know how to hook into that.

 kernel/trace_watchdog.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 kernel/watchdog.c       |   23 +++++++++++------------
 2 files changed, 54 insertions(+), 12 deletions(-)
 create mode 100644 kernel/trace_watchdog.h

diff --git a/kernel/trace_watchdog.h b/kernel/trace_watchdog.h
new file mode 100644
index 0000000..1401d27f
--- /dev/null
+++ b/kernel/trace_watchdog.h
@@ -0,0 +1,43 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM watchdog
+
+#if !defined(_TRACE_WATCHDOG_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_WATCHDOG_H
+
+#include <linux/tracepoint.h>
+#include <linux/stacktrace.h>
+
+TRACE_EVENT(soft_stall,
+	TP_PROTO(unsigned long stall),
+	TP_ARGS(stall),
+	TP_STRUCT__entry(
+		__field(unsigned long, stall)
+	),
+	TP_fast_assign(
+		__entry->stall = stall;
+	),
+	TP_printk("Soft stall: %lums", __entry->stall)
+);
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+TRACE_EVENT(hard_stall,
+	TP_PROTO(unsigned long stall),
+	TP_ARGS(stall),
+	TP_STRUCT__entry(
+		__field(unsigned long, stall)
+	),
+	TP_fast_assign(
+		__entry->stall = stall;
+	),
+	TP_printk("Hard stall: %lu", __entry->stall)
+);
+#endif /* CONFIG_HARDLOCKUP_DETECTOR */
+
+#endif /* _TRACE_WATCHDOG_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+
+#define TRACE_INCLUDE_FILE trace_watchdog
+#include <trace/define_trace.h>
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d4c51cc..18385ed 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -27,6 +27,9 @@
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
 
+#define CREATE_TRACE_POINTS
+#include "trace_watchdog.h"
+
 int watchdog_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
 static unsigned long worst_softstall;
@@ -208,7 +211,7 @@ void touch_softlockup_watchdog_sync(void)
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 /* watchdog detector functions */
-static void update_hardstall(unsigned long stall, int this_cpu)
+static void update_hardstall(unsigned long stall)
 {
 	int update_stall = 0;
 
@@ -222,10 +225,8 @@ static void update_hardstall(unsigned long stall, int this_cpu)
 	}
 
 	if (update_stall) {
-		printk(KERN_WARNING "LOCKUP may be in progress!"
-			"Worst hard stall seen on CPU#%d: %lu interrupts missed\n",
-			this_cpu, stall);
-		dump_stack();
+		trace_hard_stall(stall);
+		trace_dump_stack();
 	}
 }
 
@@ -245,12 +246,12 @@ static int is_hardlockup(int this_cpu)
 	if (ints_missed >= hardlockup_thresh)
 		return 1;
 
-	update_hardstall(ints_missed, this_cpu);
+	update_hardstall(ints_missed);
 	return 0;
 }
 #endif
 
-static void update_softstall(unsigned long stall, int this_cpu)
+static void update_softstall(unsigned long stall)
 {
 	int update_stall = 0;
 	if (stall > get_softstall_thresh() &&
@@ -264,10 +265,8 @@ static void update_softstall(unsigned long stall, int this_cpu)
 	}
 
 	if (update_stall) {
-		printk(KERN_WARNING "LOCKUP may be in progress!"
-				"Worst soft stall seen on CPU#%d: %lums\n",
-				this_cpu, stall);
-		dump_stack();
+		trace_soft_stall(stall);
+		trace_dump_stack();
 	}
 }
 
@@ -280,7 +279,7 @@ static int is_softlockup(unsigned long touch_ts, int this_cpu)
 	if (time_after(now, touch_ts + 1000 * get_softlockup_thresh()))
 		return stall;
 
-	update_softstall(stall, this_cpu);
+	update_softstall(stall);
 
 	return 0;
 }
-- 
1.7.3.1

