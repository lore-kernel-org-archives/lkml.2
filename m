Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2BPMB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:01:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab2BPMBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:01:54 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/8] perf, tool: Add parser generator for events parsing
Date: Thu, 16 Feb 2012 13:00:49 +0100
Message-Id: <1329393652-6055-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
References: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing event parsing to use flex/bison parse generator.
The event syntax stays as it was.

grammar description:

events: events ',' event | event

event:  event_def PE_MODIFIER_EVENT | event_def

event_def: event_legacy_symbol sep_dc     |
           event_legacy_cache sep_dc      |
           event_legacy_breakpoint sep_dc |
           event_legacy_tracepoint sep_dc |
           event_legacy_numeric sep_dc    |
           event_legacy_raw sep_dc

event_legacy_symbol:      PE_NAME_SYM

event_legacy_cache:       PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT |
                          PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT  |
                          PE_NAME_CACHE_TYPE

event_legacy_raw:         PE_SEP_RAW PE_VALUE

event_legacy_numeric:     PE_VALUE ':' PE_VALUE

event_legacy_breakpoint:  PE_SEP_BP ':' PE_VALUE ':' PE_MODIFIER_BP

event_breakpoint_type:    PE_MODIFIER_BPTYPE | empty

PE_NAME_SYM:              cpu-cycles|cycles                              |
                          stalled-cycles-frontend|idle-cycles-frontend   |
                          stalled-cycles-backend|idle-cycles-backend     |
                          instructions                                   |
                          cache-references                               |
                          cache-misses                                   |
                          branch-instructions|branches                   |
                          branch-misses                                  |
                          bus-cycles                                     |
                          cpu-clock                                      |
                          task-clock                                     |
                          page-faults|faults                             |
                          minor-faults                                   |
                          major-faults                                   |
                          context-switches|cs                            |
                          cpu-migrations|migrations                      |
                          alignment-faults                               |
                          emulation-faults

PE_NAME_CACHE_TYPE:       L1-dcache|l1-d|l1d|L1-data             |
                          L1-icache|l1-i|l1i|L1-instruction      |
                          LLC|L2                                 |
                          dTLB|d-tlb|Data-TLB                    |
                          iTLB|i-tlb|Instruction-TLB             |
                          branch|branches|bpu|btb|bpc            |
                          node

PE_NAME_CACHE_OP_RESULT:  load|loads|read                        |
                          store|stores|write                     |
                          prefetch|prefetches                    |
                          speculative-read|speculative-load      |
                          refs|Reference|ops|access              |
                          misses|miss

PE_MODIFIER_EVENT:        [ukhp]{0,5}

PE_MODIFIER_BP:           [rwx]

PE_SEP_BP:                'mem'

PE_SEP_RAW:               'r'

sep_dc:                   ':' |

Added flex/bison files for event grammar parsing. The generated
parser is part of the patch. Added makefile rule 'event-parser'
to generate the parser code out of the bison/flex sources.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile                  |   17 +
 tools/perf/builtin-test.c            |    6 +-
 tools/perf/util/parse-events-bison.c | 1715 ++++++++++++++++++++++++++
 tools/perf/util/parse-events-bison.h |   79 ++
 tools/perf/util/parse-events-flex.c  | 2225 ++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events-flex.h  |  316 +++++
 tools/perf/util/parse-events.c       |  486 +++------
 tools/perf/util/parse-events.h       |   15 +
 tools/perf/util/parse-events.l       |  107 ++
 tools/perf/util/parse-events.y       |  127 ++
 10 files changed, 4752 insertions(+), 341 deletions(-)
 create mode 100644 tools/perf/util/parse-events-bison.c
 create mode 100644 tools/perf/util/parse-events-bison.h
 create mode 100644 tools/perf/util/parse-events-flex.c
 create mode 100644 tools/perf/util/parse-events-flex.h
 create mode 100644 tools/perf/util/parse-events.l
 create mode 100644 tools/perf/util/parse-events.y

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7124381..4e3b411 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -47,6 +47,8 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
+FLEX = $(CROSS_COMPILE)flex
+BISON= $(CROSS_COMPILE)bison
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
@@ -340,6 +342,8 @@ LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
+LIB_OBJS += $(OUTPUT)util/parse-events-flex.o
+LIB_OBJS += $(OUTPUT)util/parse-events-bison.o
 LIB_OBJS += $(OUTPUT)util/trace-event-read.o
 LIB_OBJS += $(OUTPUT)util/trace-event-info.o
 LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
@@ -628,6 +632,8 @@ ifndef V
 	QUIET_LINK     = @echo '   ' LINK $@;
 	QUIET_MKDIR    = @echo '   ' MKDIR $@;
 	QUIET_GEN      = @echo '   ' GEN $@;
+	QUIET_FLEX     = @echo '   ' FLEX $@;
+	QUIET_BISON    = @echo '   ' BISON $@;
 endif
 endif
 
@@ -708,6 +714,9 @@ $(OUTPUT)perf.o perf.spec \
 	$(SCRIPTS) \
 	: $(OUTPUT)PERF-VERSION-FILE
 
+.SUFFIXES:
+.SUFFIXES: .o .c .S .s
+
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
 $(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
@@ -740,6 +749,9 @@ $(OUTPUT)util/ui/browsers/map.o: util/ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/parse-events-flex.o: util/parse-events-flex.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
@@ -776,6 +788,7 @@ help:
 	@echo '  html		- make html documentation'
 	@echo '  info		- make GNU info documentation (access with info <foo>)'
 	@echo '  pdf		- make pdf documentation'
+	@echo '  event-parser	- make event parser code'
 	@echo '  TAGS		- use etags to make tag information for source browsing'
 	@echo '  tags		- use ctags to make tag information for source browsing'
 	@echo '  cscope	- use cscope to make interactive browsing database'
@@ -825,6 +838,10 @@ cscope:
 	$(RM) cscope*
 	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
 
+event-parser:
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o util/parse-events-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=util/parse-events-flex.h -t util/parse-events.l > util/parse-events-flex.c
+
 ### Detect prefix changes
 TRACK_CFLAGS = $(subst ','\'',$(ALL_CFLAGS)):\
              $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 70c4eb2..adf959f 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -650,7 +650,7 @@ static int test__checkevent_raw(struct perf_evlist *evlist)
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config", 0x1a == evsel->attr.config);
 	return 0;
 }
 
