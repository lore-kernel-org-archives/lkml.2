Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0CXC5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:57:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64573 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab0CXC5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:57:01 -0400
Message-ID: <4BA97FBD.8070703@cn.fujitsu.com>
Date: Wed, 24 Mar 2010 10:58:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing: Convert some signal events to DEFINE_TRACE
References: <4BA97FA7.6040406@cn.fujitsu.com>
In-Reply-To: <4BA97FA7.6040406@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DECLARE_EVENT_CLASS to remove duplicate code:

text    data     bss     dec     hex filename
  23639    6084       8   29731    7423 kernel/signal.o.orig
  22727    6084       8   28819    7093 kernel/signal.o

2 events are converted:

  signal_queue_overflow: signal_overflow_fail, signal_lose_info

No functional change.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.6.3

