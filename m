Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab2BQNxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:53:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40178 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2BQNxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:53:00 -0500
Date: Fri, 17 Feb 2012 05:52:02 -0800
From: tip-bot for Johannes Berg <johannes.berg@intel.com>
Message-ID: <tip-95100358491abaa2e9a5483811370059bbca4645@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, hch@infradead.org, fweisbec@gmail.com,
        rostedt@goodmis.org, johannes.berg@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        johannes.berg@intel.com, tglx@linutronix.de, hch@infradead.org
In-Reply-To: <1322161388.5366.54.camel@jlt3.sipsolutions.net>
References: <1322161388.5366.54.camel@jlt3.sipsolutions.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] printk/tracing: Add console output tracing
Git-Commit-ID: 95100358491abaa2e9a5483811370059bbca4645
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 05:52:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95100358491abaa2e9a5483811370059bbca4645
Gitweb:     http://git.kernel.org/tip/95100358491abaa2e9a5483811370059bbca4645
Author:     Johannes Berg <johannes.berg@intel.com>
AuthorDate: Thu, 24 Nov 2011 20:03:08 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 13 Feb 2012 13:46:05 -0500

printk/tracing: Add console output tracing

Add a printk.console trace point to record any printk
messages into the trace, regardless of the current
console loglevel. This can help correlate (existing)
printk debugging with other tracing.

Link: http://lkml.kernel.org/r/1322161388.5366.54.camel@jlt3.sipsolutions.net

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/printk.h |   41 +++++++++++++++++++++++++++++++++++++++++
 kernel/printk.c               |    5 +++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/printk.h b/include/trace/events/printk.h
new file mode 100644
index 0000000..94ec79c
--- /dev/null
+++ b/include/trace/events/printk.h
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
diff --git a/kernel/printk.c b/kernel/printk.c
index 13c0a11..cb8a6bd 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -44,6 +44,9 @@
 
 #include <asm/uaccess.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/printk.h>
+
 /*
  * Architectures can override it:
  */
@@ -542,6 +545,8 @@ MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
 static void _call_console_drivers(unsigned start,
 				unsigned end, int msg_log_level)
 {
+	trace_console(&LOG_BUF(0), start, end, log_buf_len);
+
 	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
 			console_drivers && start != end) {
 		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
