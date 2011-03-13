Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1CMGbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:31:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1CMGbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:31:02 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] genksyms: Regenerate lexer and parser
Date: Sun, 13 Mar 2011 07:30:25 +0100
Message-Id: <1299997825-18977-8-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/genksyms/lex.c_shipped   |   30 +-
 scripts/genksyms/parse.c_shipped | 1071 ++++++++++++++++++++++----------------
 scripts/genksyms/parse.h_shipped |   72 +--
 3 files changed, 661 insertions(+), 512 deletions(-)

diff --git a/scripts/genksyms/lex.c_shipped b/scripts/genksyms/lex.c_shipped
index f231c08..af49390 100644
--- a/scripts/genksyms/lex.c_shipped
+++ b/scripts/genksyms/lex.c_shipped
@@ -2253,12 +2253,23 @@ void yyfree (void * ptr )
 
 /* Macros to append to our phrase collection list.  */
 
+/*
+ * We mark any token, that that equals to a known enumerator, as
+ * SYM_ENUM_CONST. The parser will change this for struct and union tags later,
+ * the only problem is struct and union members:
+ *    enum e { a, b }; struct s { int a, b; }
+ * but in this case, the only effect will be, that the ABI checksums become
+ * more volatile, which is acceptable. Also, such collisions are quite rare,
+ * so far it was only observed in include/linux/telephony.h.
+ */
 #define _APP(T,L)	do {						   \
 			  cur_node = next_node;				   \
 			  next_node = xmalloc(sizeof(*next_node));	   \
 			  next_node->next = cur_node;			   \
 			  cur_node->string = memcpy(xmalloc(L+1), T, L+1); \
-			  cur_node->tag = SYM_NORMAL;			   \
+			  cur_node->tag =				   \
+			    find_symbol(cur_node->string, SYM_ENUM_CONST, 1)?\
+			    SYM_ENUM_CONST : SYM_NORMAL ;		   \
 			} while (0)
 
 #define APP		_APP(yytext, yyleng)
@@ -2336,8 +2347,8 @@ repeat:
 
 		  case STRUCT_KEYW:
 		  case UNION_KEYW:
-		    dont_want_brace_phrase = 3;
 		  case ENUM_KEYW:
+		    dont_want_brace_phrase = 3;
 		    suppress_type_lookup = 2;
 		    goto fini;
 
@@ -2466,7 +2477,20 @@ repeat:
 	  ++count;
 	  APP;
 	  goto repeat;
-	case ')': case ']': case '}':
+	case '}':
+	  /* is this the last line of an enum declaration? */
+	  if (count == 0)
+	    {
+	      /* Put back the token we just read so's we can find it again
+		 after registering the expression.  */
+	      unput(token);
+
+	      lexstate = ST_NORMAL;
+	      token = EXPRESSION_PHRASE;
+	      break;
+	    }
+	  /* FALLTHRU */
+	case ')': case ']':
 	  --count;
 	  APP;
 	  goto repeat;
diff --git a/scripts/genksyms/parse.c_shipped b/scripts/genksyms/parse.c_shipped
index 809b949..1a0b860 100644
--- a/scripts/genksyms/parse.c_shipped
+++ b/scripts/genksyms/parse.c_shipped
@@ -1,24 +1,23 @@
-/* A Bison parser, made by GNU Bison 2.3.  */
 
-/* Skeleton implementation for Bison's Yacc-like parsers in C
+/* A Bison parser, made by GNU Bison 2.4.1.  */
 
-   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
+/* Skeleton implementation for Bison's Yacc-like parsers in C
+   
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
    Free Software Foundation, Inc.
-
-   This program is free software; you can redistribute it and/or modify
+   
+   This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2, or (at your option)
-   any later version.
-
+   the Free Software Foundation, either version 3 of the License, or
+   (at your option) any later version.
+   
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
-
+   
    You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 51 Franklin Street, Fifth Floor,
-   Boston, MA 02110-1301, USA.  */
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
 
 /* As a special exception, you may create a larger work that contains
    part or all of the Bison parser skeleton and distribute that work
@@ -29,7 +28,7 @@
    special exception, which will cause the skeleton and the resulting
    Bison output files to be licensed under the GNU General Public
    License without this special exception.
-
+   
    This special exception was added by the Free Software Foundation in
    version 2.2 of Bison.  */
 
@@ -47,7 +46,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.3"
+#define YYBISON_VERSION "2.4.1"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -55,11 +54,75 @@
 /* Pure parsers.  */
 #define YYPURE 0
 
+/* Push parsers.  */
+#define YYPUSH 0
+
+/* Pull parsers.  */
+#define YYPULL 1
+
 /* Using locations.  */
 #define YYLSP_NEEDED 0
 
 
 
+/* Copy the first part of user declarations.  */
+
+/* Line 189 of yacc.c  */
+#line 24 "scripts/genksyms/parse.y"
+
+
+#include <assert.h>
+#include <stdlib.h>
+#include <string.h>
+#include "genksyms.h"
+
+static int is_typedef;
+static int is_extern;
+static char *current_name;
+static struct string_list *decl_spec;
+
+static void yyerror(const char *);
+
+static inline void
+remove_node(struct string_list **p)
+{
+  struct string_list *node = *p;
+  *p = node->next;
+  free_node(node);
+}
+
+static inline void
+remove_list(struct string_list **pb, struct string_list **pe)
+{
+  struct string_list *b = *pb, *e = *pe;
+  *pb = e;
+  free_list(b, e);
+}
+
+
+
+/* Line 189 of yacc.c  */
+#line 106 "scripts/genksyms/parse.c"
+
+/* Enabling traces.  */
+#ifndef YYDEBUG
+# define YYDEBUG 1
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
 /* Tokens.  */
 #ifndef YYTOKENTYPE
 # define YYTOKENTYPE
@@ -109,117 +172,22 @@
      FILENAME = 298
    };
 #endif
-/* Tokens.  */
-#define ASM_KEYW 258
-#define ATTRIBUTE_KEYW 259
-#define AUTO_KEYW 260
-#define BOOL_KEYW 261
-#define CHAR_KEYW 262
-#define CONST_KEYW 263
-#define DOUBLE_KEYW 264
-#define ENUM_KEYW 265
-#define EXTERN_KEYW 266
-#define EXTENSION_KEYW 267
-#define FLOAT_KEYW 268
-#define INLINE_KEYW 269
-#define INT_KEYW 270
-#define LONG_KEYW 271
-#define REGISTER_KEYW 272
-#define RESTRICT_KEYW 273
-#define SHORT_KEYW 274
-#define SIGNED_KEYW 275
-#define STATIC_KEYW 276
-#define STRUCT_KEYW 277
-#define TYPEDEF_KEYW 278
-#define UNION_KEYW 279
-#define UNSIGNED_KEYW 280
-#define VOID_KEYW 281
-#define VOLATILE_KEYW 282
-#define TYPEOF_KEYW 283
-#define EXPORT_SYMBOL_KEYW 284
-#define ASM_PHRASE 285
-#define ATTRIBUTE_PHRASE 286
-#define BRACE_PHRASE 287
-#define BRACKET_PHRASE 288
-#define EXPRESSION_PHRASE 289
-#define CHAR 290
-#define DOTS 291
-#define IDENT 292
-#define INT 293
-#define REAL 294
-#define STRING 295
-#define TYPE 296
-#define OTHER 297
-#define FILENAME 298
-
-
-
-
-/* Copy the first part of user declarations.  */
-#line 24 "scripts/genksyms/parse.y"
-
-
-#include <assert.h>
-#include <stdlib.h>
-#include "genksyms.h"
-
-static int is_typedef;
-static int is_extern;
-static char *current_name;
-static struct string_list *decl_spec;
-
-static void yyerror(const char *);
-
-static inline void
-remove_node(struct string_list **p)
-{
-  struct string_list *node = *p;
-  *p = node->next;
-  free_node(node);
-}
-
-static inline void
-remove_list(struct string_list **pb, struct string_list **pe)
-{
-  struct string_list *b = *pb, *e = *pe;
-  *pb = e;
-  free_list(b, e);
-}
-
-
-
-/* Enabling traces.  */
-#ifndef YYDEBUG
-# define YYDEBUG 1
-#endif
 
-/* Enabling verbose error messages.  */
-#ifdef YYERROR_VERBOSE
-# undef YYERROR_VERBOSE
-# define YYERROR_VERBOSE 1
-#else
-# define YYERROR_VERBOSE 0
-#endif
 
-/* Enabling the token table.  */
-#ifndef YYTOKEN_TABLE
-# define YYTOKEN_TABLE 0
-#endif
 
 #if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
 typedef int YYSTYPE;
