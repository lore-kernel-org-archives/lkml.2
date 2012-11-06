Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2KFO0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 09:26:37 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41295 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2KFO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 09:26:35 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] malloc: Fix malloc handling in conf tools
To: mmarek@suse.cz, linux-kernel@vger.kernel.org
Date: Tue, 06 Nov 2012 14:32:08 +0000
Message-ID: <20121106143206.21941.22214.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

(and get them out of the noise in the audit work)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 scripts/kconfig/expr.c   |   10 +++++-----
 scripts/kconfig/lkc.h    |    2 ++
 scripts/kconfig/menu.c   |    4 ++--
 scripts/kconfig/symbol.c |   12 ++++++------
 scripts/kconfig/util.c   |   23 +++++++++++++++++++++--
 scripts/kconfig/zconf.l  |    8 ++++----
 6 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index 290ce41..d662652 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -13,7 +13,7 @@
 
 struct expr *expr_alloc_symbol(struct symbol *sym)
 {
-	struct expr *e = calloc(1, sizeof(*e));
+	struct expr *e = xcalloc(1, sizeof(*e));
 	e->type = E_SYMBOL;
 	e->left.sym = sym;
 	return e;
@@ -21,7 +21,7 @@ struct expr *expr_alloc_symbol(struct symbol *sym)
 
 struct expr *expr_alloc_one(enum expr_type type, struct expr *ce)
 {
-	struct expr *e = calloc(1, sizeof(*e));
+	struct expr *e = xcalloc(1, sizeof(*e));
 	e->type = type;
 	e->left.expr = ce;
 	return e;
@@ -29,7 +29,7 @@ struct expr *expr_alloc_one(enum expr_type type, struct expr *ce)
 
 struct expr *expr_alloc_two(enum expr_type type, struct expr *e1, struct expr *e2)
 {
-	struct expr *e = calloc(1, sizeof(*e));
+	struct expr *e = xcalloc(1, sizeof(*e));
 	e->type = type;
 	e->left.expr = e1;
 	e->right.expr = e2;
@@ -38,7 +38,7 @@ struct expr *expr_alloc_two(enum expr_type type, struct expr *e1, struct expr *e
 
 struct expr *expr_alloc_comp(enum expr_type type, struct symbol *s1, struct symbol *s2)
 {
-	struct expr *e = calloc(1, sizeof(*e));
+	struct expr *e = xcalloc(1, sizeof(*e));
 	e->type = type;
 	e->left.sym = s1;
 	e->right.sym = s2;
@@ -66,7 +66,7 @@ struct expr *expr_copy(const struct expr *org)
 	if (!org)
 		return NULL;
 
-	e = malloc(sizeof(*org));
+	e = xmalloc(sizeof(*org));
 	memcpy(e, org, sizeof(*org));
 	switch (org->type) {
 	case E_SYMBOL:
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index c18f2bd..e231638 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -116,6 +116,8 @@ void menu_set_type(int type);
 /* util.c */
 struct file *file_lookup(const char *name);
 int file_write_dep(const char *name);
+void *xmalloc(size_t size);
+void *xcalloc(size_t nmemb, size_t size);
 
 struct gstr {
 	size_t len;
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index e98a05c..f3bffa3 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -48,7 +48,7 @@ void menu_add_entry(struct symbol *sym)
 {
 	struct menu *menu;
 
-	menu = malloc(sizeof(*menu));
+	menu = xmalloc(sizeof(*menu));
 	memset(menu, 0, sizeof(*menu));
 	menu->sym = sym;
 	menu->parent = current_menu;
@@ -531,7 +531,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 			location = menu;
 	}
 	if (head && location) {
-		jump = malloc(sizeof(struct jump_key));
+		jump = xmalloc(sizeof(struct jump_key));
 
 		if (menu_is_visible(prop->menu)) {
 			/*
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 22a3c40..ecc5aa5 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -656,11 +656,11 @@ bool sym_set_string_value(struct symbol *sym, const char *newval)
 	size = strlen(newval) + 1;
 	if (sym->type == S_HEX && (newval[0] != '0' || (newval[1] != 'x' && newval[1] != 'X'))) {
 		size += 2;
-		sym->def[S_DEF_USER].val = val = malloc(size);
+		sym->def[S_DEF_USER].val = val = xmalloc(size);
 		*val++ = '0';
 		*val++ = 'x';
 	} else if (!oldval || strcmp(oldval, newval))
-		sym->def[S_DEF_USER].val = val = malloc(size);
+		sym->def[S_DEF_USER].val = val = xmalloc(size);
 	else
 		return true;
 
@@ -812,7 +812,7 @@ struct symbol *sym_lookup(const char *name, int flags)
 		hash = 0;
 	}
 
-	symbol = malloc(sizeof(*symbol));
+	symbol = xmalloc(sizeof(*symbol));
 	memset(symbol, 0, sizeof(*symbol));
 	symbol->name = new_name;
 	symbol->type = S_UNKNOWN;
@@ -863,7 +863,7 @@ const char *sym_expand_string_value(const char *in)
 	size_t reslen;
 
 	reslen = strlen(in) + 1;
-	res = malloc(reslen);
+	res = xmalloc(reslen);
 	res[0] = '\0';
 
 	while ((src = strchr(in, '$'))) {
@@ -921,7 +921,7 @@ const char *sym_escape_string_value(const char *in)
 		p++;
 	}
 
-	res = malloc(reslen);
+	res = xmalloc(reslen);
 	res[0] = '\0';
 
 	strcat(res, "\"");
@@ -1228,7 +1228,7 @@ struct property *prop_alloc(enum prop_type type, struct symbol *sym)
 	struct property *prop;
 	struct property **propp;
 
-	prop = malloc(sizeof(*prop));
+	prop = xmalloc(sizeof(*prop));
 	memset(prop, 0, sizeof(*prop));
 	prop->type = type;
 	prop->sym = sym;
diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index d0b8b23..6e7fbf1 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -23,7 +23,7 @@ struct file *file_lookup(const char *name)
 		}
 	}
 
-	file = malloc(sizeof(*file));
+	file = xmalloc(sizeof(*file));
 	memset(file, 0, sizeof(*file));
 	file->name = file_name;
 	file->next = file_list;
@@ -81,7 +81,7 @@ int file_write_dep(const char *name)
 struct gstr str_new(void)
 {
 	struct gstr gs;
-	gs.s = malloc(sizeof(char) * 64);
+	gs.s = xmalloc(sizeof(char) * 64);
 	gs.len = 64;
 	gs.max_width = 0;
 	strcpy(gs.s, "\0");
@@ -138,3 +138,22 @@ const char *str_get(struct gstr *gs)
 	return gs->s;
 }
 
+void *xmalloc(size_t size)
+{
+	void *p = malloc(size);
+	if (p)
+		return p;
+	fprintf(stderr, "Out of memory.\n");
+	exit(1);
+}
+
+void *xcalloc(size_t nmemb, size_t size)
+{
+	void *p = calloc(nmemb, size);
+	if (p)
+		return p;
+	fprintf(stderr, "Out of memory.\n");
+	exit(1);
+}
+
+
diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
index 00f9d3a..6555a47 100644
--- a/scripts/kconfig/zconf.l
+++ b/scripts/kconfig/zconf.l
@@ -40,7 +40,7 @@ static void zconf_endfile(void);
 
 static void new_string(void)
 {
-	text = malloc(START_STRSIZE);
+	text = xmalloc(START_STRSIZE);
 	text_asize = START_STRSIZE;
 	text_size = 0;
 	*text = 0;
@@ -62,7 +62,7 @@ static void append_string(const char *str, int size)
 
 static void alloc_string(const char *str, int size)
 {
-	text = malloc(size + 1);
+	text = xmalloc(size + 1);
 	memcpy(text, str, size);
 	text[size] = 0;
 }
@@ -288,7 +288,7 @@ void zconf_initscan(const char *name)
 		exit(1);
 	}
 
-	current_buf = malloc(sizeof(*current_buf));
+	current_buf = xmalloc(sizeof(*current_buf));
 	memset(current_buf, 0, sizeof(*current_buf));
 
 	current_file = file_lookup(name);
@@ -299,7 +299,7 @@ void zconf_nextfile(const char *name)
 {
 	struct file *iter;
 	struct file *file = file_lookup(name);
-	struct buffer *buf = malloc(sizeof(*buf));
+	struct buffer *buf = xmalloc(sizeof(*buf));
 	memset(buf, 0, sizeof(*buf));
 
 	current_buf->state = YY_CURRENT_BUFFER;

