Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0JUBmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:42:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57408 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab0JUBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:41:45 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=lGjoF7kkascA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=I6j03qa_a5nMc7jSCuIA:9 a=j2HSjwhxuXFDMmviMoAA:7 a=S4nzhdbaUxImGZ2HaPg-gVDsWsgA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101021014144.393522857@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Oct 2010 21:39:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 7/8] ring-buffer: Micro-optimize with some strategic inlining
References: <20101021013906.507064528@goodmis.org>
Content-Disposition: inline; filename=0007-ring-buffer-Micro-optimize-with-some-strategic-inlin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

By using inline and noinline, we are able to make the fast path of
recording an event 4% faster.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d9f3e7a..f5007d0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2078,7 +2078,7 @@ static void rb_start_commit(struct ring_buffer_per_cpu *cpu_buffer)
 	local_inc(&cpu_buffer->commits);
 }
 
-static void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
+static inline void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	unsigned long commits;
 
@@ -2193,13 +2193,9 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 
 #define TRACE_RECURSIVE_DEPTH 16
 
-static int trace_recursive_lock(void)
+/* Keep this code out of the fast path cache */
+static noinline void trace_recursive_fail(void)
 {
-	current->trace_recursion++;
-
-	if (likely(current->trace_recursion < TRACE_RECURSIVE_DEPTH))
-		return 0;
-
 	/* Disable all tracing before we do anything else */
 	tracing_off_permanent();
 
@@ -2211,10 +2207,21 @@ static int trace_recursive_lock(void)
 		    in_nmi());
 
 	WARN_ON_ONCE(1);
+}
+
+static inline int trace_recursive_lock(void)
+{
+	current->trace_recursion++;
+
+	if (likely(current->trace_recursion < TRACE_RECURSIVE_DEPTH))
+		return 0;
+
+	trace_recursive_fail();
+
 	return -1;
 }
 
-static void trace_recursive_unlock(void)
+static inline void trace_recursive_unlock(void)
 {
 	WARN_ON_ONCE(!current->trace_recursion);
 
-- 
1.7.1


