Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2BPMCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:02:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2BPMCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:02:08 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/8] perf, tool: Add perf pmu object to access pmu format definition
Date: Thu, 16 Feb 2012 13:00:51 +0100
Message-Id: <1329393652-6055-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
References: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding pmu object which provides interface to pmu's sysfs
event format definition located at:
  ${sysfs_mount}/bus/event_source/devices/${pmu}/format

Following interface is exported:
  struct perf_pmu* perf_pmu__find(char *name);
  - this function returns pmu object, which is then
    passed as a handle to other interface functions

  int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
                       struct list_head *head_terms);
  - this function configures perf_event_attr struct based
    on pmu's format definitions and config terms data,
    containined in head_terms list.

Parser generator is used to retrive the pmu's format definition.
The generated parser is part of the patch. Added makefile rule
'pmu-parser' to generate the parser code out of the bison/flex
sources.

Added builtin test 'Test perf pmu format parsing', which could
be run like:
	perf test pmu

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile         |   12 +
 tools/perf/builtin-test.c   |   10 +
 tools/perf/util/pmu-bison.c | 1663 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu-bison.h |   73 ++
 tools/perf/util/pmu-flex.c  | 1821 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu-flex.h  |  316 ++++++++
 tools/perf/util/pmu.c       |  469 +++++++++++
 tools/perf/util/pmu.h       |   41 +
 tools/perf/util/pmu.l       |   43 +
 tools/perf/util/pmu.y       |   93 +++
 10 files changed, 4541 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/pmu-bison.c
 create mode 100644 tools/perf/util/pmu-bison.h
 create mode 100644 tools/perf/util/pmu-flex.c
 create mode 100644 tools/perf/util/pmu-flex.h
 create mode 100644 tools/perf/util/pmu.c
 create mode 100644 tools/perf/util/pmu.h
 create mode 100644 tools/perf/util/pmu.l
 create mode 100644 tools/perf/util/pmu.y

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4e3b411..83a4a3a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -259,6 +259,7 @@ LIB_H += util/build-id.h
 LIB_H += util/debug.h
 LIB_H += util/debugfs.h
 LIB_H += util/sysfs.h
+LIB_H += util/pmu.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
 LIB_H += util/evlist.h
@@ -306,6 +307,7 @@ LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/sysfs.o
+LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/evlist.o
@@ -344,6 +346,8 @@ LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
 LIB_OBJS += $(OUTPUT)util/parse-events-flex.o
 LIB_OBJS += $(OUTPUT)util/parse-events-bison.o
+LIB_OBJS += $(OUTPUT)util/pmu-flex.o
+LIB_OBJS += $(OUTPUT)util/pmu-bison.o
 LIB_OBJS += $(OUTPUT)util/trace-event-read.o
 LIB_OBJS += $(OUTPUT)util/trace-event-info.o
 LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
@@ -752,6 +756,9 @@ $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/parse-events-flex.o: util/parse-events-flex.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
 
+$(OUTPUT)util/pmu-flex.o: util/pmu-flex.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
@@ -789,6 +796,7 @@ help:
 	@echo '  info		- make GNU info documentation (access with info <foo>)'
 	@echo '  pdf		- make pdf documentation'
 	@echo '  event-parser	- make event parser code'
+	@echo '  pmu-parser	- make pmu format parser code'
 	@echo '  TAGS		- use etags to make tag information for source browsing'
 	@echo '  tags		- use ctags to make tag information for source browsing'
 	@echo '  cscope	- use cscope to make interactive browsing database'
@@ -842,6 +850,10 @@ event-parser:
 	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o util/parse-events-bison.c
 	$(QUIET_FLEX)$(FLEX) --header-file=util/parse-events-flex.h -t util/parse-events.l > util/parse-events-flex.c
 
+pmu-parser:
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o util/pmu-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=util/pmu-flex.h -t util/pmu.l > util/pmu-flex.c
+
 ### Detect prefix changes
 TRACK_CFLAGS = $(subst ','\'',$(ALL_CFLAGS)):\
              $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index c994a9c..fc7172e 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -13,6 +13,7 @@
 #include "util/parse-events.h"
 #include "util/symbol.h"
 #include "util/thread_map.h"
+#include "util/pmu.h"
 #include "../../include/linux/hw_breakpoint.h"
 
 #include <sys/mman.h>
@@ -1487,6 +1488,11 @@ static int test__rdpmc(void)
 
 #endif
 
