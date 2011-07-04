Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1GDH4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:56:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:47700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab1GDH4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:56:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="23490061"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] perf, tool: Add new command "perf mem"
Date: Mon,  4 Jul 2011 08:02:05 +0000
Message-Id: <1309766525-14089-5-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds new command "perf mem" to monitor memory load/store events.

$ perf mem

 usage: perf mem [<options>] {record <command> |report}

    -t, --type <type>     memory operations(load/store)
    -L, --latency <n>     latency to sample(only for load op)

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/Makefile            |    1 +
 tools/perf/builtin-record.c    |    8 ++++++++
 tools/perf/builtin-script.c    |    6 +++---
 tools/perf/builtin.h           |    1 +
 tools/perf/perf.c              |    1 +
 tools/perf/util/event.h        |    2 ++
 tools/perf/util/evsel.c        |   10 ++++++++++
 tools/perf/util/parse-events.c |   40 ++++++++++++++++++++++++++++++++++------
 tools/perf/util/parse-events.h |    2 +-
 9 files changed, 61 insertions(+), 10 deletions(-)

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

