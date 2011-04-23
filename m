Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab1DWQ3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:29:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35095 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab1DWQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:29:32 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 07/18] perf: Export trace-event utils
Date: Sat, 23 Apr 2011 18:28:09 +0200
Message-Id: <1303576100-425-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Export trace-event* utils into a sub-lib for wider use. While at it,
export functions for use by other entities later.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile                                     |    6 ++-
 tools/lib/trace/Makefile                           |   59 ++++++++++++++++++++
 .../trace-event-info.c => lib/trace/event-info.c}  |   20 +++----
 .../trace/event-parse.c}                           |   16 +++---
 .../trace-event-read.c => lib/trace/event-read.c}  |    4 +-
 tools/{perf/util => lib/trace}/trace-event.h       |   22 +++++--
 tools/perf/Makefile                                |   11 ++--
 tools/perf/bench/bench.h                           |    2 +
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-kvm.c                           |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-sched.c                         |    2 +-
 tools/perf/builtin-script.c                        |    2 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    2 +-
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |    2 +-
 tools/perf/util/cache.h                            |    1 +
 tools/perf/util/header.c                           |    2 +-
 tools/perf/util/probe-event.c                      |    2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    2 +-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/scripts/Makefile.lib                         |    4 +
 22 files changed, 123 insertions(+), 46 deletions(-)
 create mode 100644 tools/lib/trace/Makefile
 rename tools/{perf/util/trace-event-info.c => lib/trace/event-info.c} (97%)
 rename tools/{perf/util/trace-event-parse.c => lib/trace/event-parse.c} (99%)
 rename tools/{perf/util/trace-event-read.c => lib/trace/event-read.c} (99%)
 rename tools/{perf/util => lib/trace}/trace-event.h (91%)

diff --git a/tools/Makefile b/tools/Makefile
index 74b20a9..48f0720 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -9,12 +9,15 @@ BASIC_CFLAGS = -I$(CURDIR)/lib
 BASIC_CFLAGS += -I$(CURDIR)/perf/util/include
 export BASIC_CFLAGS
 
-perf: .FORCE
+perf: libtrace .FORCE
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
 
 firewire: .FORCE
 	$(QUIET_SUBDIR0)firewire/ $(QUIET_SUBDIR1)
 
+libtrace: .FORCE
+	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1)
+
 slabinfo: .FORCE
 	$(QUIET_SUBDIR0)slub/ $(QUIET_SUBDIR1)
 
@@ -33,6 +36,7 @@ x86_energy: .FORCE
 clean:
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)firewire/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)slub/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)power/x86/turbostat/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)usb/ $(QUIET_SUBDIR1) clean
diff --git a/tools/lib/trace/Makefile b/tools/lib/trace/Makefile
new file mode 100644
index 0000000..dddc228
--- /dev/null
+++ b/tools/lib/trace/Makefile
@@ -0,0 +1,59 @@
+include ../../scripts/Makefile.lib
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+
+# Make the path relative to DESTDIR, not to prefix
+ifndef DESTDIR
+prefix = $(HOME)
+endif
+bindir_relative = bin
+bindir = $(prefix)/$(bindir_relative)
+mandir = share/man
+infodir = share/info
+sharedir = $(prefix)/share
+ifeq ($(prefix),/usr)
+sysconfdir = /etc
+else
+sysconfdir = $(prefix)/etc
+endif
+
+export prefix bindir sharedir sysconfdir
+
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+RM = rm -f
+TAR = tar
+FIND = find
+INSTALL = install
+RPMBUILD = rpmbuild
+PTHREAD_LIBS = -lpthread
+
+ifeq ("$(origin V)", "command line")
+  VERBOSE = $(V)
+endif
+ifndef VERBOSE
+  VERBOSE = 0
+endif
+
+TRACE_LIB = $(LIB_OUTPUT)libtrace.a
+
+all: $(TRACE_LIB)
+
+TRACE_LIB_H += trace-event.h
+
+TRACE_LIB_OBJS += event-parse.o
+TRACE_LIB_OBJS += event-read.o
+TRACE_LIB_OBJS += event-info.o
+
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+
+$(OUTPUT)%.o: %.c
+	$(QUIET_CC)$(CC) -g -o $@ -c $(ALL_CFLAGS) $<
+
+$(TRACE_LIB): $(TRACE_LIB_OBJS) $(TRACE_LIB_H)
+	$(RM) $@;  $(AR) rcs $@ $(TRACE_LIB_OBJS)
+
+clean:
+	$(RM) *.a *.o *~ *.so $(TRACE_LIB)
+
+.PHONY: clean
diff --git a/tools/perf/util/trace-event-info.c b/tools/lib/trace/event-info.c
similarity index 97%
rename from tools/perf/util/trace-event-info.c
rename to tools/lib/trace/event-info.c
index 35729f4..5270a64 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/lib/trace/event-info.c
@@ -37,10 +37,10 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 
-#include "../perf.h"
+#include "../../perf/perf.h"
 #include "trace-event.h"
