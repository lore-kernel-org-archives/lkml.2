Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0CWAdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:33:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:45249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab0CWAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:14 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 01/18] trace: Allow <linux/tracepoint.h> to create empty tracepoints
Date: Tue, 23 Mar 2010 01:32:03 +0100
Message-Id: <1269304340-25372-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a particular tracer is disabled, there is no need to generate any tracepoint
code for it. Actually, the inline checks whether tracepoints of the tracer are
active have non-negligible impact on a code size [1] and thus can in theory
lead to slowdown. This is undesirable when e.g. BLK_DEV_IO_TRACE should be
enabled in the production kernel but KMEMTRACE is disabled.

So introduce a macro trickery in <linux/tracepoint.h> so that each tracer can
define TRACE_CONFIG to CONFIG_MY_TRACER before including linux/tracepoint.h in
it's events file and that will result in tracepoints becoming empty if
CONFIG_MY_TRACER is not defined.

[1] As an example: bloat-o-meter mm/slub.o.untraced mm/slub.o.traced
add/remove: 61/1 grow/shrink: 24/10 up/down: 6366/-737 (5629)
function                                     old     new   delta
deactivate_slab                                -     592    +592
show_stat                                      -     380    +380
trace_kmalloc_node                             -     265    +265
trace_kmalloc                                  -     255    +255
kmem_cache_alloc_node                        590     825    +235
kmem_cache_alloc                             542     768    +226
kfree                                        566     763    +197
kmem_cache_free                              478     671    +193
...

CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/tracepoint.h |   96 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 78 insertions(+), 18 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index f59604e..1ad17cc 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -37,8 +37,7 @@ struct tracepoint {
 
 #define TP_PROTO(args...)	args
 #define TP_ARGS(args...)	args
-
-#ifdef CONFIG_TRACEPOINTS
+#define PARAMS(args...)		args
 
 /*
  * it_func[0] is never NULL because there is at least one element in the array
@@ -63,7 +62,7 @@ struct tracepoint {
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define DECLARE_TRACE(name, proto, args)				\
+#define DECLARE_TRACE_1(name, proto, args)				\
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
@@ -81,26 +80,22 @@ struct tracepoint {
 	}
 
 
-#define DEFINE_TRACE_FN(name, reg, unreg)				\
+#define DEFINE_TRACE_FN_1(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
 	__attribute__((section("__tracepoints"), aligned(32))) =	\
 		{ __tpstrtab_##name, 0, reg, unreg, NULL }
 
-#define DEFINE_TRACE(name)						\
+#define DEFINE_TRACE_1(name)						\
 	DEFINE_TRACE_FN(name, NULL, NULL);
 
-#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)				\
+#define EXPORT_TRACEPOINT_SYMBOL_GPL_1(name)				\
 	EXPORT_SYMBOL_GPL(__tracepoint_##name)
-#define EXPORT_TRACEPOINT_SYMBOL(name)					\
+#define EXPORT_TRACEPOINT_SYMBOL_1(name)				\
 	EXPORT_SYMBOL(__tracepoint_##name)
 
-extern void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end);
-
-#else /* !CONFIG_TRACEPOINTS */
-#define DECLARE_TRACE(name, proto, args)				\
+#define DECLARE_TRACE_0(name, proto, args)				\
 	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
 	{ }								\
 	static inline void trace_##name(proto)				\
@@ -114,10 +109,51 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 		return -ENOSYS;						\
 	}
 
