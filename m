Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab1JKKNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:13:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab1JKKNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:13:21 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] genksyms: Regenerate lexer and parser
Date: Tue, 11 Oct 2011 12:12:49 +0200
Message-Id: <1318327969-24807-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1318327969-24807-1-git-send-email-mmarek@suse.cz>
References: <1318327969-24807-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 scripts/genksyms/lex.lex.c_shipped   |   12 +-
 scripts/genksyms/parse.tab.c_shipped |  645 ++++++++++++++++++----------------
 scripts/genksyms/parse.tab.h_shipped |    7 +-
 3 files changed, 358 insertions(+), 306 deletions(-)

diff --git a/scripts/genksyms/lex.lex.c_shipped b/scripts/genksyms/lex.lex.c_shipped
index c83cf60..0bf4157 100644
--- a/scripts/genksyms/lex.lex.c_shipped
+++ b/scripts/genksyms/lex.lex.c_shipped
@@ -660,7 +660,7 @@ static int input (void );
 /* This used to be an fputs(), but since the string might contain NUL's,
  * we now use fwrite().
  */
-#define ECHO do { if (fwrite( yytext, yyleng, 1, yyout )) {} } while (0)
+#define ECHO fwrite( yytext, yyleng, 1, yyout )
 #endif
 
 /* Gets input and stuffs it into "buf".  number of characters read, or YY_NULL,
@@ -671,7 +671,7 @@ static int input (void );
 	if ( YY_CURRENT_BUFFER_LVALUE->yy_is_interactive ) \
 		{ \
 		int c = '*'; \
-		unsigned n; \
+		int n; \
 		for ( n = 0; n < max_size && \
 			     (c = getc( yyin )) != EOF && c != '\n'; ++n ) \
 			buf[n] = (char) c; \
@@ -1926,6 +1926,7 @@ void yyfree (void * ptr )
 			  cur_node->tag =				   \
 			    find_symbol(cur_node->string, SYM_ENUM_CONST, 1)?\
 			    SYM_ENUM_CONST : SYM_NORMAL ;		   \
+			  cur_node->in_source_file = in_source_file;       \
 			} while (0)
 
 #define APP		_APP(yytext, yyleng)
@@ -1975,6 +1976,13 @@ repeat:
       cur_filename = memcpy(xmalloc(e-file+1), file, e-file+1);
       cur_line = atoi(yytext+2);
 
+      if (!source_file) {
+        source_file = xstrdup(cur_filename);
+        in_source_file = 1;
+      } else {
+        in_source_file = (strcmp(cur_filename, source_file) == 0);
+      }
+
       goto repeat;
     }
 
diff --git a/scripts/genksyms/parse.tab.c_shipped b/scripts/genksyms/parse.tab.c_shipped
index 61d4a5d..ece53c7 100644
--- a/scripts/genksyms/parse.tab.c_shipped
+++ b/scripts/genksyms/parse.tab.c_shipped
@@ -1,9 +1,8 @@
-/* A Bison parser, made by GNU Bison 2.4.3.  */
+/* A Bison parser, made by GNU Bison 2.5.  */
 
-/* Skeleton implementation for Bison's Yacc-like parsers in C
+/* Bison implementation for Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
-   2009, 2010 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -45,7 +44,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.4.3"
+#define YYBISON_VERSION "2.5"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -96,6 +95,25 @@ remove_list(struct string_list **pb, struct string_list **pe)
   free_list(b, e);
 }
 
+/* Record definition of a struct/union/enum */
+static void record_compound(struct string_list **keyw,
+		       struct string_list **ident,
+		       struct string_list **body,
+		       enum symbol_type type)
+{
+	struct string_list *b = *body, *i = *ident, *r;
+
+	if (i->in_source_file) {
+		remove_node(keyw);
+		(*ident)->tag = type;
+		remove_list(body, ident);
+		return;
+	}
+	r = copy_node(i); r->tag = type;
+	r->next = (*keyw)->next; *body = r; (*keyw)->next = NULL;
+	add_symbol(i->string, type, b, is_extern);
+}
+
 
 
 
@@ -283,11 +301,11 @@ YYID (yyi)
 #    define alloca _alloca
 #   else
 #    define YYSTACK_ALLOC alloca
-#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 #     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#     ifndef _STDLIB_H
-#      define _STDLIB_H 1
+#     ifndef EXIT_SUCCESS
+#      define EXIT_SUCCESS 0
 #     endif
 #    endif
 #   endif
@@ -310,24 +328,24 @@ YYID (yyi)
 #  ifndef YYSTACK_ALLOC_MAXIMUM
 #   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
 #  endif
