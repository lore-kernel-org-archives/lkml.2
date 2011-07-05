Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1GEBaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 21:30:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:47520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1GEBaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 21:30:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,476,1304319600"; 
   d="scan'208";a="23390166"
Subject: Re: [PATCH 4/4] perf, tool: Add new command "perf mem"
From: Lin Ming <ming.m.lin@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110704220023.GI15637@one.firstfloor.org>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-5-git-send-email-ming.m.lin@intel.com>
	 <20110704220023.GI15637@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 09:35:34 +0800
Message-ID: <1309829734.18875.99.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 06:00 +0800, Andi Kleen wrote:
> > diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> > index 032ba63..221d1d8 100644
> > --- a/tools/perf/Makefile
> > +++ b/tools/perf/Makefile
> > @@ -372,6 +372,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
> >  BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
> >  BUILTIN_OBJS += $(OUTPUT)builtin-test.o
> >  BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
> > +BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
> 
> File seems to be missing in the patch. Forgot a git add?
> 
> Also need a manpage for it.

Ah, sorry for the missing. Here it is.

>From 6fb31b6fb63d73624c6bffbe81a013ca915da077 Mon Sep 17 00:00:00 2001
From: Lin Ming <ming.m.lin@intel.com>
Date: Mon, 4 Jul 2011 07:33:36 +0000
Subject: [PATCH] perf, tool: Add new command "perf mem"

Adds new command "perf mem" to monitor memory load/store events.

$ perf mem

 usage: perf mem [<options>] {record <command> |report}

    -t, --type <type>     memory operations(load/store)
    -L, --latency <n>     latency to sample(only for load op)

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/Documentation/perf-mem.txt |   38 +++++
 tools/perf/Makefile                   |    1 +
 tools/perf/builtin-mem.c              |  269 +++++++++++++++++++++++++++++++++
 tools/perf/builtin-record.c           |    8 +
 tools/perf/builtin-script.c           |    6 +-
 tools/perf/builtin.h                  |    1 +
 tools/perf/perf.c                     |    1 +
 tools/perf/util/event.h               |    2 +
 tools/perf/util/evsel.c               |   10 ++
 tools/perf/util/parse-events.c        |   40 ++++-
 tools/perf/util/parse-events.h        |    2 +-
 11 files changed, 368 insertions(+), 10 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-mem.txt
 create mode 100644 tools/perf/builtin-mem.c

diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
new file mode 100644
index 0000000..8ee5794
--- /dev/null
+++ b/tools/perf/Documentation/perf-mem.txt
@@ -0,0 +1,38 @@
+perf-mem(1)
+===========
+
+NAME
+----
+perf-mem - Monitor memory load/store operation
+
+SYNOPSIS
+--------
+[verse]
+'perf mem' -t load [-L <n>] record <command>
+'perf mem' -t store record <command>
+'perf mem' -t load report
+'perf mem' -t store report
+
+DESCRIPTION
+-----------
+"perf mem -t <TYPE> record" runs a command and gathers memory operation data
+from it, into perf.data.
+
+"perf mem -t <TYPE> report" displays the result.
+
+OPTIONS
+-------
+<command>...::
+	Any command you can specify in a shell.
+
+-t::
+--type=::
+	Select the memory operation type: load or store
+
+-L::
+--latency=::
+	Select the memory load latency to sample. Only used for memory load operation.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 032ba63..221d1d8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -372,6 +372,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
+BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
new file mode 100644
index 0000000..d00fedf
--- /dev/null
+++ b/tools/perf/builtin-mem.c
@@ -0,0 +1,269 @@
+#include "builtin.h"
+#include "perf.h"
+
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+
+static char			const *input_name		= "perf.data";
+static const char		*mem_operation;
+static int			latency_value			= 3;
+
+#define MEM_OPEARTION_LOAD	"load"
+#define MEM_OPERATION_STORE	"store"
+
+static const char * const mem_usage[] = {
+	"perf mem [<options>] {record <command> |report}",
+	NULL
+};
+
+static const struct option mem_options[] = {
+	OPT_STRING('t', "type", &mem_operation, "type", "memory operations(load/store)"),
+	OPT_INTEGER('L', "latency", &latency_value, "latency to sample(only for load op)"),
+	OPT_END()
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	int rec_argc, i = 0, j;
+	const char **rec_argv;
+	char event[20];
+
+	rec_argc = argc + 4;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+	rec_argv[i++] = strdup("record");
+	rec_argv[i++] = strdup("-l");
+	rec_argv[i++] = strdup("-d");
+	rec_argv[i++] = strdup("-e");
+	if (!strcmp(mem_operation, MEM_OPEARTION_LOAD))
+		sprintf(event, "mem-load:%04x:p", latency_value);
+	else
+		sprintf(event, "mem-store:p");
+	rec_argv[i++] = strdup(event);
+	for (j = 1; j < argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+#define LEN 56
+struct perf_mem_data {
+	char name[LEN];
+	u64 count;
+	u64 latency;
+};
+
+static struct perf_mem_data load_data[7][4][4] = {
+ [MEM_LOAD_L1] = {
+	[MEM_LOAD_LOCAL >> 2] = {
+		[MEM_LOAD_MODIFIED >> 4] = {
+			"L1-local", 0, 0
+		},
+	},
+ },
+ [MEM_LOAD_L2] = {
+	[MEM_LOAD_SNOOP >> 2] = {
+		[MEM_LOAD_MODIFIED >> 4] = {
+			"L2-snoop", 0, 0
+		},
+	},
+	[MEM_LOAD_LOCAL >> 2] = {
+		[MEM_LOAD_MODIFIED >> 4] = {
+			"L2-local", 0, 0
+		},
+	},
+ },
+ [MEM_LOAD_L3] = {
+	[MEM_LOAD_SNOOP >> 2] = {
+		[MEM_LOAD_MODIFIED >> 4] = {
+			"L3-snoop, found M", 0, 0
+		},
+		[MEM_LOAD_SHARED >> 4] = {
+			"L3-snoop, found no M", 0, 0
+		},
+		[MEM_LOAD_INVALID >> 4] = {
+			"L3-snoop, no coherency actions", 0, 0
+		},
+	},
+ },
+ [MEM_LOAD_RAM] = {
+	[MEM_LOAD_SNOOP >> 2] = {
+		[MEM_LOAD_SHARED >> 4] = {
+			"L3-miss, snoop, shared", 0, 0
+		},
+	},
+	[MEM_LOAD_LOCAL >> 2] = {
+		[MEM_LOAD_EXCLUSIVE >> 4] = {
+			"L3-miss, local, exclusive", 0, 0
+		},
+		[MEM_LOAD_SHARED >> 4] = {
+			"L3-miss, local, shared", 0, 0
+		},
+	},
+	[MEM_LOAD_REMOTE >> 2] = {
+		[MEM_LOAD_EXCLUSIVE >> 4] = {
+			"L3-miss, remote, exclusive", 0, 0
+		},
+		[MEM_LOAD_SHARED >> 4] = {
+			"L3-miss, remote, shared", 0, 0
+		},
+	},
+ },
+ [MEM_LOAD_UNKNOWN + 4] = {
+	[MEM_LOAD_TOGGLE] = {
+		[0] = {
+			"Unknown L3", 0, 0
+		},
+	},
+ },
+ [MEM_LOAD_IO + 4] = {
+	[MEM_LOAD_TOGGLE] = {
+		[0] = {
+			"IO", 0, 0
+		},
+	},
+ },
+ [MEM_LOAD_UNCACHED + 4] = {
+	[MEM_LOAD_TOGGLE] = {
+		[0] = {
+			"Uncached", 0, 0
+		},
+	},
+ },
+};
+
+static struct perf_mem_data store_data[6] = {
+	{"data-cache hit", 0, 0},
+	{"data-cache miss", 0, 0},
+	{"STLB hit", 0, 0},
+	{"STLB miss", 0, 0},
+	{"Locked access", 0, 0},
+	{"Unlocked access", 0, 0},
+};
+
+static void dump_load_data(void)
+{
+	int i, j, k;
+
+	printf("Memory load operation statistics\n");
+	printf("================================\n");
+	for (i = 0; i < 7; i++)
+		for (j = 0; j < 4; j++)
+			for (k = 0; k < 4; k++) {
+				if (!load_data[i][j][k].name[0])
+					continue;
+				printf("%30s: total latency=%8" PRId64 ", count=%8" PRId64 "(avg=%" PRId64 ")\n",
+					load_data[i][j][k].name,
+					load_data[i][j][k].latency,
+					load_data[i][j][k].count,
+					load_data[i][j][k].count ?
+					(load_data[i][j][k].latency /
+					load_data[i][j][k].count) : 0);
+			}
+}
+
+static void dump_store_data(void)
+{
+	int i;
+
+	printf("Memory store operation statistics\n");
+	printf("=================================\n");
+	for (i = 0; i < 6; i++)
+		printf("%30s: %8" PRId64 "\n", store_data[i].name,
+			store_data[i].count);
+}
+
+static void process_load_sample(u64 latency, u64 extra)
+{
+	int i, j, k;
+
+	i = extra & 0x3;
+	j = (extra >> 2) & 0x3;
+	k = (extra >> 4) & 0x3;
+
+	if (j == 0)
+		i += 4;
+
+	load_data[i][j][k].latency += latency;
+	load_data[i][j][k].count++;
+}
+
+static void process_store_sample(u64 extra)
+{
+	if (extra & MEM_STORE_DCU_HIT)
+		store_data[0].count++;
+	else
+		store_data[1].count++;
+
+	if (extra & MEM_STORE_STLB_HIT)
+		store_data[2].count++;
+	else
+		store_data[3].count++;
+
+	if (extra & MEM_STORE_LOCKED_ACCESS)
+		store_data[4].count++;
+	else
+		store_data[5].count++;
+}
+
+static int process_sample_event(union perf_event *event __unused, struct perf_sample *sample,
+                                struct perf_evsel *evsel __unused, struct perf_session *session __unused)
+{
+	if (!strcmp(mem_operation, MEM_OPEARTION_LOAD))
+		process_load_sample(sample->latency, sample->extra);
+	else
+		process_store_sample(sample->extra);
+
+	return 0;
+}
+
+static struct perf_event_ops event_ops = {
+	.sample			= process_sample_event,
+	.mmap			= perf_event__process_mmap,
+	.comm			= perf_event__process_comm,
+	.lost			= perf_event__process_lost,
+	.fork			= perf_event__process_task,
+	.ordered_samples	= true,
+};
+
+static int report_events(void)
+{
+	int err = -EINVAL;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 0, false, &event_ops);
+
+	if (symbol__init() < 0)
+		return -1;
+
+	if (session == NULL)
+		return -ENOMEM;
+
+	err = perf_session__process_events(session, &event_ops);
+
+	if (!strcmp(mem_operation, MEM_OPEARTION_LOAD))
+		dump_load_data();
+	else
+		dump_store_data();
+
+	perf_session__delete(session);
+	return err;
+}
+
+int cmd_mem(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, mem_options, mem_usage,
+                        PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (!argc || !mem_operation)
+		usage_with_options(mem_usage, mem_options);
+
+        if (!strncmp(argv[0], "rec", 3))
+		return __cmd_record(argc, argv);
+	else if (!strncmp(argv[0], "rep", 3))
+		return report_events();
+	else
+		usage_with_options(mem_usage, mem_options);
+
+	return 0;
+}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8e2c857..8ebdcdd 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -63,6 +63,7 @@ static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
 static bool			sample_time			=  false;
+static bool			latency_data			=  false;
 static bool			no_buildid			=  false;
 static bool			no_buildid_cache		=  false;
 static struct perf_evlist	*evsel_list;
@@ -199,6 +200,11 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 		attr->mmap_data = track;
 	}
 
