Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab2HPTym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:54:42 -0400
Received: from [216.32.180.31] ([216.32.180.31]:6858 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932118Ab2HPTyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:54:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(zz853kzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M8V5WR-01-68E-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/8] perf tools: Catch event names from command line
Date: Thu, 16 Aug 2012 21:10:21 +0200
Message-ID: <1345144224-27280-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use command line string provided by the -e option to name events. This
way we get unique events names that also support pmu event syntax
(<pmu_name>/<config>/<modifier>). No need to reconstruct the name
anymore from its attributes. We use the event_desc of the header to
store the name in the perf.data header. Thus it is also available for
perf report.

Implemented by putting the parser in different states to parse events
or configs.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/parse-events.c |   12 +++++++++
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/parse-events.l |   50 ++++++++++++++++++++++++++++++++--------
 tools/perf/util/parse-events.y |   20 ++++++++++++++-
 4 files changed, 71 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 925784a..b246303 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -751,6 +751,18 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 	return 0;
 }
 
+int parse_events_name(struct list_head *list, char *name)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, list, node) {
+		if (!evsel->name)
+			evsel->name = strdup(name);
+	}
+
+	return 0;
+}
+
 static int parse_events__scanner(const char *str, void *data, int start_token)
 {
 	YY_BUFFER_STATE buffer;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 0b9782d..c356e44 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -81,6 +81,7 @@ int parse_events__term_clone(struct parse_events__term **new,
 void parse_events__free_terms(struct list_head *terms);
 int parse_events__modifier_event(struct list_head *list, char *str, bool add);
 int parse_events__modifier_group(struct list_head *list, char *event_mod);
+int parse_events_name(struct list_head *list, char *name);
 int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event);
 int parse_events_add_numeric(struct list_head **list, int *idx,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 2c0d006..f5e28dc 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -70,6 +70,12 @@ static int term(yyscan_t scanner, int type)
 %}
 
 %x mem
+%s config
+%x event
+
+group		[^,{}/]*[{][^}]*[}][^,{}/]*
+event_pmu	[^,{}/]+[/][^/]*[/][^,{}/]*
+event		[^,{}/]+
 
 num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
@@ -84,7 +90,13 @@ modifier_bp	[rwx]{1,3}
 	{
 		int start_token;
 
-		start_token = (int) parse_events_get_extra(yyscanner);
+		start_token = parse_events_get_extra(yyscanner);
+
+		if (start_token == PE_START_TERMS)
+			BEGIN(config);
+		else if (start_token == PE_START_EVENTS)
+			BEGIN(event);
+
 		if (start_token) {
 			parse_events_set_extra(NULL, yyscanner);
 			return start_token;
@@ -92,6 +104,26 @@ modifier_bp	[rwx]{1,3}
          }
 %}
 
+<event>{
+
+{group}		{
+			BEGIN(INITIAL); yyless(0);
+		}
+
+{event_pmu}	|
+{event}		{
+			str(yyscanner, PE_EVENT_NAME);
+			BEGIN(INITIAL); yyless(0);
+			return PE_EVENT_NAME;
+		}
+
+.		|
+<<EOF>>		{
+			BEGIN(INITIAL); yyless(0);
+		}
+
+}
+
 cpu-cycles|cycles				{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
 stalled-cycles-frontend|idle-cycles-frontend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
 stalled-cycles-backend|idle-cycles-backend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
@@ -127,18 +159,16 @@ speculative-read|speculative-load	|
 refs|Reference|ops|access		|
 misses|miss				{ return str(yyscanner, PE_NAME_CACHE_OP_RESULT); }
 
-	/*
-	 * These are event config hardcoded term names to be specified
-	 * within xxx/.../ syntax. So far we dont clash with other names,
-	 * so we can put them here directly. In case the we have a conflict
-	 * in future, this needs to go into '//' condition block.
-	 */
+<config>{
 config			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG); }
 config1			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
 config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
 name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
+,			{ return ','; }
+"/"			{ BEGIN(INITIAL); return '/'; }
+}
 
 mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
 r{num_raw_hex}		{ return raw(yyscanner); }
@@ -147,11 +177,11 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 
 {modifier_event}	{ return str(yyscanner, PE_MODIFIER_EVENT); }
 {name}			{ return str(yyscanner, PE_NAME); }
-"/"			{ return '/'; }
+"/"			{ BEGIN(config); return '/'; }
 -			{ return '-'; }
-,			{ return ','; }
+,			{ BEGIN(event); return ','; }
 :			{ return ':'; }
-"{"			{ return '{'; }
+"{"			{ BEGIN(event); return '{'; }
 "}"			{ return '}'; }
 =			{ return '='; }
 \n			{ }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 66850f8..42d9a17 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -27,6 +27,7 @@ do { \
 
 %token PE_START_EVENTS PE_START_TERMS
 %token PE_VALUE PE_VALUE_SYM_HW PE_VALUE_SYM_SW PE_RAW PE_TERM
+%token PE_EVENT_NAME
 %token PE_NAME
 %token PE_MODIFIER_EVENT PE_MODIFIER_BP
 %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
@@ -42,6 +43,7 @@ do { \
 %type <str> PE_NAME_CACHE_OP_RESULT
 %type <str> PE_MODIFIER_EVENT
 %type <str> PE_MODIFIER_BP
+%type <str> PE_EVENT_NAME
 %type <num> value_sym
 %type <head> event_config
 %type <term> event_term
@@ -53,6 +55,8 @@ do { \
 %type <head> event_legacy_numeric
 %type <head> event_legacy_raw
 %type <head> event_def
+%type <head> event_mod
+%type <head> event_name
 %type <head> event
 %type <head> events
 %type <head> group_def
@@ -143,8 +147,10 @@ events ',' event
 |
 event
 
-event:
-event_def PE_MODIFIER_EVENT
+event: event_mod
+
+event_mod:
+event_name PE_MODIFIER_EVENT
 {
 	struct list_head *list = $1;
 
@@ -157,6 +163,16 @@ event_def PE_MODIFIER_EVENT
 	$$ = list;
 }
 |
+event_name
+
+event_name:
+PE_EVENT_NAME event_def
+{
+	ABORT_ON(parse_events_name($2, $1));
+	free($1);
+	$$ = $2;
+}
+|
 event_def
 
 event_def: event_pmu |
-- 
1.7.8.6