+static int test__perf_pmu(void)
+{
+	return perf_pmu__test();
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -1522,6 +1528,10 @@ static struct test {
 		.func = test__PERF_RECORD,
 	},
 	{
+		.desc = "Test perf pmu format parsing",
+		.func = test__perf_pmu,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/util/pmu-bison.c b/tools/perf/util/pmu-bison.c
new file mode 100644
index 0000000..343521e
--- /dev/null
+++ b/tools/perf/util/pmu-bison.c
@@ -0,0 +1,1663 @@
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
+#define yyparse         perf_pmu_parse
+#define yylex           perf_pmu_lex
+#define yyerror         perf_pmu_error
+#define yylval          perf_pmu_lval
+#define yychar          perf_pmu_char
+#define yydebug         perf_pmu_debug
+#define yynerrs         perf_pmu_nerrs
+
+
+/* Copy the first part of user declarations.  */
+
+/* Line 189 of yacc.c  */
+#line 6 "util/pmu.y"
+
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+#include <linux/bitmap.h>
+#include <string.h>
+#include "pmu.h"
+
+extern int perf_pmu_lex (void);
+
+#define ABORT_ON(val) \
+do { \
+        if (val) \
+                YYABORT; \
+} while (0)
+
+
+
+/* Line 189 of yacc.c  */
+#line 99 "util/pmu-bison.c"
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
+     PP_CONFIG = 258,
+     PP_CONFIG1 = 259,
+     PP_CONFIG2 = 260,
+     PP_VALUE = 261,
+     PP_ERROR = 262
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
+#line 31 "util/pmu.y"
+
+	unsigned long num;
+	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
+
+
+
+/* Line 214 of yacc.c  */
+#line 149 "util/pmu-bison.c"
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
+#line 161 "util/pmu-bison.c"
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
+#define YYFINAL  9
+/* YYLAST -- Last index in YYTABLE.  */
+#define YYLAST   17
+
+/* YYNTOKENS -- Number of terminals.  */
+#define YYNTOKENS  11
+/* YYNNTS -- Number of nonterminals.  */
+#define YYNNTS  5
+/* YYNRULES -- Number of rules.  */
+#define YYNRULES  10
+/* YYNRULES -- Number of states.  */
+#define YYNSTATES  20
+
+/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
+#define YYUNDEFTOK  2
+#define YYMAXUTOK   262
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
+       2,     2,     2,     2,     9,    10,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     8,     2,
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
+       5,     6,     7
+};
+
+#if YYDEBUG
+/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
+   YYRHS.  */
+static const yytype_uint8 yyprhs[] =
+{
+       0,     0,     3,     6,     8,    12,    16,    20,    24,    26,
+      30
+};
+
+/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
+static const yytype_int8 yyrhs[] =
+{
+      12,     0,    -1,    12,    13,    -1,    13,    -1,     3,     8,
+      14,    -1,     4,     8,    14,    -1,     5,     8,    14,    -1,
+      14,     9,    15,    -1,    15,    -1,     6,    10,     6,    -1,
+       6,    -1
+};
+
+/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
+static const yytype_uint8 yyrline[] =
+{
+       0,    39,    39,    41,    44,    51,    58,    66,    71,    77,
+      82
+};
+#endif
+
+#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
+/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
+   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
+static const char *const yytname[] =
+{
+  "$end", "error", "$undefined", "PP_CONFIG", "PP_CONFIG1", "PP_CONFIG2",
+  "PP_VALUE", "PP_ERROR", "':'", "','", "'-'", "$accept", "format",
+  "format_term", "bits", "bit_term", 0
+};
+#endif
+
+# ifdef YYPRINT
+/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
+   token YYLEX-NUM.  */
+static const yytype_uint16 yytoknum[] =
+{
+       0,   256,   257,   258,   259,   260,   261,   262,    58,    44,
+      45
+};
+# endif
+
+/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
+static const yytype_uint8 yyr1[] =
+{
+       0,    11,    12,    12,    13,    13,    13,    14,    14,    15,
+      15
+};
+
+/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
+static const yytype_uint8 yyr2[] =
+{
+       0,     2,     2,     1,     3,     3,     3,     3,     1,     3,
+       1
+};
+
+/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
+   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
+   means the default is an error.  */
+static const yytype_uint8 yydefact[] =
+{
+       0,     0,     0,     0,     0,     3,     0,     0,     0,     1,
+       2,    10,     4,     8,     5,     6,     0,     0,     9,     7
+};
+
+/* YYDEFGOTO[NTERM-NUM].  */
+static const yytype_int8 yydefgoto[] =
+{
+      -1,     4,     5,    12,    13
+};
+
+/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
+   STATE-NUM.  */
+#define YYPACT_NINF -7
+static const yytype_int8 yypact[] =
+{
+       3,     1,     2,     4,     0,    -7,     5,     5,     5,    -7,
+      -7,     6,     8,    -7,     8,     8,     7,     5,    -7,    -7
+};
+
+/* YYPGOTO[NTERM-NUM].  */
+static const yytype_int8 yypgoto[] =
+{
+      -7,    -7,    10,    -6,    -2
+};
+
+/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
+   positive, shift that token.  If negative, reduce the rule which
+   number is the opposite.  If zero, do what YYDEFACT says.
+   If YYTABLE_NINF, syntax error.  */
+#define YYTABLE_NINF -1
+static const yytype_uint8 yytable[] =
+{
+       9,    14,    15,     1,     2,     3,     1,     2,     3,     6,
+       7,    11,     8,    18,    10,    19,    16,    17
+};
+
+static const yytype_uint8 yycheck[] =
+{
+       0,     7,     8,     3,     4,     5,     3,     4,     5,     8,
+       8,     6,     8,     6,     4,    17,    10,     9
+};
+
+/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
+   symbol of state STATE-NUM.  */
+static const yytype_uint8 yystos[] =
+{
+       0,     3,     4,     5,    12,    13,     8,     8,     8,     0,
+      13,     6,    14,    15,    14,    14,    10,     9,     6,    15
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
+      yyerror (format, name, YY_("syntax error: cannot back up")); \
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
+		  Type, Value, format, name); \
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
+yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct list_head *format, char *name)
+#else
+static void
+yy_symbol_value_print (yyoutput, yytype, yyvaluep, format, name)
+    FILE *yyoutput;
+    int yytype;
+    YYSTYPE const * const yyvaluep;
+    struct list_head *format;
+    char *name;
+#endif
+{
+  if (!yyvaluep)
+    return;
+  YYUSE (format);
+  YYUSE (name);
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
+yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct list_head *format, char *name)
+#else
+static void
+yy_symbol_print (yyoutput, yytype, yyvaluep, format, name)
+    FILE *yyoutput;
+    int yytype;
+    YYSTYPE const * const yyvaluep;
+    struct list_head *format;
+    char *name;
+#endif
+{
+  if (yytype < YYNTOKENS)
+    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
+  else
+    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);
+
+  yy_symbol_value_print (yyoutput, yytype, yyvaluep, format, name);
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
+yy_reduce_print (YYSTYPE *yyvsp, int yyrule, struct list_head *format, char *name)
+#else
+static void
+yy_reduce_print (yyvsp, yyrule, format, name)
+    YYSTYPE *yyvsp;
+    int yyrule;
+    struct list_head *format;
+    char *name;
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
+		       		       , format, name);
+      YYFPRINTF (stderr, "\n");
+    }
+}
+
+# define YY_REDUCE_PRINT(Rule)		\
+do {					\
+  if (yydebug)				\
+    yy_reduce_print (yyvsp, Rule, format, name); \
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
+yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, struct list_head *format, char *name)
+#else
+static void
+yydestruct (yymsg, yytype, yyvaluep, format, name)
+    const char *yymsg;
+    int yytype;
+    YYSTYPE *yyvaluep;
+    struct list_head *format;
+    char *name;
+#endif
+{
+  YYUSE (yyvaluep);
+  YYUSE (format);
+  YYUSE (name);
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
+int yyparse (struct list_head *format, char *name);
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
+yyparse (struct list_head *format, char *name)
+#else
+int
+yyparse (format, name)
+    struct list_head *format;
+    char *name;
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
+#line 45 "util/pmu.y"
+    {
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_CONFIG,
+				      (yyvsp[(3) - (3)].bits)));
+;}
+    break;
+
+  case 5:
+
+/* Line 1464 of yacc.c  */
+#line 52 "util/pmu.y"
+    {
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_CONFIG1,
+				      (yyvsp[(3) - (3)].bits)));
+;}
+    break;
+
+  case 6:
+
+/* Line 1464 of yacc.c  */
+#line 59 "util/pmu.y"
+    {
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_CONFIG2,
+				      (yyvsp[(3) - (3)].bits)));
+;}
+    break;
+
+  case 7:
+
+/* Line 1464 of yacc.c  */
+#line 67 "util/pmu.y"
+    {
+	bitmap_or((yyval.bits), (yyvsp[(1) - (3)].bits), (yyvsp[(3) - (3)].bits), 64);
+;}
+    break;
+
+  case 8:
+
+/* Line 1464 of yacc.c  */
+#line 72 "util/pmu.y"
+    {
+	memcpy((yyval.bits), (yyvsp[(1) - (1)].bits), sizeof((yyvsp[(1) - (1)].bits)));
+;}
+    break;
+
+  case 9:
+
+/* Line 1464 of yacc.c  */
+#line 78 "util/pmu.y"
+    {
+	perf_pmu__set_format((yyval.bits), (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num));
+;}
+    break;
+
+  case 10:
+
+/* Line 1464 of yacc.c  */
+#line 83 "util/pmu.y"
+    {
+	perf_pmu__set_format((yyval.bits), (yyvsp[(1) - (1)].num), 0);
+;}
+    break;
+
+
+
+/* Line 1464 of yacc.c  */
+#line 1444 "util/pmu-bison.c"
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
+      yyerror (format, name, YY_("syntax error"));
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
+	    yyerror (format, name, yymsg);
+	  }
+	else
+	  {
+	    yyerror (format, name, YY_("syntax error"));
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
+		      yytoken, &yylval, format, name);
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
+		  yystos[yystate], yyvsp, format, name);
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
+  yyerror (format, name, YY_("memory exhausted"));
+  yyresult = 2;
+  /* Fall through.  */
+#endif
+
+yyreturn:
+  if (yychar != YYEMPTY)
+     yydestruct ("Cleanup: discarding lookahead",
+		 yytoken, &yylval, format, name);
+  /* Do not reclaim the symbols of the rule which action triggered
+     this YYABORT or YYACCEPT.  */
+  YYPOPSTACK (yylen);
+  YY_STACK_PRINT (yyss, yyssp);
+  while (yyssp != yyss)
+    {
+      yydestruct ("Cleanup: popping",
+		  yystos[*yyssp], yyvsp, format, name);
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
+#line 87 "util/pmu.y"
+
+
+void perf_pmu_error(struct list_head *list __used,
+		    char *name __used,
+		    char const *msg __used)
+{
+}
+
diff --git a/tools/perf/util/pmu-bison.h b/tools/perf/util/pmu-bison.h
new file mode 100644
index 0000000..54f4a0d
--- /dev/null
+++ b/tools/perf/util/pmu-bison.h
@@ -0,0 +1,73 @@
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
+     PP_CONFIG = 258,
+     PP_CONFIG1 = 259,
+     PP_CONFIG2 = 260,
+     PP_VALUE = 261,
+     PP_ERROR = 262
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
+#line 31 "util/pmu.y"
+
+	unsigned long num;
+	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
+
+
+
+/* Line 1685 of yacc.c  */
+#line 65 "util/pmu-bison.h"
+} YYSTYPE;
+# define YYSTYPE_IS_TRIVIAL 1
+# define yystype YYSTYPE /* obsolescent; will be withdrawn */
+# define YYSTYPE_IS_DECLARED 1
+#endif
+
+extern YYSTYPE perf_pmu_lval;
+
+
diff --git a/tools/perf/util/pmu-flex.c b/tools/perf/util/pmu-flex.c
new file mode 100644
index 0000000..5a8c159
--- /dev/null
+++ b/tools/perf/util/pmu-flex.c
@@ -0,0 +1,1821 @@
+
+#line 3 "<stdout>"
+
+#define  YY_INT_ALIGNED short int
+
+/* A lexical scanner generated by flex */
+
+#define yy_create_buffer perf_pmu__create_buffer
+#define yy_delete_buffer perf_pmu__delete_buffer
+#define yy_flex_debug perf_pmu__flex_debug
+#define yy_init_buffer perf_pmu__init_buffer
+#define yy_flush_buffer perf_pmu__flush_buffer
+#define yy_load_buffer_state perf_pmu__load_buffer_state
+#define yy_switch_to_buffer perf_pmu__switch_to_buffer
+#define yyin perf_pmu_in
+#define yyleng perf_pmu_leng
+#define yylex perf_pmu_lex
+#define yylineno perf_pmu_lineno
+#define yyout perf_pmu_out
+#define yyrestart perf_pmu_restart
+#define yytext perf_pmu_text
+#define yywrap perf_pmu_wrap
+#define yyalloc perf_pmu_alloc
+#define yyrealloc perf_pmu_realloc
+#define yyfree perf_pmu_free
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
+#define YY_NEW_FILE perf_pmu_restart(perf_pmu_in  )
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
+extern int perf_pmu_leng;
+
+extern FILE *perf_pmu_in, *perf_pmu_out;
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
+		/* Undo effects of setting up perf_pmu_text. */ \
+        int yyless_macro_arg = (n); \
+        YY_LESS_LINENO(yyless_macro_arg);\
+		*yy_cp = (yy_hold_char); \
+		YY_RESTORE_YY_MORE_OFFSET \
+		(yy_c_buf_p) = yy_cp = yy_bp + yyless_macro_arg - YY_MORE_ADJ; \
+		YY_DO_BEFORE_ACTION; /* set up perf_pmu_text again */ \
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
+	 * (via perf_pmu_restart()), so that the user can continue scanning by
+	 * just pointing perf_pmu_in at a new input file.
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
+/* yy_hold_char holds the character lost when perf_pmu_text is formed. */
+static char yy_hold_char;
+static int yy_n_chars;		/* number of characters read into yy_ch_buf */
+int perf_pmu_leng;
+
+/* Points to current character in buffer. */
+static char *yy_c_buf_p = (char *) 0;
+static int yy_init = 0;		/* whether we need to initialize */
+static int yy_start = 0;	/* start state number */
+
+/* Flag which is used to allow perf_pmu_wrap()'s to do buffer switches
+ * instead of setting up a fresh perf_pmu_in.  A bit of a hack ...
+ */
+static int yy_did_buffer_switch_on_eof;
+
+void perf_pmu_restart (FILE *input_file  );
+void perf_pmu__switch_to_buffer (YY_BUFFER_STATE new_buffer  );
+YY_BUFFER_STATE perf_pmu__create_buffer (FILE *file,int size  );
+void perf_pmu__delete_buffer (YY_BUFFER_STATE b  );
+void perf_pmu__flush_buffer (YY_BUFFER_STATE b  );
+void perf_pmu_push_buffer_state (YY_BUFFER_STATE new_buffer  );
+void perf_pmu_pop_buffer_state (void );
+
+static void perf_pmu_ensure_buffer_stack (void );
+static void perf_pmu__load_buffer_state (void );
+static void perf_pmu__init_buffer (YY_BUFFER_STATE b,FILE *file  );
+
+#define YY_FLUSH_BUFFER perf_pmu__flush_buffer(YY_CURRENT_BUFFER )
+
+YY_BUFFER_STATE perf_pmu__scan_buffer (char *base,yy_size_t size  );
+YY_BUFFER_STATE perf_pmu__scan_string (yyconst char *yy_str  );
+YY_BUFFER_STATE perf_pmu__scan_bytes (yyconst char *bytes,int len  );
+
+void *perf_pmu_alloc (yy_size_t  );
+void *perf_pmu_realloc (void *,yy_size_t  );
+void perf_pmu_free (void *  );
+
+#define yy_new_buffer perf_pmu__create_buffer
+
+#define yy_set_interactive(is_interactive) \
+	{ \
+	if ( ! YY_CURRENT_BUFFER ){ \
+        perf_pmu_ensure_buffer_stack (); \
+		YY_CURRENT_BUFFER_LVALUE =    \
+            perf_pmu__create_buffer(perf_pmu_in,YY_BUF_SIZE ); \
+	} \
+	YY_CURRENT_BUFFER_LVALUE->yy_is_interactive = is_interactive; \
+	}
+
+#define yy_set_bol(at_bol) \
+	{ \
+	if ( ! YY_CURRENT_BUFFER ){\
+        perf_pmu_ensure_buffer_stack (); \
+		YY_CURRENT_BUFFER_LVALUE =    \
+            perf_pmu__create_buffer(perf_pmu_in,YY_BUF_SIZE ); \
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
+FILE *perf_pmu_in = (FILE *) 0, *perf_pmu_out = (FILE *) 0;
+
+typedef int yy_state_type;
+
+extern int perf_pmu_lineno;
+
+int perf_pmu_lineno = 1;
+
+extern char *perf_pmu_text;
+#define yytext_ptr perf_pmu_text
+
+static yy_state_type yy_get_previous_state (void );
+static yy_state_type yy_try_NUL_trans (yy_state_type current_state  );
+static int yy_get_next_buffer (void );
+static void yy_fatal_error (yyconst char msg[]  );
+
+/* Done after the current pattern has been matched and before the
+ * corresponding action - sets up perf_pmu_text.
+ */
+#define YY_DO_BEFORE_ACTION \
+	(yytext_ptr) = yy_bp; \
+	perf_pmu_leng = (size_t) (yy_cp - yy_bp); \
+	(yy_hold_char) = *yy_cp; \
+	*yy_cp = '\0'; \
+	(yy_c_buf_p) = yy_cp;
+
+#define YY_NUM_RULES 10
+#define YY_END_OF_BUFFER 11
+/* This struct is not used in this scanner,
+   but its presence is necessary. */
+struct yy_trans_info
+	{
+	flex_int32_t yy_verify;
+	flex_int32_t yy_nxt;
+	};
+static yyconst flex_int16_t yy_accept[20] =
+    {   0,
+        0,    0,   11,    8,    9,    7,    5,    1,    6,    8,
+        1,    0,    0,    0,    0,    2,    3,    4,    0
+    } ;
+
+static yyconst flex_int32_t yy_ec[256] =
+    {   0,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    2,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    3,    4,    1,    1,    5,    6,    7,
+        5,    5,    5,    5,    5,    5,    5,    8,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    9,    1,
+
+        1,   10,   11,    1,   12,    1,    1,    1,    1,   13,
+       14,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
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
+static yyconst flex_int32_t yy_meta[15] =
+    {   0,
+        1,    1,    1,    1,    2,    2,    2,    1,    1,    1,
+        1,    1,    1,    1
+    } ;
+
+static yyconst flex_int16_t yy_base[21] =
+    {   0,
+        0,    0,   23,   24,   24,   24,   24,    0,   24,    8,
+        0,    8,   10,    7,    7,    9,   24,   24,   24,   15
+    } ;
+
+static yyconst flex_int16_t yy_def[21] =
+    {   0,
+       19,    1,   19,   19,   19,   19,   19,   20,   19,   19,
+       20,   19,   19,   19,   19,   19,   19,   19,    0,   19
+    } ;
+
+static yyconst flex_int16_t yy_nxt[39] =
+    {   0,
+        4,    5,    6,    7,    8,    8,    8,    9,   10,    4,
+        4,    4,    4,    4,   17,   18,   11,   16,   15,   14,
+       13,   12,   19,    3,   19,   19,   19,   19,   19,   19,
+       19,   19,   19,   19,   19,   19,   19,   19
+    } ;
+
+static yyconst flex_int16_t yy_chk[39] =
+    {   0,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,   16,   16,   20,   15,   14,   13,
+       12,   10,    3,   19,   19,   19,   19,   19,   19,   19,
+       19,   19,   19,   19,   19,   19,   19,   19
+    } ;
+
+static yy_state_type yy_last_accepting_state;
+static char *yy_last_accepting_cpos;
+
+extern int perf_pmu__flex_debug;
+int perf_pmu__flex_debug = 0;
+
+/* The intent behind this definition is that it'll catch
+ * any uses of REJECT which flex missed.
+ */
+#define REJECT reject_used_but_not_detected
+#define yymore() yymore_used_but_not_detected
+#define YY_MORE_ADJ 0
+#define YY_RESTORE_YY_MORE_OFFSET
+char *perf_pmu_text;
+#line 1 "util/pmu.l"
+#line 4 "util/pmu.l"
+#include <stdlib.h>
+#include <linux/bitops.h>
+#include "pmu.h"
+#include "pmu-bison.h"
+
+static int value(int base)
+{
+	long num;
+
+	errno = 0;
+	num = strtoul(perf_pmu_text, NULL, base);
+	if (errno)
+		return PP_ERROR;
+
+	perf_pmu_lval.num = num;
+	return PP_VALUE;
+}
+
+#line 497 "<stdout>"
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
+int perf_pmu_lex_destroy (void );
+
+int perf_pmu_get_debug (void );
+
+void perf_pmu_set_debug (int debug_flag  );
+
+YY_EXTRA_TYPE perf_pmu_get_extra (void );
+
+void perf_pmu_set_extra (YY_EXTRA_TYPE user_defined  );
+
+FILE *perf_pmu_get_in (void );
+
+void perf_pmu_set_in  (FILE * in_str  );
+
+FILE *perf_pmu_get_out (void );
+
+void perf_pmu_set_out  (FILE * out_str  );
+
+int perf_pmu_get_leng (void );
+
+char *perf_pmu_get_text (void );
+
+int perf_pmu_get_lineno (void );
+
+void perf_pmu_set_lineno (int line_number  );
+
+/* Macros after this point can all be overridden by user definitions in
+ * section 1.
+ */
+
+#ifndef YY_SKIP_YYWRAP
+#ifdef __cplusplus
+extern "C" int perf_pmu_wrap (void );
+#else
+extern int perf_pmu_wrap (void );
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
+#define ECHO do { if (fwrite( perf_pmu_text, perf_pmu_leng, 1, perf_pmu_out )) {} } while (0)
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
+			     (c = getc( perf_pmu_in )) != EOF && c != '\n'; ++n ) \
+			buf[n] = (char) c; \
+		if ( c == '\n' ) \
+			buf[n++] = (char) c; \
+		if ( c == EOF && ferror( perf_pmu_in ) ) \
+			YY_FATAL_ERROR( "input in flex scanner failed" ); \
+		result = n; \
+		} \
+	else \
+		{ \
+		errno=0; \
+		while ( (result = fread(buf, 1, max_size, perf_pmu_in))==0 && ferror(perf_pmu_in)) \
+			{ \
+			if( errno != EINTR) \
+				{ \
+				YY_FATAL_ERROR( "input in flex scanner failed" ); \
+				break; \
+				} \
+			errno=0; \
+			clearerr(perf_pmu_in); \
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
+extern int perf_pmu_lex (void);
+
+#define YY_DECL int perf_pmu_lex (void)
+#endif /* !YY_DECL */
+
+/* Code executed at the beginning of each rule, after perf_pmu_text and perf_pmu_leng
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
+#line 26 "util/pmu.l"
+
+
+#line 682 "<stdout>"
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
+		if ( ! perf_pmu_in )
+			perf_pmu_in = stdin;
+
+		if ( ! perf_pmu_out )
+			perf_pmu_out = stdout;
+
+		if ( ! YY_CURRENT_BUFFER ) {
+			perf_pmu_ensure_buffer_stack ();
+			YY_CURRENT_BUFFER_LVALUE =
+				perf_pmu__create_buffer(perf_pmu_in,YY_BUF_SIZE );
+		}
+
+		perf_pmu__load_buffer_state( );
+		}
+
+	while ( 1 )		/* loops until end-of-file is reached */
+		{
+		yy_cp = (yy_c_buf_p);
+
+		/* Support of perf_pmu_text. */
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
+				if ( yy_current_state >= 20 )
+					yy_c = yy_meta[(unsigned int) yy_c];
+				}
+			yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
+			++yy_cp;
+			}
+		while ( yy_base[yy_current_state] != 24 );
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
+#line 28 "util/pmu.l"
+{ return value(10); }
+	YY_BREAK
+case 2:
+YY_RULE_SETUP
+#line 29 "util/pmu.l"
+{ return PP_CONFIG; }
+	YY_BREAK
+case 3:
+YY_RULE_SETUP
+#line 30 "util/pmu.l"
+{ return PP_CONFIG1; }
+	YY_BREAK
+case 4:
+YY_RULE_SETUP
+#line 31 "util/pmu.l"
+{ return PP_CONFIG2; }
+	YY_BREAK
+case 5:
+YY_RULE_SETUP
+#line 32 "util/pmu.l"
+{ return '-'; }
+	YY_BREAK
+case 6:
+YY_RULE_SETUP
+#line 33 "util/pmu.l"
+{ return ':'; }
+	YY_BREAK
+case 7:
+YY_RULE_SETUP
+#line 34 "util/pmu.l"
+{ return ','; }
+	YY_BREAK
+case 8:
+YY_RULE_SETUP
+#line 35 "util/pmu.l"
+{ ; }
+	YY_BREAK
+case 9:
+/* rule 9 can match eol */
+YY_RULE_SETUP
+#line 36 "util/pmu.l"
+{ ; }
+	YY_BREAK
+case 10:
+YY_RULE_SETUP
+#line 38 "util/pmu.l"
+ECHO;
+	YY_BREAK
+#line 816 "<stdout>"
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
+			 * just pointed perf_pmu_in at a new source and called
+			 * perf_pmu_lex().  If so, then we have to assure
+			 * consistency between YY_CURRENT_BUFFER and our
+			 * globals.  Here is the right place to do so, because
+			 * this is the first action (other than possibly a
+			 * back-up) that will match for the new input source.
+			 */
+			(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
+			YY_CURRENT_BUFFER_LVALUE->yy_input_file = perf_pmu_in;
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
+				if ( perf_pmu_wrap( ) )
+					{
+					/* Note: because we've taken care in
+					 * yy_get_next_buffer() to have set up
+					 * perf_pmu_text, we can now set up
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
+} /* end of perf_pmu_lex */
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
+					perf_pmu_realloc((void *) b->yy_ch_buf,b->yy_buf_size + 2  );
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
+			perf_pmu_restart(perf_pmu_in  );
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
+		YY_CURRENT_BUFFER_LVALUE->yy_ch_buf = (char *) perf_pmu_realloc((void *) YY_CURRENT_BUFFER_LVALUE->yy_ch_buf,new_size  );
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
+			if ( yy_current_state >= 20 )
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
+		if ( yy_current_state >= 20 )
+			yy_c = yy_meta[(unsigned int) yy_c];
+		}
+	yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
+	yy_is_jam = (yy_current_state == 19);
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
+	/* undo effects of setting up perf_pmu_text */
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
+					perf_pmu_restart(perf_pmu_in );
+
+					/*FALLTHROUGH*/
+
+				case EOB_ACT_END_OF_FILE:
+					{
+					if ( perf_pmu_wrap( ) )
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
+	*(yy_c_buf_p) = '\0';	/* preserve perf_pmu_text */
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
+    void perf_pmu_restart  (FILE * input_file )
+{
+    
+	if ( ! YY_CURRENT_BUFFER ){
+        perf_pmu_ensure_buffer_stack ();
+		YY_CURRENT_BUFFER_LVALUE =
+            perf_pmu__create_buffer(perf_pmu_in,YY_BUF_SIZE );
+	}
+
+	perf_pmu__init_buffer(YY_CURRENT_BUFFER,input_file );
+	perf_pmu__load_buffer_state( );
+}
+
+/** Switch to a different input buffer.
+ * @param new_buffer The new input buffer.
+ * 
+ */
+    void perf_pmu__switch_to_buffer  (YY_BUFFER_STATE  new_buffer )
+{
+    
+	/* TODO. We should be able to replace this entire function body
+	 * with
+	 *		perf_pmu_pop_buffer_state();
+	 *		perf_pmu_push_buffer_state(new_buffer);
+     */
+	perf_pmu_ensure_buffer_stack ();
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
+	perf_pmu__load_buffer_state( );
+
+	/* We don't actually know whether we did this switch during
+	 * EOF (perf_pmu_wrap()) processing, but the only time this flag
+	 * is looked at is after perf_pmu_wrap() is called, so it's safe
+	 * to go ahead and always set it.
+	 */
+	(yy_did_buffer_switch_on_eof) = 1;
+}
+
+static void perf_pmu__load_buffer_state  (void)
+{
+    	(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
+	(yytext_ptr) = (yy_c_buf_p) = YY_CURRENT_BUFFER_LVALUE->yy_buf_pos;
+	perf_pmu_in = YY_CURRENT_BUFFER_LVALUE->yy_input_file;
+	(yy_hold_char) = *(yy_c_buf_p);
+}
+
+/** Allocate and initialize an input buffer state.
+ * @param file A readable stream.
+ * @param size The character buffer size in bytes. When in doubt, use @c YY_BUF_SIZE.
+ * 
+ * @return the allocated buffer state.
+ */
+    YY_BUFFER_STATE perf_pmu__create_buffer  (FILE * file, int  size )
+{
+	YY_BUFFER_STATE b;
+    
+	b = (YY_BUFFER_STATE) perf_pmu_alloc(sizeof( struct yy_buffer_state )  );
+	if ( ! b )
+		YY_FATAL_ERROR( "out of dynamic memory in perf_pmu__create_buffer()" );
+
+	b->yy_buf_size = size;
+
+	/* yy_ch_buf has to be 2 characters longer than the size given because
+	 * we need to put in 2 end-of-buffer characters.
+	 */
+	b->yy_ch_buf = (char *) perf_pmu_alloc(b->yy_buf_size + 2  );
+	if ( ! b->yy_ch_buf )
+		YY_FATAL_ERROR( "out of dynamic memory in perf_pmu__create_buffer()" );
+
+	b->yy_is_our_buffer = 1;
+
+	perf_pmu__init_buffer(b,file );
+
+	return b;
+}
+
+/** Destroy the buffer.
+ * @param b a buffer created with perf_pmu__create_buffer()
+ * 
+ */
+    void perf_pmu__delete_buffer (YY_BUFFER_STATE  b )
+{
+    
+	if ( ! b )
+		return;
+
+	if ( b == YY_CURRENT_BUFFER ) /* Not sure if we should pop here. */
+		YY_CURRENT_BUFFER_LVALUE = (YY_BUFFER_STATE) 0;
+
+	if ( b->yy_is_our_buffer )
+		perf_pmu_free((void *) b->yy_ch_buf  );
+
+	perf_pmu_free((void *) b  );
+}
+
+#ifndef __cplusplus
+extern int isatty (int );
+#endif /* __cplusplus */
+    
+/* Initializes or reinitializes a buffer.
+ * This function is sometimes called more than once on the same buffer,
+ * such as during a perf_pmu_restart() or at EOF.
+ */
+    static void perf_pmu__init_buffer  (YY_BUFFER_STATE  b, FILE * file )
+
+{
+	int oerrno = errno;
+    
+	perf_pmu__flush_buffer(b );
+
+	b->yy_input_file = file;
+	b->yy_fill_buffer = 1;
+
+    /* If b is the current buffer, then perf_pmu__init_buffer was _probably_
+     * called from perf_pmu_restart() or through yy_get_next_buffer.
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
+    void perf_pmu__flush_buffer (YY_BUFFER_STATE  b )
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
+		perf_pmu__load_buffer_state( );
+}
+
+/** Pushes the new state onto the stack. The new state becomes
+ *  the current state. This function will allocate the stack
+ *  if necessary.
+ *  @param new_buffer The new state.
+ *  
+ */
+void perf_pmu_push_buffer_state (YY_BUFFER_STATE new_buffer )
+{
+    	if (new_buffer == NULL)
+		return;
+
+	perf_pmu_ensure_buffer_stack();
+
+	/* This block is copied from perf_pmu__switch_to_buffer. */
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
+	/* copied from perf_pmu__switch_to_buffer. */
+	perf_pmu__load_buffer_state( );
+	(yy_did_buffer_switch_on_eof) = 1;
+}
+
+/** Removes and deletes the top of the stack, if present.
+ *  The next element becomes the new top.
+ *  
+ */
+void perf_pmu_pop_buffer_state (void)
+{
+    	if (!YY_CURRENT_BUFFER)
+		return;
+
+	perf_pmu__delete_buffer(YY_CURRENT_BUFFER );
+	YY_CURRENT_BUFFER_LVALUE = NULL;
+	if ((yy_buffer_stack_top) > 0)
+		--(yy_buffer_stack_top);
+
+	if (YY_CURRENT_BUFFER) {
+		perf_pmu__load_buffer_state( );
+		(yy_did_buffer_switch_on_eof) = 1;
+	}
+}
+
+/* Allocates the stack if it does not exist.
+ *  Guarantees space for at least one push.
+ */
+static void perf_pmu_ensure_buffer_stack (void)
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
+		(yy_buffer_stack) = (struct yy_buffer_state**)perf_pmu_alloc
+								(num_to_alloc * sizeof(struct yy_buffer_state*)
+								);
+		if ( ! (yy_buffer_stack) )
+			YY_FATAL_ERROR( "out of dynamic memory in perf_pmu_ensure_buffer_stack()" );
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
+		(yy_buffer_stack) = (struct yy_buffer_state**)perf_pmu_realloc
+								((yy_buffer_stack),
+								num_to_alloc * sizeof(struct yy_buffer_state*)
+								);
+		if ( ! (yy_buffer_stack) )
+			YY_FATAL_ERROR( "out of dynamic memory in perf_pmu_ensure_buffer_stack()" );
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
+YY_BUFFER_STATE perf_pmu__scan_buffer  (char * base, yy_size_t  size )
+{
+	YY_BUFFER_STATE b;
+    
+	if ( size < 2 ||
+	     base[size-2] != YY_END_OF_BUFFER_CHAR ||
+	     base[size-1] != YY_END_OF_BUFFER_CHAR )
+		/* They forgot to leave room for the EOB's. */
+		return 0;
+
+	b = (YY_BUFFER_STATE) perf_pmu_alloc(sizeof( struct yy_buffer_state )  );
+	if ( ! b )
+		YY_FATAL_ERROR( "out of dynamic memory in perf_pmu__scan_buffer()" );
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
+	perf_pmu__switch_to_buffer(b  );
+
+	return b;
+}
+
+/** Setup the input buffer state to scan a string. The next call to perf_pmu_lex() will
+ * scan from a @e copy of @a str.
+ * @param yystr a NUL-terminated string to scan
+ * 
+ * @return the newly allocated buffer state object.
+ * @note If you want to scan bytes that may contain NUL values, then use
+ *       perf_pmu__scan_bytes() instead.
+ */
+YY_BUFFER_STATE perf_pmu__scan_string (yyconst char * yystr )
+{
+    
+	return perf_pmu__scan_bytes(yystr,strlen(yystr) );
+}
+
+/** Setup the input buffer state to scan the given bytes. The next call to perf_pmu_lex() will
+ * scan from a @e copy of @a bytes.
+ * @param bytes the byte buffer to scan
+ * @param len the number of bytes in the buffer pointed to by @a bytes.
+ * 
+ * @return the newly allocated buffer state object.
+ */
+YY_BUFFER_STATE perf_pmu__scan_bytes  (yyconst char * yybytes, int  _yybytes_len )
+{
+	YY_BUFFER_STATE b;
+	char *buf;
+	yy_size_t n;
+	int i;
+    
+	/* Get memory for full buffer, including space for trailing EOB's. */
+	n = _yybytes_len + 2;
+	buf = (char *) perf_pmu_alloc(n  );
+	if ( ! buf )
+		YY_FATAL_ERROR( "out of dynamic memory in perf_pmu__scan_bytes()" );
+
+	for ( i = 0; i < _yybytes_len; ++i )
+		buf[i] = yybytes[i];
+
+	buf[_yybytes_len] = buf[_yybytes_len+1] = YY_END_OF_BUFFER_CHAR;
+
+	b = perf_pmu__scan_buffer(buf,n );
+	if ( ! b )
+		YY_FATAL_ERROR( "bad buffer in perf_pmu__scan_bytes()" );
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
+		/* Undo effects of setting up perf_pmu_text. */ \
+        int yyless_macro_arg = (n); \
+        YY_LESS_LINENO(yyless_macro_arg);\
+		perf_pmu_text[perf_pmu_leng] = (yy_hold_char); \
+		(yy_c_buf_p) = perf_pmu_text + yyless_macro_arg; \
+		(yy_hold_char) = *(yy_c_buf_p); \
+		*(yy_c_buf_p) = '\0'; \
+		perf_pmu_leng = yyless_macro_arg; \
+		} \
+	while ( 0 )
+
+/* Accessor  methods (get/set functions) to struct members. */
+
+/** Get the current line number.
+ * 
+ */
+int perf_pmu_get_lineno  (void)
+{
+        
+    return perf_pmu_lineno;
+}
+
+/** Get the input stream.
+ * 
+ */
+FILE *perf_pmu_get_in  (void)
+{
+        return perf_pmu_in;
+}
+
+/** Get the output stream.
+ * 
+ */
+FILE *perf_pmu_get_out  (void)
+{
+        return perf_pmu_out;
+}
+
+/** Get the length of the current token.
+ * 
+ */
+int perf_pmu_get_leng  (void)
+{
+        return perf_pmu_leng;
+}
+
+/** Get the current token.
+ * 
+ */
+
+char *perf_pmu_get_text  (void)
+{
+        return perf_pmu_text;
+}
+
+/** Set the current line number.
+ * @param line_number
+ * 
+ */
+void perf_pmu_set_lineno (int  line_number )
+{
+    
+    perf_pmu_lineno = line_number;
+}
+
+/** Set the input stream. This does not discard the current
+ * input buffer.
+ * @param in_str A readable stream.
+ * 
+ * @see perf_pmu__switch_to_buffer
+ */
+void perf_pmu_set_in (FILE *  in_str )
+{
+        perf_pmu_in = in_str ;
+}
+
+void perf_pmu_set_out (FILE *  out_str )
+{
+        perf_pmu_out = out_str ;
+}
+
+int perf_pmu_get_debug  (void)
+{
+        return perf_pmu__flex_debug;
+}
+
+void perf_pmu_set_debug (int  bdebug )
+{
+        perf_pmu__flex_debug = bdebug ;
+}
+
+static int yy_init_globals (void)
+{
+        /* Initialization is the same as for the non-reentrant scanner.
+     * This function is called from perf_pmu_lex_destroy(), so don't allocate here.
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
+    perf_pmu_in = stdin;
+    perf_pmu_out = stdout;
+#else
+    perf_pmu_in = (FILE *) 0;
+    perf_pmu_out = (FILE *) 0;
+#endif
+
+    /* For future reference: Set errno on error, since we are called by
+     * perf_pmu_lex_init()
+     */
+    return 0;
+}
+
+/* perf_pmu_lex_destroy is for both reentrant and non-reentrant scanners. */
+int perf_pmu_lex_destroy  (void)
+{
+    
+    /* Pop the buffer stack, destroying each element. */
+	while(YY_CURRENT_BUFFER){
+		perf_pmu__delete_buffer(YY_CURRENT_BUFFER  );
+		YY_CURRENT_BUFFER_LVALUE = NULL;
+		perf_pmu_pop_buffer_state();
+	}
+
+	/* Destroy the stack itself. */
+	perf_pmu_free((yy_buffer_stack) );
+	(yy_buffer_stack) = NULL;
+
+    /* Reset the globals. This is important in a non-reentrant scanner so the next time
+     * perf_pmu_lex() is called, initialization will occur. */
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
+void *perf_pmu_alloc (yy_size_t  size )
+{
+	return (void *) malloc( size );
+}
+
+void *perf_pmu_realloc  (void * ptr, yy_size_t  size )
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
+void perf_pmu_free (void * ptr )
+{
+	free( (char *) ptr );	/* see perf_pmu_realloc() for (char *) cast */
+}
+
+#define YYTABLES_NAME "yytables"
+
+#line 38 "util/pmu.l"
+
+
+
+int perf_pmu_wrap(void)
+{
+	return 1;
+}
+
diff --git a/tools/perf/util/pmu-flex.h b/tools/perf/util/pmu-flex.h
new file mode 100644
index 0000000..0a29c8a
--- /dev/null
+++ b/tools/perf/util/pmu-flex.h
@@ -0,0 +1,316 @@
+#ifndef perf_pmu_HEADER_H
+#define perf_pmu_HEADER_H 1
+#define perf_pmu_IN_HEADER 1
+
+#line 6 "util/pmu-flex.h"
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
+extern int perf_pmu_leng;
+
+extern FILE *perf_pmu_in, *perf_pmu_out;
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
+void perf_pmu_restart (FILE *input_file  );
+void perf_pmu__switch_to_buffer (YY_BUFFER_STATE new_buffer  );
+YY_BUFFER_STATE perf_pmu__create_buffer (FILE *file,int size  );
+void perf_pmu__delete_buffer (YY_BUFFER_STATE b  );
+void perf_pmu__flush_buffer (YY_BUFFER_STATE b  );
+void perf_pmu_push_buffer_state (YY_BUFFER_STATE new_buffer  );
+void perf_pmu_pop_buffer_state (void );
+
+YY_BUFFER_STATE perf_pmu__scan_buffer (char *base,yy_size_t size  );
+YY_BUFFER_STATE perf_pmu__scan_string (yyconst char *yy_str  );
+YY_BUFFER_STATE perf_pmu__scan_bytes (yyconst char *bytes,int len  );
+
+void *perf_pmu_alloc (yy_size_t  );
+void *perf_pmu_realloc (void *,yy_size_t  );
+void perf_pmu_free (void *  );
+
+/* Begin user sect3 */
+
+extern int perf_pmu_lineno;
+
+extern char *perf_pmu_text;
+#define yytext_ptr perf_pmu_text
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
+int perf_pmu_lex_destroy (void );
+
+int perf_pmu_get_debug (void );
+
+void perf_pmu_set_debug (int debug_flag  );
+
+YY_EXTRA_TYPE perf_pmu_get_extra (void );
+
+void perf_pmu_set_extra (YY_EXTRA_TYPE user_defined  );
+
+FILE *perf_pmu_get_in (void );
+
+void perf_pmu_set_in  (FILE * in_str  );
+
+FILE *perf_pmu_get_out (void );
+
+void perf_pmu_set_out  (FILE * out_str  );
+
+int perf_pmu_get_leng (void );
+
+char *perf_pmu_get_text (void );
+
+int perf_pmu_get_lineno (void );
+
+void perf_pmu_set_lineno (int line_number  );
+
+/* Macros after this point can all be overridden by user definitions in
+ * section 1.
+ */
+
+#ifndef YY_SKIP_YYWRAP
+#ifdef __cplusplus
+extern "C" int perf_pmu_wrap (void );
+#else
+extern int perf_pmu_wrap (void );
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
+extern int perf_pmu_lex (void);
+
+#define YY_DECL int perf_pmu_lex (void)
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
+#line 38 "util/pmu.l"
+
+
+#line 315 "util/pmu-flex.h"
+#undef perf_pmu_IN_HEADER
+#endif /* perf_pmu_HEADER_H */
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
new file mode 100644
index 0000000..cb08a11
--- /dev/null
+++ b/tools/perf/util/pmu.c
@@ -0,0 +1,469 @@
+
+#include <linux/list.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <dirent.h>
+#include "sysfs.h"
+#include "util.h"
+#include "pmu.h"
+#include "parse-events.h"
+
+int perf_pmu_parse(struct list_head *list, char *name);
+extern FILE *perf_pmu_in;
+
+static LIST_HEAD(pmus);
+
+/*
+ * Parse & process all the sysfs attributes located under
+ * the directory specified in 'dir' parameter.
+ */
+static int pmu_format_parse(char *dir, struct list_head *head)
+{
+	struct dirent *evt_ent;
+	DIR *format_dir;
+	int ret = 0;
+
+	format_dir = opendir(dir);
+	if (!format_dir)
+		return -EINVAL;
+
+	while (!ret && (evt_ent = readdir(format_dir))) {
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
+
+		perf_pmu_in = file;
+		ret = perf_pmu_parse(head, name);
+		fclose(file);
+	}
+
+	closedir(format_dir);
+	return ret;
+}
+
+/*
+ * Reading/parsing the default pmu format definition, which should be
+ * located at:
+ * /sys/bus/event_source/devices/<dev>/format as sysfs group attributes.
+ */
+static int pmu_format(char *name, struct list_head *format)
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
+		 "%s/bus/event_source/devices/%s/format", sysfs, name);
+
+	if (stat(path, &st) < 0)
+		return -1;
+
+	if (pmu_format_parse(path, format))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Reading/parsing the default pmu type value, which should be
+ * located at:
+ * /sys/bus/event_source/devices/<dev>/type as sysfs attribute.
+ */
+static int pmu_type(char *name, __u32 *type)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	const char *sysfs;
+	FILE *file;
+	int ret = 0;
+
+	sysfs = sysfs_find_mountpoint();
+	if (!sysfs)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		 "%s/bus/event_source/devices/%s/type", sysfs, name);
+
+	if (stat(path, &st) < 0)
+		return -1;
+
+	file = fopen(path, "r");
+	if (!file)
+		return -EINVAL;
+
+	if (1 != fscanf(file, "%u", type))
+		ret = -1;
+
+	fclose(file);
+	return ret;
+}
+
+static struct perf_pmu *pmu_lookup(char *name)
+{
+	struct perf_pmu *pmu;
+	LIST_HEAD(format);
+	__u32 type;
+
+	/*
+	 * The pmu data we store & need consists of the pmu
+	 * type value and format definitions. Load both right
+	 * now.
+	 */
+	if (pmu_format(name, &format))
+		return NULL;
+
+	if (pmu_type(name, &type))
+		return NULL;
+
+	pmu = zalloc(sizeof(*pmu));
+	if (!pmu)
+		return NULL;
+
+	INIT_LIST_HEAD(&pmu->format);
+	list_splice(&format, &pmu->format);
+	pmu->name = strdup(name);
+	pmu->type = type;
+	return pmu;
+}
+
+static struct perf_pmu *pmu_find(char *name)
+{
+	struct perf_pmu *pmu;
+
+	list_for_each_entry(pmu, &pmus, list)
+		if (!strcmp(pmu->name, name))
+			return pmu;
+
+	return NULL;
+}
+
+struct perf_pmu *perf_pmu__find(char *name)
+{
+	struct perf_pmu *pmu;
+
+	/*
+	 * Once PMU is loaded it stays in the list,
+	 * so we keep us from multiple reading/parsing
+	 * the pmu format definitions.
+	 */
+	pmu = pmu_find(name);
+	if (pmu)
+		return pmu;
+
+	return pmu_lookup(name);
+}
+
+static struct perf_pmu__format*
+pmu_find_format(struct list_head *formats, char *name)
+{
+	struct perf_pmu__format *format;
+
+	list_for_each_entry(format, formats, list)
+		if (!strcmp(format->name, name))
+			return format;
+
+	return NULL;
+}
+
+/*
+ * Returns value based on the format definition (format parameter)
+ * and unformated value (value parameter).
+ *
+ * TODO maybe optimize a little ;)
+ */
+static __u64 pmu_format_value(unsigned long *format, __u64 value)
+{
+	unsigned long fbit, vbit;
+	__u64 v = 0;
+
+	for (fbit = 0, vbit = 0; fbit < PERF_PMU_FORMAT_BITS; fbit++) {
+
+		if (!test_bit(fbit, format))
+			continue;
+
+		if (!(value & (1llu << vbit++)))
+			continue;
+
+		v |= (1llu << fbit);
+	}
+
+	return v;
+}
+
+/*
+ * Setup one of config[12] attr members based on the
+ * user input data - temr parameter.
+ */
+static int pmu_config_term(struct list_head *formats,
+			   struct perf_event_attr *attr,
+			   struct parse_events__term *term)
+{
+	struct perf_pmu__format *format;
+	__u64 *vp;
+
+	/*
+	 * Support only for hardcoded and numnerial terms.
+	 * Hardcoded terms should be already in, so nothing
+	 * to be done for them.
+	 */
+	if (parse_events__is_hardcoded_term(term))
+		return 0;
+
+	if (term->type != PARSE_EVENTS__TERM_TYPE_NUM)
+		return -EINVAL;
+
+	format = pmu_find_format(formats, term->config);
+	if (!format)
+		return -EINVAL;
+
+	switch (format->value) {
+	case PERF_PMU_FORMAT_VALUE_CONFIG:
+		vp = &attr->config;
+		break;
+	case PERF_PMU_FORMAT_VALUE_CONFIG1:
+		vp = &attr->config1;
+		break;
+	case PERF_PMU_FORMAT_VALUE_CONFIG2:
+		vp = &attr->config2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*vp |= pmu_format_value(format->bits, term->val.num);
+	return 0;
+}
+
+static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
+		      struct list_head *head_terms)
+{
+	struct parse_events__term *term, *h;
+
+	list_for_each_entry_safe(term, h, head_terms, list)
+		if (pmu_config_term(formats, attr, term))
+			return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Configures event's 'attr' parameter based on the:
+ * 1) users input - specified in terms parameter
+ * 2) pmu format definitions - specified by pmu parameter
+ */
+int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
+		     struct list_head *head_terms)
+{
+	attr->type = pmu->type;
+	return pmu_config(&pmu->format, attr, head_terms);
+}
+
+int perf_pmu__new_format(struct list_head *list, char *name,
+			 int config, unsigned long *bits)
+{
+	struct perf_pmu__format *format;
+
+	format = zalloc(sizeof(*format));
+	if (!format)
+		return -ENOMEM;
+
+	format->name = strdup(name);
+	format->value = config;
+	memcpy(format->bits, bits, sizeof(format->bits));
+
+	list_add_tail(&format->list, list);
+	return 0;
+}
+
+void perf_pmu__set_format(unsigned long *bits, long from, long to)
+{
+	long b;
+
+	if (!to)
+		to = from;
+
+	memset(bits, 0, BITS_TO_LONGS(PERF_PMU_FORMAT_BITS));
+	for (b = from; b <= to; b++)
+		set_bit(b, bits);
+}
+
+/* Simulated format definitions. */
+static struct test_format {
+	const char *name;
+	const char *value;
+} test_formats[] = {
+	{ "krava01", "config:0-1,62-63\n", },
+	{ "krava02", "config:10-17\n", },
+	{ "krava03", "config:5\n", },
+	{ "krava11", "config1:0,2,4,6,8,20-28\n", },
+	{ "krava12", "config1:63\n", },
+	{ "krava13", "config1:45-47\n", },
+	{ "krava21", "config2:0-3,10-13,20-23,30-33,40-43,50-53,60-63\n", },
+	{ "krava22", "config2:8,18,48,58\n", },
+	{ "krava23", "config2:28-29,38\n", },
+};
+
+#define TEST_FORMATS_CNT (sizeof(test_formats) / sizeof(struct test_format))
+
+/* Simulated users input. */
+static struct parse_events__term test_terms[] = {
+	{
+		.config  = (char *) "krava01",
+		.val.num = 15,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava02",
+		.val.num = 170,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava03",
+		.val.num = 1,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava11",
+		.val.num = 27,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava12",
+		.val.num = 1,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava13",
+		.val.num = 2,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava21",
+		.val.num = 119,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava22",
+		.val.num = 11,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+	{
+		.config  = (char *) "krava23",
+		.val.num = 2,
+		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+	},
+};
+#define TERMS_CNT (sizeof(test_terms) / sizeof(struct parse_events__term))
+
+/*
+ * Prepare format directory data, exported by kernel
+ * at /sys/bus/event_source/devices/<dev>/format.
+ */
+static char *test_format_dir_get(void)
+{
+	static char dir[PATH_MAX];
+	unsigned int i;
+
+	snprintf(dir, PATH_MAX, "/tmp/perf-pmu-test-format-XXXXXX");
+	if (!mkdtemp(dir))
+		return NULL;
+
+	for (i = 0; i < TEST_FORMATS_CNT; i++) {
+		static char name[PATH_MAX];
+		struct test_format *format = &test_formats[i];
+		FILE *file;
+
+		snprintf(name, PATH_MAX, "%s/%s", dir, format->name);
+
+		file = fopen(name, "w");
+		if (!file)
+			return NULL;
+
+		if (1 != fwrite(format->value, strlen(format->value), 1, file))
+			break;
+
+		fclose(file);
+	}
+
+	return dir;
+}
+
+/* Cleanup format directory. */
+static int test_format_dir_put(char *dir)
+{
+	char buf[PATH_MAX];
+	snprintf(buf, PATH_MAX, "rm -f %s/*\n", dir);
+	if (system(buf))
+		return -1;
+
+	snprintf(buf, PATH_MAX, "rmdir %s\n", dir);
+	return system(buf);
+}
+
+static struct list_head *test_terms_list(void)
+{
+	static LIST_HEAD(terms);
+	unsigned int i;
+
+	for (i = 0; i < TERMS_CNT; i++)
+		list_add_tail(&test_terms[i].list, &terms);
+
+	return &terms;
+}
+
+#undef TERMS_CNT
+
+int perf_pmu__test(void)
+{
+	char *format = test_format_dir_get();
+	LIST_HEAD(formats);
+	struct list_head *terms = test_terms_list();
+	int ret;
+
+	if (!format)
+		return -EINVAL;
+
+	do {
+		struct perf_event_attr attr;
+
+		memset(&attr, 0, sizeof(attr));
+
+		ret = pmu_format_parse(format, &formats);
+		if (ret)
+			break;
+
+		ret = pmu_config(&formats, &attr, terms);
+		if (ret)
+			break;
+
+		ret = -EINVAL;
+
+		if (attr.config  != 0xc00000000002a823)
+			break;
+		if (attr.config1 != 0x8000400000000145)
+			break;
+		if (attr.config2 != 0x0400000020041d07)
+			break;
+
+		ret = 0;
+	} while (0);
+
+	test_format_dir_put(format);
+	return ret;
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
new file mode 100644
index 0000000..68c0db9
--- /dev/null
+++ b/tools/perf/util/pmu.h
@@ -0,0 +1,41 @@
+#ifndef __PMU_H
+#define __PMU_H
+
+#include <linux/bitops.h>
+#include "../../../include/linux/perf_event.h"
+
+enum {
+	PERF_PMU_FORMAT_VALUE_CONFIG,
+	PERF_PMU_FORMAT_VALUE_CONFIG1,
+	PERF_PMU_FORMAT_VALUE_CONFIG2,
+};
+
+#define PERF_PMU_FORMAT_BITS 64
+
+struct perf_pmu__format {
+	char *name;
+	int value;
+	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
+	struct list_head list;
+};
+
+struct perf_pmu {
+	char *name;
+	__u32 type;
+	struct list_head format;
+	struct list_head list;
+};
+
+struct perf_pmu *perf_pmu__find(char *name);
+int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
+		     struct list_head *head_terms);
+
+int perf_pmu_wrap(void);
+void perf_pmu_error(struct list_head *list, char *name, char const *msg);
+
+int perf_pmu__new_format(struct list_head *list, char *name,
+			 int config, unsigned long *bits);
+void perf_pmu__set_format(unsigned long *bits, long from, long to);
+
+int perf_pmu__test(void);
+#endif /* __PMU_H */
diff --git a/tools/perf/util/pmu.l b/tools/perf/util/pmu.l
new file mode 100644
index 0000000..a15d9fb
--- /dev/null
+++ b/tools/perf/util/pmu.l
@@ -0,0 +1,43 @@
+%option prefix="perf_pmu_"
+
+%{
+#include <stdlib.h>
+#include <linux/bitops.h>
+#include "pmu.h"
+#include "pmu-bison.h"
+
+static int value(int base)
+{
+	long num;
+
+	errno = 0;
+	num = strtoul(perf_pmu_text, NULL, base);
+	if (errno)
+		return PP_ERROR;
+
+	perf_pmu_lval.num = num;
+	return PP_VALUE;
+}
+
+%}
+
+num_dec         [0-9]+
+
+%%
+
+{num_dec}	{ return value(10); }
+config		{ return PP_CONFIG; }
+config1		{ return PP_CONFIG1; }
+config2		{ return PP_CONFIG2; }
+-		{ return '-'; }
+:		{ return ':'; }
+,		{ return ','; }
+.		{ ; }
+\n		{ ; }
+
+%%
+
+int perf_pmu_wrap(void)
+{
+	return 1;
+}
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
new file mode 100644
index 0000000..20ea77e
--- /dev/null
+++ b/tools/perf/util/pmu.y
@@ -0,0 +1,93 @@
+
+%name-prefix "perf_pmu_"
+%parse-param {struct list_head *format}
+%parse-param {char *name}
+
+%{
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+#include <linux/bitmap.h>
+#include <string.h>
+#include "pmu.h"
+
+extern int perf_pmu_lex (void);
+
+#define ABORT_ON(val) \
+do { \
+        if (val) \
+                YYABORT; \
+} while (0)
+
+%}
+
+%token PP_CONFIG PP_CONFIG1 PP_CONFIG2
+%token PP_VALUE PP_ERROR
+%type <num> PP_VALUE
+%type <bits> bit_term
+%type <bits> bits
+
+%union
+{
+	unsigned long num;
+	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
+}
+
+%%
+
+format:
+format format_term
+|
+format_term
+
+format_term:
+PP_CONFIG ':' bits
+{
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_CONFIG,
+				      $3));
+}
+|
+PP_CONFIG1 ':' bits
+{
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_CONFIG1,
+				      $3));
+}
+|
+PP_CONFIG2 ':' bits
+{
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_CONFIG2,
+				      $3));
+}
+
+bits:
+bits ',' bit_term
+{
+	bitmap_or($$, $1, $3, 64);
+}
+|
+bit_term
+{
+	memcpy($$, $1, sizeof($1));
+}
+
+bit_term:
+PP_VALUE '-' PP_VALUE
+{
+	perf_pmu__set_format($$, $1, $3);
+}
+|
+PP_VALUE
+{
+	perf_pmu__set_format($$, $1, 0);
+}
+
+%%
+
+void perf_pmu_error(struct list_head *list __used,
+		    char *name __used,
+		    char const *msg __used)
+{
+}
-- 
1.7.4.4

