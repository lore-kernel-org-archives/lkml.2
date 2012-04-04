Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2DDUWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:22:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab2DDUWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:22:06 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 8/8] perf, tool: Use allocated list for each parsed event
Date: Wed,  4 Apr 2012 22:21:38 +0200
Message-Id: <1333570898-10505-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333570898-10505-1-git-send-email-jolsa@redhat.com>
References: <1333570898-10505-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from using static temporary event list into dynamically
allocated one. This way we dont need to pass temp list to the
parse_events_parse which makes the interface more clear.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |   39 ++++++++++++++---------
 tools/perf/util/parse-events.h |   16 +++------
 tools/perf/util/parse-events.y |   69 ++++++++++++++++++++++++++++++---------
 3 files changed, 83 insertions(+), 41 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b6136fd..d4abd00 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -26,8 +26,7 @@ struct event_symbol {
 #ifdef PARSER_DEBUG
 extern int parse_events_debug;
 #endif
-int parse_events_parse(struct list_head *list, struct list_head *list_tmp,
-		       int *idx);
+int parse_events_parse(struct list_head *list, int *idx);
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
@@ -358,20 +357,30 @@ const char *__event_name(int type, u64 config)
 	return "unknown";
 }
 
-static int add_event(struct list_head *list, int *idx,
+static int add_event(struct list_head **_list, int *idx,
 		     struct perf_event_attr *attr, char *name)
 {
 	struct perf_evsel *evsel;
+	struct list_head *list = *_list;
+
+	if (!list) {
+		list = malloc(sizeof(*list));
+		if (!list)
+			return -ENOMEM;
+		INIT_LIST_HEAD(list);
+	}
 
 	event_attr_init(attr);
 
 	evsel = perf_evsel__new(attr, (*idx)++);
-	if (!evsel)
+	if (!evsel) {
+		free(list);
 		return -ENOMEM;
-
-	list_add_tail(&evsel->node, list);
+	}
 
 	evsel->name = strdup(name);
+	list_add_tail(&evsel->node, list);
+	*_list = list;
 	return 0;
 }
 
@@ -393,7 +402,7 @@ static int parse_aliases(char *str, const char *names[][MAX_ALIASES], int size)
 	return -1;
 }
 
