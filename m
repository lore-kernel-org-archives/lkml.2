Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1CMGcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:32:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab1CMGbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:31:01 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] genksyms: Add helpers for building string lists
Date: Sun, 13 Mar 2011 07:30:22 +0100
Message-Id: <1299997825-18977-5-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/genksyms/genksyms.c |   70 +++++++++++++++++++++++-------------------
 1 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index 2a1a3b8..d17b7a2 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -66,6 +66,8 @@ static const struct {
 
 static int equal_list(struct string_list *a, struct string_list *b);
 static void print_list(FILE * f, struct string_list *list);
+static struct string_list *concat_list(struct string_list *start, ...);
+static struct string_list *mk_node(const char *string);
 static void print_location(void);
 static void print_type_name(enum symbol_type type, const char *name);
 
@@ -299,6 +301,35 @@ void free_list(struct string_list *s, struct string_list *e)
 	}
 }
 
+static struct string_list *mk_node(const char *string)
+{
+	struct string_list *newnode;
+
+	newnode = xmalloc(sizeof(*newnode));
+	newnode->string = xstrdup(string);
+	newnode->tag = SYM_NORMAL;
+	newnode->next = NULL;
+
+	return newnode;
+}
+
+static struct string_list *concat_list(struct string_list *start, ...)
+{
+	va_list ap;
+	struct string_list *n, *n2;
+
+	if (!start)
+		return NULL;
+	for (va_start(ap, start); (n = va_arg(ap, struct string_list *));) {
+		for (n2 = n; n2->next; n2 = n2->next)
+			;
+		n2->next = start;
+		start = n;
+	}
+	va_end(ap);
+	return start;
+}
+
 struct string_list *copy_node(struct string_list *node)
 {
 	struct string_list *newnode;
@@ -499,42 +530,17 @@ static unsigned long expand_and_crc_sym(struct symbol *sym, unsigned long crc)
 		case SYM_ENUM:
 			subsym = find_symbol(cur->string, cur->tag);
 			if (!subsym) {
-				struct string_list *n, *t = NULL;
+				struct string_list *n;
 
 				error_with_pos("expand undefined %s %s",
 					       symbol_types[cur->tag].name,
 					       cur->string);
-
-				n = xmalloc(sizeof(*n));
-				n->string = xstrdup(symbol_types[cur->tag].name);
-				n->tag = SYM_NORMAL;
-				n->next = t;
-				t = n;
-
-				n = xmalloc(sizeof(*n));
-				n->string = xstrdup(cur->string);
-				n->tag = SYM_NORMAL;
-				n->next = t;
-				t = n;
-
-				n = xmalloc(sizeof(*n));
-				n->string = xstrdup("{");
-				n->tag = SYM_NORMAL;
-				n->next = t;
-				t = n;
-
-				n = xmalloc(sizeof(*n));
-				n->string = xstrdup("UNKNOWN");
-				n->tag = SYM_NORMAL;
-				n->next = t;
-				t = n;
-
-				n = xmalloc(sizeof(*n));
-				n->string = xstrdup("}");
-				n->tag = SYM_NORMAL;
-				n->next = t;
-				t = n;
-
+				n = concat_list(mk_node
+						(symbol_types[cur->tag].name),
+						mk_node(cur->string),
+						mk_node("{"),
+						mk_node("UNKNOWN"),
+						mk_node("}"), NULL);
 				subsym =
 				    add_symbol(cur->string, cur->tag, n, 0);
 			}
-- 
1.7.4.1

