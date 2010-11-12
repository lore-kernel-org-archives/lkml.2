Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab0KLPMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:12:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab0KLPMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:12:24 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=hHUGQOVUbM8A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=AgZKqvVX_7YeQFwo2cUA:9 a=HHv1o2s-yiuT5b8Wmt8A:7 a=q7QeflhYWY_7-ic_ictTKi94KbMA:4 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101112151223.183540991@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Nov 2010 10:10:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/3] tracing: Fix recursive user stack trace
References: <20101112151045.672405637@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Fix-recursive-user-stack-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The user stack trace can fault when examining the trace. Which
would call the do_page_fault handler, which would trace again,
which would do the user stack trace, which would fault and call
do_page_fault again ...

Thus this is causing a recursive bug. We need to have a recursion
detector here.

[ Resubmitted by Jiri Olsa ]
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1289390172-9730-3-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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


