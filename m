Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab1JKKNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:13:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1JKKNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:13:14 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] genksyms: Minor parser cleanup
Date: Tue, 11 Oct 2011 12:12:47 +0200
Message-Id: <1318327969-24807-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1318327969-24807-1-git-send-email-mmarek@suse.cz>
References: <1318327969-24807-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the identical logic for recording a struct/union/enum definition to
a function.
---
 scripts/genksyms/parse.y |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/scripts/genksyms/parse.y b/scripts/genksyms/parse.y
index ba5c242..a783ad4 100644
--- a/scripts/genksyms/parse.y
+++ b/scripts/genksyms/parse.y
@@ -51,6 +51,18 @@ remove_list(struct string_list **pb, struct string_list **pe)
   free_list(b, e);
 }
 
+/* Record definition of a struct/union/enum */
+static void record_compound(struct string_list **keyw,
+		       struct string_list **ident,
+		       struct string_list **body,
+		       enum symbol_type type)
+{
+	struct string_list *b = *body, *i = *ident, *r;
+	r = copy_node(i); r->tag = type;
+	r->next = (*keyw)->next; *body = r; (*keyw)->next = NULL;
+	add_symbol(i->string, type, b, is_extern);
+}
+
 %}
 
 %token ASM_KEYW
@@ -215,26 +227,11 @@ type_specifier:
 
 	/* Full definitions of an s/u/e.  Record it.  */
 	| STRUCT_KEYW IDENT class_body
-		{ struct string_list *s = *$3, *i = *$2, *r;
-		  r = copy_node(i); r->tag = SYM_STRUCT;
-		  r->next = (*$1)->next; *$3 = r; (*$1)->next = NULL;
-		  add_symbol(i->string, SYM_STRUCT, s, is_extern);
-		  $$ = $3;
-		}
+		{ record_compound($1, $2, $3, SYM_STRUCT); $$ = $3; }
 	| UNION_KEYW IDENT class_body
-		{ struct string_list *s = *$3, *i = *$2, *r;
-		  r = copy_node(i); r->tag = SYM_UNION;
-		  r->next = (*$1)->next; *$3 = r; (*$1)->next = NULL;
-		  add_symbol(i->string, SYM_UNION, s, is_extern);
-		  $$ = $3;
-		}
+		{ record_compound($1, $2, $3, SYM_UNION); $$ = $3; }
 	| ENUM_KEYW IDENT enum_body
-		{ struct string_list *s = *$3, *i = *$2, *r;
-		  r = copy_node(i); r->tag = SYM_ENUM;
-		  r->next = (*$1)->next; *$3 = r; (*$1)->next = NULL;
-		  add_symbol(i->string, SYM_ENUM, s, is_extern);
-		  $$ = $3;
-		}
+		{ record_compound($1, $2, $3, SYM_ENUM); $$ = $3; }
 	/*
 	 * Anonymous enum definition. Tell add_symbol() to restart its counter.
 	 */
-- 
1.7.6.1

