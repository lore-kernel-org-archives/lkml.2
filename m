Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1AZJTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:19:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49387 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab1AZJTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:19:37 -0500
Message-ID: <4D3FE72B.2010701@cn.fujitsu.com>
Date: Wed, 26 Jan 2011 17:19:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>
CC: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] power_trace: move power_trace to kernel/power/
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-26 17:18:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-26 17:18:58,
	Serialize complete at 2011-01-26 17:18:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think kernel/trace/ is the place for the tracing implementation files,
it is not a good place for tracepoint creation. Any subsystem should
creates tracepoints at its owner location, see also all other CREATE_TRACE_POINTS.
For example: net-traces.c is in the net/core/ directory.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/Makefile b/kernel/Makefile
index 353d3fe..25c3767 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_PM) += power/
 obj-$(CONFIG_FREEZER) += power/
+obj-$(CONFIG_TRACEPOINTS) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
@@ -100,7 +101,6 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
-obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index c350e18..b5a74f5 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
 				   block_io.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
+obj-$(CONFIG_TRACEPOINTS)	+= power-traces.o
diff --git a/kernel/power/power-traces.c b/kernel/power/power-traces.c
new file mode 100644
index 0000000..f55fcf6
--- /dev/null
+++ b/kernel/power/power-traces.c
@@ -0,0 +1,20 @@
+/*
+ * Power trace points
+ *
+ * Copyright (C) 2009 Arjan van de Ven <arjan@linux.intel.com>
+ */
+
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/power.h>
+
+#ifdef EVENT_POWER_TRACING_DEPRECATED
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
+#endif
+EXPORT_TRACEPOINT_SYMBOL_GPL(cpu_idle);
+
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 761c510..8ad9849 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -52,7 +52,6 @@ obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
-obj-$(CONFIG_TRACEPOINTS) += power-traces.o
 ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
deleted file mode 100644
index f55fcf6..0000000
--- a/kernel/trace/power-traces.c
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Power trace points
- *
- * Copyright (C) 2009 Arjan van de Ven <arjan@linux.intel.com>
- */
-
-#include <linux/string.h>
-#include <linux/types.h>
-#include <linux/workqueue.h>
-#include <linux/sched.h>
-#include <linux/module.h>
-
-#define CREATE_TRACE_POINTS
-#include <trace/events/power.h>
-
-#ifdef EVENT_POWER_TRACING_DEPRECATED
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
-#endif
-EXPORT_TRACEPOINT_SYMBOL_GPL(cpu_idle);
-
