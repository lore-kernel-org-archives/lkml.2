Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1CMGbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:31:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1CMGbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:31:01 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] genksyms: Track changes to enum constants
Date: Sun, 13 Mar 2011 07:30:24 +0100
Message-Id: <1299997825-18977-7-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enum constants can be used as array sizes; if the enum itself does not
appear in the symbol expansion, a change in the enum constant will go
unnoticed. Therefore, remember the value of each enum constant and
expand each occurence to <constant> <value>.

Note: The changes won't take effect until the lexer and parser are
rebuilt by the next patch.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/genksyms/genksyms.c |   71 ++++++++++++++++++++++++++++++++++++++++---
 scripts/genksyms/genksyms.h |    5 ++-
 scripts/genksyms/lex.l      |   30 ++++++++++++++++--
 scripts/genksyms/parse.y    |   34 ++++++++++++++++++--
 4 files changed, 127 insertions(+), 13 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index 4a35081..f9e7553 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -62,6 +62,7 @@ static const struct {
 	[SYM_ENUM]       = {'e', "enum"},
 	[SYM_STRUCT]     = {'s', "struct"},
 	[SYM_UNION]      = {'u', "union"},
+	[SYM_ENUM_CONST] = {'E', "enum constant"},
 };
 
 static int equal_list(struct string_list *a, struct string_list *b);
@@ -149,10 +150,16 @@ static unsigned long crc32(const char *s)
 
 static enum symbol_type map_to_ns(enum symbol_type t)
 {
-	if (t == SYM_TYPEDEF)
-		t = SYM_NORMAL;
-	else if (t == SYM_UNION)
-		t = SYM_STRUCT;
+	switch (t) {
+	case SYM_ENUM_CONST:
+	case SYM_NORMAL:
+	case SYM_TYPEDEF:
+		return SYM_NORMAL;
+	case SYM_ENUM:
+	case SYM_STRUCT:
+	case SYM_UNION:
+		return SYM_STRUCT;
+	}
 	return t;
 }
 
