Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab1EXSTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:19:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab1EXSRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:17:21 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=bAE2sNjOBh8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=hQU54lLi4O9_Ju9IwBkA:9 a=aQzckhnmw9b3kP2VtPAA:7 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=St14ymVX4Gi8nI7h:21 a=JeKFzdtoDGImNPpe:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110524181720.617618026@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 14:10:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 06/12] tracing: Schedule a delayed work to call wakeup()
References: <20110524181032.382259739@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Schedule-a-delayed-work-to-call-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

In using syscall tracing by concurrent processes, the wakeup() that is
called in the event commit function causes contention on the spin lock
of the waitqueue. I enabled sys_enter_getuid and sys_exit_getuid
tracepoints, and by running getuid_microbench from autotest in parallel
I found that the contention causes exponential latency increase in the
tracing path.

The autotest binary getuid_microbench calls getuid() in a tight loop for
the given number of iterations and measures the average time required to
complete a single invocation of syscall.

The patch schedules a delayed work after 2 ms once an event commit calls
to wake up the trace wait_queue. This removes the delay caused by
contention on spin lock in wakeup() and amortizes the wakeup() calls
scheduled over the 2 ms period.

In the following example, the script enables the sys_enter_getuid and
sys_exit_getuid tracepoints and runs the getuid_microbench in parallel
with the given number of processes. The output clearly shows the latency
increase caused by contentions.

$ ~/getuid.sh 1
1000000 calls in 0.720974253 s (720.974253 ns/call)

$ ~/getuid.sh 2
1000000 calls in 1.166457554 s (1166.457554 ns/call)
1000000 calls in 1.168933765 s (1168.933765 ns/call)

$ ~/getuid.sh 3
1000000 calls in 1.783827516 s (1783.827516 ns/call)
1000000 calls in 1.795553270 s (1795.553270 ns/call)
1000000 calls in 1.796493376 s (1796.493376 ns/call)

$ ~/getuid.sh 4
1000000 calls in 4.483041796 s (4483.041796 ns/call)
1000000 calls in 4.484165388 s (4484.165388 ns/call)
1000000 calls in 4.484850762 s (4484.850762 ns/call)
1000000 calls in 4.485643576 s (4485.643576 ns/call)

$ ~/getuid.sh 5
1000000 calls in 6.497521653 s (6497.521653 ns/call)
1000000 calls in 6.502000236 s (6502.000236 ns/call)
1000000 calls in 6.501709115 s (6501.709115 ns/call)
1000000 calls in 6.502124100 s (6502.124100 ns/call)
1000000 calls in 6.502936358 s (6502.936358 ns/call)

After the patch, the latencies scale better.
1000000 calls in 0.728720455 s (728.720455 ns/call)

1000000 calls in 0.842782857 s (842.782857 ns/call)
1000000 calls in 0.883803135 s (883.803135 ns/call)

1000000 calls in 0.902077764 s (902.077764 ns/call)
1000000 calls in 0.902838202 s (902.838202 ns/call)
1000000 calls in 0.908896885 s (908.896885 ns/call)

1000000 calls in 0.932523515 s (932.523515 ns/call)
1000000 calls in 0.958009672 s (958.009672 ns/call)
1000000 calls in 0.986188020 s (986.188020 ns/call)
1000000 calls in 0.989771102 s (989.771102 ns/call)

1000000 calls in 0.933518391 s (933.518391 ns/call)
1000000 calls in 0.958897947 s (958.897947 ns/call)
1000000 calls in 1.031038897 s (1031.038897 ns/call)
1000000 calls in 1.089516025 s (1089.516025 ns/call)
1000000 calls in 1.141998347 s (1141.998347 ns/call)

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1305059241-7629-1-git-send-email-vnagarnaik@google.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee9c921..2af132e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -343,26 +343,27 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
 
+static void wakeup_work_handler(struct work_struct *work)
+{
+	wake_up(&trace_wait);
+}
+
+static DECLARE_DELAYED_WORK(wakeup_work, wakeup_work_handler);
+
 /**
  * trace_wake_up - wake up tasks waiting for trace input
  *
- * Simply wakes up any task that is blocked on the trace_wait
- * queue. These is used with trace_poll for tasks polling the trace.
+ * Schedules a delayed work to wake up any task that is blocked on the
+ * trace_wait queue. These is used with trace_poll for tasks polling the
+ * trace.
  */
 void trace_wake_up(void)
 {
-	int cpu;
+	const unsigned long delay = msecs_to_jiffies(2); //delay 2 ms
 
 	if (trace_flags & TRACE_ITER_BLOCK)
 		return;
-	/*
-	 * The runqueue_is_locked() can fail, but this is the best we
-	 * have for now:
-	 */
-	cpu = get_cpu();
-	if (!runqueue_is_locked(cpu))
-		wake_up(&trace_wait);
-	put_cpu();
+	schedule_delayed_work(&wakeup_work, delay);
 }
 
 static int __init set_buf_size(char *str)
-- 
1.7.4.4


