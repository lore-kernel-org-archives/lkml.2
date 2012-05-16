Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967344Ab2EPFBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:01:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:54288 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967328Ab2EPFAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:00:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100617339"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] perf tool: Make the event parser reentrantable
Date: Wed, 16 May 2012 13:00:02 +0800
Message-Id: <1337144403-30841-10-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 tools/perf/Makefile            |    7 ++-
 tools/perf/util/parse-events.c |   32 ++++++++++----
 tools/perf/util/parse-events.h |    2 +-
 tools/perf/util/parse-events.l |   92 ++++++++++++++++++++-------------------
 tools/perf/util/parse-events.y |    9 +++-
 5 files changed, 83 insertions(+), 59 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 398094c..ab27fb2 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -733,14 +733,17 @@ $(OUTPUT)perf.o perf.spec \
 .SUFFIXES:
 .SUFFIXES: .o .c .S .s
 
+# Remove -Wextra to suppress 'unused parameter' warning
+ALL_CFLAGS_NO_WEXTRA = $(shell echo $(ALL_CFLAGS) | sed "s/-Wextra //g")
+
 # These two need to be here so that when O= is not used they take precedence
 # over the general rule for .o
 
 $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -w $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS_NO_WEXTRA) -Iutil/ -w $<
 
 $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -w $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS_NO_WEXTRA) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -w $<
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5b3a0ef..c587ae8 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -11,6 +11,7 @@
 #include "cache.h"
 #include "header.h"
 #include "debugfs.h"
+#include "parse-events-bison.h"
 #include "parse-events-flex.h"
 #include "pmu.h"
 
@@ -24,7 +25,8 @@ struct event_symbol {
 };
 
 int parse_events_parse(struct list_head *list, struct list_head *list_tmp,
-		       int *idx);
+		       int *idx, void *scanner);
+static int __parse_events(const char *str, int *idx, struct list_head *list);
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
@@ -747,20 +749,34 @@ int parse_events_modifier(struct list_head *list, char *str)
 	return 0;
 }
 
-int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
+static int __parse_events(const char *str, int *idx, struct list_head *list)
 {
-	LIST_HEAD(list);
 	LIST_HEAD(list_tmp);
 	YY_BUFFER_STATE buffer;
-	int ret, idx = evlist->nr_entries;
+	void *scanner;
+	int ret;
+
+	ret = parse_events_lex_init(&scanner);
+	if (ret)
+		return ret;
+
+	buffer = parse_events__scan_string(str, scanner);
 
-	buffer = parse_events__scan_string(str);
+	ret = parse_events_parse(list, &list_tmp, idx, scanner);
 
-	ret = parse_events_parse(&list, &list_tmp, &idx);
+	parse_events__flush_buffer(buffer, scanner);
+	parse_events__delete_buffer(buffer, scanner);
+	parse_events_lex_destroy(scanner);
 
-	parse_events__flush_buffer(buffer);
-	parse_events__delete_buffer(buffer);
+	return ret;
+}
+
+int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
+{
+	LIST_HEAD(list);
+	int ret, idx = evlist->nr_entries;
 
+	ret =  __parse_events(str, &idx, &list);
 	if (!ret) {
 		int entries = idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &list, entries);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 5cb0028..6a98b8d 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -82,7 +82,7 @@ void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(struct list_head *list_all,
 			struct list_head *list_event,
-			int *idx, char const *msg);
+			int *idx, void *scanner, char const *msg);
 
 void print_events(const char *event_glob);
 void print_events_type(u8 type);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 1fcf1bb..eec423c 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -1,4 +1,6 @@
 