-#  if (defined __cplusplus && ! defined _STDLIB_H \
+#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
        && ! ((defined YYMALLOC || defined malloc) \
 	     && (defined YYFREE || defined free)))
 #   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#   ifndef _STDLIB_H
-#    define _STDLIB_H 1
+#   ifndef EXIT_SUCCESS
+#    define EXIT_SUCCESS 0
 #   endif
 #  endif
 #  ifndef YYMALLOC
 #   define YYMALLOC malloc
-#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
 #   endif
 #  endif
 #  ifndef YYFREE
 #   define YYFREE free
-#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void free (void *); /* INFRINGES ON USER NAME SPACE */
 #   endif
@@ -356,23 +374,7 @@ union yyalloc
      ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
       + YYSTACK_GAP_MAXIMUM)
 
-/* Copy COUNT objects from FROM to TO.  The source and destination do
-   not overlap.  */
-# ifndef YYCOPY
-#  if defined __GNUC__ && 1 < __GNUC__
-#   define YYCOPY(To, From, Count) \
-      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
-#  else
-#   define YYCOPY(To, From, Count)		\
-      do					\
-	{					\
-	  YYSIZE_T yyi;				\
-	  for (yyi = 0; yyi < (Count); yyi++)	\
-	    (To)[yyi] = (From)[yyi];		\
-	}					\
-      while (YYID (0))
-#  endif
-# endif
+# define YYCOPY_NEEDED 1
 
 /* Relocate STACK from its old location to the new one.  The
    local variables YYSIZE and YYSTACKSIZE give the old and new number of
@@ -392,6 +394,26 @@ union yyalloc
 
 #endif
 
+#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
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
+#endif /* !YYCOPY_NEEDED */
+
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  4
 /* YYLAST -- Last index in YYTABLE.  */
@@ -514,20 +536,20 @@ static const yytype_int8 yyrhs[] =
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint16 yyrline[] =
 {
-       0,   104,   104,   105,   109,   109,   115,   115,   117,   117,
-     119,   120,   121,   122,   123,   124,   128,   142,   143,   147,
-     155,   168,   174,   175,   179,   180,   184,   190,   194,   195,
-     196,   197,   198,   202,   203,   204,   205,   209,   211,   213,
-     217,   224,   231,   241,   244,   245,   249,   250,   251,   252,
-     253,   254,   255,   256,   257,   258,   259,   263,   268,   269,
-     273,   274,   278,   278,   278,   279,   287,   288,   292,   301,
-     303,   305,   307,   309,   316,   317,   321,   322,   323,   325,
-     327,   329,   331,   336,   337,   338,   342,   343,   347,   348,
-     353,   358,   360,   364,   365,   373,   377,   379,   381,   383,
-     385,   390,   399,   400,   405,   410,   411,   415,   416,   420,
-     421,   425,   427,   432,   433,   437,   438,   442,   443,   444,
-     448,   452,   453,   457,   458,   462,   463,   466,   471,   479,
-     483,   484,   488
+       0,   123,   123,   124,   128,   128,   134,   134,   136,   136,
+     138,   139,   140,   141,   142,   143,   147,   161,   162,   166,
+     174,   187,   193,   194,   198,   199,   203,   209,   213,   214,
+     215,   216,   217,   221,   222,   223,   224,   228,   230,   232,
+     236,   238,   240,   245,   248,   249,   253,   254,   255,   256,
+     257,   258,   259,   260,   261,   262,   263,   267,   272,   273,
+     277,   278,   282,   282,   282,   283,   291,   292,   296,   305,
+     307,   309,   311,   313,   320,   321,   325,   326,   327,   329,
+     331,   333,   335,   340,   341,   342,   346,   347,   351,   352,
+     357,   362,   364,   368,   369,   377,   381,   383,   385,   387,
+     389,   394,   403,   404,   409,   414,   415,   419,   420,   424,
+     425,   429,   431,   436,   437,   441,   442,   446,   447,   448,
+     452,   456,   457,   461,   462,   466,   467,   470,   475,   483,
+     487,   488,   492
 };
 #endif
 
@@ -618,8 +640,8 @@ static const yytype_uint8 yyr2[] =
        0,     1,     5
 };
 
-/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
-   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
+/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
+   Performed when YYTABLE doesn't specify something else to do.  Zero
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
@@ -692,8 +714,7 @@ static const yytype_int16 yypgoto[] =
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
    positive, shift that token.  If negative, reduce the rule which
-   number is the opposite.  If zero, do what YYDEFACT says.
-   If YYTABLE_NINF, syntax error.  */
+   number is the opposite.  If YYTABLE_NINF, syntax error.  */
 #define YYTABLE_NINF -109
 static const yytype_int16 yytable[] =
 {
@@ -753,6 +774,12 @@ static const yytype_int16 yytable[] =
        0,     0,    34
 };
 
