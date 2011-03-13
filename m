Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1CMGbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:31:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:44108 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab1CMGbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:31:01 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] genksyms: Simplify printing of symbol types
Date: Sun, 13 Mar 2011 07:30:21 +0100
Message-Id: <1299997825-18977-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of special-casing SYM_NORMAL, do not map any name to it. Also
explicitly set the single-letter name of the symbol type, which will be
needed by a further patch. The only user-visible change is one debug
printf.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/genksyms/genksyms.c |   43 +++++++++++++++++++++++++++----------------
 1 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index f99115e..2a1a3b8 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -53,8 +53,15 @@ static int nsyms;
 static struct symbol *expansion_trail;
 static struct symbol *visited_symbols;
 
-static const char *const symbol_type_name[] = {
-	"normal", "typedef", "enum", "struct", "union"
+static const struct {
+	int n;
+	const char *name;
+} symbol_types[] = {
+	[SYM_NORMAL]     = { 0, NULL},
+	[SYM_TYPEDEF]    = {'t', "typedef"},
+	[SYM_ENUM]       = {'e', "enum"},
+	[SYM_STRUCT]     = {'s', "struct"},
+	[SYM_UNION]      = {'u', "union"},
 };
 
 static int equal_list(struct string_list *a, struct string_list *b);
@@ -247,8 +254,12 @@ static struct symbol *__add_symbol(const char *name, enum symbol_type type,
 	sym->is_override = 0;
 
 	if (flag_debug) {
-		fprintf(debugfile, "Defn for %s %s == <",
-			symbol_type_name[type], name);
+		if (symbol_types[type].name)
+			fprintf(debugfile, "Defn for %s %s == <",
+				symbol_types[type].name, name);
+		else
+			fprintf(debugfile, "Defn for type%d %s == <",
+				type, name);
 		if (is_extern)
 			fputs("extern ", debugfile);
 		print_list(debugfile, defn);
@@ -346,8 +357,8 @@ static struct string_list *read_node(FILE *f)
 	if (node.string[1] == '#') {
 		int n;
 
-		for (n = 0; n < ARRAY_SIZE(symbol_type_name); n++) {
-			if (node.string[0] == symbol_type_name[n][0]) {
+		for (n = 0; n < ARRAY_SIZE(symbol_types); n++) {
+			if (node.string[0] == symbol_types[n].n) {
 				node.tag = n;
 				node.string += 2;
 				return copy_node(&node);
@@ -397,8 +408,8 @@ static void read_reference(FILE *f)
 
 static void print_node(FILE * f, struct string_list *list)
 {
-	if (list->tag != SYM_NORMAL) {
-		putc(symbol_type_name[list->tag][0], f);
+	if (symbol_types[list->tag].n) {
+		putc(symbol_types[list->tag].n, f);
 		putc('#', f);
 	}
 	fputs(list->string, f);
@@ -491,11 +502,11 @@ static unsigned long expand_and_crc_sym(struct symbol *sym, unsigned long crc)
 				struct string_list *n, *t = NULL;
 
 				error_with_pos("expand undefined %s %s",
-					       symbol_type_name[cur->tag],
+					       symbol_types[cur->tag].name,
 					       cur->string);
 
 				n = xmalloc(sizeof(*n));
-				n->string = xstrdup(symbol_type_name[cur->tag]);
+				n->string = xstrdup(symbol_types[cur->tag].name);
 				n->tag = SYM_NORMAL;
 				n->next = t;
 				t = n;
@@ -530,11 +541,11 @@ static unsigned long expand_and_crc_sym(struct symbol *sym, unsigned long crc)
 			if (subsym->expansion_trail) {
 				if (flag_dump_defs) {
 					fprintf(debugfile, "%s %s ",
-						symbol_type_name[cur->tag],
+						symbol_types[cur->tag].name,
 						cur->string);
 				}
 
-				crc = partial_crc32(symbol_type_name[cur->tag],
+				crc = partial_crc32(symbol_types[cur->tag].name,
 						    crc);
 				crc = partial_crc32_one(' ', crc);
 				crc = partial_crc32(cur->string, crc);
@@ -624,8 +635,8 @@ static void print_location(void)
 
 static void print_type_name(enum symbol_type type, const char *name)
 {
-	if (type != SYM_NORMAL)
-		fprintf(stderr, "%s %s", symbol_type_name[type], name);
+	if (symbol_types[type].name)
+		fprintf(stderr, "%s %s", symbol_types[type].name, name);
 	else
 		fprintf(stderr, "%s", name);
 }
@@ -771,8 +782,8 @@ int main(int argc, char **argv)
 
 			if (sym->is_override)
 				fputs("override ", dumpfile);
-			if (sym->type != SYM_NORMAL) {
-				putc(symbol_type_name[sym->type][0], dumpfile);
+			if (symbol_types[sym->type].n) {
+				putc(symbol_types[sym->type].n, dumpfile);
 				putc('#', dumpfile);
 			}
 			fputs(sym->name, dumpfile);
-- 
1.7.4.1

