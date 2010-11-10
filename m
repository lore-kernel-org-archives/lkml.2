Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0KJL4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:56:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab0KJL43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:56:29 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] tracing - fix recursive user stack trace
Date: Wed, 10 Nov 2010 12:56:12 +0100
Message-Id: <1289390172-9730-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user stack trace can fault when examining the trace. Which
would call the do_page_fault handler, which would trace again,
which would do the user stack trace, which would fault and call
do_page_fault again ...

Thus this is causing a recursive bug. We need to have a recursion
detector here.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 82d9b81..0215e87 100644
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
+	if (__get_cpu_var(user_stack_count))
+		goto out;
+
+	__get_cpu_var(user_stack_count)++;
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
+	__get_cpu_var(user_stack_count)--;
+
+ out:
+	preempt_enable();
 }
 
 #ifdef UNUSED
-- 
1.7.1

