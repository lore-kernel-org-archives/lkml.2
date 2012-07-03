Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab2GCWBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316Ab2GCWBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:01:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/10] perf, tool: Add support to specify hw event as pmu event term
Date: Wed,  4 Jul 2012 00:00:45 +0200
Message-Id: <1341352848-11833-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a way to specify hw event as pmu event term like:
 'cpu/event=cycles/u'
 'cpu/event=instructions,.../u'

The 'event=cycles' term needs to be replaced/translated by the hw
events term translation, which is exposed by sysfs 'events' group
attribute.

The 'events' attribute is handled by the pmu alias code, so the
only thing we need to ensure is to map the event name to the proper
sysfs attribute name.

It's possible to use sysfs attribute name as 'event' term value,
or any possible alias for hw event, e.g.:
  cycles                     OR cpu-cycles
  branch_misses              OR branch-misses
  bus_cycles                 OR bus-cycles
  cache_misses               OR cache-misses
  cache_references           OR cache-references
  ref_cycles                 OR ref-cycles
  stalled_cycles_backend     OR stalled-cycles-backend
  stalled_cycles_frontend    OR stalled-cycles-frontend

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |   29 +++++++++++++++++++++++++++++
 tools/perf/util/parse-events.h |    2 ++
 tools/perf/util/parse-events.y |    9 +++++++++
 3 files changed, 40 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6d12b39..a0fb567 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -21,6 +21,11 @@
 struct event_symbol {
 	const char	*symbol;
 	const char	*alias;
+	/*
+	 * The attribute name inside the 'events' sysfs
+	 * group. Only for HW events.
+	 */
+	const char	*sysfs;
 };
 
 #ifdef PARSER_DEBUG
@@ -32,42 +37,52 @@ static struct event_symbol event_symbols_hw[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_CPU_CYCLES] = {
 		.symbol = "cpu-cycles",
 		.alias  = "cycles",
+		.sysfs  = "cycles",
 	},
 	[PERF_COUNT_HW_INSTRUCTIONS] = {
 		.symbol = "instructions",
 		.alias  = "",
+		.sysfs  = "instructions",
 	},
 	[PERF_COUNT_HW_CACHE_REFERENCES] = {
 		.symbol = "cache-references",
 		.alias  = "",
+		.sysfs  = "cache_references",
 	},
 	[PERF_COUNT_HW_CACHE_MISSES] = {
 		.symbol = "cache-misses",
 		.alias  = "",
+		.sysfs  = "cache_misses",
 	},
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = {
 		.symbol = "branch-instructions",
 		.alias  = "branches",
+		.sysfs  = "branch_instructions",
 	},
 	[PERF_COUNT_HW_BRANCH_MISSES] = {
 		.symbol = "branch-misses",
 		.alias  = "",
+		.sysfs  = "branch_misses",
 	},
 	[PERF_COUNT_HW_BUS_CYCLES] = {
 		.symbol = "bus-cycles",
 		.alias  = "",
+		.sysfs  = "bus_cycles",
 	},
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = {
 		.symbol = "stalled-cycles-frontend",
 		.alias  = "idle-cycles-frontend",
+		.sysfs  = "stalled_cycles_frontend",
 	},
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = {
 		.symbol = "stalled-cycles-backend",
 		.alias  = "idle-cycles-backend",
+		.sysfs  = "stalled_cycles_backend",
 	},
 	[PERF_COUNT_HW_REF_CPU_CYCLES] = {
 		.symbol = "ref-cycles",
 		.alias  = "",
+		.sysfs  = "ref_cycles",
 	},
 };
 
@@ -1037,6 +1052,20 @@ int parse_events__term_str(struct parse_events__term **term,
 			config, str, 0);
 }
 
+int parse_events__term_sym_hw(struct parse_events__term **term,
+			      char *config, unsigned idx)
+{
+	struct event_symbol *sym;
+
+	BUG_ON(idx >= PERF_COUNT_HW_MAX);
+	sym = &event_symbols_hw[idx];
+	BUG_ON(!sym->sysfs);
+
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_STR,
+			PARSE_EVENTS__TERM_TYPE_USER, config,
+			(char *) sym->sysfs, 0);
+}
+
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ee9c218..eaf2fd7 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -76,6 +76,8 @@ int parse_events__term_num(struct parse_events__term **_term,
 			   int type_term, char *config, long num);
 int parse_events__term_str(struct parse_events__term **_term,
 			   int type_term, char *config, char *str);
+int parse_events__term_sym_hw(struct parse_events__term **term,
+			      char *config, unsigned idx);
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term);
 void parse_events__free_terms(struct list_head *terms);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 2bc5fbf..9c74d8a 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -269,6 +269,15 @@ PE_NAME '=' PE_VALUE
 	$$ = term;
 }
 |
+PE_NAME '=' PE_VALUE_SYM_HW
+{
+	struct parse_events__term *term;
+	int config = $3 & 255;
+
+	ABORT_ON(parse_events__term_sym_hw(&term, $1, config));
+	$$ = term;
+}
+|
 PE_NAME
 {
 	struct parse_events__term *term;
-- 
1.7.10.4

