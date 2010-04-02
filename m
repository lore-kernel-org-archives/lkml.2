Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0DBTER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:04:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:47547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab0DBTEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:04:11 -0400
Date: Fri, 2 Apr 2010 19:03:48 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de,
       mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com
In-Reply-To: <4BA97FBD.8070703@cn.fujitsu.com>
References: <4BA97FBD.8070703@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Convert some signal events to DEFINE_TRACE
Message-ID: <tip-4bdde044dc36ac7b01f7502394d52619af9d1927@git.kernel.org>
Git-Commit-ID: 4bdde044dc36ac7b01f7502394d52619af9d1927
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:03:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bdde044dc36ac7b01f7502394d52619af9d1927
Gitweb:     http://git.kernel.org/tip/4bdde044dc36ac7b01f7502394d52619af9d1927
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Mar 2010 10:58:05 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 31 Mar 2010 22:56:54 -0400

tracing: Convert some signal events to DEFINE_TRACE

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
