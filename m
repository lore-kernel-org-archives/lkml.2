Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674Ab2ILCl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:41:56 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:55469 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab2ILClw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:41:52 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 1/3] tracing,x86: add a TSC trace_clock; reset buffer on clock change
Date: Tue, 11 Sep 2012 19:41:09 -0700
Message-Id: <1347417671-22998-2-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1347417671-22998-1-git-send-email-dhsharp@google.com>
References: <1347417671-22998-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to promote interoperability between userspace tracers and ftrace,
add a trace_clock that reports raw TSC values which will then be recorded
in the ring buffer. Userspace tracers that also record TSCs are then on
exactly the same time base as the kernel and events can be unambiguously
interlaced.

Tested: Enabled a tracepoint and the "tsc" trace_clock and saw very large
timestamp values.

Google-Bug-Id: 6980623
Signed-off-by: David Sharp <dhsharp@google.com>
---
 include/linux/trace_clock.h |    3 +++
 kernel/trace/trace.c        |    3 +++
 kernel/trace/trace_clock.c  |   16 ++++++++++++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 4eb4902..b86c7363 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -16,5 +16,8 @@ extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
 extern u64 notrace trace_clock_counter(void);
+#ifdef CONFIG_X86_TSC
+extern u64 notrace trace_clock_tsc(void);
+#endif
 
 #endif /* _LINUX_TRACE_CLOCK_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c38c81..dc1f1fa 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -480,6 +480,9 @@ static struct {
 	{ trace_clock_local,	"local" },
 	{ trace_clock_global,	"global" },
 	{ trace_clock_counter,	"counter" },
+#ifdef CONFIG_X86_TSC
+	{ trace_clock_tsc,	"tsc" },
+#endif
 };
 
 int trace_clock_id;
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 3947835..1770737 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -125,3 +125,19 @@ u64 notrace trace_clock_counter(void)
 {
 	return atomic64_add_return(1, &trace_counter);
 }
+
+#ifdef CONFIG_X86_TSC
+/*
+ * trace_clock_tsc(): A clock that is just the cycle counter.
+ *
+ * Unlike the other clocks, this is not in nanoseconds.
+ */
+u64 notrace trace_clock_tsc(void)
+{
+	u64 ret;
+	rdtsc_barrier();
+	rdtscll(ret);
+
+	return ret;
+}
+#endif
-- 
1.7.7.3

