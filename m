Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab2KENy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:54:27 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38981 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab2KENxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:53:38 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v2 14/16] perf tools: add new mem command for memory access profiling
Date: Mon,  5 Nov 2012 14:51:01 +0100
Message-Id: <1352123463-7346-15-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352123463-7346-1-git-send-email-eranian@google.com>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new command is a wrapper on top of perf record and
perf report to make it easier to configure for memory
access profiling.

To record loads:
$ perf mem -t load rec .....

To record stores:
$ perf mem -t store rec .....

To get the report:
$ perf mem -t load rep

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-mem.txt |   48 +++++++
 tools/perf/Makefile                   |    1 +
 tools/perf/builtin-mem.c              |  238 +++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                  |    1 +
 tools/perf/command-list.txt           |    1 +
 tools/perf/perf.c                     |    1 +
 6 files changed, 290 insertions(+)
 create mode 100644 tools/perf/Documentation/perf-mem.txt
 create mode 100644 tools/perf/builtin-mem.c

diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
new file mode 100644
index 0000000..888d511
--- /dev/null
+++ b/tools/perf/Documentation/perf-mem.txt
@@ -0,0 +1,48 @@
+perf-mem(1)
+===========
+
+NAME
+----
+perf-mem - Profile memory accesses
+
+SYNOPSIS
+--------
+[verse]
+'perf mem' [<options>] (record [<command>] | report)
+
+DESCRIPTION
+-----------
+"perf mem -t <TYPE> record" runs a command and gathers memory operation data
+from it, into perf.data. Perf record options are accepted and are passed through.
+
+"perf mem -t <TYPE> report" displays the result. It invokes perf report with the
+right set of options to display a memory access profile.
+
+OPTIONS
+-------
+<command>...::
+	Any command you can specify in a shell.
+
+-t::
+--type=::
+	Select the memory operation type: load or store (default: load)
+
+-D::
+--dump-raw-samples=::
+	Dump the raw decoded samples on the screen in a format that is easy to parse with
+	one sample per line.
+
+-x::
+--field-separator::
+	Specify the field separator used when dump raw samples (-D option). By default,
+	The separator is the space character.
+
+-C::
+--cpu-list::
+	Restrict dump of raw samples to those provided via this option. Note that the same
+	option can be passed in record mode. It will be interpreted the same way as perf
+	record.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7e25f59..c42b862 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -461,6 +461,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
+BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
 PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
