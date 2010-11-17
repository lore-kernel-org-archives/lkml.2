Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab0KQA7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:59:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33454 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab0KQA7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:59:41 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Vu7YGgH2cqEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=dEC0tp_7AAAA:8 a=7OewIdkAlKxeLQdx660A:9 a=ptEvIu5V_b7I8X0kcuEA:7 a=OO11_UO4j3pwp2qVx0OlS_ILj_AA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101117005939.931158103@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Nov 2010 19:53:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 2/5] [PATCH 2/5] tracing/events: Add code to (un)register stable events
References: <20101117005357.024472450@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-events-Add-code-to-un-register-stable-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the framework to create and register stable events.
To create a stable event, add a file into:

  include/trace/stable/myfile.h

With the following format:

  STABLE_EVENT(myevent,

	EVENT_STRUCT(
		__field(type, item)
		__array(type, item, count)
	)
  )

This will create the function prototype:

 typedef void (*trace_proto_myevent)(type item, type *item);

And the functions:

 int register_stable_trace_myevent(trace_proto_myevent func, void *data);
 void unregister_stable_trace_myevent(trace_proto_myevent func, void *data);

This will allow developers to register a callback of a stable event.

The stable events must have a matching raw (in field debugging)
trace event. Although, only the names must match, the information
in the stable event is just a subset of the information that can
be extracted from the raw event.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/stable.h      |   72 +++++++++++++++++++++++++++++++++++++++
 include/trace/stable_list.h |    2 +
 kernel/Makefile             |    1 +
 kernel/events/Makefile      |    1 +
 kernel/events/event_reg.h   |   79 +++++++++++++++++++++++++++++++++++++++++++
 kernel/events/events.c      |   16 +++++++++
 kernel/trace/Kconfig        |    1 +
 7 files changed, 172 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/stable.h
 create mode 100644 include/trace/stable_list.h
 create mode 100644 kernel/events/Makefile
 create mode 100644 kernel/events/event_reg.h
 create mode 100644 kernel/events/events.c

