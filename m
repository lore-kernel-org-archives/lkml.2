Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1DTTUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:20:34 -0400
Received: from host6.netdorm.com ([64.182.105.6]:35867 "EHLO host6.netdorm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab1DTTUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:20:32 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Apr 2011 15:20:31 EDT
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DAF2726.40102@verizon.net>
Date: Wed, 20 Apr 2011 14:34:14 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, <mmarek@suse.cz>
Subject: [PATCH 2/2] kbuild: regenerate genksyms to fix warning
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Foley <pefoley2@verizon.net>

This patch adds a file to .gitignore and fixes this warning by regenerating the files under scripts/genksyms.
scripts/genksyms/lex.l: In function 'yylex1':
scripts/genksyms/lex.l:93:1: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/genksyms/.gitignore      |    1 +
 scripts/genksyms/lex.c_shipped   |   30 ++++--
 scripts/genksyms/parse.c_shipped |  198 ++++++++++++++++++++------------------
 scripts/genksyms/parse.h_shipped |    7 +-
 4 files changed, 129 insertions(+), 107 deletions(-)

diff --git a/scripts/genksyms/.gitignore b/scripts/genksyms/.gitignore
index be5cadb..cebeb7b 100644
--- a/scripts/genksyms/.gitignore
+++ b/scripts/genksyms/.gitignore
@@ -2,3 +2,4 @@ keywords.c
 lex.c
 parse.[ch]
 genksyms
+parse.output
diff --git a/scripts/genksyms/lex.c_shipped b/scripts/genksyms/lex.c_shipped
index af49390..9d4e1f7 100644
--- a/scripts/genksyms/lex.c_shipped
+++ b/scripts/genksyms/lex.c_shipped
@@ -79,7 +79,6 @@ typedef int flex_int32_t;
 typedef unsigned char flex_uint8_t;  typedef unsigned short int flex_uint16_t;
 typedef unsigned int flex_uint32_t;
-#endif /* ! C99 */
  /* Limits of integral types. */
 #ifndef INT8_MIN
@@ -110,6 +109,8 @@ typedef unsigned int flex_uint32_t;
 #define UINT32_MAX             (4294967295U)
 #endif
 +#endif /* ! C99 */
+
 #endif /* ! FLEXINT_H */
  /* %endif */
@@ -184,7 +185,15 @@ typedef unsigned int flex_uint32_t;
  /* Size of default input buffer. */
 #ifndef YY_BUF_SIZE
+#ifdef __ia64__
+/* On IA-64, the buffer size is 16k, not 8k.
+ * Moreover, YY_BUF_SIZE is 2*YY_READ_BUF_SIZE in the general case.
+ * Ditto for the __ia64__ case accordingly.
+ */
+#define YY_BUF_SIZE 32768
+#else
 #define YY_BUF_SIZE 16384
+#endif /* __ia64__ */
 #endif
  /* The state buf must be large enough to hold one state per character in the main buffer.
@@ -664,7 +673,7 @@ char *yytext;
  /* We don't do multiple input files.  */
 #define YY_NO_INPUT 1
-#line 668 "scripts/genksyms/lex.c"
+#line 677 "scripts/genksyms/lex.c"
  #define INITIAL 0
 @@ -775,7 +784,12 @@ static int input (void );
  /* Amount of stuff to slurp up with each read. */
 #ifndef YY_READ_BUF_SIZE
+#ifdef __ia64__
+/* On IA-64, the buffer size is 16k, not 8k */
+#define YY_READ_BUF_SIZE 16384
+#else
 #define YY_READ_BUF_SIZE 8192
+#endif /* __ia64__ */
 #endif
  /* Copy whatever the last rule matched to the standard output. */
@@ -784,7 +798,7 @@ static int input (void );
 /* This used to be an fputs(), but since the string might contain NUL's,
  * we now use fwrite().
  */
-#define ECHO fwrite( yytext, yyleng, 1, yyout )
+#define ECHO do { if (fwrite( yytext, yyleng, 1, yyout )) {} } while (0)
 /* %endif */
 /* %if-c++-only C++ definition */
 /* %endif */
@@ -799,7 +813,7 @@ static int input (void );
 	if ( YY_CURRENT_BUFFER_LVALUE->yy_is_interactive ) \
 		{ \
 		int c = '*'; \
-		int n; \
+		size_t n; \
 		for ( n = 0; n < max_size && \
 			     (c = getc( yyin )) != EOF && c != '\n'; ++n ) \
 			buf[n] = (char) c; \
@@ -914,7 +928,7 @@ YY_DECL
    /* Keep track of our location in the original source files.  */
-#line 918 "scripts/genksyms/lex.c"
+#line 932 "scripts/genksyms/lex.c"
  	if ( !(yy_init) )
 		{
@@ -1105,7 +1119,7 @@ YY_RULE_SETUP
 #line 93 "scripts/genksyms/lex.l"
 ECHO;
 	YY_BREAK
-#line 1109 "scripts/genksyms/lex.c"
+#line 1123 "scripts/genksyms/lex.c"
 case YY_STATE_EOF(INITIAL):
 	yyterminate();
 @@ -1972,8 +1986,8 @@ YY_BUFFER_STATE yy_scan_string (yyconst char * yystr )
 /* %if-c-only */
 /** Setup the input buffer state to scan the given bytes. The next call to yylex() will
  * scan from a @e copy of @a bytes.
- * @param bytes the byte buffer to scan
- * @param len the number of bytes in the buffer pointed to by @a bytes.
+ * @param yybytes the byte buffer to scan
+ * @param _yybytes_len the number of bytes in the buffer pointed to by @a bytes.
  *   * @return the newly allocated buffer state object.
  */
diff --git a/scripts/genksyms/parse.c_shipped b/scripts/genksyms/parse.c_shipped
index 1a0b860..7728765 100644
--- a/scripts/genksyms/parse.c_shipped
+++ b/scripts/genksyms/parse.c_shipped
@@ -1,10 +1,9 @@
-
-/* A Bison parser, made by GNU Bison 2.4.1.  */
+/* A Bison parser, made by GNU Bison 2.4.3.  */
  /* Skeleton implementation for Bison's Yacc-like parsers in C
    -      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
-   Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
+   2009, 2010 Free Software Foundation, Inc.
        This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -46,7 +45,7 @@
 #define YYBISON 1
  /* Bison version.  */
-#define YYBISON_VERSION "2.4.1"
+#define YYBISON_VERSION "2.4.3"
  /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -102,7 +101,7 @@ remove_list(struct string_list **pb, struct string_list **pe)
   /* Line 189 of yacc.c  */
-#line 106 "scripts/genksyms/parse.c"
+#line 105 "scripts/genksyms/parse.c"
  /* Enabling traces.  */
 #ifndef YYDEBUG
@@ -187,7 +186,7 @@ typedef int YYSTYPE;
   /* Line 264 of yacc.c  */
-#line 191 "scripts/genksyms/parse.c"
+#line 190 "scripts/genksyms/parse.c"
  #ifdef short
 # undef short
@@ -237,7 +236,7 @@ typedef short int yytype_int16;
 #define YYSIZE_MAXIMUM ((YYSIZE_T) -1)
  #ifndef YY_
-# if YYENABLE_NLS
+# if defined YYENABLE_NLS && YYENABLE_NLS
 #  if ENABLE_NLS
 #   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
 #   define YY_(msgid) dgettext ("bison-runtime", msgid)
@@ -855,9 +854,18 @@ static const yytype_uint8 yystos[] =
  /* Like YYERROR except do call yyerror.  This remains here temporarily
    to ease the transition to the new meaning of YYERROR, for GCC.
-   Once GCC version 2 has supplanted version 1, this can go.  */
+   Once GCC version 2 has supplanted version 1, this can go.  However,
+   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
+   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
+   discussed.  */
  #define YYFAIL		goto yyerrlab
+#if defined YYFAIL
+  /* This is here to suppress warnings from the GCC cpp's
+     -Wunused-macros.  Normally we don't worry about that warning, but
+     some users do, and we want to make it easy for users to remove
+     YYFAIL uses, which will produce warnings from Bison 2.5.  */
+#endif
  #define YYRECOVERING()  (!!yyerrstatus)
 @@ -914,7 +922,7 @@ while (YYID (0))
    we won't break user code: when these are the locations we know.  */
  #ifndef YY_LOCATION_PRINT
-# if YYLTYPE_IS_TRIVIAL
+# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
 #  define YY_LOCATION_PRINT(File, Loc)			\
      fprintf (File, "%d.%d-%d.%d",			\
 	      (Loc).first_line, (Loc).first_column,	\
@@ -1653,63 +1661,63 @@ yyreduce:
     {
         case 4:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 109 "scripts/genksyms/parse.y"
     { is_typedef = 0; is_extern = 0; current_name = NULL; decl_spec = NULL; ;}
     break;
    case 5:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 111 "scripts/genksyms/parse.y"
     { free_list(*(yyvsp[(2) - (2)]), NULL); *(yyvsp[(2) - (2)]) = NULL; ;}
     break;
    case 6:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 115 "scripts/genksyms/parse.y"
     { is_typedef = 1; ;}
     break;
    case 7:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 116 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
    case 8:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 117 "scripts/genksyms/parse.y"
     { is_typedef = 1; ;}
     break;
    case 9:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 118 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 14:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 123 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 15:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 124 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 16:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 129 "scripts/genksyms/parse.y"
     { if (current_name) {
 		    struct string_list *decl = (*(yyvsp[(3) - (3)]))->next;
@@ -1725,14 +1733,14 @@ yyreduce:
    case 17:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 142 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
    case 19:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 148 "scripts/genksyms/parse.y"
     { struct string_list *decl = *(yyvsp[(1) - (1)]);
 		  *(yyvsp[(1) - (1)]) = NULL;
@@ -1745,7 +1753,7 @@ yyreduce:
    case 20:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 156 "scripts/genksyms/parse.y"
     { struct string_list *decl = *(yyvsp[(3) - (3)]);
 		  *(yyvsp[(3) - (3)]) = NULL;
@@ -1760,35 +1768,35 @@ yyreduce:
    case 21:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 169 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]) ? (yyvsp[(4) - (4)]) : (yyvsp[(3) - (4)]) ? (yyvsp[(3) - (4)]) : (yyvsp[(2) - (4)]) ? (yyvsp[(2) - (4)]) : (yyvsp[(1) - (4)]); ;}
     break;
    case 22:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 174 "scripts/genksyms/parse.y"
     { decl_spec = NULL; ;}
     break;
    case 24:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 179 "scripts/genksyms/parse.y"
     { decl_spec = *(yyvsp[(1) - (1)]); ;}
     break;
    case 25:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 180 "scripts/genksyms/parse.y"
     { decl_spec = *(yyvsp[(2) - (2)]); ;}
     break;
    case 26:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 185 "scripts/genksyms/parse.y"
     { /* Version 2 checksumming ignores storage class, as that
 		     is really irrelevant to the linkage.  */
@@ -1799,42 +1807,42 @@ yyreduce:
    case 31:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 197 "scripts/genksyms/parse.y"
     { is_extern = 1; (yyval) = (yyvsp[(1) - (1)]); ;}
     break;
    case 32:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 198 "scripts/genksyms/parse.y"
     { is_extern = 0; (yyval) = (yyvsp[(1) - (1)]); ;}
     break;
    case 37:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 210 "scripts/genksyms/parse.y"
     { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_STRUCT; (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 38:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 212 "scripts/genksyms/parse.y"
     { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_UNION; (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 39:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 214 "scripts/genksyms/parse.y"
     { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_ENUM; (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 40:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 218 "scripts/genksyms/parse.y"
     { struct string_list *s = *(yyvsp[(3) - (3)]), *i = *(yyvsp[(2) - (3)]), *r;
 		  r = copy_node(i); r->tag = SYM_STRUCT;
@@ -1846,7 +1854,7 @@ yyreduce:
    case 41:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 225 "scripts/genksyms/parse.y"
     { struct string_list *s = *(yyvsp[(3) - (3)]), *i = *(yyvsp[(2) - (3)]), *r;
 		  r = copy_node(i); r->tag = SYM_UNION;
@@ -1858,7 +1866,7 @@ yyreduce:
    case 42:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 232 "scripts/genksyms/parse.y"
     { struct string_list *s = *(yyvsp[(3) - (3)]), *i = *(yyvsp[(2) - (3)]), *r;
 		  r = copy_node(i); r->tag = SYM_ENUM;
@@ -1870,56 +1878,56 @@ yyreduce:
    case 43:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 242 "scripts/genksyms/parse.y"
     { add_symbol(NULL, SYM_ENUM, NULL, 0); (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 44:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 244 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 45:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 245 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 56:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 259 "scripts/genksyms/parse.y"
     { (*(yyvsp[(1) - (1)]))->tag = SYM_TYPEDEF; (yyval) = (yyvsp[(1) - (1)]); ;}
     break;
    case 57:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 264 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
     break;
    case 58:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 268 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
    case 61:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 274 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 65:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 280 "scripts/genksyms/parse.y"
     { /* restrict has no effect in prototypes so ignore it */
 		  remove_node((yyvsp[(1) - (1)]));
@@ -1929,14 +1937,14 @@ yyreduce:
    case 66:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 287 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 68:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 293 "scripts/genksyms/parse.y"
     { if (current_name != NULL) {
 		    error_with_pos("unexpected second declaration name");
@@ -1950,133 +1958,133 @@ yyreduce:
    case 69:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 302 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
    case 70:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 304 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
    case 71:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 306 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 72:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 308 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 73:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 310 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 74:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 316 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 78:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 324 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
    case 79:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 326 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
    case 80:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 328 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 81:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 330 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 82:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 332 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 83:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 336 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 85:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 338 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 86:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 342 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
    case 89:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 349 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 90:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 354 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
     break;
    case 91:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 359 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
     break;
    case 93:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 364 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
    case 94:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 366 "scripts/genksyms/parse.y"
     { /* For version 2 checksums, we don't want to remember
 		     private parameter names.  */
@@ -2087,7 +2095,7 @@ yyreduce:
    case 95:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 374 "scripts/genksyms/parse.y"
     { remove_node((yyvsp[(1) - (1)]));
 		  (yyval) = (yyvsp[(1) - (1)]);
@@ -2096,42 +2104,42 @@ yyreduce:
    case 96:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 378 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
    case 97:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 380 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
    case 98:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 382 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 99:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 384 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 100:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 386 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 101:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 391 "scripts/genksyms/parse.y"
     { struct string_list *decl = *(yyvsp[(2) - (3)]);
 		  *(yyvsp[(2) - (3)]) = NULL;
@@ -2142,119 +2150,119 @@ yyreduce:
    case 102:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 399 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
    case 104:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 406 "scripts/genksyms/parse.y"
     { remove_list((yyvsp[(2) - (2)]), &(*(yyvsp[(1) - (2)]))->next); (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 105:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 410 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 106:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 411 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 107:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 415 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
    case 110:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 421 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 111:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 426 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 112:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 428 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 113:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 432 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
    case 116:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 438 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 117:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 442 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
     break;
    case 118:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 443 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 120:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 448 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 121:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 452 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
    case 123:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 457 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(3) - (3)]); ;}
     break;
    case 124:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 458 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(4) - (4)]); ;}
     break;
    case 127:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 467 "scripts/genksyms/parse.y"
     {
 			const char *name = strdup((*(yyvsp[(1) - (1)]))->string);
@@ -2264,7 +2272,7 @@ yyreduce:
    case 128:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 472 "scripts/genksyms/parse.y"
     {
 			const char *name = strdup((*(yyvsp[(1) - (3)]))->string);
@@ -2275,29 +2283,29 @@ yyreduce:
    case 129:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 479 "scripts/genksyms/parse.y"
     { (yyval) = (yyvsp[(2) - (2)]); ;}
     break;
    case 130:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 483 "scripts/genksyms/parse.y"
     { (yyval) = NULL; ;}
     break;
    case 132:
 -/* Line 1455 of yacc.c  */
+/* Line 1464 of yacc.c  */
 #line 489 "scripts/genksyms/parse.y"
     { export_symbol((*(yyvsp[(3) - (5)]))->string); (yyval) = (yyvsp[(5) - (5)]); ;}
     break;
   -/* Line 1455 of yacc.c  */
-#line 2301 "scripts/genksyms/parse.c"
+/* Line 1464 of yacc.c  */
+#line 2309 "scripts/genksyms/parse.c"
       default: break;
     }
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
@@ -2508,7 +2516,7 @@ yyreturn:
   -/* Line 1675 of yacc.c  */
+/* Line 1684 of yacc.c  */
 #line 493 "scripts/genksyms/parse.y"
  diff --git a/scripts/genksyms/parse.h_shipped b/scripts/genksyms/parse.h_shipped
index 5175236..350c2b4 100644
--- a/scripts/genksyms/parse.h_shipped
+++ b/scripts/genksyms/parse.h_shipped
@@ -1,10 +1,9 @@
-
-/* A Bison parser, made by GNU Bison 2.4.1.  */
+/* A Bison parser, made by GNU Bison 2.4.3.  */
  /* Skeleton interface for Bison's Yacc-like parsers in C
    -      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
-   Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
+   2009, 2010 Free Software Foundation, Inc.
        This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
-- 
1.7.5.rc1