-#include "debugfs.h"
-#include "evsel.h"
+#include "../perf/util/debugfs.h"
+#include "../perf/util/evsel.h"
 
 #define VERSION "0.5"
 
@@ -72,8 +72,6 @@ struct events {
 	char *name;
 };
 
-
-
 static void die(const char *fmt, ...)
 {
 	va_list ap;
@@ -136,7 +134,7 @@ static const char *find_tracing_dir(void)
 	return tracing;
 }
 
-static char *get_tracing_file(const char *name)
+char *get_tracing_file(const char *name)
 {
 	const char *tracing;
 	char *file;
@@ -151,7 +149,7 @@ static char *get_tracing_file(const char *name)
 	return file;
 }
 
-static void put_tracing_file(char *file)
+void put_tracing_file(char *file)
 {
 	free(file);
 }
@@ -231,7 +229,7 @@ static unsigned long get_size_fd(int fd)
 	return size;
 }
 
-static unsigned long get_size(const char *file)
+unsigned long get_filesize(const char *file)
 {
 	unsigned long long size = 0;
 	int fd;
@@ -340,7 +338,7 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 
 		if (ret >= 0) {
 			/* unfortunately, you can not stat debugfs files for size */
-			size = get_size(format);
+			size = get_filesize(format);
 			write_or_die(&size, 8);
 			check_size = copy_file(format);
 			if (size != check_size)
@@ -438,7 +436,7 @@ static void read_proc_kallsyms(void)
 		write_or_die(&size, 4);
 		return;
 	}
-	size = get_size(path);
+	size = get_filesize(path);
 	write_or_die(&size, 4);
 	check_size = copy_file(path);
 	if (size != check_size)
@@ -461,7 +459,7 @@ static void read_ftrace_printk(void)
 		write_or_die(&size, 4);
 		goto out;
 	}
-	size = get_size(path);
+	size = get_filesize(path);
 	write_or_die(&size, 4);
 	check_size = copy_file(path);
 	if (size != check_size)
diff --git a/tools/perf/util/trace-event-parse.c b/tools/lib/trace/event-parse.c
similarity index 99%
rename from tools/perf/util/trace-event-parse.c
rename to tools/lib/trace/event-parse.c
index 0a7ed5b..4a52cb8 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/lib/trace/event-parse.c
@@ -29,8 +29,8 @@
 #include <errno.h>
 
 #undef _GNU_SOURCE
-#include "../perf.h"
-#include "util.h"
+#include "../../perf/perf.h"
+#include "../../perf/util/util.h"
 #include "trace-event.h"
 
 int header_page_ts_offset;
@@ -44,7 +44,7 @@ int header_page_data_size;
 
 bool latency_format;
 
-static char *input_buf;
+static const char *input_buf;
 static unsigned long long input_buf_ptr;
 static unsigned long long input_buf_siz;
 
@@ -56,7 +56,7 @@ static int is_symbolic_field;
 static struct format_field *
 find_any_field(struct event *event, const char *name);
 
-static void init_input_buf(char *buf, unsigned long long size)
+void init_input_buf(const char *buf, unsigned long long size)
 {
 	input_buf = buf;
 	input_buf_siz = size;
@@ -338,7 +338,7 @@ void print_printk(void)
 	}
 }
 