@@ -872,7 +872,7 @@ static struct test__event_st {
 		.check = test__checkevent_tracepoint_multi,
 	},
 	{
-		.name  = "r1",
+		.name  = "r1a",
 		.check = test__checkevent_raw,
 	},
 	{
@@ -916,7 +916,7 @@ static struct test__event_st {
 		.check = test__checkevent_tracepoint_multi_modifier,
 	},
 	{
-		.name  = "r1:kp",
+		.name  = "r1a:kp",
 		.check = test__checkevent_raw_modifier,
 	},
 	{
diff --git a/tools/perf/util/parse-events-bison.c b/tools/perf/util/parse-events-bison.c
new file mode 100644
index 0000000..20fca26
--- /dev/null
+++ b/tools/perf/util/parse-events-bison.c
@@ -0,0 +1,1715 @@
+/* A Bison parser, made by GNU Bison 2.4.3.  */
+
+/* Skeleton implementation for Bison's Yacc-like parsers in C
+   
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
+   2009, 2010 Free Software Foundation, Inc.
+   
+   This program is free software: you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation, either version 3 of the License, or
+   (at your option) any later version.
+   
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+   
+   You should have received a copy of the GNU General Public License
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+
+/* As a special exception, you may create a larger work that contains
+   part or all of the Bison parser skeleton and distribute that work
+   under terms of your choice, so long as that work isn't itself a
+   parser generator using the skeleton or a modified version thereof
+   as a parser skeleton.  Alternatively, if you modify or redistribute
+   the parser skeleton itself, you may (at your option) remove this
+   special exception, which will cause the skeleton and the resulting
+   Bison output files to be licensed under the GNU General Public
+   License without this special exception.
+   
+   This special exception was added by the Free Software Foundation in
+   version 2.2 of Bison.  */
+
+/* C LALR(1) parser skeleton written by Richard Stallman, by
+   simplifying the original so-called "semantic" parser.  */
+
+/* All symbols defined below should begin with yy or YY, to avoid
+   infringing on user name space.  This should be done even for local
+   variables, as they might otherwise be expanded by user macros.
+   There are some unavoidable exceptions within include files to
+   define necessary library symbols; they are noted "INFRINGES ON
+   USER NAME SPACE" below.  */
+
+/* Identify Bison output.  */
+#define YYBISON 1
+
+/* Bison version.  */
+#define YYBISON_VERSION "2.4.3"
+
+/* Skeleton name.  */
+#define YYSKELETON_NAME "yacc.c"
+
+/* Pure parsers.  */
+#define YYPURE 0
+
+/* Push parsers.  */
+#define YYPUSH 0
+
+/* Pull parsers.  */
+#define YYPULL 1
+
+/* Using locations.  */
+#define YYLSP_NEEDED 0
+
+/* Substitute the variable and function names.  */
+#define yyparse         parse_events_parse
+#define yylex           parse_events_lex
+#define yyerror         parse_events_error
+#define yylval          parse_events_lval
+#define yychar          parse_events_char
+#define yydebug         parse_events_debug
+#define yynerrs         parse_events_nerrs
+
+
+/* Copy the first part of user declarations.  */
+
+/* Line 189 of yacc.c  */
+#line 6 "util/parse-events.y"
+
+
+#define YYDEBUG 1
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+#include "types.h"
+#include "util.h"
+#include "parse-events.h"
+
+extern int parse_events_lex (void);
+
+#define ABORT_ON(val) \
+do { \
+	if (val) \
+		YYABORT; \
+} while (0)
+
+
+
+/* Line 189 of yacc.c  */
+#line 101 "util/parse-events-bison.c"
+
+/* Enabling traces.  */
+#ifndef YYDEBUG
+# define YYDEBUG 0
+#endif
+
+/* Enabling verbose error messages.  */
+#ifdef YYERROR_VERBOSE
+# undef YYERROR_VERBOSE
+# define YYERROR_VERBOSE 1
+#else
+# define YYERROR_VERBOSE 0
+#endif
+
+/* Enabling the token table.  */
+#ifndef YYTOKEN_TABLE
+# define YYTOKEN_TABLE 0
+#endif
+
+
+/* Tokens.  */
+#ifndef YYTOKENTYPE
+# define YYTOKENTYPE
+   /* Put the tokens into the symbol table, so that GDB and other debuggers
+      know about them.  */
+   enum yytokentype {
+     PE_VALUE = 258,
+     PE_VALUE_SYM = 259,
+     PE_RAW = 260,
+     PE_NAME = 261,
+     PE_MODIFIER_EVENT = 262,
+     PE_MODIFIER_BP = 263,
+     PE_NAME_CACHE_TYPE = 264,
+     PE_NAME_CACHE_OP_RESULT = 265,
+     PE_PREFIX_MEM = 266,
+     PE_PREFIX_RAW = 267,
+     PE_ERROR = 268
+   };
+#endif
+
+
+
+#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
+typedef union YYSTYPE
+{
+
+/* Line 214 of yacc.c  */
+#line 42 "util/parse-events.y"
+
+	char *str;
+	unsigned long num;
+
+
+
+/* Line 214 of yacc.c  */
+#line 157 "util/parse-events-bison.c"
+} YYSTYPE;
+# define YYSTYPE_IS_TRIVIAL 1
+# define yystype YYSTYPE /* obsolescent; will be withdrawn */
+# define YYSTYPE_IS_DECLARED 1
+#endif
+
+
+/* Copy the second part of user declarations.  */
+
+
+/* Line 264 of yacc.c  */
+#line 169 "util/parse-events-bison.c"
+
+#ifdef short
+# undef short
+#endif
+
+#ifdef YYTYPE_UINT8
+typedef YYTYPE_UINT8 yytype_uint8;
+#else
+typedef unsigned char yytype_uint8;
+#endif
+
+#ifdef YYTYPE_INT8
+typedef YYTYPE_INT8 yytype_int8;
+#elif (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+typedef signed char yytype_int8;
+#else
+typedef short int yytype_int8;
+#endif
+
+#ifdef YYTYPE_UINT16
+typedef YYTYPE_UINT16 yytype_uint16;
+#else
+typedef unsigned short int yytype_uint16;
+#endif
+
+#ifdef YYTYPE_INT16
+typedef YYTYPE_INT16 yytype_int16;
+#else
+typedef short int yytype_int16;
+#endif
+
+#ifndef YYSIZE_T
+# ifdef __SIZE_TYPE__
+#  define YYSIZE_T __SIZE_TYPE__
+# elif defined size_t
+#  define YYSIZE_T size_t
+# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
+#  define YYSIZE_T size_t
+# else
+#  define YYSIZE_T unsigned int
+# endif
+#endif
+
+#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)
+
+#ifndef YY_
+# if defined YYENABLE_NLS && YYENABLE_NLS
+#  if ENABLE_NLS
+#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
+#   define YY_(msgid) dgettext ("bison-runtime", msgid)
+#  endif
+# endif
+# ifndef YY_
+#  define YY_(msgid) msgid
+# endif
+#endif
+
+/* Suppress unused-variable warnings by "using" E.  */
+#if ! defined lint || defined __GNUC__
+# define YYUSE(e) ((void) (e))
+#else
+# define YYUSE(e) /* empty */
+#endif
+
+/* Identity function, used to suppress warnings about constant conditions.  */
+#ifndef lint
+# define YYID(n) (n)
+#else
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static int
+YYID (int yyi)
+#else
+static int
+YYID (yyi)
+    int yyi;
+#endif
+{
+  return yyi;
+}
+#endif
+
+#if ! defined yyoverflow || YYERROR_VERBOSE
+
+/* The parser invokes alloca or malloc; define the necessary symbols.  */
+
+# ifdef YYSTACK_USE_ALLOCA
+#  if YYSTACK_USE_ALLOCA
+#   ifdef __GNUC__
+#    define YYSTACK_ALLOC __builtin_alloca
+#   elif defined __BUILTIN_VA_ARG_INCR
+#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
+#   elif defined _AIX
+#    define YYSTACK_ALLOC __alloca
+#   elif defined _MSC_VER
+#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
+#    define alloca _alloca
+#   else
+#    define YYSTACK_ALLOC alloca
+#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
+#     ifndef _STDLIB_H
+#      define _STDLIB_H 1
+#     endif
+#    endif
+#   endif
+#  endif
+# endif
+
+# ifdef YYSTACK_ALLOC
+   /* Pacify GCC's `empty if-body' warning.  */
+#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
+#  ifndef YYSTACK_ALLOC_MAXIMUM
+    /* The OS might guarantee only one guard page at the bottom of the stack,
+       and a page size can be as small as 4096 bytes.  So we cannot safely
+       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
+       to allow for a few compiler-allocated temporary stack slots.  */
+#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
+#  endif
+# else
+#  define YYSTACK_ALLOC YYMALLOC
+#  define YYSTACK_FREE YYFREE
+#  ifndef YYSTACK_ALLOC_MAXIMUM
+#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
+#  endif
+#  if (defined __cplusplus && ! defined _STDLIB_H \
+       && ! ((defined YYMALLOC || defined malloc) \
+	     && (defined YYFREE || defined free)))
+#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
+#   ifndef _STDLIB_H
+#    define _STDLIB_H 1
+#   endif
+#  endif
+#  ifndef YYMALLOC
+#   define YYMALLOC malloc
+#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
+#   endif
+#  endif
+#  ifndef YYFREE
+#   define YYFREE free
+#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+void free (void *); /* INFRINGES ON USER NAME SPACE */
+#   endif
+#  endif
+# endif
+#endif /* ! defined yyoverflow || YYERROR_VERBOSE */
+
+
+#if (! defined yyoverflow \
+     && (! defined __cplusplus \
+	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))
+
+/* A type that is properly aligned for any stack member.  */
+union yyalloc
+{
+  yytype_int16 yyss_alloc;
+  YYSTYPE yyvs_alloc;
+};
+
+/* The size of the maximum gap between one aligned stack and the next.  */
+# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)
+
+/* The size of an array large to enough to hold all stacks, each with
+   N elements.  */
+# define YYSTACK_BYTES(N) \
+     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
+      + YYSTACK_GAP_MAXIMUM)
+
+/* Copy COUNT objects from FROM to TO.  The source and destination do
+   not overlap.  */
+# ifndef YYCOPY
+#  if defined __GNUC__ && 1 < __GNUC__
+#   define YYCOPY(To, From, Count) \
+      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
+#  else
+#   define YYCOPY(To, From, Count)		\
+      do					\
+	{					\
+	  YYSIZE_T yyi;				\
+	  for (yyi = 0; yyi < (Count); yyi++)	\
+	    (To)[yyi] = (From)[yyi];		\
+	}					\
+      while (YYID (0))
+#  endif
+# endif
+
+/* Relocate STACK from its old location to the new one.  The
+   local variables YYSIZE and YYSTACKSIZE give the old and new number of
+   elements in the stack, and YYPTR gives the new location of the
+   stack.  Advance YYPTR to a properly aligned location for the next
+   stack.  */
+# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
+    do									\
+      {									\
+	YYSIZE_T yynewbytes;						\
+	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
+	Stack = &yyptr->Stack_alloc;					\
+	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
+	yyptr += yynewbytes / sizeof (*yyptr);				\
+      }									\
+    while (YYID (0))
+
+#endif
+
+/* YYFINAL -- State number of the termination state.  */
+#define YYFINAL  20
+/* YYLAST -- Last index in YYTABLE.  */
+#define YYLAST   27
+
+/* YYNTOKENS -- Number of terminals.  */
+#define YYNTOKENS  17
+/* YYNNTS -- Number of nonterminals.  */
+#define YYNNTS  11
+/* YYNRULES -- Number of rules.  */
+#define YYNRULES  22
+/* YYNRULES -- Number of states.  */
+#define YYNSTATES  39
+
+/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
+#define YYUNDEFTOK  2
+#define YYMAXUTOK   268
+
+#define YYTRANSLATE(YYX)						\
+  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
+
+/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
+static const yytype_uint8 yytranslate[] =
+{
+       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,    14,    15,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,    16,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
+       5,     6,     7,     8,     9,    10,    11,    12,    13
+};
+
+#if YYDEBUG
+/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
+   YYRHS.  */
+static const yytype_uint8 yyprhs[] =
+{
+       0,     0,     3,     7,     9,    12,    14,    17,    20,    22,
+      25,    28,    31,    33,    39,    43,    45,    51,    55,    59,
+      63,    65,    67
+};
+
+/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
+static const yytype_int8 yyrhs[] =
+{
+      18,     0,    -1,    18,    14,    19,    -1,    19,    -1,    20,
+       7,    -1,    20,    -1,    21,    27,    -1,    22,    27,    -1,
+      23,    -1,    24,    27,    -1,    25,    27,    -1,    26,    27,
+      -1,     4,    -1,     9,    15,    10,    15,    10,    -1,     9,
+      15,    10,    -1,     9,    -1,    11,     3,    16,     8,    27,
+      -1,    11,     3,    27,    -1,     6,    16,     6,    -1,     3,
+      16,     3,    -1,     5,    -1,    16,    -1,    -1
+};
+
+/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
+static const yytype_uint8 yyrline[] =
+{
+       0,    49,    49,    49,    52,    57,    59,    60,    61,    62,
+      63,    64,    67,    76,    81,    86,    92,    97,   103,   109,
+     115,   120,   120
+};
+#endif
+
+#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
+/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
+   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
+static const char *const yytname[] =
+{
+  "$end", "error", "$undefined", "PE_VALUE", "PE_VALUE_SYM", "PE_RAW",
+  "PE_NAME", "PE_MODIFIER_EVENT", "PE_MODIFIER_BP", "PE_NAME_CACHE_TYPE",
+  "PE_NAME_CACHE_OP_RESULT", "PE_PREFIX_MEM", "PE_PREFIX_RAW", "PE_ERROR",
+  "','", "'-'", "':'", "$accept", "events", "event", "event_def",
+  "event_legacy_symbol", "event_legacy_cache", "event_legacy_mem",
+  "event_legacy_tracepoint", "event_legacy_numeric", "event_legacy_raw",
+  "sep_dc", 0
+};
+#endif
+
+# ifdef YYPRINT
+/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
+   token YYLEX-NUM.  */
+static const yytype_uint16 yytoknum[] =
+{
+       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
+     265,   266,   267,   268,    44,    45,    58
+};
+# endif
+
+/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
+static const yytype_uint8 yyr1[] =
+{
+       0,    17,    18,    18,    19,    19,    20,    20,    20,    20,
+      20,    20,    21,    22,    22,    22,    23,    23,    24,    25,
+      26,    27,    27
+};
+
+/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
+static const yytype_uint8 yyr2[] =
+{
+       0,     2,     3,     1,     2,     1,     2,     2,     1,     2,
+       2,     2,     1,     5,     3,     1,     5,     3,     3,     3,
+       1,     1,     0
+};
+
+/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
+   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
+   means the default is an error.  */
+static const yytype_uint8 yydefact[] =
+{
+       0,     0,    12,    20,     0,    15,     0,     0,     3,     5,
+      22,    22,     8,    22,    22,    22,     0,     0,     0,    22,
+       1,     0,     4,    21,     6,     7,     9,    10,    11,    19,
+      18,    14,    21,    17,     2,     0,    22,    13,    16
+};
+
+/* YYDEFGOTO[NTERM-NUM].  */
+static const yytype_int8 yydefgoto[] =
+{
+      -1,     7,     8,     9,    10,    11,    12,    13,    14,    15,
+      24
+};
+
+/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
+   STATE-NUM.  */
+#define YYPACT_NINF -12
+static const yytype_int8 yypact[] =
+{
+       7,   -10,   -12,   -12,    -9,    -6,     2,     1,   -12,    10,
+      -2,    -2,   -12,    -2,    -2,    -2,    16,    14,    11,     6,
+     -12,     7,   -12,   -12,   -12,   -12,   -12,   -12,   -12,   -12,
+     -12,     8,    18,   -12,   -12,    17,    -2,   -12,   -12
+};
+
+/* YYPGOTO[NTERM-NUM].  */
+static const yytype_int8 yypgoto[] =
+{
+     -12,   -12,     3,   -12,   -12,   -12,   -12,   -12,   -12,   -12,
+     -11
+};
+
+/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
+   positive, shift that token.  If negative, reduce the rule which
+   number is the opposite.  If zero, do what YYDEFACT says.
+   If YYTABLE_NINF, syntax error.  */
+#define YYTABLE_NINF -1
+static const yytype_uint8 yytable[] =
+{
+      25,    20,    26,    27,    28,    19,    16,    17,    33,    18,
+       1,     2,     3,     4,    23,    21,     5,    22,     6,    29,
+      30,    31,    32,    35,    34,    38,    36,    37
+};
+
+static const yytype_uint8 yycheck[] =
+{
+      11,     0,    13,    14,    15,     3,    16,    16,    19,    15,
+       3,     4,     5,     6,    16,    14,     9,     7,    11,     3,
+       6,    10,    16,    15,    21,    36,     8,    10
+};
+
+/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
+   symbol of state STATE-NUM.  */
+static const yytype_uint8 yystos[] =
+{
+       0,     3,     4,     5,     6,     9,    11,    18,    19,    20,
+      21,    22,    23,    24,    25,    26,    16,    16,    15,     3,
+       0,    14,     7,    16,    27,    27,    27,    27,    27,     3,
+       6,    10,    16,    27,    19,    15,     8,    10,    27
+};
+
+#define yyerrok		(yyerrstatus = 0)
+#define yyclearin	(yychar = YYEMPTY)
+#define YYEMPTY		(-2)
+#define YYEOF		0
+
+#define YYACCEPT	goto yyacceptlab
+#define YYABORT		goto yyabortlab
+#define YYERROR		goto yyerrorlab
+
+
+/* Like YYERROR except do call yyerror.  This remains here temporarily
+   to ease the transition to the new meaning of YYERROR, for GCC.
+   Once GCC version 2 has supplanted version 1, this can go.  However,
+   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
+   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
+   discussed.  */
+
+#define YYFAIL		goto yyerrlab
+#if defined YYFAIL
+  /* This is here to suppress warnings from the GCC cpp's
+     -Wunused-macros.  Normally we don't worry about that warning, but
+     some users do, and we want to make it easy for users to remove
+     YYFAIL uses, which will produce warnings from Bison 2.5.  */
+#endif
+
+#define YYRECOVERING()  (!!yyerrstatus)
+
+#define YYBACKUP(Token, Value)					\
+do								\
+  if (yychar == YYEMPTY && yylen == 1)				\
+    {								\
+      yychar = (Token);						\
+      yylval = (Value);						\
+      yytoken = YYTRANSLATE (yychar);				\
+      YYPOPSTACK (1);						\
+      goto yybackup;						\
+    }								\
+  else								\
+    {								\
+      yyerror (list, idx, YY_("syntax error: cannot back up")); \
+      YYERROR;							\
+    }								\
+while (YYID (0))
+
+
+#define YYTERROR	1
+#define YYERRCODE	256
+
+
+/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
+   If N is 0, then set CURRENT to the empty location which ends
+   the previous symbol: RHS[0] (always defined).  */
+
+#define YYRHSLOC(Rhs, K) ((Rhs)[K])
+#ifndef YYLLOC_DEFAULT
+# define YYLLOC_DEFAULT(Current, Rhs, N)				\
+    do									\
+      if (YYID (N))                                                    \
+	{								\
+	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
+	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
+	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
+	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
+	}								\
+      else								\
+	{								\
+	  (Current).first_line   = (Current).last_line   =		\
+	    YYRHSLOC (Rhs, 0).last_line;				\
+	  (Current).first_column = (Current).last_column =		\
+	    YYRHSLOC (Rhs, 0).last_column;				\
+	}								\
+    while (YYID (0))
+#endif
+
+
+/* YY_LOCATION_PRINT -- Print the location on the stream.
+   This macro was not mandated originally: define only if we know
+   we won't break user code: when these are the locations we know.  */
+
+#ifndef YY_LOCATION_PRINT
+# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
+#  define YY_LOCATION_PRINT(File, Loc)			\
+     fprintf (File, "%d.%d-%d.%d",			\
+	      (Loc).first_line, (Loc).first_column,	\
+	      (Loc).last_line,  (Loc).last_column)
+# else
+#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
+# endif
+#endif
+
+
+/* YYLEX -- calling `yylex' with the right arguments.  */
+
+#ifdef YYLEX_PARAM
+# define YYLEX yylex (YYLEX_PARAM)
+#else
+# define YYLEX yylex ()
+#endif
+
+/* Enable debugging if requested.  */
+#if YYDEBUG
+
+# ifndef YYFPRINTF
+#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
+#  define YYFPRINTF fprintf
+# endif
+
+# define YYDPRINTF(Args)			\
+do {						\
+  if (yydebug)					\
+    YYFPRINTF Args;				\
+} while (YYID (0))
+
+# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
+do {									  \
+  if (yydebug)								  \
+    {									  \
+      YYFPRINTF (stderr, "%s ", Title);					  \
+      yy_symbol_print (stderr,						  \
+		  Type, Value, list, idx); \
+      YYFPRINTF (stderr, "\n");						  \
+    }									  \
+} while (YYID (0))
+
+
+/*--------------------------------.
+| Print this symbol on YYOUTPUT.  |
+`--------------------------------*/
+
+/*ARGSUSED*/
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct list_head *list, int *idx)
+#else
+static void
+yy_symbol_value_print (yyoutput, yytype, yyvaluep, list, idx)
+    FILE *yyoutput;
+    int yytype;
+    YYSTYPE const * const yyvaluep;
+    struct list_head *list;
+    int *idx;
+#endif
+{
+  if (!yyvaluep)
+    return;
+  YYUSE (list);
+  YYUSE (idx);
+# ifdef YYPRINT
+  if (yytype < YYNTOKENS)
+    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
+# else
+  YYUSE (yyoutput);
+# endif
+  switch (yytype)
+    {
+      default:
+	break;
+    }
+}
+
+
+/*--------------------------------.
+| Print this symbol on YYOUTPUT.  |
+`--------------------------------*/
+
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct list_head *list, int *idx)
+#else
+static void
+yy_symbol_print (yyoutput, yytype, yyvaluep, list, idx)
+    FILE *yyoutput;
+    int yytype;
+    YYSTYPE const * const yyvaluep;
+    struct list_head *list;
+    int *idx;
+#endif
+{
+  if (yytype < YYNTOKENS)
+    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
+  else
+    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);
+
+  yy_symbol_value_print (yyoutput, yytype, yyvaluep, list, idx);
+  YYFPRINTF (yyoutput, ")");
+}
+
+/*------------------------------------------------------------------.
+| yy_stack_print -- Print the state stack from its BOTTOM up to its |
+| TOP (included).                                                   |
+`------------------------------------------------------------------*/
+
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
+#else
+static void
+yy_stack_print (yybottom, yytop)
+    yytype_int16 *yybottom;
+    yytype_int16 *yytop;
+#endif
+{
+  YYFPRINTF (stderr, "Stack now");
+  for (; yybottom <= yytop; yybottom++)
+    {
+      int yybot = *yybottom;
+      YYFPRINTF (stderr, " %d", yybot);
+    }
+  YYFPRINTF (stderr, "\n");
+}
+
+# define YY_STACK_PRINT(Bottom, Top)				\
+do {								\
+  if (yydebug)							\
+    yy_stack_print ((Bottom), (Top));				\
+} while (YYID (0))
+
+
+/*------------------------------------------------.
+| Report that the YYRULE is going to be reduced.  |
+`------------------------------------------------*/
+
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yy_reduce_print (YYSTYPE *yyvsp, int yyrule, struct list_head *list, int *idx)
+#else
+static void
+yy_reduce_print (yyvsp, yyrule, list, idx)
+    YYSTYPE *yyvsp;
+    int yyrule;
+    struct list_head *list;
+    int *idx;
+#endif
+{
+  int yynrhs = yyr2[yyrule];
+  int yyi;
+  unsigned long int yylno = yyrline[yyrule];
+  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
+	     yyrule - 1, yylno);
+  /* The symbols being reduced.  */
+  for (yyi = 0; yyi < yynrhs; yyi++)
+    {
+      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
+      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
+		       &(yyvsp[(yyi + 1) - (yynrhs)])
+		       		       , list, idx);
+      YYFPRINTF (stderr, "\n");
+    }
+}
+
+# define YY_REDUCE_PRINT(Rule)		\
+do {					\
+  if (yydebug)				\
+    yy_reduce_print (yyvsp, Rule, list, idx); \
+} while (YYID (0))
+
+/* Nonzero means print parse trace.  It is left uninitialized so that
+   multiple parsers can coexist.  */
+int yydebug;
+#else /* !YYDEBUG */
+# define YYDPRINTF(Args)
+# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
+# define YY_STACK_PRINT(Bottom, Top)
+# define YY_REDUCE_PRINT(Rule)
+#endif /* !YYDEBUG */
+
+
+/* YYINITDEPTH -- initial size of the parser's stacks.  */
+#ifndef	YYINITDEPTH
+# define YYINITDEPTH 200
+#endif
+
+/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
+   if the built-in stack extension method is used).
+
+   Do not make this value too large; the results are undefined if
+   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
+   evaluated with infinite-precision integer arithmetic.  */
+
+#ifndef YYMAXDEPTH
+# define YYMAXDEPTH 10000
+#endif
+
+
+
+#if YYERROR_VERBOSE
+
+# ifndef yystrlen
+#  if defined __GLIBC__ && defined _STRING_H
+#   define yystrlen strlen
+#  else
+/* Return the length of YYSTR.  */
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static YYSIZE_T
+yystrlen (const char *yystr)
+#else
+static YYSIZE_T
+yystrlen (yystr)
+    const char *yystr;
+#endif
+{
+  YYSIZE_T yylen;
+  for (yylen = 0; yystr[yylen]; yylen++)
+    continue;
+  return yylen;
+}
+#  endif
+# endif
+
+# ifndef yystpcpy
+#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
+#   define yystpcpy stpcpy
+#  else
+/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
+   YYDEST.  */
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static char *
+yystpcpy (char *yydest, const char *yysrc)
+#else
+static char *
+yystpcpy (yydest, yysrc)
+    char *yydest;
+    const char *yysrc;
+#endif
+{
+  char *yyd = yydest;
+  const char *yys = yysrc;
+
+  while ((*yyd++ = *yys++) != '\0')
+    continue;
+
+  return yyd - 1;
+}
+#  endif
+# endif
+
+# ifndef yytnamerr
+/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
+   quotes and backslashes, so that it's suitable for yyerror.  The
+   heuristic is that double-quoting is unnecessary unless the string
+   contains an apostrophe, a comma, or backslash (other than
+   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
+   null, do not copy; instead, return the length of what the result
+   would have been.  */
+static YYSIZE_T
+yytnamerr (char *yyres, const char *yystr)
+{
+  if (*yystr == '"')
+    {
+      YYSIZE_T yyn = 0;
+      char const *yyp = yystr;
+
+      for (;;)
+	switch (*++yyp)
+	  {
+	  case '\'':
+	  case ',':
+	    goto do_not_strip_quotes;
+
+	  case '\\':
+	    if (*++yyp != '\\')
+	      goto do_not_strip_quotes;
+	    /* Fall through.  */
+	  default:
+	    if (yyres)
+	      yyres[yyn] = *yyp;
+	    yyn++;
+	    break;
+
+	  case '"':
+	    if (yyres)
+	      yyres[yyn] = '\0';
+	    return yyn;
+	  }
+    do_not_strip_quotes: ;
+    }
+
+  if (! yyres)
+    return yystrlen (yystr);
+
+  return yystpcpy (yyres, yystr) - yyres;
+}
+# endif
+
+/* Copy into YYRESULT an error message about the unexpected token
+   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
+   including the terminating null byte.  If YYRESULT is null, do not
+   copy anything; just return the number of bytes that would be
+   copied.  As a special case, return 0 if an ordinary "syntax error"
+   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
+   size calculation.  */
+static YYSIZE_T
+yysyntax_error (char *yyresult, int yystate, int yychar)
+{
+  int yyn = yypact[yystate];
+
+  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
+    return 0;
+  else
+    {
+      int yytype = YYTRANSLATE (yychar);
+      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
+      YYSIZE_T yysize = yysize0;
+      YYSIZE_T yysize1;
+      int yysize_overflow = 0;
+      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
+      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
+      int yyx;
+
+# if 0
+      /* This is so xgettext sees the translatable formats that are
+	 constructed on the fly.  */
+      YY_("syntax error, unexpected %s");
+      YY_("syntax error, unexpected %s, expecting %s");
+      YY_("syntax error, unexpected %s, expecting %s or %s");
+      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
+      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
+# endif
+      char *yyfmt;
+      char const *yyf;
+      static char const yyunexpected[] = "syntax error, unexpected %s";
+      static char const yyexpecting[] = ", expecting %s";
+      static char const yyor[] = " or %s";
+      char yyformat[sizeof yyunexpected
+		    + sizeof yyexpecting - 1
+		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
+		       * (sizeof yyor - 1))];
+      char const *yyprefix = yyexpecting;
+
+      /* Start YYX at -YYN if negative to avoid negative indexes in
+	 YYCHECK.  */
+      int yyxbegin = yyn < 0 ? -yyn : 0;
+
+      /* Stay within bounds of both yycheck and yytname.  */
+      int yychecklim = YYLAST - yyn + 1;
+      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
+      int yycount = 1;
+
+      yyarg[0] = yytname[yytype];
+      yyfmt = yystpcpy (yyformat, yyunexpected);
+
+      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
+	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
+	  {
+	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
+	      {
+		yycount = 1;
+		yysize = yysize0;
+		yyformat[sizeof yyunexpected - 1] = '\0';
+		break;
+	      }
+	    yyarg[yycount++] = yytname[yyx];
+	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
+	    yysize_overflow |= (yysize1 < yysize);
+	    yysize = yysize1;
+	    yyfmt = yystpcpy (yyfmt, yyprefix);
+	    yyprefix = yyor;
+	  }
+
+      yyf = YY_(yyformat);
+      yysize1 = yysize + yystrlen (yyf);
+      yysize_overflow |= (yysize1 < yysize);
+      yysize = yysize1;
+
+      if (yysize_overflow)
+	return YYSIZE_MAXIMUM;
+
+      if (yyresult)
+	{
+	  /* Avoid sprintf, as that infringes on the user's name space.
+	     Don't have undefined behavior even if the translation
+	     produced a string with the wrong number of "%s"s.  */
+	  char *yyp = yyresult;
+	  int yyi = 0;
+	  while ((*yyp = *yyf) != '\0')
+	    {
+	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
+		{
+		  yyp += yytnamerr (yyp, yyarg[yyi++]);
+		  yyf += 2;
+		}
+	      else
+		{
+		  yyp++;
+		  yyf++;
+		}
+	    }
+	}
+      return yysize;
+    }
+}
+#endif /* YYERROR_VERBOSE */
+
+
+/*-----------------------------------------------.
+| Release the memory associated to this symbol.  |
+`-----------------------------------------------*/
+
+/*ARGSUSED*/
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, struct list_head *list, int *idx)
+#else
+static void
+yydestruct (yymsg, yytype, yyvaluep, list, idx)
+    const char *yymsg;
+    int yytype;
+    YYSTYPE *yyvaluep;
+    struct list_head *list;
+    int *idx;
+#endif
+{
+  YYUSE (yyvaluep);
+  YYUSE (list);
+  YYUSE (idx);
+
+  if (!yymsg)
+    yymsg = "Deleting";
+  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);
+
+  switch (yytype)
+    {
+
+      default:
+	break;
+    }
+}
+
+/* Prevent warnings from -Wmissing-prototypes.  */
+#ifdef YYPARSE_PARAM
+#if defined __STDC__ || defined __cplusplus
+int yyparse (void *YYPARSE_PARAM);
+#else
+int yyparse ();
+#endif
+#else /* ! YYPARSE_PARAM */
+#if defined __STDC__ || defined __cplusplus
+int yyparse (struct list_head *list, int *idx);
+#else
+int yyparse ();
+#endif
+#endif /* ! YYPARSE_PARAM */
+
+
+/* The lookahead symbol.  */
+int yychar;
+
+/* The semantic value of the lookahead symbol.  */
+YYSTYPE yylval;
+
+/* Number of syntax errors so far.  */
+int yynerrs;
+
+
+
+/*-------------------------.
+| yyparse or yypush_parse.  |
+`-------------------------*/
+
+#ifdef YYPARSE_PARAM
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+int
+yyparse (void *YYPARSE_PARAM)
+#else
+int
+yyparse (YYPARSE_PARAM)
+    void *YYPARSE_PARAM;
+#endif
+#else /* ! YYPARSE_PARAM */
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+int
+yyparse (struct list_head *list, int *idx)
+#else
+int
+yyparse (list, idx)
+    struct list_head *list;
+    int *idx;
+#endif
+#endif
+{
+
+
+    int yystate;
+    /* Number of tokens to shift before error messages enabled.  */
+    int yyerrstatus;
+
+    /* The stacks and their tools:
+       `yyss': related to states.
+       `yyvs': related to semantic values.
+
+       Refer to the stacks thru separate pointers, to allow yyoverflow
+       to reallocate them elsewhere.  */
+
+    /* The state stack.  */
+    yytype_int16 yyssa[YYINITDEPTH];
+    yytype_int16 *yyss;
+    yytype_int16 *yyssp;
+
+    /* The semantic value stack.  */
+    YYSTYPE yyvsa[YYINITDEPTH];
+    YYSTYPE *yyvs;
+    YYSTYPE *yyvsp;
+
+    YYSIZE_T yystacksize;
+
+  int yyn;
+  int yyresult;
+  /* Lookahead token as an internal (translated) token number.  */
+  int yytoken;
+  /* The variables used to return semantic value and location from the
+     action routines.  */
+  YYSTYPE yyval;
+
+#if YYERROR_VERBOSE
+  /* Buffer for error messages, and its allocated size.  */
+  char yymsgbuf[128];
+  char *yymsg = yymsgbuf;
+  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
+#endif
+
+#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))
+
+  /* The number of symbols on the RHS of the reduced rule.
+     Keep to zero when no symbol should be popped.  */
+  int yylen = 0;
+
+  yytoken = 0;
+  yyss = yyssa;
+  yyvs = yyvsa;
+  yystacksize = YYINITDEPTH;
+
+  YYDPRINTF ((stderr, "Starting parse\n"));
+
+  yystate = 0;
+  yyerrstatus = 0;
+  yynerrs = 0;
+  yychar = YYEMPTY; /* Cause a token to be read.  */
+
+  /* Initialize stack pointers.
+     Waste one element of value and location stack
+     so that they stay on the same level as the state stack.
+     The wasted elements are never initialized.  */
+  yyssp = yyss;
+  yyvsp = yyvs;
+
+  goto yysetstate;
+
+/*------------------------------------------------------------.
+| yynewstate -- Push a new state, which is found in yystate.  |
+`------------------------------------------------------------*/
+ yynewstate:
+  /* In all cases, when you get here, the value and location stacks
+     have just been pushed.  So pushing a state here evens the stacks.  */
+  yyssp++;
+
+ yysetstate:
+  *yyssp = yystate;
+
+  if (yyss + yystacksize - 1 <= yyssp)
+    {
+      /* Get the current used size of the three stacks, in elements.  */
+      YYSIZE_T yysize = yyssp - yyss + 1;
+
+#ifdef yyoverflow
+      {
+	/* Give user a chance to reallocate the stack.  Use copies of
+	   these so that the &'s don't force the real ones into
+	   memory.  */
+	YYSTYPE *yyvs1 = yyvs;
+	yytype_int16 *yyss1 = yyss;
+
+	/* Each stack pointer address is followed by the size of the
+	   data in use in that stack, in bytes.  This used to be a
+	   conditional around just the two extra args, but that might
+	   be undefined if yyoverflow is a macro.  */
+	yyoverflow (YY_("memory exhausted"),
+		    &yyss1, yysize * sizeof (*yyssp),
+		    &yyvs1, yysize * sizeof (*yyvsp),
+		    &yystacksize);
+
+	yyss = yyss1;
+	yyvs = yyvs1;
+      }
+#else /* no yyoverflow */
+# ifndef YYSTACK_RELOCATE
+      goto yyexhaustedlab;
+# else
+      /* Extend the stack our own way.  */
+      if (YYMAXDEPTH <= yystacksize)
+	goto yyexhaustedlab;
+      yystacksize *= 2;
+      if (YYMAXDEPTH < yystacksize)
+	yystacksize = YYMAXDEPTH;
+
+      {
+	yytype_int16 *yyss1 = yyss;
+	union yyalloc *yyptr =
+	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
+	if (! yyptr)
+	  goto yyexhaustedlab;
+	YYSTACK_RELOCATE (yyss_alloc, yyss);
+	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
+#  undef YYSTACK_RELOCATE
+	if (yyss1 != yyssa)
+	  YYSTACK_FREE (yyss1);
+      }
+# endif
+#endif /* no yyoverflow */
+
+      yyssp = yyss + yysize - 1;
+      yyvsp = yyvs + yysize - 1;
+
+      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
+		  (unsigned long int) yystacksize));
+
+      if (yyss + yystacksize - 1 <= yyssp)
+	YYABORT;
+    }
+
+  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
+
+  if (yystate == YYFINAL)
+    YYACCEPT;
+
+  goto yybackup;
+
+/*-----------.
+| yybackup.  |
+`-----------*/
+yybackup:
+
+  /* Do appropriate processing given the current state.  Read a
+     lookahead token if we need one and don't already have one.  */
+
+  /* First try to decide what to do without reference to lookahead token.  */
+  yyn = yypact[yystate];
+  if (yyn == YYPACT_NINF)
+    goto yydefault;
+
+  /* Not known => get a lookahead token if don't already have one.  */
+
+  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
+  if (yychar == YYEMPTY)
+    {
+      YYDPRINTF ((stderr, "Reading a token: "));
+      yychar = YYLEX;
+    }
+
+  if (yychar <= YYEOF)
+    {
+      yychar = yytoken = YYEOF;
+      YYDPRINTF ((stderr, "Now at end of input.\n"));
+    }
+  else
+    {
+      yytoken = YYTRANSLATE (yychar);
+      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
+    }
+
+  /* If the proper action on seeing token YYTOKEN is to reduce or to
+     detect an error, take that action.  */
+  yyn += yytoken;
+  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
+    goto yydefault;
+  yyn = yytable[yyn];
+  if (yyn <= 0)
+    {
+      if (yyn == 0 || yyn == YYTABLE_NINF)
+	goto yyerrlab;
+      yyn = -yyn;
+      goto yyreduce;
+    }
+
+  /* Count tokens shifted since error; after three, turn off error
+     status.  */
+  if (yyerrstatus)
+    yyerrstatus--;
+
+  /* Shift the lookahead token.  */
+  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
+
+  /* Discard the shifted token.  */
+  yychar = YYEMPTY;
+
+  yystate = yyn;
+  *++yyvsp = yylval;
+
+  goto yynewstate;
+
+
+/*-----------------------------------------------------------.
+| yydefault -- do the default action for the current state.  |
+`-----------------------------------------------------------*/
+yydefault:
+  yyn = yydefact[yystate];
+  if (yyn == 0)
+    goto yyerrlab;
+  goto yyreduce;
+
+
+/*-----------------------------.
+| yyreduce -- Do a reduction.  |
+`-----------------------------*/
+yyreduce:
+  /* yyn is the number of a rule to reduce with.  */
+  yylen = yyr2[yyn];
+
+  /* If YYLEN is nonzero, implement the default value of the action:
+     `$$ = $1'.
+
+     Otherwise, the following line sets YYVAL to garbage.
+     This behavior is undocumented and Bison
+     users should not rely upon it.  Assigning to YYVAL
+     unconditionally makes the parser a bit smaller, and it avoids a
+     GCC warning that YYVAL may be used uninitialized.  */
+  yyval = yyvsp[1-yylen];
+
+
+  YY_REDUCE_PRINT (yyn);
+  switch (yyn)
+    {
+        case 4:
+
+/* Line 1464 of yacc.c  */
+#line 53 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_modifier(list, (yyvsp[(2) - (2)].str)));
+;}
+    break;
+
+  case 12:
+
+/* Line 1464 of yacc.c  */
+#line 68 "util/parse-events.y"
+    {
+	int type = (yyvsp[(1) - (1)].num) >> 16;
+	int config = (yyvsp[(1) - (1)].num) & 255;
+
+	ABORT_ON(parse_events_add_numeric(list, idx, type, config));
+;}
+    break;
+
+  case 13:
+
+/* Line 1464 of yacc.c  */
+#line 77 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (5)].str), (yyvsp[(3) - (5)].str), (yyvsp[(5) - (5)].str)));
+;}
+    break;
+
+  case 14:
+
+/* Line 1464 of yacc.c  */
+#line 82 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
+;}
+    break;
+
+  case 15:
+
+/* Line 1464 of yacc.c  */
+#line 87 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
+;}
+    break;
+
+  case 16:
+
+/* Line 1464 of yacc.c  */
+#line 93 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
+;}
+    break;
+
+  case 17:
+
+/* Line 1464 of yacc.c  */
+#line 98 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
+;}
+    break;
+
+  case 18:
+
+/* Line 1464 of yacc.c  */
+#line 104 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_tracepoint(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
+;}
+    break;
+
+  case 19:
+
+/* Line 1464 of yacc.c  */
+#line 110 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_numeric(list, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num)));
+;}
+    break;
+
+  case 20:
+
+/* Line 1464 of yacc.c  */
+#line 116 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num)));
+;}
+    break;
+
+
+
+/* Line 1464 of yacc.c  */
+#line 1497 "util/parse-events-bison.c"
+      default: break;
+    }
+  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
+
+  YYPOPSTACK (yylen);
+  yylen = 0;
+  YY_STACK_PRINT (yyss, yyssp);
+
+  *++yyvsp = yyval;
+
+  /* Now `shift' the result of the reduction.  Determine what state
+     that goes to, based on the state we popped back to and the rule
+     number reduced by.  */
+
+  yyn = yyr1[yyn];
+
+  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
+  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
+    yystate = yytable[yystate];
+  else
+    yystate = yydefgoto[yyn - YYNTOKENS];
+
+  goto yynewstate;
+
+
+/*------------------------------------.
+| yyerrlab -- here on detecting error |
+`------------------------------------*/
+yyerrlab:
+  /* If not already recovering from an error, report this error.  */
+  if (!yyerrstatus)
+    {
+      ++yynerrs;
+#if ! YYERROR_VERBOSE
+      yyerror (list, idx, YY_("syntax error"));
+#else
+      {
+	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
+	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
+	  {
+	    YYSIZE_T yyalloc = 2 * yysize;
+	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
+	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
+	    if (yymsg != yymsgbuf)
+	      YYSTACK_FREE (yymsg);
+	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
+	    if (yymsg)
+	      yymsg_alloc = yyalloc;
+	    else
+	      {
+		yymsg = yymsgbuf;
+		yymsg_alloc = sizeof yymsgbuf;
+	      }
+	  }
+
+	if (0 < yysize && yysize <= yymsg_alloc)
+	  {
+	    (void) yysyntax_error (yymsg, yystate, yychar);
+	    yyerror (list, idx, yymsg);
+	  }
+	else
+	  {
+	    yyerror (list, idx, YY_("syntax error"));
+	    if (yysize != 0)
+	      goto yyexhaustedlab;
+	  }
+      }
+#endif
+    }
+
+
+
+  if (yyerrstatus == 3)
+    {
+      /* If just tried and failed to reuse lookahead token after an
+	 error, discard it.  */
+
+      if (yychar <= YYEOF)
+	{
+	  /* Return failure if at end of input.  */
+	  if (yychar == YYEOF)
+	    YYABORT;
+	}
+      else
+	{
+	  yydestruct ("Error: discarding",
+		      yytoken, &yylval, list, idx);
+	  yychar = YYEMPTY;
+	}
+    }
+
+  /* Else will try to reuse lookahead token after shifting the error
+     token.  */
+  goto yyerrlab1;
+
+
+/*---------------------------------------------------.
+| yyerrorlab -- error raised explicitly by YYERROR.  |
+`---------------------------------------------------*/
+yyerrorlab:
+
+  /* Pacify compilers like GCC when the user code never invokes
+     YYERROR and the label yyerrorlab therefore never appears in user
+     code.  */
+  if (/*CONSTCOND*/ 0)
+     goto yyerrorlab;
+
+  /* Do not reclaim the symbols of the rule which action triggered
+     this YYERROR.  */
+  YYPOPSTACK (yylen);
+  yylen = 0;
+  YY_STACK_PRINT (yyss, yyssp);
+  yystate = *yyssp;
+  goto yyerrlab1;
+
+
+/*-------------------------------------------------------------.
+| yyerrlab1 -- common code for both syntax error and YYERROR.  |
+`-------------------------------------------------------------*/
+yyerrlab1:
+  yyerrstatus = 3;	/* Each real token shifted decrements this.  */
+
+  for (;;)
+    {
+      yyn = yypact[yystate];
+      if (yyn != YYPACT_NINF)
+	{
+	  yyn += YYTERROR;
+	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
+	    {
+	      yyn = yytable[yyn];
+	      if (0 < yyn)
+		break;
+	    }
+	}
+
+      /* Pop the current state because it cannot handle the error token.  */
+      if (yyssp == yyss)
+	YYABORT;
+
+
+      yydestruct ("Error: popping",
+		  yystos[yystate], yyvsp, list, idx);
+      YYPOPSTACK (1);
+      yystate = *yyssp;
+      YY_STACK_PRINT (yyss, yyssp);
+    }
+
+  *++yyvsp = yylval;
+
+
+  /* Shift the error token.  */
+  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);
+
+  yystate = yyn;
+  goto yynewstate;
+
+
+/*-------------------------------------.
+| yyacceptlab -- YYACCEPT comes here.  |
+`-------------------------------------*/
+yyacceptlab:
+  yyresult = 0;
+  goto yyreturn;
+
+/*-----------------------------------.
+| yyabortlab -- YYABORT comes here.  |
+`-----------------------------------*/
+yyabortlab:
+  yyresult = 1;
+  goto yyreturn;
+
+#if !defined(yyoverflow) || YYERROR_VERBOSE
+/*-------------------------------------------------.
+| yyexhaustedlab -- memory exhaustion comes here.  |
+`-------------------------------------------------*/
+yyexhaustedlab:
+  yyerror (list, idx, YY_("memory exhausted"));
+  yyresult = 2;
+  /* Fall through.  */
+#endif
+
+yyreturn:
+  if (yychar != YYEMPTY)
+     yydestruct ("Cleanup: discarding lookahead",
+		 yytoken, &yylval, list, idx);
+  /* Do not reclaim the symbols of the rule which action triggered
+     this YYABORT or YYACCEPT.  */
+  YYPOPSTACK (yylen);
+  YY_STACK_PRINT (yyss, yyssp);
+  while (yyssp != yyss)
+    {
+      yydestruct ("Cleanup: popping",
+		  yystos[*yyssp], yyvsp, list, idx);
+      YYPOPSTACK (1);
+    }
+#ifndef yyoverflow
+  if (yyss != yyssa)
+    YYSTACK_FREE (yyss);
+#endif
+#if YYERROR_VERBOSE
+  if (yymsg != yymsgbuf)
+    YYSTACK_FREE (yymsg);
+#endif
+  /* Make sure YYID is used.  */
+  return YYID (yyresult);
+}
+
+
+
+/* Line 1684 of yacc.c  */
+#line 122 "util/parse-events.y"
+
+
+void parse_events_error(struct list_head *list __used, int *idx __used,
+			char const *msg __used)
+{
+}
+
diff --git a/tools/perf/util/parse-events-bison.h b/tools/perf/util/parse-events-bison.h
new file mode 100644
index 0000000..097a632
--- /dev/null
+++ b/tools/perf/util/parse-events-bison.h
@@ -0,0 +1,79 @@
+/* A Bison parser, made by GNU Bison 2.4.3.  */
+
+/* Skeleton interface for Bison's Yacc-like parsers in C
+   
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
+   2009, 2010 Free Software Foundation, Inc.
+   
+   This program is free software: you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation, either version 3 of the License, or
+   (at your option) any later version.
+   
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+   
+   You should have received a copy of the GNU General Public License
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+
+/* As a special exception, you may create a larger work that contains
+   part or all of the Bison parser skeleton and distribute that work
+   under terms of your choice, so long as that work isn't itself a
+   parser generator using the skeleton or a modified version thereof
+   as a parser skeleton.  Alternatively, if you modify or redistribute
+   the parser skeleton itself, you may (at your option) remove this
+   special exception, which will cause the skeleton and the resulting
+   Bison output files to be licensed under the GNU General Public
+   License without this special exception.
+   
+   This special exception was added by the Free Software Foundation in
+   version 2.2 of Bison.  */
+
+
+/* Tokens.  */
+#ifndef YYTOKENTYPE
+# define YYTOKENTYPE
+   /* Put the tokens into the symbol table, so that GDB and other debuggers
+      know about them.  */
+   enum yytokentype {
+     PE_VALUE = 258,
+     PE_VALUE_SYM = 259,
+     PE_RAW = 260,
+     PE_NAME = 261,
+     PE_MODIFIER_EVENT = 262,
+     PE_MODIFIER_BP = 263,
+     PE_NAME_CACHE_TYPE = 264,
+     PE_NAME_CACHE_OP_RESULT = 265,
+     PE_PREFIX_MEM = 266,
+     PE_PREFIX_RAW = 267,
+     PE_ERROR = 268
+   };
+#endif
+
+
+
+#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
+typedef union YYSTYPE
+{
+
+/* Line 1685 of yacc.c  */
+#line 42 "util/parse-events.y"
+
+	char *str;
+	unsigned long num;
+
+
+
+/* Line 1685 of yacc.c  */
+#line 71 "util/parse-events-bison.h"
+} YYSTYPE;
+# define YYSTYPE_IS_TRIVIAL 1
+# define yystype YYSTYPE /* obsolescent; will be withdrawn */
+# define YYSTYPE_IS_DECLARED 1
+#endif
+
+extern YYSTYPE parse_events_lval;
+
+
diff --git a/tools/perf/util/parse-events-flex.c b/tools/perf/util/parse-events-flex.c
new file mode 100644
index 0000000..9e77ed6
--- /dev/null
+++ b/tools/perf/util/parse-events-flex.c
@@ -0,0 +1,2225 @@
+
+#line 3 "<stdout>"
+
+#define  YY_INT_ALIGNED short int
+
+/* A lexical scanner generated by flex */
+
+#define yy_create_buffer parse_events__create_buffer
+#define yy_delete_buffer parse_events__delete_buffer
+#define yy_flex_debug parse_events__flex_debug
+#define yy_init_buffer parse_events__init_buffer
+#define yy_flush_buffer parse_events__flush_buffer
+#define yy_load_buffer_state parse_events__load_buffer_state
+#define yy_switch_to_buffer parse_events__switch_to_buffer
+#define yyin parse_events_in
+#define yyleng parse_events_leng
+#define yylex parse_events_lex
+#define yylineno parse_events_lineno
+#define yyout parse_events_out
+#define yyrestart parse_events_restart
+#define yytext parse_events_text
+#define yywrap parse_events_wrap
+#define yyalloc parse_events_alloc
+#define yyrealloc parse_events_realloc
+#define yyfree parse_events_free
+
+#define FLEX_SCANNER
+#define YY_FLEX_MAJOR_VERSION 2
+#define YY_FLEX_MINOR_VERSION 5
+#define YY_FLEX_SUBMINOR_VERSION 35
+#if YY_FLEX_SUBMINOR_VERSION > 0
+#define FLEX_BETA
+#endif
+
+/* First, we deal with  platform-specific or compiler-specific issues. */
+
+/* begin standard C headers. */
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <stdlib.h>
+
+/* end standard C headers. */
+
+/* flex integer type definitions */
+
+#ifndef FLEXINT_H
+#define FLEXINT_H
+
+/* C99 systems have <inttypes.h>. Non-C99 systems may or may not. */
+
+#if defined (__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
+
+/* C99 says to define __STDC_LIMIT_MACROS before including stdint.h,
+ * if you want the limit (max/min) macros for int types. 
+ */
+#ifndef __STDC_LIMIT_MACROS
+#define __STDC_LIMIT_MACROS 1
+#endif
+
+#include <inttypes.h>
+typedef int8_t flex_int8_t;
+typedef uint8_t flex_uint8_t;
+typedef int16_t flex_int16_t;
+typedef uint16_t flex_uint16_t;
+typedef int32_t flex_int32_t;
+typedef uint32_t flex_uint32_t;
+#else
+typedef signed char flex_int8_t;
+typedef short int flex_int16_t;
+typedef int flex_int32_t;
+typedef unsigned char flex_uint8_t; 
+typedef unsigned short int flex_uint16_t;
+typedef unsigned int flex_uint32_t;
+#endif /* ! C99 */
+
+/* Limits of integral types. */
+#ifndef INT8_MIN
+#define INT8_MIN               (-128)
+#endif
+#ifndef INT16_MIN
+#define INT16_MIN              (-32767-1)
+#endif
+#ifndef INT32_MIN
+#define INT32_MIN              (-2147483647-1)
+#endif
+#ifndef INT8_MAX
+#define INT8_MAX               (127)
+#endif
+#ifndef INT16_MAX
+#define INT16_MAX              (32767)
+#endif
+#ifndef INT32_MAX
+#define INT32_MAX              (2147483647)
+#endif
+#ifndef UINT8_MAX
+#define UINT8_MAX              (255U)
+#endif
+#ifndef UINT16_MAX
+#define UINT16_MAX             (65535U)
+#endif
+#ifndef UINT32_MAX
+#define UINT32_MAX             (4294967295U)
+#endif
+
+#endif /* ! FLEXINT_H */
+
+#ifdef __cplusplus
+
+/* The "const" storage-class-modifier is valid. */
+#define YY_USE_CONST
+
+#else	/* ! __cplusplus */
+
+/* C99 requires __STDC__ to be defined as 1. */
+#if defined (__STDC__)
+
+#define YY_USE_CONST
+
+#endif	/* defined (__STDC__) */
+#endif	/* ! __cplusplus */
+
+#ifdef YY_USE_CONST
+#define yyconst const
+#else
+#define yyconst
+#endif
+
+/* Returned upon end-of-file. */
+#define YY_NULL 0
+
+/* Promotes a possibly negative, possibly signed char to an unsigned
+ * integer for use as an array index.  If the signed char is negative,
+ * we want to instead treat it as an 8-bit unsigned char, hence the
+ * double cast.
+ */
+#define YY_SC_TO_UI(c) ((unsigned int) (unsigned char) c)
+
+/* Enter a start condition.  This macro really ought to take a parameter,
+ * but we do it the disgusting crufty way forced on us by the ()-less
+ * definition of BEGIN.
+ */
+#define BEGIN (yy_start) = 1 + 2 *
+
+/* Translate the current start state into a value that can be later handed
+ * to BEGIN to return to the state.  The YYSTATE alias is for lex
+ * compatibility.
+ */
+#define YY_START (((yy_start) - 1) / 2)
+#define YYSTATE YY_START
+
+/* Action number for EOF rule of a given start state. */
+#define YY_STATE_EOF(state) (YY_END_OF_BUFFER + state + 1)
+
+/* Special action meaning "start processing a new file". */
+#define YY_NEW_FILE parse_events_restart(parse_events_in  )
+
+#define YY_END_OF_BUFFER_CHAR 0
+
+/* Size of default input buffer. */
+#ifndef YY_BUF_SIZE
+#define YY_BUF_SIZE 16384
+#endif
+
+/* The state buf must be large enough to hold one state per character in the main buffer.
+ */
+#define YY_STATE_BUF_SIZE   ((YY_BUF_SIZE + 2) * sizeof(yy_state_type))
+
+#ifndef YY_TYPEDEF_YY_BUFFER_STATE
+#define YY_TYPEDEF_YY_BUFFER_STATE
+typedef struct yy_buffer_state *YY_BUFFER_STATE;
+#endif
+
+extern int parse_events_leng;
+
+extern FILE *parse_events_in, *parse_events_out;
+
+#define EOB_ACT_CONTINUE_SCAN 0
+#define EOB_ACT_END_OF_FILE 1
+#define EOB_ACT_LAST_MATCH 2
+
+    #define YY_LESS_LINENO(n)
+    
+/* Return all but the first "n" matched characters back to the input stream. */
+#define yyless(n) \
+	do \
+		{ \
+		/* Undo effects of setting up parse_events_text. */ \
+        int yyless_macro_arg = (n); \
+        YY_LESS_LINENO(yyless_macro_arg);\
+		*yy_cp = (yy_hold_char); \
+		YY_RESTORE_YY_MORE_OFFSET \
+		(yy_c_buf_p) = yy_cp = yy_bp + yyless_macro_arg - YY_MORE_ADJ; \
+		YY_DO_BEFORE_ACTION; /* set up parse_events_text again */ \
+		} \
+	while ( 0 )
+
+#define unput(c) yyunput( c, (yytext_ptr)  )
+
+#ifndef YY_TYPEDEF_YY_SIZE_T
+#define YY_TYPEDEF_YY_SIZE_T
+typedef size_t yy_size_t;
+#endif
+
+#ifndef YY_STRUCT_YY_BUFFER_STATE
+#define YY_STRUCT_YY_BUFFER_STATE
+struct yy_buffer_state
+	{
+	FILE *yy_input_file;
+
+	char *yy_ch_buf;		/* input buffer */
+	char *yy_buf_pos;		/* current position in input buffer */
+
+	/* Size of input buffer in bytes, not including room for EOB
+	 * characters.
+	 */
+	yy_size_t yy_buf_size;
+
+	/* Number of characters read into yy_ch_buf, not including EOB
+	 * characters.
+	 */
+	int yy_n_chars;
+
+	/* Whether we "own" the buffer - i.e., we know we created it,
+	 * and can realloc() it to grow it, and should free() it to
+	 * delete it.
+	 */
+	int yy_is_our_buffer;
+
+	/* Whether this is an "interactive" input source; if so, and
+	 * if we're using stdio for input, then we want to use getc()
+	 * instead of fread(), to make sure we stop fetching input after
+	 * each newline.
+	 */
+	int yy_is_interactive;
+
+	/* Whether we're considered to be at the beginning of a line.
+	 * If so, '^' rules will be active on the next match, otherwise
+	 * not.
+	 */
+	int yy_at_bol;
+
+    int yy_bs_lineno; /**< The line count. */
+    int yy_bs_column; /**< The column count. */
+    
+	/* Whether to try to fill the input buffer when we reach the
+	 * end of it.
+	 */
+	int yy_fill_buffer;
+
+	int yy_buffer_status;
+
+#define YY_BUFFER_NEW 0
+#define YY_BUFFER_NORMAL 1
+	/* When an EOF's been seen but there's still some text to process
+	 * then we mark the buffer as YY_EOF_PENDING, to indicate that we
+	 * shouldn't try reading from the input source any more.  We might
+	 * still have a bunch of tokens to match, though, because of
+	 * possible backing-up.
+	 *
+	 * When we actually see the EOF, we change the status to "new"
+	 * (via parse_events_restart()), so that the user can continue scanning by
+	 * just pointing parse_events_in at a new input file.
+	 */
+#define YY_BUFFER_EOF_PENDING 2
+
+	};
+#endif /* !YY_STRUCT_YY_BUFFER_STATE */
+
+/* Stack of input buffers. */
+static size_t yy_buffer_stack_top = 0; /**< index of top of stack. */
+static size_t yy_buffer_stack_max = 0; /**< capacity of stack. */
+static YY_BUFFER_STATE * yy_buffer_stack = 0; /**< Stack as an array. */
+
+/* We provide macros for accessing buffer states in case in the
+ * future we want to put the buffer states in a more general
+ * "scanner state".
+ *
+ * Returns the top of the stack, or NULL.
+ */
+#define YY_CURRENT_BUFFER ( (yy_buffer_stack) \
+                          ? (yy_buffer_stack)[(yy_buffer_stack_top)] \
+                          : NULL)
+
+/* Same as previous macro, but useful when we know that the buffer stack is not
+ * NULL or when we need an lvalue. For internal use only.
+ */
+#define YY_CURRENT_BUFFER_LVALUE (yy_buffer_stack)[(yy_buffer_stack_top)]
+
+/* yy_hold_char holds the character lost when parse_events_text is formed. */
+static char yy_hold_char;
+static int yy_n_chars;		/* number of characters read into yy_ch_buf */
+int parse_events_leng;
+
+/* Points to current character in buffer. */
+static char *yy_c_buf_p = (char *) 0;
+static int yy_init = 0;		/* whether we need to initialize */
+static int yy_start = 0;	/* start state number */
+
+/* Flag which is used to allow parse_events_wrap()'s to do buffer switches
+ * instead of setting up a fresh parse_events_in.  A bit of a hack ...
+ */
+static int yy_did_buffer_switch_on_eof;
+
+void parse_events_restart (FILE *input_file  );
+void parse_events__switch_to_buffer (YY_BUFFER_STATE new_buffer  );
+YY_BUFFER_STATE parse_events__create_buffer (FILE *file,int size  );
+void parse_events__delete_buffer (YY_BUFFER_STATE b  );
+void parse_events__flush_buffer (YY_BUFFER_STATE b  );
+void parse_events_push_buffer_state (YY_BUFFER_STATE new_buffer  );
+void parse_events_pop_buffer_state (void );
+
+static void parse_events_ensure_buffer_stack (void );
+static void parse_events__load_buffer_state (void );
+static void parse_events__init_buffer (YY_BUFFER_STATE b,FILE *file  );
+
+#define YY_FLUSH_BUFFER parse_events__flush_buffer(YY_CURRENT_BUFFER )
+
+YY_BUFFER_STATE parse_events__scan_buffer (char *base,yy_size_t size  );
+YY_BUFFER_STATE parse_events__scan_string (yyconst char *yy_str  );
+YY_BUFFER_STATE parse_events__scan_bytes (yyconst char *bytes,int len  );
+
+void *parse_events_alloc (yy_size_t  );
+void *parse_events_realloc (void *,yy_size_t  );
+void parse_events_free (void *  );
+
+#define yy_new_buffer parse_events__create_buffer
+
+#define yy_set_interactive(is_interactive) \
+	{ \
+	if ( ! YY_CURRENT_BUFFER ){ \
+        parse_events_ensure_buffer_stack (); \
+		YY_CURRENT_BUFFER_LVALUE =    \
+            parse_events__create_buffer(parse_events_in,YY_BUF_SIZE ); \
+	} \
+	YY_CURRENT_BUFFER_LVALUE->yy_is_interactive = is_interactive; \
+	}
+
+#define yy_set_bol(at_bol) \
+	{ \
+	if ( ! YY_CURRENT_BUFFER ){\
+        parse_events_ensure_buffer_stack (); \
+		YY_CURRENT_BUFFER_LVALUE =    \
+            parse_events__create_buffer(parse_events_in,YY_BUF_SIZE ); \
+	} \
+	YY_CURRENT_BUFFER_LVALUE->yy_at_bol = at_bol; \
+	}
+
+#define YY_AT_BOL() (YY_CURRENT_BUFFER_LVALUE->yy_at_bol)
+
+/* Begin user sect3 */
+
+typedef unsigned char YY_CHAR;
+
+FILE *parse_events_in = (FILE *) 0, *parse_events_out = (FILE *) 0;
+
+typedef int yy_state_type;
+
+extern int parse_events_lineno;
+
+int parse_events_lineno = 1;
+
+extern char *parse_events_text;
+#define yytext_ptr parse_events_text
+
+static yy_state_type yy_get_previous_state (void );
+static yy_state_type yy_try_NUL_trans (yy_state_type current_state  );
+static int yy_get_next_buffer (void );
+static void yy_fatal_error (yyconst char msg[]  );
+
+/* Done after the current pattern has been matched and before the
+ * corresponding action - sets up parse_events_text.
+ */
+#define YY_DO_BEFORE_ACTION \
+	(yytext_ptr) = yy_bp; \
+	parse_events_leng = (size_t) (yy_cp - yy_bp); \
+	(yy_hold_char) = *yy_cp; \
+	*yy_cp = '\0'; \
+	(yy_c_buf_p) = yy_cp;
+
+#define YY_NUM_RULES 44
+#define YY_END_OF_BUFFER 45
+/* This struct is not used in this scanner,
+   but its presence is necessary. */
+struct yy_trans_info
+	{
+	flex_int32_t yy_verify;
+	flex_int32_t yy_nxt;
+	};
+static yyconst flex_int16_t yy_accept[425] =
+    {   0,
+        0,    0,   45,   44,   38,   41,   40,   39,   34,   34,
+       42,   43,   38,   38,   38,   38,   38,   38,   38,   38,
+       38,   38,   36,   38,   38,   38,   38,   38,   36,   37,
+       38,   38,   37,   37,   38,   34,    0,   38,   38,   38,
+       21,   38,   38,   38,   38,   38,   38,   38,   38,   38,
+       38,   38,   15,   38,    0,   38,   38,   38,   36,    0,
+       38,   38,   38,   38,   38,   38,   38,   38,   38,   38,
+       38,   38,   33,   33,   38,   38,   38,   38,   35,   38,
+       38,    0,   38,   38,   38,   24,   38,   38,   38,   38,
+       38,   38,    0,   38,   38,   38,   36,    0,   38,   38,
+
+       38,    0,   19,   20,   38,   38,   38,   38,   38,   38,
+       38,   30,   38,   38,   33,   33,   38,   38,   38,   38,
+       38,   38,   38,    0,    0,   38,   38,   38,   38,    0,
+       38,   38,    0,   38,    0,   22,   38,   38,   36,    0,
+       23,   38,   38,   19,   20,   26,   38,   32,   38,   38,
+       31,   25,   38,   38,   26,   38,   38,   38,   38,   38,
+        0,   38,    0,    0,    0,    0,   38,   38,   38,   38,
+        0,   38,   38,    0,    0,   38,   22,   38,   38,   36,
+       23,    0,   38,   26,   38,   38,   38,   38,    0,   38,
+       38,   38,   27,    0,   27,    0,   38,    0,    0,    0,
+
+        0,   38,   38,   24,    0,    0,   38,    0,    0,    0,
+        1,   38,   12,    0,   38,    0,   38,    0,   31,    0,
+       38,   38,   38,    0,    0,   38,    0,    0,    0,   38,
+       38,    0,   38,    0,    0,    0,   38,    0,    0,    0,
+       38,    0,   38,    0,   38,    0,    0,   38,   38,   38,
+        0,   38,    0,    0,    0,   38,   38,    0,    0,    7,
+        0,    0,    0,    0,    0,    0,    0,   38,    0,   38,
+        0,   38,    0,    0,   28,   38,    0,    0,   38,    0,
+       38,    0,    0,    0,    0,    0,    0,   10,    0,    0,
+       38,    0,   38,    0,   38,    0,    0,   38,   38,    0,
+
+        0,   38,    0,    0,    0,    0,    9,    0,    0,    0,
+        1,    0,    0,    0,   38,    0,   16,    0,    0,   28,
+       38,    0,   11,   38,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,   38,    0,    0,   12,   38,    0,
+        0,    0,    0,    0,    0,    6,    0,    0,    0,    0,
+        0,    4,   14,   13,    0,    0,    0,    0,    0,    0,
+        8,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,   16,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,   17,    0,    5,   15,   18,    0,    0,   29,
+
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,    7,    3,    0,    0,    0,    2,    0,    0,
+        0,    0,    0,    0
+    } ;
+
+static yyconst flex_int32_t yy_ec[256] =
+    {   0,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    2,    1,    3,    4,    1,    5,    6,    7,    8,
+        9,    9,    9,    9,    9,    9,    9,   10,    1,    1,
+       11,    1,    2,    1,   12,   13,   14,   15,   12,   12,
+        2,    2,   16,    2,    2,   17,    2,    2,    2,    2,
+        2,   18,    2,   19,    2,    2,    2,    2,    2,    2,
+        1,    1,    1,    1,    2,    1,   20,   21,   22,   23,
+
+       24,   25,   26,   27,   28,   29,   30,   31,   32,   33,
+       34,   35,    2,   36,   37,   38,   39,   40,   41,   42,
+       43,    2,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1
+    } ;
+
+static yyconst flex_int32_t yy_meta[44] =
+    {   0,
+        1,    2,    1,    1,    1,    3,    3,    3,    3,    1,
+        1,    3,    3,    3,    3,    2,    2,    2,    2,    3,
+        3,    3,    3,    3,    3,    2,    2,    2,    2,    2,
+        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
+        2,    2,    2
+    } ;
+
+static yyconst flex_int16_t yy_base[427] =
+    {   0,
+        0,    0,  494,  495,    0,  495,  495,  495,   38,   42,
+      495,  495,  473,  459,   45,  467,   32,   20,   40,   53,
+      458,  469,   34,   62,   58,   58,  454,  452,   64,   98,
+       32,  466,  449,    0,    0,   81,    0,  446,  446,  478,
+        0,  467,  455,  457,  450,   54,  457,  455,  438,  452,
+      440,  433,    0,  449,  432,  452,  429,  428,   97,  428,
+      448,  433,  426,  105,  442,  432,  428,  104,  436,  421,
+      431,  432,  431,   77,  430,   95,  416,  424,    0,  431,
+      412,  103,  425,  424,  421,    0,  413,  441,  417,  405,
+      438,  410,  409,  426,  407,  406,  108,  405,  422,  410,
+
+      395,  111,    0,    0,  409,  397,  420,  393,  394,  390,
+      402,    0,  401,  399,   93,  116,  401,  391,  385,  390,
+      381,  414,  381,   76,   46,  380,  378,  381,  391,  390,
+      387,  386,  120,  385,  387,    0,  387,  368,  119,  384,
+        0,  400,  367,  495,  495,  365,  365,  495,  380,  363,
+      374,    0,  393,  372,  371,  355,  362,  368,  387,  366,
+      370,  349,  349,  366,  365,  347,  359,  345,  349,  353,
+      336,  374,  335,  113,  348,  338,  495,  336,  336,    0,
+      495,  350,  332,    0,  366,  331,  364,  330,  341,  327,
+      333,  339,  325,  339,    0,  343,  337,  338,  335,  334,
+
+      317,  321,  329,  121,  330,  119,  313,  316,  327,  322,
+        0,  319,    0,  303,  323,  319,  315,  317,    0,  321,
+      318,  319,  315,  306,  323,  297,  307,  306,  296,  309,
+      297,  129,  292,  297,  299,  302,  321,  302,  292,  286,
+      287,  298,  281,  298,  283,  296,  276,  287,  275,  308,
+      277,  282,  285,  284,  268,  282,  267,  271,  275,    0,
+      278,  264,  275,  262,  268,  273,  276,  262,  263,  265,
+      253,  258,  251,  258,  264,  259,  264,  263,  250,  261,
+      278,  244,  243,  242,  241,  253,  235,  495,  238,  236,
+      269,  248,  237,  239,  232,  237,  229,  229,  225,  221,
+
+      233,  229,  223,  235,  221,  221,  495,  233,  220,  227,
+      495,  226,  228,  215,  218,  212,    0,  211,  211,    0,
+      223,  224,  495,  241,  216,  223,  206,  217,  203,  215,
+      200,  203,  216,  231,  197,  196,  195,  495,  227,  199,
+      210,  194,  188,  187,  188,  495,  191,  201,  189,  182,
+      138,    0,  495,  495,  129,  196,  202,  185,  186,  194,
+      495,  193,  187,  176,  181,  191,  174,  175,  184,  170,
+      193,  167,  166,  179,  178,  495,  163,  178,  165,  178,
+      177,  192,  158,  166,  156,  155,  154,  160,  156,  165,
+      164,  141,  495,  152,  495,  495,  495,  161,  146,  495,
+
+      163,  146,  148,  147,  155,  156,  143,  139,  152,  141,
+      143,  139,  495,  495,  148,  146,  131,  495,  131,  126,
+      125,   81,   85,  495,  165,   68
+    } ;
+
+static yyconst flex_int16_t yy_def[427] =
+    {   0,
+      424,    1,  424,  424,  425,  424,  424,  424,  424,  424,
+      424,  424,  425,  425,  425,  425,  425,  425,  425,  425,
+      425,  425,  425,  425,  425,  425,  425,  425,  425,  425,
+      425,  425,  425,  425,  425,  424,  426,  425,  425,  425,
+      425,  425,  425,  425,  425,  425,  425,  425,  425,  425,
+      425,  425,  425,  425,  424,  425,  425,  425,  425,  424,
+      425,  425,  425,  425,  425,  425,  425,  425,  425,  425,
+      425,  425,   30,   30,  425,  425,  425,  425,  426,  425,
+      425,  424,  425,  425,  425,  425,  425,  425,  425,  425,
+      425,  425,  424,  425,  425,  425,  425,  424,  425,  425,
+
+      425,  424,  425,  425,  425,  425,  425,  425,  425,  425,
+      425,  425,  425,  425,   30,   30,  425,  425,  425,  425,
+      425,  425,  425,  424,  424,  425,  425,  425,  425,  424,
+      425,  425,  424,  425,  424,  425,  425,  425,  425,  424,
+      425,  425,  425,  424,  424,  425,  425,  424,  425,  425,
+      425,  425,  425,  425,   30,  425,  425,  425,  425,  425,
+      424,  425,  424,  424,  424,  424,  425,  425,  425,  425,
+      424,  425,  425,  424,  424,  425,  424,  425,  425,  425,
+      424,  424,  425,  425,  425,  425,  425,  425,  424,  425,
+      425,  425,  425,  424,  425,  424,  425,  424,  424,  424,
+
+      424,  425,  425,  425,  424,  424,  425,  424,  424,  424,
+      425,  425,  425,  424,  425,  424,  425,  424,  425,  424,
+      425,  425,  425,  424,  424,  425,  424,  424,  424,  425,
+      425,  424,  425,  424,  424,  424,  425,  424,  424,  424,
+      425,  424,  425,  424,  425,  424,  424,  425,  425,  425,
+      424,  425,  424,  424,  424,  425,  425,  424,  424,  425,
+      424,  424,  424,  424,  424,  424,  424,  425,  424,  425,
+      424,  425,  424,  424,  425,  425,  424,  424,  425,  424,
+      425,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      425,  424,  425,  424,  425,  424,  424,  425,  425,  424,
+
+      424,  425,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  425,  424,  425,  424,  424,  425,
+      425,  424,  424,  425,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  425,  424,  424,  424,  425,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  425,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,    0,  424,  424
+    } ;
+
+static yyconst flex_int16_t yy_nxt[539] =
+    {   0,
+        4,    5,    6,    7,    8,    9,   10,   10,   10,   11,
+       12,    5,    5,    5,   13,   14,   15,   16,    5,   17,
+       18,   19,   20,   21,   22,    5,   23,   24,    5,   23,
+       25,   26,   27,   28,   29,   30,   31,   32,   23,    5,
+       33,   34,    5,   36,   36,   36,   36,   36,   36,   36,
+       36,   40,   41,   44,   46,   47,   55,   48,   49,   50,
+       59,   42,   45,   59,   64,   60,   75,  165,   59,   76,
+       79,   56,   59,   51,   52,   86,   53,   66,  166,   37,
+       61,   67,   54,   71,   62,   68,   36,   36,   36,   36,
+       59,   65,   86,   59,   63,  163,  115,  164,   59,   72,
+
+       73,  116,   59,   73,   73,   73,   73,  418,  102,   73,
+       73,   73,   73,  423,  118,  155,   73,   73,   73,   73,
+       73,   74,   73,   97,  232,  124,   97,  103,  119,  108,
+      125,   97,  104,  144,  139,   97,  109,  139,  145,   73,
+      110,  174,  139,  208,  233,  180,  139,  414,  180,  422,
+      235,  175,  112,  180,  236,  209,  258,  180,  366,  368,
+      259,  401,  367,  421,  369,  402,   35,   35,  420,  419,
+      418,  417,  416,  415,  414,  413,  412,  411,  410,  409,
+      408,  407,  406,  405,  404,  403,  400,  400,  399,  398,
+      397,  396,  395,  394,  393,  392,  391,  390,  389,  388,
+
+      387,  386,  385,  384,  383,  181,  382,  381,  380,  379,
+      378,  377,  376,  375,  374,  373,  372,  145,  371,  370,
+      365,  364,  363,  362,  361,  360,  359,  358,  357,  356,
+      355,  354,  353,  352,  351,  350,  349,  348,  347,  346,
+      345,  344,  343,  342,  341,  340,  339,  338,  337,  336,
+      335,  334,  333,  332,  331,  330,  329,  328,  327,  326,
+      325,  324,  323,  322,  321,  320,  319,  318,  317,  316,
+      315,  314,  313,  312,  311,  310,  309,  308,  307,  306,
+      305,  304,  303,  302,  301,  300,  299,  298,  297,  296,
+      295,  294,  293,  292,  291,  290,  289,  288,  287,  286,
+
+      285,  284,  283,  282,  281,  112,  280,  145,  144,  279,
+      278,  277,  276,  275,  274,  273,  272,  271,  270,  269,
+      268,  267,  266,  265,  264,  263,  262,  261,  260,  257,
+      256,  255,  254,  253,  252,  177,  251,  250,  249,  248,
+      247,  246,  245,  244,  243,  242,  241,  240,  239,  238,
+      237,  234,  231,  230,  229,  228,  227,  144,  226,  225,
+      224,  195,  223,  222,  221,  220,  219,  218,  217,  216,
+      215,  214,  213,  212,  211,  210,  207,  206,  205,  204,
+      203,  112,  202,  201,  200,  199,  198,  197,  196,  195,
+      194,  193,  192,  191,   73,  190,  189,  188,  187,  186,
+
+      185,  184,  183,  182,  181,  179,  178,  177,  176,  173,
+      172,  171,  170,  169,  168,  167,  162,  161,  160,  159,
+      158,  157,  156,  154,  153,  152,  151,  150,  149,  148,
+      147,  146,  143,  142,  141,  140,  138,  137,  136,  135,
+      134,  133,  132,  131,  130,  129,  128,  127,  126,  123,
+      122,  121,  120,  117,   73,  114,  113,  112,  111,  107,
+      106,  105,  101,  100,   99,   98,   96,   95,   94,   93,
+       92,   91,   90,   89,   88,   86,   87,   85,   84,   83,
+       41,   82,   81,   80,   78,   77,   70,   69,   58,   57,
+       43,   39,   38,  424,    3,  424,  424,  424,  424,  424,
+
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424
+    } ;
+
+static yyconst flex_int16_t yy_chk[539] =
+    {   0,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    9,    9,    9,    9,   10,   10,   10,
+       10,   15,   15,   17,   18,   18,   20,   18,   18,   19,
+       23,   15,   17,   23,   25,   24,   31,  125,   23,   31,
+      426,   20,   23,   19,   19,   46,   19,   26,  125,    9,
+       24,   26,   19,   29,   24,   26,   36,   36,   36,   36,
+       29,   25,   46,   29,   24,  124,   74,  124,   29,   29,
+
+       74,   74,   29,   30,   30,   30,   30,  423,   64,   30,
+       30,   30,   30,  422,   76,  115,  115,   30,   30,   30,
+       30,   30,   30,   59,  204,   82,   59,   64,   76,   68,
+       82,   59,   64,  102,   97,   59,   68,   97,  102,  116,
+       68,  133,   97,  174,  204,  139,   97,  421,  139,  420,
+      206,  133,  116,  139,  206,  174,  232,  139,  351,  355,
+      232,  392,  351,  419,  355,  392,  425,  425,  417,  416,
+      415,  412,  411,  410,  409,  408,  407,  406,  405,  404,
+      403,  402,  401,  399,  398,  394,  391,  390,  389,  388,
+      387,  386,  385,  384,  383,  382,  381,  380,  379,  378,
+
+      377,  375,  374,  373,  372,  371,  370,  369,  368,  367,
+      366,  365,  364,  363,  362,  360,  359,  358,  357,  356,
+      350,  349,  348,  347,  345,  344,  343,  342,  341,  340,
+      339,  337,  336,  335,  334,  333,  332,  331,  330,  329,
+      328,  327,  326,  325,  324,  322,  321,  319,  318,  316,
+      315,  314,  313,  312,  310,  309,  308,  306,  305,  304,
+      303,  302,  301,  300,  299,  298,  297,  296,  295,  294,
+      293,  292,  291,  290,  289,  287,  286,  285,  284,  283,
+      282,  281,  280,  279,  278,  277,  276,  275,  274,  273,
+      272,  271,  270,  269,  268,  267,  266,  265,  264,  263,
+
+      262,  261,  259,  258,  257,  256,  255,  254,  253,  252,
+      251,  250,  249,  248,  247,  246,  245,  244,  243,  242,
+      241,  240,  239,  238,  237,  236,  235,  234,  233,  231,
+      230,  229,  228,  227,  226,  225,  224,  223,  222,  221,
+      220,  218,  217,  216,  215,  214,  212,  210,  209,  208,
+      207,  205,  203,  202,  201,  200,  199,  198,  197,  196,
+      194,  193,  192,  191,  190,  189,  188,  187,  186,  185,
+      183,  182,  179,  178,  176,  175,  173,  172,  171,  170,
+      169,  168,  167,  166,  165,  164,  163,  162,  161,  160,
+      159,  158,  157,  156,  155,  154,  153,  151,  150,  149,
+
+      147,  146,  143,  142,  140,  138,  137,  135,  134,  132,
+      131,  130,  129,  128,  127,  126,  123,  122,  121,  120,
+      119,  118,  117,  114,  113,  111,  110,  109,  108,  107,
+      106,  105,  101,  100,   99,   98,   96,   95,   94,   93,
+       92,   91,   90,   89,   88,   87,   85,   84,   83,   81,
+       80,   78,   77,   75,   73,   72,   71,   70,   69,   67,
+       66,   65,   63,   62,   61,   60,   58,   57,   56,   55,
+       54,   52,   51,   50,   49,   48,   47,   45,   44,   43,
+       42,   40,   39,   38,   33,   32,   28,   27,   22,   21,
+       16,   14,   13,    3,  424,  424,  424,  424,  424,  424,
+
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
+      424,  424,  424,  424,  424,  424,  424,  424
+    } ;
+
+static yy_state_type yy_last_accepting_state;
+static char *yy_last_accepting_cpos;
+
+extern int parse_events__flex_debug;
+int parse_events__flex_debug = 0;
+
+/* The intent behind this definition is that it'll catch
+ * any uses of REJECT which flex missed.
+ */
+#define REJECT reject_used_but_not_detected
+#define yymore() yymore_used_but_not_detected
+#define YY_MORE_ADJ 0
+#define YY_RESTORE_YY_MORE_OFFSET
+char *parse_events_text;
+#line 1 "util/parse-events.l"
+#line 5 "util/parse-events.l"
+#include <errno.h>
+#include "../perf.h"
+#include "parse-events-bison.h"
+
+static int __value(char *str, int base, int token)
+{
+	long num;
+
+	errno = 0;
+	num = strtoul(str, NULL, base);
+	if (errno)
+		return PE_ERROR;
+
+	parse_events_lval.num = num;
+	return token;
+}
+
+static int value(int base)
+{
+	return __value(parse_events_text, base, PE_VALUE);
+}
+
+static int raw(void)
+{
+	return __value(parse_events_text + 1, 16, PE_RAW);
+}
+
+static int str(int token)
+{
+	parse_events_lval.str = strdup(parse_events_text);
+	return token;
+}
+
+static int sym(int type, int config)
+{
+	parse_events_lval.num = (type << 16) + config;
+	return PE_VALUE_SYM;
+}
+
+#line 766 "<stdout>"
+
+#define INITIAL 0
+
+#ifndef YY_NO_UNISTD_H
+/* Special case for "unistd.h", since it is non-ANSI. We include it way
+ * down here because we want the user's section 1 to have been scanned first.
+ * The user has a chance to override it with an option.
+ */
+#include <unistd.h>
+#endif
+
+#ifndef YY_EXTRA_TYPE
+#define YY_EXTRA_TYPE void *
+#endif
+
+static int yy_init_globals (void );
+
+/* Accessor methods to globals.
+   These are made visible to non-reentrant scanners for convenience. */
+
+int parse_events_lex_destroy (void );
+
+int parse_events_get_debug (void );
+
+void parse_events_set_debug (int debug_flag  );
+
+YY_EXTRA_TYPE parse_events_get_extra (void );
+
+void parse_events_set_extra (YY_EXTRA_TYPE user_defined  );
+
+FILE *parse_events_get_in (void );
+
+void parse_events_set_in  (FILE * in_str  );
+
+FILE *parse_events_get_out (void );
+
+void parse_events_set_out  (FILE * out_str  );
+
+int parse_events_get_leng (void );
+
+char *parse_events_get_text (void );
+
+int parse_events_get_lineno (void );
+
+void parse_events_set_lineno (int line_number  );
+
+/* Macros after this point can all be overridden by user definitions in
+ * section 1.
+ */
+
+#ifndef YY_SKIP_YYWRAP
+#ifdef __cplusplus
+extern "C" int parse_events_wrap (void );
+#else
+extern int parse_events_wrap (void );
+#endif
+#endif
+
+    static void yyunput (int c,char *buf_ptr  );
+    
+#ifndef yytext_ptr
+static void yy_flex_strncpy (char *,yyconst char *,int );
+#endif
+
+#ifdef YY_NEED_STRLEN
+static int yy_flex_strlen (yyconst char * );
+#endif
+
+#ifndef YY_NO_INPUT
+
+#ifdef __cplusplus
+static int yyinput (void );
+#else
+static int input (void );
+#endif
+
+#endif
+
+/* Amount of stuff to slurp up with each read. */
+#ifndef YY_READ_BUF_SIZE
+#define YY_READ_BUF_SIZE 8192
+#endif
+
+/* Copy whatever the last rule matched to the standard output. */
+#ifndef ECHO
+/* This used to be an fputs(), but since the string might contain NUL's,
+ * we now use fwrite().
+ */
+#define ECHO do { if (fwrite( parse_events_text, parse_events_leng, 1, parse_events_out )) {} } while (0)
+#endif
+
+/* Gets input and stuffs it into "buf".  number of characters read, or YY_NULL,
+ * is returned in "result".
+ */
+#ifndef YY_INPUT
+#define YY_INPUT(buf,result,max_size) \
+	if ( YY_CURRENT_BUFFER_LVALUE->yy_is_interactive ) \
+		{ \
+		int c = '*'; \
+		unsigned n; \
+		for ( n = 0; n < max_size && \
+			     (c = getc( parse_events_in )) != EOF && c != '\n'; ++n ) \
+			buf[n] = (char) c; \
+		if ( c == '\n' ) \
+			buf[n++] = (char) c; \
+		if ( c == EOF && ferror( parse_events_in ) ) \
+			YY_FATAL_ERROR( "input in flex scanner failed" ); \
+		result = n; \
+		} \
+	else \
+		{ \
+		errno=0; \
+		while ( (result = fread(buf, 1, max_size, parse_events_in))==0 && ferror(parse_events_in)) \
+			{ \
+			if( errno != EINTR) \
+				{ \
+				YY_FATAL_ERROR( "input in flex scanner failed" ); \
+				break; \
+				} \
+			errno=0; \
+			clearerr(parse_events_in); \
+			} \
+		}\
+\
+
+#endif
+
+/* No semi-colon after return; correct usage is to write "yyterminate();" -
+ * we don't want an extra ';' after the "return" because that will cause
+ * some compilers to complain about unreachable statements.
+ */
+#ifndef yyterminate
+#define yyterminate() return YY_NULL
+#endif
+
+/* Number of entries by which start-condition stack grows. */
+#ifndef YY_START_STACK_INCR
+#define YY_START_STACK_INCR 25
+#endif
+
+/* Report a fatal error. */
+#ifndef YY_FATAL_ERROR
+#define YY_FATAL_ERROR(msg) yy_fatal_error( msg )
+#endif
+
+/* end tables serialization structures and prototypes */
+
+/* Default declaration of generated scanner - a define so the user can
+ * easily add parameters.
+ */
+#ifndef YY_DECL
+#define YY_DECL_IS_OURS 1
+
+extern int parse_events_lex (void);
+
+#define YY_DECL int parse_events_lex (void)
+#endif /* !YY_DECL */
+
+/* Code executed at the beginning of each rule, after parse_events_text and parse_events_leng
+ * have been set up.
+ */
+#ifndef YY_USER_ACTION
+#define YY_USER_ACTION
+#endif
+
+/* Code executed at the end of each rule. */
+#ifndef YY_BREAK
+#define YY_BREAK break;
+#endif
+
+#define YY_RULE_SETUP \
+	YY_USER_ACTION
+
+/** The main scanner function which does all the work.
+ */
+YY_DECL
+{
+	register yy_state_type yy_current_state;
+	register char *yy_cp, *yy_bp;
+	register int yy_act;
+    
+#line 53 "util/parse-events.l"
+
+#line 950 "<stdout>"
+
+	if ( !(yy_init) )
+		{
+		(yy_init) = 1;
+
+#ifdef YY_USER_INIT
+		YY_USER_INIT;
+#endif
+
+		if ( ! (yy_start) )
+			(yy_start) = 1;	/* first start state */
+
+		if ( ! parse_events_in )
+			parse_events_in = stdin;
+
+		if ( ! parse_events_out )
+			parse_events_out = stdout;
+
+		if ( ! YY_CURRENT_BUFFER ) {
+			parse_events_ensure_buffer_stack ();
+			YY_CURRENT_BUFFER_LVALUE =
+				parse_events__create_buffer(parse_events_in,YY_BUF_SIZE );
+		}
+
+		parse_events__load_buffer_state( );
+		}
+
+	while ( 1 )		/* loops until end-of-file is reached */
+		{
+		yy_cp = (yy_c_buf_p);
+
+		/* Support of parse_events_text. */
+		*yy_cp = (yy_hold_char);
+
+		/* yy_bp points to the position in yy_ch_buf of the start of
+		 * the current run.
+		 */
+		yy_bp = yy_cp;
+
+		yy_current_state = (yy_start);
+yy_match:
+		do
+			{
+			register YY_CHAR yy_c = yy_ec[YY_SC_TO_UI(*yy_cp)];
+			if ( yy_accept[yy_current_state] )
+				{
+				(yy_last_accepting_state) = yy_current_state;
+				(yy_last_accepting_cpos) = yy_cp;
+				}
+			while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
+				{
+				yy_current_state = (int) yy_def[yy_current_state];
+				if ( yy_current_state >= 425 )
+					yy_c = yy_meta[(unsigned int) yy_c];
+				}
+			yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
+			++yy_cp;
+			}
+		while ( yy_base[yy_current_state] != 495 );
+
+yy_find_action:
+		yy_act = yy_accept[yy_current_state];
+		if ( yy_act == 0 )
+			{ /* have to back up */
+			yy_cp = (yy_last_accepting_cpos);
+			yy_current_state = (yy_last_accepting_state);
+			yy_act = yy_accept[yy_current_state];
+			}
+
+		YY_DO_BEFORE_ACTION;
+
+do_action:	/* This label is used only to access EOF actions. */
+
+		switch ( yy_act )
+	{ /* beginning of action switch */
+			case 0: /* must back up */
+			/* undo the effects of YY_DO_BEFORE_ACTION */
+			*yy_cp = (yy_hold_char);
+			yy_cp = (yy_last_accepting_cpos);
+			yy_current_state = (yy_last_accepting_state);
+			goto yy_find_action;
+
+case 1:
+YY_RULE_SETUP
+#line 54 "util/parse-events.l"
+{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
+	YY_BREAK
+case 2:
+YY_RULE_SETUP
+#line 55 "util/parse-events.l"
+{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
+	YY_BREAK
+case 3:
+YY_RULE_SETUP
+#line 56 "util/parse-events.l"
+{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
+	YY_BREAK
+case 4:
+YY_RULE_SETUP
+#line 57 "util/parse-events.l"
+{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS); }
+	YY_BREAK
+case 5:
+YY_RULE_SETUP
+#line 58 "util/parse-events.l"
+{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_REFERENCES); }
+	YY_BREAK
+case 6:
+YY_RULE_SETUP
+#line 59 "util/parse-events.l"
+{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_MISSES); }
+	YY_BREAK
+case 7:
+YY_RULE_SETUP
+#line 60 "util/parse-events.l"
+{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_INSTRUCTIONS); }
+	YY_BREAK
+case 8:
+YY_RULE_SETUP
+#line 61 "util/parse-events.l"
+{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES); }
+	YY_BREAK
+case 9:
+YY_RULE_SETUP
+#line 62 "util/parse-events.l"
+{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BUS_CYCLES); }
+	YY_BREAK
+case 10:
+YY_RULE_SETUP
+#line 63 "util/parse-events.l"
+{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_CLOCK); }
+	YY_BREAK
+case 11:
+YY_RULE_SETUP
+#line 64 "util/parse-events.l"
+{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK); }
+	YY_BREAK
+case 12:
+YY_RULE_SETUP
+#line 65 "util/parse-events.l"
+{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS); }
+	YY_BREAK
+case 13:
+YY_RULE_SETUP
+#line 66 "util/parse-events.l"
+{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MIN); }
+	YY_BREAK
+case 14:
+YY_RULE_SETUP
+#line 67 "util/parse-events.l"
+{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MAJ); }
+	YY_BREAK
+case 15:
+YY_RULE_SETUP
+#line 68 "util/parse-events.l"
+{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CONTEXT_SWITCHES); }
+	YY_BREAK
+case 16:
+YY_RULE_SETUP
+#line 69 "util/parse-events.l"
+{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS); }
+	YY_BREAK
+case 17:
+YY_RULE_SETUP
+#line 70 "util/parse-events.l"
+{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_ALIGNMENT_FAULTS); }
+	YY_BREAK
+case 18:
+YY_RULE_SETUP
+#line 71 "util/parse-events.l"
+{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
+	YY_BREAK
+case 19:
+#line 74 "util/parse-events.l"
+case 20:
+#line 75 "util/parse-events.l"
+case 21:
+#line 76 "util/parse-events.l"
+case 22:
+#line 77 "util/parse-events.l"
+case 23:
+#line 78 "util/parse-events.l"
+case 24:
+#line 79 "util/parse-events.l"
+case 25:
+YY_RULE_SETUP
+#line 79 "util/parse-events.l"
+{ return str(PE_NAME_CACHE_TYPE); }
+	YY_BREAK
+case 26:
+#line 82 "util/parse-events.l"
+case 27:
+#line 83 "util/parse-events.l"
+case 28:
+#line 84 "util/parse-events.l"
+case 29:
+#line 85 "util/parse-events.l"
+case 30:
+#line 86 "util/parse-events.l"
+case 31:
+YY_RULE_SETUP
+#line 86 "util/parse-events.l"
+{ return str(PE_NAME_CACHE_OP_RESULT); }
+	YY_BREAK
+case 32:
+YY_RULE_SETUP
+#line 88 "util/parse-events.l"
+{ return PE_PREFIX_MEM; }
+	YY_BREAK
+case 33:
+YY_RULE_SETUP
+#line 89 "util/parse-events.l"
+{ return raw(); }
+	YY_BREAK
+case 34:
+YY_RULE_SETUP
+#line 90 "util/parse-events.l"
+{ return value(10); }
+	YY_BREAK
+case 35:
+YY_RULE_SETUP
+#line 91 "util/parse-events.l"
+{ return value(16); }
+	YY_BREAK
+case 36:
+YY_RULE_SETUP
+#line 93 "util/parse-events.l"
+{ return str(PE_MODIFIER_EVENT); }
+	YY_BREAK
+case 37:
+YY_RULE_SETUP
+#line 94 "util/parse-events.l"
+{ return str(PE_MODIFIER_BP); }
+	YY_BREAK
+case 38:
+YY_RULE_SETUP
+#line 95 "util/parse-events.l"
+{ return str(PE_NAME); }
+	YY_BREAK
+case 39:
+YY_RULE_SETUP
+#line 96 "util/parse-events.l"
+{ return '/'; }
+	YY_BREAK
+case 40:
+YY_RULE_SETUP
+#line 97 "util/parse-events.l"
+{ return '-'; }
+	YY_BREAK
+case 41:
+YY_RULE_SETUP
+#line 98 "util/parse-events.l"
+{ return ','; }
+	YY_BREAK
+case 42:
+YY_RULE_SETUP
+#line 99 "util/parse-events.l"
+{ return ':'; }
+	YY_BREAK
+case 43:
+YY_RULE_SETUP
+#line 100 "util/parse-events.l"
+{ return '='; }
+	YY_BREAK
+case 44:
+YY_RULE_SETUP
+#line 102 "util/parse-events.l"
+ECHO;
+	YY_BREAK
+#line 1220 "<stdout>"
+case YY_STATE_EOF(INITIAL):
+	yyterminate();
+
+	case YY_END_OF_BUFFER:
+		{
+		/* Amount of text matched not including the EOB char. */
+		int yy_amount_of_matched_text = (int) (yy_cp - (yytext_ptr)) - 1;
+
+		/* Undo the effects of YY_DO_BEFORE_ACTION. */
+		*yy_cp = (yy_hold_char);
+		YY_RESTORE_YY_MORE_OFFSET
+
+		if ( YY_CURRENT_BUFFER_LVALUE->yy_buffer_status == YY_BUFFER_NEW )
+			{
+			/* We're scanning a new file or input source.  It's
+			 * possible that this happened because the user
+			 * just pointed parse_events_in at a new source and called
+			 * parse_events_lex().  If so, then we have to assure
+			 * consistency between YY_CURRENT_BUFFER and our
+			 * globals.  Here is the right place to do so, because
+			 * this is the first action (other than possibly a
+			 * back-up) that will match for the new input source.
+			 */
+			(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
+			YY_CURRENT_BUFFER_LVALUE->yy_input_file = parse_events_in;
+			YY_CURRENT_BUFFER_LVALUE->yy_buffer_status = YY_BUFFER_NORMAL;
+			}
+
+		/* Note that here we test for yy_c_buf_p "<=" to the position
+		 * of the first EOB in the buffer, since yy_c_buf_p will
+		 * already have been incremented past the NUL character
+		 * (since all states make transitions on EOB to the
+		 * end-of-buffer state).  Contrast this with the test
+		 * in input().
+		 */
+		if ( (yy_c_buf_p) <= &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)] )
+			{ /* This was really a NUL. */
+			yy_state_type yy_next_state;
+
+			(yy_c_buf_p) = (yytext_ptr) + yy_amount_of_matched_text;
+
+			yy_current_state = yy_get_previous_state(  );
+
+			/* Okay, we're now positioned to make the NUL
+			 * transition.  We couldn't have
+			 * yy_get_previous_state() go ahead and do it
+			 * for us because it doesn't know how to deal
+			 * with the possibility of jamming (and we don't
+			 * want to build jamming into it because then it
+			 * will run more slowly).
+			 */
+
+			yy_next_state = yy_try_NUL_trans( yy_current_state );
+
+			yy_bp = (yytext_ptr) + YY_MORE_ADJ;
+
+			if ( yy_next_state )
+				{
+				/* Consume the NUL. */
+				yy_cp = ++(yy_c_buf_p);
+				yy_current_state = yy_next_state;
+				goto yy_match;
+				}
+
+			else
+				{
+				yy_cp = (yy_c_buf_p);
+				goto yy_find_action;
+				}
+			}
+
+		else switch ( yy_get_next_buffer(  ) )
+			{
+			case EOB_ACT_END_OF_FILE:
+				{
+				(yy_did_buffer_switch_on_eof) = 0;
+
+				if ( parse_events_wrap( ) )
+					{
+					/* Note: because we've taken care in
+					 * yy_get_next_buffer() to have set up
+					 * parse_events_text, we can now set up
+					 * yy_c_buf_p so that if some total
+					 * hoser (like flex itself) wants to
+					 * call the scanner after we return the
+					 * YY_NULL, it'll still work - another
+					 * YY_NULL will get returned.
+					 */
+					(yy_c_buf_p) = (yytext_ptr) + YY_MORE_ADJ;
+
+					yy_act = YY_STATE_EOF(YY_START);
+					goto do_action;
+					}
+
+				else
+					{
+					if ( ! (yy_did_buffer_switch_on_eof) )
+						YY_NEW_FILE;
+					}
+				break;
+				}
+
+			case EOB_ACT_CONTINUE_SCAN:
+				(yy_c_buf_p) =
+					(yytext_ptr) + yy_amount_of_matched_text;
+
+				yy_current_state = yy_get_previous_state(  );
+
+				yy_cp = (yy_c_buf_p);
+				yy_bp = (yytext_ptr) + YY_MORE_ADJ;
+				goto yy_match;
+
+			case EOB_ACT_LAST_MATCH:
+				(yy_c_buf_p) =
+				&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)];
+
+				yy_current_state = yy_get_previous_state(  );
+
+				yy_cp = (yy_c_buf_p);
+				yy_bp = (yytext_ptr) + YY_MORE_ADJ;
+				goto yy_find_action;
+			}
+		break;
+		}
+
+	default:
+		YY_FATAL_ERROR(
+			"fatal flex scanner internal error--no action found" );
+	} /* end of action switch */
+		} /* end of scanning one token */
+} /* end of parse_events_lex */
+
+/* yy_get_next_buffer - try to read in a new buffer
+ *
+ * Returns a code representing an action:
+ *	EOB_ACT_LAST_MATCH -
+ *	EOB_ACT_CONTINUE_SCAN - continue scanning from current position
+ *	EOB_ACT_END_OF_FILE - end of file
+ */
+static int yy_get_next_buffer (void)
+{
+    	register char *dest = YY_CURRENT_BUFFER_LVALUE->yy_ch_buf;
+	register char *source = (yytext_ptr);
+	register int number_to_move, i;
+	int ret_val;
+
+	if ( (yy_c_buf_p) > &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars) + 1] )
+		YY_FATAL_ERROR(
+		"fatal flex scanner internal error--end of buffer missed" );
+
+	if ( YY_CURRENT_BUFFER_LVALUE->yy_fill_buffer == 0 )
+		{ /* Don't try to fill the buffer, so this is an EOF. */
+		if ( (yy_c_buf_p) - (yytext_ptr) - YY_MORE_ADJ == 1 )
+			{
+			/* We matched a single character, the EOB, so
+			 * treat this as a final EOF.
+			 */
+			return EOB_ACT_END_OF_FILE;
+			}
+
+		else
+			{
+			/* We matched some text prior to the EOB, first
+			 * process it.
+			 */
+			return EOB_ACT_LAST_MATCH;
+			}
+		}
+
+	/* Try to read more data. */
+
+	/* First move last chars to start of buffer. */
+	number_to_move = (int) ((yy_c_buf_p) - (yytext_ptr)) - 1;
+
+	for ( i = 0; i < number_to_move; ++i )
+		*(dest++) = *(source++);
+
+	if ( YY_CURRENT_BUFFER_LVALUE->yy_buffer_status == YY_BUFFER_EOF_PENDING )
+		/* don't do the read, it's not guaranteed to return an EOF,
+		 * just force an EOF
+		 */
+		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars) = 0;
+
+	else
+		{
+			int num_to_read =
+			YY_CURRENT_BUFFER_LVALUE->yy_buf_size - number_to_move - 1;
+
+		while ( num_to_read <= 0 )
+			{ /* Not enough room in the buffer - grow it. */
+
+			/* just a shorter name for the current buffer */
+			YY_BUFFER_STATE b = YY_CURRENT_BUFFER;
+
+			int yy_c_buf_p_offset =
+				(int) ((yy_c_buf_p) - b->yy_ch_buf);
+
+			if ( b->yy_is_our_buffer )
+				{
+				int new_size = b->yy_buf_size * 2;
+
+				if ( new_size <= 0 )
+					b->yy_buf_size += b->yy_buf_size / 8;
+				else
+					b->yy_buf_size *= 2;
+
+				b->yy_ch_buf = (char *)
+					/* Include room in for 2 EOB chars. */
+					parse_events_realloc((void *) b->yy_ch_buf,b->yy_buf_size + 2  );
+				}
+			else
+				/* Can't grow it, we don't own it. */
+				b->yy_ch_buf = 0;
+
+			if ( ! b->yy_ch_buf )
+				YY_FATAL_ERROR(
+				"fatal error - scanner input buffer overflow" );
+
+			(yy_c_buf_p) = &b->yy_ch_buf[yy_c_buf_p_offset];
+
+			num_to_read = YY_CURRENT_BUFFER_LVALUE->yy_buf_size -
+						number_to_move - 1;
+
+			}
+
+		if ( num_to_read > YY_READ_BUF_SIZE )
+			num_to_read = YY_READ_BUF_SIZE;
+
+		/* Read in more data. */
+		YY_INPUT( (&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
+			(yy_n_chars), (size_t) num_to_read );
+
+		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars);
+		}
+
+	if ( (yy_n_chars) == 0 )
+		{
+		if ( number_to_move == YY_MORE_ADJ )
+			{
+			ret_val = EOB_ACT_END_OF_FILE;
+			parse_events_restart(parse_events_in  );
+			}
+
+		else
+			{
+			ret_val = EOB_ACT_LAST_MATCH;
+			YY_CURRENT_BUFFER_LVALUE->yy_buffer_status =
+				YY_BUFFER_EOF_PENDING;
+			}
+		}
+
+	else
+		ret_val = EOB_ACT_CONTINUE_SCAN;
+
+	if ((yy_size_t) ((yy_n_chars) + number_to_move) > YY_CURRENT_BUFFER_LVALUE->yy_buf_size) {
+		/* Extend the array by 50%, plus the number we really need. */
+		yy_size_t new_size = (yy_n_chars) + number_to_move + ((yy_n_chars) >> 1);
+		YY_CURRENT_BUFFER_LVALUE->yy_ch_buf = (char *) parse_events_realloc((void *) YY_CURRENT_BUFFER_LVALUE->yy_ch_buf,new_size  );
+		if ( ! YY_CURRENT_BUFFER_LVALUE->yy_ch_buf )
+			YY_FATAL_ERROR( "out of dynamic memory in yy_get_next_buffer()" );
+	}
+
+	(yy_n_chars) += number_to_move;
+	YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)] = YY_END_OF_BUFFER_CHAR;
+	YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars) + 1] = YY_END_OF_BUFFER_CHAR;
+
+	(yytext_ptr) = &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[0];
+
+	return ret_val;
+}
+
+/* yy_get_previous_state - get the state just before the EOB char was reached */
+
+    static yy_state_type yy_get_previous_state (void)
+{
+	register yy_state_type yy_current_state;
+	register char *yy_cp;
+    
+	yy_current_state = (yy_start);
+
+	for ( yy_cp = (yytext_ptr) + YY_MORE_ADJ; yy_cp < (yy_c_buf_p); ++yy_cp )
+		{
+		register YY_CHAR yy_c = (*yy_cp ? yy_ec[YY_SC_TO_UI(*yy_cp)] : 1);
+		if ( yy_accept[yy_current_state] )
+			{
+			(yy_last_accepting_state) = yy_current_state;
+			(yy_last_accepting_cpos) = yy_cp;
+			}
+		while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
+			{
+			yy_current_state = (int) yy_def[yy_current_state];
+			if ( yy_current_state >= 425 )
+				yy_c = yy_meta[(unsigned int) yy_c];
+			}
+		yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
+		}
+
+	return yy_current_state;
+}
+
+/* yy_try_NUL_trans - try to make a transition on the NUL character
+ *
+ * synopsis
+ *	next_state = yy_try_NUL_trans( current_state );
+ */
+    static yy_state_type yy_try_NUL_trans  (yy_state_type yy_current_state )
+{
+	register int yy_is_jam;
+    	register char *yy_cp = (yy_c_buf_p);
+
+	register YY_CHAR yy_c = 1;
+	if ( yy_accept[yy_current_state] )
+		{
+		(yy_last_accepting_state) = yy_current_state;
+		(yy_last_accepting_cpos) = yy_cp;
+		}
+	while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
+		{
+		yy_current_state = (int) yy_def[yy_current_state];
+		if ( yy_current_state >= 425 )
+			yy_c = yy_meta[(unsigned int) yy_c];
+		}
+	yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
+	yy_is_jam = (yy_current_state == 424);
+
+	return yy_is_jam ? 0 : yy_current_state;
+}
+
+    static void yyunput (int c, register char * yy_bp )
+{
+	register char *yy_cp;
+    
+    yy_cp = (yy_c_buf_p);
+
+	/* undo effects of setting up parse_events_text */
+	*yy_cp = (yy_hold_char);
+
+	if ( yy_cp < YY_CURRENT_BUFFER_LVALUE->yy_ch_buf + 2 )
+		{ /* need to shift things up to make room */
+		/* +2 for EOB chars. */
+		register int number_to_move = (yy_n_chars) + 2;
+		register char *dest = &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[
+					YY_CURRENT_BUFFER_LVALUE->yy_buf_size + 2];
+		register char *source =
+				&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move];
+
+		while ( source > YY_CURRENT_BUFFER_LVALUE->yy_ch_buf )
+			*--dest = *--source;
+
+		yy_cp += (int) (dest - source);
+		yy_bp += (int) (dest - source);
+		YY_CURRENT_BUFFER_LVALUE->yy_n_chars =
+			(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_buf_size;
+
+		if ( yy_cp < YY_CURRENT_BUFFER_LVALUE->yy_ch_buf + 2 )
+			YY_FATAL_ERROR( "flex scanner push-back overflow" );
+		}
+
+	*--yy_cp = (char) c;
+
+	(yytext_ptr) = yy_bp;
+	(yy_hold_char) = *yy_cp;
+	(yy_c_buf_p) = yy_cp;
+}
+
+#ifndef YY_NO_INPUT
+#ifdef __cplusplus
+    static int yyinput (void)
+#else
+    static int input  (void)
+#endif
+
+{
+	int c;
+    
+	*(yy_c_buf_p) = (yy_hold_char);
+
+	if ( *(yy_c_buf_p) == YY_END_OF_BUFFER_CHAR )
+		{
+		/* yy_c_buf_p now points to the character we want to return.
+		 * If this occurs *before* the EOB characters, then it's a
+		 * valid NUL; if not, then we've hit the end of the buffer.
+		 */
+		if ( (yy_c_buf_p) < &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)] )
+			/* This was really a NUL. */
+			*(yy_c_buf_p) = '\0';
+
+		else
+			{ /* need more input */
+			int offset = (yy_c_buf_p) - (yytext_ptr);
+			++(yy_c_buf_p);
+
+			switch ( yy_get_next_buffer(  ) )
+				{
+				case EOB_ACT_LAST_MATCH:
+					/* This happens because yy_g_n_b()
+					 * sees that we've accumulated a
+					 * token and flags that we need to
+					 * try matching the token before
+					 * proceeding.  But for input(),
+					 * there's no matching to consider.
+					 * So convert the EOB_ACT_LAST_MATCH
+					 * to EOB_ACT_END_OF_FILE.
+					 */
+
+					/* Reset buffer status. */
+					parse_events_restart(parse_events_in );
+
+					/*FALLTHROUGH*/
+
+				case EOB_ACT_END_OF_FILE:
+					{
+					if ( parse_events_wrap( ) )
+						return EOF;
+
+					if ( ! (yy_did_buffer_switch_on_eof) )
+						YY_NEW_FILE;
+#ifdef __cplusplus
+					return yyinput();
+#else
+					return input();
+#endif
+					}
+
+				case EOB_ACT_CONTINUE_SCAN:
+					(yy_c_buf_p) = (yytext_ptr) + offset;
+					break;
+				}
+			}
+		}
+
+	c = *(unsigned char *) (yy_c_buf_p);	/* cast for 8-bit char's */
+	*(yy_c_buf_p) = '\0';	/* preserve parse_events_text */
+	(yy_hold_char) = *++(yy_c_buf_p);
+
+	return c;
+}
+#endif	/* ifndef YY_NO_INPUT */
+
+/** Immediately switch to a different input stream.
+ * @param input_file A readable stream.
+ * 
+ * @note This function does not reset the start condition to @c INITIAL .
+ */
+    void parse_events_restart  (FILE * input_file )
+{
+    
+	if ( ! YY_CURRENT_BUFFER ){
+        parse_events_ensure_buffer_stack ();
+		YY_CURRENT_BUFFER_LVALUE =
+            parse_events__create_buffer(parse_events_in,YY_BUF_SIZE );
+	}
+
+	parse_events__init_buffer(YY_CURRENT_BUFFER,input_file );
+	parse_events__load_buffer_state( );
+}
+
+/** Switch to a different input buffer.
+ * @param new_buffer The new input buffer.
+ * 
+ */
+    void parse_events__switch_to_buffer  (YY_BUFFER_STATE  new_buffer )
+{
+    
+	/* TODO. We should be able to replace this entire function body
+	 * with
+	 *		parse_events_pop_buffer_state();
+	 *		parse_events_push_buffer_state(new_buffer);
+     */
+	parse_events_ensure_buffer_stack ();
+	if ( YY_CURRENT_BUFFER == new_buffer )
+		return;
+
+	if ( YY_CURRENT_BUFFER )
+		{
+		/* Flush out information for old buffer. */
+		*(yy_c_buf_p) = (yy_hold_char);
+		YY_CURRENT_BUFFER_LVALUE->yy_buf_pos = (yy_c_buf_p);
+		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars);
+		}
+
+	YY_CURRENT_BUFFER_LVALUE = new_buffer;
+	parse_events__load_buffer_state( );
+
+	/* We don't actually know whether we did this switch during
+	 * EOF (parse_events_wrap()) processing, but the only time this flag
+	 * is looked at is after parse_events_wrap() is called, so it's safe
+	 * to go ahead and always set it.
+	 */
+	(yy_did_buffer_switch_on_eof) = 1;
+}
+
+static void parse_events__load_buffer_state  (void)
+{
+    	(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
+	(yytext_ptr) = (yy_c_buf_p) = YY_CURRENT_BUFFER_LVALUE->yy_buf_pos;
+	parse_events_in = YY_CURRENT_BUFFER_LVALUE->yy_input_file;
+	(yy_hold_char) = *(yy_c_buf_p);
+}
+
+/** Allocate and initialize an input buffer state.
+ * @param file A readable stream.
+ * @param size The character buffer size in bytes. When in doubt, use @c YY_BUF_SIZE.
+ * 
+ * @return the allocated buffer state.
+ */
+    YY_BUFFER_STATE parse_events__create_buffer  (FILE * file, int  size )
+{
+	YY_BUFFER_STATE b;
+    
+	b = (YY_BUFFER_STATE) parse_events_alloc(sizeof( struct yy_buffer_state )  );
+	if ( ! b )
+		YY_FATAL_ERROR( "out of dynamic memory in parse_events__create_buffer()" );
+
+	b->yy_buf_size = size;
+
+	/* yy_ch_buf has to be 2 characters longer than the size given because
+	 * we need to put in 2 end-of-buffer characters.
+	 */
+	b->yy_ch_buf = (char *) parse_events_alloc(b->yy_buf_size + 2  );
+	if ( ! b->yy_ch_buf )
+		YY_FATAL_ERROR( "out of dynamic memory in parse_events__create_buffer()" );
+
+	b->yy_is_our_buffer = 1;
+
+	parse_events__init_buffer(b,file );
+
+	return b;
+}
+
+/** Destroy the buffer.
+ * @param b a buffer created with parse_events__create_buffer()
+ * 
+ */
+    void parse_events__delete_buffer (YY_BUFFER_STATE  b )
+{
+    
+	if ( ! b )
+		return;
+
+	if ( b == YY_CURRENT_BUFFER ) /* Not sure if we should pop here. */
+		YY_CURRENT_BUFFER_LVALUE = (YY_BUFFER_STATE) 0;
+
+	if ( b->yy_is_our_buffer )
+		parse_events_free((void *) b->yy_ch_buf  );
+
+	parse_events_free((void *) b  );
+}
+
+#ifndef __cplusplus
+extern int isatty (int );
+#endif /* __cplusplus */
+    
+/* Initializes or reinitializes a buffer.
+ * This function is sometimes called more than once on the same buffer,
+ * such as during a parse_events_restart() or at EOF.
+ */
+    static void parse_events__init_buffer  (YY_BUFFER_STATE  b, FILE * file )
+
+{
+	int oerrno = errno;
+    
+	parse_events__flush_buffer(b );
+
+	b->yy_input_file = file;
+	b->yy_fill_buffer = 1;
+
+    /* If b is the current buffer, then parse_events__init_buffer was _probably_
+     * called from parse_events_restart() or through yy_get_next_buffer.
+     * In that case, we don't want to reset the lineno or column.
+     */
+    if (b != YY_CURRENT_BUFFER){
+        b->yy_bs_lineno = 1;
+        b->yy_bs_column = 0;
+    }
+
+        b->yy_is_interactive = file ? (isatty( fileno(file) ) > 0) : 0;
+    
+	errno = oerrno;
+}
+
+/** Discard all buffered characters. On the next scan, YY_INPUT will be called.
+ * @param b the buffer state to be flushed, usually @c YY_CURRENT_BUFFER.
+ * 
+ */
+    void parse_events__flush_buffer (YY_BUFFER_STATE  b )
+{
+    	if ( ! b )
+		return;
+
+	b->yy_n_chars = 0;
+
+	/* We always need two end-of-buffer characters.  The first causes
+	 * a transition to the end-of-buffer state.  The second causes
+	 * a jam in that state.
+	 */
+	b->yy_ch_buf[0] = YY_END_OF_BUFFER_CHAR;
+	b->yy_ch_buf[1] = YY_END_OF_BUFFER_CHAR;
+
+	b->yy_buf_pos = &b->yy_ch_buf[0];
+
+	b->yy_at_bol = 1;
+	b->yy_buffer_status = YY_BUFFER_NEW;
+
+	if ( b == YY_CURRENT_BUFFER )
+		parse_events__load_buffer_state( );
+}
+
+/** Pushes the new state onto the stack. The new state becomes
+ *  the current state. This function will allocate the stack
+ *  if necessary.
+ *  @param new_buffer The new state.
+ *  
+ */
+void parse_events_push_buffer_state (YY_BUFFER_STATE new_buffer )
+{
+    	if (new_buffer == NULL)
+		return;
+
+	parse_events_ensure_buffer_stack();
+
+	/* This block is copied from parse_events__switch_to_buffer. */
+	if ( YY_CURRENT_BUFFER )
+		{
+		/* Flush out information for old buffer. */
+		*(yy_c_buf_p) = (yy_hold_char);
+		YY_CURRENT_BUFFER_LVALUE->yy_buf_pos = (yy_c_buf_p);
+		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars);
+		}
+
+	/* Only push if top exists. Otherwise, replace top. */
+	if (YY_CURRENT_BUFFER)
+		(yy_buffer_stack_top)++;
+	YY_CURRENT_BUFFER_LVALUE = new_buffer;
+
+	/* copied from parse_events__switch_to_buffer. */
+	parse_events__load_buffer_state( );
+	(yy_did_buffer_switch_on_eof) = 1;
+}
+
+/** Removes and deletes the top of the stack, if present.
+ *  The next element becomes the new top.
+ *  
+ */
+void parse_events_pop_buffer_state (void)
+{
+    	if (!YY_CURRENT_BUFFER)
+		return;
+
+	parse_events__delete_buffer(YY_CURRENT_BUFFER );
+	YY_CURRENT_BUFFER_LVALUE = NULL;
+	if ((yy_buffer_stack_top) > 0)
+		--(yy_buffer_stack_top);
+
+	if (YY_CURRENT_BUFFER) {
+		parse_events__load_buffer_state( );
+		(yy_did_buffer_switch_on_eof) = 1;
+	}
+}
+
+/* Allocates the stack if it does not exist.
+ *  Guarantees space for at least one push.
+ */
+static void parse_events_ensure_buffer_stack (void)
+{
+	int num_to_alloc;
+    
+	if (!(yy_buffer_stack)) {
+
+		/* First allocation is just for 2 elements, since we don't know if this
+		 * scanner will even need a stack. We use 2 instead of 1 to avoid an
+		 * immediate realloc on the next call.
+         */
+		num_to_alloc = 1;
+		(yy_buffer_stack) = (struct yy_buffer_state**)parse_events_alloc
+								(num_to_alloc * sizeof(struct yy_buffer_state*)
+								);
+		if ( ! (yy_buffer_stack) )
+			YY_FATAL_ERROR( "out of dynamic memory in parse_events_ensure_buffer_stack()" );
+								  
+		memset((yy_buffer_stack), 0, num_to_alloc * sizeof(struct yy_buffer_state*));
+				
+		(yy_buffer_stack_max) = num_to_alloc;
+		(yy_buffer_stack_top) = 0;
+		return;
+	}
+
+	if ((yy_buffer_stack_top) >= ((yy_buffer_stack_max)) - 1){
+
+		/* Increase the buffer to prepare for a possible push. */
+		int grow_size = 8 /* arbitrary grow size */;
+
+		num_to_alloc = (yy_buffer_stack_max) + grow_size;
+		(yy_buffer_stack) = (struct yy_buffer_state**)parse_events_realloc
+								((yy_buffer_stack),
+								num_to_alloc * sizeof(struct yy_buffer_state*)
+								);
+		if ( ! (yy_buffer_stack) )
+			YY_FATAL_ERROR( "out of dynamic memory in parse_events_ensure_buffer_stack()" );
+
+		/* zero only the new slots.*/
+		memset((yy_buffer_stack) + (yy_buffer_stack_max), 0, grow_size * sizeof(struct yy_buffer_state*));
+		(yy_buffer_stack_max) = num_to_alloc;
+	}
+}
+
+/** Setup the input buffer state to scan directly from a user-specified character buffer.
+ * @param base the character buffer
+ * @param size the size in bytes of the character buffer
+ * 
+ * @return the newly allocated buffer state object. 
+ */
+YY_BUFFER_STATE parse_events__scan_buffer  (char * base, yy_size_t  size )
+{
+	YY_BUFFER_STATE b;
+    
+	if ( size < 2 ||
+	     base[size-2] != YY_END_OF_BUFFER_CHAR ||
+	     base[size-1] != YY_END_OF_BUFFER_CHAR )
+		/* They forgot to leave room for the EOB's. */
+		return 0;
+
+	b = (YY_BUFFER_STATE) parse_events_alloc(sizeof( struct yy_buffer_state )  );
+	if ( ! b )
+		YY_FATAL_ERROR( "out of dynamic memory in parse_events__scan_buffer()" );
+
+	b->yy_buf_size = size - 2;	/* "- 2" to take care of EOB's */
+	b->yy_buf_pos = b->yy_ch_buf = base;
+	b->yy_is_our_buffer = 0;
+	b->yy_input_file = 0;
+	b->yy_n_chars = b->yy_buf_size;
+	b->yy_is_interactive = 0;
+	b->yy_at_bol = 1;
+	b->yy_fill_buffer = 0;
+	b->yy_buffer_status = YY_BUFFER_NEW;
+
+	parse_events__switch_to_buffer(b  );
+
+	return b;
+}
+
+/** Setup the input buffer state to scan a string. The next call to parse_events_lex() will
+ * scan from a @e copy of @a str.
+ * @param yystr a NUL-terminated string to scan
+ * 
+ * @return the newly allocated buffer state object.
+ * @note If you want to scan bytes that may contain NUL values, then use
+ *       parse_events__scan_bytes() instead.
+ */
+YY_BUFFER_STATE parse_events__scan_string (yyconst char * yystr )
+{
+    
+	return parse_events__scan_bytes(yystr,strlen(yystr) );
+}
+
+/** Setup the input buffer state to scan the given bytes. The next call to parse_events_lex() will
+ * scan from a @e copy of @a bytes.
+ * @param bytes the byte buffer to scan
+ * @param len the number of bytes in the buffer pointed to by @a bytes.
+ * 
+ * @return the newly allocated buffer state object.
+ */
+YY_BUFFER_STATE parse_events__scan_bytes  (yyconst char * yybytes, int  _yybytes_len )
+{
+	YY_BUFFER_STATE b;
+	char *buf;
+	yy_size_t n;
+	int i;
+    
+	/* Get memory for full buffer, including space for trailing EOB's. */
+	n = _yybytes_len + 2;
+	buf = (char *) parse_events_alloc(n  );
+	if ( ! buf )
+		YY_FATAL_ERROR( "out of dynamic memory in parse_events__scan_bytes()" );
+
+	for ( i = 0; i < _yybytes_len; ++i )
+		buf[i] = yybytes[i];
+
+	buf[_yybytes_len] = buf[_yybytes_len+1] = YY_END_OF_BUFFER_CHAR;
+
+	b = parse_events__scan_buffer(buf,n );
+	if ( ! b )
+		YY_FATAL_ERROR( "bad buffer in parse_events__scan_bytes()" );
+
+	/* It's okay to grow etc. this buffer, and we should throw it
+	 * away when we're done.
+	 */
+	b->yy_is_our_buffer = 1;
+
+	return b;
+}
+
+#ifndef YY_EXIT_FAILURE
+#define YY_EXIT_FAILURE 2
+#endif
+
+static void yy_fatal_error (yyconst char* msg )
+{
+    	(void) fprintf( stderr, "%s\n", msg );
+	exit( YY_EXIT_FAILURE );
+}
+
+/* Redefine yyless() so it works in section 3 code. */
+
+#undef yyless
+#define yyless(n) \
+	do \
+		{ \
+		/* Undo effects of setting up parse_events_text. */ \
+        int yyless_macro_arg = (n); \
+        YY_LESS_LINENO(yyless_macro_arg);\
+		parse_events_text[parse_events_leng] = (yy_hold_char); \
+		(yy_c_buf_p) = parse_events_text + yyless_macro_arg; \
+		(yy_hold_char) = *(yy_c_buf_p); \
+		*(yy_c_buf_p) = '\0'; \
+		parse_events_leng = yyless_macro_arg; \
+		} \
+	while ( 0 )
+
+/* Accessor  methods (get/set functions) to struct members. */
+
+/** Get the current line number.
+ * 
+ */
+int parse_events_get_lineno  (void)
+{
+        
+    return parse_events_lineno;
+}
+
+/** Get the input stream.
+ * 
+ */
+FILE *parse_events_get_in  (void)
+{
+        return parse_events_in;
+}
+
+/** Get the output stream.
+ * 
+ */
+FILE *parse_events_get_out  (void)
+{
+        return parse_events_out;
+}
+
+/** Get the length of the current token.
+ * 
+ */
+int parse_events_get_leng  (void)
+{
+        return parse_events_leng;
+}
+
+/** Get the current token.
+ * 
+ */
+
+char *parse_events_get_text  (void)
+{
+        return parse_events_text;
+}
+
+/** Set the current line number.
+ * @param line_number
+ * 
+ */
+void parse_events_set_lineno (int  line_number )
+{
+    
+    parse_events_lineno = line_number;
+}
+
+/** Set the input stream. This does not discard the current
+ * input buffer.
+ * @param in_str A readable stream.
+ * 
+ * @see parse_events__switch_to_buffer
+ */
+void parse_events_set_in (FILE *  in_str )
+{
+        parse_events_in = in_str ;
+}
+
+void parse_events_set_out (FILE *  out_str )
+{
+        parse_events_out = out_str ;
+}
+
+int parse_events_get_debug  (void)
+{
+        return parse_events__flex_debug;
+}
+
+void parse_events_set_debug (int  bdebug )
+{
+        parse_events__flex_debug = bdebug ;
+}
+
+static int yy_init_globals (void)
+{
+        /* Initialization is the same as for the non-reentrant scanner.
+     * This function is called from parse_events_lex_destroy(), so don't allocate here.
+     */
+
+    (yy_buffer_stack) = 0;
+    (yy_buffer_stack_top) = 0;
+    (yy_buffer_stack_max) = 0;
+    (yy_c_buf_p) = (char *) 0;
+    (yy_init) = 0;
+    (yy_start) = 0;
+
+/* Defined in main.c */
+#ifdef YY_STDINIT
+    parse_events_in = stdin;
+    parse_events_out = stdout;
+#else
+    parse_events_in = (FILE *) 0;
+    parse_events_out = (FILE *) 0;
+#endif
+
+    /* For future reference: Set errno on error, since we are called by
+     * parse_events_lex_init()
+     */
+    return 0;
+}
+
+/* parse_events_lex_destroy is for both reentrant and non-reentrant scanners. */
+int parse_events_lex_destroy  (void)
+{
+    
+    /* Pop the buffer stack, destroying each element. */
+	while(YY_CURRENT_BUFFER){
+		parse_events__delete_buffer(YY_CURRENT_BUFFER  );
+		YY_CURRENT_BUFFER_LVALUE = NULL;
+		parse_events_pop_buffer_state();
+	}
+
+	/* Destroy the stack itself. */
+	parse_events_free((yy_buffer_stack) );
+	(yy_buffer_stack) = NULL;
+
+    /* Reset the globals. This is important in a non-reentrant scanner so the next time
+     * parse_events_lex() is called, initialization will occur. */
+    yy_init_globals( );
+
+    return 0;
+}
+
+/*
+ * Internal utility routines.
+ */
+
+#ifndef yytext_ptr
+static void yy_flex_strncpy (char* s1, yyconst char * s2, int n )
+{
+	register int i;
+	for ( i = 0; i < n; ++i )
+		s1[i] = s2[i];
+}
+#endif
+
+#ifdef YY_NEED_STRLEN
+static int yy_flex_strlen (yyconst char * s )
+{
+	register int n;
+	for ( n = 0; s[n]; ++n )
+		;
+
+	return n;
+}
+#endif
+
+void *parse_events_alloc (yy_size_t  size )
+{
+	return (void *) malloc( size );
+}
+
+void *parse_events_realloc  (void * ptr, yy_size_t  size )
+{
+	/* The cast to (char *) in the following accommodates both
+	 * implementations that use char* generic pointers, and those
+	 * that use void* generic pointers.  It works with the latter
+	 * because both ANSI C and C++ allow castless assignment from
+	 * any pointer type to void*, and deal with argument conversions
+	 * as though doing an assignment.
+	 */
+	return (void *) realloc( (char *) ptr, size );
+}
+
+void parse_events_free (void * ptr )
+{
+	free( (char *) ptr );	/* see parse_events_realloc() for (char *) cast */
+}
+
+#define YYTABLES_NAME "yytables"
+
+#line 102 "util/parse-events.l"
+
+
+
+int parse_events_wrap(void)
+{
+	return 1;
+}
+
diff --git a/tools/perf/util/parse-events-flex.h b/tools/perf/util/parse-events-flex.h
new file mode 100644
index 0000000..b927f9a
--- /dev/null
+++ b/tools/perf/util/parse-events-flex.h
@@ -0,0 +1,316 @@
+#ifndef parse_events_HEADER_H
+#define parse_events_HEADER_H 1
+#define parse_events_IN_HEADER 1
+
+#line 6 "util/parse-events-flex.h"
+
+#define  YY_INT_ALIGNED short int
+
+/* A lexical scanner generated by flex */
+
+#define FLEX_SCANNER
+#define YY_FLEX_MAJOR_VERSION 2
+#define YY_FLEX_MINOR_VERSION 5
+#define YY_FLEX_SUBMINOR_VERSION 35
+#if YY_FLEX_SUBMINOR_VERSION > 0
+#define FLEX_BETA
+#endif
+
+/* First, we deal with  platform-specific or compiler-specific issues. */
+
+/* begin standard C headers. */
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <stdlib.h>
+
+/* end standard C headers. */
+
+/* flex integer type definitions */
+
+#ifndef FLEXINT_H
+#define FLEXINT_H
+
+/* C99 systems have <inttypes.h>. Non-C99 systems may or may not. */
+
+#if defined (__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
+
+/* C99 says to define __STDC_LIMIT_MACROS before including stdint.h,
+ * if you want the limit (max/min) macros for int types. 
+ */
+#ifndef __STDC_LIMIT_MACROS
+#define __STDC_LIMIT_MACROS 1
+#endif
+
+#include <inttypes.h>
+typedef int8_t flex_int8_t;
+typedef uint8_t flex_uint8_t;
+typedef int16_t flex_int16_t;
+typedef uint16_t flex_uint16_t;
+typedef int32_t flex_int32_t;
+typedef uint32_t flex_uint32_t;
+#else
+typedef signed char flex_int8_t;
+typedef short int flex_int16_t;
+typedef int flex_int32_t;
+typedef unsigned char flex_uint8_t; 
+typedef unsigned short int flex_uint16_t;
+typedef unsigned int flex_uint32_t;
+#endif /* ! C99 */
+
+/* Limits of integral types. */
+#ifndef INT8_MIN
+#define INT8_MIN               (-128)
+#endif
+#ifndef INT16_MIN
+#define INT16_MIN              (-32767-1)
+#endif
+#ifndef INT32_MIN
+#define INT32_MIN              (-2147483647-1)
+#endif
+#ifndef INT8_MAX
+#define INT8_MAX               (127)
+#endif
+#ifndef INT16_MAX
+#define INT16_MAX              (32767)
+#endif
+#ifndef INT32_MAX
+#define INT32_MAX              (2147483647)
+#endif
+#ifndef UINT8_MAX
+#define UINT8_MAX              (255U)
+#endif
+#ifndef UINT16_MAX
+#define UINT16_MAX             (65535U)
+#endif
+#ifndef UINT32_MAX
+#define UINT32_MAX             (4294967295U)
+#endif
+
+#endif /* ! FLEXINT_H */
+
+#ifdef __cplusplus
+
+/* The "const" storage-class-modifier is valid. */
+#define YY_USE_CONST
+
+#else	/* ! __cplusplus */
+
+/* C99 requires __STDC__ to be defined as 1. */
+#if defined (__STDC__)
+
+#define YY_USE_CONST
+
+#endif	/* defined (__STDC__) */
+#endif	/* ! __cplusplus */
+
+#ifdef YY_USE_CONST
+#define yyconst const
+#else
+#define yyconst
+#endif
+
+/* Size of default input buffer. */
+#ifndef YY_BUF_SIZE
+#define YY_BUF_SIZE 16384
+#endif
+
+#ifndef YY_TYPEDEF_YY_BUFFER_STATE
+#define YY_TYPEDEF_YY_BUFFER_STATE
+typedef struct yy_buffer_state *YY_BUFFER_STATE;
+#endif
+
+extern int parse_events_leng;
+
+extern FILE *parse_events_in, *parse_events_out;
+
+#ifndef YY_TYPEDEF_YY_SIZE_T
+#define YY_TYPEDEF_YY_SIZE_T
+typedef size_t yy_size_t;
+#endif
+
+#ifndef YY_STRUCT_YY_BUFFER_STATE
+#define YY_STRUCT_YY_BUFFER_STATE
+struct yy_buffer_state
+	{
+	FILE *yy_input_file;
+
+	char *yy_ch_buf;		/* input buffer */
+	char *yy_buf_pos;		/* current position in input buffer */
+
+	/* Size of input buffer in bytes, not including room for EOB
+	 * characters.
+	 */
+	yy_size_t yy_buf_size;
+
+	/* Number of characters read into yy_ch_buf, not including EOB
+	 * characters.
+	 */
+	int yy_n_chars;
+
+	/* Whether we "own" the buffer - i.e., we know we created it,
+	 * and can realloc() it to grow it, and should free() it to
+	 * delete it.
+	 */
+	int yy_is_our_buffer;
+
+	/* Whether this is an "interactive" input source; if so, and
+	 * if we're using stdio for input, then we want to use getc()
+	 * instead of fread(), to make sure we stop fetching input after
+	 * each newline.
+	 */
+	int yy_is_interactive;
+
+	/* Whether we're considered to be at the beginning of a line.
+	 * If so, '^' rules will be active on the next match, otherwise
+	 * not.
+	 */
+	int yy_at_bol;
+
+    int yy_bs_lineno; /**< The line count. */
+    int yy_bs_column; /**< The column count. */
+    
+	/* Whether to try to fill the input buffer when we reach the
+	 * end of it.
+	 */
+	int yy_fill_buffer;
+
+	int yy_buffer_status;
+
+	};
+#endif /* !YY_STRUCT_YY_BUFFER_STATE */
+
+void parse_events_restart (FILE *input_file  );
+void parse_events__switch_to_buffer (YY_BUFFER_STATE new_buffer  );
+YY_BUFFER_STATE parse_events__create_buffer (FILE *file,int size  );
+void parse_events__delete_buffer (YY_BUFFER_STATE b  );
+void parse_events__flush_buffer (YY_BUFFER_STATE b  );
+void parse_events_push_buffer_state (YY_BUFFER_STATE new_buffer  );
+void parse_events_pop_buffer_state (void );
+
+YY_BUFFER_STATE parse_events__scan_buffer (char *base,yy_size_t size  );
+YY_BUFFER_STATE parse_events__scan_string (yyconst char *yy_str  );
+YY_BUFFER_STATE parse_events__scan_bytes (yyconst char *bytes,int len  );
+
+void *parse_events_alloc (yy_size_t  );
+void *parse_events_realloc (void *,yy_size_t  );
+void parse_events_free (void *  );
+
+/* Begin user sect3 */
+
+extern int parse_events_lineno;
+
+extern char *parse_events_text;
+#define yytext_ptr parse_events_text
+
+#ifdef YY_HEADER_EXPORT_START_CONDITIONS
+#define INITIAL 0
+
+#endif
+
+#ifndef YY_NO_UNISTD_H
+/* Special case for "unistd.h", since it is non-ANSI. We include it way
+ * down here because we want the user's section 1 to have been scanned first.
+ * The user has a chance to override it with an option.
+ */
+#include <unistd.h>
+#endif
+
+#ifndef YY_EXTRA_TYPE
+#define YY_EXTRA_TYPE void *
+#endif
+
+/* Accessor methods to globals.
+   These are made visible to non-reentrant scanners for convenience. */
+
+int parse_events_lex_destroy (void );
+
+int parse_events_get_debug (void );
+
+void parse_events_set_debug (int debug_flag  );
+
+YY_EXTRA_TYPE parse_events_get_extra (void );
+
+void parse_events_set_extra (YY_EXTRA_TYPE user_defined  );
+
+FILE *parse_events_get_in (void );
+
+void parse_events_set_in  (FILE * in_str  );
+
+FILE *parse_events_get_out (void );
+
+void parse_events_set_out  (FILE * out_str  );
+
+int parse_events_get_leng (void );
+
+char *parse_events_get_text (void );
+
+int parse_events_get_lineno (void );
+
+void parse_events_set_lineno (int line_number  );
+
+/* Macros after this point can all be overridden by user definitions in
+ * section 1.
+ */
+
+#ifndef YY_SKIP_YYWRAP
+#ifdef __cplusplus
+extern "C" int parse_events_wrap (void );
+#else
+extern int parse_events_wrap (void );
+#endif
+#endif
+
+#ifndef yytext_ptr
+static void yy_flex_strncpy (char *,yyconst char *,int );
+#endif
+
+#ifdef YY_NEED_STRLEN
+static int yy_flex_strlen (yyconst char * );
+#endif
+
+#ifndef YY_NO_INPUT
+
+#endif
+
+/* Amount of stuff to slurp up with each read. */
+#ifndef YY_READ_BUF_SIZE
+#define YY_READ_BUF_SIZE 8192
+#endif
+
+/* Number of entries by which start-condition stack grows. */
+#ifndef YY_START_STACK_INCR
+#define YY_START_STACK_INCR 25
+#endif
+
+/* Default declaration of generated scanner - a define so the user can
+ * easily add parameters.
+ */
+#ifndef YY_DECL
+#define YY_DECL_IS_OURS 1
+
+extern int parse_events_lex (void);
+
+#define YY_DECL int parse_events_lex (void)
+#endif /* !YY_DECL */
+
+/* yy_get_previous_state - get the state just before the EOB char was reached */
+
+#undef YY_NEW_FILE
+#undef YY_FLUSH_BUFFER
+#undef yy_set_bol
+#undef yy_new_buffer
+#undef yy_set_interactive
+#undef YY_DO_BEFORE_ACTION
+
+#ifdef YY_DECL_IS_OURS
+#undef YY_DECL_IS_OURS
+#undef YY_DECL
+#endif
+
+#line 102 "util/parse-events.l"
+
+
+#line 315 "util/parse-events-flex.h"
+#undef parse_events_IN_HEADER
+#endif /* parse_events_HEADER_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b029296..6e50b91 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -11,6 +11,9 @@
 #include "cache.h"
 #include "header.h"
 #include "debugfs.h"
