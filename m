Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0JMFI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:08:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0JMFHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=UN2UzZ5ECCW7/8hvH71C7BhYN2mtdWJWhg+y/euGetiBJmePXEcdg5rH8ecrSOR02s
         ZmzYyLycoS/V5dmR/x+O9E+NVGLBXf4P3/kiGtDOpFzTGre0FhCHXIoVw0Z+W2vpaAya
         iQg7/eVuyj9wLMA/tXDE4l0Uu3YnGxNsZtMHE=
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
        Robert Richter <robert.richter@amd.com>
Subject: [RFC PATCH 5/9] perf: Support for dwarf mode callchain on perf record
Date: Wed, 13 Oct 2010 07:06:57 +0200
Message-Id: <1286946421-32202-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
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
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-record.c |   76 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ff77b80..132d710 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -32,6 +32,12 @@ enum write_mode_t {
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
@@ -56,7 +62,6 @@ static int			thread_num			=      0;
 static pid_t			child_pid			=     -1;
 static bool			no_inherit			=  false;
 static enum write_mode_t	write_mode			= WRITE_FORCE;
-static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
@@ -76,6 +81,10 @@ static off_t			post_processing_offset;
 static struct perf_session	*session;
 static const char		*cpu_list;
 
+static char			callchain_default_opt[]		=      "fp";
+static unsigned long		stack_dump_size			=	4000;
+static enum call_graph_mode	call_graph			= CALLCHAIN_NONE;
+
 struct mmap_data {
 	int			counter;
 	void			*base;
@@ -274,9 +283,15 @@ static void create_counter(int counter, int cpu)
 		attr->mmap_data = track;
 	}
 
-	if (call_graph)
+	if (call_graph) {
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+		if (call_graph == CALLCHAIN_DWARF) {
+			attr->sample_type |= PERF_SAMPLE_UREGS;
+			attr->ustack_dump_size = stack_dump_size;
+		}
+	}
+
 	if (system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
@@ -779,6 +794,58 @@ out_delete_session:
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
@@ -816,8 +883,9 @@ static const struct option options[] = {
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
-- 
1.6.2.3

