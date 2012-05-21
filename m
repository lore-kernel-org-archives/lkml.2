Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2EUHhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:37:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2EUHh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:37:29 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: zheng.z.yan@intel.com
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] perf, tool: Add support to reuse event grammar to parse out terms
Date: Mon, 21 May 2012 09:36:51 +0200
Message-Id: <1337585813-3349-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337585813-3349-1-git-send-email-jolsa@redhat.com>
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
 <1337585813-3349-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to reuse the event grammar for parsing aliased terms.
The obvious reason is we dont need to add new code when there's
already support for this in event grammar.

Doing this by adding terms and event start entries into event
parse grammar. The grammar forks on the begining based on the
starting token, which is supplied via bison interface into the
lexer.  The lexer then returns the starting token as the first
token, thus making the grammar switch accordingly.

Currently 2 starting tokens/grammars are supported:
	PE_START_TERMS, PE_START_EVENTS

The PE_START_TERMS related grammar uses 'event_config' part
of the grammar for term parsing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |   28 +++++++++++++++++++++++++---
 tools/perf/util/parse-events.h |    5 +++++
 tools/perf/util/parse-events.l |   13 +++++++++++++
 tools/perf/util/parse-events.y |   12 ++++++++++++
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 64d936b..5f7bf0e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -12,6 +12,7 @@
 #include "header.h"
 #include "debugfs.h"
 #include "parse-events-bison.h"
+#define YY_EXTRA_TYPE int
 #include "parse-events-flex.h"
 #include "pmu.h"
 
@@ -793,13 +794,13 @@ int parse_events_modifier(struct list_head *list, char *str)
 	return 0;
 }
 
-static int parse_events__scanner(const char *str, void *data)
+static int parse_events__scanner(const char *str, void *data, int start_token)
 {
 	YY_BUFFER_STATE buffer;
 	void *scanner;
 	int ret;
 
-	ret = parse_events_lex_init(&scanner);
+	ret = parse_events_lex_init_extra(start_token, &scanner);
 	if (ret)
 		return ret;
 
@@ -816,6 +817,27 @@ static int parse_events__scanner(const char *str, void *data)
 	return ret;
 }
 
+/*
+ * parse event config string, return a list of event terms.
+ */
+int parse_events_terms(struct list_head *terms, const char *str)
+{
+	struct parse_events_data__terms data = {
+		.terms = NULL,
+	};
+	int ret;
+
+	ret = parse_events__scanner(str, &data, PE_START_TERMS);
+	if (!ret) {
+		list_splice(data.terms, terms);
+		free(data.terms);
+		return 0;
+	}
+
+	parse_events__free_terms(data.terms);
+	return ret;
+}
+
 int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 {
 	struct parse_events_data__events data = {
@@ -824,7 +846,7 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 	};
 	int ret;
 
-	ret = parse_events__scanner(str, &data);
+	ret = parse_events__scanner(str, &data, PE_START_EVENTS);
 	if (!ret) {
 		int entries = data.idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &data.list, entries);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index fa2b19b..9896eda 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -33,6 +33,7 @@ extern int parse_events_option(const struct option *opt, const char *str,
 			       int unset);
 extern int parse_events(struct perf_evlist *evlist, const char *str,
 			int unset);
+extern int parse_events_terms(struct list_head *terms, const char *str);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
@@ -68,6 +69,10 @@ struct parse_events_data__events {
 	int idx;
 };
 
+struct parse_events_data__terms {
+	struct list_head *terms;
+};
+
 int parse_events__is_hardcoded_term(struct parse_events__term *term);
 int parse_events__term_num(struct parse_events__term **_term,
 			   int type_term, char *config, long num);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 329794e..488362e 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -79,6 +79,19 @@ modifier_event	[ukhpGH]{1,8}
 modifier_bp	[rwx]
 
 %%
+
+%{
+	{
+		int start_token;
+
+		start_token = (int) parse_events_get_extra(yyscanner);
+		if (start_token) {
+			parse_events_set_extra(NULL, yyscanner);
+			return start_token;
+		}
+         }
+%}
+
 cpu-cycles|cycles				{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
 stalled-cycles-frontend|idle-cycles-frontend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
 stalled-cycles-backend|idle-cycles-backend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 2a93d5c..9525c45 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -25,6 +25,7 @@ do { \
 
 %}
 
+%token PE_START_EVENTS PE_START_TERMS
 %token PE_VALUE PE_VALUE_SYM PE_RAW PE_TERM
 %token PE_NAME
 %token PE_MODIFIER_EVENT PE_MODIFIER_BP
@@ -60,6 +61,11 @@ do { \
 }
 %%
 
+start:
+PE_START_EVENTS events
+|
+PE_START_TERMS  terms
+
 events:
 events ',' event | event
 
@@ -209,6 +215,12 @@ PE_RAW
 	$$ = list;
 }
 
+terms: event_config
+{
+	struct parse_events_data__terms *data = _data;
+	data->terms = $1;
+}
+
 event_config:
 event_config ',' event_term
 {
-- 
1.7.7.6

