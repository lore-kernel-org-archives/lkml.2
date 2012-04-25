Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab2DYFrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 01:47:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:54242 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167Ab2DYFrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 01:47:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133520564"
Message-ID: <4F979002.9090906@intel.com>
Date: Wed, 25 Apr 2012 13:47:46 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: [PATCH 4/6] perf tool: Parse general events from sysfs
References: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com> <1333244495-1020-5-git-send-email-zheng.z.yan@intel.com> <20120424090427.GA2125@m.brq.redhat.com>
In-Reply-To: <20120424090427.GA2125@m.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 05:04 PM, Jiri Olsa wrote:
> hi,
> so the point is to have an alias support for pmu event definition.
> Seems like good idea to improve usability/readability, I have some
> general comments though..
> 
Thank you very much for reviewing this.
> - you suggest to have sysfs files having contents like:
>     event=0x2c,umask=0xf
>   when we were adding the formats stuff into sysfs, we had to cut off
>   the sysfs file contents to bare minimum to obey the sysfs rule:
>     single file = single value
>   so you might have some troubles pushing that through.. not sure ;)
> 
> - I haven't read the whole patchset, but seems like the "events"
>   directory is now specific to a 'Intel uncore pmu'. If thats the
>   case I think there should be generic way for each pmu to define
>   this stuff.
> 
> - as for the tools/pmu.c change I'd like to see more consistent
>   way of parsing this, than via 'newcfg' variable.. but none
>   is comming to me so far ;) I'll think about that..
> 
For this point, how about making the parser re-entrantable like the patch
attached below does.

Regards
Yan, Zheng

---
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e98e14c..a8b47d2 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -728,11 +728,13 @@ $(OUTPUT)perf.o perf.spec \
 # These two need to be here so that when O= is not used they take precedence
 # over the general rule for .o
 
+ALL_CFLAGS_NO_WERROR = $(shell echo $(ALL_CFLAGS) | sed "s/-Werror //g")
+
 $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS_NO_WERROR) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
 
 $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS_NO_WERROR) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5b3a0ef..b776c2e 100644
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
@@ -651,8 +653,11 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *name, struct list_head *head_config)
 {
+	LIST_HEAD(event);
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
+	char *config;
+	int ret;
 
 	pmu = perf_pmu__find(name);
 	if (!pmu)
@@ -666,10 +671,21 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	 */
 	config_attr(&attr, head_config, 0);
 
-	if (perf_pmu__config(pmu, &attr, head_config))
-		return -EINVAL;
+	ret = perf_pmu__config(pmu, &attr, head_config);
+	if (!ret)
+		return add_event(list, idx, &attr, (char *) "pmu");
+
+	ret = perf_pmu__alias(pmu, &config, head_config);
+	if (ret)
+		return ret;
+
+	ret =  __parse_events(config, idx, &event);
+	free(config);
+	if (ret)
+		return ret;
 
-	return add_event(list, idx, &attr, (char *) "pmu");
+	list_splice_tail(&event, list);
+	return 0;
 }
 
 void parse_events_update_lists(struct list_head *list_event,
@@ -747,20 +763,34 @@ int parse_events_modifier(struct list_head *list, char *str)
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
+
+	ret = parse_events_parse(list, &list_tmp, idx, scanner);
 
-	buffer = parse_events__scan_string(str);
+	parse_events__flush_buffer(buffer, scanner);
+	parse_events__delete_buffer(buffer, scanner);
+	parse_events_lex_destroy(scanner);
 
-	ret = parse_events_parse(&list, &list_tmp, &idx);
+	return ret;
+}
 
-	parse_events__flush_buffer(buffer);
-	parse_events__delete_buffer(buffer);
+int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
+{
+	LIST_HEAD(list);
+	int ret, idx = evlist->nr_entries;
 
+	ret =  __parse_events(str, &idx, &list);
 	if (!ret) {
 		int entries = idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &list, entries);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ca069f8..e1ffeb7 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -80,7 +80,7 @@ void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(struct list_head *list_all,
 			struct list_head *list_event,
-			int *idx, char const *msg);
+			int *idx, void *scanner, char const *msg);
 
 void print_events(const char *event_glob);
 void print_events_type(u8 type);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 05d766e..72066d2 100644
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
 
@@ -58,25 +60,25 @@ modifier_event	[ukhp]{1,5}
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
index d9637da..8a26f3d 100644
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
@@ -194,7 +197,7 @@ PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
 		 $1, NULL, 1));
 	$$ = term;
 }
@@ -223,7 +226,7 @@ sep_slash_dc: '/' | ':' |
 
 void parse_events_error(struct list_head *list_all __used,
 			struct list_head *list_event __used,
-			int *idx __used,
+			int *idx __used, void *scanner __used,
 			char const *msg __used)
 {
 }
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index cb08a11..3daf828 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -80,6 +80,89 @@ static int pmu_format(char *name, struct list_head *format)
 	return 0;
 }
 
