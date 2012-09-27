Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2I0VSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:18:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:49013 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2I0VSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:18:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf tools: Check libaudit availability for perf-trace builtin
Date: Thu, 27 Sep 2012 18:18:04 -0300
Message-Id: <1348780686-16108-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348780686-16108-1-git-send-email-acme@infradead.org>
References: <1348780686-16108-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The newly added trace command requires an external audit library.

However it can cause a build error because it's not checked whether the
libaudit is installed on system:

    CC builtin-trace.o
  builtin-trace.c:7:22: fatal error: libaudit.h: No such file or directory
  compilation terminated.
  make: *** [builtin-trace.o] Error 1

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348745018-21744-1-git-send-email-namhyung@kernel.org
[ committer note: Added ", disables 'trace tool' to the feature warning msg ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |   16 ++++++++++++++--
 tools/perf/config/feature-tests.mak |   11 +++++++++++
 tools/perf/perf.c                   |    2 ++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6958ba4..e5e71e7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -102,7 +102,7 @@ ifdef PARSER_DEBUG
 endif
 
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
-EXTLIBS = -lpthread -lrt -lelf -lm -laudit
+EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -442,7 +442,6 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
-BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
 PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
@@ -560,6 +559,19 @@ else
 	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
+ifdef NO_LIBAUDIT
+	BASIC_CFLAGS += -DNO_LIBAUDIT_SUPPORT
+else
+	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
+	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT)),y)
+		msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
+		BASIC_CFLAGS += -DNO_LIBAUDIT_SUPPORT
+	else
+		BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
+		EXTLIBS += -laudit
+	endif
+endif
+
 ifdef NO_NEWT
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 else
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 116690a..4add41b 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -193,3 +193,14 @@ int main(void)
 }
 endef
 endif
+
+ifndef NO_LIBAUDIT
+define SOURCE_LIBAUDIT
+#include <libaudit.h>
+
+int main(void)
+{
+	return audit_open();
+}
+endef
+endif
\ No newline at end of file
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 3fb052c..fc2f770 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -55,7 +55,9 @@ static struct cmd_struct commands[] = {
 	{ "lock",	cmd_lock,	0 },
 	{ "kvm",	cmd_kvm,	0 },
 	{ "test",	cmd_test,	0 },
+#ifndef NO_LIBAUDIT_SUPPORT
 	{ "trace",	cmd_trace,	0 },
+#endif
 	{ "inject",	cmd_inject,	0 },
 };
 
-- 
1.7.9.2.358.g22243

