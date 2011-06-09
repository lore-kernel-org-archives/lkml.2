Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1FIRaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:30:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1FIR3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:29:16 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=JKEXRdkTv48A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=IKevOhzDfAtzxxjoFzQA:9 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110609172912.411145320@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:27:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/15] tracing, function: Fix trace header to follow context-info option
References: <20110609172744.333794089@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-function-Fix-trace-header-to-follow-context-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The header display of function tracer does not follow
the context-info option, so field names are displayed even
if this option is off.

Added check for TRACE_ITER_CONTEXT_INFO trace_flags.

With following commands:
	# echo function > ./current_tracer
	# echo 0 > options/context-info
	# cat trace

This is what it looked like before:
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
add_preempt_count <-schedule
rcu_note_context_switch <-schedule
...

This is what it looks like now:
# tracer: function
#
_raw_spin_unlock_irqrestore <-hrtimer_try_to_cancel
...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1307113131-10045-4-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b926578..3d5e17a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2052,6 +2052,9 @@ void trace_default_header(struct seq_file *m)
 {
 	struct trace_iterator *iter = m->private;
 
+	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
+		return;
+
 	if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
 		/* print nothing if the buffers are empty */
 		if (trace_empty(iter))
-- 
1.7.4.4