diff --git a/include/trace/stable.h b/include/trace/stable.h
new file mode 100644
index 0000000..ee10f41
--- /dev/null
+++ b/include/trace/stable.h
@@ -0,0 +1,72 @@
+#ifndef _TRACE_STABLE_H
+#define _TRACE_STABLE_H
+/*
+ * stable.h - create structure and format for stable events
+ *
+ * Copyright (C) 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc
+ *
+ * This file creates the registering function prototypes
+ * to hook to the stable events and the function prototypes of those
+ * hooks.
+ *
+ * The stable events themselves reside in the directory:
+ *   include/trace/stable/
+ *
+ * Each of these files must be added to the header:
+ *   include/trace/stable_list.
+ *
+ * Code that registers and unregisters stable events only needs
+ * to include this file:
+ *   #include <trace/stable.h>
+ *
+ * and all the stable structures and registering functions will
+ * also be included for all stable events.
+ *
+ * The current elements that can be used by stable events are:
+ *
+ *    __field(type, item)
+ *    __array(type, time, size)
+ *
+ *  Example:
+ *   STABLE_EVENT(myevent,
+ * 	EVENT_STRUCT(
+ *      __field(	pid_t,		pid			)
+ *      __array(	char,		comm,	TASK_COMM_LEN	)
+ *	)
+ *   )
+ *
+ * The above would create the following:
+ *
+ *  typedef void (*trace_proto_myevent)(pid_t pid, char comm[TASK_COMM_LEN]);
+ *  int register_stable_trace_myevent(trace_proto_myevent func, void *data);
+ *  void unregister_stable_trace_myevent(trace_proto_myevent func, void *data);
+ *
+ * These functions will be created in kernel/events/events.c
+ */
+
+#define STABLE_HEADER_MULTI_READ
+
+#undef __SEP__
+#define __SEP__ ,
+
+#undef __field
+#define __field(type, item)				type item
+
+#undef __array
+#define __array(type, item, size)			type *item
+
+#undef EVENT_STRUCT
+#define EVENT_STRUCT(s)	s
+
+#undef STABLE_EVENT
+#define STABLE_EVENT(name, estruct)					\
+	typedef void (*trace_proto_##name)(void *data, estruct);	\
+	int register_stable_trace_##name(trace_proto_##name func, void *data); \
+	void unregister_stable_trace_##name(trace_proto_##name func, void *data)
+
+/* New stable defines must be added here */
+#include <trace/stable_list.h>
+
+#undef STABLE_HEADER_MULTI_READ
+
+#endif /* _TRACE_STABLE_H */
diff --git a/include/trace/stable_list.h b/include/trace/stable_list.h
new file mode 100644
index 0000000..996932a
--- /dev/null
+++ b/include/trace/stable_list.h
@@ -0,0 +1,2 @@
+
+/* New stable defines must be added here */
diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..8c1cbbd 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-y += events/
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
new file mode 100644
index 0000000..86fd7c1
--- /dev/null
+++ b/kernel/events/Makefile
@@ -0,0 +1 @@
+obj-y += events.o
diff --git a/kernel/events/event_reg.h b/kernel/events/event_reg.h
new file mode 100644
index 0000000..dfe16df
--- /dev/null
+++ b/kernel/events/event_reg.h
@@ -0,0 +1,79 @@
+/*
+ * event_reg.h - code to register stable events
+ *
+ * Copyright (C) 2010 Steven Rostedt <srostedt@redhat.com> Red Hat Inc
+ *
+ * Create the registration functions for the stable events:
+ *
+ * int register_stable_trace_##name(func, data);
+ * void unregister_stable_stable_trace_##name(func, data);
+ *
+ * The func is of the format based off of the STABLE_EVENT() structure.
+ * For example:
+ *
+ *   STABLE_EVENT(myevent,
+ * 	EVENT_STRUCT(
+ *      __field(	pid_t,		pid			)
+ *      __array(	char,		comm,	TASK_COMM_LEN	)
+ *	)
+ *   )
+ *
+ *  Will yield a function proto type of:
+ *
+ *  void func(pid_t pid, char *comm, void *data);
+ *
+ * When registering a call back to a stable event, what ever you
+ * pass into data, will be sent to your function in the data field.
+ *
+ * Once you register it, the function will start being called when
+ * the corresponding tracepoint is hit.
+ *
+ * To stop tracing, just unregister the function. Note, both
+ * registering and unregistering must be called from sleepable
+ * context, since those functions may sleep.
+ */
+
+#define STABLE_HEADER_MULTI_READ
+
+#undef __SEP__
+#define __SEP__
+
+#undef __field
+#define __field(type, item)
+
+#undef __array
+#define __array(type, item, size)
+
+#undef STABLE_EVENT
+#define STABLE_EVENT(name, estruct)					\
+static int name##_ref_count;						\
+int register_stable_trace_##name(trace_proto_##name func, void *__data)	\
+{									\
+	int ret;							\
+									\
+	mutex_lock(&stable_event_mutex);				\
+	ret = register_trace_stable_##name(func, __data);		\
+	if (!ret)							\
+		goto out;						\
+									\
+	if (name##_ref_count++ == 0)					\
+		ret = register_trace_##name(hook_##name, NULL);		\
+									\
+ out:									\
+	mutex_unlock(&stable_event_mutex);				\
+	return ret;							\
+}									\
+EXPORT_SYMBOL(register_stable_trace_##name);				\
+									\
+void unregister_stable_trace_##name(trace_proto_##name func, void *__data) \
+{									\
+	mutex_lock(&stable_event_mutex);				\
+	if (--name##_ref_count == 0)					\
+		unregister_trace_##name(hook_##name, NULL);		\
+									\
+	unregister_trace_stable_##name(func, __data);			\
+	mutex_unlock(&stable_event_mutex);				\
+}									\
+EXPORT_SYMBOL(unregister_stable_trace_##name)
+
+#include <trace/stable_list.h>
diff --git a/kernel/events/events.c b/kernel/events/events.c
new file mode 100644
index 0000000..6868bf1
--- /dev/null
+++ b/kernel/events/events.c
@@ -0,0 +1,16 @@
+/*
+ * events.c - code to register stable events
+ *
+ * Copyright (C) 2010 Steven Rostedt <srostedt@redhat.com> Red Hat Inc
+ *
+ * This file holds the hooks that are required to convert
+ * a raw tracepoing into a stable one. The conversion names
+ * must be named: hook_##tracepoint_name.
+ */
+#include <linux/tracepoint.h>
+#include <linux/module.h>
+#include <trace/stable.h>
+
+static struct mutex stable_event_mutex;
+
+#include "event_reg.h"
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e04b8bc..0533182 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -94,6 +94,7 @@ config TRACING
 	select NOP_TRACER
 	select BINARY_PRINTF
 	select EVENT_TRACING
+	select EVENT_FS
 
 config GENERIC_TRACER
 	bool
-- 
1.7.1


