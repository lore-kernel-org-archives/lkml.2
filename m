Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1LTRh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:37:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1LTRhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:37:54 -0500
Date: Tue, 20 Dec 2011 15:37:22 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events parsing
Message-ID: <20111220173721.GB22107@infradead.org>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com> <1323963039-7602-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323963039-7602-2-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 15, 2011 at 04:30:37PM +0100, Jiri Olsa escreveu:
> Changing event parsing to use flex/bison parse generator.
> The event syntax stays as it is.

Seems really cool, using the right tool for the task, comments:

. Can we avoid more globals? Like that __event_list one.
. All those ABORT_ON do what? die() like stuff? /me googles YYABORT...

----
YYABORT
Return immediately with value 1 (to report failure).
----

	Ok, so it gets propagated back and hopefully the we die() just
back at main() in tools/perf/perf.c, right?

. make help | perf

	Then running one of those targets and trying to build perf still
works? I guess so, but better check that.

	Having it added to some new "make perf-test" that does that +
'perf test' too would get you brownie points. Leave it for later/someone
else if you're busy/not looking for more work, of course 8-)

. We have some tests to parse events in 'perf test', right? From the top
of my head it was even ya that did that, guess those are ok/improved
(still need to look at the other patches in the backlog).

- Arnaldo
 
