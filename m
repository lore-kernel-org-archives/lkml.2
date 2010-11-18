Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0KRBcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:32:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0KRBcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=YbeVuN+h+ikXO5QvrHl+orNjObTPI/L1Yiyty8Z4T1T2uHxg/1vp8pT/Ecv8j8gG4U
         6jBIcgwSaikxQ0ir4CIEpKusShjInI+GZkQlCcv/ZTiLbG3EVEPcJpPn3IKc0LT1cqRk
         TJDik9bbdGapaeiPG7igAPjoNKSj1Pce2qwzY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/5] tracing: New macro to set up initial event flags value
Date: Thu, 18 Nov 2010 02:32:40 +0100
Message-Id: <1290043963-1480-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
References: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces the new TRACE_EVENT_FLAGS() macro in order
to set up initial event flags value.

This macro must simply follow the definition of a trace event
and take the event name and the flag value as parameters:

TRACE_EVENT(my_event, .....
....
);

TRACE_EVENT_FLAGS(my_event, 1)

This will set up 1 as the initial my_event->flags value.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/tracepoint.h |    4 ++++
 include/trace/ftrace.h     |   12 ++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index a4a90b6..5a6074f 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -234,6 +234,8 @@ do_trace:								\
 				PARAMS(void *__data, proto),		\
 				PARAMS(__data, args))
 
+#define TRACE_EVENT_FLAGS(event, flag)
+
 #endif /* DECLARE_TRACE */
 
 #ifndef TRACE_EVENT
@@ -354,4 +356,6 @@ do_trace:								\
 		assign, print, reg, unreg)			\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
+#define TRACE_EVENT_FLAGS(event, flag)
+
 #endif /* ifdef TRACE_EVENT (see note above) */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a9377c0..6f54012 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -82,6 +82,15 @@
 	TRACE_EVENT(name, PARAMS(proto), PARAMS(args),			\
 		PARAMS(tstruct), PARAMS(assign), PARAMS(print))		\
 
+#undef TRACE_EVENT_FLAGS
+#define TRACE_EVENT_FLAGS(name, value)					\
+	static int __init trace_init_flags_##name(void)			\
+	{								\
+		event_##name.flags = value;				\
+		return 0;						\
+	}								\
+	early_initcall(trace_init_flags_##name);
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 
@@ -129,6 +138,9 @@
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
 
+#undef TRACE_EVENT_FLAGS
+#define TRACE_EVENT_FLAGS(event, flag)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
-- 
1.6.2.3

