Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2JHGo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:44:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40084 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2JHGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:44:54 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 1/8] perf tools: add on_exit implementation
Date: Mon,  8 Oct 2012 09:43:26 +0300
Message-Id: <1349678613-7045-2-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>

on_exit() is only available in new versions of glibc.
It is not implemented in Bionic and will lead to linking errors when
compiling for Android.

Implement a wrapper for on_exit using atexit.

The implementation for on_exit is the one sent by Bernhard Rosenkraenzer in
https://lkml.org/lkml/2012/8/23/316. The configuration part from the Makefile
is different than the one from the original patch.

Signed-off-by: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Makefile                 |    6 ++++++
 tools/perf/builtin-record.c         |   32 ++++++++++++++++++++++++++++++++
 tools/perf/config/feature-tests.mak |   11 ++++++++++-
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f9126f8..0e468b5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -751,6 +751,12 @@ ifndef NO_STRLCPY
 	endif
 endif
 
+ifndef NO_ON_EXIT
+	ifeq ($(call try-cc,$(SOURCE_ON_EXIT),),y)
+		BASIC_CFLAGS += -DHAVE_ON_EXIT
+	endif
+endif
+
 ifndef NO_BACKTRACE
        ifeq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
                BASIC_CFLAGS += -DBACKTRACE_SUPPORT
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e9231659..73b5d7f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -31,6 +31,38 @@
 #include <sched.h>
 #include <sys/mman.h>
 
+#ifndef HAVE_ON_EXIT
+#ifndef ATEXIT_MAX
+#define ATEXIT_MAX 32
+#endif
+static int __on_exit_count = 0;
+typedef void (*on_exit_func_t) (int, void *);
+static on_exit_func_t __on_exit_funcs[ATEXIT_MAX];
+static void *__on_exit_args[ATEXIT_MAX];
+static int __exitcode = 0;
+static void __handle_on_exit_funcs(void);
+static int on_exit(on_exit_func_t function, void *arg);
+#define exit(x) (exit)(__exitcode = (x))
+
+static int on_exit(on_exit_func_t function, void *arg)
+{
+	if (__on_exit_count == ATEXIT_MAX)
+		return -ENOMEM;
+	else if (__on_exit_count == 0)
+		atexit(__handle_on_exit_funcs);
+	__on_exit_funcs[__on_exit_count] = function;
+	__on_exit_args[__on_exit_count++] = arg;
+	return 0;
+}
+
+static void __handle_on_exit_funcs(void)
+{
+	int i;
+	for (i = 0; i < __on_exit_count; i++)
+		__on_exit_funcs[i] (__exitcode, __on_exit_args[i]);
+}
+#endif
+
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 4add41b..eaeb0fd 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -203,4 +203,13 @@ int main(void)
 	return audit_open();
 }
 endef
-endif
\ No newline at end of file
+endif
+
+define SOURCE_ON_EXIT
+#include <stdio.h>
+
+int main(void)
+{
+	return on_exit(NULL, NULL);
+}
+endef
-- 
1.7.9.5