+#include "parse-events-flex.h"
+
+#define MAX_NAME_LEN 100
 
 struct event_symbol {
 	u8		type;
@@ -19,11 +22,7 @@ struct event_symbol {
 	const char	*alias;
 };
 
-enum event_result {
-	EVT_FAILED,
-	EVT_HANDLED,
-	EVT_HANDLED_ALL
-};
+int parse_events_parse(struct list_head *list, int *idx);
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
@@ -354,7 +353,24 @@ const char *__event_name(int type, u64 config)
 	return "unknown";
 }
 
-static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int size)
+static int add_event(struct list_head *list, int *idx,
+		     struct perf_event_attr *attr, char *name)
+{
+	struct perf_evsel *evsel;
+
+	event_attr_init(attr);
+
+	evsel = perf_evsel__new(attr, (*idx)++);
+	if (!evsel)
+		return -ENOMEM;
+
+	list_add_tail(&evsel->node, list);
+
+	evsel->name = strdup(name);
+	return 0;
+}
+
+static int parse_aliases(char *str, const char *names[][MAX_ALIASES], int size)
 {
 	int i, j;
 	int n, longest = -1;
@@ -362,58 +378,57 @@ static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int
 	for (i = 0; i < size; i++) {
 		for (j = 0; j < MAX_ALIASES && names[i][j]; j++) {
 			n = strlen(names[i][j]);
-			if (n > longest && !strncasecmp(*str, names[i][j], n))
+			if (n > longest && !strncasecmp(str, names[i][j], n))
 				longest = n;
 		}
-		if (longest > 0) {
-			*str += longest;
+		if (longest > 0)
 			return i;
-		}
 	}
 
 	return -1;
 }
 
