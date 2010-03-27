Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0C0Rcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 13:32:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:58485 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab0C0Rc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 13:32:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf tools: Allow specifying O= to build files in a separate directory
Date: Sat, 27 Mar 2010 14:32:13 -0300
Message-Id: <1269711133-7743-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269711133-7743-1-git-send-email-acme@infradead.org>
References: <1269711133-7743-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Avoiding polluting the source tree with build files.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile              |  322 ++++++++++++++++++++------------------
 tools/perf/util/PERF-VERSION-GEN |    6 +-
 2 files changed, 172 insertions(+), 156 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0d36c8c..9f5a47e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,3 +1,7 @@
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+endif
+
 # The default target of this Makefile is...
 all::
 
@@ -153,9 +157,13 @@ all::
 #
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 
-PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
-	@$(SHELL_PATH) util/PERF-VERSION-GEN
--include PERF-VERSION-FILE
+$(shell sh -c 'mkdir -p $(OUTPUT)scripts/python/Perf-Trace-Util/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)util/scripting-engines/' 2> /dev/null)
+$(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
+
+$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
+	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
+-include $(OUTPUT)PERF-VERSION-FILE
 
 uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
 uname_M := $(shell sh -c 'uname -m 2>/dev/null || echo not')
@@ -310,7 +318,7 @@ PROGRAMS += $(EXTRA_PROGRAMS)
 #
 # Single 'perf' binary right now:
 #
-PROGRAMS += perf
+PROGRAMS += $(OUTPUT)perf
 
 # List built-in command $C whose implementation cmd_$C() is not in
 # builtin-$C.o but is linked in as part of some other command.
@@ -320,7 +328,7 @@ PROGRAMS += perf
 ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
 
 # what 'all' will build but not install in perfexecdir
-OTHER_PROGRAMS = perf$X
+OTHER_PROGRAMS = $(OUTPUT)perf$X
 
 # Set paths to tools early so that they can be used for version tests.
 ifndef SHELL_PATH
@@ -332,7 +340,7 @@ endif
 
 export PERL_PATH
 
-LIB_FILE=libperf.a
+LIB_FILE=$(OUTPUT)libperf.a
 
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
@@ -392,77 +400,77 @@ LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/cpumap.h
 
-LIB_OBJS += util/abspath.o
-LIB_OBJS += util/alias.o
-LIB_OBJS += util/build-id.o
-LIB_OBJS += util/config.o
-LIB_OBJS += util/ctype.o
-LIB_OBJS += util/debugfs.o
-LIB_OBJS += util/environment.o
-LIB_OBJS += util/event.o
-LIB_OBJS += util/exec_cmd.o
-LIB_OBJS += util/help.o
-LIB_OBJS += util/levenshtein.o
-LIB_OBJS += util/parse-options.o
-LIB_OBJS += util/parse-events.o
-LIB_OBJS += util/path.o
-LIB_OBJS += util/rbtree.o
-LIB_OBJS += util/bitmap.o
-LIB_OBJS += util/hweight.o
-LIB_OBJS += util/find_next_bit.o
-LIB_OBJS += util/run-command.o
-LIB_OBJS += util/quote.o
-LIB_OBJS += util/strbuf.o
-LIB_OBJS += util/string.o
-LIB_OBJS += util/strlist.o
-LIB_OBJS += util/usage.o
-LIB_OBJS += util/wrapper.o
-LIB_OBJS += util/sigchain.o
-LIB_OBJS += util/symbol.o
-LIB_OBJS += util/color.o
-LIB_OBJS += util/pager.o
-LIB_OBJS += util/header.o
-LIB_OBJS += util/callchain.o
-LIB_OBJS += util/values.o
-LIB_OBJS += util/debug.o
-LIB_OBJS += util/map.o
-LIB_OBJS += util/session.o
-LIB_OBJS += util/thread.o
-LIB_OBJS += util/trace-event-parse.o
-LIB_OBJS += util/trace-event-read.o
-LIB_OBJS += util/trace-event-info.o
-LIB_OBJS += util/trace-event-scripting.o
-LIB_OBJS += util/svghelper.o
-LIB_OBJS += util/sort.o
-LIB_OBJS += util/hist.o
-LIB_OBJS += util/probe-event.o
-LIB_OBJS += util/util.o
-LIB_OBJS += util/cpumap.o
-
-BUILTIN_OBJS += builtin-annotate.o
-
-BUILTIN_OBJS += builtin-bench.o
+LIB_OBJS += $(OUTPUT)util/abspath.o
+LIB_OBJS += $(OUTPUT)util/alias.o
+LIB_OBJS += $(OUTPUT)util/build-id.o
+LIB_OBJS += $(OUTPUT)util/config.o
+LIB_OBJS += $(OUTPUT)util/ctype.o
+LIB_OBJS += $(OUTPUT)util/debugfs.o
+LIB_OBJS += $(OUTPUT)util/environment.o
+LIB_OBJS += $(OUTPUT)util/event.o
+LIB_OBJS += $(OUTPUT)util/exec_cmd.o
+LIB_OBJS += $(OUTPUT)util/help.o
+LIB_OBJS += $(OUTPUT)util/levenshtein.o
+LIB_OBJS += $(OUTPUT)util/parse-options.o
+LIB_OBJS += $(OUTPUT)util/parse-events.o
+LIB_OBJS += $(OUTPUT)util/path.o
+LIB_OBJS += $(OUTPUT)util/rbtree.o
+LIB_OBJS += $(OUTPUT)util/bitmap.o
+LIB_OBJS += $(OUTPUT)util/hweight.o
+LIB_OBJS += $(OUTPUT)util/find_next_bit.o
+LIB_OBJS += $(OUTPUT)util/run-command.o
+LIB_OBJS += $(OUTPUT)util/quote.o
+LIB_OBJS += $(OUTPUT)util/strbuf.o
+LIB_OBJS += $(OUTPUT)util/string.o
+LIB_OBJS += $(OUTPUT)util/strlist.o
+LIB_OBJS += $(OUTPUT)util/usage.o
+LIB_OBJS += $(OUTPUT)util/wrapper.o
+LIB_OBJS += $(OUTPUT)util/sigchain.o
+LIB_OBJS += $(OUTPUT)util/symbol.o
+LIB_OBJS += $(OUTPUT)util/color.o
+LIB_OBJS += $(OUTPUT)util/pager.o
+LIB_OBJS += $(OUTPUT)util/header.o
+LIB_OBJS += $(OUTPUT)util/callchain.o
+LIB_OBJS += $(OUTPUT)util/values.o
+LIB_OBJS += $(OUTPUT)util/debug.o
+LIB_OBJS += $(OUTPUT)util/map.o
+LIB_OBJS += $(OUTPUT)util/session.o
+LIB_OBJS += $(OUTPUT)util/thread.o
+LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
+LIB_OBJS += $(OUTPUT)util/trace-event-read.o
+LIB_OBJS += $(OUTPUT)util/trace-event-info.o
+LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
+LIB_OBJS += $(OUTPUT)util/svghelper.o
+LIB_OBJS += $(OUTPUT)util/sort.o
+LIB_OBJS += $(OUTPUT)util/hist.o
+LIB_OBJS += $(OUTPUT)util/probe-event.o
+LIB_OBJS += $(OUTPUT)util/util.o
+LIB_OBJS += $(OUTPUT)util/cpumap.o
+
+BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
+
+BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 
 # Benchmark modules
-BUILTIN_OBJS += bench/sched-messaging.o
-BUILTIN_OBJS += bench/sched-pipe.o
-BUILTIN_OBJS += bench/mem-memcpy.o
-
-BUILTIN_OBJS += builtin-diff.o
-BUILTIN_OBJS += builtin-help.o
-BUILTIN_OBJS += builtin-sched.o
-BUILTIN_OBJS += builtin-buildid-list.o
-BUILTIN_OBJS += builtin-buildid-cache.o
-BUILTIN_OBJS += builtin-list.o
-BUILTIN_OBJS += builtin-record.o
-BUILTIN_OBJS += builtin-report.o
-BUILTIN_OBJS += builtin-stat.o
-BUILTIN_OBJS += builtin-timechart.o
-BUILTIN_OBJS += builtin-top.o
-BUILTIN_OBJS += builtin-trace.o
-BUILTIN_OBJS += builtin-probe.o
-BUILTIN_OBJS += builtin-kmem.o
-BUILTIN_OBJS += builtin-lock.o
+BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
+BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
+
+BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
+BUILTIN_OBJS += $(OUTPUT)builtin-help.o
+BUILTIN_OBJS += $(OUTPUT)builtin-sched.o
+BUILTIN_OBJS += $(OUTPUT)builtin-buildid-list.o
+BUILTIN_OBJS += $(OUTPUT)builtin-buildid-cache.o
+BUILTIN_OBJS += $(OUTPUT)builtin-list.o
+BUILTIN_OBJS += $(OUTPUT)builtin-record.o
+BUILTIN_OBJS += $(OUTPUT)builtin-report.o
+BUILTIN_OBJS += $(OUTPUT)builtin-stat.o
+BUILTIN_OBJS += $(OUTPUT)builtin-timechart.o
+BUILTIN_OBJS += $(OUTPUT)builtin-top.o
+BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
+BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
+BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
+BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 
 PERFLIBS = $(LIB_FILE)
 
@@ -493,6 +501,10 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifneq ($(OUTPUT),)
+	BASIC_CFLAGS += -I$(OUTPUT)
+endif
+
 ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
@@ -511,7 +523,7 @@ else
 ifndef NO_DWARF
 	BASIC_CFLAGS += -I/usr/include/elfutils -DDWARF_SUPPORT
 	EXTLIBS += -lelf -ldw
-	LIB_OBJS += util/probe-finder.o
+	LIB_OBJS += $(OUTPUT)util/probe-finder.o
 endif
 endif
 
@@ -520,7 +532,7 @@ ifneq ($(shell sh -c "(echo '\#include <newt.h>'; echo 'int main(void) { newtIni
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 else
 	EXTLIBS += -lnewt
-	LIB_OBJS += util/newt.o
+	LIB_OBJS += $(OUTPUT)util/newt.o
 endif
 
 ifndef NO_LIBPERL
@@ -532,8 +544,8 @@ ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; e
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
 	ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
-	LIB_OBJS += util/scripting-engines/trace-event-perl.o
-	LIB_OBJS += scripts/perl/Perf-Trace-Util/Context.o
+	LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
+	LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
 
 ifndef NO_LIBPYTHON
@@ -545,8 +557,8 @@ ifneq ($(shell sh -c "(echo '\#include <Python.h>'; echo 'int main(void) { Py_In
 	BASIC_CFLAGS += -DNO_LIBPYTHON
 else
 	ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
-	LIB_OBJS += util/scripting-engines/trace-event-python.o
-	LIB_OBJS += scripts/python/Perf-Trace-Util/Context.o
+	LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
+	LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
 endif
 
 ifdef NO_DEMANGLE
@@ -617,53 +629,53 @@ ifdef NO_C99_FORMAT
 endif
 ifdef SNPRINTF_RETURNS_BOGUS
 	COMPAT_CFLAGS += -DSNPRINTF_RETURNS_BOGUS
-	COMPAT_OBJS += compat/snprintf.o
+	COMPAT_OBJS += $(OUTPUT)compat/snprintf.o
 endif
 ifdef FREAD_READS_DIRECTORIES
 	COMPAT_CFLAGS += -DFREAD_READS_DIRECTORIES
-	COMPAT_OBJS += compat/fopen.o
+	COMPAT_OBJS += $(OUTPUT)compat/fopen.o
 endif
 ifdef NO_SYMLINK_HEAD
 	BASIC_CFLAGS += -DNO_SYMLINK_HEAD
 endif
 ifdef NO_STRCASESTR
 	COMPAT_CFLAGS += -DNO_STRCASESTR
-	COMPAT_OBJS += compat/strcasestr.o
+	COMPAT_OBJS += $(OUTPUT)compat/strcasestr.o
 endif
 ifdef NO_STRTOUMAX
 	COMPAT_CFLAGS += -DNO_STRTOUMAX
-	COMPAT_OBJS += compat/strtoumax.o
+	COMPAT_OBJS += $(OUTPUT)compat/strtoumax.o
 endif
 ifdef NO_STRTOULL
 	COMPAT_CFLAGS += -DNO_STRTOULL
 endif
 ifdef NO_SETENV
 	COMPAT_CFLAGS += -DNO_SETENV
-	COMPAT_OBJS += compat/setenv.o
+	COMPAT_OBJS += $(OUTPUT)compat/setenv.o
 endif
 ifdef NO_MKDTEMP
 	COMPAT_CFLAGS += -DNO_MKDTEMP
-	COMPAT_OBJS += compat/mkdtemp.o
+	COMPAT_OBJS += $(OUTPUT)compat/mkdtemp.o
 endif
 ifdef NO_UNSETENV
 	COMPAT_CFLAGS += -DNO_UNSETENV
-	COMPAT_OBJS += compat/unsetenv.o
+	COMPAT_OBJS += $(OUTPUT)compat/unsetenv.o
 endif
 ifdef NO_SYS_SELECT_H
 	BASIC_CFLAGS += -DNO_SYS_SELECT_H
 endif
 ifdef NO_MMAP
 	COMPAT_CFLAGS += -DNO_MMAP
-	COMPAT_OBJS += compat/mmap.o
+	COMPAT_OBJS += $(OUTPUT)compat/mmap.o
 else
 	ifdef USE_WIN32_MMAP
 		COMPAT_CFLAGS += -DUSE_WIN32_MMAP
-		COMPAT_OBJS += compat/win32mmap.o
+		COMPAT_OBJS += $(OUTPUT)compat/win32mmap.o
 	endif
 endif
 ifdef NO_PREAD
 	COMPAT_CFLAGS += -DNO_PREAD
-	COMPAT_OBJS += compat/pread.o
+	COMPAT_OBJS += $(OUTPUT)compat/pread.o
 endif
 ifdef NO_FAST_WORKING_DIRECTORY
 	BASIC_CFLAGS += -DNO_FAST_WORKING_DIRECTORY
@@ -685,10 +697,10 @@ else
 endif
 endif
 ifdef NO_INET_NTOP
-	LIB_OBJS += compat/inet_ntop.o
+	LIB_OBJS += $(OUTPUT)compat/inet_ntop.o
 endif
 ifdef NO_INET_PTON
-	LIB_OBJS += compat/inet_pton.o
+	LIB_OBJS += $(OUTPUT)compat/inet_pton.o
 endif
 
 ifdef NO_ICONV
@@ -705,15 +717,15 @@ endif
 
 ifdef PPC_SHA1
 	SHA1_HEADER = "ppc/sha1.h"
-	LIB_OBJS += ppc/sha1.o ppc/sha1ppc.o
+	LIB_OBJS += $(OUTPUT)ppc/sha1.o ppc/sha1ppc.o
 else
 ifdef ARM_SHA1
 	SHA1_HEADER = "arm/sha1.h"
-	LIB_OBJS += arm/sha1.o arm/sha1_arm.o
+	LIB_OBJS += $(OUTPUT)arm/sha1.o $(OUTPUT)arm/sha1_arm.o
 else
 ifdef MOZILLA_SHA1
 	SHA1_HEADER = "mozilla-sha1/sha1.h"
-	LIB_OBJS += mozilla-sha1/sha1.o
+	LIB_OBJS += $(OUTPUT)mozilla-sha1/sha1.o
 else
 	SHA1_HEADER = <openssl/sha.h>
 	EXTLIBS += $(LIB_4_CRYPTO)
@@ -725,15 +737,15 @@ ifdef NO_PERL_MAKEMAKER
 endif
 ifdef NO_HSTRERROR
 	COMPAT_CFLAGS += -DNO_HSTRERROR
-	COMPAT_OBJS += compat/hstrerror.o
+	COMPAT_OBJS += $(OUTPUT)compat/hstrerror.o
 endif
 ifdef NO_MEMMEM
 	COMPAT_CFLAGS += -DNO_MEMMEM
-	COMPAT_OBJS += compat/memmem.o
+	COMPAT_OBJS += $(OUTPUT)compat/memmem.o
 endif
 ifdef INTERNAL_QSORT
 	COMPAT_CFLAGS += -DINTERNAL_QSORT
-	COMPAT_OBJS += compat/qsort.o
+	COMPAT_OBJS += $(OUTPUT)compat/qsort.o
 endif
 ifdef RUNTIME_PREFIX
 	COMPAT_CFLAGS += -DRUNTIME_PREFIX
@@ -813,7 +825,7 @@ export TAR INSTALL DESTDIR SHELL_PATH
 
 SHELL = $(SHELL_PATH)
 
-all:: .perf.dev.null shell_compatibility_test $(ALL_PROGRAMS) $(BUILT_INS) $(OTHER_PROGRAMS) PERF-BUILD-OPTIONS
+all:: .perf.dev.null shell_compatibility_test $(ALL_PROGRAMS) $(BUILT_INS) $(OTHER_PROGRAMS) $(OUTPUT)PERF-BUILD-OPTIONS
 ifneq (,$X)
 	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), test '$p' -ef '$p$X' || $(RM) '$p';)
 endif
@@ -825,39 +837,39 @@ please_set_SHELL_PATH_to_a_more_modern_shell:
 
 shell_compatibility_test: please_set_SHELL_PATH_to_a_more_modern_shell
 
-strip: $(PROGRAMS) perf$X
-	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) perf$X
+strip: $(PROGRAMS) $(OUTPUT)perf$X
+	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf$X
 
-perf.o: perf.c common-cmds.h PERF-CFLAGS
+$(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -DPERF_VERSION='"$(PERF_VERSION)"' \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		$(ALL_CFLAGS) -c $(filter %.c,$^)
+		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
 
-perf$X: perf.o $(BUILTIN_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ perf.o \
+$(OUTPUT)perf$X: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
+	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(OUTPUT)perf.o \
 		$(BUILTIN_OBJS) $(ALL_LDFLAGS) $(LIBS)
 
-builtin-help.o: builtin-help.c common-cmds.h PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) \
+$(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
 		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
 
-builtin-timechart.o: builtin-timechart.c common-cmds.h PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) \
+$(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
 		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
 
-$(BUILT_INS): perf$X
+$(BUILT_INS): $(OUTPUT)perf$X
 	$(QUIET_BUILT_IN)$(RM) $@ && \
 	ln perf$X $@ 2>/dev/null || \
 	ln -s perf$X $@ 2>/dev/null || \
 	cp perf$X $@
 
-common-cmds.h: util/generate-cmdlist.sh command-list.txt
+$(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
 
-common-cmds.h: $(wildcard Documentation/perf-*.txt)
+$(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
 	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
 
 $(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
@@ -869,7 +881,7 @@ $(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
 	    -e 's/@@NO_CURL@@/$(NO_CURL)/g' \
 	    $@.sh >$@+ && \
 	chmod +x $@+ && \
-	mv $@+ $@
+	mv $@+ $(OUTPUT)$@
 
 configure: configure.ac
 	$(QUIET_GEN)$(RM) $@ $<+ && \
@@ -879,60 +891,60 @@ configure: configure.ac
 	$(RM) $<+
 
 # These can record PERF_VERSION
-perf.o perf.spec \
+$(OUTPUT)perf.o perf.spec \
 	$(patsubst %.sh,%,$(SCRIPT_SH)) \
 	$(patsubst %.perl,%,$(SCRIPT_PERL)) \
-	: PERF-VERSION-FILE
+	: $(OUTPUT)PERF-VERSION-FILE
 
-%.o: %.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) $<
-%.s: %.c PERF-CFLAGS
+$(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
-%.o: %.S
-	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
 
-util/exec_cmd.o: util/exec_cmd.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) \
+$(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
 		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
 		'-DBINDIR="$(bindir_relative_SQ)"' \
 		'-DPREFIX="$(prefix_SQ)"' \
 		$<
 
-builtin-init-db.o: builtin-init-db.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) -DDEFAULT_PERF_TEMPLATE_DIR='"$(template_dir_SQ)"' $<
+$(OUTPUT)builtin-init-db.o: builtin-init-db.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DDEFAULT_PERF_TEMPLATE_DIR='"$(template_dir_SQ)"' $<
 
-util/config.o: util/config.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+$(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-util/rbtree.o: ../../lib/rbtree.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/rbtree.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 # some perf warning policies can't fit to lib/bitmap.c, eg: it warns about variable shadowing
 # from <string.h> that comes from kernel headers wrapping.
 KBITMAP_FLAGS=`echo $(ALL_CFLAGS) | sed s/-Wshadow// | sed s/-Wswitch-default// | sed s/-Wextra//`
 
-util/bitmap.o: ../../lib/bitmap.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/bitmap.o -c $(KBITMAP_FLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+$(OUTPUT)util/bitmap.o: ../../lib/bitmap.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(KBITMAP_FLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-util/hweight.o: ../../lib/hweight.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/hweight.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+$(OUTPUT)util/hweight.o: ../../lib/hweight.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+$(OUTPUT)util/find_next_bit.o: ../../lib/find_next_bit.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/scripting-engines/trace-event-perl.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+$(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
-scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o scripts/perl/Perf-Trace-Util/Context.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+$(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
 
-util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/scripting-engines/trace-event-python.o -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+$(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
-scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o scripts/python/Perf-Trace-Util/Context.o -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+$(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
 
-perf-%$X: %.o $(PERFLIBS)
+$(OUTPUT)perf-%$X: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
 
 $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
@@ -973,17 +985,17 @@ cscope:
 TRACK_CFLAGS = $(subst ','\'',$(ALL_CFLAGS)):\
              $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
 
-PERF-CFLAGS: .FORCE-PERF-CFLAGS
+$(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
 	@FLAGS='$(TRACK_CFLAGS)'; \
-	    if test x"$$FLAGS" != x"`cat PERF-CFLAGS 2>/dev/null`" ; then \
+	    if test x"$$FLAGS" != x"`cat $(OUTPUT)PERF-CFLAGS 2>/dev/null`" ; then \
 		echo 1>&2 "    * new build flags or prefix"; \
-		echo "$$FLAGS" >PERF-CFLAGS; \
+		echo "$$FLAGS" >$(OUTPUT)PERF-CFLAGS; \
             fi
 
 # We need to apply sq twice, once to protect from the shell
-# that runs PERF-BUILD-OPTIONS, and then again to protect it
+# that runs $(OUTPUT)PERF-BUILD-OPTIONS, and then again to protect it
 # and the first level quoting from the shell that runs "echo".
-PERF-BUILD-OPTIONS: .FORCE-PERF-BUILD-OPTIONS
+$(OUTPUT)PERF-BUILD-OPTIONS: .FORCE-PERF-BUILD-OPTIONS
 	@echo SHELL_PATH=\''$(subst ','\'',$(SHELL_PATH_SQ))'\' >$@
 	@echo TAR=\''$(subst ','\'',$(subst ','\'',$(TAR)))'\' >>$@
 	@echo NO_CURL=\''$(subst ','\'',$(subst ','\'',$(NO_CURL)))'\' >>$@
@@ -1004,7 +1016,7 @@ all:: $(TEST_PROGRAMS)
 
 export NO_SVN_TESTS
 
-check: common-cmds.h
+check: $(OUTPUT)common-cmds.h
 	if sparse; \
 	then \
 		for i in *.c */*.c; \
@@ -1038,10 +1050,10 @@ export perfexec_instdir
 
 install: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
-	$(INSTALL) perf$X '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) $(OUTPUT)perf$X '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
-	$(INSTALL) perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
 	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
@@ -1055,7 +1067,7 @@ ifdef BUILT_INS
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(BUILT_INS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifneq (,$X)
-	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), $(RM) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/$p';)
+	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) $(OUTPUT)perf$X)), $(RM) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/$p';)
 endif
 endif
 
@@ -1139,14 +1151,14 @@ clean:
 	$(RM) *.o */*.o */*/*.o */*/*/*.o $(LIB_FILE)
 	$(RM) $(ALL_PROGRAMS) $(BUILT_INS) perf$X
 	$(RM) $(TEST_PROGRAMS)
-	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo common-cmds.h TAGS tags cscope*
+	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(RM) -r autom4te.cache
 	$(RM) config.log config.mak.autogen config.mak.append config.status config.cache
 	$(RM) -r $(PERF_TARNAME) .doc-tmp-dir
 	$(RM) $(PERF_TARNAME).tar.gz perf-core_$(PERF_VERSION)-*.tar.gz
 	$(RM) $(htmldocs).tar.gz $(manpages).tar.gz
 	$(MAKE) -C Documentation/ clean
-	$(RM) PERF-VERSION-FILE PERF-CFLAGS PERF-BUILD-OPTIONS
+	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-BUILD-OPTIONS
 
 .PHONY: all install clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 54552a0..49ece79 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -1,6 +1,10 @@
 #!/bin/sh
 
-GVF=PERF-VERSION-FILE
+if [ $# -eq 1 ]  ; then
+	OUTPUT=$1
+fi
+
+GVF=${OUTPUT}PERF-VERSION-FILE
 DEF_VER=v0.0.2.PERF
 
 LF='
-- 
1.6.2.5

