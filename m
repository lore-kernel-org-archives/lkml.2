Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab2I1Qih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:38:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42075 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab2I1Qig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:38:36 -0400
Date: Fri, 28 Sep 2012 09:38:17 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-4d29089c2b70ffeb61656ffd1b9c9c52602ddd44@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1348745018-21744-1-git-send-email-namhyung@kernel.org>
References: <1348745018-21744-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Check libaudit availability for perf-trace builtin
Git-Commit-ID: 4d29089c2b70ffeb61656ffd1b9c9c52602ddd44
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 09:38:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d29089c2b70ffeb61656ffd1b9c9c52602ddd44
Gitweb:     http://git.kernel.org/tip/4d29089c2b70ffeb61656ffd1b9c9c52602ddd44
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Sep 2012 20:23:38 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 27 Sep 2012 10:56:40 -0300

perf tools: Check libaudit availability for perf-trace builtin

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
 