+# define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
 # define YYSTYPE_IS_DECLARED 1
-# define YYSTYPE_IS_TRIVIAL 1
 #endif
 
 
-
 /* Copy the second part of user declarations.  */
 
 
-/* Line 216 of yacc.c.  */
-#line 223 "scripts/genksyms/parse.c"
+/* Line 264 of yacc.c  */
+#line 191 "scripts/genksyms/parse.c"
 
 #ifdef short
 # undef short
@@ -294,14 +262,14 @@ typedef short int yytype_int16;
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 static int
-YYID (int i)
+YYID (int yyi)
 #else
 static int
-YYID (i)
-    int i;
+YYID (yyi)
+    int yyi;
 #endif
 {
-  return i;
+  return yyi;
 }
 #endif
 
@@ -382,9 +350,9 @@ void free (void *); /* INFRINGES ON USER NAME SPACE */
 /* A type that is properly aligned for any stack member.  */
 union yyalloc
 {
-  yytype_int16 yyss;
-  YYSTYPE yyvs;
-  };
+  yytype_int16 yyss_alloc;
+  YYSTYPE yyvs_alloc;
+};
 
 /* The size of the maximum gap between one aligned stack and the next.  */
 # define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)
@@ -418,12 +386,12 @@ union yyalloc
    elements in the stack, and YYPTR gives the new location of the
    stack.  Advance YYPTR to a properly aligned location for the next
    stack.  */
-# define YYSTACK_RELOCATE(Stack)					\
+# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
     do									\
       {									\
 	YYSIZE_T yynewbytes;						\
-	YYCOPY (&yyptr->Stack, Stack, yysize);				\
-	Stack = &yyptr->Stack;						\
+	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
+	Stack = &yyptr->Stack_alloc;					\
 	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
 	yyptr += yynewbytes / sizeof (*yyptr);				\
       }									\
@@ -434,16 +402,16 @@ union yyalloc
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  4
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   523
+#define YYLAST   532
 
 /* YYNTOKENS -- Number of terminals.  */
 #define YYNTOKENS  53
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  46
+#define YYNNTS  49
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  126
+#define YYNRULES  132
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  178
+#define YYNSTATES  188
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
@@ -504,7 +472,8 @@ static const yytype_uint16 yyprhs[] =
      239,   242,   245,   247,   248,   250,   252,   257,   262,   265,
      269,   273,   277,   278,   280,   283,   287,   291,   292,   294,
      296,   299,   303,   306,   307,   309,   311,   315,   318,   321,
-     323,   326,   327,   330,   333,   334,   336
+     323,   326,   327,   330,   334,   339,   341,   345,   347,   351,
+     354,   355,   357
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
@@ -512,16 +481,16 @@ static const yytype_int8 yyrhs[] =
 {
       54,     0,    -1,    55,    -1,    54,    55,    -1,    -1,    56,
       57,    -1,    -1,    12,    23,    58,    60,    -1,    -1,    23,
-      59,    60,    -1,    60,    -1,    84,    -1,    96,    -1,    98,
+      59,    60,    -1,    60,    -1,    84,    -1,    99,    -1,   101,
       -1,     1,    44,    -1,     1,    45,    -1,    64,    61,    44,
       -1,    -1,    62,    -1,    63,    -1,    62,    46,    63,    -1,
-      74,    97,    95,    85,    -1,    -1,    65,    -1,    66,    -1,
+      74,   100,    95,    85,    -1,    -1,    65,    -1,    66,    -1,
       65,    66,    -1,    67,    -1,    68,    -1,     5,    -1,    17,
       -1,    21,    -1,    11,    -1,    14,    -1,    69,    -1,    73,
       -1,    28,    47,    65,    48,    49,    -1,    28,    47,    65,
       49,    -1,    22,    37,    -1,    24,    37,    -1,    10,    37,
       -1,    22,    37,    87,    -1,    24,    37,    87,    -1,    10,
-      37,    32,    -1,    10,    32,    -1,    22,    87,    -1,    24,
+      37,    96,    -1,    10,    96,    -1,    22,    87,    -1,    24,
       87,    -1,     7,    -1,    19,    -1,    15,    -1,    16,    -1,
       20,    -1,    25,    -1,    13,    -1,     9,    -1,    26,    -1,
        6,    -1,    41,    -1,    48,    71,    -1,    -1,    72,    -1,
@@ -543,26 +512,29 @@ static const yytype_int8 yyrhs[] =
       91,    44,    -1,     1,    44,    -1,    -1,    92,    -1,    93,
       -1,    92,    46,    93,    -1,    76,    95,    -1,    37,    94,
       -1,    94,    -1,    52,    34,    -1,    -1,    95,    31,    -1,
-      30,    44,    -1,    -1,    30,    -1,    29,    47,    37,    49,
-      44,    -1
+      51,    97,    45,    -1,    51,    97,    46,    45,    -1,    98,
+      -1,    97,    46,    98,    -1,    37,    -1,    37,    50,    34,
+      -1,    30,    44,    -1,    -1,    30,    -1,    29,    47,    37,
+      49,    44,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint16 yyrline[] =
 {
-       0,   103,   103,   104,   108,   108,   114,   114,   116,   116,
-     118,   119,   120,   121,   122,   123,   127,   141,   142,   146,
-     154,   167,   173,   174,   178,   179,   183,   189,   193,   194,
-     195,   196,   197,   201,   202,   203,   204,   208,   210,   212,
-     216,   223,   230,   239,   240,   241,   245,   246,   247,   248,
-     249,   250,   251,   252,   253,   254,   255,   259,   264,   265,
-     269,   270,   274,   274,   274,   275,   283,   284,   288,   297,
-     299,   301,   303,   305,   312,   313,   317,   318,   319,   321,
-     323,   325,   327,   332,   333,   334,   338,   339,   343,   344,
-     349,   354,   356,   360,   361,   369,   373,   375,   377,   379,
-     381,   386,   395,   396,   401,   406,   407,   411,   412,   416,
-     417,   421,   423,   428,   429,   433,   434,   438,   439,   440,
-     444,   448,   449,   453,   457,   458,   462
+       0,   104,   104,   105,   109,   109,   115,   115,   117,   117,
+     119,   120,   121,   122,   123,   124,   128,   142,   143,   147,
+     155,   168,   174,   175,   179,   180,   184,   190,   194,   195,
+     196,   197,   198,   202,   203,   204,   205,   209,   211,   213,
+     217,   224,   231,   241,   244,   245,   249,   250,   251,   252,
+     253,   254,   255,   256,   257,   258,   259,   263,   268,   269,
+     273,   274,   278,   278,   278,   279,   287,   288,   292,   301,
+     303,   305,   307,   309,   316,   317,   321,   322,   323,   325,
+     327,   329,   331,   336,   337,   338,   342,   343,   347,   348,
+     353,   358,   360,   364,   365,   373,   377,   379,   381,   383,
+     385,   390,   399,   400,   405,   410,   411,   415,   416,   420,
+     421,   425,   427,   432,   433,   437,   438,   442,   443,   444,
+     448,   452,   453,   457,   458,   462,   463,   466,   471,   479,
+     483,   484,   488
 };
 #endif
 
@@ -581,8 +553,8 @@ static const char *const yytname[] =
   "ATTRIBUTE_PHRASE", "BRACE_PHRASE", "BRACKET_PHRASE",
   "EXPRESSION_PHRASE", "CHAR", "DOTS", "IDENT", "INT", "REAL", "STRING",
   "TYPE", "OTHER", "FILENAME", "';'", "'}'", "','", "'('", "'*'", "')'",
-  "'='", "'{'", "':'", "$accept", "declaration_seq", "declaration", "@1",
-  "declaration1", "@2", "@3", "simple_declaration",
+  "'='", "'{'", "':'", "$accept", "declaration_seq", "declaration", "$@1",
+  "declaration1", "$@2", "$@3", "simple_declaration",
   "init_declarator_list_opt", "init_declarator_list", "init_declarator",
   "decl_specifier_seq_opt", "decl_specifier_seq", "decl_specifier",
   "storage_class_specifier", "type_specifier", "simple_type_specifier",
@@ -596,7 +568,8 @@ static const char *const yytname[] =
   "member_specification", "member_declaration",
   "member_declarator_list_opt", "member_declarator_list",
   "member_declarator", "member_bitfield_declarator", "attribute_opt",
-  "asm_definition", "asm_phrase_opt", "export_definition", 0
+  "enum_body", "enumerator_list", "enumerator", "asm_definition",
+  "asm_phrase_opt", "export_definition", 0
 };
 #endif
 
