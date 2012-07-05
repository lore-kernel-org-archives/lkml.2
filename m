Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab2GEPsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:48:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:59140 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030217Ab2GEPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/20] perf tools: Split event symbols arrays to hw and sw parts
Date: Thu,  5 Jul 2012 12:45:18 -0300
Message-Id: <1341503118-13198-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

It'll be convenient in upcoming patch to access hw event symbols
strings via enum perf_hw_id indexes. In order not to duplicate
the data, creating two separate arrays:

  event_symbols_hw for enum perf_hw_id events
  event_symbols_sw for enum perf_sw_ids events

Changing the current event list code to follow the change.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1341352848-11833-7-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |  174 +++++++++++++++++++++++++++-------------
 1 file changed, 117 insertions(+), 57 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1dc44dc..1aa721d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -19,8 +19,6 @@
 #define MAX_NAME_LEN 100
 
 struct event_symbol {
-	u8		type;
-	u64		config;
 	const char	*symbol;
 	const char	*alias;
 };
@@ -30,30 +28,86 @@ extern int parse_events_debug;
 #endif
 int parse_events_parse(void *data, void *scanner);
 
-#define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
-#define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
-
-static struct event_symbol event_symbols[] = {
-  { CHW(CPU_CYCLES),			"cpu-cycles",			"cycles"		},
-  { CHW(STALLED_CYCLES_FRONTEND),	"stalled-cycles-frontend",	"idle-cycles-frontend"	},
-  { CHW(STALLED_CYCLES_BACKEND),	"stalled-cycles-backend",	"idle-cycles-backend"	},
-  { CHW(INSTRUCTIONS),			"instructions",			""			},
-  { CHW(CACHE_REFERENCES),		"cache-references",		""			},
-  { CHW(CACHE_MISSES),			"cache-misses",			""			},
-  { CHW(BRANCH_INSTRUCTIONS),		"branch-instructions",		"branches"		},
-  { CHW(BRANCH_MISSES),			"branch-misses",		""			},
-  { CHW(BUS_CYCLES),			"bus-cycles",			""			},
-  { CHW(REF_CPU_CYCLES),		"ref-cycles",			""			},
-
-  { CSW(CPU_CLOCK),			"cpu-clock",			""			},
-  { CSW(TASK_CLOCK),			"task-clock",			""			},
-  { CSW(PAGE_FAULTS),			"page-faults",			"faults"		},
-  { CSW(PAGE_FAULTS_MIN),		"minor-faults",			""			},
-  { CSW(PAGE_FAULTS_MAJ),		"major-faults",			""			},
-  { CSW(CONTEXT_SWITCHES),		"context-switches",		"cs"			},
-  { CSW(CPU_MIGRATIONS),		"cpu-migrations",		"migrations"		},
-  { CSW(ALIGNMENT_FAULTS),		"alignment-faults",		""			},
-  { CSW(EMULATION_FAULTS),		"emulation-faults",		""			},
+static struct event_symbol event_symbols_hw[PERF_COUNT_HW_MAX] = {
+	[PERF_COUNT_HW_CPU_CYCLES] = {
+		.symbol = "cpu-cycles",
+		.alias  = "cycles",
+	},
+	[PERF_COUNT_HW_INSTRUCTIONS] = {
+		.symbol = "instructions",
+		.alias  = "",
+	},
+	[PERF_COUNT_HW_CACHE_REFERENCES] = {
+		.symbol = "cache-references",
+		.alias  = "",
+	},
+	[PERF_COUNT_HW_CACHE_MISSES] = {
+		.symbol = "cache-misses",
+		.alias  = "",
+	},
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = {
+		.symbol = "branch-instructions",
+		.alias  = "branches",
+	},
+	[PERF_COUNT_HW_BRANCH_MISSES] = {
+		.symbol = "branch-misses",
+		.alias  = "",
+	},
+	[PERF_COUNT_HW_BUS_CYCLES] = {
+		.symbol = "bus-cycles",
+		.alias  = "",
+	},
+	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = {
+		.symbol = "stalled-cycles-frontend",
+		.alias  = "idle-cycles-frontend",
+	},
+	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = {
+		.symbol = "stalled-cycles-backend",
+		.alias  = "idle-cycles-backend",
+	},
+	[PERF_COUNT_HW_REF_CPU_CYCLES] = {
+		.symbol = "ref-cycles",
+		.alias  = "",
+	},
+};
+
+static struct event_symbol event_symbols_sw[PERF_COUNT_SW_MAX] = {
+	[PERF_COUNT_SW_CPU_CLOCK] = {
+		.symbol = "cpu-clock",
+		.alias  = "",
+	},
+	[PERF_COUNT_SW_TASK_CLOCK] = {
+		.symbol = "task-clock",
+		.alias  = "",
+	},
+	[PERF_COUNT_SW_PAGE_FAULTS] = {
+		.symbol = "page-faults",
+		.alias  = "faults",
+	},
+	[PERF_COUNT_SW_CONTEXT_SWITCHES] = {
+		.symbol = "context-switches",
+		.alias  = "cs",
+	},
+	[PERF_COUNT_SW_CPU_MIGRATIONS] = {
+		.symbol = "cpu-migrations",
+		.alias  = "migrations",
+	},
+	[PERF_COUNT_SW_PAGE_FAULTS_MIN] = {
+		.symbol = "minor-faults",
+		.alias  = "",
+	},
+	[PERF_COUNT_SW_PAGE_FAULTS_MAJ] = {
+		.symbol = "major-faults",
+		.alias  = "",
+	},
+	[PERF_COUNT_SW_ALIGNMENT_FAULTS] = {
+		.symbol = "alignment-faults",
+		.alias  = "",
+	},
+	[PERF_COUNT_SW_EMULATION_FAULTS] = {
+		.symbol = "emulation-faults",
+		.alias  = "",
+	},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
@@ -824,16 +878,13 @@ int is_valid_tracepoint(const char *event_string)
 	return 0;
 }
 
-void print_events_type(u8 type)
+static void __print_events_type(u8 type, struct event_symbol *syms,
+				unsigned max)
 {
-	struct event_symbol *syms = event_symbols;
-	unsigned int i;
 	char name[64];
+	unsigned i;
 
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
-		if (type != syms->type)
-			continue;
-
+	for (i = 0; i < max ; i++, syms++) {
 		if (strlen(syms->alias))
 			snprintf(name, sizeof(name),  "%s OR %s",
 				 syms->symbol, syms->alias);
@@ -845,6 +896,14 @@ void print_events_type(u8 type)
 	}
 }
 
+void print_events_type(u8 type)
+{
+	if (type == PERF_TYPE_SOFTWARE)
+		__print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX);
+	else
+		__print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX);
+}
+
 int print_hwcache_events(const char *event_glob)
 {
 	unsigned int type, op, i, printed = 0;
@@ -872,26 +931,13 @@ int print_hwcache_events(const char *event_glob)
 	return printed;
 }
 