+#define yypact_value_is_default(yystate) \
+  ((yystate) == (-135))
+
+#define yytable_value_is_error(yytable_value) \
+  YYID (0)
+
 static const yytype_int16 yycheck[] =
 {
       59,    38,    79,     3,     1,     8,    56,    37,    26,    37,
@@ -869,7 +896,6 @@ do								\
     {								\
       yychar = (Token);						\
       yylval = (Value);						\
-      yytoken = YYTRANSLATE (yychar);				\
       YYPOPSTACK (1);						\
       goto yybackup;						\
     }								\
@@ -911,19 +937,10 @@ while (YYID (0))
 #endif
 
 
-/* YY_LOCATION_PRINT -- Print the location on the stream.
-   This macro was not mandated originally: define only if we know
-   we won't break user code: when these are the locations we know.  */
+/* This macro is provided for backward compatibility. */
 
 #ifndef YY_LOCATION_PRINT
-# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
-#  define YY_LOCATION_PRINT(File, Loc)			\
-     fprintf (File, "%d.%d-%d.%d",			\
-	      (Loc).first_line, (Loc).first_column,	\
-	      (Loc).last_line,  (Loc).last_column)
-# else
-#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
-# endif
+# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
 #endif
 
 
@@ -1115,7 +1132,6 @@ int yydebug;
 # define YYMAXDEPTH 10000
 #endif
 
-
 
 #if YYERROR_VERBOSE
 
@@ -1218,115 +1234,142 @@ yytnamerr (char *yyres, const char *yystr)
 }
 # endif
 