-#define DEFINE_TRACE_FN(name, reg, unreg)
-#define DEFINE_TRACE(name)
-#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
-#define EXPORT_TRACEPOINT_SYMBOL(name)
+#define DEFINE_TRACE_FN_0(name, reg, unreg)
+#define DEFINE_TRACE_0(name)
+#define EXPORT_TRACEPOINT_SYMBOL_GPL_0(name)
+#define EXPORT_TRACEPOINT_SYMBOL_0(name)
+
+/*
+ * Below two-level macro magic is really needed to propely expand TRACE_CONFIG
+ * macro to 0 or 1 in the end
+ */
+#define __DECLARE_TRACE(config, name, proto, args) \
+		DECLARE_TRACE_##config(name, PARAMS(proto), PARAMS(args))
+#define __DEFINE_TRACE_FN(config, name, reg, unreg) \
+			DEFINE_TRACE_FN_##config(name, reg, unreg)
+#define __DEFINE_TRACE(config, name) DEFINE_TRACE_##config(name)
+#define __EXPORT_TRACEPOINT_SYMBOL_GPL(config, name) \
+			EXPORT_TRACEPOINT_SYMBOL_GPL_##config(name)
+#define __EXPORT_TRACEPOINT_SYMBOL(config, name) \
+			EXPORT_TRACEPOINT_SYMBOL_##config(name)
+
+#define _DECLARE_TRACE(config, name, proto, args) \
+		__DECLARE_TRACE(config, name, PARAMS(proto), PARAMS(args))
+#define _DEFINE_TRACE_FN(config, name, reg, unreg) \
+			__DEFINE_TRACE_FN(config, name, reg, unreg)
+#define _DEFINE_TRACE(config, name) __DEFINE_TRACE(config, name)
+#define _EXPORT_TRACEPOINT_SYMBOL_GPL(config, name) \
+			__EXPORT_TRACEPOINT_SYMBOL_GPL(config, name)
+#define _EXPORT_TRACEPOINT_SYMBOL(config, name) \
+			__EXPORT_TRACEPOINT_SYMBOL(config, name)
+
+#define DECLARE_TRACE(name, proto, args) \
+		_DECLARE_TRACE(TRACE_CONFIG, name, PARAMS(proto), PARAMS(args))
+#define DEFINE_TRACE_FN(name, reg, unreg) \
+			_DEFINE_TRACE_FN(TRACE_CONFIG, name, reg, unreg)
+#define DEFINE_TRACE(name) _DEFINE_TRACE(TRACE_CONFIG, name)
+#define EXPORT_TRACEPOINT_SYMBOL_GPL(name) \
+			_EXPORT_TRACEPOINT_SYMBOL_GPL(TRACE_CONFIG, name)
+#define EXPORT_TRACEPOINT_SYMBOL(name) \
+			_EXPORT_TRACEPOINT_SYMBOL(TRACE_CONFIG, name)
+
+#ifdef CONFIG_TRACEPOINTS
+
+extern void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end);
+
+#else /* ! CONFIG_TRACEPOINTS */
 
 static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end)
@@ -163,11 +199,35 @@ static inline void tracepoint_synchronize_unregister(void)
 	synchronize_sched();
 }
 
-#define PARAMS(args...) args
-
 #endif /* _LINUX_TRACEPOINT_H */
 
 /*
+ * The two chunks below are out of include file ifdef protection because
+ * we want to be able to define TRACE_CONFIG even before second or even
+ * later include of linux/tracepoint.h.
+ */
+/*
+ * Make tracepoints which are not converted to a new method of enabling
+ * always compiled in
+ */
+#ifndef TRACE_CONFIG
+#define TRACE_CONFIG 1
+#endif
+
+/*
+ * If TRACE_CONFIG is defined but a config option it is defined to isn't, make
+ * the result 0. It would require much less magic if the kernel was not
+ * compiled with -Wundef.
+ */
+#define CONFIG_TEST_1
+#define _CONFIG_UNDEF(x) !defined(CONFIG_TEST_##x)
+#define CONFIG_UNDEF(x) _CONFIG_UNDEF(x)
+#if CONFIG_UNDEF(TRACE_CONFIG)
+#undef TRACE_CONFIG
+#define TRACE_CONFIG 0
+#endif
+
+/*
  * Note: we keep the TRACE_EVENT outside the include file ifdef protection.
  *  This is due to the way trace events work. If a file includes two
  *  trace event headers under one "CREATE_TRACE_POINTS" the first include
-- 
1.6.4.2