@@ -629,7 +602,8 @@ static const yytype_uint8 yyr1[] =
       81,    82,    82,    83,    83,    83,    83,    83,    83,    83,
       83,    84,    85,    85,    86,    87,    87,    88,    88,    89,
       89,    90,    90,    91,    91,    92,    92,    93,    93,    93,
-      94,    95,    95,    96,    97,    97,    98
+      94,    95,    95,    96,    96,    97,    97,    98,    98,    99,
+     100,   100,   101
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
@@ -647,7 +621,8 @@ static const yytype_uint8 yyr2[] =
        2,     2,     1,     0,     1,     1,     4,     4,     2,     3,
        3,     3,     0,     1,     2,     3,     3,     0,     1,     1,
        2,     3,     2,     0,     1,     1,     3,     2,     2,     1,
-       2,     0,     2,     2,     0,     1,     5
+       2,     0,     2,     3,     4,     1,     3,     1,     3,     2,
+       0,     1,     5
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -659,17 +634,18 @@ static const yytype_uint8 yydefact[] =
       62,    53,     0,    31,     0,    52,    32,    48,    49,    29,
       65,    47,    50,    30,     0,     8,     0,    51,    54,    63,
        0,     0,     0,    64,    56,     5,    10,    17,    23,    24,
-      26,    27,    33,    34,    11,    12,    13,    14,    15,    43,
-      39,     6,    37,     0,    44,    22,    38,    45,     0,     0,
-     123,    68,     0,    58,     0,    18,    19,     0,   124,    67,
-      25,    42,    22,    40,     0,   113,     0,     0,   109,     9,
-      17,    41,     0,     0,     0,     0,    57,    59,    60,    16,
-       0,    66,   125,   101,   121,    71,     0,     7,   112,   106,
-      76,    77,     0,     0,     0,   121,    75,     0,   114,   115,
-     119,   105,     0,   110,   124,     0,    36,     0,    73,    72,
-      61,    20,   102,     0,    93,     0,    84,    87,    88,   118,
+      26,    27,    33,    34,    11,    12,    13,    14,    15,    39,
+       0,    43,     6,    37,     0,    44,    22,    38,    45,     0,
+       0,   129,    68,     0,    58,     0,    18,    19,     0,   130,
+      67,    25,    42,   127,     0,   125,    22,    40,     0,   113,
+       0,     0,   109,     9,    17,    41,     0,     0,     0,     0,
+      57,    59,    60,    16,     0,    66,   131,   101,   121,    71,
+       0,     0,   123,     0,     7,   112,   106,    76,    77,     0,
+       0,     0,   121,    75,     0,   114,   115,   119,   105,     0,
+     110,   130,     0,    36,     0,    73,    72,    61,    20,   102,
+       0,    93,     0,    84,    87,    88,   128,   124,   126,   118,
        0,    76,     0,   120,    74,   117,    80,     0,   111,     0,
-      35,   126,   122,     0,    21,   103,    70,    94,    56,     0,
+      35,   132,   122,     0,    21,   103,    70,    94,    56,     0,
       93,    90,    92,    69,    83,     0,    82,    81,     0,     0,
      116,   104,     0,    95,     0,    91,    98,     0,    85,    89,
       79,    78,   100,    99,     0,     0,    97,    96