-/* Copy into YYRESULT an error message about the unexpected token
-   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
-   including the terminating null byte.  If YYRESULT is null, do not
-   copy anything; just return the number of bytes that would be
-   copied.  As a special case, return 0 if an ordinary "syntax error"
-   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
-   size calculation.  */
-static YYSIZE_T
-yysyntax_error (char *yyresult, int yystate, int yychar)
-{
-  int yyn = yypact[yystate];
+/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
+   about the unexpected token YYTOKEN for the state stack whose top is
+   YYSSP.
 
-  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
-    return 0;
-  else
+   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
+   not large enough to hold the message.  In that case, also set
+   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
+   required number of bytes is too large to store.  */
+static int
+yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
+                yytype_int16 *yyssp, int yytoken)
+{
+  YYSIZE_T yysize0 = yytnamerr (0, yytname[yytoken]);
+  YYSIZE_T yysize = yysize0;
+  YYSIZE_T yysize1;
+  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
+  /* Internationalized format string. */
+  const char *yyformat = 0;
+  /* Arguments of yyformat. */
+  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
+  /* Number of reported tokens (one for the "unexpected", one per
+     "expected"). */
+  int yycount = 0;
+
+  /* There are many possibilities here to consider:
+     - Assume YYFAIL is not used.  It's too flawed to consider.  See
+       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
+       for details.  YYERROR is fine as it does not invoke this
+       function.
+     - If this state is a consistent state with a default action, then
+       the only way this function was invoked is if the default action
+       is an error action.  In that case, don't check for expected
+       tokens because there are none.
+     - The only way there can be no lookahead present (in yychar) is if
+       this state is a consistent state with a default action.  Thus,
+       detecting the absence of a lookahead is sufficient to determine
+       that there is no unexpected or expected token to report.  In that
+       case, just report a simple "syntax error".
+     - Don't assume there isn't a lookahead just because this state is a
+       consistent state with a default action.  There might have been a
+       previous inconsistent state, consistent state with a non-default
+       action, or user semantic action that manipulated yychar.
+     - Of course, the expected token list depends on states to have
+       correct lookahead information, and it depends on the parser not
+       to perform extra reductions after fetching a lookahead from the
+       scanner and before detecting a syntax error.  Thus, state merging
+       (from LALR or IELR) and default reductions corrupt the expected
+       token list.  However, the list is correct for canonical LR with
+       one exception: it will still contain any token that will not be
+       accepted due to an error action in a later state.
+  */
+  if (yytoken != YYEMPTY)
     {
-      int yytype = YYTRANSLATE (yychar);
-      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
-      YYSIZE_T yysize = yysize0;
-      YYSIZE_T yysize1;
-      int yysize_overflow = 0;
-      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
-      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
-      int yyx;
-
-# if 0
-      /* This is so xgettext sees the translatable formats that are
-	 constructed on the fly.  */
-      YY_("syntax error, unexpected %s");
-      YY_("syntax error, unexpected %s, expecting %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
-# endif
-      char *yyfmt;
-      char const *yyf;
-      static char const yyunexpected[] = "syntax error, unexpected %s";
-      static char const yyexpecting[] = ", expecting %s";
-      static char const yyor[] = " or %s";
-      char yyformat[sizeof yyunexpected
-		    + sizeof yyexpecting - 1
-		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
-		       * (sizeof yyor - 1))];
-      char const *yyprefix = yyexpecting;
-
-      /* Start YYX at -YYN if negative to avoid negative indexes in
-	 YYCHECK.  */
-      int yyxbegin = yyn < 0 ? -yyn : 0;
-
-      /* Stay within bounds of both yycheck and yytname.  */
-      int yychecklim = YYLAST - yyn + 1;
-      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
-      int yycount = 1;
-
-      yyarg[0] = yytname[yytype];
-      yyfmt = yystpcpy (yyformat, yyunexpected);
-
-      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
-	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
-	  {
-	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
-	      {
-		yycount = 1;
-		yysize = yysize0;
-		yyformat[sizeof yyunexpected - 1] = '\0';
-		break;
-	      }
-	    yyarg[yycount++] = yytname[yyx];
-	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
-	    yysize_overflow |= (yysize1 < yysize);
-	    yysize = yysize1;
-	    yyfmt = yystpcpy (yyfmt, yyprefix);
-	    yyprefix = yyor;
-	  }
+      int yyn = yypact[*yyssp];
+      yyarg[yycount++] = yytname[yytoken];
+      if (!yypact_value_is_default (yyn))
+        {
+          /* Start YYX at -YYN if negative to avoid negative indexes in
+             YYCHECK.  In other words, skip the first -YYN actions for
+             this state because they are default actions.  */
+          int yyxbegin = yyn < 0 ? -yyn : 0;
+          /* Stay within bounds of both yycheck and yytname.  */
+          int yychecklim = YYLAST - yyn + 1;
+          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
+          int yyx;
+
+          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
+            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
+                && !yytable_value_is_error (yytable[yyx + yyn]))
+              {
+                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
+                  {
+                    yycount = 1;
+                    yysize = yysize0;
+                    break;
+                  }
+                yyarg[yycount++] = yytname[yyx];
+                yysize1 = yysize + yytnamerr (0, yytname[yyx]);
+                if (! (yysize <= yysize1
+                       && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+                  return 2;
+                yysize = yysize1;
+              }
+        }
+    }
 
-      yyf = YY_(yyformat);
-      yysize1 = yysize + yystrlen (yyf);
-      yysize_overflow |= (yysize1 < yysize);
-      yysize = yysize1;
+  switch (yycount)
+    {
+# define YYCASE_(N, S)                      \
+      case N:                               \
+        yyformat = S;                       \
+      break
+      YYCASE_(0, YY_("syntax error"));
+      YYCASE_(1, YY_("syntax error, unexpected %s"));
+      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
+      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
+      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
+      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
+# undef YYCASE_
+    }
 
-      if (yysize_overflow)
-	return YYSIZE_MAXIMUM;
+  yysize1 = yysize + yystrlen (yyformat);
+  if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+    return 2;
+  yysize = yysize1;
 
-      if (yyresult)
-	{
-	  /* Avoid sprintf, as that infringes on the user's name space.
-	     Don't have undefined behavior even if the translation
-	     produced a string with the wrong number of "%s"s.  */
-	  char *yyp = yyresult;
-	  int yyi = 0;
-	  while ((*yyp = *yyf) != '\0')
-	    {
-	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
-		{
-		  yyp += yytnamerr (yyp, yyarg[yyi++]);
-		  yyf += 2;
-		}
-	      else
-		{
-		  yyp++;
-		  yyf++;
-		}
-	    }
-	}
-      return yysize;
+  if (*yymsg_alloc < yysize)
+    {
+      *yymsg_alloc = 2 * yysize;
+      if (! (yysize <= *yymsg_alloc
+             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
+        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
+      return 1;
     }
+
+  /* Avoid sprintf, as that infringes on the user's name space.
+     Don't have undefined behavior even if the translation
+     produced a string with the wrong number of "%s"s.  */
+  {
+    char *yyp = *yymsg;
+    int yyi = 0;
+    while ((*yyp = *yyformat) != '\0')
+      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
+        {
+          yyp += yytnamerr (yyp, yyarg[yyi++]);
+          yyformat += 2;
+        }
+      else
+        {
+          yyp++;
+          yyformat++;
+        }
+  }
+  return 0;
 }
 #endif /* YYERROR_VERBOSE */
-
 
 /*-----------------------------------------------.
 | Release the memory associated to this symbol.  |
@@ -1359,6 +1402,7 @@ yydestruct (yymsg, yytype, yyvaluep)
     }
 }
 
+
 /* Prevent warnings from -Wmissing-prototypes.  */
 #ifdef YYPARSE_PARAM
 #if defined __STDC__ || defined __cplusplus
@@ -1385,10 +1429,9 @@ YYSTYPE yylval;
 int yynerrs;
 
 
-
-/*-------------------------.
-| yyparse or yypush_parse.  |
-`-------------------------*/
+/*----------.
+| yyparse.  |
+`----------*/
 
 #ifdef YYPARSE_PARAM
 #if (defined __STDC__ || defined __C99__FUNC__ \
@@ -1412,8 +1455,6 @@ yyparse ()
 #endif
 #endif
 {
-
-
     int yystate;
     /* Number of tokens to shift before error messages enabled.  */
     int yyerrstatus;
@@ -1568,7 +1609,7 @@ yybackup:
 
   /* First try to decide what to do without reference to lookahead token.  */
   yyn = yypact[yystate];
-  if (yyn == YYPACT_NINF)
+  if (yypact_value_is_default (yyn))
     goto yydefault;
 
   /* Not known => get a lookahead token if don't already have one.  */
@@ -1599,8 +1640,8 @@ yybackup:
   yyn = yytable[yyn];
   if (yyn <= 0)
     {
-      if (yyn == 0 || yyn == YYTABLE_NINF)
-	goto yyerrlab;
+      if (yytable_value_is_error (yyn))
+        goto yyerrlab;
       yyn = -yyn;
       goto yyreduce;
     }
@@ -1655,42 +1696,42 @@ yyreduce:
     {
         case 4:
 
-    { is_typedef = 0; is_extern = 0; current_name = NULL; decl_spec = NULL; ;}
+    { is_typedef = 0; is_extern = 0; current_name = NULL; decl_spec = NULL; }
     break;
 
   case 5:
 
-    { free_list(*(yyvsp[(2) - (2)]), NULL); *(yyvsp[(2) - (2)]) = NULL; ;}
+    { free_list(*(yyvsp[(2) - (2)]), NULL); *(yyvsp[(2) - (2)]) = NULL; }
     break;
 
   case 6:
 
-    { is_typedef = 1; ;}
+    { is_typedef = 1; }
     break;
 
   case 7:
 
-    { (yyval) = (yyvsp[(4) - (4)]); ;}
+    { (yyval) = (yyvsp[(4) - (4)]); }
     break;
 
   case 8:
 
-    { is_typedef = 1; ;}
+    { is_typedef = 1; }
     break;
 
   case 9:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 14:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 15:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 16:
@@ -1704,12 +1745,12 @@ yyreduce:
 		    current_name = NULL;
 		  }
 		  (yyval) = (yyvsp[(3) - (3)]);
-		;}
+		}
     break;
 
   case 17:
 
-    { (yyval) = NULL; ;}
+    { (yyval) = NULL; }
     break;
 
   case 19:
@@ -1720,7 +1761,7 @@ yyreduce:
 			     is_typedef ? SYM_TYPEDEF : SYM_NORMAL, decl, is_extern);
 		  current_name = NULL;
 		  (yyval) = (yyvsp[(1) - (1)]);
-		;}
+		}
     break;
 
   case 20:
