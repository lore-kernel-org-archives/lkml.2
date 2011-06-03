Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1FCO7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:59:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1FCO67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:58:59 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 3/5] tracing, function: Fix trace header to follow context-info option
Date: Fri,  3 Jun 2011 16:58:49 +0200
Message-Id: <1307113131-10045-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1307113131-10045-1-git-send-email-jolsa@redhat.com>
References: <1307111215.3667.53.camel@gandalf.stny.rr.com>
 <1307113131-10045-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/trace/trace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee9c921..01fc8d7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2051,6 +2051,9 @@ void trace_default_header(struct seq_file *m)
 {
 	struct trace_iterator *iter = m->private;
 
+	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
+		return;
+
 	if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
 		/* print nothing if the buffers are empty */
 		if (trace_empty(iter))
-- 
1.7.1

