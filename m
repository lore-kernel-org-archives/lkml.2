Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1BIUKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:10:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1BIUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:10:32 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=KPctdiwS7pgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=WfulkdPnAAAA:8 a=meVymXHHAAAA:8 a=z92ZAsfz5gGZNyKBvmQA:9 a=OBcuedXyxaaXIjAvHoquoKGr1ukA:4 a=jEp0ucaQiEUA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110209201030.063742553@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 09 Feb 2011 15:02:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC][PATCH 3/4] ftrace: Do not test frame pointers if -mfentry is used
References: <20110209200249.111932716@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Do-not-test-frame-pointers-if-mfentry-is-used.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function graph has a test to check if the frame pointer is
corrupted, which can happen with various options of gcc with mcount.
But this is not an issue with -mfentry as -mfentry does not need nor use
frame pointers for function graph tracing.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 76b0598..e7bc48b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -129,7 +129,7 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
 		return;
 	}
 
-#ifdef CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST
+#if defined(CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST) && !defined(CC_HAS_FENTRY)
 	/*
 	 * The arch may choose to record the frame pointer used
 	 * and check it here to make sure that it is what we expect it
@@ -140,6 +140,9 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
 	 *
 	 * Currently, x86_32 with optimize for size (-Os) makes the latest
 	 * gcc do the above.
+	 *
+	 * Note, -mfentry does not use frame pointers, and this test
+	 *  is not needed if CC_HAS_FENTRY is set.
 	 */
 	if (unlikely(current->ret_stack[index].fp != frame_pointer)) {
 		ftrace_graph_stop();
-- 
1.7.2.3