@@ -1733,27 +1774,27 @@ yyreduce:
 			     is_typedef ? SYM_TYPEDEF : SYM_NORMAL, decl, is_extern);
 		  current_name = NULL;
 		  (yyval) = (yyvsp[(3) - (3)]);
-		;}
+		}
     break;
 
   case 21:
 
-    { (yyval) = (yyvsp[(4) - (4)]) ? (yyvsp[(4) - (4)]) : (yyvsp[(3) - (4)]) ? (yyvsp[(3) - (4)]) : (yyvsp[(2) - (4)]) ? (yyvsp[(2) - (4)]) : (yyvsp[(1) - (4)]); ;}
+    { (yyval) = (yyvsp[(4) - (4)]) ? (yyvsp[(4) - (4)]) : (yyvsp[(3) - (4)]) ? (yyvsp[(3) - (4)]) : (yyvsp[(2) - (4)]) ? (yyvsp[(2) - (4)]) : (yyvsp[(1) - (4)]); }
     break;
 
   case 22:
 
-    { decl_spec = NULL; ;}
+    { decl_spec = NULL; }
     break;
 
   case 24:
 
-    { decl_spec = *(yyvsp[(1) - (1)]); ;}
+    { decl_spec = *(yyvsp[(1) - (1)]); }
     break;
 
   case 25:
 
-    { decl_spec = *(yyvsp[(2) - (2)]); ;}
+    { decl_spec = *(yyvsp[(2) - (2)]); }
     break;
 
   case 26:
