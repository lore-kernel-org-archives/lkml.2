Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0KMC5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 21:57:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0KMC5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 21:57:52 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=7p6bkbCgeYgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=jqXQ-xn1kw274rXKkuYA:9 a=nAUpLxcKp-zlUU9QwrkA:7 a=kmeed5hNP8REOk56bdS7tZT0jnwA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] tracing: Fix recursive user stack trace
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 21:57:49 -0500
Message-ID: <1289617069.12418.575.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This also includes the two other patches I submitted previously.
I just rebased the third patch with Eric's recommendation.

Please pull the latest tip/perf/urgent-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent-3


Steven Rostedt (1):
      tracing: Fix recursive user stack trace

----
 kernel/trace/trace.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)
---------------------------
commit 91e86e560d0b3ce4c5fc64fd2bbb99f856a30a4e
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Nov 10 12:56:12 2010 +0100

    tracing: Fix recursive user stack trace
    
    The user stack trace can fault when examining the trace. Which
    would call the do_page_fault handler, which would trace again,
    which would do the user stack trace, which would fault and call
    do_page_fault again ...
    
    Thus this is causing a recursive bug. We need to have a recursion
    detector here.
    
    [ Resubmitted by Jiri Olsa ]
    
    [ Eric Dumazet recommended using __this_cpu_* instead of __get_cpu_* ]
    
    Cc: Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: Jiri Olsa <jolsa@redhat.com>
    LKML-Reference: <1289390172-9730-3-git-send-email-jolsa@redhat.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 82d9b81..ee6a733 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1284,6 +1284,8 @@ void trace_dump_stack(void)
 	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
 }
 
+static DEFINE_PER_CPU(int, user_stack_count);
+
 void
 ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 {
@@ -1302,6 +1304,18 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	if (unlikely(in_nmi()))
 		return;
 
+	/*
+	 * prevent recursion, since the user stack tracing may
+	 * trigger other kernel events.
+	 */
+	preempt_disable();
+	if (__this_cpu_read(user_stack_count))
+		goto out;
+
+	__this_cpu_inc(user_stack_count);
+
+
+
 	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)
@@ -1319,6 +1333,11 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	save_stack_trace_user(&trace);
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
+
+	__this_cpu_dec(user_stack_count);
+
+ out:
+	preempt_enable();
 }
 
 #ifdef UNUSED