> grammar description:
> 
> events: events ',' event | event
> 
> event:  event_tracepoint |
>         event_raw |
>         event_numeric |
>         event_symbolic |
>         event_generic_hw |
>         event_breakpoint
> 
> event_tracepoint:       PE_NAME_TP ':' PE_NAME_TP modifier
> event_raw:              PE_SEP_RAW PE_VALUE modifier
> event_numeric:          PE_VALUE ':' PE_VALUE modifier
> event_symbolic:         PE_NAME_SYM modifier
> event_generic_hw:       PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT modifier |
>                         PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT modifier |
>                         PE_NAME_CACHE_TYPE modifier
> event_breakpoint:       PE_SEP_BP ':' PE_VALUE event_breakpoint_type modifier
> event_breakpoint_type:  PE_MODIFIER_BPTYPE | empty
> modifier:               PE_MODIFIER_EVENT | empty
> 
> PE_NAME_SYM:            cpu-cycles|cycles                              |
>                         stalled-cycles-frontend|idle-cycles-frontend   |
>                         stalled-cycles-backend|idle-cycles-backend     |
>                         instructions                                   |
>                         cache-references                               |
>                         cache-misses                                   |
>                         branch-instructions|branches                   |
>                         branch-misses                                  |
>                         bus-cycles                                     |
>                         cpu-clock                                      |
>                         task-clock                                     |
>                         page-faults|faults                             |
>                         minor-faults                                   |
>                         major-faults                                   |
>                         context-switches|cs                            |
>                         cpu-migrations|migrations                      |
>                         alignment-faults                               |
>                         emulation-faults
> 
> PE_NAME_CACHE_TYPE:     L1-dcache|l1-d|l1d|L1-data             |
>                         L1-icache|l1-i|l1i|L1-instruction      |
>                         LLC|L2                                 |
>                         dTLB|d-tlb|Data-TLB                    |
>                         iTLB|i-tlb|Instruction-TLB             |
>                         branch|branches|bpu|btb|bpc            |
>                         node
> 
> PE_NAME_CACHE_OP_RESULT: load|loads|read                       |
>                         store|stores|write                     |
>                         prefetch|prefetches                    |
>                         speculative-read|speculative-load      |
>                         refs|Reference|ops|access              |
>                         misses|miss
> 
> PE_SEP_RAW:             'r'
> PE_SEP_BP:              'mem'
> PE_MODIFIER_EVENT:      :[ukhp]{1,2}
> PE_MODIFIER_BPTYPE:     :[rwx]{1,3}
> PE_NAME_TP:             [a-zA-Z_*?]+
> PE_VALUE:               number
> 
> Added flex/bison files for event grammar parsing. Added
> flex/bison Makefile rules plus few special dependencies.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/Makefile                  |   21 ++
>  tools/perf/util/parse-events-bison.y |  119 +++++++++
>  tools/perf/util/parse-events-flex.l  |  111 ++++++++
>  tools/perf/util/parse-events.c       |  459 +++++++++++-----------------------
>  tools/perf/util/parse-events.h       |    9 +
>  5 files changed, 411 insertions(+), 308 deletions(-)
>  create mode 100644 tools/perf/util/parse-events-bison.y
>  create mode 100644 tools/perf/util/parse-events-flex.l
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index ac86d67..ef6b621 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -47,6 +47,8 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>  
>  CC = $(CROSS_COMPILE)gcc
>  AR = $(CROSS_COMPILE)ar
> +FLEX = $(CROSS_COMPILE)flex
> +BISON= $(CROSS_COMPILE)bison
>  
>  # Additional ARCH settings for x86
>  ifeq ($(ARCH),i386)
> @@ -341,6 +343,8 @@ LIB_OBJS += $(OUTPUT)util/session.o
>  LIB_OBJS += $(OUTPUT)util/thread.o
>  LIB_OBJS += $(OUTPUT)util/thread_map.o
>  LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
> +LIB_OBJS += $(OUTPUT)util/parse-events-flex.o
> +LIB_OBJS += $(OUTPUT)util/parse-events-bison.o
>  LIB_OBJS += $(OUTPUT)util/trace-event-read.o
>  LIB_OBJS += $(OUTPUT)util/trace-event-info.o
>  LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
> @@ -627,6 +631,8 @@ ifndef V
>  	QUIET_LINK     = @echo '   ' LINK $@;
>  	QUIET_MKDIR    = @echo '   ' MKDIR $@;
>  	QUIET_GEN      = @echo '   ' GEN $@;
> +	QUIET_FLEX     = @echo '   ' FLEX $@;
> +	QUIET_BISON    = @echo '   ' BISON $@;
>  endif
>  endif
>  
> @@ -713,6 +719,10 @@ $(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
>  $(OUTPUT)%.o: %.S
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
> +$(OUTPUT)%.c: %.l
> +	$(QUIET_FLEX)$(FLEX) --header-file=$*.h -t $< > $@
> +$(OUTPUT)%.c: %.y
> +	$(QUIET_BISON)$(BISON) -v $< -d -o $@
>  
>  $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
> @@ -739,6 +749,16 @@ $(OUTPUT)util/ui/browsers/map.o: util/ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
>  $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
>  
> +
> +.SECONDARY: util/parse-events-flex.c util/parse-events-flex.h
> +.SECONDARY: util/parse-events-bison.c util/parse-events-bison.h
> +
> +util/parse-events.o: util/parse-events-flex.c
> +util/parse-events-flex.c: util/parse-events-bison.c
> +
> +$(OUTPUT)util/parse-events-flex.o: util/parse-events-flex.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
> +
>  $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
>  
> @@ -910,6 +930,7 @@ clean:
>  	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
>  	$(RM) $(ALL_PROGRAMS) perf
>  	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
> +	$(RM) util/parse-events-flex.[ch] util/parse-events-bison.[cho]*
>  	$(MAKE) -C Documentation/ clean
>  	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
>  	$(python-clean)
> diff --git a/tools/perf/util/parse-events-bison.y b/tools/perf/util/parse-events-bison.y
> new file mode 100644
> index 0000000..403cbf6
> --- /dev/null
> +++ b/tools/perf/util/parse-events-bison.y
> @@ -0,0 +1,119 @@
> +
> +%name-prefix "parse_events_"
> +
> +%{
> +
> +#define YYDEBUG 1
> +
> +#include <linux/compiler.h>
> +#include "types.h"
> +#include "util.h"
> +#include "parse-events.h"
> +
> +extern int parse_events_lex (void);
> +
> +#define ABORT_ON(val) \
> +do { \
> +	if (val) \
> +		YYABORT; \
> +} while (0)
> +
> +%}
> +
> +%token PE_VALUE
> +%token PE_MODIFIER_BPTYPE PE_MODIFIER_EVENT
> +%token PE_NAME_TP PE_NAME_SYM
> +%token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
> +%token PE_SEP_RAW PE_SEP_BP
> +%token PE_ERROR
> +%type <l> PE_VALUE
> +%type <s> PE_NAME_TP
> +%type <s> PE_NAME_SYM
> +%type <s> PE_NAME_CACHE_TYPE
> +%type <s> PE_NAME_CACHE_OP_RESULT
> +%type <s> PE_MODIFIER_EVENT
> +%type <s> modifier
> +%type <s> PE_MODIFIER_BPTYPE
> +%type <s> event_breakpoint_type
> +
> +%union
> +{
> +	char *s;
> +	long l;
> +}
> +
> +%%
> +
> +events: events ',' event | event
> +
> +event:  event_tracepoint |
> +	event_raw |
> +	event_numeric |
> +	event_symbolic |
> +	event_generic_hw |
> +	event_breakpoint
> +
> +event_tracepoint: PE_NAME_TP ':' PE_NAME_TP modifier
> +{
> +	ABORT_ON(parse_events_add_tracepoint($1, $3, $4));
> +}
> +
> +event_raw: PE_SEP_RAW PE_VALUE modifier
> +{
> +	ABORT_ON(parse_events_add_raw($2, $3));
> +}
> +
> +event_numeric: PE_VALUE ':' PE_VALUE modifier
> +{
> +	ABORT_ON(parse_events_add_numeric($1, $3, $4));
> +}
> +
> +event_symbolic: PE_NAME_SYM modifier
> +{
> +	ABORT_ON(parse_events_add_symbolic($1, $2));
> +}
> +
> +event_generic_hw:
> +PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT modifier
> +{
> +	ABORT_ON(parse_events_add_generic_hw($1, $3, $5, $6));
> +}
> +|
> +PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT modifier
> +{
> +	ABORT_ON(parse_events_add_generic_hw($1, $3, NULL, $4));
> +}
> +|
> +PE_NAME_CACHE_TYPE modifier
> +{
> +	ABORT_ON(parse_events_add_generic_hw($1, NULL, NULL, $2));
> +}
> +
> +event_breakpoint: PE_SEP_BP ':' PE_VALUE event_breakpoint_type modifier
> +{
> +	ABORT_ON(parse_events_add_breakpoint((void *) $3, $4, $5))
> +}
> +
> +event_breakpoint_type: PE_MODIFIER_BPTYPE
> +{
> +	$$ = $1
> +}
> +|
> +{
> +	$$ = NULL;
> +}
> +
> +modifier: PE_MODIFIER_EVENT
> +{
> +	$$ = $1;
> +}
> +|
> +{
> +	$$ = NULL;
> +}
> +
> +%%
> +
> +void parse_events_error(char const *msg __used)
> +{
> +}
> diff --git a/tools/perf/util/parse-events-flex.l b/tools/perf/util/parse-events-flex.l
> new file mode 100644
> index 0000000..84b9b0e
> --- /dev/null
> +++ b/tools/perf/util/parse-events-flex.l
> @@ -0,0 +1,111 @@
> +
> +%option prefix="parse_events_"
> +
> +%{
> +#include <errno.h>
> +#include "parse-events-bison.h"
> +
> +enum {
> +	VALUE_DEC,
> +	VALUE_HEX,
> +};
> +
> +static int value(int base)
> +{
> +	long num;
> +
> +	errno = 0;
> +	num = strtol(parse_events_text, NULL, base);
> +	if (errno)
> +		return PE_ERROR;
> +
> +	parse_events_lval.l = num;
> +	return PE_VALUE;
> +}
> +
> +static int __str(char *s, int token)
> +{
> +	parse_events_lval.s = strdup(s);
> +	return token;
> +}
> +
> +static int str(int token)
> +{
> +	return __str(parse_events_text, token);
> +}
> +
> +static int mod(int token)
> +{
> +	return __str(parse_events_text + 1, token);
> +}
> +
> +%}
> +
> +num_dec		[0-9]+
> +num_hex		0x[a-fA-F0-9]+
> +name_tp		[a-zA-Z_*?]+
> +
> +%x BP
> +
> +%%
> +
> +cpu-cycles|cycles				|
> +stalled-cycles-frontend|idle-cycles-frontend	|
> +stalled-cycles-backend|idle-cycles-backend	|
> +instructions					|
> +cache-references				|
> +cache-misses					|
> +branch-instructions|branches			|
> +branch-misses					|
> +bus-cycles					|
> +cpu-clock					|
> +task-clock					|
> +page-faults|faults				|
> +minor-faults					|
> +major-faults					|
> +context-switches|cs				|
> +cpu-migrations|migrations			|
> +alignment-faults				|
> +emulation-faults				{ return str(PE_NAME_SYM); }
> +
> +L1-dcache|l1-d|l1d|L1-data		|
> +L1-icache|l1-i|l1i|L1-instruction	|
> +LLC|L2					|
> +dTLB|d-tlb|Data-TLB			|
> +iTLB|i-tlb|Instruction-TLB		|
> +branch|branches|bpu|btb|bpc		|
> +node					{ return str(PE_NAME_CACHE_TYPE); }
> +
> +load|loads|read				|
> +store|stores|write			|
> +prefetch|prefetches			|
> +speculative-read|speculative-load	|
> +refs|Reference|ops|access		|
> +misses|miss				{ return str(PE_NAME_CACHE_OP_RESULT); }
> +
> +{num_dec}		{ return value(10); }
> +{num_hex}		{ return value(16); }
> +
> +r			{ return PE_SEP_RAW; }
> +
> +mem			{ BEGIN(BP); return PE_SEP_BP; }
> +<BP>:[rwx]{1,3}		{ return mod(PE_MODIFIER_BPTYPE); }
> +<BP>:[ukhp]{1,2}	{ return mod(PE_MODIFIER_EVENT); }
> +<BP>:			{ return ':'; }
> +<BP>{num_dec}		{ return value(10); }
> +<BP>{num_hex}		{ return value(16); }
> +<BP><<EOF>>		{ BEGIN(INITIAL); }
> +<BP>.			{ BEGIN(INITIAL); }
> +
> +:[ukhp]{1,2}		{ return mod(PE_MODIFIER_EVENT); }
> +{name_tp}		{ return str(PE_NAME_TP); }
> +-			{ return '-'; }
> +,			{ return ','; }
> +:			{ return ':'; }
> +
> +%%
> +
> +int parse_events_wrap(void)
> +{
> +	return 1;
> +}
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 586ab3f..b9c4189 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -11,6 +11,9 @@
>  #include "cache.h"
>  #include "header.h"
>  #include "debugfs.h"
> +#include "parse-events-flex.h"
> +
> +#define MAX_NAME_LEN 100
>  
>  struct event_symbol {
>  	u8		type;
> @@ -19,11 +22,9 @@ struct event_symbol {
>  	const char	*alias;
>  };
>  
> -enum event_result {
> -	EVT_FAILED,
> -	EVT_HANDLED,
> -	EVT_HANDLED_ALL
> -};
> +int parse_events_parse(void);
> +
> +static struct perf_evlist *__evlist;
>  
>  #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
>  #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
> @@ -352,7 +353,31 @@ const char *__event_name(int type, u64 config)
>  	return "unknown";
>  }
>  
> -static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int size)
> +static void
> +parse_event_modifier(char *mod, struct perf_event_attr *attr);
> +
> +static int add_event(struct perf_event_attr *attr, char *name, char *mod)
> +{
> +	struct perf_evsel *evsel;
> +	int len = strlen(name);
> +
> +	parse_event_modifier(mod, attr);
> +
> +	evsel = perf_evsel__new(attr, __evlist->nr_entries);
> +	if (!evsel)
> +		return -ENOMEM;
> +
> +	perf_evlist__add(__evlist, evsel);
> +
> +	evsel->name = zalloc(len);
> +	if (!evsel->name)
> +		return -ENOMEM;
> +
> +	strncpy(evsel->name, name, len);
> +	return 0;
> +}
> +
> +static int parse_aliases(char *str, const char *names[][MAX_ALIASES], int size)
>  {
>  	int i, j;
>  	int n, longest = -1;
> @@ -360,58 +385,57 @@ static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int
>  	for (i = 0; i < size; i++) {
>  		for (j = 0; j < MAX_ALIASES && names[i][j]; j++) {
>  			n = strlen(names[i][j]);
> -			if (n > longest && !strncasecmp(*str, names[i][j], n))
> +			if (n > longest && !strncasecmp(str, names[i][j], n))
>  				longest = n;
>  		}
> -		if (longest > 0) {
> -			*str += longest;
> +		if (longest > 0)
>  			return i;
> -		}
>  	}
>  
>  	return -1;
>  }
>  
> -static enum event_result
> -parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
> +int parse_events_add_generic_hw(char *type, char *op_result1, char *op_result2,
> +				char *mod)
>  {
> -	const char *s = *str;
> +	struct perf_event_attr attr;
> +	char name[MAX_NAME_LEN];
>  	int cache_type = -1, cache_op = -1, cache_result = -1;
> +	char *op_result[2] = { op_result1, op_result2 };
> +	int i, n;
>  
> -	cache_type = parse_aliases(&s, hw_cache, PERF_COUNT_HW_CACHE_MAX);
>  	/*
>  	 * No fallback - if we cannot get a clear cache type
>  	 * then bail out:
>  	 */
> +	cache_type = parse_aliases(type, hw_cache,
> +				   PERF_COUNT_HW_CACHE_MAX);
>  	if (cache_type == -1)
> -		return EVT_FAILED;
> +		return -EINVAL;
>  
> -	while ((cache_op == -1 || cache_result == -1) && *s == '-') {
> -		++s;
> +	n = snprintf(name, MAX_NAME_LEN, "%s", type);
> +
> +	for (i = 0; (i < 2) && (op_result[i]); i++) {
> +		char *str = op_result[i];
> +
> +		snprintf(name + n, MAX_NAME_LEN - n, "-%s\n", str);
>  
>  		if (cache_op == -1) {
> -			cache_op = parse_aliases(&s, hw_cache_op,
> -						PERF_COUNT_HW_CACHE_OP_MAX);
> +			cache_op = parse_aliases(str, hw_cache_op,
> +						 PERF_COUNT_HW_CACHE_OP_MAX);
>  			if (cache_op >= 0) {
>  				if (!is_cache_op_valid(cache_type, cache_op))
> -					return EVT_FAILED;
> +					return -EINVAL;
>  				continue;
>  			}
>  		}
>  
>  		if (cache_result == -1) {
> -			cache_result = parse_aliases(&s, hw_cache_result,
> +			cache_result = parse_aliases(str, hw_cache_result,
>  						PERF_COUNT_HW_CACHE_RESULT_MAX);
>  			if (cache_result >= 0)
>  				continue;
>  		}
> -
> -		/*
> -		 * Can't parse this as a cache op or result, so back up
> -		 * to the '-'.
> -		 */
> -		--s;
> -		break;
>  	}
>  
>  	/*
> @@ -426,20 +450,16 @@ parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
>  	if (cache_result == -1)
>  		cache_result = PERF_COUNT_HW_CACHE_RESULT_ACCESS;
>  
> -	attr->config = cache_type | (cache_op << 8) | (cache_result << 16);
> -	attr->type = PERF_TYPE_HW_CACHE;
> -
> -	*str = s;
> -	return EVT_HANDLED;
> +	memset(&attr, 0, sizeof(attr));
> +	attr.config = cache_type | (cache_op << 8) | (cache_result << 16);
> +	attr.type = PERF_TYPE_HW_CACHE;
> +	return add_event(&attr, name, mod);
>  }
>  
> -static enum event_result
> -parse_single_tracepoint_event(char *sys_name,
> -			      const char *evt_name,
> -			      unsigned int evt_length,
> -			      struct perf_event_attr *attr,
> -			      const char **strp)
> +static int add_tracepoint(char *sys_name, char *evt_name, char *mod)
>  {
> +	struct perf_event_attr attr;
> +	char name[MAX_NAME_LEN];
>  	char evt_path[MAXPATHLEN];
>  	char id_buf[4];
>  	u64 id;
> @@ -450,130 +470,78 @@ parse_single_tracepoint_event(char *sys_name,
>  
>  	fd = open(evt_path, O_RDONLY);
>  	if (fd < 0)
> -		return EVT_FAILED;
> +		return -1;
>  
>  	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
>  		close(fd);
> -		return EVT_FAILED;
> +		return -1;
>  	}
>  
>  	close(fd);
>  	id = atoll(id_buf);
> -	attr->config = id;
> -	attr->type = PERF_TYPE_TRACEPOINT;
> -	*strp += strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
> -
> -	attr->sample_type |= PERF_SAMPLE_RAW;
> -	attr->sample_type |= PERF_SAMPLE_TIME;
> -	attr->sample_type |= PERF_SAMPLE_CPU;
>  
> -	attr->sample_period = 1;
> +	memset(&attr, 0, sizeof(attr));
> +	attr.config = id;
> +	attr.type = PERF_TYPE_TRACEPOINT;
> +	attr.sample_type |= PERF_SAMPLE_RAW;
> +	attr.sample_type |= PERF_SAMPLE_TIME;
> +	attr.sample_type |= PERF_SAMPLE_CPU;
> +	attr.sample_period = 1;
>  
> -
> -	return EVT_HANDLED;
> +	snprintf(name, MAX_NAME_LEN, "%s:%s", sys_name, evt_name);
> +	return add_event(&attr, name, mod);
>  }
>  
> -/* sys + ':' + event + ':' + flags*/
> -#define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
> -static enum event_result
> -parse_multiple_tracepoint_event(struct perf_evlist *evlist, char *sys_name,
> -				const char *evt_exp, char *flags)
> +static int add_tracepoint_multi(char *sys_name, char *evt_name, char *mod)
>  {
>  	char evt_path[MAXPATHLEN];
>  	struct dirent *evt_ent;
>  	DIR *evt_dir;
> +	int ret = 0;
>  
>  	snprintf(evt_path, MAXPATHLEN, "%s/%s", tracing_events_path, sys_name);
>  	evt_dir = opendir(evt_path);
> -
>  	if (!evt_dir) {
>  		perror("Can't open event dir");
> -		return EVT_FAILED;
> +		return -1;
>  	}
>  
> -	while ((evt_ent = readdir(evt_dir))) {
> -		char event_opt[MAX_EVOPT_LEN + 1];
> -		int len;
> -
> +	while (!ret && (evt_ent = readdir(evt_dir))) {
>  		if (!strcmp(evt_ent->d_name, ".")
>  		    || !strcmp(evt_ent->d_name, "..")
>  		    || !strcmp(evt_ent->d_name, "enable")
>  		    || !strcmp(evt_ent->d_name, "filter"))
>  			continue;
>  
> -		if (!strglobmatch(evt_ent->d_name, evt_exp))
> +		if (!strglobmatch(evt_ent->d_name, evt_name))
>  			continue;
>  
> -		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s%s%s", sys_name,
> -			       evt_ent->d_name, flags ? ":" : "",
> -			       flags ?: "");
> -		if (len < 0)
> -			return EVT_FAILED;
> -
> -		if (parse_events(evlist, event_opt, 0))
> -			return EVT_FAILED;
> +		ret = add_tracepoint(sys_name, evt_ent->d_name, mod);
>  	}
>  
> -	return EVT_HANDLED_ALL;
> +	return ret;
>  }
>  
> -static enum event_result
> -parse_tracepoint_event(struct perf_evlist *evlist, const char **strp,
> -		       struct perf_event_attr *attr)
> +int parse_events_add_tracepoint(char *sys, char *event, char *mod)
>  {
> -	const char *evt_name;
> -	char *flags = NULL, *comma_loc;
> -	char sys_name[MAX_EVENT_LENGTH];
> -	unsigned int sys_length, evt_length;
> -
> -	if (debugfs_valid_mountpoint(tracing_events_path))
> -		return 0;
> +	int ret;
>  
> -	evt_name = strchr(*strp, ':');
> -	if (!evt_name)
> -		return EVT_FAILED;
> -
> -	sys_length = evt_name - *strp;
> -	if (sys_length >= MAX_EVENT_LENGTH)
> -		return 0;
> +	ret = debugfs_valid_mountpoint(tracing_events_path);
> +	if (ret)
> +		return ret;
>  
> -	strncpy(sys_name, *strp, sys_length);
> -	sys_name[sys_length] = '\0';
> -	evt_name = evt_name + 1;
> -
> -	comma_loc = strchr(evt_name, ',');
> -	if (comma_loc) {
> -		/* take the event name up to the comma */
> -		evt_name = strndup(evt_name, comma_loc - evt_name);
> -	}
> -	flags = strchr(evt_name, ':');
> -	if (flags) {
> -		/* split it out: */
> -		evt_name = strndup(evt_name, flags - evt_name);
> -		flags++;
> -	}
> -
> -	evt_length = strlen(evt_name);
> -	if (evt_length >= MAX_EVENT_LENGTH)
> -		return EVT_FAILED;
> -	if (strpbrk(evt_name, "*?")) {
> -		*strp += strlen(sys_name) + evt_length + 1; /* 1 == the ':' */
> -		return parse_multiple_tracepoint_event(evlist, sys_name,
> -						       evt_name, flags);
> -	} else {
> -		return parse_single_tracepoint_event(sys_name, evt_name,
> -						     evt_length, attr, strp);
> -	}
> +	return strpbrk(event, "*?") ?
> +	       add_tracepoint_multi(sys, event, mod) :
> +	       add_tracepoint(sys, event, mod);
>  }
>  
> -static enum event_result
> -parse_breakpoint_type(const char *type, const char **strp,
> -		      struct perf_event_attr *attr)
> +static int
> +parse_breakpoint_type(const char *type, struct perf_event_attr *attr)
>  {
>  	int i;
>  
>  	for (i = 0; i < 3; i++) {
> -		if (!type[i])
> +		if (!type || !type[i])
>  			break;
>  
>  		switch (type[i]) {
> @@ -587,65 +555,40 @@ parse_breakpoint_type(const char *type, const char **strp,
>  			attr->bp_type |= HW_BREAKPOINT_X;
>  			break;
>  		default:
> -			return EVT_FAILED;
> +			return -EINVAL;
>  		}
>  	}
> +
>  	if (!attr->bp_type) /* Default */
>  		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
>  
> -	*strp = type + i;
> -
> -	return EVT_HANDLED;
> +	return 0;
>  }
>  
> -static enum event_result
> -parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
> +int parse_events_add_breakpoint(void *ptr, char *type, char *mod)
>  {
> -	const char *target;
> -	const char *type;
> -	char *endaddr;
> -	u64 addr;
> -	enum event_result err;
> -
> -	target = strchr(*strp, ':');
> -	if (!target)
> -		return EVT_FAILED;
> -
> -	if (strncmp(*strp, "mem", target - *strp) != 0)
> -		return EVT_FAILED;
> -
> -	target++;
> -
> -	addr = strtoull(target, &endaddr, 0);
> -	if (target == endaddr)
> -		return EVT_FAILED;
> -
> -	attr->bp_addr = addr;
> -	*strp = endaddr;
> +	struct perf_event_attr attr;
> +	char name[MAX_NAME_LEN];
>  
> -	type = strchr(target, ':');
> +	memset(&attr, 0, sizeof(attr));
> +	attr.bp_addr = (u64) ptr;
>  
> -	/* If no type is defined, just rw as default */
> -	if (!type) {
> -		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
> -	} else {
> -		err = parse_breakpoint_type(++type, strp, attr);
> -		if (err == EVT_FAILED)
> -			return EVT_FAILED;
> -	}
> +	if (parse_breakpoint_type(type, &attr))
> +		return -EINVAL;
>  
>  	/*
>  	 * We should find a nice way to override the access length
>  	 * Provide some defaults for now
>  	 */
> -	if (attr->bp_type == HW_BREAKPOINT_X)
> -		attr->bp_len = sizeof(long);
> +	if (attr.bp_type == HW_BREAKPOINT_X)
> +		attr.bp_len = sizeof(long);
>  	else
> -		attr->bp_len = HW_BREAKPOINT_LEN_4;
> +		attr.bp_len = HW_BREAKPOINT_LEN_4;
>  
> -	attr->type = PERF_TYPE_BREAKPOINT;
> +	attr.type = PERF_TYPE_BREAKPOINT;
>  
> -	return EVT_HANDLED;
> +	snprintf(name, MAX_NAME_LEN, "mem:%p:%s", ptr, type ? type : "rw");
> +	return add_event(&attr, name, mod);
>  }
>  
>  static int check_events(const char *str, unsigned int i)
> @@ -665,85 +608,59 @@ static int check_events(const char *str, unsigned int i)
>  	return 0;
>  }
>  
> -static enum event_result
> -parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
> +int parse_events_add_symbolic(char *symbol, char *mod)
>  {
> -	const char *str = *strp;
> +	struct perf_event_attr attr;
> +	char name[MAX_NAME_LEN];
>  	unsigned int i;
> -	int n;
>  
>  	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
> -		n = check_events(str, i);
> -		if (n > 0) {
> -			attr->type = event_symbols[i].type;
> -			attr->config = event_symbols[i].config;
> -			*strp = str + n;
> -			return EVT_HANDLED;
> -		}
> +		if (!check_events(symbol, i))
> +			continue;
> +		memset(&attr, 0, sizeof(attr));
> +		attr.type = event_symbols[i].type;
> +		attr.config = event_symbols[i].config;
> +		snprintf(name, MAX_NAME_LEN, "%s", event_symbols[i].symbol);
> +		return add_event(&attr, name, mod);
>  	}
> -	return EVT_FAILED;
> +
> +	return -EINVAL;
>  }
>  
> -static enum event_result
> -parse_raw_event(const char **strp, struct perf_event_attr *attr)
> +int parse_events_add_raw(long code, char *mod)
>  {
> -	const char *str = *strp;
> -	u64 config;
> -	int n;
> +	struct perf_event_attr attr;
> +	char name[MAX_NAME_LEN];
>  
> -	if (*str != 'r')
> -		return EVT_FAILED;
> -	n = hex2u64(str + 1, &config);
> -	if (n > 0) {
> -		const char *end = str + n + 1;
> -		if (*end != '\0' && *end != ',' && *end != ':')
> -			return EVT_FAILED;
> -
> -		*strp = end;
> -		attr->type = PERF_TYPE_RAW;
> -		attr->config = config;
> -		return EVT_HANDLED;
> -	}
> -	return EVT_FAILED;
> +	memset(&attr, 0, sizeof(attr));
> +	attr.type = PERF_TYPE_RAW;
> +	attr.config = code;
> +
> +	snprintf(name, MAX_NAME_LEN, "r%lx", code);
> +	return add_event(&attr, name, mod);
>  }
>  
> -static enum event_result
> -parse_numeric_event(const char **strp, struct perf_event_attr *attr)
> +int parse_events_add_numeric(long type, long config, char *mod)
>  {
> -	const char *str = *strp;
> -	char *endp;
> -	unsigned long type;
> -	u64 config;
> -
> -	type = strtoul(str, &endp, 0);
> -	if (endp > str && type < PERF_TYPE_MAX && *endp == ':') {
> -		str = endp + 1;
> -		config = strtoul(str, &endp, 0);
> -		if (endp > str) {
> -			attr->type = type;
> -			attr->config = config;
> -			*strp = endp;
> -			return EVT_HANDLED;
> -		}
> -	}
> -	return EVT_FAILED;
> +	struct perf_event_attr attr;
> +	char name[MAX_NAME_LEN];
> +
> +	memset(&attr, 0, sizeof(attr));
> +	attr.type = type;
> +	attr.config = config;
> +
> +	snprintf(name, MAX_NAME_LEN, "%lx:%lx", type, config);
> +	return add_event(&attr, name, mod);
>  }
>  
> -static int
> -parse_event_modifier(const char **strp, struct perf_event_attr *attr)
> +static void
> +parse_event_modifier(char *str, struct perf_event_attr *attr)
>  {
> -	const char *str = *strp;
>  	int exclude = 0;
>  	int eu = 0, ek = 0, eh = 0, precise = 0;
>  
> -	if (!*str)
> -		return 0;
> -
> -	if (*str == ',')
> -		return 0;
> -
> -	if (*str++ != ':')
> -		return -1;
> +	if (str == NULL)
> +		return;
>  
>  	while (*str) {
>  		if (*str == 'u') {
> @@ -765,108 +682,36 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
>  
>  		++str;
>  	}
> -	if (str < *strp + 2)
> -		return -1;
> -
> -	*strp = str;
>  
>  	attr->exclude_user   = eu;
>  	attr->exclude_kernel = ek;
>  	attr->exclude_hv     = eh;
>  	attr->precise_ip     = precise;
> -
> -	return 0;
> +	return;
>  }
>  
> -/*
> - * Each event can have multiple symbolic names.
> - * Symbolic names are (almost) exactly matched.
> - */
> -static enum event_result
> -parse_event_symbols(struct perf_evlist *evlist, const char **str,
> -		    struct perf_event_attr *attr)
> +int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
>  {
> -	enum event_result ret;
> -
> -	ret = parse_tracepoint_event(evlist, str, attr);
> -	if (ret != EVT_FAILED)
> -		goto modifier;
> -
> -	ret = parse_raw_event(str, attr);
> -	if (ret != EVT_FAILED)
> -		goto modifier;
> +	YY_BUFFER_STATE buffer;
> +	int ret;
>  
> -	ret = parse_numeric_event(str, attr);
> -	if (ret != EVT_FAILED)
> -		goto modifier;
> +	__evlist = evlist;
>  
> -	ret = parse_symbolic_event(str, attr);
> -	if (ret != EVT_FAILED)
> -		goto modifier;
> +	buffer = parse_events__scan_string(str);
>  
> -	ret = parse_generic_hw_event(str, attr);
> -	if (ret != EVT_FAILED)
> -		goto modifier;
> +	ret = parse_events_parse();
>  
> -	ret = parse_breakpoint_event(str, attr);
> -	if (ret != EVT_FAILED)
> -		goto modifier;
> +	parse_events__flush_buffer(buffer);
> +	parse_events__delete_buffer(buffer);
>  
> -	fprintf(stderr, "invalid or unsupported event: '%s'\n", *str);
> -	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
> -	return EVT_FAILED;
> -
> -modifier:
> -	if (parse_event_modifier(str, attr) < 0) {
> -		fprintf(stderr, "invalid event modifier: '%s'\n", *str);
> -		fprintf(stderr, "Run 'perf list' for a list of valid events and modifiers\n");
> -
> -		return EVT_FAILED;
> +	if (ret) {
> +		fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
> +		fprintf(stderr, "Run 'perf list' for a list of valid events\n");
>  	}
>  
>  	return ret;
>  }
>  
> -int parse_events(struct perf_evlist *evlist , const char *str, int unset __used)
> -{
> -	struct perf_event_attr attr;
> -	enum event_result ret;
> -	const char *ostr;
> -
> -	for (;;) {
> -		ostr = str;
> -		memset(&attr, 0, sizeof(attr));
> -		ret = parse_event_symbols(evlist, &str, &attr);
> -		if (ret == EVT_FAILED)
> -			return -1;
> -
> -		if (!(*str == 0 || *str == ',' || isspace(*str)))
> -			return -1;
> -
> -		if (ret != EVT_HANDLED_ALL) {
> -			struct perf_evsel *evsel;
> -			evsel = perf_evsel__new(&attr, evlist->nr_entries);
> -			if (evsel == NULL)
> -				return -1;
> -			perf_evlist__add(evlist, evsel);
> -
> -			evsel->name = calloc(str - ostr + 1, 1);
> -			if (!evsel->name)
> -				return -1;
> -			strncpy(evsel->name, ostr, str - ostr);
> -		}
> -
> -		if (*str == 0)
> -			break;
> -		if (*str == ',')
> -			++str;
> -		while (isspace(*str))
> -			++str;
> -	}
> -
> -	return 0;
> -}
> -
>  int parse_events_option(const struct option *opt, const char *str,
>  			int unset __used)
>  {
> @@ -1039,8 +884,6 @@ int print_hwcache_events(const char *event_glob)
>  	return printed;
>  }
>  
> -#define MAX_NAME_LEN 100
> -
>  /*
>   * Print the help text for the event symbols:
>   */
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index 7e0cbe7..fa3ac7f 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -33,6 +33,15 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
>  
>  #define EVENTS_HELP_MAX (128*1024)
>  
> +int parse_events_add_tracepoint(char *sys, char *event, char *mod);
> +int parse_events_add_raw(long code, char *mod);
> +int parse_events_add_numeric(long type, long config, char *mod);
> +int parse_events_add_symbolic(char *symbol, char *mod);
> +int parse_events_add_generic_hw(char *type, char *op_result1, char *op_result2,
> +				char *mod);
> +int parse_events_add_breakpoint(void *ptr, char *type, char *mod);
> +void parse_events_error(char const *msg);
> +
>  void print_events(const char *event_glob);
>  void print_events_type(u8 type);
>  void print_tracepoint_events(const char *subsys_glob, const char *event_glob);
> -- 
> 1.7.4