@@ -1762,97 +1803,82 @@ yyreduce:
 		     is really irrelevant to the linkage.  */
 		  remove_node((yyvsp[(1) - (1)]));
 		  (yyval) = (yyvsp[(1) - (1)]);
-		;}
+		}
     break;
 
   case 31:
 
-    { is_extern = 1; (yyval) = (yyvsp[(1) - (1)]); ;}
+    { is_extern = 1; (yyval) = (yyvsp[(1) - (1)]); }
     break;
 
   case 32:
 
-    { is_extern = 0; (yyval) = (yyvsp[(1) - (1)]); ;}
+    { is_extern = 0; (yyval) = (yyvsp[(1) - (1)]); }
     break;
 
   case 37:
 
-    { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_STRUCT; (yyval) = (yyvsp[(2) - (2)]); ;}
+    { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_STRUCT; (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 38:
 
-    { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_UNION; (yyval) = (yyvsp[(2) - (2)]); ;}
+    { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_UNION; (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 39:
 
-    { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_ENUM; (yyval) = (yyvsp[(2) - (2)]); ;}
+    { remove_node((yyvsp[(1) - (2)])); (*(yyvsp[(2) - (2)]))->tag = SYM_ENUM; (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 40:
 
-    { struct string_list *s = *(yyvsp[(3) - (3)]), *i = *(yyvsp[(2) - (3)]), *r;
-		  r = copy_node(i); r->tag = SYM_STRUCT;
-		  r->next = (*(yyvsp[(1) - (3)]))->next; *(yyvsp[(3) - (3)]) = r; (*(yyvsp[(1) - (3)]))->next = NULL;
-		  add_symbol(i->string, SYM_STRUCT, s, is_extern);
-		  (yyval) = (yyvsp[(3) - (3)]);
-		;}
+    { record_compound((yyvsp[(1) - (3)]), (yyvsp[(2) - (3)]), (yyvsp[(3) - (3)]), SYM_STRUCT); (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 41:
 
-    { struct string_list *s = *(yyvsp[(3) - (3)]), *i = *(yyvsp[(2) - (3)]), *r;
-		  r = copy_node(i); r->tag = SYM_UNION;
-		  r->next = (*(yyvsp[(1) - (3)]))->next; *(yyvsp[(3) - (3)]) = r; (*(yyvsp[(1) - (3)]))->next = NULL;
-		  add_symbol(i->string, SYM_UNION, s, is_extern);
-		  (yyval) = (yyvsp[(3) - (3)]);
-		;}
+    { record_compound((yyvsp[(1) - (3)]), (yyvsp[(2) - (3)]), (yyvsp[(3) - (3)]), SYM_UNION); (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 42:
 
-    { struct string_list *s = *(yyvsp[(3) - (3)]), *i = *(yyvsp[(2) - (3)]), *r;
-		  r = copy_node(i); r->tag = SYM_ENUM;
-		  r->next = (*(yyvsp[(1) - (3)]))->next; *(yyvsp[(3) - (3)]) = r; (*(yyvsp[(1) - (3)]))->next = NULL;
-		  add_symbol(i->string, SYM_ENUM, s, is_extern);
-		  (yyval) = (yyvsp[(3) - (3)]);
-		;}
+    { record_compound((yyvsp[(1) - (3)]), (yyvsp[(2) - (3)]), (yyvsp[(3) - (3)]), SYM_ENUM); (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 43:
 
-    { add_symbol(NULL, SYM_ENUM, NULL, 0); (yyval) = (yyvsp[(2) - (2)]); ;}
+    { add_symbol(NULL, SYM_ENUM, NULL, 0); (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 44:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 45:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 56:
 
-    { (*(yyvsp[(1) - (1)]))->tag = SYM_TYPEDEF; (yyval) = (yyvsp[(1) - (1)]); ;}
+    { (*(yyvsp[(1) - (1)]))->tag = SYM_TYPEDEF; (yyval) = (yyvsp[(1) - (1)]); }
     break;
 
   case 57:
 
-    { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); }
     break;
 
   case 58:
 
-    { (yyval) = NULL; ;}
+    { (yyval) = NULL; }
     break;
 
   case 61:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 65:
@@ -1860,12 +1886,12 @@ yyreduce:
     { /* restrict has no effect in prototypes so ignore it */
 		  remove_node((yyvsp[(1) - (1)]));
 		  (yyval) = (yyvsp[(1) - (1)]);
-		;}
+		}
     break;
 
   case 66:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 68:
@@ -1877,97 +1903,97 @@ yyreduce:
 		    current_name = (*(yyvsp[(1) - (1)]))->string;
 		    (yyval) = (yyvsp[(1) - (1)]);
 		  }
-		;}
+		}
     break;
 
   case 69:
 
-    { (yyval) = (yyvsp[(4) - (4)]); ;}
+    { (yyval) = (yyvsp[(4) - (4)]); }
     break;
 
   case 70:
 
-    { (yyval) = (yyvsp[(4) - (4)]); ;}
+    { (yyval) = (yyvsp[(4) - (4)]); }
     break;
 
   case 71:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 72:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 73:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 74:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 78:
 
-    { (yyval) = (yyvsp[(4) - (4)]); ;}
+    { (yyval) = (yyvsp[(4) - (4)]); }
     break;
 
   case 79:
 
-    { (yyval) = (yyvsp[(4) - (4)]); ;}
+    { (yyval) = (yyvsp[(4) - (4)]); }
     break;
 
   case 80:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 81:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 82:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 83:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 85:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 86:
 
-    { (yyval) = NULL; ;}
+    { (yyval) = NULL; }
     break;
 
   case 89:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 90:
 
-    { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); }
     break;
 
   case 91:
 
-    { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); }
     break;
 
   case 93:
 
-    { (yyval) = NULL; ;}
+    { (yyval) = NULL; }
     break;
 
   case 94:
@@ -1976,39 +2002,39 @@ yyreduce:
 		     private parameter names.  */
 		  remove_node((yyvsp[(1) - (1)]));
 		  (yyval) = (yyvsp[(1) - (1)]);
-		;}
+		}
     break;
 
   case 95:
 
     { remove_node((yyvsp[(1) - (1)]));
 		  (yyval) = (yyvsp[(1) - (1)]);
-		;}
+		}
     break;
 
   case 96:
 
-    { (yyval) = (yyvsp[(4) - (4)]); ;}
+    { (yyval) = (yyvsp[(4) - (4)]); }
     break;
 
   case 97:
 
-    { (yyval) = (yyvsp[(4) - (4)]); ;}
+    { (yyval) = (yyvsp[(4) - (4)]); }
     break;
 
   case 98:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 99:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 100:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 101:
@@ -2017,87 +2043,87 @@ yyreduce:
 		  *(yyvsp[(2) - (3)]) = NULL;
 		  add_symbol(current_name, SYM_NORMAL, decl, is_extern);
 		  (yyval) = (yyvsp[(3) - (3)]);
-		;}
+		}
     break;
 
   case 102:
 
-    { (yyval) = NULL; ;}
+    { (yyval) = NULL; }
     break;
 
   case 104:
 
-    { remove_list((yyvsp[(2) - (2)]), &(*(yyvsp[(1) - (2)]))->next); (yyval) = (yyvsp[(2) - (2)]); ;}
+    { remove_list((yyvsp[(2) - (2)]), &(*(yyvsp[(1) - (2)]))->next); (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 105:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 106:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 107:
 
-    { (yyval) = NULL; ;}
+    { (yyval) = NULL; }
     break;
 
   case 110:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 111:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 112:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 113:
 
-    { (yyval) = NULL; ;}
+    { (yyval) = NULL; }
     break;
 
   case 116:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 117:
 
-    { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]) ? (yyvsp[(2) - (2)]) : (yyvsp[(1) - (2)]); }
     break;
 
   case 118:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 120:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 121:
 
-    { (yyval) = NULL; ;}
+    { (yyval) = NULL; }
     break;
 
   case 123:
 
-    { (yyval) = (yyvsp[(3) - (3)]); ;}
+    { (yyval) = (yyvsp[(3) - (3)]); }
     break;
 
   case 124:
 
-    { (yyval) = (yyvsp[(4) - (4)]); ;}
+    { (yyval) = (yyvsp[(4) - (4)]); }
     break;
 
   case 127:
@@ -2105,7 +2131,7 @@ yyreduce:
     {
 			const char *name = strdup((*(yyvsp[(1) - (1)]))->string);
 			add_symbol(name, SYM_ENUM_CONST, NULL, 0);
-		;}
+		}
     break;
 
   case 128:
@@ -2114,28 +2140,39 @@ yyreduce:
 			const char *name = strdup((*(yyvsp[(1) - (3)]))->string);
 			struct string_list *expr = copy_list_range(*(yyvsp[(3) - (3)]), *(yyvsp[(2) - (3)]));
 			add_symbol(name, SYM_ENUM_CONST, expr, 0);
-		;}
+		}
     break;
 
   case 129:
 