+static int perf_pmu__new_event(struct list_head *list, char *name, FILE *file)
+{
+	struct perf_pmu__event *event;
+	char buf[256];
+	int ret;
+
+	ret = fread(buf, 1, sizeof(buf), file);
+	if (ret == 0)
+		return -EINVAL;
+
+	event = zalloc(sizeof(*event));
+	if (!event)
+		return -ENOMEM;
+
+	event->name = strdup(name);
+	event->config = strndup(buf, ret);
+
+	list_add_tail(&event->list, list);
+	return 0;
+}
+
+/*
+ * Process all the sysfs attributes located under the directory
+ * specified in 'dir' parameter.
+ */
+static int pmu_events_parse(char *dir, struct list_head *head)
+{
+	struct dirent *evt_ent;
+	DIR *event_dir;
+	int ret = 0;
+
+	event_dir = opendir(dir);
+	if (!event_dir)
+		return -EINVAL;
+
+	while (!ret && (evt_ent = readdir(event_dir))) {
+		char path[PATH_MAX];
+		char *name = evt_ent->d_name;
+		FILE *file;
+
+		if (!strcmp(name, ".") || !strcmp(name, ".."))
+			continue;
+
+		snprintf(path, PATH_MAX, "%s/%s", dir, name);
+
+		ret = -EINVAL;
+		file = fopen(path, "r");
+		if (!file)
+			break;
+		ret = perf_pmu__new_event(head, name, file);
+		fclose(file);
+	}
+
+	closedir(event_dir);
+	return ret;
+}
+
+/*
+ * Reading the pmu event definition, which should be located at:
+ * /sys/bus/event_source/devices/<dev>/events as sysfs group attributes.
+ */
+static int pmu_events(char *name, struct list_head *events)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	const char *sysfs;
+
+	sysfs = sysfs_find_mountpoint();
+	if (!sysfs)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		 "%s/bus/event_source/devices/%s/events", sysfs, name);
+
+	if (stat(path, &st) < 0)
+		return -1;
+
+	if (pmu_events_parse(path, events))
+		return -1;
+
+	return 0;
+}
+
 /*
  * Reading/parsing the default pmu type value, which should be
  * located at:
@@ -118,6 +201,7 @@ static struct perf_pmu *pmu_lookup(char *name)
 {
 	struct perf_pmu *pmu;
 	LIST_HEAD(format);
+	LIST_HEAD(events);
 	__u32 type;
 
 	/*
@@ -135,8 +219,12 @@ static struct perf_pmu *pmu_lookup(char *name)
 	if (!pmu)
 		return NULL;
 
+	pmu_events(name, &events);
+
 	INIT_LIST_HEAD(&pmu->format);
+	INIT_LIST_HEAD(&pmu->events);
 	list_splice(&format, &pmu->format);
+	list_splice(&events, &pmu->events);
 	pmu->name = strdup(name);
 	pmu->type = type;
 	return pmu;
@@ -262,6 +350,47 @@ static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
 	return 0;
 }
 
+
+static struct perf_pmu__event*
+pmu_find_event(struct list_head *events, char *name)
+{
+	struct perf_pmu__event *event;
+
+	list_for_each_entry(event, events, list)
+		if (!strcmp(event->name, name))
+			return event;
+
+	return NULL;
+}
+
+static int pmu_event(struct perf_pmu *pmu, struct list_head *head_terms,
+			char **config)
+{
+	struct parse_events__term *term;
+	struct perf_pmu__event *event;
+	char *buf;
+
+	if (!list_is_singular(head_terms))
+		return -EINVAL;
+
+	term = list_entry(head_terms->next, struct parse_events__term, list);
+
+	if (term->type != PARSE_EVENTS__TERM_TYPE_STR || term->val.str)
+		return -EINVAL;
+
+	event = pmu_find_event(&pmu->events, term->config);
+	if (!event)
+		return -EINVAL;
+
+	buf = malloc(strlen(pmu->name) + strlen(event->config) + 3);
+	if (!buf)
+		return -ENOMEM;
+
+	sprintf(buf, "%s/%s/", pmu->name, event->config);
+	*config = buf;
+	return 0;
+}
+
 /*
  * Configures event's 'attr' parameter based on the:
  * 1) users input - specified in terms parameter
@@ -274,6 +403,12 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 	return pmu_config(&pmu->format, attr, head_terms);
 }
 
+int perf_pmu__alias(struct perf_pmu *pmu, char **config,
+		    struct list_head *head_terms)
+{
+	return pmu_event(pmu, head_terms, config);
+}
+
 int perf_pmu__new_format(struct list_head *list, char *name,
 			 int config, unsigned long *bits)
 {
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 68c0db9..3656b42 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -19,16 +19,25 @@ struct perf_pmu__format {
 	struct list_head list;
 };
 
+struct perf_pmu__event {
+	char *name;
+	char *config;
+	struct list_head list;
+};
+
 struct perf_pmu {
 	char *name;
 	__u32 type;
 	struct list_head format;
+	struct list_head events;
 	struct list_head list;
 };
 
 struct perf_pmu *perf_pmu__find(char *name);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
+int perf_pmu__alias(struct perf_pmu *pmu, char **config,
+		    struct list_head *head_terms);
 
 int perf_pmu_wrap(void);
 void perf_pmu_error(struct list_head *list, char *name, char const *msg);
