Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2JDSYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:24:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:39663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2JDSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:08:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/42] perf tools: Convert to LIBUNWIND_SUPPORT
Date: Thu,  4 Oct 2012 15:08:04 -0300
Message-Id: <1349374122-27806-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without libunwind, we can set NO_LIBUNWIND=1 as a
argument of make.  It then defines NO_LIBUNWIND_SUPPORT macro for C code
to do the proper handling.  However it usually used in a negative
semantics - e.g. #ifndef - so we saw double negations which can be
misleading.  Convert it to a positive form to make it more readable.

Also change NO_PERF_REGS macro to HAVE_PERF_REGS for the same reason.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348824728-14025-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile         |    8 +++-----
 tools/perf/builtin-record.c |   14 +++++++-------
 tools/perf/util/perf_regs.h |    4 ++--
 tools/perf/util/unwind.h    |    4 ++--
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1df0917..6763024 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -535,9 +535,8 @@ endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 endif # NO_LIBELF
 
-ifdef NO_LIBUNWIND
-	BASIC_CFLAGS += -DNO_LIBUNWIND_SUPPORT
-else
+ifndef NO_LIBUNWIND
+	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
 	EXTLIBS += $(LIBUNWIND_LIBS)
 	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
 	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
@@ -747,8 +746,7 @@ ifeq ($(NO_PERF_REGS),0)
 	ifeq ($(ARCH),x86)
 		LIB_H += arch/x86/include/perf_regs.h
 	endif
-else
-	BASIC_CFLAGS += -DNO_PERF_REGS
+	BASIC_CFLAGS += -DHAVE_PERF_REGS
 endif
 
 ifdef NO_STRLCPY
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f14cb5f..8c029fe 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -33,11 +33,11 @@
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
 
-#ifdef NO_LIBUNWIND_SUPPORT
-static char callchain_help[] = CALLCHAIN_HELP "[fp]";
-#else
+#ifdef LIBUNWIND_SUPPORT
 static unsigned long default_stack_dump_size = 8192;
 static char callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+#else
+static char callchain_help[] = CALLCHAIN_HELP "[fp]";
 #endif
 
 enum write_mode_t {
@@ -800,7 +800,7 @@ error:
 	return ret;
 }
 
-#ifndef NO_LIBUNWIND_SUPPORT
+#ifdef LIBUNWIND_SUPPORT
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -826,7 +826,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* !NO_LIBUNWIND_SUPPORT */
+#endif /* LIBUNWIND_SUPPORT */
 
 static int
 parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
@@ -865,7 +865,7 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 				       "needed for -g fp\n");
 			break;
 
-#ifndef NO_LIBUNWIND_SUPPORT
+#ifdef LIBUNWIND_SUPPORT
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			ret = 0;
@@ -883,7 +883,7 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 			if (!ret)
 				pr_debug("callchain: stack dump size %d\n",
 					 rec->opts.stack_dump_size);
-#endif /* !NO_LIBUNWIND_SUPPORT */
+#endif /* LIBUNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown -g option "
 			       "value: %s\n", arg);
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index 316dbe7..5a4f2b6 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_REGS_H
 #define __PERF_REGS_H
 
-#ifndef NO_PERF_REGS
+#ifdef HAVE_PERF_REGS
 #include <perf_regs.h>
 #else
 #define PERF_REGS_MASK	0
@@ -10,5 +10,5 @@ static inline const char *perf_reg_name(int id __maybe_unused)
 {
 	return NULL;
 }
-#endif /* NO_PERF_REGS */
+#endif /* HAVE_PERF_REGS */
 #endif /* __PERF_REGS_H */
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index a78c8b3..cb6bc50 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -13,7 +13,7 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifndef NO_LIBUNWIND_SUPPORT
+#ifdef LIBUNWIND_SUPPORT
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
@@ -31,5 +31,5 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
-#endif /* NO_LIBUNWIND_SUPPORT */
+#endif /* LIBUNWIND_SUPPORT */
 #endif /* __UNWIND_H */
-- 
1.7.1

