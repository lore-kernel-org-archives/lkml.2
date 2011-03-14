Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1CNSG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:06:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab1CNSG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:06:26 -0400
Date: Mon, 14 Mar 2011 19:06:21 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] tracing - avoid soft lockup in trace_pipe
Message-ID: <20110314180621.GA5987@jolsa.brq.redhat.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
 <1299970786-8075-3-git-send-email-jolsa@redhat.com>
 <20110313145811.GA30558@redhat.com>
 <1300111651.9910.87.camel@gandalf.stny.rr.com>
 <20110314141853.GB1936@jolsa.brq.redhat.com>
 <1300112926.9910.100.camel@gandalf.stny.rr.com>
 <20110314150746.GA4453@jolsa.brq.redhat.com>
 <1300116057.9910.106.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300116057.9910.106.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 11:20:57AM -0400, Steven Rostedt wrote:
> On Mon, 2011-03-14 at 16:07 +0100, Jiri Olsa wrote:
> > So we get back the the while loop with no data added and with
> > TRACE_TYPE_HANDLED return code, which will keep us in the loop.
> > 
> > Not sure this is bug or feature :)
> > 
> > 
> Most bugs are features ;)
> 
> honestly, I'd love to rip out all the "bin", "hex" etc formats as they
> are pretty much deprecated.
> 
> But as you pointed out that this can keep us in the inner loop, we need
> to fix that. I prefer to fix it within the nop print function. Perhaps
> we need to fill in something. "type: %d", iter->ent->type ?

sounds ok :) attaching v2 patch

thanks,
jirka


---
running following commands:

  # enable the binary option
  echo 1 > ./options/bin
  # disable context info option
  echo 0 > ./options/context-info 
  # tracing only events
  echo 1 > ./events/enable
  cat trace_pipe

is causing lockup (in NON preemptive kernels) inside
tracing_read_pipe function.

The reason are:
 - bin/hex/raw output functions for events are set to
   trace_nop_print function, which prints nothing and
   returns TRACE_TYPE_HANDLED value
 - LOST EVENT trace do not handle trace_seq overflow

These reasons force the while loop in tracing_read_pipe
function never to break.

The attached patch fixies handling of lost event trace, and
changes trace_nop_print to print minimal info, which is needed
for the correct tracing_read_pipe processing.

v2 changes:
 - omit the cond_resched changes by trace_nop_print changes
 - WARN changed to WARN_ONCE and added info to be able
   to find out the culprit

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.c        |   15 ++++++++++++---
 kernel/trace/trace_output.c |    3 +++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9541c27..5af42f4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2013,9 +2013,10 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
-	if (iter->lost_events)
-		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
-				 iter->cpu, iter->lost_events);
+	if (iter->lost_events &&
+	    !trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->cpu, iter->lost_events))
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
@@ -3229,6 +3230,14 @@ waitagain:
 
 		if (iter->seq.len >= cnt)
 			break;
+
+		/*
+		 * Setting the full flag means we reached the trace_seq buffer
+		 * size and we should leave by partial output condition above.
+		 * One of the trace_seq_* functions is not used properly.
+		 */
+		WARN_ONCE(iter->seq.full, "full flag set for trace type %d",
+			  iter->ent->type);
 	}
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 456be90..cf535cc 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -830,6 +830,9 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_event);
 enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags,
 				  struct trace_event *event)
 {
+	if (!trace_seq_printf(&iter->seq, "type: %d\n", iter->ent->type))
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	return TRACE_TYPE_HANDLED;
 }
 
-- 
1.7.1