@@ -191,10 +198,47 @@ static struct symbol *__add_symbol(const char *name, enum symbol_type type,
 			    struct string_list *defn, int is_extern,
 			    int is_reference)
 {
-	unsigned long h = crc32(name) % HASH_BUCKETS;
+	unsigned long h;
 	struct symbol *sym;
 	enum symbol_status status = STATUS_UNCHANGED;
+	/* The parser adds symbols in the order their declaration completes,
+	 * so it is safe to store the value of the previous enum constant in
+	 * a static variable.
+	 */
+	static int enum_counter;
+	static struct string_list *last_enum_expr;
+
+	if (type == SYM_ENUM_CONST) {
+		if (defn) {
+			free_list(last_enum_expr, NULL);
+			last_enum_expr = copy_list_range(defn, NULL);
+			enum_counter = 1;
+		} else {
+			struct string_list *expr;
+			char buf[20];
+
+			snprintf(buf, sizeof(buf), "%d", enum_counter++);
+			if (last_enum_expr) {
+				expr = copy_list_range(last_enum_expr, NULL);
+				defn = concat_list(mk_node("("),
+						   expr,
+						   mk_node(")"),
+						   mk_node("+"),
+						   mk_node(buf), NULL);
+			} else {
+				defn = mk_node(buf);
+			}
+		}
+	} else if (type == SYM_ENUM) {
+		free_list(last_enum_expr, NULL);
+		last_enum_expr = NULL;
+		enum_counter = 0;
+		if (!name)
+			/* Anonymous enum definition, nothing more to do */
+			return NULL;
+	}
 
+	h = crc32(name) % HASH_BUCKETS;
 	for (sym = symtab[h]; sym; sym = sym->hash_next) {
 		if (map_to_ns(sym->type) == map_to_ns(type) &&
 		    strcmp(name, sym->name) == 0) {
@@ -343,6 +387,22 @@ struct string_list *copy_node(struct string_list *node)
 	return newnode;
 }
 
+struct string_list *copy_list_range(struct string_list *start,
+				    struct string_list *end)
+{
+	struct string_list *res, *n;
+
+	if (start == end)
+		return NULL;
+	n = res = copy_node(start);
+	for (start = start->next; start != end; start = start->next) {
+		n->next = copy_node(start);
+		n = n->next;
+	}
+	n->next = NULL;
+	return res;
+}
+
 static int equal_list(struct string_list *a, struct string_list *b)
 {
 	while (a && b) {
@@ -512,6 +572,7 @@ static unsigned long expand_and_crc_sym(struct symbol *sym, unsigned long crc)
 			crc = partial_crc32_one(' ', crc);
 			break;
 
+		case SYM_ENUM_CONST:
 		case SYM_TYPEDEF:
 			subsym = find_symbol(cur->string, cur->tag, 0);
 			/* FIXME: Bad reference files can segfault here. */
diff --git a/scripts/genksyms/genksyms.h b/scripts/genksyms/genksyms.h
index 9fdafb6..7ec52ae 100644
--- a/scripts/genksyms/genksyms.h
+++ b/scripts/genksyms/genksyms.h
@@ -26,7 +26,8 @@
 #include <stdio.h>
 
 enum symbol_type {
-	SYM_NORMAL, SYM_TYPEDEF, SYM_ENUM, SYM_STRUCT, SYM_UNION
+	SYM_NORMAL, SYM_TYPEDEF, SYM_ENUM, SYM_STRUCT, SYM_UNION,
+	SYM_ENUM_CONST
 };
 
 enum symbol_status {
@@ -66,6 +67,8 @@ void export_symbol(const char *);
 void free_node(struct string_list *list);
 void free_list(struct string_list *s, struct string_list *e);
 struct string_list *copy_node(struct string_list *);
+struct string_list *copy_list_range(struct string_list *start,
+				    struct string_list *end);
 
 int yylex(void);
 int yyparse(void);
diff --git a/scripts/genksyms/lex.l b/scripts/genksyms/lex.l
index c125d06..e4ddd49 100644
--- a/scripts/genksyms/lex.l
+++ b/scripts/genksyms/lex.l
@@ -99,12 +99,23 @@ MC_TOKEN		([~%^&*+=|<>/-]=)|(&&)|("||")|(->)|(<<)|(>>)
 
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
@@ -182,8 +193,8 @@ repeat:
 
 		  case STRUCT_KEYW:
 		  case UNION_KEYW:
-		    dont_want_brace_phrase = 3;
 		  case ENUM_KEYW:
+		    dont_want_brace_phrase = 3;
 		    suppress_type_lookup = 2;
 		    goto fini;
 
@@ -312,7 +323,20 @@ repeat:
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
diff --git a/scripts/genksyms/parse.y b/scripts/genksyms/parse.y
index 09a265c..ba5c242 100644
--- a/scripts/genksyms/parse.y
+++ b/scripts/genksyms/parse.y
@@ -25,6 +25,7 @@
 
 #include <assert.h>
 #include <stdlib.h>
+#include <string.h>
 #include "genksyms.h"
 
 static int is_typedef;
@@ -227,16 +228,19 @@ type_specifier:
 		  add_symbol(i->string, SYM_UNION, s, is_extern);
 		  $$ = $3;
 		}
-	| ENUM_KEYW IDENT BRACE_PHRASE
+	| ENUM_KEYW IDENT enum_body
 		{ struct string_list *s = *$3, *i = *$2, *r;
 		  r = copy_node(i); r->tag = SYM_ENUM;
 		  r->next = (*$1)->next; *$3 = r; (*$1)->next = NULL;
 		  add_symbol(i->string, SYM_ENUM, s, is_extern);
 		  $$ = $3;
 		}
-
-	/* Anonymous s/u/e definitions.  Nothing needs doing.  */
-	| ENUM_KEYW BRACE_PHRASE			{ $$ = $2; }
+	/*
+	 * Anonymous enum definition. Tell add_symbol() to restart its counter.
+	 */
+	| ENUM_KEYW enum_body
+		{ add_symbol(NULL, SYM_ENUM, NULL, 0); $$ = $2; }
+	/* Anonymous s/u definitions.  Nothing needs doing.  */
 	| STRUCT_KEYW class_body			{ $$ = $2; }
 	| UNION_KEYW class_body				{ $$ = $2; }
 	;
@@ -449,6 +453,28 @@ attribute_opt:
 	| attribute_opt ATTRIBUTE_PHRASE
 	;
 
+enum_body:
+	'{' enumerator_list '}'				{ $$ = $3; }
+	| '{' enumerator_list ',' '}'			{ $$ = $4; }
+	 ;
+
+enumerator_list:
+	enumerator
+	| enumerator_list ',' enumerator
+
+enumerator:
+	IDENT
+		{
+			const char *name = strdup((*$1)->string);
+			add_symbol(name, SYM_ENUM_CONST, NULL, 0);
+		}
+	| IDENT '=' EXPRESSION_PHRASE
+		{
+			const char *name = strdup((*$1)->string);
+			struct string_list *expr = copy_list_range(*$3, *$2);
+			add_symbol(name, SYM_ENUM_CONST, expr, 0);
+		}
+
 asm_definition:
 	ASM_PHRASE ';'					{ $$ = $2; }
 	;
-- 
1.7.4.1

