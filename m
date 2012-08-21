Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab2HUQPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:15:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2HUQPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:15:10 -0400
Date: Tue, 21 Aug 2012 09:14:27 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-p4j8bnvo879uokum4k4zk5q6@git.kernel.org>
Cc: acme@redhat.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, peterz@infradead.org, jolsa@redhat.com,
        drepper@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, namhyung@kernel.org,
        mingo@elte.hu
Reply-To: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@ghostprotocols.net,
        namhyung@kernel.org, jolsa@redhat.com, drepper@gmail.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add support to parse event group syntax
Git-Commit-ID: 89efb029502d7f2d0993ed2aa9280c414336939c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:14:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89efb029502d7f2d0993ed2aa9280c414336939c
Gitweb:     http://git.kernel.org/tip/89efb029502d7f2d0993ed2aa9280c414336939c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 8 Aug 2012 12:14:14 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Aug 2012 17:03:44 -0300

perf tools: Add support to parse event group syntax

Adding scanner/parser bits to parse event groups.

The grammar for group is:
  groups:      groups ',' group | group
  group:       group_name '{' events '}' group_mod
  group_name:  name | empty
  group_mod:   ':' group_mods | empty
  group_mods:  event_mod

It's possible to use standard event modifier as a modifier
for group. It'll be used as an update to existing event
modifiers.

It's necessary to use quoting ("'\) when specifying group on
command line, since {} characters are interpreted by most of
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

The grouping functionality itself is coming shortly.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/n/tip-p4j8bnvo879uokum4k4zk5q6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   14 +++++-
 tools/perf/util/parse-events.h |    4 +-
 tools/perf/util/parse-events.l |    2 +
 tools/perf/util/parse-events.y |   93 ++++++++++++++++++++++++++++++++++------
 4 files changed, 97 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3ec4bfc..57d5809 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -611,19 +611,29 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
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
index 00416d7f..c3bb04c 100644
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
index e4abdf2..2c0d006 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -151,6 +151,8 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 -			{ return '-'; }
 ,			{ return ','; }
 :			{ return ':'; }
+"{"			{ return '{'; }
+"}"			{ return '}'; }
 =			{ return '='; }
 \n			{ }
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 423d331..15e6e97 100644
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
 %type <num> PE_VALUE_SYM_HW
@@ -53,6 +53,11 @@ do { \
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
@@ -64,33 +69,95 @@ do { \
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
@@ -222,7 +289,7 @@ PE_RAW
 	$$ = list;
 }
 
-terms: event_config
+start_terms: event_config
 {
 	struct parse_events_data__terms *data = _data;
 	data->terms = $1;
