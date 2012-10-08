Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab2JHWeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:34:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:41447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab2JHWdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>,
        Irina Tirdea <irina.tirdea@intel.com>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/25] perf tools: Add on_exit implementation
Date: Mon,  8 Oct 2012 19:32:48 -0300
Message-Id: <1349735570-19339-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
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
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1349678613-7045-2-git-send-email-irina.tirdea@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |    6 ++++++
 tools/perf/builtin-record.c         |   32 ++++++++++++++++++++++++++++++++
 tools/perf/config/feature-tests.mak |   11 ++++++++++-
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d80a333..a7d8745 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -753,6 +753,12 @@ ifndef NO_STRLCPY
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
1.7.9.2.358.g22243