new file mode 100644
index 0000000..c2980b8
--- /dev/null
+++ b/tools/perf/builtin-mem.c
@@ -0,0 +1,238 @@
+#include "builtin.h"
+#include "perf.h"
+
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+#include "util/tool.h"
+#include "util/session.h"
+
+#define MEM_OPERATION_LOAD	"load"
+#define MEM_OPERATION_STORE	"store"
+
+static const char	*mem_operation		= MEM_OPERATION_LOAD;
+
+struct perf_mem {
+	struct perf_tool	tool;
+	char const		*input_name;
+	symbol_filter_t		annotate_init;
+	bool			hide_unresolved;
+	bool			dump_raw;
+	const char		*cpu_list;
+	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+};
+
+static const char * const mem_usage[] = {
+	"perf mem [<options>] {record <command> |report}",
+	NULL
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	int rec_argc, i = 0, j;
+	const char **rec_argv;
+	char event[64];
+	int ret;
+
+	rec_argc = argc + 4;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+	if (!rec_argv)
+		return -1;
+
+	rec_argv[i++] = strdup("record");
+	if (!strcmp(mem_operation, MEM_OPERATION_LOAD))
+		rec_argv[i++] = strdup("-l");
+	rec_argv[i++] = strdup("-d");
+	rec_argv[i++] = strdup("-e");
+
+	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
+		sprintf(event, "cpu/mem-stores/pp");
+	else
+		sprintf(event, "cpu/mem-loads/pp");
+
+	rec_argv[i++] = strdup(event);
+	for (j = 1; j < argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	ret = cmd_record(i, rec_argv, NULL);
+	free(rec_argv);
+	return ret;
+}
+
+static int
+dump_raw_samples(struct perf_tool *tool,
+		 union perf_event *event,
+		 struct perf_sample *sample,
+		 struct perf_evsel *evsel __maybe_unused,
+		 struct machine *machine)
+{
+	struct perf_mem *mem = container_of(tool, struct perf_mem, tool);
+	struct addr_location al;
+	const char *fmt;
+
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+				mem->annotate_init) < 0) {
+		fprintf(stderr, "problem processing %d event, skipping it.\n",
+				event->header.type);
+		return -1;
+	}
+
+	if (al.filtered || (mem->hide_unresolved && al.sym == NULL))
+		return 0;
+
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
+	if (symbol_conf.field_sep) {
+		fmt = "%d%s%d%s0x%"PRIx64"%s0x%"PRIx64"%s%"PRIu64
+		      "%s0x%"PRIx64"%s%s:%s\n";
+	} else {
+		fmt = "%5d%s%5d%s0x%016"PRIx64"%s0x016%"PRIx64
+		      "%s%5"PRIu64"%s0x%06"PRIx64"%s%s:%s\n";
+		symbol_conf.field_sep = " ";
+	}
+
+	printf( fmt,
+		sample->pid,
+		symbol_conf.field_sep,
+		sample->tid,
+		symbol_conf.field_sep,
+		event->ip.ip,
+		symbol_conf.field_sep,
+		sample->addr,
+		symbol_conf.field_sep,
+		sample->weight,
+		symbol_conf.field_sep,
+		sample->dsrc,
+		symbol_conf.field_sep,
+		al.map ? (al.map->dso ? al.map->dso->long_name : "???") : "???",
+		al.sym ? al.sym->name : "???");
+
+	return 0;
+}
+
+static int process_sample_event(struct perf_tool *tool,
+				union perf_event *event,
+				struct perf_sample *sample,
+                                struct perf_evsel *evsel,
+				struct machine *machine)
+{
+	return dump_raw_samples(tool, event, sample, evsel, machine);
+}
+
+static int report_raw_events(struct perf_mem *mem)
+{
+	int err = -EINVAL;
+	int ret;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 0, false, &mem->tool);
+
+	if (session == NULL)
+		return -ENOMEM;
+
+	if (mem->cpu_list) {
+		ret = perf_session__cpu_bitmap(session, mem->cpu_list,
+					       mem->cpu_bitmap);
+		if (ret)
+			goto out_delete;
+	}
+
+	if (symbol__init() < 0)
+		return -1;
+
+	printf("# PID, TID, IP, ADDR, COST, DSRC, SYMBOL\n");
+
+	err = perf_session__process_events(session, &mem->tool);
+	if (err)
+		return err;
+
+	return 0;
+
+out_delete:
+	perf_session__delete(session);
+	return err;
+}
+
+static int report_events(int argc, const char **argv, struct perf_mem *mem)
+{
+	const char **rep_argv;
+	int ret, i = 0, j, rep_argc;
+
+	if (mem->dump_raw)
+		return report_raw_events(mem);
+
+	rep_argc = argc + 3;
+	rep_argv = calloc(rep_argc + 1, sizeof(char *));
+	if (!rep_argv)
+		return -1;
+
+	rep_argv[i++] = strdup("report");
+	rep_argv[i++] = strdup("--mem-mode");
+	rep_argv[i++] = strdup("-n"); /* display number of samples */
+
+	/*
+	 * there is no cost associated with stores, so don't print
+	 * the column
+	 */
+	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
+		rep_argv[i++] = strdup("--sort=mem,sym,dso,symbol_daddr,dso_daddr,tlb,locked");
+
+	for (j = 1; j < argc; j++, i++)
+		rep_argv[i] = argv[j];
+
+	ret = cmd_report(i, rep_argv, NULL);
+	free(rep_argv);
+	return ret;
+}
+
+int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	struct stat st;
+	struct perf_mem mem = {
+		.tool = {
+			.sample		= process_sample_event,
+			.mmap		= perf_event__process_mmap,
+			.comm		= perf_event__process_comm,
+			.lost		= perf_event__process_lost,
+			.fork		= perf_event__process_fork,
+			.build_id	= perf_event__process_build_id,
+			.ordered_samples= true,
+		},
+		.input_name		 = "perf.data",
+	};
+	const struct option mem_options[] = {
+		OPT_STRING('t', "type", &mem_operation,
+			   "type", "memory operations(load/store)"),
+		OPT_BOOLEAN('D', "dump-raw-samples", &mem.dump_raw,
+			    "dump raw samples in ASCII"),
+		OPT_BOOLEAN('U', "hide-unresolved", &mem.hide_unresolved,
+			    "Only display entries resolved to a symbol"),
+		OPT_STRING('i', "input", &input_name, "file", "input file name"),
+		OPT_STRING('C', "cpu", &mem.cpu_list, "cpu", "list of cpus to profile"),
+		OPT_STRING('x', "field-separator", &symbol_conf.field_sep, "separator",
+			   "separator for columns, no spaces will be added between "
+			   "columns '.' is reserved."),
+		OPT_END()
+	};
+
+	argc = parse_options(argc, argv, mem_options, mem_usage,
+                        PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (!argc || !(strncmp(argv[0], "rec", 3) || mem_operation))
+		usage_with_options(mem_usage, mem_options);
+
+	if (!mem.input_name || !strlen(mem.input_name)) {
+		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
+			mem.input_name = "-";
+		else
+			mem.input_name = "perf.data";
+	}
+
+        if (!strncmp(argv[0], "rec", 3))
+		return __cmd_record(argc, argv);
+	else if (!strncmp(argv[0], "rep", 3))
+		return report_events(argc, argv, &mem);
+	else
+		usage_with_options(mem_usage, mem_options);
+
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 08143bd..b210d62 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -36,6 +36,7 @@ extern int cmd_kvm(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
+extern int cmd_mem(int argc, const char **argv, const char *prefix);
 
 extern int find_scripts(char **scripts_array, char **scripts_path_array);
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 3e86bbd..2c5b621 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -24,3 +24,4 @@ perf-kmem			mainporcelain common
 perf-lock			mainporcelain common
 perf-kvm			mainporcelain common
 perf-test			mainporcelain common
+perf-mem			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index e968373..ccdf32d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -60,6 +60,7 @@ static struct cmd_struct commands[] = {
 	{ "trace",	cmd_trace,	0 },
 #endif
 	{ "inject",	cmd_inject,	0 },
+	{ "mem",	cmd_mem,	0 },
 };
 
 struct pager_config {
-- 
1.7.9.5

