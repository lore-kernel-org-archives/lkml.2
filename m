Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2BQQJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 11:09:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39448 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2BQQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 11:09:53 -0500
MIME-Version: 1.0
Date: Fri, 17 Feb 2012 21:39:52 +0530
Message-ID: <CA+jqyFAabkTRWENA5Cu8Q8O5Vc+4hmeiTS2_tduuLt2LH+mHBA@mail.gmail.com>
Subject: [PATCH 1/1] ftrace: fix function graph tracer
From: Rajesh Bhagat <rajesh.lnx@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 31f8971a19b45aae8227c6d143a6ecde26fa68b2 Mon Sep 17 00:00:00 2001
From: Rajesh Bhagat <rajesh.lnx@gmail.com>
Date: Fri, 17 Feb 2012 13:59:15 +0530
Subject: [PATCH 1/1] ftrace: fix function graph tracer

when function tracer is set - function_graph tracer is not working
Problem occurs when CONFIG_DYNAMIC_FTRACE is not set

Output before patch
/debug/tracing # echo function > current_tracer
/debug/tracing # echo function_graph > current_tracer
/debug/tracing # cat trace

Output after patch
/debug/tracing # echo function > current_tracer
/debug/tracing # echo function_graph > current_tracer
/debug/tracing # cat trace
0) ! 253.375 us | } /* irq_enter */
0) | generic_handle_irq() {
0) | handle_fasteoi_irq() {
0) 9.208 us | _raw_spin_lock();
0) | handle_irq_event() {
0) | handle_irq_event_percpu() {

Signed-off-by: Rajesh Bhagat <rajesh.lnx@gmail.com>
---
 kernel/trace/ftrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 683d559..dc2de98 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -219,7 +219,8 @@ static void update_ftrace_function(void)
 #else
    __ftrace_trace_function = func;
 #endif
-   ftrace_trace_function = ftrace_test_stop_func;
+   ftrace_trace_function =
+       (func == ftrace_stub) ? func : ftrace_test_stop_func;
 #endif
 }
-- 
1.7.6