+	if (latency_data) {
+		attr->sample_type	|= PERF_SAMPLE_LATENCY;
+		attr->sample_type	|= PERF_SAMPLE_EXTRA;
+	}
+
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
@@ -780,6 +786,8 @@ const struct option record_options[] = {
 	OPT_BOOLEAN('T', "timestamp", &sample_time, "Sample timestamps"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
+	OPT_BOOLEAN('l', "latency", &latency_data,
+		    "Latency data"),
 	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid_cache,
 		    "do not update the buildid cache"),
 	OPT_BOOLEAN('B', "no-buildid", &no_buildid,
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3056b45..c7489a6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -140,7 +140,7 @@ static int perf_event_attr__check_stype(struct perf_event_attr *attr,
 		return 0;
 
 	if (output[type].user_set) {
-		evname = __event_name(attr->type, attr->config);
+		evname = __event_name(attr->type, attr->config, attr->config1);
 		pr_err("Samples for '%s' event do not have %s attribute set. "
 		       "Cannot print '%s' field.\n",
 		       evname, sample_msg, output_field2str(field));
@@ -149,7 +149,7 @@ static int perf_event_attr__check_stype(struct perf_event_attr *attr,
 
 	/* user did not ask for it explicitly so remove from the default list */
 	output[type].fields &= ~field;
-	evname = __event_name(attr->type, attr->config);
+	evname = __event_name(attr->type, attr->config, attr->config1);
 	pr_debug("Samples for '%s' event do not have %s attribute set. "
 		 "Skipping '%s' field.\n",
 		 evname, sample_msg, output_field2str(field));
@@ -292,7 +292,7 @@ static void print_sample_start(struct perf_sample *sample,
 			if (event)
 				evname = event->name;
 		} else
-			evname = __event_name(attr->type, attr->config);
+			evname = __event_name(attr->type, attr->config, 0);
 
 		printf("%s: ", evname ? evname : "(unknown)");
 	}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 4702e24..419ba8f 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -36,5 +36,6 @@ extern int cmd_lock(int argc, const char **argv, const char *prefix);
 extern int cmd_kvm(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
+extern int cmd_mem(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index ec635b7..20c53f8 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -332,6 +332,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "kvm",	cmd_kvm,	0 },
 		{ "test",	cmd_test,	0 },
 		{ "inject",	cmd_inject,	0 },
+		{ "mem",	cmd_mem,	0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1d7f664..1392867 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -76,6 +76,8 @@ struct perf_sample {
 	u64 id;
 	u64 stream_id;
 	u64 period;
+	u64 latency;
+	u64 extra;
 	u32 cpu;
 	u32 raw_size;
 	void *raw_data;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a03a36b..8eab351 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -405,6 +405,16 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_LATENCY) {
+		data->latency = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_EXTRA) {
+		data->extra = *array;
+		array++;
+	}
+
 	if (type & PERF_SAMPLE_READ) {
 		fprintf(stderr, "PERF_SAMPLE_READ is unsuported for now\n");
 		return -1;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..9f3bcb9 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -40,6 +40,8 @@ static struct event_symbol event_symbols[] = {
   { CHW(BRANCH_INSTRUCTIONS),		"branch-instructions",		"branches"		},
   { CHW(BRANCH_MISSES),			"branch-misses",		""			},
   { CHW(BUS_CYCLES),			"bus-cycles",			""			},
+  { CHW(MEM_LOAD),			"mem-load",			""			},
+  { CHW(MEM_STORE),			"mem-store",			""			},
 
   { CSW(CPU_CLOCK),			"cpu-clock",			""			},
   { CSW(TASK_CLOCK),			"task-clock",			""			},
@@ -297,15 +299,18 @@ const char *event_name(struct perf_evsel *evsel)
 	if (evsel->name)
 		return evsel->name;
 
-	return __event_name(type, config);
+	return __event_name(type, config, evsel->attr.config1);
 }
 
-const char *__event_name(int type, u64 config)
+const char *__event_name(int type, u64 config, u64 extra)
 {
 	static char buf[32];
+	int n;
 
 	if (type == PERF_TYPE_RAW) {
-		sprintf(buf, "raw 0x%" PRIx64, config);
+		n = sprintf(buf, "raw 0x%" PRIx64, config);
+		if (extra)
+			sprintf(buf + n, ":%#" PRIx64, extra);
 		return buf;
 	}
 
@@ -668,6 +673,7 @@ static enum event_result
 parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
+	u64 config;
 	unsigned int i;
 	int n;
 
@@ -676,7 +682,18 @@ parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
 		if (n > 0) {
 			attr->type = event_symbols[i].type;
 			attr->config = event_symbols[i].config;
-			*strp = str + n;
+			str += n;
+			*strp = str;
+
+			if (*str++ == ':') {
+				n = hex2u64(str + 1, &config);
+				if (n > 0) {
+					attr->config1 = config;
+					str += n + 1;
+					*strp = str;
+				}
+			}
+
 			return EVT_HANDLED;
 		}
 	}
@@ -694,9 +711,20 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
-		*strp = str + n + 1;
+		str += n + 1;
+		*strp = str;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
+
+		if (*str++ == ':') {
+			n = hex2u64(str + 1, &config);
+			if (n > 0) {
+				attr->config1 = config;
+				str += n + 1;
+				*strp = str;
+			}
+		}
+
 		return EVT_HANDLED;
 	}
 	return EVT_FAILED;
@@ -1078,7 +1106,7 @@ void print_events(const char *event_glob)
 
 	printf("\n");
 	printf("  %-50s [%s]\n",
-		"rNNN (see 'perf list --help' on how to encode it)",
+		"rNNN[:EEE] (see 'perf list --help' on how to encode it)",
 	       event_type_descriptors[PERF_TYPE_RAW]);
 	printf("\n");
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 746d3fc..904c8c4 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -22,7 +22,7 @@ extern bool have_tracepoints(struct list_head *evlist);
 
 const char *event_type(int type);
 const char *event_name(struct perf_evsel *event);
-extern const char *__event_name(int type, u64 config);
+extern const char *__event_name(int type, u64 config, u64 extra);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
-- 
1.7.5.1



