Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab2FORLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:11:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55158 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2FORKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:10:50 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 4/6] tracing/function: Introduce persistent trace option
Date: Fri, 15 Jun 2012 10:08:29 -0700
Message-Id: <1339780111-12075-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120615170659.GA4060@lizard>
References: <20120615170659.GA4060@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces 'func_ptrace' option, now available in
/sys/kernel/debug/tracing/options when function tracer
is selected.

The patch also adds some tiny code that calls back to pstore
to record the trace. The callback is no-op when PSTORE=n.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 kernel/trace/trace_functions.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index c7b0c6a..269627c 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -13,6 +13,7 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
+#include <linux/pstore.h>
 #include <linux/fs.h>
 
 #include "trace.h"
@@ -74,6 +75,14 @@ function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 	preempt_enable_notrace();
 }
 
+/* Our two options */
+enum {
+	TRACE_FUNC_OPT_STACK	= 0x1,
+	TRACE_FUNC_OPT_PSTORE	= 0x2,
+};
+
+static struct tracer_flags func_flags;
+
 static void
 function_trace_call(unsigned long ip, unsigned long parent_ip)
 {
@@ -97,6 +106,12 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1)) {
+		/*
+		 * So far tracing doesn't support multiple buffers, so
+		 * we make an explicit call for now.
+		 */
+		if (unlikely(func_flags.val & TRACE_FUNC_OPT_PSTORE))
+			pstore_ftrace_call(ip, parent_ip);
 		pc = preempt_count();
 		trace_function(tr, ip, parent_ip, flags, pc);
 	}
@@ -158,15 +173,13 @@ static struct ftrace_ops trace_stack_ops __read_mostly =
 	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 
-/* Our two options */
-enum {
-	TRACE_FUNC_OPT_STACK = 0x1,
-};
-
 static struct tracer_opt func_opts[] = {
 #ifdef CONFIG_STACKTRACE
 	{ TRACER_OPT(func_stack_trace, TRACE_FUNC_OPT_STACK) },
 #endif
+#ifdef CONFIG_PSTORE_FTRACE
+	{ TRACER_OPT(func_pstore, TRACE_FUNC_OPT_PSTORE) },
+#endif
 	{ } /* Always set a last empty entry */
 };
 
@@ -219,6 +232,8 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
 
 		return 0;
 	}
+	if (bit == TRACE_FUNC_OPT_PSTORE)
+		return 0;
 
 	return -EINVAL;
 }
-- 
1.7.10.4