-/*
- * Print the help text for the event symbols:
- */
-void print_events(const char *event_glob)
+static void print_symbol_events(const char *event_glob, unsigned type,
+				struct event_symbol *syms, unsigned max)
 {
-	unsigned int i, type, prev_type = -1, printed = 0, ntypes_printed = 0;
-	struct event_symbol *syms = event_symbols;
+	unsigned i, printed = 0;
 	char name[MAX_NAME_LEN];
 
-	printf("\n");
-	printf("List of pre-defined events (to be used in -e):\n");
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
-		type = syms->type;
-
-		if (type != prev_type && printed) {
-			printf("\n");
-			printed = 0;
-			ntypes_printed++;
-		}
+	for (i = 0; i < max; i++, syms++) {
 
 		if (event_glob != NULL && 
 		    !(strglobmatch(syms->symbol, event_glob) ||
@@ -902,17 +948,31 @@ void print_events(const char *event_glob)
 			snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
 		else
 			strncpy(name, syms->symbol, MAX_NAME_LEN);
-		printf("  %-50s [%s]\n", name,
-			event_type_descriptors[type]);
 
-		prev_type = type;
-		++printed;
+		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
+
+		printed++;
 	}
 
-	if (ntypes_printed) {
-		printed = 0;
+	if (printed)
 		printf("\n");
-	}
+}
+
+/*
+ * Print the help text for the event symbols:
+ */
+void print_events(const char *event_glob)
+{
+
+	printf("\n");
+	printf("List of pre-defined events (to be used in -e):\n");
+
+	print_symbol_events(event_glob, PERF_TYPE_HARDWARE,
+			    event_symbols_hw, PERF_COUNT_HW_MAX);
+
+	print_symbol_events(event_glob, PERF_TYPE_SOFTWARE,
+			    event_symbols_sw, PERF_COUNT_SW_MAX);
+
 	print_hwcache_events(event_glob);
 
 	if (event_glob != NULL)
-- 
1.7.9.2.358.g22243