@@ -678,46 +654,47 @@ static const yytype_uint8 yydefact[] =
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int16 yydefgoto[] =
 {
-      -1,     1,     2,     3,    35,    72,    55,    36,    64,    65,
-      66,    75,    38,    39,    40,    41,    42,    67,    86,    87,
-      43,   114,    69,   105,   106,   125,   126,   127,   128,   151,
-     152,    44,   144,   145,    54,    76,    77,    78,   107,   108,
-     109,   110,   122,    45,    94,    46
+      -1,     1,     2,     3,    35,    76,    56,    36,    65,    66,
+      67,    79,    38,    39,    40,    41,    42,    68,    90,    91,
+      43,   121,    70,   112,   113,   132,   133,   134,   135,   161,
+     162,    44,   154,   155,    55,    80,    81,    82,   114,   115,
+     116,   117,   129,    51,    74,    75,    45,    98,    46
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -134
+#define YYPACT_NINF -135
 static const yytype_int16 yypact[] =
 {
-    -134,    16,  -134,   312,  -134,  -134,    20,  -134,  -134,  -134,
-    -134,  -134,   -18,  -134,    -3,  -134,  -134,  -134,  -134,  -134,
-    -134,  -134,  -134,  -134,   -26,  -134,   -25,  -134,  -134,  -134,
-      -7,     5,    27,  -134,  -134,  -134,  -134,    46,   482,  -134,
-    -134,  -134,  -134,  -134,  -134,  -134,  -134,  -134,  -134,  -134,
-      -8,  -134,    30,    97,  -134,   482,    30,  -134,   482,     7,
-    -134,  -134,    12,    10,    42,    55,  -134,    46,   -15,    15,
-    -134,  -134,   482,  -134,    25,    26,    47,   145,  -134,  -134,
-      46,  -134,   356,    39,    71,    77,  -134,    10,  -134,  -134,
-      46,  -134,  -134,  -134,  -134,  -134,   193,  -134,  -134,  -134,
-      75,  -134,     6,    95,    43,  -134,    28,    86,    85,  -134,
-    -134,  -134,    88,  -134,   103,    87,  -134,    91,  -134,  -134,
-    -134,  -134,   -23,    90,   401,    94,   101,   102,  -134,  -134,
-      98,  -134,   108,  -134,  -134,   109,  -134,   230,  -134,    26,
-    -134,  -134,  -134,   134,  -134,  -134,  -134,  -134,  -134,     9,
-      48,  -134,    35,  -134,  -134,   445,  -134,  -134,   125,   126,
-    -134,  -134,   128,  -134,   129,  -134,  -134,   267,  -134,  -134,
-    -134,  -134,  -134,  -134,   130,   131,  -134,  -134
+    -135,    20,  -135,   321,  -135,  -135,    30,  -135,  -135,  -135,
+    -135,  -135,   -28,  -135,     2,  -135,  -135,  -135,  -135,  -135,
+    -135,  -135,  -135,  -135,    -6,  -135,     9,  -135,  -135,  -135,
+      -5,    15,   -17,  -135,  -135,  -135,  -135,    18,   491,  -135,
+    -135,  -135,  -135,  -135,  -135,  -135,  -135,  -135,  -135,   -22,
+      31,  -135,  -135,    19,   106,  -135,   491,    19,  -135,   491,
+      50,  -135,  -135,    11,    -3,    51,    57,  -135,    18,   -14,
+      14,  -135,  -135,    48,    46,  -135,   491,  -135,    33,    32,
+      59,   154,  -135,  -135,    18,  -135,   365,    56,    60,    61,
+    -135,    -3,  -135,  -135,    18,  -135,  -135,  -135,  -135,  -135,
+     202,    74,  -135,   -23,  -135,  -135,  -135,    77,  -135,    16,
+     101,    49,  -135,    34,    92,    93,  -135,  -135,  -135,    94,
+    -135,   110,    95,  -135,    97,  -135,  -135,  -135,  -135,   -20,
+      96,   410,    99,   113,   100,  -135,  -135,  -135,  -135,  -135,
+     103,  -135,   107,  -135,  -135,   111,  -135,   239,  -135,    32,
+    -135,  -135,  -135,   123,  -135,  -135,  -135,  -135,  -135,     3,
+      52,  -135,    38,  -135,  -135,   454,  -135,  -135,   117,   128,
+    -135,  -135,   134,  -135,   135,  -135,  -135,   276,  -135,  -135,
+    -135,  -135,  -135,  -135,   137,   138,  -135,  -135
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int16 yypgoto[] =
 {
-    -134,  -134,   180,  -134,  -134,  -134,  -134,   -33,  -134,  -134,
-      93,     0,   -58,   -37,  -134,  -134,  -134,   -73,  -134,  -134,
-     -54,   -32,  -134,   -81,  -134,  -133,  -134,  -134,    29,   -50,
-    -134,  -134,  -134,  -134,   -20,  -134,  -134,   110,  -134,  -134,
-      49,    96,    80,  -134,  -134,  -134
+    -135,  -135,   187,  -135,  -135,  -135,  -135,   -50,  -135,  -135,
+      98,     0,   -59,   -37,  -135,  -135,  -135,   -77,  -135,  -135,
+     -54,   -30,  -135,   -90,  -135,  -134,  -135,  -135,    24,   -58,
+    -135,  -135,  -135,  -135,   -18,  -135,  -135,   109,  -135,  -135,
+      44,    87,    84,   148,  -135,   102,  -135,  -135,  -135
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
@@ -727,116 +704,118 @@ static const yytype_int16 yypgoto[] =
 #define YYTABLE_NINF -109
 static const yytype_int16 yytable[] =
 {
-      82,    70,   104,    37,   159,    68,    57,   130,   142,    88,
-     162,    52,    56,    84,    49,    92,     4,    93,    10,    50,
-      51,   132,    79,   134,    71,    53,    53,   143,    20,   104,
-      85,   104,    73,   120,   175,    91,    81,    29,   124,    97,
-      58,    33,   -93,   131,    83,    70,   147,   101,    95,    61,
-     163,   150,    59,   102,    63,    80,   149,    63,   -93,    62,
-      63,   136,    96,   100,    47,    48,   104,   101,   166,    98,
-      99,    60,    80,   102,    63,   137,   150,   150,   103,   124,
-     131,    53,   167,    61,   101,   147,    89,    70,   117,   163,
-     102,    63,   111,    62,    63,   149,    63,   124,    74,   164,
-     165,    90,     7,     8,     9,    10,    11,    12,    13,   124,
-      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
-     118,    26,    27,    28,    29,    30,   119,   103,    33,   133,
-     138,   139,    98,    92,   -22,   141,   140,   154,    34,   146,
-     142,   -22,  -107,   153,   -22,   -22,   112,   156,   155,   -22,
-       7,     8,     9,    10,    11,    12,    13,   157,    15,    16,
-      17,    18,    19,    20,    21,    22,    23,    24,   161,    26,
-      27,    28,    29,    30,   170,   171,    33,   172,   173,   176,
-     177,     5,   -22,   121,   169,   135,    34,   113,   160,   -22,
-    -108,     0,   -22,   -22,   123,     0,   129,   -22,     7,     8,
-       9,    10,    11,    12,    13,     0,    15,    16,    17,    18,
-      19,    20,    21,    22,    23,    24,     0,    26,    27,    28,
-      29,    30,     0,     0,    33,     0,     0,     0,     0,   -86,
-       0,   158,     0,     0,    34,     7,     8,     9,    10,    11,
-      12,    13,   -86,    15,    16,    17,    18,    19,    20,    21,
-      22,    23,    24,     0,    26,    27,    28,    29,    30,     0,
-       0,    33,     0,     0,     0,     0,   -86,     0,   174,     0,
-       0,    34,     7,     8,     9,    10,    11,    12,    13,   -86,
-      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
-       0,    26,    27,    28,    29,    30,     0,     0,    33,     0,
-       0,     0,     0,   -86,     0,     0,     0,     0,    34,     0,
-       0,     0,     0,     6,     0,     0,   -86,     7,     8,     9,
-      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
-      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
-      30,    31,    32,    33,     0,     0,     0,     0,     0,   -22,
-       0,     0,     0,    34,     0,     0,   -22,     0,     0,   -22,
-     -22,     7,     8,     9,    10,    11,    12,    13,     0,    15,
+      86,    71,   111,    37,   172,    10,    83,    69,    58,    49,
+      92,   152,    88,   169,    73,    20,    96,   140,    97,   142,
+       4,   144,   137,    50,    29,    52,   104,    61,    33,    50,
+     153,    53,   111,    89,   111,    77,   -93,   127,    95,    85,
+     157,   131,    59,   185,   173,    54,    57,    99,    62,    71,
+     159,    64,   -93,   141,   160,    62,    84,   108,    63,    64,
+      54,   100,    60,   109,    64,    63,    64,   146,    73,   107,
+      54,   176,   111,   108,    47,    48,    84,   105,   106,   109,
+      64,   147,   160,   160,   110,   177,   141,    87,   131,   157,
+     108,   102,   103,   173,    71,    93,   109,    64,   101,   159,
+      64,   174,   175,    94,   118,   124,   131,    78,   136,   125,
+     126,     7,     8,     9,    10,    11,    12,    13,   131,    15,
+      16,    17,    18,    19,    20,    21,    22,    23,    24,   110,
+      26,    27,    28,    29,    30,   143,   148,    33,   105,   149,
+      96,   151,   152,   -22,   150,   156,   165,    34,   163,   164,
+     -22,  -107,   166,   -22,   -22,   119,   167,   171,   -22,     7,
+       8,     9,    10,    11,    12,    13,   180,    15,    16,    17,
+      18,    19,    20,    21,    22,    23,    24,   181,    26,    27,
+      28,    29,    30,   182,   183,    33,   186,   187,     5,   179,
+     120,   -22,   128,   170,   139,    34,   145,    72,   -22,  -108,
+       0,   -22,   -22,   130,     0,   138,   -22,     7,     8,     9,
+      10,    11,    12,    13,     0,    15,    16,    17,    18,    19,
+      20,    21,    22,    23,    24,     0,    26,    27,    28,    29,
+      30,     0,     0,    33,     0,     0,     0,     0,   -86,     0,
+     168,     0,     0,    34,     7,     8,     9,    10,    11,    12,
+      13,   -86,    15,    16,    17,    18,    19,    20,    21,    22,
+      23,    24,     0,    26,    27,    28,    29,    30,     0,     0,
+      33,     0,     0,     0,     0,   -86,     0,   184,     0,     0,
+      34,     7,     8,     9,    10,    11,    12,    13,   -86,    15,
       16,    17,    18,    19,    20,    21,    22,    23,    24,     0,
       26,    27,    28,    29,    30,     0,     0,    33,     0,     0,
-       0,     0,     0,     0,     0,     0,     0,    34,     0,     0,
-       0,     0,     0,     0,   115,   116,     7,     8,     9,    10,
-      11,    12,    13,     0,    15,    16,    17,    18,    19,    20,
-      21,    22,    23,    24,     0,    26,    27,    28,    29,    30,
-       0,     0,    33,     0,     0,     0,     0,     0,   147,     0,
-       0,     0,   148,     0,     0,     0,     0,     0,   149,    63,
+       0,     0,   -86,     0,     0,     0,     0,    34,     0,     0,
+       0,     0,     6,     0,     0,   -86,     7,     8,     9,    10,
+      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
+      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
+      31,    32,    33,     0,     0,     0,     0,     0,   -22,     0,
+       0,     0,    34,     0,     0,   -22,     0,     0,   -22,   -22,
        7,     8,     9,    10,    11,    12,    13,     0,    15,    16,
       17,    18,    19,    20,    21,    22,    23,    24,     0,    26,
       27,    28,    29,    30,     0,     0,    33,     0,     0,     0,
-       0,   168,     0,     0,     0,     0,    34,     7,     8,     9,
-      10,    11,    12,    13,     0,    15,    16,    17,    18,    19,
-      20,    21,    22,    23,    24,     0,    26,    27,    28,    29,
-      30,     0,     0,    33,     0,     0,     0,     0,     0,     0,
-       0,     0,     0,    34
+       0,     0,     0,     0,     0,     0,    34,     0,     0,     0,
+       0,     0,     0,   122,   123,     7,     8,     9,    10,    11,
+      12,    13,     0,    15,    16,    17,    18,    19,    20,    21,
+      22,    23,    24,     0,    26,    27,    28,    29,    30,     0,
+       0,    33,     0,     0,     0,     0,     0,   157,     0,     0,
+       0,   158,     0,     0,     0,     0,     0,   159,    64,     7,
+       8,     9,    10,    11,    12,    13,     0,    15,    16,    17,
+      18,    19,    20,    21,    22,    23,    24,     0,    26,    27,
+      28,    29,    30,     0,     0,    33,     0,     0,     0,     0,
+     178,     0,     0,     0,     0,    34,     7,     8,     9,    10,
+      11,    12,    13,     0,    15,    16,    17,    18,    19,    20,
+      21,    22,    23,    24,     0,    26,    27,    28,    29,    30,
+       0,     0,    33,     0,     0,     0,     0,     0,     0,     0,
+       0,     0,    34
 };
 
 static const yytype_int16 yycheck[] =
 {
-      58,    38,    75,     3,   137,    37,    26,     1,    31,    63,
-       1,    37,    37,     1,    32,    30,     0,    32,     8,    37,
-      23,   102,    55,   104,    32,    51,    51,    50,    18,   102,
-      62,   104,    52,    87,   167,    67,    56,    27,    96,    72,
-      47,    31,    33,    37,    37,    82,    37,    41,    33,    37,
-      41,   124,    47,    47,    48,    55,    47,    48,    49,    47,
-      48,    33,    47,    37,    44,    45,   139,    41,    33,    44,
-      45,    44,    72,    47,    48,    47,   149,   150,    52,   137,
-      37,    51,    47,    37,    41,    37,    44,   124,    49,    41,
-      47,    48,    45,    47,    48,    47,    48,   155,     1,   149,
-     150,    46,     5,     6,     7,     8,     9,    10,    11,   167,
-      13,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      49,    24,    25,    26,    27,    28,    49,    52,    31,    34,
-      44,    46,    44,    30,    37,    44,    49,    36,    41,    49,
-      31,    44,    45,    49,    47,    48,     1,    49,    46,    52,
-       5,     6,     7,     8,     9,    10,    11,    49,    13,    14,
-      15,    16,    17,    18,    19,    20,    21,    22,    34,    24,
-      25,    26,    27,    28,    49,    49,    31,    49,    49,    49,
-      49,     1,    37,    90,   155,   105,    41,    77,   139,    44,
-      45,    -1,    47,    48,     1,    -1,   100,    52,     5,     6,
-       7,     8,     9,    10,    11,    -1,    13,    14,    15,    16,
-      17,    18,    19,    20,    21,    22,    -1,    24,    25,    26,
-      27,    28,    -1,    -1,    31,    -1,    -1,    -1,    -1,    36,
-      -1,     1,    -1,    -1,    41,     5,     6,     7,     8,     9,
-      10,    11,    49,    13,    14,    15,    16,    17,    18,    19,
-      20,    21,    22,    -1,    24,    25,    26,    27,    28,    -1,
-      -1,    31,    -1,    -1,    -1,    -1,    36,    -1,     1,    -1,
-      -1,    41,     5,     6,     7,     8,     9,    10,    11,    49,
-      13,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      -1,    24,    25,    26,    27,    28,    -1,    -1,    31,    -1,
-      -1,    -1,    -1,    36,    -1,    -1,    -1,    -1,    41,    -1,
-      -1,    -1,    -1,     1,    -1,    -1,    49,     5,     6,     7,
-       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
-      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
-      28,    29,    30,    31,    -1,    -1,    -1,    -1,    -1,    37,
-      -1,    -1,    -1,    41,    -1,    -1,    44,    -1,    -1,    47,
-      48,     5,     6,     7,     8,     9,    10,    11,    -1,    13,
+      59,    38,    79,     3,     1,     8,    56,    37,    26,    37,
+      64,    31,     1,   147,    37,    18,    30,     1,    32,   109,
+       0,   111,    45,    51,    27,    23,    76,    44,    31,    51,
+      50,    37,   109,    63,   111,    53,    33,    91,    68,    57,
+      37,   100,    47,   177,    41,    51,    37,    33,    37,    86,
+      47,    48,    49,    37,   131,    37,    56,    41,    47,    48,
+      51,    47,    47,    47,    48,    47,    48,    33,    37,    37,
+      51,    33,   149,    41,    44,    45,    76,    44,    45,    47,
+      48,    47,   159,   160,    52,    47,    37,    37,   147,    37,
+      41,    45,    46,    41,   131,    44,    47,    48,    50,    47,
+      48,   159,   160,    46,    45,    49,   165,     1,    34,    49,
+      49,     5,     6,     7,     8,     9,    10,    11,   177,    13,
+      14,    15,    16,    17,    18,    19,    20,    21,    22,    52,
+      24,    25,    26,    27,    28,    34,    44,    31,    44,    46,
+      30,    44,    31,    37,    49,    49,    46,    41,    49,    36,
+      44,    45,    49,    47,    48,     1,    49,    34,    52,     5,
+       6,     7,     8,     9,    10,    11,    49,    13,    14,    15,
+      16,    17,    18,    19,    20,    21,    22,    49,    24,    25,
+      26,    27,    28,    49,    49,    31,    49,    49,     1,   165,
+      81,    37,    94,   149,   107,    41,   112,    49,    44,    45,
+      -1,    47,    48,     1,    -1,   103,    52,     5,     6,     7,
+       8,     9,    10,    11,    -1,    13,    14,    15,    16,    17,
+      18,    19,    20,    21,    22,    -1,    24,    25,    26,    27,
+      28,    -1,    -1,    31,    -1,    -1,    -1,    -1,    36,    -1,
+       1,    -1,    -1,    41,     5,     6,     7,     8,     9,    10,
+      11,    49,    13,    14,    15,    16,    17,    18,    19,    20,
+      21,    22,    -1,    24,    25,    26,    27,    28,    -1,    -1,
+      31,    -1,    -1,    -1,    -1,    36,    -1,     1,    -1,    -1,
+      41,     5,     6,     7,     8,     9,    10,    11,    49,    13,
       14,    15,    16,    17,    18,    19,    20,    21,    22,    -1,
       24,    25,    26,    27,    28,    -1,    -1,    31,    -1,    -1,
-      -1,    -1,    -1,    -1,    -1,    -1,    -1,    41,    -1,    -1,
-      -1,    -1,    -1,    -1,    48,    49,     5,     6,     7,     8,
-       9,    10,    11,    -1,    13,    14,    15,    16,    17,    18,
-      19,    20,    21,    22,    -1,    24,    25,    26,    27,    28,
-      -1,    -1,    31,    -1,    -1,    -1,    -1,    -1,    37,    -1,
-      -1,    -1,    41,    -1,    -1,    -1,    -1,    -1,    47,    48,
+      -1,    -1,    36,    -1,    -1,    -1,    -1,    41,    -1,    -1,
+      -1,    -1,     1,    -1,    -1,    49,     5,     6,     7,     8,
+       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
+      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
+      29,    30,    31,    -1,    -1,    -1,    -1,    -1,    37,    -1,
+      -1,    -1,    41,    -1,    -1,    44,    -1,    -1,    47,    48,
        5,     6,     7,     8,     9,    10,    11,    -1,    13,    14,
       15,    16,    17,    18,    19,    20,    21,    22,    -1,    24,
       25,    26,    27,    28,    -1,    -1,    31,    -1,    -1,    -1,
-      -1,    36,    -1,    -1,    -1,    -1,    41,     5,     6,     7,
-       8,     9,    10,    11,    -1,    13,    14,    15,    16,    17,
-      18,    19,    20,    21,    22,    -1,    24,    25,    26,    27,
-      28,    -1,    -1,    31,    -1,    -1,    -1,    -1,    -1,    -1,
-      -1,    -1,    -1,    41
+      -1,    -1,    -1,    -1,    -1,    -1,    41,    -1,    -1,    -1,
+      -1,    -1,    -1,    48,    49,     5,     6,     7,     8,     9,
+      10,    11,    -1,    13,    14,    15,    16,    17,    18,    19,
+      20,    21,    22,    -1,    24,    25,    26,    27,    28,    -1,
+      -1,    31,    -1,    -1,    -1,    -1,    -1,    37,    -1,    -1,
+      -1,    41,    -1,    -1,    -1,    -1,    -1,    47,    48,     5,
+       6,     7,     8,     9,    10,    11,    -1,    13,    14,    15,
+      16,    17,    18,    19,    20,    21,    22,    -1,    24,    25,
+      26,    27,    28,    -1,    -1,    31,    -1,    -1,    -1,    -1,
+      36,    -1,    -1,    -1,    -1,    41,     5,     6,     7,     8,
+       9,    10,    11,    -1,    13,    14,    15,    16,    17,    18,
+      19,    20,    21,    22,    -1,    24,    25,    26,    27,    28,
+      -1,    -1,    31,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
+      -1,    -1,    41
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
@@ -847,15 +826,16 @@ static const yytype_uint8 yystos[] =
        8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
       18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
       28,    29,    30,    31,    41,    57,    60,    64,    65,    66,
-      67,    68,    69,    73,    84,    96,    98,    44,    45,    32,
-      37,    23,    37,    51,    87,    59,    37,    87,    47,    47,
-      44,    37,    47,    48,    61,    62,    63,    70,    74,    75,
-      66,    32,    58,    87,     1,    64,    88,    89,    90,    60,
-      64,    87,    65,    37,     1,    74,    71,    72,    73,    44,
-      46,    74,    30,    32,    97,    33,    47,    60,    44,    45,
-      37,    41,    47,    52,    70,    76,    77,    91,    92,    93,
-      94,    45,     1,    90,    74,    48,    49,    49,    49,    49,
-      73,    63,    95,     1,    65,    78,    79,    80,    81,    94,
+      67,    68,    69,    73,    84,    99,   101,    44,    45,    37,
+      51,    96,    23,    37,    51,    87,    59,    37,    87,    47,
+      47,    44,    37,    47,    48,    61,    62,    63,    70,    74,
+      75,    66,    96,    37,    97,    98,    58,    87,     1,    64,
+      88,    89,    90,    60,    64,    87,    65,    37,     1,    74,
+      71,    72,    73,    44,    46,    74,    30,    32,   100,    33,
+      47,    50,    45,    46,    60,    44,    45,    37,    41,    47,
+      52,    70,    76,    77,    91,    92,    93,    94,    45,     1,
+      90,    74,    48,    49,    49,    49,    49,    73,    63,    95,
+       1,    65,    78,    79,    80,    81,    34,    45,    98,    94,
        1,    37,    76,    34,    76,    95,    33,    47,    44,    46,
       49,    44,    31,    50,    85,    86,    49,    37,    41,    47,
       70,    82,    83,    49,    36,    46,    49,    49,     1,    78,
@@ -1045,17 +1025,20 @@ yy_symbol_print (yyoutput, yytype, yyvaluep)
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 static void
-yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
+yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
 #else
 static void
-yy_stack_print (bottom, top)
-    yytype_int16 *bottom;
-    yytype_int16 *top;
+yy_stack_print (yybottom, yytop)
+    yytype_int16 *yybottom;
+    yytype_int16 *yytop;
 #endif
 {
   YYFPRINTF (stderr, "Stack now");
-  for (; bottom <= top; ++bottom)
-    YYFPRINTF (stderr, " %d", *bottom);
+  for (; yybottom <= yytop; yybottom++)
+    {
+      int yybot = *yybottom;
+      YYFPRINTF (stderr, " %d", yybot);
+    }
   YYFPRINTF (stderr, "\n");
 }
 
@@ -1089,11 +1072,11 @@ yy_reduce_print (yyvsp, yyrule)
   /* The symbols being reduced.  */
   for (yyi = 0; yyi < yynrhs; yyi++)
     {
-      fprintf (stderr, "   $%d = ", yyi + 1);
+      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
       yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
 		       &(yyvsp[(yyi + 1) - (yynrhs)])
 		       		       );
-      fprintf (stderr, "\n");
+      YYFPRINTF (stderr, "\n");
     }
 }
 
@@ -1373,10 +1356,8 @@ yydestruct (yymsg, yytype, yyvaluep)
 	break;
     }
 }
