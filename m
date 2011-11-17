Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1KQPVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:21:18 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:58266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab1KQPVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:21:17 -0500
Subject: [PATCH v2] printk: add console output tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20111117150040.GB18437@somewhere> (sfid-20111117_160121_163516_FCBDB77B)
References: <20111116151037.GA26166@infradead.org>
	 <1321456652.4502.12.camel@jlt3.sipsolutions.net>
	 <1321461693.4181.26.camel@frodo>
	 <1321461902.4502.14.camel@jlt3.sipsolutions.net>
	 <1321462856.4181.28.camel@frodo>
	 <1321468380.4502.16.camel@jlt3.sipsolutions.net>
	 <1321473443.4181.38.camel@frodo>
	 <1321478719.4502.20.camel@jlt3.sipsolutions.net>
	 <20111117145502.GA18437@somewhere>
	 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
	 <20111117150040.GB18437@somewhere> (sfid-20111117_160121_163516_FCBDB77B)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 16:21:08 +0100
Message-ID: <1321543268.3997.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add a printk.console trace point to record any printk
messages into the trace, regardless of the current
console loglevel. This can help correlate (existing)
printk debugging with other tracing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: remove extra file

 include/trace/events/printk.h |   44 ++++++++++++++++++++++++++++++++++++++++++
 kernel/printk.c               |    5 ++++
 2 files changed, 49 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/include/trace/events/printk.h	2011-11-16 23:18:35.000000000 +0100
@@ -0,0 +1,44 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM printk
+
+#if !defined(_TRACE_PRINTK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PRINTK_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT_CONDITION(console,
+	TP_PROTO(const char *log_buf, unsigned start, unsigned end,
+		 unsigned log_buf_len),
+
+	TP_ARGS(log_buf, start, end, log_buf_len),
+
+	TP_CONDITION(start != end),
+
+	TP_STRUCT__entry(
+		__dynamic_array(char, msg,
+				((end - start + log_buf_len) &
+				 (log_buf_len - 1)) + 1)
+	),
+
+	TP_fast_assign(
+		if ((start & (log_buf_len - 1)) > (end & (log_buf_len - 1))) {
+			memcpy(__get_dynamic_array(msg),
+			       log_buf + (start & (log_buf_len - 1)),
+			       log_buf_len - (start & (log_buf_len - 1)));
+			memcpy((char *)__get_dynamic_array(msg) +
+			       log_buf_len - (start & (log_buf_len - 1)),
+			       log_buf, end & (log_buf_len - 1));
+		} else
+			memcpy(__get_dynamic_array(msg),
+			       log_buf + (start & (log_buf_len - 1)),
+			       (end - start + log_buf_len) & (log_buf_len - 1));
+		((char *)__get_dynamic_array(msg))[(end - start + log_buf_len) &
+						   (log_buf_len - 1)] = 0;
+	),
+
+	TP_printk("%s", __get_str(msg))
+);
+#endif /* _TRACE_PRINTK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/kernel/printk.c	2011-11-16 22:25:43.000000000 +0100
+++ b/kernel/printk.c	2011-11-17 16:19:19.000000000 +0100
@@ -44,6 +44,9 @@
 
 #include <asm/uaccess.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/printk.h>
+
 /*
  * Architectures can override it:
  */
@@ -542,6 +545,8 @@ MODULE_PARM_DESC(ignore_loglevel, "ignor
 static void _call_console_drivers(unsigned start,
 				unsigned end, int msg_log_level)
 {
+	trace_console(&LOG_BUF(0), start, end, log_buf_len);
+
 	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
 			console_drivers && start != end) {
 		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {


