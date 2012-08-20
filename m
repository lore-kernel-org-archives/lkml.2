Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2HTEqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:46:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2HTEpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:45:22 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 6/7] perf: make dwarf unwind support based on CONFIG_LIBUNWIND
Date: Sun, 19 Aug 2012 22:44:50 -0600
Message-Id: <1345437891-78830-7-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
References: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile                 |   43 +++++++++++++++--------------------
 tools/perf/arch/x86/Makefile        |    2 +-
 tools/perf/builtin-record.c         |   15 ++++++------
 tools/perf/config/feature-tests.mak |    2 +-
 tools/perf/util/unwind.h            |    5 ++--
 5 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 012434d..b481d77 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -37,9 +37,6 @@ include config/utilities.mak
 # Define NO_DEMANGLE if you do not want C++ symbol demangling.
 #
 # Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
-#
-# Define NO_LIBUNWIND if you do not want libunwind dependency for dwarf
-# backtrace post unwind.
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
@@ -480,20 +477,25 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 endif
 endif # NO_LIBELF
 
-ifndef NO_LIBUNWIND
-# for linking with debug library, run like:
-# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-ifdef LIBUNWIND_DIR
-	LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-	LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
-endif
+ifdef CONFIG_LIBUNWIND
+    # for linking with debug library, run like:
+    # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+    ifdef LIBUNWIND_DIR
+	    LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+	    LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+    endif
 
-FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
-	msg := $(warning No libunwind found. Please install libunwind >= 0.99);
-	NO_LIBUNWIND := 1
-endif # Libunwind support
-endif # NO_LIBUNWIND
+    FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
+    ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
+        $(warning No libunwind found. Please install libunwind >= 0.99)
+        $(error )
+    endif # Libunwind support
+
+	EXTLIBS += $(LIBUNWIND_LIBS)
+	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
+	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
+	LIB_OBJS += $(OUTPUT)util/unwind.o
+endif # CONFIG_LIBUNWIND
 
 -include arch/$(ARCH)/Makefile
 
@@ -541,15 +543,6 @@ endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 endif # NO_LIBELF
 
-ifdef NO_LIBUNWIND
-	BASIC_CFLAGS += -DNO_LIBUNWIND_SUPPORT
-else
-	EXTLIBS += $(LIBUNWIND_LIBS)
-	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
-	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
-	LIB_OBJS += $(OUTPUT)util/unwind.o
-endif
-
 ifdef CONFIG_NEWT
     FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
     ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 815841c..3a6dc3d 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -2,7 +2,7 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
-ifndef NO_LIBUNWIND
+ifdef CONFIG_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 479ff2a..3f0c5f5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -26,6 +26,7 @@
 #include "util/symbol.h"
 #include "util/cpumap.h"
 #include "util/thread_map.h"
+#include "generated/autoconf.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -33,11 +34,11 @@
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
 
-#ifdef NO_LIBUNWIND_SUPPORT
-static char callchain_help[] = CALLCHAIN_HELP "[fp]";
-#else
+#ifdef CONFIG_LIBUNWIND
 static unsigned long default_stack_dump_size = 8192;
 static char callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+#else
+static char callchain_help[] = CALLCHAIN_HELP "[fp]";
 #endif
 
 enum write_mode_t {
@@ -738,7 +739,7 @@ error:
 	return ret;
 }
 
-#ifndef NO_LIBUNWIND_SUPPORT
+#ifdef CONFIG_LIBUNWIND
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -764,7 +765,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* !NO_LIBUNWIND_SUPPORT */
+#endif /* CONFIG_LIBUNWIND */
 
 static int
 parse_callchain_opt(const struct option *opt __used, const char *arg,
@@ -803,7 +804,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 				       "needed for -g fp\n");
 			break;
 
-#ifndef NO_LIBUNWIND_SUPPORT
+#ifdef CONFIG_LIBUNWIND
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			ret = 0;
@@ -821,7 +822,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 			if (!ret)
 				pr_debug("callchain: stack dump size %d\n",
 					 rec->opts.stack_dump_size);
-#endif /* !NO_LIBUNWIND_SUPPORT */
+#endif /* CONFIG_LIBUNWIND */
 		} else {
 			pr_err("callchain: Unknown -g option "
 			       "value: %s\n", arg);
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index aabe4e4..dbda9b5 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -155,7 +155,7 @@ int main(void)
 }
 endef
 
-ifndef NO_LIBUNWIND
+ifdef CONFIG_LIBUNWIND
 define SOURCE_LIBUNWIND
 #include <libunwind.h>
 #include <stdlib.h>
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index 919bd6a..8dd9e03 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -4,6 +4,7 @@
 #include "types.h"
 #include "event.h"
 #include "symbol.h"
+#include "generated/autoconf.h"
 
 struct unwind_entry {
 	struct map	*map;
@@ -13,7 +14,7 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifndef NO_LIBUNWIND_SUPPORT
+#ifdef CONFIG_LIBUNWIND
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
@@ -30,5 +31,5 @@ unwind__get_entries(unwind_entry_cb_t cb __used, void *arg __used,
 {
 	return 0;
 }
-#endif /* NO_LIBUNWIND_SUPPORT */
+#endif /* CONFIG_LIBUNWIND */
 #endif /* __UNWIND_H */
-- 
1.7.10.1

