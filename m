Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1KVOMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:12:38 -0500
Received: from mail176c2.megamailservers.com ([69.49.111.76]:57470 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995Ab1KVOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:11:37 -0500
X-Authenticated-User: konrad.gaisler.com
From: Konrad Eisele <konrad@gaisler.com>
To: linux-kernel@vger.kernel.org
Cc: lacombar@gmail.com, mmarek@suse.cz, yann.morin.1998@anciens.enib.fr,
        linux-config@vger.kernel.org, konrad@gaisler.com
Subject: [PATCH 2/3] kconfig: Add support for Kconfig subtrees
Date: Tue, 22 Nov 2011 15:03:45 +0100
Message-Id: <1321970626-12615-3-git-send-email-konrad@gaisler.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
References: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
X-CSC: 0
X-CHA: v=1.1 cv=vjffymXyDtjo34N5cbiAavWp8ckkCSHNaVzdIDazEXU= c=1 sm=1
		a=Uj4JihZ132gA:10 a=U62ajLuCel8A:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=ebG-ZW-8AAAA:8 a=zPnIJ4bp6snpEZPgulgA:9 a=BN8wYQAwyjAy1MgDgAgA:7
		a=cCYF7-FHeg4A:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the options "prefix" or "configfile" are given to a "menu"
entry then the childs of that menu are given an independent namspace
with its own config data file.

Signed-off-by: Konrad Eisele <konrad@gaisler.com>
---
 Documentation/kbuild/kconfig-language.txt |   21 ++++++++++-
 scripts/kconfig/confdata.c                |   24 ++++++------
 scripts/kconfig/expr.h                    |    5 +++
 scripts/kconfig/lkc_proto.h               |    8 +++-
 scripts/kconfig/menu.c                    |   48 ++++++++++++++++++++++++-
 scripts/kconfig/symbol.c                  |   26 +++++++++++--
 scripts/kconfig/zconf.gperf               |    2 +
 scripts/kconfig/zconf.y                   |   56 +++++++++++++++++++++++-----
 8 files changed, 159 insertions(+), 31 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 44e2649..ae57d86 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -240,6 +240,23 @@ MODULES is different from 'n'. The comment on the other hand is always
 visible when MODULES is visible (the (empty) dependency of MODULES is
 also part of the comment dependencies).
 
+Subtree Menus 
+-------------
+
+It is possible to add other configuration trees as independent subtrees. To do so
+you have to specify the "prefix" or "configfile" options to a "menu" entry. This will
+create a independent namespace for the menu's childs, with its own config data file.
+
+menu "SPARC subtree"
+	prefix "CONFIG_"
+	configfile "CONFIG_"
+
+source "arch/sparc/Kconfig"	
+
+endmenu
+
+The "prefix" option specifies the prefix when writing/reading a config data file.
+The "configfile" option specifies the default config data file to use for the subtree.
 
 Kconfig syntax
 --------------
@@ -310,8 +327,8 @@ menu:
 	"endmenu"
 
 This defines a menu block, see "Menu structure" above for more
-information. The only possible options are dependencies and "visible"
-attributes.
+information. The possible options are dependencies, "visible"
+attributes and subtree definition.
 
 if:
 
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 25c29c8..3446dc4 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -253,7 +253,7 @@ load:
 		if (line[0] == '#') {
 			if (memcmp(line + 2, l->conf_prefix, strlen(l->conf_prefix)))
 				continue;
-			p = strchr(line + 2 + strlen(CONFIG_), ' ');
+			p = strchr(line + 2 + strlen(l->conf_prefix), ' ');
 			if (!p)
 				continue;
 			*p++ = 0;
@@ -283,7 +283,7 @@ load:
 				;
 			}
 		} else if (memcmp(line, l->conf_prefix, strlen(l->conf_prefix)) == 0) {
-			p = strchr(line + strlen(CONFIG_), '=');
+			p = strchr(line + strlen(l->conf_prefix), '=');
 			if (!p)
 				continue;
 			*p++ = 0;
@@ -455,7 +455,7 @@ kconfig_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 
 			if (!skip_unset)
 				fprintf(fp, "# %s%s is not set\n",
-				    CONFIG_, sym->name);
+				    sym->level->conf_prefix, sym->name);
 			return;
 		}
 		break;
@@ -463,7 +463,7 @@ kconfig_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 		break;
 	}
 
-	fprintf(fp, "%s%s=%s\n", CONFIG_, sym->name, value);
+	fprintf(fp, "%s%s=%s\n", sym->level->conf_prefix, sym->name, value);
 }
 
 static void
@@ -514,7 +514,7 @@ header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 			/* fall through */
 		default:
 			fprintf(fp, "#define %s%s%s 1\n",
-			    CONFIG_, sym->name, suffix);
+			    sym->level->conf_prefix, sym->name, suffix);
 		}
 		break;
 	}
