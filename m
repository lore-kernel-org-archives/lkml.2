Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1BHWSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:18:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab1BHWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:22 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=ZvZDiN3hnSYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=hi_Dvdma7l9kYd-bG3sA:9 a=9uoIOUN0XqQazCprEDH1sEAtAbcA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221721.408925046@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/10] tracing: Deprecate tracing_enabled for tracing_on
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Deprecate-tracing_enabled-for-tracing_on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

tracing_enabled should not be used, it is heavy weight and does not
do much in helping lower the overhead.

tracing_on should be used instead. Warn users to use tracing_on
when tracing_enabled is used as it will soon be removed from the
tracing directory.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |   38 +++++++++++++++++++-------------------
 kernel/trace/trace.c           |    4 ++++
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 65eddb7..67f1cc4 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -80,11 +80,11 @@ of ftrace. Here is a list of some of the key files:
 	tracers listed here can be configured by
 	echoing their name into current_tracer.
 
-  tracing_enabled:
+  tracing_on:
 
-	This sets or displays whether the current_tracer
-	is activated and tracing or not. Echo 0 into this
-	file to disable the tracer or 1 to enable it.
+	This sets or displays whether writing to the trace
+	ring buffer is enabled. Echo 0 into this file to disable
+	the tracer or 1 to enable it.
 
   trace:
 
@@ -497,10 +497,10 @@ an example:
  # echo irqsoff > current_tracer
  # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
- # echo 1 > tracing_enabled
+ # echo 1 > tracing_on
  # ls -ltr
  [...]
- # echo 0 > tracing_enabled
+ # echo 0 > tracing_on
  # cat trace
 # tracer: irqsoff
 #
@@ -605,10 +605,10 @@ is much like the irqsoff tracer.
  # echo preemptoff > current_tracer
  # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
- # echo 1 > tracing_enabled
+ # echo 1 > tracing_on
  # ls -ltr
  [...]
- # echo 0 > tracing_enabled
+ # echo 0 > tracing_on
  # cat trace
 # tracer: preemptoff
 #
@@ -753,10 +753,10 @@ tracers.
  # echo preemptirqsoff > current_tracer
  # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
- # echo 1 > tracing_enabled
+ # echo 1 > tracing_on
  # ls -ltr
  [...]
- # echo 0 > tracing_enabled
+ # echo 0 > tracing_on
  # cat trace
 # tracer: preemptirqsoff
 #
@@ -916,9 +916,9 @@ Instead of performing an 'ls', we will run 'sleep 1' under
  # echo wakeup > current_tracer
  # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
- # echo 1 > tracing_enabled
+ # echo 1 > tracing_on
  # chrt -f 5 sleep 1
- # echo 0 > tracing_enabled
+ # echo 0 > tracing_on
  # cat trace
 # tracer: wakeup
 #
@@ -1030,9 +1030,9 @@ ftrace_enabled is set; otherwise this tracer is a nop.
 
  # sysctl kernel.ftrace_enabled=1
  # echo function > current_tracer
- # echo 1 > tracing_enabled
+ # echo 1 > tracing_on
  # usleep 1
- # echo 0 > tracing_enabled
+ # echo 0 > tracing_on
  # cat trace
 # tracer: function
 #
@@ -1070,7 +1070,7 @@ int trace_fd;
 [...]
 int main(int argc, char *argv[]) {
 	[...]
-	trace_fd = open(tracing_file("tracing_enabled"), O_WRONLY);
+	trace_fd = open(tracing_file("tracing_on"), O_WRONLY);
 	[...]
 	if (condition_hit()) {
 		write(trace_fd, "0", 1);
@@ -1521,9 +1521,9 @@ If I am only interested in sys_nanosleep and hrtimer_interrupt:
  # echo sys_nanosleep hrtimer_interrupt \
 		> set_ftrace_filter
  # echo function > current_tracer
- # echo 1 > tracing_enabled
+ # echo 1 > tracing_on
  # usleep 1
- # echo 0 > tracing_enabled
+ # echo 0 > tracing_on
  # cat trace
 # tracer: ftrace
 #
@@ -1769,9 +1769,9 @@ different. The trace is live.
  # echo function > current_tracer
  # cat trace_pipe > /tmp/trace.out &
 [1] 4153
- # echo 1 > tracing_enabled
+ # echo 1 > tracing_on
  # usleep 1
- # echo 0 > tracing_enabled
+ # echo 0 > tracing_on
  # cat trace
 # tracer: function
 #
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dc53ecb..8dc8da6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2710,6 +2710,10 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 
 	mutex_lock(&trace_types_lock);
 	if (tracer_enabled ^ val) {
+
+		/* Only need to warn if this is used to change the state */
+		WARN_ONCE(1, "tracing_enabled is deprecated. Use tracing_on");
+
 		if (val) {
 			tracer_enabled = 1;
 			if (current_trace->start)
-- 
1.7.2.3


