Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1CMGb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:31:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:44107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab1CMGbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:31:01 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] genksyms: simplify usage of find_symbol()
Date: Sun, 13 Mar 2011 07:30:23 +0100
Message-Id: <1299997825-18977-6-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow searching for symbols of an exact type. The lexer does this and a
subsequent patch will add one more usage.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/genksyms/genksyms.c    |   10 ++++++----
 scripts/genksyms/genksyms.h    |    2 +-
 scripts/genksyms/lex.c_shipped |    3 +--
 scripts/genksyms/lex.l         |    3 +--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index d17b7a2..4a35081 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -156,7 +156,7 @@ static enum symbol_type map_to_ns(enum symbol_type t)
 	return t;
 }
 
-struct symbol *find_symbol(const char *name, enum symbol_type ns)
+struct symbol *find_symbol(const char *name, enum symbol_type ns, int exact)
 {
 	unsigned long h = crc32(name) % HASH_BUCKETS;
 	struct symbol *sym;
@@ -167,6 +167,8 @@ struct symbol *find_symbol(const char *name, enum symbol_type ns)
 		    sym->is_declared)
 			break;
 
+	if (exact && sym && sym->type != ns)
+		return NULL;
 	return sym;
 }
 
@@ -511,7 +513,7 @@ static unsigned long expand_and_crc_sym(struct symbol *sym, unsigned long crc)
 			break;
 
 		case SYM_TYPEDEF:
-			subsym = find_symbol(cur->string, cur->tag);
+			subsym = find_symbol(cur->string, cur->tag, 0);
 			/* FIXME: Bad reference files can segfault here. */
 			if (subsym->expansion_trail) {
 				if (flag_dump_defs)
@@ -528,7 +530,7 @@ static unsigned long expand_and_crc_sym(struct symbol *sym, unsigned long crc)
 		case SYM_STRUCT:
 		case SYM_UNION:
 		case SYM_ENUM:
-			subsym = find_symbol(cur->string, cur->tag);
+			subsym = find_symbol(cur->string, cur->tag, 0);
 			if (!subsym) {
 				struct string_list *n;
 
@@ -582,7 +584,7 @@ void export_symbol(const char *name)
 {
 	struct symbol *sym;
 
-	sym = find_symbol(name, SYM_NORMAL);
+	sym = find_symbol(name, SYM_NORMAL, 0);
 	if (!sym)
 		error_with_pos("export undefined symbol %s", name);
 	else {
diff --git a/scripts/genksyms/genksyms.h b/scripts/genksyms/genksyms.h
index 25c4d40..9fdafb6 100644
--- a/scripts/genksyms/genksyms.h
+++ b/scripts/genksyms/genksyms.h
@@ -58,7 +58,7 @@ typedef struct string_list **yystype;
 extern int cur_line;
 extern char *cur_filename;
 
-struct symbol *find_symbol(const char *name, enum symbol_type ns);
+struct symbol *find_symbol(const char *name, enum symbol_type ns, int exact);
 struct symbol *add_symbol(const char *name, enum symbol_type type,
 			  struct string_list *defn, int is_extern);
 void export_symbol(const char *);
diff --git a/scripts/genksyms/lex.c_shipped b/scripts/genksyms/lex.c_shipped
index d0a0423..f231c08 100644
--- a/scripts/genksyms/lex.c_shipped
+++ b/scripts/genksyms/lex.c_shipped
@@ -2347,8 +2347,7 @@ repeat:
 	      }
 	    if (!suppress_type_lookup)
 	      {
-		struct symbol *sym = find_symbol(yytext, SYM_TYPEDEF);
-		if (sym && sym->type == SYM_TYPEDEF)
+		if (find_symbol(yytext, SYM_TYPEDEF, 1))
 		  token = TYPE;
 	      }
 	  }
diff --git a/scripts/genksyms/lex.l b/scripts/genksyms/lex.l
index 4687b1d..c125d06 100644
--- a/scripts/genksyms/lex.l
+++ b/scripts/genksyms/lex.l
@@ -193,8 +193,7 @@ repeat:
 	      }
 	    if (!suppress_type_lookup)
 	      {
-		struct symbol *sym = find_symbol(yytext, SYM_TYPEDEF);
-		if (sym && sym->type == SYM_TYPEDEF)
+		if (find_symbol(yytext, SYM_TYPEDEF, 1))
 		  token = TYPE;
 	      }
 	  }
-- 
1.7.4.1