@@ -524,13 +524,13 @@ header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 		if (value[0] != '0' || (value[1] != 'x' && value[1] != 'X'))
 			prefix = "0x";
 		fprintf(fp, "#define %s%s %s%s\n",
-		    CONFIG_, sym->name, prefix, value);
+		    sym->level->conf_prefix, sym->name, prefix, value);
 		break;
 	}
 	case S_STRING:
 	case S_INT:
 		fprintf(fp, "#define %s%s %s\n",
-		    CONFIG_, sym->name, value);
+		    sym->level->conf_prefix, sym->name, value);
 		break;
 	default:
 		break;
@@ -578,9 +578,9 @@ header_print__enabled_symbol(FILE *fp, struct symbol *sym, const char *value, vo
 	switch (sym->type) {
 	case S_BOOLEAN:
 	case S_TRISTATE: {
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
+		fprintf(fp, "#define __enabled_%s%s %d\n", sym->level->conf_prefix,
 		    sym->name, (*value == 'y'));
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
+		fprintf(fp, "#define __enabled_%s%s_MODULE %d\n", sym->level->conf_prefix,
 		    sym->name, (*value == 'm'));
 		break;
 	}
@@ -605,7 +605,7 @@ tristate_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg
 {
 
 	if (sym->type == S_TRISTATE && *value != 'n')
-		fprintf(fp, "%s%s=%c\n", CONFIG_, sym->name, (char)toupper(*value));
+		fprintf(fp, "%s%s=%c\n", sym->level->conf_prefix, sym->name, (char)toupper(*value));
 }
 
 static struct conf_printer tristate_printer_cb =
@@ -775,7 +775,7 @@ int conf_write(const char *name, struct conf_level *l)
 	if (!conf_get_changed())
 		sym_clear_all_valid(l);
 
-	menu = rootmenu.list;
+	menu = l->rootmenu->list;
 	while (menu) {
 		sym = menu->sym;
 		if (!sym) {
@@ -796,7 +796,7 @@ int conf_write(const char *name, struct conf_level *l)
 		}
 
 next:
-		if (menu->list) {
+		if (menu->list && menu->list->level == l) {
 			menu = menu->list;
 			continue;
 		}
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 12ac5bc..7d38fc0 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -172,10 +172,12 @@ struct menu {
 	struct file *file;
 	int lineno;
 	void *data;
+        struct conf_level *level;
 };
 
 #define MENU_CHANGED		0x0001
 #define MENU_ROOT		0x0002
+#define MENU_SUBTREE		0x0004
 
 struct conf_level {
         struct conf_level *n;
@@ -188,9 +190,12 @@ struct conf_level {
 	tristate modules_val;
 	struct symbol *sym_defconfig_list;
 	struct expr *sym_env_list;
+	struct menu *rootmenu;
 };
 extern struct conf_level rootlevel;
 
+extern char *default_prefix;
+
 extern struct file *file_list;
 extern struct file *current_file;
 struct file *lookup_file(const char *name);
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 749d78a..ffea171 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -26,6 +26,8 @@ P(menu_get_help,const char *,(struct menu *menu));
 P(get_symbol_str, void, (struct gstr *r, struct symbol *sym));
 P(get_relations_str, struct gstr, (struct symbol **sym_arr));
 P(menu_get_ext_help,void,(struct menu *menu, struct gstr *help));
+P(menu_prepare_level_prefix,void,(int ismainmenu, char *prefix));
+P(menu_prepare_level_conffile,void,(int ismainmenu, char *file));
 
 /* symbol.c */
 P(symbol_hash,struct symbol *,[SYMBOL_HASHSIZE]);
@@ -50,9 +52,11 @@ P(sym_get_default_prop,struct property *,(struct symbol *sym));
 P(sym_get_string_value,const char *,(struct symbol *sym));
 
 P(prop_get_type_name,const char *,(enum prop_type type));
-P(sym_level_open,void,(struct conf_level *l));
+P(sym_level_open,void,(struct conf_level *l, struct menu *m));
 P(sym_level_close,void,(struct conf_level *l));
-
+P(sym_open_namespace,struct conf_level *,(struct menu *m));
+P(sym_level_default,void,(struct conf_level *l));
+	
 /* expr.c */
 P(expr_compare_type,int,(enum expr_type t1, enum expr_type t2));
 P(expr_print,void,(struct expr *e, void (*fn)(void *, struct symbol *, const char *), void *data, int prevtoken));
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 9977819..880dc08 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -42,6 +42,8 @@ void _menu_init(void)
 {
 	current_entry = current_menu = &rootmenu;
 	last_entry_ptr = &rootmenu.list;
+	rootmenu.flags = MENU_SUBTREE;
+	rootmenu.level = current_conf_level;
 }
 
 void menu_add_entry(struct symbol *sym)
@@ -54,6 +56,7 @@ void menu_add_entry(struct symbol *sym)
 	menu->parent = current_menu;
 	menu->file = current_file;
 	menu->lineno = zconf_lineno();
+	menu->level = current_conf_level;
 
 	*last_entry_ptr = menu;
 	last_entry_ptr = &menu->next;
@@ -62,6 +65,40 @@ void menu_add_entry(struct symbol *sym)
 		menu_add_symbol(P_SYMBOL, sym, NULL);
 }
 
+struct conf_level *menu_prepare_level(int ismainmenu)
+{
+	if (!ismainmenu
+	    && (!(current_entry->flags & MENU_SUBTREE))
+	    &&  current_entry->level == current_conf_level) {
+		struct conf_level *l;
+		l = (struct conf_level*) malloc(sizeof(struct conf_level));
+		sym_level_default(l);
+		current_entry->level = l;
+		current_entry->flags |= MENU_SUBTREE;
+	}
+	return current_entry->level;
+}
+
+void menu_prepare_level_prefix(int ismainmenu, char *prefix)
+{
+	struct conf_level *l;
+	l = menu_prepare_level(ismainmenu);
+	/* override mainmenu options if this is a subtree and prefix has already been given */
+	if (!(ismainmenu && l->conf_prefix == default_prefix)) {
+		l->conf_prefix = prefix;
+	}
+}
+
+void menu_prepare_level_conffile(int ismainmenu, char *file)
+{
+	struct conf_level *l;
+	l = menu_prepare_level(ismainmenu);
+	/* override mainmenu options if this is a subtree and configfile has already been given */
+	if (!(ismainmenu && !l->conf)) {
+		l->conf = file;
+	}
+}
+
 void menu_end_entry(void)
 {
 }
@@ -70,11 +107,17 @@ struct menu *menu_add_menu(void)
 {
 	menu_end_entry();
 	last_entry_ptr = &current_entry->list;
+	if (current_entry->flags & MENU_SUBTREE) {
+		sym_open_namespace(current_entry);
+	}
 	return current_menu = current_entry;
 }
 
 void menu_end_menu(void)
 {
+	if (current_menu->flags & MENU_SUBTREE) {
+		sym_level_close(current_conf_level);
+	}
 	last_entry_ptr = &current_menu->next;
 	current_menu = current_menu->parent;
 }
@@ -290,7 +333,10 @@ void menu_finalize(struct menu *parent)
 			parentdep = parent->prompt->visible.expr;
 		else
 			parentdep = parent->dep;
-
+		/* break dependency chain for subtrees */
+		if (parent->flags & MENU_SUBTREE)
+			parentdep = NULL;
+		
 		for (menu = parent->list; menu; menu = menu->next) {
 			basedep = expr_transform(menu->dep);
 			basedep = expr_alloc_and(expr_copy(parentdep), basedep);
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 6999c8d..f9ee6a1 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -31,6 +31,7 @@ struct symbol symbol_yes = {
 
 tristate modules_val;
 struct conf_level rootlevel;
+char *default_prefix = CONFIG_;
 
 static void sym_add_default(struct symbol *sym, const char *def)
 {
@@ -1306,10 +1307,15 @@ static void prop_add_env(const char *env)
 		menu_warn(current_entry, "environment variable %s undefined", env);
 }
 
-void sym_level_open(struct conf_level *l)
+void  sym_level_default(struct conf_level *l)
 {
-	struct conf_level **lp;
 	memset(l, 0, sizeof(*l));
+	l->conf_prefix = default_prefix;
+}
+
+void  sym_level_open(struct conf_level *l, struct menu *m)
+{
+	struct conf_level **lp;
 
 	for (lp = &conf_levels; *lp; lp = &(*lp)->n) ;
 	*lp = l;
@@ -1319,8 +1325,8 @@ void sym_level_open(struct conf_level *l)
 	l->modules_sym = sym_lookup(NULL, 0, current_conf_level);
 	l->modules_sym->type = S_BOOLEAN;
 	l->modules_sym->flags |= SYMBOL_AUTO;
-	l->conf_prefix = CONFIG_;
-
+	l->rootmenu = m;
+		
 	sym_init(current_conf_level);
 }
 
@@ -1333,3 +1339,15 @@ void sym_level_close(struct conf_level *l)
 	}
 	current_conf_level = l->parent;
 }
+
+struct conf_level *sym_open_namespace(struct menu *m)
+{
+	struct conf_level *l = m->level;
+	if (current_conf_level == l) {
+		l = (struct conf_level*) malloc(sizeof(struct conf_level));
+		sym_level_default(l);
+	}
+	sym_level_open(l, m);
+	return l;
+}
+
diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
index f14ab41..714fad4 100644
--- a/scripts/kconfig/zconf.gperf
+++ b/scripts/kconfig/zconf.gperf
@@ -39,6 +39,8 @@ string,		T_TYPE,		TF_COMMAND, S_STRING
 select,		T_SELECT,	TF_COMMAND
 range,		T_RANGE,	TF_COMMAND
 visible,	T_VISIBLE,	TF_COMMAND
+prefix,		T_PREFIX,	TF_COMMAND
+configfile,	T_CONFIGFILE,	TF_COMMAND
 option,		T_OPTION,	TF_COMMAND
 on,		T_ON,		TF_PARAM
 modules,	T_OPT_MODULES,	TF_OPTION
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index c6e923f..edb6ba7 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -29,6 +29,7 @@ static bool zconf_endtoken(const struct kconf_id *id, int starttoken, int endtok
 static struct menu *current_menu, *current_entry;
 struct conf_level *current_conf_level = 0;
 struct conf_level *conf_levels = 0;
+int ismainmenu = 0;
 
 %}
 %expect 30
@@ -64,6 +65,8 @@ struct conf_level *conf_levels = 0;
 %token <id>T_SELECT
 %token <id>T_RANGE
 %token <id>T_VISIBLE
+%token <id>T_PREFIX
+%token <id>T_CONFIGFILE
 %token <id>T_OPTION
 %token <id>T_ON
 %token <string> T_WORD
@@ -102,13 +105,14 @@ struct conf_level *conf_levels = 0;
 %%
 input: nl start | start;
 
-start: mainmenu_stmt stmt_list | stmt_list;
+start: stmt_list;
 
 stmt_list:
 	  /* empty */
 	| stmt_list common_stmt
 	| stmt_list choice_stmt
 	| stmt_list menu_stmt
+	| stmt_list mainmenu_stmt
 	| stmt_list end			{ zconf_error("unexpected end statement"); }
 	| stmt_list T_WORD error T_EOL	{ zconf_error("unknown statement \"%s\"", $2); }
 	| stmt_list option_name error T_EOL
@@ -341,11 +345,22 @@ if_block:
 
 /* mainmenu entry */
 
-mainmenu_stmt: T_MAINMENU prompt nl
+mainmenu: T_MAINMENU prompt nl 
 {
 	menu_add_prompt(P_MENU, $2, NULL);
 };
 
+mainmenu_stmt: mainmenu { ismainmenu = 1; } mainmenu_options { ismainmenu = 0; }
+{
+};
+
+mainmenu_options:
+	  /* empty */
+	| mainmenu_options subtree_options
+	| mainmenu_options T_EOL
+;
+
+
 /* menu entry */
 
 menu: T_MENU prompt T_EOL
@@ -355,7 +370,7 @@ menu: T_MENU prompt T_EOL
 	printd(DEBUG_PARSE, "%s:%d:menu\n", zconf_curname(), zconf_lineno());
 };
 
-menu_entry: menu visibility_list depends_list
+menu_entry: menu menu_options
 {
 	$$ = menu_add_menu();
 };
@@ -368,6 +383,15 @@ menu_end: end
 	}
 };
 
+menu_options:
+	  /* empty */
+	| menu_options visible
+	| menu_options depends
+	| menu_options T_EOL
+	| menu_options subtree_options
+	| menu_options option_error
+;
+
 menu_stmt: menu_entry menu_block menu_end
 ;
 
@@ -428,17 +452,26 @@ depends: T_DEPENDS T_ON expr T_EOL
 
 /* visibility option */
 
-visibility_list:
-	  /* empty */
-	| visibility_list visible
-	| visibility_list T_EOL
-;
-
 visible: T_VISIBLE if_expr
 {
 	menu_add_visibility($2);
 };
 
+/* subtree menu options */
+
+subtree_options:
+	  subtree_prefix
+	| subtree_configfile
+;
+
+subtree_prefix:
+	T_PREFIX prompt         { menu_prepare_level_prefix(ismainmenu, $2); }
+;
+
+subtree_configfile:
+	T_CONFIGFILE prompt     { menu_prepare_level_conffile(ismainmenu, $2); }
+;
+
 /* prompt statement */
 
 prompt_stmt_opt:
@@ -490,7 +523,8 @@ void conf_parse(const char *name)
 	struct conf_level *l;
 	int i;
 
-	sym_level_open(&rootlevel);
+	sym_level_default(&rootlevel);
+	sym_level_open(&rootlevel, &rootmenu);
 
 	zconf_initscan(name);
 
@@ -535,6 +569,8 @@ static const char *zconf_tokenname(int token)
 	case T_ENDIF:		return "endif";
 	case T_DEPENDS:		return "depends";
 	case T_VISIBLE:		return "visible";
+	case T_PREFIX:		return "prefix";
+	case T_CONFIGFILE:	return "configfile";
 	}
 	return "<token>";
 }
-- 
1.6.4.1

