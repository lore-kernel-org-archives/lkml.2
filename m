Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab0DADSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:18:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0DADSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:18:21 -0400
X-Authority-Analysis: v=1.1 cv=W8jVbnnOFeMnsvu+vJfVVAGaiNyfzTaRLlU2b8ifu+8= c=1 sm=0 a=vwqKU94Vsi4A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=adTaOm2Smiow8V5QAUEA:9 a=zSjI_lYxRVzUL21odPQA:7 a=uFG7W7Zk9z9l8qo5uhenYky9cfMA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=BVJYc9CU9XkE0nFO:21 a=KHW5ifhXL65VuW7n:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100401031819.089633620@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 31 Mar 2010 23:17:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/7] tracing: Convert some signal events to DEFINE_TRACE
References: <20100401031735.683626160@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Convert-some-signal-events-to-DEFINE_TRACE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Use DECLARE_EVENT_CLASS to remove duplicate code:

text    data     bss     dec     hex filename
  23639    6084       8   29731    7423 kernel/signal.o.orig
  22727    6084       8   28819    7093 kernel/signal.o

2 events are converted:

  signal_queue_overflow: signal_overflow_fail, signal_lose_info

No functional change.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BA97FBD.8070703@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/signal.h |   52 +++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index a510b75..814566c 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -100,18 +100,7 @@ TRACE_EVENT(signal_deliver,
 		  __entry->sa_handler, __entry->sa_flags)
 );
 
-/**
- * signal_overflow_fail - called when signal queue is overflow
- * @sig: signal number
- * @group: signal to process group or not (bool)
- * @info: pointer to struct siginfo
- *
- * Kernel fails to generate 'sig' signal with 'info' siginfo, because
- * siginfo queue is overflow, and the signal is dropped.
- * 'group' is not 0 if the signal will be sent to a process group.
- * 'sig' is always one of RT signals.
- */
-TRACE_EVENT(signal_overflow_fail,
+DECLARE_EVENT_CLASS(signal_queue_overflow,
 
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
@@ -135,6 +124,24 @@ TRACE_EVENT(signal_overflow_fail,
 );
 
 /**
+ * signal_overflow_fail - called when signal queue is overflow
+ * @sig: signal number
+ * @group: signal to process group or not (bool)
+ * @info: pointer to struct siginfo
+ *
+ * Kernel fails to generate 'sig' signal with 'info' siginfo, because
+ * siginfo queue is overflow, and the signal is dropped.
+ * 'group' is not 0 if the signal will be sent to a process group.
+ * 'sig' is always one of RT signals.
+ */
+DEFINE_EVENT(signal_queue_overflow, signal_overflow_fail,
+
+	TP_PROTO(int sig, int group, struct siginfo *info),
+
+	TP_ARGS(sig, group, info)
+);
+
+/**
  * signal_lose_info - called when siginfo is lost
  * @sig: signal number
  * @group: signal to process group or not (bool)
@@ -145,28 +152,13 @@ TRACE_EVENT(signal_overflow_fail,
  * 'group' is not 0 if the signal will be sent to a process group.
  * 'sig' is always one of non-RT signals.
  */
-TRACE_EVENT(signal_lose_info,
+DEFINE_EVENT(signal_queue_overflow, signal_lose_info,
 
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
-	TP_ARGS(sig, group, info),
-
-	TP_STRUCT__entry(
-		__field(	int,	sig	)
-		__field(	int,	group	)
-		__field(	int,	errno	)
-		__field(	int,	code	)
-	),
-
-	TP_fast_assign(
-		__entry->sig	= sig;
-		__entry->group	= group;
-		TP_STORE_SIGINFO(__entry, info);
-	),
-
-	TP_printk("sig=%d group=%d errno=%d code=%d",
-		  __entry->sig, __entry->group, __entry->errno, __entry->code)
+	TP_ARGS(sig, group, info)
 );
+
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */
-- 
1.7.0


