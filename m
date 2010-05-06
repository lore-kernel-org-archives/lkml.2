Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0EFXGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:06:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0EFXF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:05:58 -0400
X-Authority-Analysis: v=1.1 cv=Ebn0m7KaSvUJV60GCOzUqyhjUj7QmnsyUUVbVvk8w6o= c=1 sm=0 a=YUiYvfPCjrAA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=vmLDa1wCAAAA:8 a=J1Y8HTJGAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=9uL6OlwD6QnThlPYUMkA:9 a=394TysUmq8floOqUz7YA:7 a=-JGZm_9t0wZMYSYQAt1jOlxmoyQA:4 a=jEp0ucaQiEUA:10 a=gv_BBZfBKR8A:10 a=4N9Db7Z2_RYA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100506230555.381153062@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 06 May 2010 19:05:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 2/3] tracing: Fix tracepoint.h DECLARE_TRACE() to allow more than one header
References: <20100506230459.278936703@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-tracepoint.h-DECLARE_TRACE-to-allow-more.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When more than one header is included under CREATE_TRACE_POINTS
the DECLARE_TRACE() macro is not defined back to its original meaning
and the second include will fail to initialize the TRACE_EVENT()
and DECLARE_TRACE() correctly.

To fix this the tracepoint.h file moves the define of DECLARE_TRACE()
out of the #ifdef _LINUX_TRACEPOINT_H protection (just like the
define of the TRACE_EVENT()). This way the define_trace.h will undef
the DECLARE_TRACE() at the end and allow new headers to start
from scratch.

This patch also requires fixing the include/events/napi.h

It currently uses DECLARE_TRACE() and should be converted to a TRACE_EVENT()
format. But I'll leave that change to the authors of that file.
But since the napi.h file depends on using the CREATE_TRACE_POINTS
and does not define its own DEFINE_TRACE() it must use the define_trace.h
method instead.

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h   |  114 ++++++++++++++++++++++--------------------
 include/trace/define_trace.h |    5 ++
 include/trace/events/napi.h  |   10 +++-
 3 files changed, 72 insertions(+), 57 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 78b4bd3..1d85f9a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -33,6 +33,65 @@ struct tracepoint {
 					 * Keep in sync with vmlinux.lds.h.
 					 */
 
+/*
+ * Connect a probe to a tracepoint.
+ * Internal API, should not be used directly.
+ */
+extern int tracepoint_probe_register(const char *name, void *probe);
+
+/*
+ * Disconnect a probe from a tracepoint.
+ * Internal API, should not be used directly.
+ */
+extern int tracepoint_probe_unregister(const char *name, void *probe);
+
+extern int tracepoint_probe_register_noupdate(const char *name, void *probe);
+extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe);
+extern void tracepoint_probe_update_all(void);
+
+struct tracepoint_iter {
+	struct module *module;
+	struct tracepoint *tracepoint;
+};
+
+extern void tracepoint_iter_start(struct tracepoint_iter *iter);
+extern void tracepoint_iter_next(struct tracepoint_iter *iter);
+extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
+extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
+extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
+	struct tracepoint *begin, struct tracepoint *end);
+
+/*
+ * tracepoint_synchronize_unregister must be called between the last tracepoint
+ * probe unregistration and the end of module exit to make sure there is no
+ * caller executing a probe when it is freed.
+ */
+static inline void tracepoint_synchronize_unregister(void)
+{
+	synchronize_sched();
+}
+
+#define PARAMS(args...) args
+
+#ifdef CONFIG_TRACEPOINTS
+extern void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end);
+#else
+static inline void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end)
+{ }
+#endif /* CONFIG_TRACEPOINTS */
+
+#endif /* _LINUX_TRACEPOINT_H */
+
+/*
+ * Note: we keep the TRACE_EVENT and DECLARE_TRACE outside the include
+ *  file ifdef protection.
+ *  This is due to the way trace events work. If a file includes two
+ *  trace event headers under one "CREATE_TRACE_POINTS" the first include
+ *  will override the TRACE_EVENT and break the second include.
+ */
+
 #ifndef DECLARE_TRACE
 
 #define TP_PROTO(args...)	args
@@ -96,9 +155,6 @@ struct tracepoint {
 #define EXPORT_TRACEPOINT_SYMBOL(name)					\
 	EXPORT_SYMBOL(__tracepoint_##name)
 
-extern void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end);
-
 #else /* !CONFIG_TRACEPOINTS */
 #define DECLARE_TRACE(name, proto, args)				\
 	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
@@ -119,61 +175,9 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
 
-static inline void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end)
-{ }
 #endif /* CONFIG_TRACEPOINTS */
 #endif /* DECLARE_TRACE */
 
-/*
- * Connect a probe to a tracepoint.
- * Internal API, should not be used directly.
- */
-extern int tracepoint_probe_register(const char *name, void *probe);
-
-/*
- * Disconnect a probe from a tracepoint.
- * Internal API, should not be used directly.
- */
-extern int tracepoint_probe_unregister(const char *name, void *probe);
-
-extern int tracepoint_probe_register_noupdate(const char *name, void *probe);
-extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe);
-extern void tracepoint_probe_update_all(void);
-
-struct tracepoint_iter {
-	struct module *module;
-	struct tracepoint *tracepoint;
-};
-
-extern void tracepoint_iter_start(struct tracepoint_iter *iter);
-extern void tracepoint_iter_next(struct tracepoint_iter *iter);
-extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
-extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
-	struct tracepoint *begin, struct tracepoint *end);
-
-/*
- * tracepoint_synchronize_unregister must be called between the last tracepoint
- * probe unregistration and the end of module exit to make sure there is no
- * caller executing a probe when it is freed.
- */
-static inline void tracepoint_synchronize_unregister(void)
-{
-	synchronize_sched();
-}
-
-#define PARAMS(args...) args
-
-#endif /* _LINUX_TRACEPOINT_H */
-
-/*
- * Note: we keep the TRACE_EVENT outside the include file ifdef protection.
- *  This is due to the way trace events work. If a file includes two
- *  trace event headers under one "CREATE_TRACE_POINTS" the first include
- *  will override the TRACE_EVENT and break the second include.
- */
-
 #ifndef TRACE_EVENT
 /*
  * For use with the TRACE_EVENT macro:
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 5acfb1e..1dfab54 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -65,6 +65,10 @@
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+/* Make all open coded DECLARE_TRACE nops */
+#undef DECLARE_TRACE
+#define DECLARE_TRACE(name, proto, args)
+
 #ifdef CONFIG_EVENT_TRACING
 #include <trace/ftrace.h>
 #endif
@@ -75,6 +79,7 @@
 #undef DEFINE_EVENT
 #undef DEFINE_EVENT_PRINT
 #undef TRACE_HEADER_MULTI_READ
+#undef DECLARE_TRACE
 
 /* Only undef what we defined in this file */
 #ifdef UNDEF_TRACE_INCLUDE_FILE
diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index a8989c4..188deca 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -1,4 +1,7 @@
-#ifndef _TRACE_NAPI_H_
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM napi
+
+#if !defined(_TRACE_NAPI_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_NAPI_H_
 
 #include <linux/netdevice.h>
@@ -8,4 +11,7 @@ DECLARE_TRACE(napi_poll,
 	TP_PROTO(struct napi_struct *napi),
 	TP_ARGS(napi));
 
-#endif
+#endif /* _TRACE_NAPI_H_ */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.0


