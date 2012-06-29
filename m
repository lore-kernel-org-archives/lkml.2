Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2F2JJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:09:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab2F2JJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:09:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/3] perf, tool: Add support to parse event group syntax
Date: Fri, 29 Jun 2012 11:08:25 +0200
Message-Id: <1340960907-3725-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding scanner/parser bits to parse event groups.

The grammar for group is:
  groups:      groups ',' group | group
  group:       group_name '{' events '}' group_mod
  group_name:  name | empty
  group_mod:   ':' group_mods | empty
  group_mods:  event_mod

Currently it's possible to use standard event modifier as a
modifier for group. It spans over all events in the group
and overrides any event modifier settings.

It's necessary to use quoting ("'\) when specifying group on
command line, since {} characters are interpretted by most of
the shells.

It is now possible to specify groups in event syntax like:

  '{cycles,faults}'
   - anonymous group

  'group1{cycles,faults}
   - group with name 'group1'

  '{cycles,faults}:k
   - anonymous group with event modifier 'k'

  '{cpu-clock,task-clock},{minor-faults,major-faults}'
   - two anonymous groups

The grouping functionality itself is comming shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |   14 +++++-
 tools/perf/util/parse-events.h |    4 +-
 tools/perf/util/parse-events.l |    2 +
 tools/perf/util/parse-events.y |   93 ++++++++++++++++++++++++++++++++++------
 4 files changed, 97 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0cc27da..f62cbee 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -547,19 +547,29 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 			 pmu_event_name(head_config));
 }
 
+int parse_events__modifier_group(struct list_head *list __used,
+				 char *event_mod __used)
+{
+	return 0;
+}
+
+void parse_events__group(char *name __used, struct list_head *list __used)
+{
+}
+
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all)
 {
 	/*
 	 * Called for single event definition. Update the
-	 * 'all event' list, and reinit the 'signle event'
+	 * 'all event' list, and reinit the 'single event'
 	 * list, for next event definition.
 	 */
 	list_splice_tail(list_event, list_all);
 	free(list_event);
 }
 
-int parse_events_modifier(struct list_head *list, char *str)
+int parse_events__modifier_event(struct list_head *list, char *str)
 {
 	struct perf_evsel *evsel;
 	int exclude = 0, exclude_GH = 0;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ee9c218..c2f2ed9 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -79,7 +79,8 @@ int parse_events__term_str(struct parse_events__term **_term,
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term);
 void parse_events__free_terms(struct list_head *terms);
-int parse_events_modifier(struct list_head *list, char *str);
+int parse_events__modifier_event(struct list_head *list, char *str);
+int parse_events__modifier_group(struct list_head *list, char *event_mod);
 int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event);
 int parse_events_add_numeric(struct list_head **list, int *idx,
@@ -91,6 +92,7 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *pmu , struct list_head *head_config);
+void parse_events__group(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(void *data, void *scanner, char const *msg);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 488362e..931bb6e 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -151,6 +151,8 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 -			{ return '-'; }
 ,			{ return ','; }
 :			{ return ':'; }
+"{"			{ return '{'; }
+"}"			{ return '}'; }
 =			{ return '='; }
 
 <mem>{
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 9525c45..2141c0c 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -30,7 +30,7 @@ do { \
 %token PE_NAME
 %token PE_MODIFIER_EVENT PE_MODIFIER_BP
 %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
-%token PE_PREFIX_MEM PE_PREFIX_RAW
+%token PE_PREFIX_MEM PE_PREFIX_RAW PE_PREFIX_GROUP
 %token PE_ERROR
 %type <num> PE_VALUE
 %type <num> PE_VALUE_SYM
@@ -51,6 +51,11 @@ do { \
 %type <head> event_legacy_numeric
 %type <head> event_legacy_raw
 %type <head> event_def
+%type <head> event
+%type <head> events
+%type <head> group_def
+%type <head> group
+%type <head> groups
 
 %union
 {
@@ -62,33 +67,95 @@ do { \
 %%
 
 start:
-PE_START_EVENTS events
+PE_START_EVENTS start_events
 |
-PE_START_TERMS  terms
+PE_START_TERMS  start_terms
+
+start_events: groups
+{
+	struct parse_events_data__events *data = _data;
+
+	parse_events_update_lists($1, &data->list);
+}
+
+groups:
+groups ',' group
+{
+	struct list_head *list  = $1;
+	struct list_head *group = $3;
+
+	parse_events_update_lists(group, list);
+	$$ = list;
+}
+|
+groups ',' event
+{
+	struct list_head *list  = $1;
+	struct list_head *event = $3;
+
+	parse_events_update_lists(event, list);
+	$$ = list;
+}
+|
+group
+|
+event
+
+group:
+group_def ':' PE_MODIFIER_EVENT
+{
+	struct list_head *list = $1;
+
+	ABORT_ON(parse_events__modifier_group(list, $3));
+	$$ = list;
+}
+|
+group_def
+
+group_def:
+PE_NAME '{' events '}'
+{
+	struct list_head *list = $3;
+
+	parse_events__group($1, list);
+	$$ = list;
+}
+|
+'{' events '}'
+{
+	struct list_head *list = $2;
+
+	parse_events__group(NULL, list);
+	$$ = list;
+}
 
 events:
-events ',' event | event
+events ',' event
+{
+	struct list_head *event = $3;
+	struct list_head *list  = $1;
+
+	parse_events_update_lists(event, list);
+	$$ = list;
+}
+|
+event
 
 event:
 event_def PE_MODIFIER_EVENT
 {
-	struct parse_events_data__events *data = _data;
+	struct list_head *list = $1;
 
 	/*
 	 * Apply modifier on all events added by single event definition
 	 * (there could be more events added for multiple tracepoint
 	 * definitions via '*?'.
 	 */
-	ABORT_ON(parse_events_modifier($1, $2));
-	parse_events_update_lists($1, &data->list);
+	ABORT_ON(parse_events__modifier_event(list, $2));
+	$$ = list;
 }
 |
 event_def
-{
-	struct parse_events_data__events *data = _data;
-
-	parse_events_update_lists($1, &data->list);
-}
 
 event_def: event_pmu |
 	   event_legacy_symbol |
@@ -215,7 +282,7 @@ PE_RAW
 	$$ = list;
 }
 
-terms: event_config
+start_terms: event_config
 {
 	struct parse_events_data__terms *data = _data;
 	data->terms = $1;
-- 
1.7.7.6