-static enum event_result
-parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
+int parse_events_add_cache(struct list_head *list, int *idx,
+			   char *type, char *op_result1, char *op_result2)
 {
-	const char *s = *str;
+	struct perf_event_attr attr;
+	char name[MAX_NAME_LEN];
 	int cache_type = -1, cache_op = -1, cache_result = -1;
+	char *op_result[2] = { op_result1, op_result2 };
+	int i, n;
 
-	cache_type = parse_aliases(&s, hw_cache, PERF_COUNT_HW_CACHE_MAX);
 	/*
 	 * No fallback - if we cannot get a clear cache type
 	 * then bail out:
 	 */
+	cache_type = parse_aliases(type, hw_cache,
+				   PERF_COUNT_HW_CACHE_MAX);
 	if (cache_type == -1)
-		return EVT_FAILED;
+		return -EINVAL;
+
+	n = snprintf(name, MAX_NAME_LEN, "%s", type);
 
-	while ((cache_op == -1 || cache_result == -1) && *s == '-') {
-		++s;
+	for (i = 0; (i < 2) && (op_result[i]); i++) {
+		char *str = op_result[i];
+
+		snprintf(name + n, MAX_NAME_LEN - n, "-%s\n", str);
 
 		if (cache_op == -1) {
-			cache_op = parse_aliases(&s, hw_cache_op,
-						PERF_COUNT_HW_CACHE_OP_MAX);
+			cache_op = parse_aliases(str, hw_cache_op,
+						 PERF_COUNT_HW_CACHE_OP_MAX);
 			if (cache_op >= 0) {
 				if (!is_cache_op_valid(cache_type, cache_op))
-					return EVT_FAILED;
+					return -EINVAL;
 				continue;
 			}
 		}
 
 		if (cache_result == -1) {
-			cache_result = parse_aliases(&s, hw_cache_result,
+			cache_result = parse_aliases(str, hw_cache_result,
 						PERF_COUNT_HW_CACHE_RESULT_MAX);
 			if (cache_result >= 0)
 				continue;
 		}
-
-		/*
-		 * Can't parse this as a cache op or result, so back up
-		 * to the '-'.
-		 */
-		--s;
-		break;
 	}
 
 	/*
@@ -428,20 +443,17 @@ parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
 	if (cache_result == -1)
 		cache_result = PERF_COUNT_HW_CACHE_RESULT_ACCESS;
 
-	attr->config = cache_type | (cache_op << 8) | (cache_result << 16);
-	attr->type = PERF_TYPE_HW_CACHE;
-
-	*str = s;
-	return EVT_HANDLED;
+	memset(&attr, 0, sizeof(attr));
+	attr.config = cache_type | (cache_op << 8) | (cache_result << 16);
+	attr.type = PERF_TYPE_HW_CACHE;
+	return add_event(list, idx, &attr, name);
 }
 
-static enum event_result
-parse_single_tracepoint_event(char *sys_name,
-			      const char *evt_name,
-			      unsigned int evt_length,
-			      struct perf_event_attr *attr,
-			      const char **strp)
+static int add_tracepoint(struct list_head *list, int *idx,
+			  char *sys_name, char *evt_name)
 {
+	struct perf_event_attr attr;
+	char name[MAX_NAME_LEN];
 	char evt_path[MAXPATHLEN];
 	char id_buf[4];
 	u64 id;
@@ -452,130 +464,80 @@ parse_single_tracepoint_event(char *sys_name,
 
 	fd = open(evt_path, O_RDONLY);
 	if (fd < 0)
-		return EVT_FAILED;
+		return -1;
 
 	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
 		close(fd);
-		return EVT_FAILED;
+		return -1;
 	}
 
 	close(fd);
 	id = atoll(id_buf);
-	attr->config = id;
-	attr->type = PERF_TYPE_TRACEPOINT;
-	*strp += strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
 
-	attr->sample_type |= PERF_SAMPLE_RAW;
-	attr->sample_type |= PERF_SAMPLE_TIME;
-	attr->sample_type |= PERF_SAMPLE_CPU;
+	memset(&attr, 0, sizeof(attr));
+	attr.config = id;
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.sample_type |= PERF_SAMPLE_RAW;
+	attr.sample_type |= PERF_SAMPLE_TIME;
+	attr.sample_type |= PERF_SAMPLE_CPU;
+	attr.sample_period = 1;
 
-	attr->sample_period = 1;
-
-
-	return EVT_HANDLED;
+	snprintf(name, MAX_NAME_LEN, "%s:%s", sys_name, evt_name);
+	return add_event(list, idx, &attr, name);
 }
 
-/* sys + ':' + event + ':' + flags*/
-#define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
-static enum event_result
-parse_multiple_tracepoint_event(struct perf_evlist *evlist, char *sys_name,
-				const char *evt_exp, char *flags)
+static int add_tracepoint_multi(struct list_head *list, int *idx,
+				char *sys_name, char *evt_name)
 {
 	char evt_path[MAXPATHLEN];
 	struct dirent *evt_ent;
 	DIR *evt_dir;
+	int ret = 0;
 
 	snprintf(evt_path, MAXPATHLEN, "%s/%s", tracing_events_path, sys_name);
 	evt_dir = opendir(evt_path);
-
 	if (!evt_dir) {
 		perror("Can't open event dir");
-		return EVT_FAILED;
+		return -1;
 	}
 
-	while ((evt_ent = readdir(evt_dir))) {
-		char event_opt[MAX_EVOPT_LEN + 1];
-		int len;
-
+	while (!ret && (evt_ent = readdir(evt_dir))) {
 		if (!strcmp(evt_ent->d_name, ".")
 		    || !strcmp(evt_ent->d_name, "..")
 		    || !strcmp(evt_ent->d_name, "enable")
 		    || !strcmp(evt_ent->d_name, "filter"))
 			continue;
 
-		if (!strglobmatch(evt_ent->d_name, evt_exp))
+		if (!strglobmatch(evt_ent->d_name, evt_name))
 			continue;
 
-		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s%s%s", sys_name,
-			       evt_ent->d_name, flags ? ":" : "",
-			       flags ?: "");
-		if (len < 0)
-			return EVT_FAILED;
-
-		if (parse_events(evlist, event_opt, 0))
-			return EVT_FAILED;
+		ret = add_tracepoint(list, idx, sys_name, evt_ent->d_name);
 	}
 
-	return EVT_HANDLED_ALL;
+	return ret;
 }
 
-static enum event_result
-parse_tracepoint_event(struct perf_evlist *evlist, const char **strp,
-		       struct perf_event_attr *attr)
+int parse_events_add_tracepoint(struct list_head *list, int *idx,
+				char *sys, char *event)
 {
-	const char *evt_name;
-	char *flags = NULL, *comma_loc;
-	char sys_name[MAX_EVENT_LENGTH];
-	unsigned int sys_length, evt_length;
-
-	if (debugfs_valid_mountpoint(tracing_events_path))
-		return 0;
+	int ret;
 
-	evt_name = strchr(*strp, ':');
-	if (!evt_name)
-		return EVT_FAILED;
+	ret = debugfs_valid_mountpoint(tracing_events_path);
+	if (ret)
+		return ret;
 
-	sys_length = evt_name - *strp;
-	if (sys_length >= MAX_EVENT_LENGTH)
-		return 0;
-
-	strncpy(sys_name, *strp, sys_length);
-	sys_name[sys_length] = '\0';
-	evt_name = evt_name + 1;
-
-	comma_loc = strchr(evt_name, ',');
-	if (comma_loc) {
-		/* take the event name up to the comma */
-		evt_name = strndup(evt_name, comma_loc - evt_name);
-	}
-	flags = strchr(evt_name, ':');
-	if (flags) {
-		/* split it out: */
-		evt_name = strndup(evt_name, flags - evt_name);
-		flags++;
-	}
-
-	evt_length = strlen(evt_name);
-	if (evt_length >= MAX_EVENT_LENGTH)
-		return EVT_FAILED;
-	if (strpbrk(evt_name, "*?")) {
-		*strp += strlen(sys_name) + evt_length + 1; /* 1 == the ':' */
-		return parse_multiple_tracepoint_event(evlist, sys_name,
-						       evt_name, flags);
-	} else {
-		return parse_single_tracepoint_event(sys_name, evt_name,
-						     evt_length, attr, strp);
-	}
+	return strpbrk(event, "*?") ?
+	       add_tracepoint_multi(list, idx, sys, event) :
+	       add_tracepoint(list, idx, sys, event);
 }
 
-static enum event_result
-parse_breakpoint_type(const char *type, const char **strp,
-		      struct perf_event_attr *attr)
+static int
+parse_breakpoint_type(const char *type, struct perf_event_attr *attr)
 {
 	int i;
 
 	for (i = 0; i < 3; i++) {
-		if (!type[i])
+		if (!type || !type[i])
 			break;
 
 		switch (type[i]) {
@@ -589,164 +551,65 @@ parse_breakpoint_type(const char *type, const char **strp,
 			attr->bp_type |= HW_BREAKPOINT_X;
 			break;
 		default:
-			return EVT_FAILED;
+			return -EINVAL;
 		}
 	}
+
 	if (!attr->bp_type) /* Default */
 		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
 
-	*strp = type + i;
-
-	return EVT_HANDLED;
+	return 0;
 }
 
-static enum event_result
-parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
+int parse_events_add_breakpoint(struct list_head *list, int *idx,
+				void *ptr, char *type)
 {
-	const char *target;
-	const char *type;
-	char *endaddr;
-	u64 addr;
-	enum event_result err;
-
-	target = strchr(*strp, ':');
-	if (!target)
-		return EVT_FAILED;
-
-	if (strncmp(*strp, "mem", target - *strp) != 0)
-		return EVT_FAILED;
-
-	target++;
-
-	addr = strtoull(target, &endaddr, 0);
-	if (target == endaddr)
-		return EVT_FAILED;
-
-	attr->bp_addr = addr;
-	*strp = endaddr;
+	struct perf_event_attr attr;
+	char name[MAX_NAME_LEN];
 
-	type = strchr(target, ':');
+	memset(&attr, 0, sizeof(attr));
+	attr.bp_addr = (u64) ptr;
 
-	/* If no type is defined, just rw as default */
-	if (!type) {
-		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
-	} else {
-		err = parse_breakpoint_type(++type, strp, attr);
-		if (err == EVT_FAILED)
-			return EVT_FAILED;
-	}
+	if (parse_breakpoint_type(type, &attr))
+		return -EINVAL;
 
 	/*
 	 * We should find a nice way to override the access length
 	 * Provide some defaults for now
 	 */
-	if (attr->bp_type == HW_BREAKPOINT_X)
-		attr->bp_len = sizeof(long);
+	if (attr.bp_type == HW_BREAKPOINT_X)
+		attr.bp_len = sizeof(long);
 	else
-		attr->bp_len = HW_BREAKPOINT_LEN_4;
-
-	attr->type = PERF_TYPE_BREAKPOINT;
-
-	return EVT_HANDLED;
-}
-
-static int check_events(const char *str, unsigned int i)
-{
-	int n;
-
-	n = strlen(event_symbols[i].symbol);
-	if (!strncasecmp(str, event_symbols[i].symbol, n))
-		return n;
+		attr.bp_len = HW_BREAKPOINT_LEN_4;
 
-	n = strlen(event_symbols[i].alias);
-	if (n) {
-		if (!strncasecmp(str, event_symbols[i].alias, n))
-			return n;
-	}
+	attr.type = PERF_TYPE_BREAKPOINT;
 
-	return 0;
+	snprintf(name, MAX_NAME_LEN, "mem:%p:%s", ptr, type ? type : "rw");
+	return add_event(list, idx, &attr, name);
 }
 
-static enum event_result
-parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
+int
+parse_events_add_numeric(struct list_head *list, int *idx,
+			 unsigned long type, unsigned long config)
 {
-	const char *str = *strp;
-	unsigned int i;
-	int n;
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		n = check_events(str, i);
-		if (n > 0) {
-			attr->type = event_symbols[i].type;
-			attr->config = event_symbols[i].config;
-			*strp = str + n;
-			return EVT_HANDLED;
-		}
-	}
-	return EVT_FAILED;
-}
+	struct perf_event_attr attr;
 
-static enum event_result
-parse_raw_event(const char **strp, struct perf_event_attr *attr)
-{
-	const char *str = *strp;
-	u64 config;
-	int n;
-
-	if (*str != 'r')
-		return EVT_FAILED;
-	n = hex2u64(str + 1, &config);
-	if (n > 0) {
-		const char *end = str + n + 1;
-		if (*end != '\0' && *end != ',' && *end != ':')
-			return EVT_FAILED;
-
-		*strp = end;
-		attr->type = PERF_TYPE_RAW;
-		attr->config = config;
-		return EVT_HANDLED;
-	}
-	return EVT_FAILED;
+	memset(&attr, 0, sizeof(attr));
+	attr.type = type;
+	attr.config = config;
+	return add_event(list, idx, &attr,
+			 (char *) __event_name(type, config));
 }
 
-static enum event_result
-parse_numeric_event(const char **strp, struct perf_event_attr *attr)
+int parse_events_modifier(struct list_head *list, char *str)
 {
-	const char *str = *strp;
-	char *endp;
-	unsigned long type;
-	u64 config;
-
-	type = strtoul(str, &endp, 0);
-	if (endp > str && type < PERF_TYPE_MAX && *endp == ':') {
-		str = endp + 1;
-		config = strtoul(str, &endp, 0);
-		if (endp > str) {
-			attr->type = type;
-			attr->config = config;
-			*strp = endp;
-			return EVT_HANDLED;
-		}
-	}
-	return EVT_FAILED;
-}
-
-static int
-parse_event_modifier(const char **strp, struct perf_event_attr *attr)
-{
-	const char *str = *strp;
+	struct perf_evsel *evsel;
 	int exclude = 0, exclude_GH = 0;
 	int eu = 0, ek = 0, eh = 0, eH = 0, eG = 0, precise = 0;
 
-	if (!*str)
+	if (str == NULL)
 		return 0;
 
-	if (*str == ',')
-		return 0;
-
-	if (*str++ != ':')
-		return -1;
-
 	while (*str) {
 		if (*str == 'u') {
 			if (!exclude)
@@ -775,111 +638,60 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 
 		++str;
 	}
-	if (str < *strp + 2)
-		return -1;
 
-	*strp = str;
+	/*
+	 * precise ip:
+	 *
+	 *  0 - SAMPLE_IP can have arbitrary skid
+	 *  1 - SAMPLE_IP must have constant skid
+	 *  2 - SAMPLE_IP requested to have 0 skid
+	 *  3 - SAMPLE_IP must have 0 skid
+	 *
+	 *  See also PERF_RECORD_MISC_EXACT_IP
+	 */
+	if (precise > 3)
+		return -EINVAL;
 
-	attr->exclude_user   = eu;
-	attr->exclude_kernel = ek;
-	attr->exclude_hv     = eh;
-	attr->precise_ip     = precise;
-	attr->exclude_host   = eH;
-	attr->exclude_guest  = eG;
+	list_for_each_entry(evsel, list, node) {
+		evsel->attr.exclude_user   = eu;
+		evsel->attr.exclude_kernel = ek;
+		evsel->attr.exclude_hv     = eh;
+		evsel->attr.precise_ip     = precise;
+		evsel->attr.exclude_host   = eH;
+		evsel->attr.exclude_guest  = eG;
+	}
 
 	return 0;
 }
 
-/*
- * Each event can have multiple symbolic names.
- * Symbolic names are (almost) exactly matched.
- */
-static enum event_result
-parse_event_symbols(struct perf_evlist *evlist, const char **str,
-		    struct perf_event_attr *attr)
+int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 {
-	enum event_result ret;
-
-	ret = parse_tracepoint_event(evlist, str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	struct perf_evsel *evsel, *h;
+	LIST_HEAD(list);
+	YY_BUFFER_STATE buffer;
+	int ret, idx = evlist->nr_entries;
 
-	ret = parse_raw_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	buffer = parse_events__scan_string(str);
 
-	ret = parse_numeric_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	ret = parse_events_parse(&list, &idx);
 
-	ret = parse_symbolic_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	parse_events__flush_buffer(buffer);
+	parse_events__delete_buffer(buffer);
 
-	ret = parse_generic_hw_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	if (!ret) {
+		int entries = idx - evlist->nr_entries;
+		perf_evlist__splice_list_tail(evlist, &list, entries);
+		return 0;
+	}
 
-	ret = parse_breakpoint_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
+	list_for_each_entry_safe(evsel, h, &list, node)
+		perf_evsel__delete(evsel);
 
-	fprintf(stderr, "invalid or unsupported event: '%s'\n", *str);
+	fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
 	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
-	return EVT_FAILED;
-
-modifier:
-	if (parse_event_modifier(str, attr) < 0) {
-		fprintf(stderr, "invalid event modifier: '%s'\n", *str);
-		fprintf(stderr, "Run 'perf list' for a list of valid events and modifiers\n");
-
-		return EVT_FAILED;
-	}
-
 	return ret;
 }
 
-int parse_events(struct perf_evlist *evlist , const char *str, int unset __used)
-{
-	struct perf_event_attr attr;
-	enum event_result ret;
-	const char *ostr;
-
-	for (;;) {
-		ostr = str;
-		memset(&attr, 0, sizeof(attr));
-		event_attr_init(&attr);
-		ret = parse_event_symbols(evlist, &str, &attr);
-		if (ret == EVT_FAILED)
-			return -1;
-
-		if (!(*str == 0 || *str == ',' || isspace(*str)))
-			return -1;
-
-		if (ret != EVT_HANDLED_ALL) {
-			struct perf_evsel *evsel;
-			evsel = perf_evsel__new(&attr, evlist->nr_entries);
-			if (evsel == NULL)
-				return -1;
-			perf_evlist__add(evlist, evsel);
-
-			evsel->name = calloc(str - ostr + 1, 1);
-			if (!evsel->name)
-				return -1;
-			strncpy(evsel->name, ostr, str - ostr);
-		}
-
-		if (*str == 0)
-			break;
-		if (*str == ',')
-			++str;
-		while (isspace(*str))
-			++str;
-	}
-
-	return 0;
-}
-
 int parse_events_option(const struct option *opt, const char *str,
 			int unset __used)
 {
@@ -1052,8 +864,6 @@ int print_hwcache_events(const char *event_glob)
 	return printed;
 }
 
-#define MAX_NAME_LEN 100
-
 /*
  * Print the help text for the event symbols:
  */
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 7e0cbe7..84d3771 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -33,6 +33,21 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
+int parse_events_modifier(struct list_head *list __used, char *str __used);
+int parse_events_add_tracepoint(struct list_head *list, int *idx,
+				char *sys, char *event);
+int parse_events_add_raw(struct perf_evlist *evlist, unsigned long config,
+			 unsigned long config1, unsigned long config2,
+			 char *mod);
+int parse_events_add_numeric(struct list_head *list, int *idx,
+			     unsigned long type, unsigned long config);
+int parse_events_add_cache(struct list_head *list, int *idx,
+			   char *type, char *op_result1, char *op_result2);
+int parse_events_add_breakpoint(struct list_head *list, int *idx,
+				void *ptr, char *type);
+void parse_events_error(struct list_head *list, int *idx,
+			char const *msg);
+
 void print_events(const char *event_glob);
 void print_events_type(u8 type);
 void print_tracepoint_events(const char *subsys_glob, const char *event_glob);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
new file mode 100644
index 0000000..44dbc35
--- /dev/null
+++ b/tools/perf/util/parse-events.l
@@ -0,0 +1,107 @@
+
+%option prefix="parse_events_"
+
+%{
+#include <errno.h>
+#include "../perf.h"
+#include "parse-events-bison.h"
+
+static int __value(char *str, int base, int token)
+{
+	long num;
+
+	errno = 0;
+	num = strtoul(str, NULL, base);
+	if (errno)
+		return PE_ERROR;
+
+	parse_events_lval.num = num;
+	return token;
+}
+
+static int value(int base)
+{
+	return __value(parse_events_text, base, PE_VALUE);
+}
+
+static int raw(void)
+{
+	return __value(parse_events_text + 1, 16, PE_RAW);
+}
+
+static int str(int token)
+{
+	parse_events_lval.str = strdup(parse_events_text);
+	return token;
+}
+
+static int sym(int type, int config)
+{
+	parse_events_lval.num = (type << 16) + config;
+	return PE_VALUE_SYM;
+}
+
+%}
+
+num_dec		[0-9]+
+num_hex		0x[a-fA-F0-9]+
+num_raw_hex	[a-fA-F0-9]+
+name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
+modifier_event	[ukhp]{1,5}
+modifier_bp	[rwx]
+
+%%
+cpu-cycles|cycles				{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
+stalled-cycles-frontend|idle-cycles-frontend	{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
+stalled-cycles-backend|idle-cycles-backend	{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
+instructions					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS); }
+cache-references				{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_REFERENCES); }
+cache-misses					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_MISSES); }
+branch-instructions|branches			{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_INSTRUCTIONS); }
+branch-misses					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES); }
+bus-cycles					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BUS_CYCLES); }
+cpu-clock					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_CLOCK); }
+task-clock					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK); }
+page-faults|faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS); }
+minor-faults					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MIN); }
+major-faults					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MAJ); }
+context-switches|cs				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CONTEXT_SWITCHES); }
+cpu-migrations|migrations			{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS); }
+alignment-faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_ALIGNMENT_FAULTS); }
+emulation-faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
+
+L1-dcache|l1-d|l1d|L1-data		|
+L1-icache|l1-i|l1i|L1-instruction	|
+LLC|L2					|
+dTLB|d-tlb|Data-TLB			|
+iTLB|i-tlb|Instruction-TLB		|
+branch|branches|bpu|btb|bpc		|
+node					{ return str(PE_NAME_CACHE_TYPE); }
+
+load|loads|read				|
+store|stores|write			|
+prefetch|prefetches			|
+speculative-read|speculative-load	|
+refs|Reference|ops|access		|
+misses|miss				{ return str(PE_NAME_CACHE_OP_RESULT); }
+
+mem:			{ return PE_PREFIX_MEM; }
+r{num_raw_hex}		{ return raw(); }
+{num_dec}		{ return value(10); }
+{num_hex}		{ return value(16); }
+
+{modifier_event}	{ return str(PE_MODIFIER_EVENT); }
+{modifier_bp}		{ return str(PE_MODIFIER_BP); }
+{name}			{ return str(PE_NAME); }
+"/"			{ return '/'; }
+-			{ return '-'; }
+,			{ return ','; }
+:			{ return ':'; }
+=			{ return '='; }
+
+%%
+
+int parse_events_wrap(void)
+{
+	return 1;
+}
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
new file mode 100644
index 0000000..4b4459e
--- /dev/null
+++ b/tools/perf/util/parse-events.y
@@ -0,0 +1,127 @@
+
+%name-prefix "parse_events_"
+%parse-param {struct list_head *list}
+%parse-param {int *idx}
+
+%{
+
+#define YYDEBUG 1
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+#include "types.h"
+#include "util.h"
+#include "parse-events.h"
+
+extern int parse_events_lex (void);
+
+#define ABORT_ON(val) \
+do { \
+	if (val) \
+		YYABORT; \
+} while (0)
+
+%}
+
+%token PE_VALUE PE_VALUE_SYM PE_RAW
+%token PE_NAME
+%token PE_MODIFIER_EVENT PE_MODIFIER_BP
+%token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
+%token PE_PREFIX_MEM PE_PREFIX_RAW
+%token PE_ERROR
+%type <num> PE_VALUE
+%type <num> PE_VALUE_SYM
+%type <num> PE_RAW
+%type <str> PE_NAME
+%type <str> PE_NAME_CACHE_TYPE
+%type <str> PE_NAME_CACHE_OP_RESULT
+%type <str> PE_MODIFIER_EVENT
+%type <str> PE_MODIFIER_BP
+
+%union
+{
+	char *str;
+	unsigned long num;
+}
+%%
+
+events:
+events ',' event | event
+
+event:
+event_def PE_MODIFIER_EVENT
+{
+	ABORT_ON(parse_events_modifier(list, $2));
+}
+|
+event_def
+
+event_def: event_legacy_symbol sep_dc |
+	   event_legacy_cache sep_dc |
+	   event_legacy_mem |
+	   event_legacy_tracepoint sep_dc |
+	   event_legacy_numeric sep_dc |
+	   event_legacy_raw sep_dc
+
+event_legacy_symbol:
+PE_VALUE_SYM
+{
+	int type = $1 >> 16;
+	int config = $1 & 255;
+
+	ABORT_ON(parse_events_add_numeric(list, idx, type, config));
+}
+
+event_legacy_cache:
+PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT
+{
+	ABORT_ON(parse_events_add_cache(list, idx, $1, $3, $5));
+}
+|
+PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT
+{
+	ABORT_ON(parse_events_add_cache(list, idx, $1, $3, NULL));
+}
+|
+PE_NAME_CACHE_TYPE
+{
+	ABORT_ON(parse_events_add_cache(list, idx, $1, NULL, NULL));
+}
+
+event_legacy_mem:
+PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
+{
+	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) $2, $4));
+}
+|
+PE_PREFIX_MEM PE_VALUE sep_dc
+{
+	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) $2, NULL));
+}
+
+event_legacy_tracepoint:
+PE_NAME ':' PE_NAME
+{
+	ABORT_ON(parse_events_add_tracepoint(list, idx, $1, $3));
+}
+
+event_legacy_numeric:
+PE_VALUE ':' PE_VALUE
+{
+	ABORT_ON(parse_events_add_numeric(list, idx, $1, $3));
+}
+
+event_legacy_raw:
+PE_RAW
+{
+	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, $1));
+}
+
+sep_dc: ':' |
+
+%%
+
+void parse_events_error(struct list_head *list __used, int *idx __used,
+			char const *msg __used)
+{
+}
-- 
1.7.4.4