-
 
 /* Prevent warnings from -Wmissing-prototypes.  */
-
 #ifdef YYPARSE_PARAM
 #if defined __STDC__ || defined __cplusplus
 int yyparse (void *YYPARSE_PARAM);
@@ -1392,11 +1373,10 @@ int yyparse ();
 #endif /* ! YYPARSE_PARAM */
 
 
-
-/* The look-ahead symbol.  */
+/* The lookahead symbol.  */
 int yychar;
 
-/* The semantic value of the look-ahead symbol.  */
+/* The semantic value of the lookahead symbol.  */
 YYSTYPE yylval;
 
 /* Number of syntax errors so far.  */
@@ -1404,9 +1384,9 @@ int yynerrs;
 
 
 
-/*----------.
-| yyparse.  |
-`----------*/
+/*-------------------------.
+| yyparse or yypush_parse.  |
+`-------------------------*/
 
 #ifdef YYPARSE_PARAM
 #if (defined __STDC__ || defined __C99__FUNC__ \
@@ -1430,66 +1410,68 @@ yyparse ()
 #endif
 #endif
 {
-  
-  int yystate;
-  int yyn;
-  int yyresult;
-  /* Number of tokens to shift before error messages enabled.  */
-  int yyerrstatus;
-  /* Look-ahead token as an internal (translated) token number.  */
-  int yytoken = 0;
-#if YYERROR_VERBOSE
-  /* Buffer for error messages, and its allocated size.  */
-  char yymsgbuf[128];
-  char *yymsg = yymsgbuf;
-  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
-#endif
 
-  /* Three stacks and their tools:
-     `yyss': related to states,
-     `yyvs': related to semantic values,
-     `yyls': related to locations.
 
-     Refer to the stacks thru separate pointers, to allow yyoverflow
-     to reallocate them elsewhere.  */
+    int yystate;
+    /* Number of tokens to shift before error messages enabled.  */
+    int yyerrstatus;
 
-  /* The state stack.  */
-  yytype_int16 yyssa[YYINITDEPTH];
-  yytype_int16 *yyss = yyssa;
-  yytype_int16 *yyssp;
+    /* The stacks and their tools:
+       `yyss': related to states.
+       `yyvs': related to semantic values.
 
-  /* The semantic value stack.  */
-  YYSTYPE yyvsa[YYINITDEPTH];
-  YYSTYPE *yyvs = yyvsa;
-  YYSTYPE *yyvsp;
+       Refer to the stacks thru separate pointers, to allow yyoverflow
+       to reallocate them elsewhere.  */
 
+    /* The state stack.  */
+    yytype_int16 yyssa[YYINITDEPTH];
+    yytype_int16 *yyss;
+    yytype_int16 *yyssp;
 
+    /* The semantic value stack.  */
+    YYSTYPE yyvsa[YYINITDEPTH];
+    YYSTYPE *yyvs;
+    YYSTYPE *yyvsp;
 
-#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))
-
-  YYSIZE_T yystacksize = YYINITDEPTH;
+    YYSIZE_T yystacksize;
 
+  int yyn;
+  int yyresult;
+  /* Lookahead token as an internal (translated) token number.  */
+  int yytoken;
   /* The variables used to return semantic value and location from the
      action routines.  */
   YYSTYPE yyval;
 
+#if YYERROR_VERBOSE
+  /* Buffer for error messages, and its allocated size.  */
+  char yymsgbuf[128];
+  char *yymsg = yymsgbuf;
+  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
+#endif
+
+#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))
 
   /* The number of symbols on the RHS of the reduced rule.
      Keep to zero when no symbol should be popped.  */
   int yylen = 0;
 
+  yytoken = 0;
+  yyss = yyssa;
+  yyvs = yyvsa;
+  yystacksize = YYINITDEPTH;
+
   YYDPRINTF ((stderr, "Starting parse\n"));
 
   yystate = 0;
   yyerrstatus = 0;
   yynerrs = 0;
-  yychar = YYEMPTY;		/* Cause a token to be read.  */
+  yychar = YYEMPTY; /* Cause a token to be read.  */
 
   /* Initialize stack pointers.
      Waste one element of value and location stack
      so that they stay on the same level as the state stack.
      The wasted elements are never initialized.  */
-
   yyssp = yyss;
   yyvsp = yyvs;
 
@@ -1519,7 +1501,6 @@ yyparse ()
 	YYSTYPE *yyvs1 = yyvs;
 	yytype_int16 *yyss1 = yyss;
 
-
 	/* Each stack pointer address is followed by the size of the
 	   data in use in that stack, in bytes.  This used to be a
 	   conditional around just the two extra args, but that might
@@ -1527,7 +1508,6 @@ yyparse ()
 	yyoverflow (YY_("memory exhausted"),
 		    &yyss1, yysize * sizeof (*yyssp),
 		    &yyvs1, yysize * sizeof (*yyvsp),
-
 		    &yystacksize);
 
 	yyss = yyss1;
@@ -1550,9 +1530,8 @@ yyparse ()
 	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
 	if (! yyptr)
 	  goto yyexhaustedlab;
-	YYSTACK_RELOCATE (yyss);
-	YYSTACK_RELOCATE (yyvs);
-
+	YYSTACK_RELOCATE (yyss_alloc, yyss);
+	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
 #  undef YYSTACK_RELOCATE
 	if (yyss1 != yyssa)
 	  YYSTACK_FREE (yyss1);
@@ -1563,7 +1542,6 @@ yyparse ()
       yyssp = yyss + yysize - 1;
       yyvsp = yyvs + yysize - 1;
 
-
       YYDPRINTF ((stderr, "Stack size increased to %lu\n",
 		  (unsigned long int) yystacksize));
 
@@ -1573,6 +1551,9 @@ yyparse ()
 
   YYDPRINTF ((stderr, "Entering state %d\n", yystate));
 
+  if (yystate == YYFINAL)
+    YYACCEPT;
+
   goto yybackup;
 
 /*-----------.
@@ -1581,16 +1562,16 @@ yyparse ()
 yybackup:
 
   /* Do appropriate processing given the current state.  Read a
-     look-ahead token if we need one and don't already have one.  */
+     lookahead token if we need one and don't already have one.  */
 
-  /* First try to decide what to do without reference to look-ahead token.  */
+  /* First try to decide what to do without reference to lookahead token.  */
   yyn = yypact[yystate];
   if (yyn == YYPACT_NINF)
     goto yydefault;
 
-  /* Not known => get a look-ahead token if don't already have one.  */
+  /* Not known => get a lookahead token if don't already have one.  */
 
-  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
+  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
   if (yychar == YYEMPTY)
     {
       YYDPRINTF ((stderr, "Reading a token: "));
@@ -1622,20 +1603,16 @@ yybackup:
       goto yyreduce;
     }
 
-  if (yyn == YYFINAL)
-    YYACCEPT;
-
   /* Count tokens shifted since error; after three, turn off error
      status.  */
   if (yyerrstatus)
     yyerrstatus--;
 
-  /* Shift the look-ahead token.  */
+  /* Shift the lookahead token.  */
   YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
 
-  /* Discard the shifted token unless it is eof.  */
-  if (yychar != YYEOF)
-    yychar = YYEMPTY;
+  /* Discard the shifted token.  */
+  yychar = YYEMPTY;
 
   yystate = yyn;
   *++yyvsp = yylval;
@@ -1675,47 +1652,65 @@ yyreduce:
   switch (yyn)
     {
         case 4:
-#line 108 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 109 "scripts/genksyms/parse.y"
     { is_typedef = 0; is_extern = 0; current_name = NULL; decl_spec = NULL; ;}
     break;
 
   case 5:
-#line 110 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 111 "scripts/genksyms/parse.y"
     { free_list(*(yyvsp[(2) - (2)]), NULL); *(yyvsp[(2) - (2)]) = NULL; ;}
     break;
 
   case 6:
-#line 114 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 115 "scripts/genksyms/parse.y"
     { is_typedef = 1; ;}
     break;
 
   case 7:
-#line 115 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 116 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
 
   case 8:
-#line 116 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 117 "scripts/genksyms/parse.y"
     { is_typedef = 1; ;}
     break;
 
   case 9:
-#line 117 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 118 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 14:
-#line 122 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 123 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 15:
-#line 123 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 124 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 16:
-#line 128 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 129 "scripts/genksyms/parse.y"
     { if (current_name) {
 		    struct string_list *decl = (*(yyvsp[(3) - (3)]))->next;
 		    (*(yyvsp[(3) - (3)]))->next = NULL;
@@ -1729,12 +1724,16 @@ yyreduce:
     break;
 
   case 17:
-#line 141 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 142 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
 
   case 19:
-#line 147 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 148 "scripts/genksyms/parse.y"
     { struct string_list *decl = *(yyvsp[(1) - (1)]);
 		  *(yyvsp[(1) - (1)]) = NULL;
 		  add_symbol(current_name,
@@ -1745,7 +1744,9 @@ yyreduce:
     break;
 
   case 20:
-#line 155 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 156 "scripts/genksyms/parse.y"
     { struct string_list *decl = *(yyvsp[(3) - (3)]);
 		  *(yyvsp[(3) - (3)]) = NULL;
 		  free_list(*(yyvsp[(2) - (3)]), NULL);
@@ -1758,27 +1759,37 @@ yyreduce:
     break;
 
   case 21:
-#line 168 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 169 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]) ? (yyvsp[(4) - (4)]) : (yyvsp[(3) - (4)]) ? (yyvsp[(3) - (4)]) : (yyvsp[(2) - (4)]) ? (yyvsp[(2) - (4)]) : (yyvsp[(1) - (4)]); ;}
     break;
 
   case 22:
-#line 173 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 174 "scripts/genksyms/parse.y"
     { decl_spec = NULL; ;}
     break;
 
   case 24:
-#line 178 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 179 "scripts/genksyms/parse.y"
     { decl_spec = *(yyvsp[(1) - (1)]); ;}
     break;
 
   case 25:
-#line 179 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 180 "scripts/genksyms/parse.y"
     { decl_spec = *(yyvsp[(2) - (2)]); ;}
     break;
 
   case 26:
-#line 184 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 185 "scripts/genksyms/parse.y"
     { /* Version 2 checksumming ignores storage class, as that
 		     is really irrelevant to the linkage.  */
 		  remove_node((yyvsp[(1) - (1)]));
@@ -1787,32 +1798,44 @@ yyreduce:
     break;
 
   case 31:
-#line 196 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 197 "scripts/genksyms/parse.y"
     { is_extern = 1; (yyval) = (yyvsp[(1) - (1)]); ;}
     break;
 
   case 32:
-#line 197 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 198 "scripts/genksyms/parse.y"
     { is_extern = 0; (yyval) = (yyvsp[(1) - (1)]); ;}
     break;
 
   case 37:
-#line 209 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 210 "scripts/genksyms/parse.y"
     { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_STRUCT; (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 38:
-#line 211 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 212 "scripts/genksyms/parse.y"
     { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_UNION; (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 39:
-#line 213 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 214 "scripts/genksyms/parse.y"
     { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_ENUM; (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 40:
-#line 217 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 218 "scripts/genksyms/parse.y"
     { struct string_list *s = *(yyvsp[(3) - (3)]), *i = *(yyvsp[(2) - (3)]), *r;
 		  r = copy_node(i); r->tag = SYM_STRUCT;
 		  r->next = (*(yyvsp[(1) - (3)]))->next; *(yyvsp[(3) - (3)]) = r; (*(yyvsp[(1) - (3)]))->next = NULL;
@@ -1822,7 +1845,9 @@ yyreduce:
     break;
 
   case 41:
-#line 224 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 225 "scripts/genksyms/parse.y"
     { struct string_list *s = *(yyvsp[(3) - (3)]), *i = *(yyvsp[(2) - (3)]), *r;
 		  r = copy_node(i); r->tag = SYM_UNION;
 		  r->next = (*(yyvsp[(1) - (3)]))->next; *(yyvsp[(3) - (3)]) = r; (*(yyvsp[(1) - (3)]))->next = NULL;
@@ -1832,7 +1857,9 @@ yyreduce:
     break;
 
   case 42:
-#line 231 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 232 "scripts/genksyms/parse.y"
     { struct string_list *s = *(yyvsp[(3) - (3)]), *i = *(yyvsp[(2) - (3)]), *r;
 		  r = copy_node(i); r->tag = SYM_ENUM;
 		  r->next = (*(yyvsp[(1) - (3)]))->next; *(yyvsp[(3) - (3)]) = r; (*(yyvsp[(1) - (3)]))->next = NULL;
@@ -1842,42 +1869,58 @@ yyreduce:
     break;
 
   case 43:
-#line 239 "scripts/genksyms/parse.y"
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+
+/* Line 1455 of yacc.c  */
+#line 242 "scripts/genksyms/parse.y"
+    { add_symbol(NULL, SYM_ENUM, NULL, 0); (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 44:
-#line 240 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 244 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 45:
-#line 241 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 245 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 56:
-#line 255 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 259 "scripts/genksyms/parse.y"
     { (*(yyvsp[(1) - (1)]))->tag = SYM_TYPEDEF; (yyval) = (yyvsp[(1) - (1)]); ;}
     break;
 
   case 57:
-#line 260 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 264 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
     break;
 
   case 58:
-#line 264 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 268 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
 
   case 61:
-#line 270 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 274 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 65:
-#line 276 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 280 "scripts/genksyms/parse.y"
     { /* restrict has no effect in prototypes so ignore it */
 		  remove_node((yyvsp[(1) - (1)]));
 		  (yyval) = (yyvsp[(1) - (1)]);
@@ -1885,12 +1928,16 @@ yyreduce:
     break;
 
   case 66:
-#line 283 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 287 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 68:
-#line 289 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 293 "scripts/genksyms/parse.y"
     { if (current_name != NULL) {
 		    error_with_pos("unexpected second declaration name");
 		    YYERROR;
@@ -1902,97 +1949,135 @@ yyreduce:
     break;
 
   case 69:
-#line 298 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 302 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
 
   case 70:
-#line 300 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 304 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
 
   case 71:
-#line 302 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 306 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 72:
-#line 304 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 308 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 73:
-#line 306 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 310 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 74:
-#line 312 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 316 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 78:
-#line 320 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 324 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
 
   case 79:
-#line 322 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 326 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
 
   case 80:
-#line 324 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 328 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 81:
-#line 326 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 330 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 82:
-#line 328 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 332 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 83:
-#line 332 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 336 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 85:
-#line 334 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 338 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 86:
-#line 338 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 342 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
 
   case 89:
-#line 345 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 349 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 90:
-#line 350 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 354 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
     break;
 
   case 91:
-#line 355 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 359 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
     break;
 
   case 93:
-#line 360 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 364 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
 
   case 94:
-#line 362 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 366 "scripts/genksyms/parse.y"
     { /* For version 2 checksums, we don't want to remember
 		     private parameter names.  */
 		  remove_node((yyvsp[(1) - (1)]));
@@ -2001,39 +2086,53 @@ yyreduce:
     break;
 
   case 95:
-#line 370 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 374 "scripts/genksyms/parse.y"
     { remove_node((yyvsp[(1) - (1)]));
 		  (yyval) = (yyvsp[(1) - (1)]);
 		;}
     break;
 
   case 96:
-#line 374 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 378 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
 
   case 97:
-#line 376 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 380 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
 
   case 98:
-#line 378 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 382 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 99:
-#line 380 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 384 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 100:
-#line 382 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 386 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 101:
-#line 387 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 391 "scripts/genksyms/parse.y"
     { struct string_list *decl = *(yyvsp[(2) - (3)]);
 		  *(yyvsp[(2) - (3)]) = NULL;
 		  add_symbol(current_name, SYM_NORMAL, decl, is_extern);
@@ -2042,93 +2141,163 @@ yyreduce:
     break;
 
   case 102:
-#line 395 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 399 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
 
   case 104:
-#line 402 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 406 "scripts/genksyms/parse.y"
     { remove_list((yyvsp[(2) - (2)]), &(*(yyvsp[(1) - (2)]))->next); (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 105:
-#line 406 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 410 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 106:
-#line 407 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 411 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 107:
-#line 411 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 415 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
 
   case 110:
-#line 417 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 421 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 111:
-#line 422 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 426 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 112:
-#line 424 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 428 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 113:
-#line 428 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 432 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
 
   case 116:
-#line 434 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 438 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 117:
-#line 438 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 442 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
     break;
 
   case 118:
-#line 439 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 443 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 120:
-#line 444 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 448 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
 
   case 121:
-#line 448 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 452 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
 
   case 123:
-#line 453 "scripts/genksyms/parse.y"
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+
+/* Line 1455 of yacc.c  */
+#line 457 "scripts/genksyms/parse.y"
+    { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
 
   case 124:
-#line 457 "scripts/genksyms/parse.y"
+
+/* Line 1455 of yacc.c  */
+#line 458 "scripts/genksyms/parse.y"
+    { (yyval) = (yyvsp[(4) - (4)]); ;}
+    break;
+
+  case 127:
+
+/* Line 1455 of yacc.c  */
+#line 467 "scripts/genksyms/parse.y"
+    {
+			const char *name = strdup((*(yyvsp[(1) - (1)]))->string);
+			add_symbol(name, SYM_ENUM_CONST, NULL, 0);
+		;}
+    break;
+
+  case 128:
+
+/* Line 1455 of yacc.c  */
+#line 472 "scripts/genksyms/parse.y"
+    {
+			const char *name = strdup((*(yyvsp[(1) - (3)]))->string);
+			struct string_list *expr = copy_list_range(*(yyvsp[(3) - (3)]), *(yyvsp[(2) - (3)]));
+			add_symbol(name, SYM_ENUM_CONST, expr, 0);
+		;}
+    break;
+
+  case 129:
+
+/* Line 1455 of yacc.c  */
+#line 479 "scripts/genksyms/parse.y"
+    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    break;
+
+  case 130:
+
+/* Line 1455 of yacc.c  */
+#line 483 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
 
-  case 126:
-#line 463 "scripts/genksyms/parse.y"
+  case 132:
+
+/* Line 1455 of yacc.c  */
+#line 489 "scripts/genksyms/parse.y"
     { export_symbol((*(yyvsp[(3) - (5)]))->string); (yyval) = (yyvsp[(5) - (5)]); ;}
     break;
 
 
-/* Line 1267 of yacc.c.  */
-#line 2132 "scripts/genksyms/parse.c"
+
+/* Line 1455 of yacc.c  */
+#line 2301 "scripts/genksyms/parse.c"
       default: break;
     }
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
@@ -2139,7 +2308,6 @@ yyreduce:
 
   *++yyvsp = yyval;
 
-
   /* Now `shift' the result of the reduction.  Determine what state
      that goes to, based on the state we popped back to and the rule
      number reduced by.  */
@@ -2204,7 +2372,7 @@ yyerrlab:
 
   if (yyerrstatus == 3)
     {
-      /* If just tried and failed to reuse look-ahead token after an
+      /* If just tried and failed to reuse lookahead token after an
 	 error, discard it.  */
 
       if (yychar <= YYEOF)
@@ -2221,7 +2389,7 @@ yyerrlab:
 	}
     }
 
-  /* Else will try to reuse look-ahead token after shifting the error
+  /* Else will try to reuse lookahead token after shifting the error
      token.  */
   goto yyerrlab1;
 
@@ -2278,9 +2446,6 @@ yyerrlab1:
       YY_STACK_PRINT (yyss, yyssp);
     }
 
-  if (yyn == YYFINAL)
-    YYACCEPT;
-
   *++yyvsp = yylval;
 
 
@@ -2305,7 +2470,7 @@ yyabortlab:
   yyresult = 1;
   goto yyreturn;
 
-#ifndef yyoverflow
+#if !defined(yyoverflow) || YYERROR_VERBOSE
 /*-------------------------------------------------.
 | yyexhaustedlab -- memory exhaustion comes here.  |
 `-------------------------------------------------*/
@@ -2316,7 +2481,7 @@ yyexhaustedlab:
 #endif
 
 yyreturn:
-  if (yychar != YYEOF && yychar != YYEMPTY)
+  if (yychar != YYEMPTY)
      yydestruct ("Cleanup: discarding lookahead",
 		 yytoken, &yylval);
   /* Do not reclaim the symbols of the rule which action triggered
@@ -2342,7 +2507,9 @@ yyreturn:
 }
 
 
-#line 467 "scripts/genksyms/parse.y"
+
+/* Line 1675 of yacc.c  */
+#line 493 "scripts/genksyms/parse.y"
 
 
 static void
diff --git a/scripts/genksyms/parse.h_shipped b/scripts/genksyms/parse.h_shipped
index c4eeec6..5175236 100644
--- a/scripts/genksyms/parse.h_shipped
+++ b/scripts/genksyms/parse.h_shipped
@@ -1,24 +1,23 @@
-/* A Bison parser, made by GNU Bison 2.3.  */
 
-/* Skeleton interface for Bison's Yacc-like parsers in C
+/* A Bison parser, made by GNU Bison 2.4.1.  */
 
-   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
+/* Skeleton interface for Bison's Yacc-like parsers in C
+   
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
    Free Software Foundation, Inc.
-
-   This program is free software; you can redistribute it and/or modify
+   
+   This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2, or (at your option)
-   any later version.
-
+   the Free Software Foundation, either version 3 of the License, or
+   (at your option) any later version.
+   
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
-
+   
    You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 51 Franklin Street, Fifth Floor,
-   Boston, MA 02110-1301, USA.  */
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
 
 /* As a special exception, you may create a larger work that contains
    part or all of the Bison parser skeleton and distribute that work
@@ -29,10 +28,11 @@
    special exception, which will cause the skeleton and the resulting
    Bison output files to be licensed under the GNU General Public
    License without this special exception.
-
+   
    This special exception was added by the Free Software Foundation in
    version 2.2 of Bison.  */
 
+
 /* Tokens.  */
 #ifndef YYTOKENTYPE
 # define YYTOKENTYPE
@@ -82,58 +82,16 @@
      FILENAME = 298
    };
 #endif
-/* Tokens.  */
-#define ASM_KEYW 258
-#define ATTRIBUTE_KEYW 259
-#define AUTO_KEYW 260
-#define BOOL_KEYW 261
-#define CHAR_KEYW 262
-#define CONST_KEYW 263
-#define DOUBLE_KEYW 264
-#define ENUM_KEYW 265
-#define EXTERN_KEYW 266
-#define EXTENSION_KEYW 267
-#define FLOAT_KEYW 268
-#define INLINE_KEYW 269
-#define INT_KEYW 270
-#define LONG_KEYW 271
-#define REGISTER_KEYW 272
-#define RESTRICT_KEYW 273
-#define SHORT_KEYW 274
-#define SIGNED_KEYW 275
-#define STATIC_KEYW 276
-#define STRUCT_KEYW 277
-#define TYPEDEF_KEYW 278
-#define UNION_KEYW 279
-#define UNSIGNED_KEYW 280
-#define VOID_KEYW 281
-#define VOLATILE_KEYW 282
-#define TYPEOF_KEYW 283
-#define EXPORT_SYMBOL_KEYW 284
-#define ASM_PHRASE 285
-#define ATTRIBUTE_PHRASE 286
-#define BRACE_PHRASE 287
-#define BRACKET_PHRASE 288
-#define EXPRESSION_PHRASE 289
-#define CHAR 290
-#define DOTS 291
-#define IDENT 292
-#define INT 293
-#define REAL 294
-#define STRING 295
-#define TYPE 296
-#define OTHER 297
-#define FILENAME 298
-
 
 
 
 #if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
 typedef int YYSTYPE;
+# define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
 # define YYSTYPE_IS_DECLARED 1
-# define YYSTYPE_IS_TRIVIAL 1
 #endif
 
 extern YYSTYPE yylval;
 
+
-- 
1.7.4.1