+%option reentrant
+%option bison-bridge
 %option prefix="parse_events_"
 
 %{
@@ -7,7 +9,7 @@
 #include "parse-events-bison.h"
 #include "parse-events.h"
 
-static int __value(char *str, int base, int token)
+static int __value(YYSTYPE *yylval, char *str, int base, int token)
 {
 	long num;
 
@@ -16,35 +18,35 @@ static int __value(char *str, int base, int token)
 	if (errno)
 		return PE_ERROR;
 
-	parse_events_lval.num = num;
+	yylval->num = num;
 	return token;
 }
 
-static int value(int base)
+static int value(YYSTYPE *yylval, char *text, int base)
 {
-	return __value(parse_events_text, base, PE_VALUE);
+	return __value(yylval, text, base, PE_VALUE);
 }
 
-static int raw(void)
+static int raw(YYSTYPE *yylval, char *text)
 {
-	return __value(parse_events_text + 1, 16, PE_RAW);
+	return __value(yylval, text + 1, 16, PE_RAW);
 }
 
-static int str(int token)
+static int str(YYSTYPE *yylval, char *text, int token)
 {
-	parse_events_lval.str = strdup(parse_events_text);
+	yylval->str = strdup(text);
 	return token;
 }
 
-static int sym(int type, int config)
+static int sym(YYSTYPE *yylval, int type, int config)
 {
-	parse_events_lval.num = (type << 16) + config;
+	yylval->num = (type << 16) + config;
 	return PE_VALUE_SYM;
 }
 
-static int term(int type)
+static int term(YYSTYPE *yylval, int type)
 {
-	parse_events_lval.num = type;
+	yylval->num = type;
 	return PE_TERM;
 }
 
@@ -58,25 +60,25 @@ modifier_event	[ukhpGH]{1,8}
 modifier_bp	[rwx]
 
 %%
-cpu-cycles|cycles				{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
-stalled-cycles-frontend|idle-cycles-frontend	{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
-stalled-cycles-backend|idle-cycles-backend	{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
-instructions					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS); }
-cache-references				{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_REFERENCES); }
-cache-misses					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_MISSES); }
-branch-instructions|branches			{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_INSTRUCTIONS); }
-branch-misses					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES); }
-bus-cycles					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BUS_CYCLES); }
-ref-cycles					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_REF_CPU_CYCLES); }
-cpu-clock					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_CLOCK); }
-task-clock					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK); }
-page-faults|faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS); }
-minor-faults					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MIN); }
-major-faults					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MAJ); }
-context-switches|cs				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CONTEXT_SWITCHES); }
-cpu-migrations|migrations			{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS); }
-alignment-faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_ALIGNMENT_FAULTS); }
-emulation-faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
+cpu-cycles|cycles				{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
+stalled-cycles-frontend|idle-cycles-frontend	{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
+stalled-cycles-backend|idle-cycles-backend	{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
+instructions					{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS); }
+cache-references				{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_REFERENCES); }
+cache-misses					{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_MISSES); }
+branch-instructions|branches			{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_INSTRUCTIONS); }
+branch-misses					{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES); }
+bus-cycles					{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_BUS_CYCLES); }
+ref-cycles					{ return sym(yylval, PERF_TYPE_HARDWARE, PERF_COUNT_HW_REF_CPU_CYCLES); }
+cpu-clock					{ return sym(yylval, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_CLOCK); }
+task-clock					{ return sym(yylval, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK); }
+page-faults|faults				{ return sym(yylval, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS); }
+minor-faults					{ return sym(yylval, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MIN); }
+major-faults					{ return sym(yylval, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MAJ); }
+context-switches|cs				{ return sym(yylval, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CONTEXT_SWITCHES); }
+cpu-migrations|migrations			{ return sym(yylval, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS); }
+alignment-faults				{ return sym(yylval, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_ALIGNMENT_FAULTS); }
+emulation-faults				{ return sym(yylval, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
 
 L1-dcache|l1-d|l1d|L1-data		|
 L1-icache|l1-i|l1i|L1-instruction	|
@@ -84,14 +86,14 @@ LLC|L2					|
 dTLB|d-tlb|Data-TLB			|
 iTLB|i-tlb|Instruction-TLB		|
 branch|branches|bpu|btb|bpc		|
-node					{ return str(PE_NAME_CACHE_TYPE); }
+node					{ return str(yylval, yytext, PE_NAME_CACHE_TYPE); }
 
 load|loads|read				|
 store|stores|write			|
 prefetch|prefetches			|
 speculative-read|speculative-load	|
 refs|Reference|ops|access		|
-misses|miss				{ return str(PE_NAME_CACHE_OP_RESULT); }
+misses|miss				{ return str(yylval, yytext, PE_NAME_CACHE_OP_RESULT); }
 
 	/*
 	 * These are event config hardcoded term names to be specified
@@ -99,20 +101,20 @@ misses|miss				{ return str(PE_NAME_CACHE_OP_RESULT); }
 	 * so we can put them here directly. In case the we have a conflict
 	 * in future, this needs to go into '//' condition block.
 	 */
-config			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG); }
-config1			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG1); }
-config2			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG2); }
-period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
-branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
+config			{ return term(yylval, PARSE_EVENTS__TERM_TYPE_CONFIG); }
+config1			{ return term(yylval, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
+config2			{ return term(yylval, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
+period			{ return term(yylval, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
+branch_type		{ return term(yylval, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 
 mem:			{ return PE_PREFIX_MEM; }
-r{num_raw_hex}		{ return raw(); }
-{num_dec}		{ return value(10); }
-{num_hex}		{ return value(16); }
+r{num_raw_hex}		{ return raw(yylval, yytext); }
+{num_dec}		{ return value(yylval, yytext, 10); }
+{num_hex}		{ return value(yylval, yytext, 16); }
 
-{modifier_event}	{ return str(PE_MODIFIER_EVENT); }
-{modifier_bp}		{ return str(PE_MODIFIER_BP); }
-{name}			{ return str(PE_NAME); }
+{modifier_event}	{ return str(yylval, yytext, PE_MODIFIER_EVENT); }
+{modifier_bp}		{ return str(yylval, yytext, PE_MODIFIER_BP); }
+{name}			{ return str(yylval, yytext, PE_NAME); }
 "/"			{ return '/'; }
 -			{ return '-'; }
 ,			{ return ','; }
@@ -121,7 +123,7 @@ r{num_raw_hex}		{ return raw(); }
 
 %%
 
-int parse_events_wrap(void)
+int parse_events_wrap(void *scanner __used)
 {
 	return 1;
 }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index d9637da..52082a7 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -1,8 +1,10 @@
-
+%pure-parser
 %name-prefix "parse_events_"
 %parse-param {struct list_head *list_all}
 %parse-param {struct list_head *list_event}
 %parse-param {int *idx}
+%parse-param {void *scanner}
+%lex-param {void* scanner}
 
 %{
 
@@ -13,8 +15,9 @@
 #include "types.h"
 #include "util.h"
 #include "parse-events.h"
+#include "parse-events-bison.h"
 
-extern int parse_events_lex (void);
+extern int parse_events_lex (YYSTYPE* lvalp, void* scanner);
 
 #define ABORT_ON(val) \
 do { \
@@ -223,7 +226,7 @@ sep_slash_dc: '/' | ':' |
 
 void parse_events_error(struct list_head *list_all __used,
 			struct list_head *list_event __used,
-			int *idx __used,
+			int *idx __used, void *scanner __used,
 			char const *msg __used)
 {
 }
-- 
1.7.7.6

