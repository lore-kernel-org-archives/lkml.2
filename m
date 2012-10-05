Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2JEIcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:32:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60639 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2JEIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:32:08 -0400
Date: Fri, 5 Oct 2012 01:31:49 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-95485b1cda827e4db7102ad5fde1791087a0f4c5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1348824728-14025-5-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Convert to LIBUNWIND_SUPPORT
Git-Commit-ID: 95485b1cda827e4db7102ad5fde1791087a0f4c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:31:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95485b1cda827e4db7102ad5fde1791087a0f4c5
Gitweb:     http://git.kernel.org/tip/95485b1cda827e4db7102ad5fde1791087a0f4c5
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 28 Sep 2012 18:32:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 17:56:01 -0300

perf tools: Convert to LIBUNWIND_SUPPORT

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
index 316dbe7..5a4f2b6f 100644
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
