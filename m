Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495Ab1CYLFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:05:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125Ab1CYLFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:05:24 -0400
Date: Fri, 25 Mar 2011 12:05:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3] tracing - avoid soft lockup in trace_pipe
Message-ID: <20110325110518.GC1922@jolsa.brq.redhat.com>
References: <20110313145811.GA30558@redhat.com>
 <1300111651.9910.87.camel@gandalf.stny.rr.com>
 <20110314141853.GB1936@jolsa.brq.redhat.com>
 <1300112926.9910.100.camel@gandalf.stny.rr.com>
 <20110314150746.GA4453@jolsa.brq.redhat.com>
 <1300116057.9910.106.camel@gandalf.stny.rr.com>
 <20110314180621.GA5987@jolsa.brq.redhat.com>
 <20110321121008.GA1979@jolsa.brq.redhat.com>
 <1301019798.14261.159.camel@gandalf.stny.rr.com>
 <1301022889.14261.167.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301022889.14261.167.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:14:49PM -0400, Steven Rostedt wrote:
> On Thu, 2011-03-24 at 22:23 -0400, Steven Rostedt wrote:
> 
> > > > 
> > > > 
> > > > ---
> > > > running following commands:
> > > > 
> > > >   # enable the binary option
> > > >   echo 1 > ./options/bin
> > > >   # disable context info option
> > > >   echo 0 > ./options/context-info 
> > > >   # tracing only events
> > > >   echo 1 > ./events/enable
> > > >   cat trace_pipe
> 
> OK, I'm trying to reproduce this, but I'm not able to.
> 
> I disabled preemption, recompiled and rebooted, and I did the above and
> all I get is the numbers printing. But I can exit out with a simple ^C.
> 
> No soft lockups or anything.
> 
> 
> I'm not saying that your patch is useless, it does seem to clean things
> up. But I'm not seeing any lockups here.
> 
> The while loop will always exit when the ring buffer is empty.
> 
> You mean if the events are filling quicker than the loop then we have
> this issue. Perhaps I'm not triggering enough events?

right, I'm now able to trigger the issue when running setting the tracing
as said in the patch and plus running this in few instacies:

(while [ 1 ]; do find / > /dev/null ; done) &

It's strange I did not need this last time.. not sure why :)


anyway, the original reproducer I picked this issue from is ltp suite:
http://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20100131/ltp-full-20100131.tgz/download

and running following test:
ltp-full-20101031/testcases/kernel/tracing/ftrace_stress_test/ftrace_stress_test.sh 

reproduces the issue all the time for me, and the patch fixies it.
Attaching patch rebased to the current master with changed comment.

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

plus forcing system to generate many tracing events,
is causing lockup (in NON preemptive kernels) inside
tracing_read_pipe function.

The issue is also easily reproduced by running ltp stress test.
(ftrace_stress_test.sh)

The reasons are:
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

v3 changes:
 - make more accurate patch comment

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
