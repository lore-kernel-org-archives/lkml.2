Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab0JVTO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:14:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37529 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759674Ab0JVTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=F8dvG3+88PUT+cj02k0M+Kx3K49Mr8PQ674vGiDVgUyJAIsuccwQ/82011Fw7DVAaX
         ut3kD8jsQ2O+yXIcJnx+IQgoKBwbVi5n7tk8CFsRbLGwFuYoGp9Yif0SX5HI7oAhqTpc
         6PWVb2H8aGkE0h+XocdRgOLRtukgC3amQuzmI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC PATCH 06/11] perf: Support for dwarf mode callchain on perf record
Date: Fri, 22 Oct 2010 21:13:07 +0200
Message-Id: <1287774792-23123-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
References: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"perf record -g" is the command to record frame pointer based
callchains. This patch extends the "-g" option to support the
dwarf cfi mode.

The new behaviour is:

- "perf record -g" will record frame pointer based callchains
as it did before.

- "perf record -g fp" is the same as "-g" alone

- "perf record -g dwarf" will record frame pointer based kernel
callchains but will ignore the user part. Instead it will dump
user regs and 4000 bytes of stack by default to each samples.

- "perf record -g dwarf,x" does the same but overrides the
default 4000 bytes of user stack dumped to x bytes instead.
The higher is the size, the deeper will be the callchain but
the higher will be the overhead of the profiling and the size
of the output file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---
 tools/perf/Makefile                     |    7 +++
 tools/perf/arch/x86/include/perf_regs.h |   11 ++++
 tools/perf/builtin-record.c             |   78 +++++++++++++++++++++++++++++--
 tools/perf/util/perf_regs.h             |   11 ++++
 4 files changed, 103 insertions(+), 4 deletions(-)
 create mode 100644 tools/perf/arch/x86/include/perf_regs.h
 create mode 100644 tools/perf/util/perf_regs.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d1db0f6..e22016d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -179,10 +179,12 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ )
+NO_PERF_REGS_DEFS := 1
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
         ARCH := x86
+	NO_PERF_REGS_DEFS := 0
 endif
 ifeq ($(ARCH),x86_64)
         ARCH := x86
@@ -417,6 +419,7 @@ LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
+LIB_H += util/perf_regs.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -662,6 +665,10 @@ else
 	endif
 endif
 
+ifeq ($(NO_PERF_REGS_DEFS),1)
+	BASIC_CFLAGS += -DNO_PERF_REGS_DEFS
+endif
+
 
 ifdef NO_STRLCPY
 	BASIC_CFLAGS += -DNO_STRLCPY
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
new file mode 100644
index 0000000..4f6d65d
--- /dev/null
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -0,0 +1,11 @@
+#include "../../../../../arch/x86/include/asm/perf_regs_32.h"
+
+
+#define BIT(x)	(1 << (x))
+
+#define PERF_UNWIND_REGS_MASK	\
+	(BIT(PERF_X86_32_REG_EAX) | BIT(PERF_X86_32_REG_EBX) |	\
+	 BIT(PERF_X86_32_REG_ECX) | BIT(PERF_X86_32_REG_EDX) |	\
+	 BIT(PERF_X86_32_REG_ESI) | BIT(PERF_X86_32_REG_EDI) |	\
+	 BIT(PERF_X86_32_REG_EBP) | BIT(PERF_X86_32_REG_ESP) |	\
+	 BIT(PERF_X86_32_REG_EIP))
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ff77b80..e3d835c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -22,6 +22,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/cpumap.h"
+#include "util/perf_regs.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -32,6 +33,12 @@ enum write_mode_t {
 	WRITE_APPEND
 };
 
+enum call_graph_mode {
+	CALLCHAIN_NONE,
+	CALLCHAIN_FP,
+	CALLCHAIN_DWARF
+};
+
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static u64			user_interval			= ULLONG_MAX;
@@ -56,7 +63,6 @@ static int			thread_num			=      0;
 static pid_t			child_pid			=     -1;
 static bool			no_inherit			=  false;
 static enum write_mode_t	write_mode			= WRITE_FORCE;
-static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
@@ -76,6 +82,10 @@ static off_t			post_processing_offset;
 static struct perf_session	*session;
 static const char		*cpu_list;
 
+static char			callchain_default_opt[]		=      "fp";
+static unsigned long		stack_dump_size			=	4000;
+static enum call_graph_mode	call_graph			= CALLCHAIN_NONE;
+
 struct mmap_data {
 	int			counter;
 	void			*base;
@@ -274,9 +284,16 @@ static void create_counter(int counter, int cpu)
 		attr->mmap_data = track;
 	}
 
-	if (call_graph)
+	if (call_graph) {
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+		if (call_graph == CALLCHAIN_DWARF) {
+			attr->user_regs = PERF_UNWIND_REGS_MASK;
+			attr->ustack_dump_size = stack_dump_size;
+			attr->exclude_user_callchain = 1;
+		}
+	}
+
 	if (system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
@@ -779,6 +796,58 @@ out_delete_session:
 	return err;
 }
 
+static int
+parse_callchain_opt(const struct option *opt __used, const char *arg,
+		    int unset)
+{
+	char *tok;
+
+	/*
+	 * --no-call-graph
+	 */
+	if (unset)
+		return 0;
+
+	if (!arg)
+		return 0;
+
+	tok = strtok((char *)arg, ",");
+	if (!tok)
+		return -1;
+
+	/* get the output mode */
+	if (!strncmp(tok, "fp", strlen(arg)))
+		call_graph = CALLCHAIN_FP;
+
+	else if (!strncmp(tok, "dwarf", strlen(arg)))
+		call_graph = CALLCHAIN_DWARF;
+
+	else if (!strncmp(tok, "none", strlen(arg)))
+		return 0;
+
+	else
+		return -1;
+
+	/* get the stack dump size */
+	tok = strtok(NULL, ",");
+	if (!tok)
+		return 0;
+
+	/* No stack dump size if we record using frame pointers */
+	if (call_graph == CALLCHAIN_FP) {
+		fprintf(stderr, "Stack dump size is only necessary for -g dwarf\n");
+		return -1;
+	}
+
+	stack_dump_size = strtoul(tok, NULL, 0);
+	if (stack_dump_size == ULONG_MAX) {
+		perror("Incorrect stack dump size\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -816,8 +885,9 @@ static const struct option options[] = {
 		    "child tasks do not inherit counters"),
 	OPT_UINTEGER('F', "freq", &user_freq, "profile at this frequency"),
 	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
-	OPT_BOOLEAN('g', "call-graph", &call_graph,
-		    "do call-graph (stack chain/backtrace) recording"),
+	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "mode,dump_size",
+		     "do call-graph (stack chain/backtrace) recording"
+		     "Default: fp", &parse_callchain_opt, callchain_default_opt),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('s', "stat", &inherit_stat,
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
new file mode 100644
index 0000000..f553a7a
--- /dev/null
+++ b/tools/perf/util/perf_regs.h
@@ -0,0 +1,11 @@
+#ifndef __PERF_REGS_H
+#define __PERF_REGS_H
+
+#ifndef NO_PERF_REGS_DEFS
+#include <perf_regs.h>
+#else
+
+#define PERF_UNWIND_REGS_MASK	0
+#endif /* NO_PERF_REGS_DEFS */
+
+#endif
-- 
1.6.2.3