-int parse_events_add_cache(struct list_head *list, int *idx,
+int parse_events_add_cache(struct list_head **list, int *idx,
 			   char *type, char *op_result1, char *op_result2)
 {
 	struct perf_event_attr attr;
@@ -454,7 +463,7 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-static int add_tracepoint(struct list_head *list, int *idx,
+static int add_tracepoint(struct list_head **list, int *idx,
 			  char *sys_name, char *evt_name)
 {
 	struct perf_event_attr attr;
@@ -491,7 +500,7 @@ static int add_tracepoint(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-static int add_tracepoint_multi(struct list_head *list, int *idx,
+static int add_tracepoint_multi(struct list_head **list, int *idx,
 				char *sys_name, char *evt_name)
 {
 	char evt_path[MAXPATHLEN];
@@ -522,7 +531,7 @@ static int add_tracepoint_multi(struct list_head *list, int *idx,
 	return ret;
 }
 
-int parse_events_add_tracepoint(struct list_head *list, int *idx,
+int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event)
 {
 	int ret;
@@ -566,7 +575,7 @@ parse_breakpoint_type(const char *type, struct perf_event_attr *attr)
 	return 0;
 }
 
-int parse_events_add_breakpoint(struct list_head *list, int *idx,
+int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type)
 {
 	struct perf_event_attr attr;
@@ -738,7 +747,7 @@ static int config_attr(struct perf_event_attr *attr,
 	return 0;
 }
 
-int parse_events_add_numeric(struct list_head *list, int *idx,
+int parse_events_add_numeric(struct list_head **list, int *idx,
 			     unsigned long type, unsigned long config,
 			     struct list_head *head_config)
 {
@@ -756,7 +765,7 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 			 (char *) __event_name(type, config));
 }
 
-int parse_events_add_pmu(struct list_head *list, int *idx,
+int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *name, struct list_head *head_config)
 {
 	struct perf_event_attr attr;
@@ -791,7 +800,7 @@ void parse_events_update_lists(struct list_head *list_event,
 	 * list, for next event definition.
 	 */
 	list_splice_tail(list_event, list_all);
-	INIT_LIST_HEAD(list_event);
+	free(list_event);
 }
 
 int parse_events_modifier(struct list_head *list, char *str)
@@ -869,7 +878,7 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 #ifdef PARSER_DEBUG
 	parse_events_debug = 1;
 #endif
-	ret = parse_events_parse(&list, &list_tmp, &idx);
+	ret = parse_events_parse(&list, &idx);
 
 	parse_events__flush_buffer(buffer);
 	parse_events__delete_buffer(buffer);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 66e08f4..8651757 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -87,25 +87,21 @@ int parse_events__term_elem(struct parse_events__term_elem **_e,
 			    int type_val, char *str, long num);
 int parse_events__branch_type(u64 *_type, char *str);
 void parse_events__free_terms(struct list_head *terms);
-int parse_events_modifier(struct list_head *list __used, char *str __used);
-int parse_events_add_tracepoint(struct list_head *list, int *idx,
+int parse_events_modifier(struct list_head *list, char *str);
+int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event);
-int parse_events_add_raw(struct perf_evlist *evlist, unsigned long config,
-			 unsigned long config1, unsigned long config2,
-			 char *mod);
-int parse_events_add_numeric(struct list_head *list, int *idx,
+int parse_events_add_numeric(struct list_head **list, int *idx,
 			     unsigned long type, unsigned long config,
 			     struct list_head *head_config);
-int parse_events_add_cache(struct list_head *list, int *idx,
+int parse_events_add_cache(struct list_head **list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
-int parse_events_add_breakpoint(struct list_head *list, int *idx,
+int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type);
-int parse_events_add_pmu(struct list_head *list, int *idx,
+int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *pmu , struct list_head *head_config);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(struct list_head *list_all,
-			struct list_head *list_event,
 			int *idx, char const *msg);
 int parse_events__test(void);
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index ef3ee2d..5899a0e 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -1,7 +1,6 @@
 
 %name-prefix "parse_events_"
 %parse-param {struct list_head *list_all}
-%parse-param {struct list_head *list_event}
 %parse-param {int *idx}
 
 %{
@@ -43,6 +42,14 @@ do { \
 %type <term> event_term
 %type <head> event_term_list
 %type <elem> event_term_elem
+%type <head> event_pmu
+%type <head> event_legacy_symbol
+%type <head> event_legacy_cache
+%type <head> event_legacy_mem
+%type <head> event_legacy_tracepoint
+%type <head> event_legacy_numeric
+%type <head> event_legacy_raw
+%type <head> event_def
 
 %union
 {
@@ -65,13 +72,13 @@ event_def PE_MODIFIER_EVENT
 	 * (there could be more events added for multiple tracepoint
 	 * definitions via '*?'.
 	 */
-	ABORT_ON(parse_events_modifier(list_event, $2));
-	parse_events_update_lists(list_event, list_all);
+	ABORT_ON(parse_events_modifier($1, $2));
+	parse_events_update_lists($1, list_all);
 }
 |
 event_def
 {
-	parse_events_update_lists(list_event, list_all);
+	parse_events_update_lists($1, list_all);
 }
 
 event_def: event_pmu |
@@ -85,71 +92,102 @@ event_def: event_pmu |
 event_pmu:
 PE_NAME '/' event_config '/'
 {
-	ABORT_ON(parse_events_add_pmu(list_event, idx, $1, $3));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_pmu(&list, idx, $1, $3));
 	parse_events__free_terms($3);
+	$$ = list;
 }
 
 event_legacy_symbol:
 PE_VALUE_SYM '/' event_config '/'
 {
+	struct list_head *list = NULL;
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, $3));
+	ABORT_ON(parse_events_add_numeric(&list, idx, type, config, $3));
 	parse_events__free_terms($3);
+	$$ = list;
 }
 |
 PE_VALUE_SYM sep_slash_dc
 {
+	struct list_head *list = NULL;
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, NULL));
+	ABORT_ON(parse_events_add_numeric(&list, idx, type, config, NULL));
+	$$ = list;
 }
 
 event_legacy_cache:
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT
 {
-	ABORT_ON(parse_events_add_cache(list_event, idx, $1, $3, $5));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_cache(&list, idx, $1, $3, $5));
+	$$ = list;
 }
 |
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT
 {
-	ABORT_ON(parse_events_add_cache(list_event, idx, $1, $3, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_cache(&list, idx, $1, $3, NULL));
+	$$ = list;
 }
 |
 PE_NAME_CACHE_TYPE
 {
-	ABORT_ON(parse_events_add_cache(list_event, idx, $1, NULL, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_cache(&list, idx, $1, NULL, NULL));
+	$$ = list;
 }
 
 event_legacy_mem:
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
-	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) $2, $4));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_breakpoint(&list, idx, (void *) $2, $4));
+	$$ = list;
 }
 |
 PE_PREFIX_MEM PE_VALUE sep_dc
 {
-	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) $2, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_breakpoint(&list, idx, (void *) $2, NULL));
+	$$ = list;
 }
 
 event_legacy_tracepoint:
 PE_NAME ':' PE_NAME
 {
-	ABORT_ON(parse_events_add_tracepoint(list_event, idx, $1, $3));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_tracepoint(&list, idx, $1, $3));
+	$$ = list;
 }
 
 event_legacy_numeric:
 PE_VALUE ':' PE_VALUE
 {
-	ABORT_ON(parse_events_add_numeric(list_event, idx, $1, $3, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_numeric(&list, idx, $1, $3, NULL));
+	$$ = list;
 }
 
 event_legacy_raw:
 PE_RAW
 {
-	ABORT_ON(parse_events_add_numeric(list_event, idx, PERF_TYPE_RAW, $1, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_numeric(&list, idx, PERF_TYPE_RAW, $1, NULL));
+	$$ = list;
 }
 
 event_config:
@@ -284,7 +322,6 @@ sep_slash_dc: '/' | ':' |
 %%
 
 void parse_events_error(struct list_head *list_all __used,
-			struct list_head *list_event __used,
 			int *idx __used,
 			char const *msg __used)
 {
-- 
1.7.7.6

