Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658Ab2IHCKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:10:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201Ab2IHCH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/13] perf tools: add NO_BACKTRACE for application self-debugging
Date: Fri,  7 Sep 2012 23:07:11 -0300
Message-Id: <1347070032-4161-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

perf has support for self-debugging by defining dump_stack function.
This function uses backtrace and backtrace_symbols functions defined as
GNU extensions.

In Android, bionic does not offer support for these functions and
compilation will fail with the following error:

target  C: libperf <= tools/perf/util/util.c
tools/perf/util/util.c:4:22: fatal error: execinfo.h: No such file or directory
compilation terminated.

Add a compile-time option (NO_BACKTRACE) to enable or disable
self-debugging functionality in perf. This can also help in debugging
since it offers the possibility to turn on/off printing the backtrace.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-12-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |    8 ++++++++
 tools/perf/config/feature-tests.mak |   14 ++++++++++++++
 tools/perf/util/util.c              |    6 ++++++
 3 files changed, 28 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index afd5075..3eda492 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -755,6 +755,14 @@ else
 	endif
 endif
 
+ifdef NO_BACKTRACE
+       BASIC_CFLAGS += -DNO_BACKTRACE
+else
+       ifneq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
+               BASIC_CFLAGS += -DNO_BACKTRACE
+       endif
+endif
+
 ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 2f1156a..116690a 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -179,3 +179,17 @@ int main(void)
 }
 endef
 endif
+
+ifndef NO_BACKTRACE
+define SOURCE_BACKTRACE
+#include <execinfo.h>
+#include <stdio.h>
+
+int main(void)
+{
+	backtrace(NULL, 0);
+	backtrace_symbols(NULL, 0);
+	return 0;
+}
+endef
+endif
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 1b8775c..2055cf3 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,7 +1,9 @@
 #include "../perf.h"
 #include "util.h"
 #include <sys/mman.h>
+#ifndef NO_BACKTRACE
 #include <execinfo.h>
+#endif
 #include <stdio.h>
 #include <stdlib.h>
 
@@ -163,6 +165,7 @@ size_t hex_width(u64 v)
 }
 
 /* Obtain a backtrace and print it to stdout. */
+#ifndef NO_BACKTRACE
 void dump_stack(void)
 {
 	void *array[16];
@@ -177,3 +180,6 @@ void dump_stack(void)
 
 	free(strings);
 }
+#else
+void dump_stack(void) {}
+#endif
-- 
1.7.9.2.358.g22243

