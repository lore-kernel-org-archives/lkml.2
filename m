Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1KXTDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:03:14 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:37994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1KXTDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:03:12 -0500
Subject: [PATCH v3] printk: add console output tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20111124154519.GB18579@somewhere.redhat.com> (sfid-20111124_164601_383201_AB72557F)
References: <20111117145502.GA18437@somewhere>
	 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
	 <20111117150040.GB18437@somewhere>
	 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
	 <20111118184401.GA24787@somewhere.redhat.com>
	 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
	 <20111118185449.GB24787@somewhere.redhat.com>
	 <1321642752.10266.75.camel@jlt3.sipsolutions.net>
	 <20111123131622.GA10669@somewhere.redhat.com>
	 <1322140919.5366.17.camel@jlt3.sipsolutions.net>
	 <20111124154519.GB18579@somewhere.redhat.com>
	 (sfid-20111124_164601_383201_AB72557F)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 20:03:08 +0100
Message-ID: <1322161388.5366.54.camel@jlt3.sipsolutions.net>
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
v3: simplify length of __dynamic_array, thanks Frederic

 include/trace/events/printk.h |   41 +++++++++++++++++++++++++++++++++++++++++
 kernel/printk.c               |    5 +++++
 2 files changed, 46 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/include/trace/events/printk.h	2011-11-24 20:02:21.000000000 +0100
@@ -0,0 +1,41 @@
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
+		__dynamic_array(char, msg, end - start + 1)
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
+			       end - start);
+		((char *)__get_dynamic_array(msg))[end - start] = 0;
+	),
+
+	TP_printk("%s", __get_str(msg))
+);
+#endif /* _TRACE_PRINTK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/kernel/printk.c	2011-11-24 09:38:53.000000000 +0100
+++ b/kernel/printk.c	2011-11-24 09:42:37.000000000 +0100
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


