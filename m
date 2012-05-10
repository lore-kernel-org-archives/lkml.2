Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab2EJXKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:10:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5461 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2EJXKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:10:21 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=PuFSj2cVAUYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1PS2i99sygln3H0yJJ0A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336691420.14207.246.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.4] tracing: Fix a regression with enabling all
 events
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 10 May 2012 19:10:20 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I found this regression from the adding of function tracing to perf had
a side effect of causing an error message to print, and potentially
worse, the perf ->reg() function being called out of context.

-- Steve
	
Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 9b63776fa3ca96c4ecda76f6fa947b7b0add66ac


Steven Rostedt (1):
      tracing: Do not enable function event with enable

----
 include/linux/ftrace_event.h |    2 ++
 kernel/trace/trace_events.c  |    5 ++++-
 kernel/trace/trace_export.c  |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)
---------------------------
commit 9b63776fa3ca96c4ecda76f6fa947b7b0add66ac
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu May 10 15:55:43 2012 -0400

    tracing: Do not enable function event with enable
    
    With the adding of function tracing event to perf, it caused a
    side effect that produces the following warning when enabling all
    events in ftrace:
    
     # echo 1 > /sys/kernel/debug/tracing/events/enable
    
    [console]
    event trace: Could not enable event function
    
    This is because when enabling all events via the debugfs system
    it ignores events that do not have a ->reg() function assigned.
    This was to skip over the ftrace internal events (as they are
    not TRACE_EVENTs). But as the ftrace function event now has
    a ->reg() function attached to it for use with perf, it is no
    longer ignored.
    
    Worse yet, this ->reg() function is being called when it should
    not be. It returns an error and causes the above warning to
    be printed.
    
    By adding a new event_call flag (TRACE_EVENT_FL_IGNORE_ENABLE)
    and have all ftrace internel event structures have it set,
    setting the events/enable will no longe try to incorrectly enable
    the function event and does not warn.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5f3f3be..176a939 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -179,6 +179,7 @@ enum {
 	TRACE_EVENT_FL_RECORDED_CMD_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
 	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
+	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
 };
 
 enum {
@@ -187,6 +188,7 @@ enum {
 	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
 	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
 	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
+	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
 };
 
 struct ftrace_event_call {
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 079a93a..29111da 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -294,6 +294,9 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
 		if (!call->name || !call->class || !call->class->reg)
 			continue;
 
+		if (call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
+			continue;
+
 		if (match &&
 		    strcmp(match, call->name) != 0 &&
 		    strcmp(match, call->class->system) != 0)
@@ -1164,7 +1167,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		return -1;
 	}
 
-	if (call->class->reg)
+	if (call->class->reg && !(call->flags & TRACE_EVENT_FL_IGNORE_ENABLE))
 		trace_create_file("enable", 0644, call->dir, call,
 				  enable);
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 3dd15e8..e039906 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -180,6 +180,7 @@ struct ftrace_event_call __used event_##call = {			\
 	.event.type		= etype,				\
 	.class			= &event_class_ftrace_##call,		\
 	.print_fmt		= print,				\
+	.flags			= TRACE_EVENT_FL_IGNORE_ENABLE,		\
 };									\
 struct ftrace_event_call __used						\
 __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;