-    { (yyval) = (yyvsp[(2) - (2)]); ;}
+    { (yyval) = (yyvsp[(2) - (2)]); }
     break;
 
   case 130:
 
-    { (yyval) = NULL; ;}
+    { (yyval) = NULL; }
     break;
 
   case 132:
 
-    { export_symbol((*(yyvsp[(3) - (5)]))->string); (yyval) = (yyvsp[(5) - (5)]); ;}
+    { export_symbol((*(yyvsp[(3) - (5)]))->string); (yyval) = (yyvsp[(5) - (5)]); }
     break;
 
 
 
       default: break;
     }
+  /* User semantic actions sometimes alter yychar, and that requires
+     that yytoken be updated with the new translation.  We take the
+     approach of translating immediately before every use of yytoken.
+     One alternative is translating here after every semantic action,
+     but that translation would be missed if the semantic action invokes
+     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
+     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
+     incorrect destructor might then be invoked immediately.  In the
+     case of YYERROR or YYBACKUP, subsequent parser actions might lead
+     to an incorrect destructor call or verbose syntax error message
+     before the lookahead is translated.  */
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
 
   YYPOPSTACK (yylen);
@@ -2163,6 +2200,10 @@ yyreduce:
 | yyerrlab -- here on detecting error |
 `------------------------------------*/
 yyerrlab:
+  /* Make sure we have latest lookahead translation.  See comments at
+     user semantic actions for why this is necessary.  */
+  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);
+
   /* If not already recovering from an error, report this error.  */
   if (!yyerrstatus)
     {
@@ -2170,37 +2211,36 @@ yyerrlab:
 #if ! YYERROR_VERBOSE
       yyerror (YY_("syntax error"));
 #else
+# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
+                                        yyssp, yytoken)
       {
-	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
-	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
-	  {
-	    YYSIZE_T yyalloc = 2 * yysize;
-	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
-	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
-	    if (yymsg != yymsgbuf)
-	      YYSTACK_FREE (yymsg);
-	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
-	    if (yymsg)
-	      yymsg_alloc = yyalloc;
-	    else
-	      {
-		yymsg = yymsgbuf;
-		yymsg_alloc = sizeof yymsgbuf;
-	      }
-	  }
-
-	if (0 < yysize && yysize <= yymsg_alloc)
-	  {
-	    (void) yysyntax_error (yymsg, yystate, yychar);
-	    yyerror (yymsg);
-	  }
-	else
-	  {
-	    yyerror (YY_("syntax error"));
-	    if (yysize != 0)
-	      goto yyexhaustedlab;
-	  }
+        char const *yymsgp = YY_("syntax error");
+        int yysyntax_error_status;
+        yysyntax_error_status = YYSYNTAX_ERROR;
+        if (yysyntax_error_status == 0)
+          yymsgp = yymsg;
+        else if (yysyntax_error_status == 1)
+          {
+            if (yymsg != yymsgbuf)
+              YYSTACK_FREE (yymsg);
+            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
+            if (!yymsg)
+              {
+                yymsg = yymsgbuf;
+                yymsg_alloc = sizeof yymsgbuf;
+                yysyntax_error_status = 2;
+              }
+            else
+              {
+                yysyntax_error_status = YYSYNTAX_ERROR;
+                yymsgp = yymsg;
+              }
+          }
+        yyerror (yymsgp);
+        if (yysyntax_error_status == 2)
+          goto yyexhaustedlab;
       }
+# undef YYSYNTAX_ERROR
 #endif
     }
 
@@ -2259,7 +2299,7 @@ yyerrlab1:
   for (;;)
     {
       yyn = yypact[yystate];
-      if (yyn != YYPACT_NINF)
+      if (!yypact_value_is_default (yyn))
 	{
 	  yyn += YYTERROR;
 	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
@@ -2318,8 +2358,13 @@ yyexhaustedlab:
 
 yyreturn:
   if (yychar != YYEMPTY)
-     yydestruct ("Cleanup: discarding lookahead",
-		 yytoken, &yylval);
+    {
+      /* Make sure we have latest lookahead translation.  See comments at
+         user semantic actions for why this is necessary.  */
+      yytoken = YYTRANSLATE (yychar);
+      yydestruct ("Cleanup: discarding lookahead",
+                  yytoken, &yylval);
+    }
   /* Do not reclaim the symbols of the rule which action triggered
      this YYABORT or YYACCEPT.  */
   YYPOPSTACK (yylen);
diff --git a/scripts/genksyms/parse.tab.h_shipped b/scripts/genksyms/parse.tab.h_shipped
index 350c2b4..93240a3 100644
--- a/scripts/genksyms/parse.tab.h_shipped
+++ b/scripts/genksyms/parse.tab.h_shipped
@@ -1,9 +1,8 @@
-/* A Bison parser, made by GNU Bison 2.4.3.  */
+/* A Bison parser, made by GNU Bison 2.5.  */
 
-/* Skeleton interface for Bison's Yacc-like parsers in C
+/* Bison interface for Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
-   2009, 2010 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
-- 
1.7.6.1

