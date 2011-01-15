Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1AOBFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 20:05:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1AOBFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 20:05:19 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=c4K3OtSgUW4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=FOI7FFCQKlPIwOgrCoMA:9 a=tAA0sBuQvleWViVjETIA:7 a=9Pyjwv27-xzwNKylci5qQXPV95EA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110115010517.907508227@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 Jan 2011 20:04:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] tracing: Only process module tracepoints once
References: <20110115010442.446174852@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Only-process-module-tracepoints-once.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The commit:

 9f987b3141f086de27832514aad9f50a53f754
 tracing: Include module.h in define_trace.h

only solved half the problem. If the trace/events/module.h header is
included at the time of define_trace.h (or in ftrace.h within it),
the module.h TRACE_SYSTEM will override the current TRACE_SYSTEM
macro.

Since define_trace.h is included when CREATE_TRACE_POINTS is set,
and the first thing it does is to #undef CREATE_TRACE_POINTS,
by placing the module.h TRACE_SYSTEM inside a
 #ifdef CREATE_TRACE_POINTS
we can prevent it from overriding the TRACE_SYSTEM that is
being processed, and still process the module.h tracepoints
when the module code defines CREATE_TRACE_POINTS and includes
the trace/events/module.h header.

As with commit 9f987b3141, this is only an issue if module.h
is not included before the trace/events/<event>.h file is
included, which (luckily) has not happened yet.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/module.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index c7bb2f0..c6bae36 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -1,5 +1,15 @@
+/*
+ * Because linux/module.h has tracepoints in the header, and ftrace.h
+ * eventually includes this file, define_trace.h includes linux/module.h
+ * But we do not want the module.h to override the TRACE_SYSTEM macro
+ * variable that define_trace.h is processing, so we only set it
+ * when module events are being processed, which would happen when
+ * CREATE_TRACE_POINTS is defined.
+ */
+#ifdef CREATE_TRACE_POINTS
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM module
+#endif
 
 #if !defined(_TRACE_MODULE_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_MODULE_H
-- 
1.7.2.3


