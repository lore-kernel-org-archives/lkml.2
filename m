Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2DDVQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab2DDVQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/8] perf, tool: Add support to parse event group syntax
Date: Wed,  4 Apr 2012 23:16:09 +0200
Message-Id: <1333574176-11388-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding scanner/parser bits to add group event support into the
event syntax.

The grammar for group is:
  start:    groups
  groups:   groups ';' group
  group:    'group=' events

It is possible to specify group assignement in event syntax like:
   perf record -e group=cycles,faults ls

Creating multiple events within one '-e' option with the ';' separator:
   perf record -e 'group=cycles,faults;group=instructions,cache-misses' ls

The grouping functionality itself is comming in shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |    5 +++
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/parse-events.l |    2 +
 tools/perf/util/parse-events.y |   55 ++++++++++++++++++++++++++++++++++-----
 4 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d4abd00..53c7505 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -791,6 +791,11 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
+int parse_events__group(struct list_head *list __used)
+{
+	return 0;
+}
+
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8651757..a5e1adf 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -99,6 +99,7 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *pmu , struct list_head *head_config);
+int parse_events__group(struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(struct list_head *list_all,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index cd6614d..c867b34 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -107,6 +107,7 @@ period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 
 mem:			{ return PE_PREFIX_MEM; }
+group=			{ return PE_PREFIX_GROUP; }
 r{num_raw_hex}		{ return raw(); }
 {num_dec}		{ return value(10); }
 {num_hex}		{ return value(16); }
@@ -118,6 +119,7 @@ r{num_raw_hex}		{ return raw(); }
 -			{ return '-'; }
 ,			{ return ','; }
 :			{ return ':'; }
+;			{ return ';'; }
 =			{ return '='; }
 \|			{ return '|'; }
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 5899a0e..a3898d6 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -27,7 +27,7 @@ do { \
 %token PE_NAME
 %token PE_MODIFIER_EVENT PE_MODIFIER_BP
 %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
-%token PE_PREFIX_MEM PE_PREFIX_RAW
+%token PE_PREFIX_MEM PE_PREFIX_RAW PE_PREFIX_GROUP
 %token PE_ERROR
 %type <num> PE_VALUE
 %type <num> PE_VALUE_SYM
@@ -50,6 +50,10 @@ do { \
 %type <head> event_legacy_numeric
 %type <head> event_legacy_raw
 %type <head> event_def
+%type <head> event
+%type <head> events
+%type <head> group
+%type <head> groups
 
 %union
 {
@@ -61,25 +65,62 @@ do { \
 }
 %%
 
+start: groups
+{
+	struct list_head *groups = $1;
+
+	parse_events_update_lists(groups, list_all);
+}
+
+groups:
+groups ';' group
+{
+	struct list_head *group = $3;
+	struct list_head *list  = $1;
+
+	parse_events_update_lists(group, list);
+	$$ = list;
+}
+|
+group
+
+group:
+PE_PREFIX_GROUP events
+{
+	struct list_head *list = $2;
+
+	ABORT_ON(parse_events__group(list));
+	$$ = list;
+}
+|
+events
+
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
+	struct list_head *list = $1;
 	/*
 	 * Apply modifier on all events added by single event definition
 	 * (there could be more events added for multiple tracepoint
 	 * definitions via '*?'.
 	 */
-	ABORT_ON(parse_events_modifier($1, $2));
-	parse_events_update_lists($1, list_all);
+	ABORT_ON(parse_events_modifier(list, $2));
+	$$ = list;
 }
 |
 event_def
-{
-	parse_events_update_lists($1, list_all);
-}
 
 event_def: event_pmu |
 	   event_legacy_symbol |
-- 
1.7.7.6

