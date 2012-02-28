Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2B1LCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:02:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49710 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468Ab2B1LCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:02:49 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
Date: Tue, 28 Feb 2012 11:02:46 +0000
Message-Id: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's -next fails to build for me:

  CC      kernel/trace/trace_export.o
In file included from kernel/trace/trace_export.c:197: kernel/trace/trace_entries.h:58: error: 'perf_ftrace_event_register' undeclared here (not in a function)
make[2]: *** [kernel/trace/trace_export.o] Error 1
make[1]: *** [kernel/trace] Error 2
make: *** [kernel] Error 2

because as of ced390 (ftrace, perf: Add support to use function
tracepoint in perf) perf_trace_event_register() is declared in trace.h
only if CONFIG_PERF_EVENTS is enabled but I don't have that set.

Ensure that we always have a definition of perf_trace_event_register()
by making the definition unconditional.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 kernel/trace/trace.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 54faec7..3dd357c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -835,13 +835,11 @@ extern const char *__stop___trace_bprintk_fmt[];
 		     filter)
 #include "trace_entries.h"
 
-#ifdef CONFIG_PERF_EVENTS
 #ifdef CONFIG_FUNCTION_TRACER
 int perf_ftrace_event_register(struct ftrace_event_call *call,
 			       enum trace_reg type, void *data);
 #else
 #define perf_ftrace_event_register NULL
 #endif /* CONFIG_FUNCTION_TRACER */
-#endif /* CONFIG_PERF_EVENTS */
 
 #endif /* _LINUX_KERNEL_TRACE_H */
-- 
1.7.9.1