-static struct event *alloc_event(void)
+struct event *alloc_event(void)
 {
 	struct event *event;
 
@@ -701,7 +701,7 @@ static int read_expected_item(enum event_type expect, const char *str)
 	return __read_expected(expect, str, 0, true);
 }
 
-static char *event_read_name(void)
+char *event_read_name(void)
 {
 	char *token;
 
@@ -721,7 +721,7 @@ static char *event_read_name(void)
 	return NULL;
 }
 
-static int event_read_id(void)
+int event_read_id(void)
 {
 	char *token;
 	int id;
@@ -986,7 +986,7 @@ fail_expect:
 	return -1;
 }
 
-static int event_read_format(struct event *event)
+int event_read_format(struct event *event)
 {
 	char *token;
 	int ret;
diff --git a/tools/perf/util/trace-event-read.c b/tools/lib/trace/event-read.c
similarity index 99%
rename from tools/perf/util/trace-event-read.c
rename to tools/lib/trace/event-read.c
index f55cc3a..f65dcaa 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/lib/trace/event-read.c
@@ -36,8 +36,8 @@
 #include <ctype.h>
 #include <errno.h>
 
-#include "../perf.h"
-#include "util.h"
+#include "../../perf/perf.h"
+#include "../../perf/util/util.h"
 #include "trace-event.h"
 
 static int input_fd;
diff --git a/tools/perf/util/trace-event.h b/tools/lib/trace/trace-event.h
similarity index 91%
rename from tools/perf/util/trace-event.h
rename to tools/lib/trace/trace-event.h
index f674dda..bf28476 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/lib/trace/trace-event.h
@@ -1,12 +1,13 @@
-#ifndef __PERF_TRACE_EVENTS_H
-#define __PERF_TRACE_EVENTS_H
+#ifndef __LIB_TRACE_EVENTS_H
+#define __LIB_TRACE_EVENTS_H
 
 #include <stdbool.h>
-#include "parse-events.h"
-#include "session.h"
+#include <linux/compiler.h>
 
-#define __unused __attribute__((unused))
+#include "../../perf/util/session.h"
+#include "../../perf/util/parse-events.h"
 
+#define __unused       __attribute__((unused))
 
 #ifndef PAGE_MASK
 #define PAGE_MASK (page_size - 1)
@@ -265,6 +266,15 @@ unsigned long long eval_flag(const char *flag);
 int read_tracing_data(int fd, struct list_head *pattrs);
 ssize_t read_tracing_data_size(int fd, struct list_head *pattrs);
 
+extern struct event *alloc_event(void);
+extern void init_input_buf(const char *buf, unsigned long long size);
+extern char *event_read_name(void);
+extern int event_read_id(void);
+extern int event_read_format(struct event *event);
+unsigned long get_filesize(const char *file);
+char *get_tracing_file(const char *name);
+void put_tracing_file(char *file);
+
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
@@ -299,4 +309,4 @@ int common_pc(struct scripting_context *context);
 int common_flags(struct scripting_context *context);
 int common_lock_depth(struct scripting_context *context);
 
-#endif /* __PERF_TRACE_EVENTS_H */
+#endif /* __LIB_TRACE_EVENTS_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ab9f667..2c82f7f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -124,7 +124,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
+BASIC_CFLAGS += -Iutil/include -Iarch/$(ARCH)/include
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -133,6 +133,7 @@ LIB_H =
 LIB_OBJS =
 PYRF_OBJS =
 SCRIPT_SH =
+EXTRA_LIBS =
 
 SCRIPT_SH += perf-archive.sh
 
@@ -175,6 +176,8 @@ export PERL_PATH
 
 LIB_FILE=$(OUTPUT)libperf.a
 
+EXTRA_LIBS=$(LIB_OUTPUT)libtrace.a
+
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
@@ -238,7 +241,6 @@ LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
 LIB_H += util/thread_map.h
-LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
@@ -289,9 +291,6 @@ LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
-LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
-LIB_OBJS += $(OUTPUT)util/trace-event-read.o
-LIB_OBJS += $(OUTPUT)util/trace-event-info.o
 LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
 LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
@@ -334,7 +333,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
-PERFLIBS = $(LIB_FILE)
+PERFLIBS = $(LIB_FILE) $(EXTRA_LIBS)
 
 # Files needed for the python binding, perf.so
 # pyrf is just an internal name needed for all those wrappers.
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..0c7ee07 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,6 +1,8 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+#include <linux/compiler.h>
+
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 225e963..49062b6 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -9,7 +9,7 @@
 #include "util/session.h"
 
 #include "util/parse-options.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 
 #include "util/debug.h"
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 34d1e85..1981fe4 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -9,7 +9,7 @@
 #include "util/session.h"
 
 #include "util/parse-options.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 
 #include "util/debug.h"
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 9ac05aa..f73806f 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -8,7 +8,7 @@
 #include "util/header.h"
 
 #include "util/parse-options.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 
 #include "util/debug.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index dcfe887..26fb319 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -9,7 +9,7 @@
 #include "util/session.h"
 
 #include "util/parse-options.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 
 #include "util/debug.h"
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 974f6d3..f4c0d50 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -9,7 +9,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 #include "util/parse-options.h"
 #include "util/util.h"
 #include "util/evlist.h"
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
index 790ceba..bb52853 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -32,7 +32,7 @@
 #include "perl.h"
 #include "XSUB.h"
 #include "../../../perf.h"
-#include "../../../util/trace-event.h"
+#include <trace/trace-event.h>
 
 #ifndef PERL_UNUSED_VAR
 #  define PERL_UNUSED_VAR(var) if (0) var = var
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/Context.c b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
index 315067b..7621a46 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
@@ -21,7 +21,7 @@
 
 #include <Python.h>
 #include "../../../perf.h"
-#include "../../../util/trace-event.h"
+#include <trace/trace-event.h>
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index fc5e5a0..ced8cee 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -5,6 +5,7 @@
 #include "util.h"
 #include "strbuf.h"
 #include "../perf.h"
+#include <linux/compiler.h>
 
 #define CMD_EXEC_PATH "--exec-path"
 #define CMD_PERF_DIR "--perf-dir="
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 93862a8..ac26a5c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -13,7 +13,7 @@
 #include "util.h"
 #include "header.h"
 #include "../perf.h"
-#include "trace-event.h"
+#include <trace/trace-event.h>
 #include "session.h"
 #include "symbol.h"
 #include "debug.h"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f022316..9c074ea 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -44,7 +44,7 @@
 #include "symbol.h"
 #include "thread.h"
 #include "debugfs.h"
-#include "trace-event.h"	/* For __unused */
+#include <trace/trace-event.h>	/* For __unused */
 #include "probe-event.h"
 #include "probe-finder.h"
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 74350ff..0c1ba9b 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -27,7 +27,7 @@
 
 #include "../../perf.h"
 #include "../util.h"
-#include "../trace-event.h"
+#include <trace/trace-event.h>
 
 #include <EXTERN.h>
 #include <perl.h>
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 6ccf70e..79caf91 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -29,7 +29,7 @@
 
 #include "../../perf.h"
 #include "../util.h"
-#include "../trace-event.h"
+#include <trace/trace-event.h>
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index c9dcbec..205ec96 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -27,7 +27,7 @@
 
 #include "../perf.h"
 #include "util.h"
-#include "trace-event.h"
+#include <trace/trace-event.h>
 
 struct scripting_context *scripting_context;
 
diff --git a/tools/scripts/Makefile.lib b/tools/scripts/Makefile.lib
index 9dfa0f9..f6c6af6 100644
--- a/tools/scripts/Makefile.lib
+++ b/tools/scripts/Makefile.lib
@@ -1,5 +1,9 @@
 ifeq ("$(origin O)", "command line")
 	OUTPUT := $(O)/
+	LIB_OUTPUT := $(O)/generic-lib/
+	__dummy := $(shell if [ ! -d $(LIB_OUTPUT) ]; then mkdir -p $(LIB_OUTPUT); fi)
+else
+	LIB_OUTPUT := $(PERF_TOP_DIR)/lib/
 endif
 
 ifneq ($(OUTPUT),)
-- 
1.7.4.rc2

