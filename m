Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab1KRQNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:13:49 -0500
Received: from mail175c2.megamailservers.com ([69.49.111.75]:56297 "EHLO
	mail175c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab1KRQNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:13:47 -0500
X-Greylist: delayed 6499 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 11:13:46 EST
X-Authenticated-User: konrad.gaisler.com
From: Konrad Eisele <konrad@gaisler.com>
To: linux-kernel@vger.kernel.org
Cc: linux-config@vger.kernel.org, konrad@gaisler.com, mmarek@suse.cz,
        pefoley2@verizon.net, yann.morin.1998@anciens.enib.fr,
        sam@ravnborg.org, zippel@linux-m68k.org
Subject: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
Date: Fri, 18 Nov 2011 15:16:14 +0100
Message-Id: <1321625774-12749-1-git-send-email-konrad@gaisler.com>
X-Mailer: git-send-email 1.6.4.1
X-CSC: 100
X-CHA: v=1.1 cv=Dt2dKqGHsKqylFsReVPyCOhFPYlE1w6lK6qBgE09yz8= c=1 sm=1
		p=QICIXhSNTeUA:10 a=LQOQUlTpXzAA:10 a=U62ajLuCel8A:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=ebG-ZW-8AAAA:8 a=mDV3o1hIAAAA:8
		a=pQxnBk43bs12mEK5M-8A:9 a=rQ1woBu4o4J0rwN231wA:7 a=xQdB8fRqRzQA:10
		a=cCYF7-FHeg4A:10 a=NWVoK91CQyQA:10 a=KHjwd_CBDJaY5x8T:21
		a=riMGzhGH7u5MNOGx:21 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New kconfig command "subsource":
subsource "<kconfig>" "<cwd>" "<.config>" "<title>"  <internal_prefix> <.config_prefix>
Allocates <kconfig> as a configuration subtree using <.config> as the configuration
file to save and load from. <cwd> is the directory path to switch to for "source" to
work, "<title>" is the Menu tile of the subtree, <internal_prefix> is a internal prefix,
and <.config_prefix> is the prefix to append/remove when saving/loading <.config>.

Signed-off-by: Konrad Eisele <konrad@gaisler.com>
---
 scripts/kconfig/conf.c               |    6 +-
 scripts/kconfig/confdata.c           |   83 ++-
 scripts/kconfig/expr.h               |   16 +
 scripts/kconfig/gconf.c              |    3 +
 scripts/kconfig/lkc.h                |    1 +
 scripts/kconfig/lkc_proto.h          |   12 +-
 scripts/kconfig/mconf.c              |   13 +-
 scripts/kconfig/menu.c               |   18 +-
 scripts/kconfig/nconf.c              |   13 +-
 scripts/kconfig/qconf.cc             |    3 +
 scripts/kconfig/symbol.c             |   50 ++-
 scripts/kconfig/util.c               |   49 ++
 scripts/kconfig/zconf.gperf          |    1 +
 scripts/kconfig/zconf.hash.c_shipped |  252 +++++-----
 scripts/kconfig/zconf.l              |   50 ++-
 scripts/kconfig/zconf.lex.c_shipped  |   52 ++-
 scripts/kconfig/zconf.tab.c_shipped  |  985 ++++++++++++++++++----------------
 scripts/kconfig/zconf.y              |   23 +-
 18 files changed, 991 insertions(+), 639 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index f208f90..8d6cbb4 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -575,7 +575,7 @@ int main(int ac, char **av)
 	case randconfig:
 		name = getenv("KCONFIG_ALLCONFIG");
 		if (name && !stat(name, &tmpstat)) {
-			conf_read_simple(name, S_DEF_USER);
+			conf_read_simple_level(name, S_DEF_USER, 0);
 			break;
 		}
 		switch (input_mode) {
@@ -587,9 +587,9 @@ int main(int ac, char **av)
 		default: break;
 		}
 		if (!stat(name, &tmpstat))
-			conf_read_simple(name, S_DEF_USER);
+			conf_read_simple_level(name, S_DEF_USER, 0);
 		else if (!stat("all.config", &tmpstat))
-			conf_read_simple("all.config", S_DEF_USER);
+			conf_read_simple_level("all.config", S_DEF_USER, 0);
 		break;
 	default:
 		break;
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 5a58965..688b6b6 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -182,13 +182,13 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 	return 0;
 }
 
-int conf_read_simple(const char *name, int def)
+int conf_read_simple_level(const char *name, int def, struct conf_level *l)
 {
 	FILE *in = NULL;
 	char line[1024];
-	char *p, *p2;
+	char *p, *p2, *lp;
 	struct symbol *sym;
-	int i, def_flags;
+	int i, def_flags, prel;
 
 	if (name) {
 		in = zconf_fopen(name);
@@ -200,13 +200,13 @@ int conf_read_simple(const char *name, int def)
 		if (in)
 			goto load;
 		sym_add_change_count(1);
-		if (!sym_defconfig_list) {
+		if (!(l ? l->sym_defconfig_list : sym_defconfig_list)) {
 			if (modules_sym)
 				sym_calc_value(modules_sym);
 			return 1;
 		}
 
-		for_all_defaults(sym_defconfig_list, prop) {
+		for_all_defaults((l ? l->sym_defconfig_list : sym_defconfig_list), prop) {
 			if (expr_calc_value(prop->visible.expr) == no ||
 			    prop->expr->type != E_SYMBOL)
 				continue;
@@ -229,7 +229,7 @@ load:
 	conf_unsaved = 0;
 
 	def_flags = SYMBOL_DEF << def;
-	for_all_symbols(i, sym) {
+	for_all_symbols_level(i, sym, l) {
 		sym->flags |= SYMBOL_CHANGED;
 		sym->flags &= ~(def_flags|SYMBOL_VALID);
 		if (sym_is_choice(sym))
@@ -251,7 +251,7 @@ load:
 		conf_lineno++;
 		sym = NULL;
 		if (line[0] == '#') {
-			if (memcmp(line + 2, CONFIG_, strlen(CONFIG_)))
+			if (memcmp(line + 2, l ? l->conf_prefix : CONFIG_, prel = strlen(l ? l->conf_prefix : CONFIG_)))
 				continue;
 			p = strchr(line + 2 + strlen(CONFIG_), ' ');
 			if (!p)
@@ -259,14 +259,15 @@ load:
 			*p++ = 0;
 			if (strncmp(p, "is not set", 10))
 				continue;
-			if (def == S_DEF_USER) {
-				sym = sym_find(line + 2 + strlen(CONFIG_));
+			lp = line + 2 + prel;
+ 			if (def == S_DEF_USER) {
+				sym = sym_find_level(lp, l);
 				if (!sym) {
 					sym_add_change_count(1);
 					goto setsym;
 				}
 			} else {
-				sym = sym_lookup(line + 2 + strlen(CONFIG_), 0);
+				sym = sym_lookup_level(lp, 0, l);
 				if (sym->type == S_UNKNOWN)
 					sym->type = S_BOOLEAN;
 			}
@@ -282,7 +283,7 @@ load:
 			default:
 				;
 			}
-		} else if (memcmp(line, CONFIG_, strlen(CONFIG_)) == 0) {
+		} else if (memcmp(line, l ? l->conf_prefix : CONFIG_, prel = strlen(l ? l->conf_prefix : CONFIG_)) == 0) {
 			p = strchr(line + strlen(CONFIG_), '=');
 			if (!p)
 				continue;
@@ -293,14 +294,15 @@ load:
 				if (*p2 == '\r')
 					*p2 = 0;
 			}
+			lp = line + prel;
 			if (def == S_DEF_USER) {
-				sym = sym_find(line + strlen(CONFIG_));
+				sym = sym_find_level(lp, l);
 				if (!sym) {
 					sym_add_change_count(1);
 					goto setsym;
 				}
 			} else {
-				sym = sym_lookup(line + strlen(CONFIG_), 0);
+				sym = sym_lookup_level(lp, 0, l);
 				if (sym->type == S_UNKNOWN)
 					sym->type = S_OTHER;
 			}
@@ -342,7 +344,7 @@ setsym:
 	return 0;
 }
 
-int conf_read(const char *name)
+int conf_read_level(const char *name, struct conf_level *l)
 {
 	struct symbol *sym, *choice_sym;
 	struct property *prop;
@@ -351,10 +353,10 @@ int conf_read(const char *name)
 
 	sym_set_change_count(0);
 
-	if (conf_read_simple(name, S_DEF_USER))
+	if (conf_read_simple_level(name, S_DEF_USER, l))
 		return 1;
 
-	for_all_symbols(i, sym) {
+	for_all_symbols_level(i, sym, l) {
 		sym_calc_value(sym);
 		if (sym_is_choice(sym) || (sym->flags & SYMBOL_AUTO))
 			goto sym_ok;
@@ -392,7 +394,7 @@ int conf_read(const char *name)
 		sym->flags &= flags | ~SYMBOL_DEF_USER;
 	}
 
-	for_all_symbols(i, sym) {
+	for_all_symbols_level(i, sym, l) {
 		if (sym_has_value(sym) && !sym_is_choice_value(sym)) {
 			/* Reset values of generates values, so they'll appear
 			 * as new, if they should become visible, but that
@@ -422,6 +424,23 @@ int conf_read(const char *name)
 	return 0;
 }
 
+int conf_read(const char *name) {
+	int r = conf_read_level(name, 0);
+	if (!r && !name) {
+		struct conf_level *l = conf_levels;
+		while (l) {
+			char *n = resolve_vars(l->conf, l->parent);
+			if (n) {
+				if ((r = conf_read_level(n, l)))
+					break;
+				free(n);
+			}
+			l = l->n;
+		}
+	} 
+	return r;
+}
+
 /*
  * Kconfig configuration printer
  *
@@ -590,9 +609,9 @@ static struct conf_printer header__enabled_printer_cb =
 static void
 tristate_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 {
-
+	char *pre = (sym->level && sym->level->conf_prefix) ? sym->level->conf_prefix : CONFIG_;
 	if (sym->type == S_TRISTATE && *value != 'n')
-		fprintf(fp, "%s%s=%c\n", CONFIG_, sym->name, (char)toupper(*value));
+		fprintf(fp, "%s%s=%c\n", pre, sym->name, (char)toupper(*value));
 }
 
 static struct conf_printer tristate_printer_cb =
@@ -713,7 +732,7 @@ next_menu:
 	return 0;
 }
 
-int conf_write(const char *name)
+int conf_write_level(const char *name, struct conf_level *l)
 {
 	FILE *out;
 	struct symbol *sym;
@@ -766,7 +785,7 @@ int conf_write(const char *name)
 	while (menu) {
 		sym = menu->sym;
 		if (!sym) {
-			if (!menu_is_visible(menu))
+			if (!menu_is_visible(menu) || menu->level != l)
 				goto next;
 			str = menu_get_prompt(menu);
 			fprintf(out, "\n"
@@ -778,8 +797,8 @@ int conf_write(const char *name)
 			if (!(sym->flags & SYMBOL_WRITE))
 				goto next;
 			sym->flags &= ~SYMBOL_WRITE;
-
-			conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
+			if (sym->level == l)
+				conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
 		}
 
 next:
@@ -813,6 +832,22 @@ next:
 	return 0;
 }
 
+int conf_write(const char *name) {
+	int r = conf_write_level(name, 0);
+	if (!r && !name) {
+		struct conf_level *l = conf_levels;
+		while (l) {
+			char *n = resolve_vars(l->conf, l->parent);
+			if ((r = conf_write_level(n, l)))
+				break;
+			l = l->n;
+			if (n)
+				free(n);
+		}
+	} 
+	return r;
+}
+
 static int conf_split_config(void)
 {
 	const char *name;
@@ -823,7 +858,7 @@ static int conf_split_config(void)
 	int res, i, fd;
 
 	name = conf_get_autoconfig_name();
-	conf_read_simple(name, S_DEF_AUTO);
+	conf_read_simple_level(name, S_DEF_AUTO, 0);
 
 	if (chdir("include/config"))
 		return 1;
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 80fce57..493d703 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -15,6 +15,19 @@ extern "C" {
 #include <stdbool.h>
 #endif
 
+struct conf_level {
+        struct conf_level *n, *parent;
+        char *sym_prefix;
+	char *conf;
+	char *conf_prefix;
+	char *cwd;
+	struct symbol *modules_sym;
+	struct symbol *sym_defconfig_list;
+};
+extern struct conf_level *conf_levels;
+extern struct conf_level *current_conf_level;
+extern int dosubsource;
+
 struct file {
 	struct file *next;
 	struct file *parent;
@@ -73,6 +86,7 @@ enum {
 struct symbol {
 	struct symbol *next;
 	char *name;
+	struct conf_level *level;
 	enum symbol_type type;
 	struct symbol_value curr;
 	struct symbol_value def[S_DEF_COUNT];
@@ -84,6 +98,7 @@ struct symbol {
 };
 
 #define for_all_symbols(i, sym) for (i = 0; i < SYMBOL_HASHSIZE; i++) for (sym = symbol_hash[i]; sym; sym = sym->next) if (sym->type != S_OTHER)
+#define for_all_symbols_level(i, sym, l) for (i = 0; i < SYMBOL_HASHSIZE; i++) for (sym = symbol_hash[i]; sym; sym = sym->next) if (sym->level == l && sym->type != S_OTHER)
 
 #define SYMBOL_CONST      0x0001  /* symbol is const */
 #define SYMBOL_CHECK      0x0008  /* used during dependency checking */
@@ -167,6 +182,7 @@ struct menu {
 	struct file *file;
 	int lineno;
 	void *data;
+	struct conf_level *level;
 };
 
 #define MENU_CHANGED		0x0001
diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 9f44380..33d7815 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1498,6 +1498,9 @@ int main(int ac, char *av[])
 	/* Conf stuffs */
 	if (ac > 1 && av[1][0] == '-') {
 		switch (av[1][1]) {
+		case 's':
+			dosubsource = 1;
+			break;
 		case 'a':
 			//showAll = 1;
 			break;
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index b633bdb..3873fb8 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -71,6 +71,7 @@ void zconf_starthelp(void);
 FILE *zconf_fopen(const char *name);
 void zconf_initscan(const char *name);
 void zconf_nextfile(const char *name);
+void zconf_nextconf(const char *name, char *subdir, char *subconf, char *title, char *subprefix, char *confprefix);	
 int zconf_lineno(void);
 const char *zconf_curname(void);
 
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 47fe9c3..f84032c 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -10,6 +10,10 @@ P(conf_write_autoconf,int,(void));
 P(conf_get_changed,bool,(void));
 P(conf_set_changed_callback, void,(void (*fn)(void)));
 P(conf_set_message_callback, void,(void (*fn)(const char *fmt, va_list ap)));
+P(conf_read_simple_level,int,(const char *name, int def, struct conf_level *l));
+P(conf_read_level,int,(const char *name, struct conf_level *l));
+P(conf_write_level,int,(const char *name, struct conf_level *l));
+
 
 /* menu.c */
 P(rootmenu,struct menu,);
@@ -29,7 +33,9 @@ P(menu_get_ext_help,void,(struct menu *menu, struct gstr *help));
 P(symbol_hash,struct symbol *,[SYMBOL_HASHSIZE]);
 
 P(sym_lookup,struct symbol *,(const char *name, int flags));
+P(sym_lookup_level,struct symbol *,(const char *name, int flags,struct conf_level *l));
 P(sym_find,struct symbol *,(const char *name));
+P(sym_find_level,struct symbol *,(const char *name,struct conf_level *l));
 P(sym_expand_string_value,const char *,(const char *in));
 P(sym_escape_string_value, const char *,(const char *in));
 P(sym_re_search,struct symbol **,(const char *pattern));
@@ -48,7 +54,11 @@ P(sym_get_default_prop,struct property *,(struct symbol *sym));
 P(sym_get_string_value,const char *,(struct symbol *sym));
 
 P(prop_get_type_name,const char *,(enum prop_type type));
-
+P(modules_sym_level,struct symbol *,(struct symbol *sym));
+	
 /* expr.c */
 P(expr_compare_type,int,(enum expr_type t1, enum expr_type t2));
 P(expr_print,void,(struct expr *e, void (*fn)(void *, struct symbol *, const char *), void *data, int prevtoken));
+
+/* util.c */
+P(resolve_vars,char*,(const char *n, struct conf_level *l));
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 19e200d..a85554d 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -844,6 +844,7 @@ int main(int ac, char **av)
 {
 	char *mode;
 	int res;
+ 	const char *name;
 
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
@@ -851,7 +852,17 @@ int main(int ac, char **av)
 
 	signal(SIGINT, sig_handler);
 
-	conf_parse(av[1]);
+ 	if (ac > 1 && av[1][0] == '-') {
+ 		switch (av[1][1]) {
+ 		case 's':
+ 			dosubsource = 1;
+ 			break;
+ 		}
+ 		name = av[2];
+ 	} else
+ 		name = av[1];
+ 
+	conf_parse(name);
 	conf_read(NULL);
 
 	mode = getenv("MENUCONFIG_MODE");
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 8c2a97e..0162d82 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -54,7 +54,8 @@ void menu_add_entry(struct symbol *sym)
 	menu->parent = current_menu;
 	menu->file = current_file;
 	menu->lineno = zconf_lineno();
-
+	menu->level = current_conf_level;
+	
 	*last_entry_ptr = menu;
 	last_entry_ptr = &menu->next;
 	current_entry = menu;
@@ -192,10 +193,17 @@ void menu_add_option(int token, char *arg)
 		prop->expr = expr_alloc_symbol(current_entry->sym);
 		break;
 	case T_OPT_DEFCONFIG_LIST:
-		if (!sym_defconfig_list)
-			sym_defconfig_list = current_entry->sym;
-		else if (sym_defconfig_list != current_entry->sym)
-			zconf_error("trying to redefine defconfig symbol");
+		if (!current_conf_level) {
+			if (!sym_defconfig_list)
+				sym_defconfig_list = current_entry->sym;
+			else if (sym_defconfig_list != current_entry->sym)
+				zconf_error("trying to redefine defconfig symbol");
+		} else {
+			if (!current_conf_level->sym_defconfig_list)
+				current_conf_level->sym_defconfig_list = current_entry->sym;
+			else if (current_conf_level->sym_defconfig_list != current_entry->sym)
+				zconf_error("trying to redefine defconfig symbol");
+		}
 		break;
 	case T_OPT_ENV:
 		prop_add_env(arg);
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 73070cb..37feea4 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1471,12 +1471,23 @@ void setup_windows(void)
 int main(int ac, char **av)
 {
 	char *mode;
+	const char *name;
 
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	conf_parse(av[1]);
+	if (ac > 1 && av[1][0] == '-') {
+		switch (av[1][1]) {
+		case 's':
+			dosubsource = 1;
+			break;
+		}
+		name = av[2];
+	} else
+		name = av[1];
+
+	conf_parse(name);
 	conf_read(NULL);
 
 	mode = getenv("NCONFIG_MODE");
diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index df274fe..b180571 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1756,6 +1756,9 @@ int main(int ac, char** av)
 	configApp = new QApplication(ac, av);
 	if (ac > 1 && av[1][0] == '-') {
 		switch (av[1][1]) {
+		case 's':
+			dosubsource = 1;
+			break;
 		case 'h':
 		case '?':
 			usage();
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 071f00c..724e7e8 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -32,6 +32,13 @@ struct symbol symbol_yes = {
 struct symbol *sym_defconfig_list;
 struct symbol *modules_sym;
 tristate modules_val;
+struct symbol *modules_sym_level(struct symbol *sym) {
+	if (sym->level) {
+		return sym->level->modules_sym;
+	} else {
+		return modules_sym;
+	}
+}
 
 struct expr *sym_env_list;
 
@@ -397,9 +404,9 @@ void sym_calc_value(struct symbol *sym)
 
 	if (memcmp(&oldval, &sym->curr, sizeof(oldval))) {
 		sym_set_changed(sym);
-		if (modules_sym == sym) {
+		if (modules_sym_level(sym) == sym) {
 			sym_set_all_changed();
-			modules_val = modules_sym->curr.tri;
+			modules_val = modules_sym_level(sym)->curr.tri;
 		}
 	}
 
@@ -423,6 +430,7 @@ void sym_calc_value(struct symbol *sym)
 void sym_clear_all_valid(void)
 {
 	struct symbol *sym;
+	struct conf_level *l;
 	int i;
 
 	for_all_symbols(i, sym)
@@ -430,6 +438,12 @@ void sym_clear_all_valid(void)
 	sym_add_change_count(1);
 	if (modules_sym)
 		sym_calc_value(modules_sym);
+	l = conf_levels;
+	while (l) {
+		if (l->modules_sym)
+			sym_calc_value(l->modules_sym);
+		l = l->n;
+	}
 }
 
 void sym_set_changed(struct symbol *sym)
@@ -679,7 +693,7 @@ const char *sym_get_string_default(struct symbol *sym)
 	tristate val;
 
 	sym_calc_visibility(sym);
-	sym_calc_value(modules_sym);
+	sym_calc_value(modules_sym_level(sym));
 	val = symbol_no.curr.tri;
 	str = symbol_empty.curr.val;
 
@@ -711,7 +725,7 @@ const char *sym_get_string_default(struct symbol *sym)
 
 	/* transpose mod to yes if modules are not enabled */
 	if (val == mod)
-		if (!sym_is_choice_value(sym) && modules_sym->curr.tri == no)
+		if (!sym_is_choice_value(sym) && modules_sym_level(sym)->curr.tri == no)
 			val = yes;
 
 	/* transpose mod to yes if type is bool */
@@ -793,7 +807,7 @@ struct symbol *sym_lookup(const char *name, int flags)
 		hash = strhash(name) % SYMBOL_HASHSIZE;
 
 		for (symbol = symbol_hash[hash]; symbol; symbol = symbol->next) {
-			if (symbol->name &&
+			if (symbol->name && symbol->level == current_conf_level &&
 			    !strcmp(symbol->name, name) &&
 			    (flags ? symbol->flags & flags
 				   : !(symbol->flags & (SYMBOL_CONST|SYMBOL_CHOICE))))
@@ -810,13 +824,24 @@ struct symbol *sym_lookup(const char *name, int flags)
 	symbol->name = new_name;
 	symbol->type = S_UNKNOWN;
 	symbol->flags |= flags;
-
+	symbol->level = current_conf_level;
 	symbol->next = symbol_hash[hash];
 	symbol_hash[hash] = symbol;
 
 	return symbol;
 }
 
+struct symbol *sym_lookup_level(const char *name, int flags, struct conf_level *l)
+{
+	struct conf_level *ol = current_conf_level;
+	struct symbol *sym;
+
+	current_conf_level = l;
+	sym = sym_lookup(name, flags);
+	current_conf_level = ol;
+	return sym;
+}
+
 struct symbol *sym_find(const char *name)
 {
 	struct symbol *symbol = NULL;
@@ -836,6 +861,7 @@ struct symbol *sym_find(const char *name)
 
 	for (symbol = symbol_hash[hash]; symbol; symbol = symbol->next) {
 		if (symbol->name &&
+		    symbol->level == current_conf_level &&
 		    !strcmp(symbol->name, name) &&
 		    !(symbol->flags & SYMBOL_CONST))
 				break;
@@ -936,6 +962,18 @@ const char *sym_escape_string_value(const char *in)
 	return res;
 }
 
+struct symbol *sym_find_level(const char *name, struct conf_level *l)
+{
+	struct conf_level *ol = current_conf_level;
+	struct symbol *sym;
+
+	current_conf_level = l;
+	sym = sym_find(name);
+	current_conf_level = ol;
+	return sym;
+}
+
+
 struct symbol **sym_re_search(const char *pattern)
 {
 	struct symbol *sym, **sym_arr = NULL;
diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index d0b8b23..82b3556 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -138,3 +138,52 @@ const char *str_get(struct gstr *gs)
 	return gs->s;
 }
 
+#define APPEND_STR(r,a,l) do {				\
+		if (l) {				\
+			int rl=r?strlen(r):0;		\
+			r = realloc(r,rl+l+1);		\
+			memcpy(r+rl,a,l);		\
+			r[rl+l] = 0;			\
+		}					\
+	} while(0)
+
+char *resolve_vars(const char *n, struct conf_level *l) {
+	char *r = 0;
+	char *var = 0;
+	const char *val = 0;
+	int i, j, nl = strlen(n);
+	struct symbol *sym;
+	struct conf_level *o = current_conf_level;
+	current_conf_level = l;
+	
+	for (i = 0, j = 0; i < nl; i++) {
+		if (n[i] == '$' && n[i+1] == '(') {
+			APPEND_STR(r,&n[j],i-j);
+			for (i+=2, j = i; i < nl; i++) {
+				if (n[i] == ')') {
+					break;
+				}
+			}
+			if (i < nl && i > j) {
+				var = malloc(i-j+1);
+				memcpy(var, &n[j], i-j);
+				var[i-j] = 0;
+				if ((sym = sym_lookup(var, 0))) {
+					if (sym_get_type(sym) == S_STRING) {
+						sym_calc_value(sym);
+						val  = sym_get_string_value(sym);
+						if (val) {
+							APPEND_STR(r,val,strlen(val));
+						}
+						
+					}
+				}
+				free(var);
+				j=i+1;
+			}
+		}
+	}
+	APPEND_STR(r,&n[j],i-j);
+	current_conf_level = o;
+	return r;
+}
diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
index f14ab41..139e7f3 100644
--- a/scripts/kconfig/zconf.gperf
+++ b/scripts/kconfig/zconf.gperf
@@ -16,6 +16,7 @@ mainmenu,	T_MAINMENU,	TF_COMMAND
 menu,		T_MENU,		TF_COMMAND
 endmenu,	T_ENDMENU,	TF_COMMAND
 source,		T_SOURCE,	TF_COMMAND
+subsource,	T_SUBSOURCE,	TF_COMMAND
 choice,		T_CHOICE,	TF_COMMAND
 endchoice,	T_ENDCHOICE,	TF_COMMAND
 comment,	T_COMMENT,	TF_COMMAND
diff --git a/scripts/kconfig/zconf.hash.c_shipped b/scripts/kconfig/zconf.hash.c_shipped
index 40df000..69d8976 100644
--- a/scripts/kconfig/zconf.hash.c_shipped
+++ b/scripts/kconfig/zconf.hash.c_shipped
@@ -1,4 +1,4 @@
-/* ANSI-C code produced by gperf version 3.0.4 */
+/* ANSI-C code produced by gperf version 3.0.3 */
 /* Command-line: gperf -t --output-file scripts/kconfig/zconf.hash.c_shipped -a -C -E -g -k '1,3,$' -p -t scripts/kconfig/zconf.gperf  */
 
 #if !((' ' == 32) && ('!' == 33) && ('"' == 34) && ('#' == 35) \
@@ -32,7 +32,7 @@
 struct kconf_id;
 
 static const struct kconf_id *kconf_id_lookup(register const char *str, register unsigned int len);
-/* maximum key range = 71, duplicates = 0 */
+/* maximum key range = 62, duplicates = 0 */
 
 #ifdef __GNUC__
 __inline
@@ -46,32 +46,32 @@ kconf_id_hash (register const char *str, register unsigned int len)
 {
   static const unsigned char asso_values[] =
     {
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 25, 25,
-       0,  0,  0,  5,  0,  0, 73, 73,  5,  0,
-      10,  5, 45, 73, 20, 20,  0, 15, 15, 73,
-      20, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 10, 20,
+       0,  0,  0,  0,  5,  0, 64, 64,  5, 15,
+      10,  5, 40, 64,  0,  0,  0, 20, 30, 64,
+      10, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
+      64, 64, 64, 64, 64, 64
     };
   register int hval = len;
 
@@ -93,75 +93,77 @@ struct kconf_id_strings_t
     char kconf_id_strings_str2[sizeof("if")];
     char kconf_id_strings_str3[sizeof("int")];
     char kconf_id_strings_str5[sizeof("endif")];
+    char kconf_id_strings_str6[sizeof("string")];
     char kconf_id_strings_str7[sizeof("default")];
     char kconf_id_strings_str8[sizeof("tristate")];
     char kconf_id_strings_str9[sizeof("endchoice")];
+    char kconf_id_strings_str11[sizeof("select")];
     char kconf_id_strings_str12[sizeof("def_tristate")];
     char kconf_id_strings_str13[sizeof("def_bool")];
     char kconf_id_strings_str14[sizeof("defconfig_list")];
+    char kconf_id_strings_str15[sizeof("range")];
     char kconf_id_strings_str17[sizeof("on")];
     char kconf_id_strings_str18[sizeof("optional")];
+    char kconf_id_strings_str19[sizeof("subsource")];
     char kconf_id_strings_str21[sizeof("option")];
-    char kconf_id_strings_str22[sizeof("endmenu")];
-    char kconf_id_strings_str23[sizeof("mainmenu")];
-    char kconf_id_strings_str25[sizeof("menuconfig")];
-    char kconf_id_strings_str27[sizeof("modules")];
-    char kconf_id_strings_str29[sizeof("menu")];
-    char kconf_id_strings_str31[sizeof("select")];
-    char kconf_id_strings_str32[sizeof("comment")];
-    char kconf_id_strings_str33[sizeof("env")];
-    char kconf_id_strings_str35[sizeof("range")];
-    char kconf_id_strings_str36[sizeof("choice")];
-    char kconf_id_strings_str39[sizeof("bool")];
-    char kconf_id_strings_str41[sizeof("source")];
-    char kconf_id_strings_str42[sizeof("visible")];
-    char kconf_id_strings_str43[sizeof("hex")];
-    char kconf_id_strings_str46[sizeof("config")];
-    char kconf_id_strings_str47[sizeof("boolean")];
-    char kconf_id_strings_str51[sizeof("string")];
+    char kconf_id_strings_str22[sizeof("modules")];
+    char kconf_id_strings_str24[sizeof("bool")];
+    char kconf_id_strings_str26[sizeof("source")];
+    char kconf_id_strings_str27[sizeof("endmenu")];
+    char kconf_id_strings_str28[sizeof("hex")];
+    char kconf_id_strings_str31[sizeof("choice")];
+    char kconf_id_strings_str32[sizeof("boolean")];
+    char kconf_id_strings_str35[sizeof("menuconfig")];
+    char kconf_id_strings_str36[sizeof("config")];
+    char kconf_id_strings_str37[sizeof("visible")];
+    char kconf_id_strings_str42[sizeof("comment")];
+    char kconf_id_strings_str43[sizeof("mainmenu")];
+    char kconf_id_strings_str47[sizeof("depends")];
+    char kconf_id_strings_str49[sizeof("menu")];
+    char kconf_id_strings_str51[sizeof("prompt")];
     char kconf_id_strings_str54[sizeof("help")];
-    char kconf_id_strings_str56[sizeof("prompt")];
-    char kconf_id_strings_str72[sizeof("depends")];
+    char kconf_id_strings_str63[sizeof("env")];
   };
 static const struct kconf_id_strings_t kconf_id_strings_contents =
   {
     "if",
     "int",
     "endif",
+    "string",
     "default",
     "tristate",
     "endchoice",
+    "select",
     "def_tristate",
     "def_bool",
     "defconfig_list",
+    "range",
     "on",
     "optional",
+    "subsource",
     "option",
-    "endmenu",
-    "mainmenu",
-    "menuconfig",
     "modules",
-    "menu",
-    "select",
-    "comment",
-    "env",
-    "range",
-    "choice",
     "bool",
     "source",
-    "visible",
+    "endmenu",
     "hex",
-    "config",
+    "choice",
     "boolean",
-    "string",
-    "help",
+    "menuconfig",
+    "config",
+    "visible",
+    "comment",
+    "mainmenu",
+    "depends",
+    "menu",
     "prompt",
-    "depends"
+    "help",
+    "env"
   };
 #define kconf_id_strings ((const char *) &kconf_id_strings_contents)
 #ifdef __GNUC__
 __inline
-#if defined __GNUC_STDC_INLINE__ || defined __GNUC_GNU_INLINE__
+#ifdef __GNUC_STDC_INLINE__
 __attribute__ ((__gnu_inline__))
 #endif
 #endif
@@ -170,98 +172,96 @@ kconf_id_lookup (register const char *str, register unsigned int len)
 {
   enum
     {
-      TOTAL_KEYWORDS = 32,
+      TOTAL_KEYWORDS = 33,
       MIN_WORD_LENGTH = 2,
       MAX_WORD_LENGTH = 14,
       MIN_HASH_VALUE = 2,
-      MAX_HASH_VALUE = 72
+      MAX_HASH_VALUE = 63
     };
 
   static const struct kconf_id wordlist[] =
     {
       {-1}, {-1},
-#line 25 "scripts/kconfig/zconf.gperf"
+#line 26 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str2,		T_IF,		TF_COMMAND|TF_PARAM},
-#line 36 "scripts/kconfig/zconf.gperf"
+#line 37 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str3,		T_TYPE,		TF_COMMAND, S_INT},
       {-1},
-#line 26 "scripts/kconfig/zconf.gperf"
+#line 27 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str5,		T_ENDIF,	TF_COMMAND},
-      {-1},
-#line 29 "scripts/kconfig/zconf.gperf"
+#line 39 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str6,		T_TYPE,		TF_COMMAND, S_STRING},
+#line 30 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str7,	T_DEFAULT,	TF_COMMAND, S_UNKNOWN},
-#line 31 "scripts/kconfig/zconf.gperf"
+#line 32 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str8,	T_TYPE,		TF_COMMAND, S_TRISTATE},
-#line 20 "scripts/kconfig/zconf.gperf"
+#line 21 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str9,	T_ENDCHOICE,	TF_COMMAND},
-      {-1}, {-1},
-#line 32 "scripts/kconfig/zconf.gperf"
+      {-1},
+#line 40 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str11,		T_SELECT,	TF_COMMAND},
+#line 33 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str12,	T_DEFAULT,	TF_COMMAND, S_TRISTATE},
-#line 35 "scripts/kconfig/zconf.gperf"
+#line 36 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str13,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN},
-#line 45 "scripts/kconfig/zconf.gperf"
+#line 46 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str14,	T_OPT_DEFCONFIG_LIST,TF_OPTION},
-      {-1}, {-1},
-#line 43 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str17,		T_ON,		TF_PARAM},
-#line 28 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,	T_OPTIONAL,	TF_COMMAND},
-      {-1}, {-1},
-#line 42 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_OPTION,	TF_COMMAND},
-#line 17 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,	T_ENDMENU,	TF_COMMAND},
-#line 15 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str23,	T_MAINMENU,	TF_COMMAND},
-      {-1},
-#line 23 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str25,	T_MENUCONFIG,	TF_COMMAND},
+#line 41 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str15,		T_RANGE,	TF_COMMAND},
       {-1},
 #line 44 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
-      {-1},
-#line 16 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str29,		T_MENU,		TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str17,		T_ON,		TF_PARAM},
+#line 29 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,	T_OPTIONAL,	TF_COMMAND},
+#line 19 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str19,	T_SUBSOURCE,	TF_COMMAND},
       {-1},
-#line 39 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str31,		T_SELECT,	TF_COMMAND},
-#line 21 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str32,	T_COMMENT,	TF_COMMAND},
-#line 46 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str33,		T_OPT_ENV,	TF_OPTION},
+#line 43 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_OPTION,	TF_COMMAND},
+#line 45 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,	T_OPT_MODULES,	TF_OPTION},
       {-1},
-#line 40 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str35,		T_RANGE,	TF_COMMAND},
-#line 19 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,		T_CHOICE,	TF_COMMAND},
-      {-1}, {-1},
-#line 33 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str39,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
+#line 34 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str24,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
       {-1},
 #line 18 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str41,		T_SOURCE,	TF_COMMAND},
-#line 41 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str42,	T_VISIBLE,	TF_COMMAND},
-#line 37 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str43,		T_TYPE,		TF_COMMAND, S_HEX},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str26,		T_SOURCE,	TF_COMMAND},
+#line 17 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_ENDMENU,	TF_COMMAND},
+#line 38 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,		T_TYPE,		TF_COMMAND, S_HEX},
+      {-1}, {-1},
+#line 20 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str31,		T_CHOICE,	TF_COMMAND},
+#line 35 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str32,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
       {-1}, {-1},
+#line 24 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str35,	T_MENUCONFIG,	TF_COMMAND},
+#line 23 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,		T_CONFIG,	TF_COMMAND},
+#line 42 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str37,	T_VISIBLE,	TF_COMMAND},
+      {-1}, {-1}, {-1}, {-1},
 #line 22 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str46,		T_CONFIG,	TF_COMMAND},
-#line 34 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str47,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str42,	T_COMMENT,	TF_COMMAND},
+#line 15 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str43,	T_MAINMENU,	TF_COMMAND},
       {-1}, {-1}, {-1},
-#line 38 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str51,		T_TYPE,		TF_COMMAND, S_STRING},
+#line 28 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str47,	T_DEPENDS,	TF_COMMAND},
+      {-1},
+#line 16 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str49,		T_MENU,		TF_COMMAND},
+      {-1},
+#line 31 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str51,		T_PROMPT,	TF_COMMAND},
       {-1}, {-1},
-#line 24 "scripts/kconfig/zconf.gperf"
+#line 25 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str54,		T_HELP,		TF_COMMAND},
-      {-1},
-#line 30 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str56,		T_PROMPT,	TF_COMMAND},
-      {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
-      {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
-#line 27 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str72,	T_DEPENDS,	TF_COMMAND}
+      {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
+#line 47 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str63,		T_OPT_ENV,	TF_OPTION}
     };
 
   if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
@@ -282,5 +282,5 @@ kconf_id_lookup (register const char *str, register unsigned int len)
     }
   return 0;
 }
-#line 47 "scripts/kconfig/zconf.gperf"
+#line 48 "scripts/kconfig/zconf.gperf"
 
diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
index 00f9d3a..7e9b6b6 100644
--- a/scripts/kconfig/zconf.l
+++ b/scripts/kconfig/zconf.l
@@ -29,6 +29,7 @@ static int text_size, text_asize;
 struct buffer {
         struct buffer *parent;
         YY_BUFFER_STATE state;
+        struct conf_level *level;
 };
 
 struct buffer *current_buf;
@@ -311,6 +312,7 @@ void zconf_nextfile(const char *name)
 	}
 	yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
 	buf->parent = current_buf;
+	buf->level = current_conf_level;
 	current_buf = buf;
 
 	for (iter = current_file->parent; iter; iter = iter->parent ) {
@@ -337,6 +339,35 @@ void zconf_nextfile(const char *name)
 	current_file = file;
 }
 
+void zconf_nextconf(const char *name, char *subdir, char *subconf, char *title, char *subprefix, char *confprefix)
+{
+	struct conf_level **lp, *l;
+	l = malloc(sizeof(struct conf_level));
+	memset(l,0,sizeof(*l));
+	l->conf = subconf;
+	l->sym_prefix = subprefix;
+	l->conf_prefix = confprefix;
+	l->parent = current_conf_level;
+	for (lp = &conf_levels; *lp; lp = &(*lp)->n) ;
+	*lp = l;
+	current_conf_level = l;
+        
+	zconf_nextfile(name);
+
+	/* allocate per conf module-sym */
+	l->modules_sym = sym_lookup(NULL, 0);
+	l->modules_sym->type = S_BOOLEAN;
+	l->modules_sym->flags |= SYMBOL_AUTO;
+	l->cwd = getcwd(0,0);
+	chdir(subdir);
+
+	/* open new menu */
+	menu_add_entry(NULL);
+	menu_add_prompt(P_MENU, title, NULL);
+	menu_add_menu();
+
+}
+
 static void zconf_endfile(void)
 {
 	struct buffer *parent;
@@ -344,10 +375,27 @@ static void zconf_endfile(void)
 	current_file = current_file->parent;
 
 	parent = current_buf->parent;
+
 	if (parent) {
-		fclose(yyin);
+                fclose(yyin);
 		yy_delete_buffer(YY_CURRENT_BUFFER);
 		yy_switch_to_buffer(parent->state);
+
+		if (current_buf->level && (parent->level != current_buf->level)) {
+			/* close menu */
+			menu_end_menu();
+			/* restore cwd */
+			chdir(current_buf->level->cwd);
+
+			if (current_conf_level && !current_conf_level->modules_sym->prop) {
+				struct property *prop;
+				prop = prop_alloc(P_DEFAULT, current_conf_level->modules_sym);
+				prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0));
+			}
+
+			/* switch to previous conf */
+			current_conf_level = parent->level;
+		}
 	}
 	free(current_buf);
 	current_buf = parent;
diff --git a/scripts/kconfig/zconf.lex.c_shipped b/scripts/kconfig/zconf.lex.c_shipped
index c32b1a4..81bd748 100644
--- a/scripts/kconfig/zconf.lex.c_shipped
+++ b/scripts/kconfig/zconf.lex.c_shipped
@@ -791,6 +791,7 @@ static int text_size, text_asize;
 struct buffer {
         struct buffer *parent;
         YY_BUFFER_STATE state;
+        struct conf_level *level;
 };
 
 struct buffer *current_buf;
@@ -920,7 +921,7 @@ static int input (void );
 /* This used to be an fputs(), but since the string might contain NUL's,
  * we now use fwrite().
  */
-#define ECHO do { if (fwrite( zconftext, zconfleng, 1, zconfout )) {} } while (0)
+#define ECHO fwrite( zconftext, zconfleng, 1, zconfout )
 #endif
 
 /* Gets input and stuffs it into "buf".  number of characters read, or YY_NULL,
@@ -2366,6 +2367,7 @@ void zconf_nextfile(const char *name)
 	}
 	zconf_switch_to_buffer(zconf_create_buffer(zconfin,YY_BUF_SIZE));
 	buf->parent = current_buf;
+	buf->level = current_conf_level;
 	current_buf = buf;
 
 	for (iter = current_file->parent; iter; iter = iter->parent ) {
@@ -2392,6 +2394,35 @@ void zconf_nextfile(const char *name)
 	current_file = file;
 }
 
+void zconf_nextconf(const char *name, char *subdir, char *subconf, char *title, char *subprefix, char *confprefix)
+{
+	struct conf_level **lp, *l;
+	l = malloc(sizeof(struct conf_level));
+	memset(l,0,sizeof(*l));
+	l->conf = subconf;
+	l->sym_prefix = subprefix;
+	l->conf_prefix = confprefix;
+	l->parent = current_conf_level;
+	for (lp = &conf_levels; *lp; lp = &(*lp)->n) ;
+	*lp = l;
+	current_conf_level = l;
+        
+	zconf_nextfile(name);
+
+	/* allocate per conf module-sym */
+	l->modules_sym = sym_lookup(NULL, 0);
+	l->modules_sym->type = S_BOOLEAN;
+	l->modules_sym->flags |= SYMBOL_AUTO;
+	l->cwd = getcwd(0,0);
+	chdir(subdir);
+
+	/* open new menu */
+	menu_add_entry(NULL);
+	menu_add_prompt(P_MENU, title, NULL);
+	menu_add_menu();
+
+}
+
 static void zconf_endfile(void)
 {
 	struct buffer *parent;
@@ -2399,10 +2430,27 @@ static void zconf_endfile(void)
 	current_file = current_file->parent;
 
 	parent = current_buf->parent;
+
 	if (parent) {
-		fclose(zconfin);
+                fclose(zconfin);
 		zconf_delete_buffer(YY_CURRENT_BUFFER);
 		zconf_switch_to_buffer(parent->state);
+
+		if (current_buf->level && (parent->level != current_buf->level)) {
+			/* close menu */
+			menu_end_menu();
+			/* restore cwd */
+			chdir(current_buf->level->cwd);
+
+			if (current_conf_level && !current_conf_level->modules_sym->prop) {
+				struct property *prop;
+				prop = prop_alloc(P_DEFAULT, current_conf_level->modules_sym);
+				prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0));
+			}
+
+			/* switch to previous conf */
+			current_conf_level = parent->level;
+		}
 	}
 	free(current_buf);
 	current_buf = parent;
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index f636141..f424687 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -1,22 +1,24 @@
-/* A Bison parser, made by GNU Bison 2.4.3.  */
+/* A Bison parser, made by GNU Bison 2.3.  */
 
 /* Skeleton implementation for Bison's Yacc-like parsers in C
-   
-      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
-   2009, 2010 Free Software Foundation, Inc.
-   
-   This program is free software: you can redistribute it and/or modify
+
+   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
+   Free Software Foundation, Inc.
+
+   This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
-   the Free Software Foundation, either version 3 of the License, or
-   (at your option) any later version.
-   
+   the Free Software Foundation; either version 2, or (at your option)
+   any later version.
+
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
-   
+
    You should have received a copy of the GNU General Public License
-   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 51 Franklin Street, Fifth Floor,
+   Boston, MA 02110-1301, USA.  */
 
 /* As a special exception, you may create a larger work that contains
    part or all of the Bison parser skeleton and distribute that work
@@ -27,7 +29,7 @@
    special exception, which will cause the skeleton and the resulting
    Bison output files to be licensed under the GNU General Public
    License without this special exception.
-   
+
    This special exception was added by the Free Software Foundation in
    version 2.2 of Bison.  */
 
@@ -45,7 +47,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.4.3"
+#define YYBISON_VERSION "2.3"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -53,23 +55,98 @@
 /* Pure parsers.  */
 #define YYPURE 0
 
-/* Push parsers.  */
-#define YYPUSH 0
-
-/* Pull parsers.  */
-#define YYPULL 1
-
 /* Using locations.  */
 #define YYLSP_NEEDED 0
 
 /* Substitute the variable and function names.  */
-#define yyparse         zconfparse
-#define yylex           zconflex
-#define yyerror         zconferror
-#define yylval          zconflval
-#define yychar          zconfchar
-#define yydebug         zconfdebug
-#define yynerrs         zconfnerrs
+#define yyparse zconfparse
+#define yylex   zconflex
+#define yyerror zconferror
+#define yylval  zconflval
+#define yychar  zconfchar
+#define yydebug zconfdebug
+#define yynerrs zconfnerrs
+
+
+/* Tokens.  */
+#ifndef YYTOKENTYPE
+# define YYTOKENTYPE
+   /* Put the tokens into the symbol table, so that GDB and other debuggers
+      know about them.  */
+   enum yytokentype {
+     T_MAINMENU = 258,
+     T_MENU = 259,
+     T_ENDMENU = 260,
+     T_SOURCE = 261,
+     T_SUBSOURCE = 262,
+     T_CHOICE = 263,
+     T_ENDCHOICE = 264,
+     T_COMMENT = 265,
+     T_CONFIG = 266,
+     T_MENUCONFIG = 267,
+     T_HELP = 268,
+     T_HELPTEXT = 269,
+     T_IF = 270,
+     T_ENDIF = 271,
+     T_DEPENDS = 272,
+     T_OPTIONAL = 273,
+     T_PROMPT = 274,
+     T_TYPE = 275,
+     T_DEFAULT = 276,
+     T_SELECT = 277,
+     T_RANGE = 278,
+     T_VISIBLE = 279,
+     T_OPTION = 280,
+     T_ON = 281,
+     T_WORD = 282,
+     T_WORD_QUOTE = 283,
+     T_UNEQUAL = 284,
+     T_CLOSE_PAREN = 285,
+     T_OPEN_PAREN = 286,
+     T_EOL = 287,
+     T_OR = 288,
+     T_AND = 289,
+     T_EQUAL = 290,
+     T_NOT = 291
+   };
+#endif
+/* Tokens.  */
+#define T_MAINMENU 258
+#define T_MENU 259
+#define T_ENDMENU 260
+#define T_SOURCE 261
+#define T_SUBSOURCE 262
+#define T_CHOICE 263
+#define T_ENDCHOICE 264
+#define T_COMMENT 265
+#define T_CONFIG 266
+#define T_MENUCONFIG 267
+#define T_HELP 268
+#define T_HELPTEXT 269
+#define T_IF 270
+#define T_ENDIF 271
+#define T_DEPENDS 272
+#define T_OPTIONAL 273
+#define T_PROMPT 274
+#define T_TYPE 275
+#define T_DEFAULT 276
+#define T_SELECT 277
+#define T_RANGE 278
+#define T_VISIBLE 279
+#define T_OPTION 280
+#define T_ON 281
+#define T_WORD 282
+#define T_WORD_QUOTE 283
+#define T_UNEQUAL 284
+#define T_CLOSE_PAREN 285
+#define T_OPEN_PAREN 286
+#define T_EOL 287
+#define T_OR 288
+#define T_AND 289
+#define T_EQUAL 290
+#define T_NOT 291
+
+
 
 
 /* Copy the first part of user declarations.  */
@@ -95,7 +172,8 @@
 #define DEBUG_PARSE	0x0002
 
 int cdebug = PRINTD;
-
+int dosubsource = 0;
+ 
 extern int zconflex(void);
 static void zconfprint(const char *err, ...);
 static void zconf_error(const char *err, ...);
@@ -105,7 +183,8 @@ static bool zconf_endtoken(const struct kconf_id *id, int starttoken, int endtok
 struct symbol *symbol_hash[SYMBOL_HASHSIZE];
 
 static struct menu *current_menu, *current_entry;
-
+struct conf_level *current_conf_level = 0;
+struct conf_level *conf_levels = 0;
 
 
 
@@ -127,72 +206,27 @@ static struct menu *current_menu, *current_entry;
 # define YYTOKEN_TABLE 0
 #endif
 
-
-/* Tokens.  */
-#ifndef YYTOKENTYPE
-# define YYTOKENTYPE
-   /* Put the tokens into the symbol table, so that GDB and other debuggers
-      know about them.  */
-   enum yytokentype {
-     T_MAINMENU = 258,
-     T_MENU = 259,
-     T_ENDMENU = 260,
-     T_SOURCE = 261,
-     T_CHOICE = 262,
-     T_ENDCHOICE = 263,
-     T_COMMENT = 264,
-     T_CONFIG = 265,
-     T_MENUCONFIG = 266,
-     T_HELP = 267,
-     T_HELPTEXT = 268,
-     T_IF = 269,
-     T_ENDIF = 270,
-     T_DEPENDS = 271,
-     T_OPTIONAL = 272,
-     T_PROMPT = 273,
-     T_TYPE = 274,
-     T_DEFAULT = 275,
-     T_SELECT = 276,
-     T_RANGE = 277,
-     T_VISIBLE = 278,
-     T_OPTION = 279,
-     T_ON = 280,
-     T_WORD = 281,
-     T_WORD_QUOTE = 282,
-     T_UNEQUAL = 283,
-     T_CLOSE_PAREN = 284,
-     T_OPEN_PAREN = 285,
-     T_EOL = 286,
-     T_OR = 287,
-     T_AND = 288,
-     T_EQUAL = 289,
-     T_NOT = 290
-   };
-#endif
-
-
-
 #if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
 typedef union YYSTYPE
-{
-
 
+{
 	char *string;
 	struct file *file;
 	struct symbol *symbol;
 	struct expr *expr;
 	struct menu *menu;
 	const struct kconf_id *id;
+}
+/* Line 187 of yacc.c.  */
 
-
-
-} YYSTYPE;
-# define YYSTYPE_IS_TRIVIAL 1
+	YYSTYPE;
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
 # define YYSTYPE_IS_DECLARED 1
+# define YYSTYPE_IS_TRIVIAL 1
 #endif
 
 
+
 /* Copy the second part of user declarations.  */
 
 
@@ -200,6 +234,8 @@ typedef union YYSTYPE
 #include "zconf.hash.c"
 
 
+/* Line 216 of yacc.c.  */
+
 
 #ifdef short
 # undef short
@@ -249,7 +285,7 @@ typedef short int yytype_int16;
 #define YYSIZE_MAXIMUM ((YYSIZE_T) -1)
 
 #ifndef YY_
-# if defined YYENABLE_NLS && YYENABLE_NLS
+# if YYENABLE_NLS
 #  if ENABLE_NLS
 #   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
 #   define YY_(msgid) dgettext ("bison-runtime", msgid)
@@ -274,14 +310,14 @@ typedef short int yytype_int16;
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 static int
-YYID (int yyi)
+YYID (int i)
 #else
 static int
-YYID (yyi)
-    int yyi;
+YYID (i)
+    int i;
 #endif
 {
-  return yyi;
+  return i;
 }
 #endif
 
@@ -362,9 +398,9 @@ void free (void *); /* INFRINGES ON USER NAME SPACE */
 /* A type that is properly aligned for any stack member.  */
 union yyalloc
 {
-  yytype_int16 yyss_alloc;
-  YYSTYPE yyvs_alloc;
-};
+  yytype_int16 yyss;
+  YYSTYPE yyvs;
+  };
 
 /* The size of the maximum gap between one aligned stack and the next.  */
 # define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)
@@ -398,12 +434,12 @@ union yyalloc
    elements in the stack, and YYPTR gives the new location of the
    stack.  Advance YYPTR to a properly aligned location for the next
    stack.  */
-# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
+# define YYSTACK_RELOCATE(Stack)					\
     do									\
       {									\
 	YYSIZE_T yynewbytes;						\
-	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
-	Stack = &yyptr->Stack_alloc;					\
+	YYCOPY (&yyptr->Stack, Stack, yysize);				\
+	Stack = &yyptr->Stack;						\
 	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
 	yyptr += yynewbytes / sizeof (*yyptr);				\
       }									\
@@ -412,22 +448,22 @@ union yyalloc
 #endif
 
 /* YYFINAL -- State number of the termination state.  */
-#define YYFINAL  11
+#define YYFINAL  6
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   290
+#define YYLAST   287
 
 /* YYNTOKENS -- Number of terminals.  */
-#define YYNTOKENS  36
+#define YYNTOKENS  37
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  50
+#define YYNNTS  51
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  118
+#define YYNRULES  120
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  191
+#define YYNSTATES  199
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
-#define YYMAXUTOK   290
+#define YYMAXUTOK   291
 
 #define YYTRANSLATE(YYX)						\
   ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
@@ -464,7 +500,7 @@ static const yytype_uint8 yytranslate[] =
        5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
       15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
       25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
-      35
+      35,    36
 };
 
 #if YYDEBUG
@@ -472,75 +508,78 @@ static const yytype_uint8 yytranslate[] =
    YYRHS.  */
 static const yytype_uint16 yyprhs[] =
 {
-       0,     0,     3,     6,     8,    11,    13,    14,    17,    20,
-      23,    26,    31,    36,    40,    42,    44,    46,    48,    50,
-      52,    54,    56,    58,    60,    62,    64,    66,    68,    72,
-      75,    79,    82,    86,    89,    90,    93,    96,    99,   102,
-     105,   108,   112,   117,   122,   127,   133,   137,   138,   142,
-     143,   146,   150,   153,   155,   159,   160,   163,   166,   169,
-     172,   175,   180,   184,   187,   192,   193,   196,   200,   202,
-     206,   207,   210,   213,   216,   220,   224,   228,   230,   234,
-     235,   238,   241,   244,   248,   252,   255,   258,   261,   262,
-     265,   268,   271,   276,   277,   280,   283,   286,   287,   290,
-     292,   294,   297,   300,   303,   305,   308,   309,   312,   314,
-     318,   322,   326,   329,   333,   337,   339,   341,   342
+       0,     0,     3,     6,     8,    10,    11,    14,    17,    20,
+      23,    28,    33,    37,    39,    41,    43,    45,    47,    49,
+      51,    53,    55,    57,    59,    61,    63,    65,    67,    69,
+      73,    76,    80,    83,    87,    90,    91,    94,    97,   100,
+     103,   106,   109,   113,   118,   123,   128,   134,   138,   139,
+     143,   144,   147,   151,   154,   156,   160,   161,   164,   167,
+     170,   173,   176,   181,   185,   188,   193,   194,   197,   201,
+     203,   207,   208,   211,   214,   217,   221,   225,   229,   231,
+     235,   236,   239,   242,   245,   249,   258,   262,   265,   268,
+     271,   272,   275,   278,   281,   286,   287,   290,   293,   296,
+     297,   300,   302,   304,   307,   310,   313,   315,   318,   319,
+     322,   324,   328,   332,   336,   339,   343,   347,   349,   351,
+     352
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
 static const yytype_int8 yyrhs[] =
 {
-      37,     0,    -1,    81,    38,    -1,    38,    -1,    63,    39,
-      -1,    39,    -1,    -1,    39,    41,    -1,    39,    55,    -1,
-      39,    67,    -1,    39,    80,    -1,    39,    26,     1,    31,
-      -1,    39,    40,     1,    31,    -1,    39,     1,    31,    -1,
-      16,    -1,    18,    -1,    19,    -1,    21,    -1,    17,    -1,
-      22,    -1,    20,    -1,    23,    -1,    31,    -1,    61,    -1,
-      71,    -1,    44,    -1,    46,    -1,    69,    -1,    26,     1,
-      31,    -1,     1,    31,    -1,    10,    26,    31,    -1,    43,
-      47,    -1,    11,    26,    31,    -1,    45,    47,    -1,    -1,
-      47,    48,    -1,    47,    49,    -1,    47,    75,    -1,    47,
-      73,    -1,    47,    42,    -1,    47,    31,    -1,    19,    78,
-      31,    -1,    18,    79,    82,    31,    -1,    20,    83,    82,
-      31,    -1,    21,    26,    82,    31,    -1,    22,    84,    84,
-      82,    31,    -1,    24,    50,    31,    -1,    -1,    50,    26,
-      51,    -1,    -1,    34,    79,    -1,     7,    85,    31,    -1,
-      52,    56,    -1,    80,    -1,    53,    58,    54,    -1,    -1,
-      56,    57,    -1,    56,    75,    -1,    56,    73,    -1,    56,
-      31,    -1,    56,    42,    -1,    18,    79,    82,    31,    -1,
-      19,    78,    31,    -1,    17,    31,    -1,    20,    26,    82,
-      31,    -1,    -1,    58,    41,    -1,    14,    83,    81,    -1,
-      80,    -1,    59,    62,    60,    -1,    -1,    62,    41,    -1,
-      62,    67,    -1,    62,    55,    -1,     3,    79,    81,    -1,
-       4,    79,    31,    -1,    64,    76,    74,    -1,    80,    -1,
-      65,    68,    66,    -1,    -1,    68,    41,    -1,    68,    67,
-      -1,    68,    55,    -1,     6,    79,    31,    -1,     9,    79,
-      31,    -1,    70,    74,    -1,    12,    31,    -1,    72,    13,
-      -1,    -1,    74,    75,    -1,    74,    31,    -1,    74,    42,
-      -1,    16,    25,    83,    31,    -1,    -1,    76,    77,    -1,
-      76,    31,    -1,    23,    82,    -1,    -1,    79,    82,    -1,
-      26,    -1,    27,    -1,     5,    31,    -1,     8,    31,    -1,
-      15,    31,    -1,    31,    -1,    81,    31,    -1,    -1,    14,
-      83,    -1,    84,    -1,    84,    34,    84,    -1,    84,    28,
-      84,    -1,    30,    83,    29,    -1,    35,    83,    -1,    83,
-      32,    83,    -1,    83,    33,    83,    -1,    26,    -1,    27,
-      -1,    -1,    26,    -1
+      38,     0,    -1,    83,    39,    -1,    39,    -1,    40,    -1,
+      -1,    40,    42,    -1,    40,    56,    -1,    40,    68,    -1,
+      40,    82,    -1,    40,    27,     1,    32,    -1,    40,    41,
+       1,    32,    -1,    40,     1,    32,    -1,    17,    -1,    19,
+      -1,    20,    -1,    22,    -1,    18,    -1,    23,    -1,    21,
+      -1,    24,    -1,    32,    -1,    62,    -1,    64,    -1,    73,
+      -1,    45,    -1,    47,    -1,    70,    -1,    71,    -1,    27,
+       1,    32,    -1,     1,    32,    -1,    11,    27,    32,    -1,
+      44,    48,    -1,    12,    27,    32,    -1,    46,    48,    -1,
+      -1,    48,    49,    -1,    48,    50,    -1,    48,    77,    -1,
+      48,    75,    -1,    48,    43,    -1,    48,    32,    -1,    20,
+      80,    32,    -1,    19,    81,    84,    32,    -1,    21,    85,
+      84,    32,    -1,    22,    27,    84,    32,    -1,    23,    86,
+      86,    84,    32,    -1,    25,    51,    32,    -1,    -1,    51,
+      27,    52,    -1,    -1,    35,    81,    -1,     8,    87,    32,
+      -1,    53,    57,    -1,    82,    -1,    54,    59,    55,    -1,
+      -1,    57,    58,    -1,    57,    77,    -1,    57,    75,    -1,
+      57,    32,    -1,    57,    43,    -1,    19,    81,    84,    32,
+      -1,    20,    80,    32,    -1,    18,    32,    -1,    21,    27,
+      84,    32,    -1,    -1,    59,    42,    -1,    15,    85,    83,
+      -1,    82,    -1,    60,    63,    61,    -1,    -1,    63,    42,
+      -1,    63,    68,    -1,    63,    56,    -1,     3,    81,    83,
+      -1,     4,    81,    32,    -1,    65,    78,    76,    -1,    82,
+      -1,    66,    69,    67,    -1,    -1,    69,    42,    -1,    69,
+      68,    -1,    69,    56,    -1,     6,    81,    32,    -1,     7,
+      81,    81,    81,    81,    27,    87,    32,    -1,    10,    81,
+      32,    -1,    72,    76,    -1,    13,    32,    -1,    74,    14,
+      -1,    -1,    76,    77,    -1,    76,    32,    -1,    76,    43,
+      -1,    17,    26,    85,    32,    -1,    -1,    78,    79,    -1,
+      78,    32,    -1,    24,    84,    -1,    -1,    81,    84,    -1,
+      27,    -1,    28,    -1,     5,    32,    -1,     9,    32,    -1,
+      16,    32,    -1,    32,    -1,    83,    32,    -1,    -1,    15,
+      85,    -1,    86,    -1,    86,    35,    86,    -1,    86,    29,
+      86,    -1,    31,    85,    30,    -1,    36,    85,    -1,    85,
+      33,    85,    -1,    85,    34,    85,    -1,    27,    -1,    28,
+      -1,    -1,    27,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint16 yyrline[] =
 {
-       0,   104,   104,   104,   106,   106,   108,   110,   111,   112,
-     113,   114,   115,   119,   123,   123,   123,   123,   123,   123,
-     123,   123,   127,   128,   129,   130,   131,   132,   136,   137,
-     143,   151,   157,   165,   175,   177,   178,   179,   180,   181,
-     182,   185,   193,   199,   209,   215,   221,   224,   226,   237,
-     238,   243,   252,   257,   265,   268,   270,   271,   272,   273,
-     274,   277,   283,   294,   300,   310,   312,   317,   325,   333,
-     336,   338,   339,   340,   345,   352,   359,   364,   372,   375,
-     377,   378,   379,   382,   390,   397,   404,   410,   417,   419,
-     420,   421,   424,   432,   434,   435,   438,   445,   447,   452,
-     453,   456,   457,   458,   462,   463,   466,   467,   470,   471,
-     472,   473,   474,   475,   476,   479,   480,   483,   484
+       0,   107,   107,   107,   109,   111,   113,   114,   115,   116,
+     117,   118,   122,   126,   126,   126,   126,   126,   126,   126,
+     126,   130,   131,   132,   133,   134,   135,   136,   137,   141,
+     142,   148,   156,   162,   170,   180,   182,   183,   184,   185,
+     186,   187,   190,   198,   204,   214,   220,   226,   229,   231,
+     242,   243,   248,   257,   262,   270,   273,   275,   276,   277,
+     278,   279,   282,   288,   299,   305,   315,   317,   322,   330,
+     338,   341,   343,   344,   345,   350,   357,   364,   369,   377,
+     380,   382,   383,   384,   387,   394,   404,   411,   418,   424,
+     431,   433,   434,   435,   438,   446,   448,   449,   452,   459,
+     461,   466,   467,   470,   471,   472,   476,   477,   480,   481,
+     484,   485,   486,   487,   488,   489,   490,   493,   494,   497,
+     498
 };
 #endif
 
@@ -550,22 +589,23 @@ static const yytype_uint16 yyrline[] =
 static const char *const yytname[] =
 {
   "$end", "error", "$undefined", "T_MAINMENU", "T_MENU", "T_ENDMENU",
-  "T_SOURCE", "T_CHOICE", "T_ENDCHOICE", "T_COMMENT", "T_CONFIG",
-  "T_MENUCONFIG", "T_HELP", "T_HELPTEXT", "T_IF", "T_ENDIF", "T_DEPENDS",
-  "T_OPTIONAL", "T_PROMPT", "T_TYPE", "T_DEFAULT", "T_SELECT", "T_RANGE",
-  "T_VISIBLE", "T_OPTION", "T_ON", "T_WORD", "T_WORD_QUOTE", "T_UNEQUAL",
-  "T_CLOSE_PAREN", "T_OPEN_PAREN", "T_EOL", "T_OR", "T_AND", "T_EQUAL",
-  "T_NOT", "$accept", "input", "start", "stmt_list", "option_name",
-  "common_stmt", "option_error", "config_entry_start", "config_stmt",
-  "menuconfig_entry_start", "menuconfig_stmt", "config_option_list",
-  "config_option", "symbol_option", "symbol_option_list",
-  "symbol_option_arg", "choice", "choice_entry", "choice_end",
-  "choice_stmt", "choice_option_list", "choice_option", "choice_block",
-  "if_entry", "if_end", "if_stmt", "if_block", "mainmenu_stmt", "menu",
-  "menu_entry", "menu_end", "menu_stmt", "menu_block", "source_stmt",
-  "comment", "comment_stmt", "help_start", "help", "depends_list",
-  "depends", "visibility_list", "visible", "prompt_stmt_opt", "prompt",
-  "end", "nl", "if_expr", "expr", "symbol", "word_opt", 0
+  "T_SOURCE", "T_SUBSOURCE", "T_CHOICE", "T_ENDCHOICE", "T_COMMENT",
+  "T_CONFIG", "T_MENUCONFIG", "T_HELP", "T_HELPTEXT", "T_IF", "T_ENDIF",
+  "T_DEPENDS", "T_OPTIONAL", "T_PROMPT", "T_TYPE", "T_DEFAULT", "T_SELECT",
+  "T_RANGE", "T_VISIBLE", "T_OPTION", "T_ON", "T_WORD", "T_WORD_QUOTE",
+  "T_UNEQUAL", "T_CLOSE_PAREN", "T_OPEN_PAREN", "T_EOL", "T_OR", "T_AND",
+  "T_EQUAL", "T_NOT", "$accept", "input", "start", "stmt_list",
+  "option_name", "common_stmt", "option_error", "config_entry_start",
+  "config_stmt", "menuconfig_entry_start", "menuconfig_stmt",
+  "config_option_list", "config_option", "symbol_option",
+  "symbol_option_list", "symbol_option_arg", "choice", "choice_entry",
+  "choice_end", "choice_stmt", "choice_option_list", "choice_option",
+  "choice_block", "if_entry", "if_end", "if_stmt", "if_block",
+  "mainmenu_stmt", "menu", "menu_entry", "menu_end", "menu_stmt",
+  "menu_block", "source_stmt", "subsource_stmt", "comment", "comment_stmt",
+  "help_start", "help", "depends_list", "depends", "visibility_list",
+  "visible", "prompt_stmt_opt", "prompt", "end", "nl", "if_expr", "expr",
+  "symbol", "word_opt", 0
 };
 #endif
 
@@ -577,42 +617,44 @@ static const yytype_uint16 yytoknum[] =
        0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
      265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
      275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
-     285,   286,   287,   288,   289,   290
+     285,   286,   287,   288,   289,   290,   291
 };
 # endif
 
 /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
 static const yytype_uint8 yyr1[] =
 {
-       0,    36,    37,    37,    38,    38,    39,    39,    39,    39,
-      39,    39,    39,    39,    40,    40,    40,    40,    40,    40,
-      40,    40,    41,    41,    41,    41,    41,    41,    42,    42,
-      43,    44,    45,    46,    47,    47,    47,    47,    47,    47,
-      47,    48,    48,    48,    48,    48,    49,    50,    50,    51,
-      51,    52,    53,    54,    55,    56,    56,    56,    56,    56,
-      56,    57,    57,    57,    57,    58,    58,    59,    60,    61,
-      62,    62,    62,    62,    63,    64,    65,    66,    67,    68,
-      68,    68,    68,    69,    70,    71,    72,    73,    74,    74,
-      74,    74,    75,    76,    76,    76,    77,    78,    78,    79,
-      79,    80,    80,    80,    81,    81,    82,    82,    83,    83,
-      83,    83,    83,    83,    83,    84,    84,    85,    85
+       0,    37,    38,    38,    39,    40,    40,    40,    40,    40,
+      40,    40,    40,    41,    41,    41,    41,    41,    41,    41,
+      41,    42,    42,    42,    42,    42,    42,    42,    42,    43,
+      43,    44,    45,    46,    47,    48,    48,    48,    48,    48,
+      48,    48,    49,    49,    49,    49,    49,    50,    51,    51,
+      52,    52,    53,    54,    55,    56,    57,    57,    57,    57,
+      57,    57,    58,    58,    58,    58,    59,    59,    60,    61,
+      62,    63,    63,    63,    63,    64,    65,    66,    67,    68,
+      69,    69,    69,    69,    70,    71,    72,    73,    74,    75,
+      76,    76,    76,    76,    77,    78,    78,    78,    79,    80,
+      80,    81,    81,    82,    82,    82,    83,    83,    84,    84,
+      85,    85,    85,    85,    85,    85,    85,    86,    86,    87,
+      87
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
 static const yytype_uint8 yyr2[] =
 {
-       0,     2,     2,     1,     2,     1,     0,     2,     2,     2,
-       2,     4,     4,     3,     1,     1,     1,     1,     1,     1,
-       1,     1,     1,     1,     1,     1,     1,     1,     3,     2,
-       3,     2,     3,     2,     0,     2,     2,     2,     2,     2,
-       2,     3,     4,     4,     4,     5,     3,     0,     3,     0,
-       2,     3,     2,     1,     3,     0,     2,     2,     2,     2,
-       2,     4,     3,     2,     4,     0,     2,     3,     1,     3,
-       0,     2,     2,     2,     3,     3,     3,     1,     3,     0,
-       2,     2,     2,     3,     3,     2,     2,     2,     0,     2,
-       2,     2,     4,     0,     2,     2,     2,     0,     2,     1,
-       1,     2,     2,     2,     1,     2,     0,     2,     1,     3,
-       3,     3,     2,     3,     3,     1,     1,     0,     1
+       0,     2,     2,     1,     1,     0,     2,     2,     2,     2,
+       4,     4,     3,     1,     1,     1,     1,     1,     1,     1,
+       1,     1,     1,     1,     1,     1,     1,     1,     1,     3,
+       2,     3,     2,     3,     2,     0,     2,     2,     2,     2,
+       2,     2,     3,     4,     4,     4,     5,     3,     0,     3,
+       0,     2,     3,     2,     1,     3,     0,     2,     2,     2,
+       2,     2,     4,     3,     2,     4,     0,     2,     3,     1,
+       3,     0,     2,     2,     2,     3,     3,     3,     1,     3,
+       0,     2,     2,     2,     3,     8,     3,     2,     2,     2,
+       0,     2,     2,     2,     4,     0,     2,     2,     2,     0,
+       2,     1,     1,     2,     2,     2,     1,     2,     0,     2,
+       1,     3,     3,     3,     2,     3,     3,     1,     1,     0,
+       1
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -620,172 +662,172 @@ static const yytype_uint8 yyr2[] =
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       6,     0,   104,     0,     3,     0,     6,     6,    99,   100,
-       0,     1,     0,     0,     0,     0,   117,     0,     0,     0,
-       0,     0,     0,    14,    18,    15,    16,    20,    17,    19,
-      21,     0,    22,     0,     7,    34,    25,    34,    26,    55,
-      65,     8,    70,    23,    93,    79,     9,    27,    88,    24,
-      10,     0,   105,     2,    74,    13,     0,   101,     0,   118,
-       0,   102,     0,     0,     0,   115,   116,     0,     0,     0,
-     108,   103,     0,     0,     0,     0,     0,     0,     0,    88,
-       0,     0,    75,    83,    51,    84,    30,    32,     0,   112,
-       0,     0,    67,     0,     0,    11,    12,     0,     0,     0,
-       0,    97,     0,     0,     0,    47,     0,    40,    39,    35,
-      36,     0,    38,    37,     0,     0,    97,     0,    59,    60,
-      56,    58,    57,    66,    54,    53,    71,    73,    69,    72,
-      68,   106,    95,     0,    94,    80,    82,    78,    81,    77,
-      90,    91,    89,   111,   113,   114,   110,   109,    29,    86,
-       0,   106,     0,   106,   106,   106,     0,     0,     0,    87,
-      63,   106,     0,   106,     0,    96,     0,     0,    41,    98,
-       0,     0,   106,    49,    46,    28,     0,    62,     0,   107,
-      92,    42,    43,    44,     0,     0,    48,    61,    64,    45,
-      50
+       5,   106,     0,     3,     0,     5,     1,     0,     0,     0,
+       0,     0,     0,   119,     0,     0,     0,     0,     0,     0,
+      13,    17,    14,    15,    19,    16,    18,    20,     0,    21,
+       0,     6,    35,    25,    35,    26,    56,    66,     7,    71,
+      22,    23,    95,    80,     8,    27,    28,    90,    24,     9,
+     107,     2,    12,   101,   102,     0,     0,   103,     0,     0,
+     120,     0,   104,     0,     0,     0,   117,   118,     0,     0,
+       0,   110,   105,     0,     0,     0,     0,     0,     0,     0,
+      90,     0,     0,    75,    76,    84,     0,    52,    86,    31,
+      33,     0,   114,     0,     0,    68,     0,     0,    10,    11,
+       0,     0,     0,     0,    99,     0,     0,     0,    48,     0,
+      41,    40,    36,    37,     0,    39,    38,     0,     0,    99,
+       0,    60,    61,    57,    59,    58,    67,    55,    54,    72,
+      74,    70,    73,    69,   108,    97,     0,    96,    81,    83,
+      79,    82,    78,    92,    93,    91,     0,   113,   115,   116,
+     112,   111,    30,    88,     0,   108,     0,   108,   108,   108,
+       0,     0,     0,    89,    64,   108,     0,   108,     0,    98,
+       0,     0,     0,    42,   100,     0,     0,   108,    50,    47,
+      29,     0,    63,     0,   109,   119,    94,    43,    44,    45,
+       0,     0,    49,    62,    65,     0,    46,    51,    85
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int16 yydefgoto[] =
 {
-      -1,     3,     4,     5,    33,    34,   108,    35,    36,    37,
-      38,    74,   109,   110,   157,   186,    39,    40,   124,    41,
-      76,   120,    77,    42,   128,    43,    78,     6,    44,    45,
-     137,    46,    80,    47,    48,    49,   111,   112,    81,   113,
-      79,   134,   152,   153,    50,     7,   165,    69,    70,    60
+      -1,     2,     3,     4,    30,    31,   111,    32,    33,    34,
+      35,    75,   112,   113,   161,   192,    36,    37,   127,    38,
+      77,   123,    78,    39,   131,    40,    79,    41,    42,    43,
+     140,    44,    81,    45,    46,    47,    48,   114,   115,    82,
+     116,    80,   137,   156,   157,    49,     5,   169,    70,    71,
+      61
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -90
+#define YYPACT_NINF -89
 static const yytype_int16 yypact[] =
 {
-       4,    42,   -90,    96,   -90,   111,   -90,    15,   -90,   -90,
-      75,   -90,    82,    42,   104,    42,   110,   107,    42,   115,
-     125,    -4,   121,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   162,   -90,   163,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   139,   -90,   -90,   138,   -90,   142,   -90,   143,   -90,
-     152,   -90,   164,   167,   168,   -90,   -90,    -4,    -4,    77,
-     -18,   -90,   177,   185,    33,    71,   195,   247,   236,    -2,
-     236,   171,   -90,   -90,   -90,   -90,   -90,   -90,    41,   -90,
-      -4,    -4,   138,    97,    97,   -90,   -90,   186,   187,   194,
-      42,    42,    -4,   196,    97,   -90,   219,   -90,   -90,   -90,
-     -90,   210,   -90,   -90,   204,    42,    42,   199,   -90,   -90,
-     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   222,   -90,   223,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   -90,   -90,   -90,   215,   -90,   -90,   -90,   -90,   -90,
-      -4,   222,   228,   222,    -5,   222,    97,    35,   229,   -90,
-     -90,   222,   232,   222,    -4,   -90,   135,   233,   -90,   -90,
-     234,   235,   222,   240,   -90,   -90,   237,   -90,   239,   -13,
-     -90,   -90,   -90,   -90,   244,    42,   -90,   -90,   -90,   -90,
-     -90
+     -30,   -89,    73,   -89,    17,    64,   -89,    71,    59,    59,
+      75,    59,    59,    77,    90,    59,   107,   116,    70,   123,
+     -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   166,   -89,
+     170,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,
+     -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,
+     -89,   -89,   -89,   -89,   -89,   -30,   146,   -89,   148,    59,
+     -89,   174,   -89,   175,   177,   178,   -89,   -89,    70,    70,
+     -20,    42,   -89,   179,   192,   108,   141,    47,   255,   241,
+      23,   241,   181,    64,   -89,   -89,    59,   -89,   -89,   -89,
+     -89,    55,   -89,    70,    70,    64,    72,    72,   -89,   -89,
+     193,   197,   204,    59,    59,    70,   205,    72,   -89,   230,
+     -89,   -89,   -89,   -89,   219,   -89,   -89,   202,    59,    59,
+     208,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,
+     -89,   -89,   -89,   -89,   221,   -89,   211,   -89,   -89,   -89,
+     -89,   -89,   -89,   -89,   -89,   -89,    59,   -89,   203,   -89,
+     -89,   -89,   -89,   -89,    70,   221,   207,   221,    60,   221,
+      72,    49,   209,   -89,   -89,   221,   210,   221,    70,   -89,
+     213,   142,   222,   -89,   -89,   223,   227,   221,   228,   -89,
+     -89,   236,   -89,   237,   161,    77,   -89,   -89,   -89,   -89,
+     240,    59,   -89,   -89,   -89,   242,   -89,   -89,   -89
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int16 yypgoto[] =
 {
-     -90,   -90,   269,   271,   -90,    23,   -70,   -90,   -90,   -90,
-     -90,   243,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -48,
-     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   -20,   -90,   -90,   -90,   -90,   -90,   206,   205,   -68,
-     -90,   -90,   169,    -1,    27,    -7,   118,   -66,   -89,   -90
+     -89,   -89,   270,   -89,   -89,    58,   -67,   -89,   -89,   -89,
+     -89,   243,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -36,
+     -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,   -89,
+     -89,    98,   -89,   -89,   -89,   -89,   -89,   -89,   199,   198,
+     -66,   -89,   -89,   160,    -8,    91,    -9,   -75,   -63,   -88,
+      95
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
    positive, shift that token.  If negative, reduce the rule which
    number is the opposite.  If zero, do what YYDEFACT says.
    If YYTABLE_NINF, syntax error.  */
-#define YYTABLE_NINF -86
+#define YYTABLE_NINF -88
 static const yytype_int16 yytable[] =
 {
-      10,    88,    89,    54,   146,   147,   119,     1,   122,   164,
-      93,   141,    56,   142,    58,   156,    94,    62,     1,    90,
-      91,   131,    65,    66,   144,   145,    67,    90,    91,   132,
-     127,    68,   136,   -31,    97,     2,   154,   -31,   -31,   -31,
-     -31,   -31,   -31,   -31,   -31,    98,    52,   -31,   -31,    99,
-     -31,   100,   101,   102,   103,   104,   -31,   105,   129,   106,
-     138,   173,    92,   141,   107,   142,   174,   172,     8,     9,
-     143,   -33,    97,    90,    91,   -33,   -33,   -33,   -33,   -33,
-     -33,   -33,   -33,    98,   166,   -33,   -33,    99,   -33,   100,
-     101,   102,   103,   104,   -33,   105,    11,   106,   179,   151,
-     123,   126,   107,   135,   125,   130,     2,   139,     2,    90,
-      91,    -5,    12,    55,   161,    13,    14,    15,    16,    17,
-      18,    19,    20,    65,    66,    21,    22,    23,    24,    25,
-      26,    27,    28,    29,    30,    57,    59,    31,    61,    -4,
-      12,    63,    32,    13,    14,    15,    16,    17,    18,    19,
-      20,    64,    71,    21,    22,    23,    24,    25,    26,    27,
-      28,    29,    30,    72,    73,    31,   180,    90,    91,    52,
-      32,   -85,    97,    82,    83,   -85,   -85,   -85,   -85,   -85,
-     -85,   -85,   -85,    84,   190,   -85,   -85,    99,   -85,   -85,
-     -85,   -85,   -85,   -85,   -85,    85,    97,   106,    86,    87,
-     -52,   -52,   140,   -52,   -52,   -52,   -52,    98,    95,   -52,
-     -52,    99,   114,   115,   116,   117,    96,   148,   149,   150,
-     158,   106,   155,   159,    97,   163,   118,   -76,   -76,   -76,
-     -76,   -76,   -76,   -76,   -76,   160,   164,   -76,   -76,    99,
-      13,    14,    15,    16,    17,    18,    19,    20,    91,   106,
-      21,    22,    14,    15,   140,    17,    18,    19,    20,   168,
-     175,    21,    22,   177,   181,   182,   183,    32,   187,   167,
-     188,   169,   170,   171,   185,   189,    53,    51,    32,   176,
-      75,   178,   121,     0,   133,   162,     0,     0,     0,     0,
-     184
+      55,    56,     1,    58,    59,    91,    92,    63,   150,   151,
+     122,   125,     1,    93,    94,   144,   145,    -4,     7,   160,
+       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
+     148,   149,    18,    19,    20,    21,    22,    23,    24,    25,
+      26,    27,   158,   130,    28,   139,    83,   134,   100,    29,
+     -53,    86,   -53,   -53,   -53,   135,   -53,   -53,   -53,   -53,
+     101,    95,   -53,   -53,   102,   117,   118,   119,   120,   144,
+     145,    96,   177,     6,   109,   168,   178,    97,   146,   121,
+     172,   179,   174,   175,   176,   147,    53,    54,    93,    94,
+     181,   171,   183,    93,    94,   155,    50,    66,    67,    66,
+      67,    68,   190,    52,    60,   184,    69,    57,   -32,   100,
+     165,   -32,   -32,   -32,   -32,   -32,   -32,   -32,   -32,   -32,
+     -32,   101,    62,   -32,   -32,   102,   -32,   103,   104,   105,
+     106,   107,   -32,   108,    64,   109,   126,   129,   170,   138,
+     110,   -34,   100,    65,   -34,   -34,   -34,   -34,   -34,   -34,
+     -34,   -34,   -34,   -34,   101,    72,   -34,   -34,   102,   -34,
+     103,   104,   105,   106,   107,   -34,   108,    73,   109,   128,
+     133,    74,   142,   110,   186,    93,    94,   132,    84,   141,
+      85,   -87,   100,   197,   -87,   -87,   -87,   -87,   -87,   -87,
+     -87,   -87,   -87,   -87,    93,    94,   -87,   -87,   102,   -87,
+     -87,   -87,   -87,   -87,   -87,   -87,    87,    88,   109,    89,
+      90,    98,   100,   143,   -77,   -77,   -77,   -77,   -77,   -77,
+     -77,   -77,   -77,   -77,    99,   152,   -77,   -77,   102,   153,
+     154,   162,   159,   163,   164,   167,   168,    94,   109,   173,
+     185,   180,   182,   143,     8,     9,    10,    11,    12,    13,
+      14,    15,    16,    17,   187,   188,    18,    19,     8,   189,
+      10,    11,    12,   191,    14,    15,    16,    17,   193,   194,
+      18,    19,   196,    29,   198,    51,   124,    76,   136,   166,
+     195,     0,     0,     0,     0,     0,     0,    29
 };
 
 static const yytype_int16 yycheck[] =
 {
-       1,    67,    68,    10,    93,    94,    76,     3,    76,    14,
-      28,    81,    13,    81,    15,   104,    34,    18,     3,    32,
-      33,    23,    26,    27,    90,    91,    30,    32,    33,    31,
-      78,    35,    80,     0,     1,    31,   102,     4,     5,     6,
-       7,     8,     9,    10,    11,    12,    31,    14,    15,    16,
-      17,    18,    19,    20,    21,    22,    23,    24,    78,    26,
-      80,    26,    69,   133,    31,   133,    31,   156,    26,    27,
-      29,     0,     1,    32,    33,     4,     5,     6,     7,     8,
-       9,    10,    11,    12,   150,    14,    15,    16,    17,    18,
-      19,    20,    21,    22,    23,    24,     0,    26,   164,   100,
-      77,    78,    31,    80,    77,    78,    31,    80,    31,    32,
-      33,     0,     1,    31,   115,     4,     5,     6,     7,     8,
-       9,    10,    11,    26,    27,    14,    15,    16,    17,    18,
-      19,    20,    21,    22,    23,    31,    26,    26,    31,     0,
-       1,    26,    31,     4,     5,     6,     7,     8,     9,    10,
-      11,    26,    31,    14,    15,    16,    17,    18,    19,    20,
-      21,    22,    23,     1,     1,    26,    31,    32,    33,    31,
-      31,     0,     1,    31,    31,     4,     5,     6,     7,     8,
-       9,    10,    11,    31,   185,    14,    15,    16,    17,    18,
-      19,    20,    21,    22,    23,    31,     1,    26,    31,    31,
-       5,     6,    31,     8,     9,    10,    11,    12,    31,    14,
-      15,    16,    17,    18,    19,    20,    31,    31,    31,    25,
-       1,    26,    26,    13,     1,    26,    31,     4,     5,     6,
-       7,     8,     9,    10,    11,    31,    14,    14,    15,    16,
-       4,     5,     6,     7,     8,     9,    10,    11,    33,    26,
-      14,    15,     5,     6,    31,     8,     9,    10,    11,    31,
-      31,    14,    15,    31,    31,    31,    31,    31,    31,   151,
-      31,   153,   154,   155,    34,    31,     7,     6,    31,   161,
-      37,   163,    76,    -1,    79,   116,    -1,    -1,    -1,    -1,
-     172
+       8,     9,    32,    11,    12,    68,    69,    15,    96,    97,
+      77,    77,    32,    33,    34,    82,    82,     0,     1,   107,
+       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
+      93,    94,    15,    16,    17,    18,    19,    20,    21,    22,
+      23,    24,   105,    79,    27,    81,    55,    24,     1,    32,
+       3,    59,     5,     6,     7,    32,     9,    10,    11,    12,
+      13,    70,    15,    16,    17,    18,    19,    20,    21,   136,
+     136,    29,   160,     0,    27,    15,    27,    35,    86,    32,
+     155,    32,   157,   158,   159,    30,    27,    28,    33,    34,
+     165,   154,   167,    33,    34,   103,    32,    27,    28,    27,
+      28,    31,   177,    32,    27,   168,    36,    32,     0,     1,
+     118,     3,     4,     5,     6,     7,     8,     9,    10,    11,
+      12,    13,    32,    15,    16,    17,    18,    19,    20,    21,
+      22,    23,    24,    25,    27,    27,    78,    79,   146,    81,
+      32,     0,     1,    27,     3,     4,     5,     6,     7,     8,
+       9,    10,    11,    12,    13,    32,    15,    16,    17,    18,
+      19,    20,    21,    22,    23,    24,    25,     1,    27,    78,
+      79,     1,    81,    32,    32,    33,    34,    79,    32,    81,
+      32,     0,     1,   191,     3,     4,     5,     6,     7,     8,
+       9,    10,    11,    12,    33,    34,    15,    16,    17,    18,
+      19,    20,    21,    22,    23,    24,    32,    32,    27,    32,
+      32,    32,     1,    32,     3,     4,     5,     6,     7,     8,
+       9,    10,    11,    12,    32,    32,    15,    16,    17,    32,
+      26,     1,    27,    14,    32,    27,    15,    34,    27,    32,
+      27,    32,    32,    32,     3,     4,     5,     6,     7,     8,
+       9,    10,    11,    12,    32,    32,    15,    16,     3,    32,
+       5,     6,     7,    35,     9,    10,    11,    12,    32,    32,
+      15,    16,    32,    32,    32,     5,    77,    34,    80,   119,
+     185,    -1,    -1,    -1,    -1,    -1,    -1,    32
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
    symbol of state STATE-NUM.  */
 static const yytype_uint8 yystos[] =
 {
-       0,     3,    31,    37,    38,    39,    63,    81,    26,    27,
-      79,     0,     1,     4,     5,     6,     7,     8,     9,    10,
-      11,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      23,    26,    31,    40,    41,    43,    44,    45,    46,    52,
-      53,    55,    59,    61,    64,    65,    67,    69,    70,    71,
-      80,    39,    31,    38,    81,    31,    79,    31,    79,    26,
-      85,    31,    79,    26,    26,    26,    27,    30,    35,    83,
-      84,    31,     1,     1,    47,    47,    56,    58,    62,    76,
-      68,    74,    31,    31,    31,    31,    31,    31,    83,    83,
-      32,    33,    81,    28,    34,    31,    31,     1,    12,    16,
-      18,    19,    20,    21,    22,    24,    26,    31,    42,    48,
-      49,    72,    73,    75,    17,    18,    19,    20,    31,    42,
-      57,    73,    75,    41,    54,    80,    41,    55,    60,    67,
-      80,    23,    31,    74,    77,    41,    55,    66,    67,    80,
-      31,    42,    75,    29,    83,    83,    84,    84,    31,    31,
-      25,    79,    78,    79,    83,    26,    84,    50,     1,    13,
-      31,    79,    78,    26,    14,    82,    83,    82,    31,    82,
-      82,    82,    84,    26,    31,    31,    82,    31,    82,    83,
-      31,    31,    31,    31,    82,    34,    51,    31,    31,    31,
-      79
+       0,    32,    38,    39,    40,    83,     0,     1,     3,     4,
+       5,     6,     7,     8,     9,    10,    11,    12,    15,    16,
+      17,    18,    19,    20,    21,    22,    23,    24,    27,    32,
+      41,    42,    44,    45,    46,    47,    53,    54,    56,    60,
+      62,    64,    65,    66,    68,    70,    71,    72,    73,    82,
+      32,    39,    32,    27,    28,    81,    81,    32,    81,    81,
+      27,    87,    32,    81,    27,    27,    27,    28,    31,    36,
+      85,    86,    32,     1,     1,    48,    48,    57,    59,    63,
+      78,    69,    76,    83,    32,    32,    81,    32,    32,    32,
+      32,    85,    85,    33,    34,    83,    29,    35,    32,    32,
+       1,    13,    17,    19,    20,    21,    22,    23,    25,    27,
+      32,    43,    49,    50,    74,    75,    77,    18,    19,    20,
+      21,    32,    43,    58,    75,    77,    42,    55,    82,    42,
+      56,    61,    68,    82,    24,    32,    76,    79,    42,    56,
+      67,    68,    82,    32,    43,    77,    81,    30,    85,    85,
+      86,    86,    32,    32,    26,    81,    80,    81,    85,    27,
+      86,    51,     1,    14,    32,    81,    80,    27,    15,    84,
+      81,    85,    84,    32,    84,    84,    84,    86,    27,    32,
+      32,    84,    32,    84,    85,    27,    32,    32,    32,    32,
+      84,    35,    52,    32,    32,    87,    32,    81,    32
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -800,18 +842,9 @@ static const yytype_uint8 yystos[] =
 
 /* Like YYERROR except do call yyerror.  This remains here temporarily
    to ease the transition to the new meaning of YYERROR, for GCC.
-   Once GCC version 2 has supplanted version 1, this can go.  However,
-   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
-   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
-   discussed.  */
+   Once GCC version 2 has supplanted version 1, this can go.  */
 
 #define YYFAIL		goto yyerrlab
-#if defined YYFAIL
-  /* This is here to suppress warnings from the GCC cpp's
-     -Wunused-macros.  Normally we don't worry about that warning, but
-     some users do, and we want to make it easy for users to remove
-     YYFAIL uses, which will produce warnings from Bison 2.5.  */
-#endif
 
 #define YYRECOVERING()  (!!yyerrstatus)
 
@@ -868,7 +901,7 @@ while (YYID (0))
    we won't break user code: when these are the locations we know.  */
 
 #ifndef YY_LOCATION_PRINT
-# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
+# if YYLTYPE_IS_TRIVIAL
 #  define YY_LOCATION_PRINT(File, Loc)			\
      fprintf (File, "%d.%d-%d.%d",			\
 	      (Loc).first_line, (Loc).first_column,	\
@@ -979,20 +1012,17 @@ yy_symbol_print (yyoutput, yytype, yyvaluep)
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 static void
-yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
+yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
 #else
 static void
-yy_stack_print (yybottom, yytop)
-    yytype_int16 *yybottom;
-    yytype_int16 *yytop;
+yy_stack_print (bottom, top)
+    yytype_int16 *bottom;
+    yytype_int16 *top;
 #endif
 {
   YYFPRINTF (stderr, "Stack now");
-  for (; yybottom <= yytop; yybottom++)
-    {
-      int yybot = *yybottom;
-      YYFPRINTF (stderr, " %d", yybot);
-    }
+  for (; bottom <= top; ++bottom)
+    YYFPRINTF (stderr, " %d", *bottom);
   YYFPRINTF (stderr, "\n");
 }
 
@@ -1026,11 +1056,11 @@ yy_reduce_print (yyvsp, yyrule)
   /* The symbols being reduced.  */
   for (yyi = 0; yyi < yynrhs; yyi++)
     {
-      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
+      fprintf (stderr, "   $%d = ", yyi + 1);
       yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
 		       &(yyvsp[(yyi + 1) - (yynrhs)])
 		       		       );
-      YYFPRINTF (stderr, "\n");
+      fprintf (stderr, "\n");
     }
 }
 
@@ -1305,7 +1335,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 
   switch (yytype)
     {
-      case 53: /* "choice_entry" */
+      case 54: /* "choice_entry" */
 
 	{
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
@@ -1315,7 +1345,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 };
 
 	break;
-      case 59: /* "if_entry" */
+      case 60: /* "if_entry" */
 
 	{
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
@@ -1325,7 +1355,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 };
 
 	break;
-      case 65: /* "menu_entry" */
+      case 66: /* "menu_entry" */
 
 	{
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
@@ -1340,8 +1370,10 @@ yydestruct (yymsg, yytype, yyvaluep)
 	break;
     }
 }
+
 
 /* Prevent warnings from -Wmissing-prototypes.  */
+
 #ifdef YYPARSE_PARAM
 #if defined __STDC__ || defined __cplusplus
 int yyparse (void *YYPARSE_PARAM);
@@ -1357,10 +1389,11 @@ int yyparse ();
 #endif /* ! YYPARSE_PARAM */
 
 
-/* The lookahead symbol.  */
+
+/* The look-ahead symbol.  */
 int yychar;
 
-/* The semantic value of the lookahead symbol.  */
+/* The semantic value of the look-ahead symbol.  */
 YYSTYPE yylval;
 
 /* Number of syntax errors so far.  */
@@ -1368,9 +1401,9 @@ int yynerrs;
 
 
 
-/*-------------------------.
-| yyparse or yypush_parse.  |
-`-------------------------*/
+/*----------.
+| yyparse.  |
+`----------*/
 
 #ifdef YYPARSE_PARAM
 #if (defined __STDC__ || defined __C99__FUNC__ \
@@ -1394,68 +1427,66 @@ yyparse ()
 #endif
 #endif
 {
+  
+  int yystate;
+  int yyn;
+  int yyresult;
+  /* Number of tokens to shift before error messages enabled.  */
+  int yyerrstatus;
+  /* Look-ahead token as an internal (translated) token number.  */
+  int yytoken = 0;
+#if YYERROR_VERBOSE
+  /* Buffer for error messages, and its allocated size.  */
+  char yymsgbuf[128];
+  char *yymsg = yymsgbuf;
+  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
+#endif
 
+  /* Three stacks and their tools:
+     `yyss': related to states,
+     `yyvs': related to semantic values,
+     `yyls': related to locations.
 
-    int yystate;
-    /* Number of tokens to shift before error messages enabled.  */
-    int yyerrstatus;
+     Refer to the stacks thru separate pointers, to allow yyoverflow
+     to reallocate them elsewhere.  */
 
-    /* The stacks and their tools:
-       `yyss': related to states.
-       `yyvs': related to semantic values.
+  /* The state stack.  */
+  yytype_int16 yyssa[YYINITDEPTH];
+  yytype_int16 *yyss = yyssa;
+  yytype_int16 *yyssp;
 
-       Refer to the stacks thru separate pointers, to allow yyoverflow
-       to reallocate them elsewhere.  */
+  /* The semantic value stack.  */
+  YYSTYPE yyvsa[YYINITDEPTH];
+  YYSTYPE *yyvs = yyvsa;
+  YYSTYPE *yyvsp;
 
-    /* The state stack.  */
-    yytype_int16 yyssa[YYINITDEPTH];
-    yytype_int16 *yyss;
-    yytype_int16 *yyssp;
 
-    /* The semantic value stack.  */
-    YYSTYPE yyvsa[YYINITDEPTH];
-    YYSTYPE *yyvs;
-    YYSTYPE *yyvsp;
 
-    YYSIZE_T yystacksize;
+#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))
+
+  YYSIZE_T yystacksize = YYINITDEPTH;
 
-  int yyn;
-  int yyresult;
-  /* Lookahead token as an internal (translated) token number.  */
-  int yytoken;
   /* The variables used to return semantic value and location from the
      action routines.  */
   YYSTYPE yyval;
 
-#if YYERROR_VERBOSE
-  /* Buffer for error messages, and its allocated size.  */
-  char yymsgbuf[128];
-  char *yymsg = yymsgbuf;
-  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
-#endif
-
-#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))
 
   /* The number of symbols on the RHS of the reduced rule.
      Keep to zero when no symbol should be popped.  */
   int yylen = 0;
 
-  yytoken = 0;
-  yyss = yyssa;
-  yyvs = yyvsa;
-  yystacksize = YYINITDEPTH;
-
   YYDPRINTF ((stderr, "Starting parse\n"));
 
   yystate = 0;
   yyerrstatus = 0;
   yynerrs = 0;
-  yychar = YYEMPTY; /* Cause a token to be read.  */
+  yychar = YYEMPTY;		/* Cause a token to be read.  */
 
   /* Initialize stack pointers.
      Waste one element of value and location stack
      so that they stay on the same level as the state stack.
      The wasted elements are never initialized.  */
+
   yyssp = yyss;
   yyvsp = yyvs;
 
@@ -1485,6 +1516,7 @@ yyparse ()
 	YYSTYPE *yyvs1 = yyvs;
 	yytype_int16 *yyss1 = yyss;
 
+
 	/* Each stack pointer address is followed by the size of the
 	   data in use in that stack, in bytes.  This used to be a
 	   conditional around just the two extra args, but that might
@@ -1492,6 +1524,7 @@ yyparse ()
 	yyoverflow (YY_("memory exhausted"),
 		    &yyss1, yysize * sizeof (*yyssp),
 		    &yyvs1, yysize * sizeof (*yyvsp),
+
 		    &yystacksize);
 
 	yyss = yyss1;
@@ -1514,8 +1547,9 @@ yyparse ()
 	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
 	if (! yyptr)
 	  goto yyexhaustedlab;
-	YYSTACK_RELOCATE (yyss_alloc, yyss);
-	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
+	YYSTACK_RELOCATE (yyss);
+	YYSTACK_RELOCATE (yyvs);
+
 #  undef YYSTACK_RELOCATE
 	if (yyss1 != yyssa)
 	  YYSTACK_FREE (yyss1);
@@ -1526,6 +1560,7 @@ yyparse ()
       yyssp = yyss + yysize - 1;
       yyvsp = yyvs + yysize - 1;
 
+
       YYDPRINTF ((stderr, "Stack size increased to %lu\n",
 		  (unsigned long int) yystacksize));
 
@@ -1535,9 +1570,6 @@ yyparse ()
 
   YYDPRINTF ((stderr, "Entering state %d\n", yystate));
 
-  if (yystate == YYFINAL)
-    YYACCEPT;
-
   goto yybackup;
 
 /*-----------.
@@ -1546,16 +1578,16 @@ yyparse ()
 yybackup:
 
   /* Do appropriate processing given the current state.  Read a
-     lookahead token if we need one and don't already have one.  */
+     look-ahead token if we need one and don't already have one.  */
 
-  /* First try to decide what to do without reference to lookahead token.  */
+  /* First try to decide what to do without reference to look-ahead token.  */
   yyn = yypact[yystate];
   if (yyn == YYPACT_NINF)
     goto yydefault;
 
-  /* Not known => get a lookahead token if don't already have one.  */
+  /* Not known => get a look-ahead token if don't already have one.  */
 
-  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
+  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
   if (yychar == YYEMPTY)
     {
       YYDPRINTF ((stderr, "Reading a token: "));
@@ -1587,16 +1619,20 @@ yybackup:
       goto yyreduce;
     }
 
+  if (yyn == YYFINAL)
+    YYACCEPT;
+
   /* Count tokens shifted since error; after three, turn off error
      status.  */
   if (yyerrstatus)
     yyerrstatus--;
 
-  /* Shift the lookahead token.  */
+  /* Shift the look-ahead token.  */
   YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
 
-  /* Discard the shifted token.  */
-  yychar = YYEMPTY;
+  /* Discard the shifted token unless it is eof.  */
+  if (yychar != YYEOF)
+    yychar = YYEMPTY;
 
   yystate = yyn;
   *++yyvsp = yylval;
@@ -1635,39 +1671,39 @@ yyreduce:
   YY_REDUCE_PRINT (yyn);
   switch (yyn)
     {
-        case 10:
+        case 9:
 
     { zconf_error("unexpected end statement"); ;}
     break;
 
-  case 11:
+  case 10:
 
     { zconf_error("unknown statement \"%s\"", (yyvsp[(2) - (4)].string)); ;}
     break;
 
-  case 12:
+  case 11:
 
     {
 	zconf_error("unexpected option \"%s\"", kconf_id_strings + (yyvsp[(2) - (4)].id)->name);
 ;}
     break;
 
-  case 13:
+  case 12:
 
     { zconf_error("invalid statement"); ;}
     break;
 
-  case 28:
+  case 29:
 
     { zconf_error("unknown option \"%s\"", (yyvsp[(1) - (3)].string)); ;}
     break;
 
-  case 29:
+  case 30:
 
     { zconf_error("invalid option"); ;}
     break;
 
-  case 30:
+  case 31:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), 0);
@@ -1677,7 +1713,7 @@ yyreduce:
 ;}
     break;
 
-  case 31:
+  case 32:
 
     {
 	menu_end_entry();
@@ -1685,7 +1721,7 @@ yyreduce:
 ;}
     break;
 
-  case 32:
+  case 33:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), 0);
@@ -1695,7 +1731,7 @@ yyreduce:
 ;}
     break;
 
-  case 33:
+  case 34:
 
     {
 	if (current_entry->prompt)
@@ -1707,7 +1743,7 @@ yyreduce:
 ;}
     break;
 
-  case 41:
+  case 42:
 
     {
 	menu_set_type((yyvsp[(1) - (3)].id)->stype);
@@ -1717,7 +1753,7 @@ yyreduce:
 ;}
     break;
 
-  case 42:
+  case 43:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
@@ -1725,7 +1761,7 @@ yyreduce:
 ;}
     break;
 
-  case 43:
+  case 44:
 
     {
 	menu_add_expr(P_DEFAULT, (yyvsp[(2) - (4)].expr), (yyvsp[(3) - (4)].expr));
@@ -1737,7 +1773,7 @@ yyreduce:
 ;}
     break;
 
-  case 44:
+  case 45:
 
     {
 	menu_add_symbol(P_SELECT, sym_lookup((yyvsp[(2) - (4)].string), 0), (yyvsp[(3) - (4)].expr));
@@ -1745,7 +1781,7 @@ yyreduce:
 ;}
     break;
 
-  case 45:
+  case 46:
 
     {
 	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,(yyvsp[(2) - (5)].symbol), (yyvsp[(3) - (5)].symbol)), (yyvsp[(4) - (5)].expr));
@@ -1753,7 +1789,7 @@ yyreduce:
 ;}
     break;
 
-  case 48:
+  case 49:
 
     {
 	const struct kconf_id *id = kconf_id_lookup((yyvsp[(2) - (3)].string), strlen((yyvsp[(2) - (3)].string)));
@@ -1765,17 +1801,17 @@ yyreduce:
 ;}
     break;
 
-  case 49:
+  case 50:
 
     { (yyval.string) = NULL; ;}
     break;
 
-  case 50:
+  case 51:
 
     { (yyval.string) = (yyvsp[(2) - (2)].string); ;}
     break;
 
-  case 51:
+  case 52:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), SYMBOL_CHOICE);
@@ -1786,14 +1822,14 @@ yyreduce:
 ;}
     break;
 
-  case 52:
+  case 53:
 
     {
 	(yyval.menu) = menu_add_menu();
 ;}
     break;
 
-  case 53:
+  case 54:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_CHOICE, T_ENDCHOICE)) {
@@ -1803,7 +1839,7 @@ yyreduce:
 ;}
     break;
 
-  case 61:
+  case 62:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
@@ -1811,7 +1847,7 @@ yyreduce:
 ;}
     break;
 
-  case 62:
+  case 63:
 
     {
 	if ((yyvsp[(1) - (3)].id)->stype == S_BOOLEAN || (yyvsp[(1) - (3)].id)->stype == S_TRISTATE) {
@@ -1824,7 +1860,7 @@ yyreduce:
 ;}
     break;
 
-  case 63:
+  case 64:
 
     {
 	current_entry->sym->flags |= SYMBOL_OPTIONAL;
@@ -1832,7 +1868,7 @@ yyreduce:
 ;}
     break;
 
-  case 64:
+  case 65:
 
     {
 	if ((yyvsp[(1) - (4)].id)->stype == S_UNKNOWN) {
@@ -1844,7 +1880,7 @@ yyreduce:
 ;}
     break;
 
-  case 67:
+  case 68:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:if\n", zconf_curname(), zconf_lineno());
@@ -1854,7 +1890,7 @@ yyreduce:
 ;}
     break;
 
-  case 68:
+  case 69:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_IF, T_ENDIF)) {
@@ -1864,14 +1900,14 @@ yyreduce:
 ;}
     break;
 
-  case 74:
+  case 75:
 
     {
 	menu_add_prompt(P_MENU, (yyvsp[(2) - (3)].string), NULL);
 ;}
     break;
 
-  case 75:
+  case 76:
 
     {
 	menu_add_entry(NULL);
@@ -1880,14 +1916,14 @@ yyreduce:
 ;}
     break;
 
-  case 76:
+  case 77:
 
     {
 	(yyval.menu) = menu_add_menu();
 ;}
     break;
 
-  case 77:
+  case 78:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_MENU, T_ENDMENU)) {
@@ -1897,7 +1933,7 @@ yyreduce:
 ;}
     break;
 
-  case 83:
+  case 84:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:source %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
@@ -1905,7 +1941,17 @@ yyreduce:
 ;}
     break;
 
-  case 84:
+  case 85:
+
+    {
+	if (dosubsource) {
+		printd(DEBUG_PARSE, "%s:%d:subsource %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (8)].string));
+		zconf_nextconf((yyvsp[(2) - (8)].string), (yyvsp[(3) - (8)].string), (yyvsp[(4) - (8)].string), (yyvsp[(5) - (8)].string), (yyvsp[(6) - (8)].string), (yyvsp[(7) - (8)].string));
+	}
+;}
+    break;
+
+  case 86:
 
     {
 	menu_add_entry(NULL);
@@ -1914,14 +1960,14 @@ yyreduce:
 ;}
     break;
 
-  case 85:
+  case 87:
 
     {
 	menu_end_entry();
 ;}
     break;
 
-  case 86:
+  case 88:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:help\n", zconf_curname(), zconf_lineno());
@@ -1929,14 +1975,14 @@ yyreduce:
 ;}
     break;
 
-  case 87:
+  case 89:
 
     {
 	current_entry->help = (yyvsp[(2) - (2)].string);
 ;}
     break;
 
-  case 92:
+  case 94:
 
     {
 	menu_add_dep((yyvsp[(3) - (4)].expr));
@@ -1944,96 +1990,97 @@ yyreduce:
 ;}
     break;
 
-  case 96:
+  case 98:
 
     {
 	menu_add_visibility((yyvsp[(2) - (2)].expr));
 ;}
     break;
 
-  case 98:
+  case 100:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].expr));
 ;}
     break;
 
-  case 101:
+  case 103:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 102:
+  case 104:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 103:
+  case 105:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 106:
+  case 108:
 
     { (yyval.expr) = NULL; ;}
     break;
 
-  case 107:
+  case 109:
 
     { (yyval.expr) = (yyvsp[(2) - (2)].expr); ;}
     break;
 
-  case 108:
+  case 110:
 
     { (yyval.expr) = expr_alloc_symbol((yyvsp[(1) - (1)].symbol)); ;}
     break;
 
-  case 109:
+  case 111:
 
     { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
     break;
 
-  case 110:
+  case 112:
 
     { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
     break;
 
-  case 111:
+  case 113:
 
     { (yyval.expr) = (yyvsp[(2) - (3)].expr); ;}
     break;
 
-  case 112:
+  case 114:
 
     { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[(2) - (2)].expr)); ;}
     break;
 
-  case 113:
+  case 115:
 
     { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
     break;
 
-  case 114:
+  case 116:
 
     { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
     break;
 
-  case 115:
+  case 117:
 
     { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), 0); free((yyvsp[(1) - (1)].string)); ;}
     break;
 
-  case 116:
+  case 118:
 
     { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), SYMBOL_CONST); free((yyvsp[(1) - (1)].string)); ;}
     break;
 
-  case 117:
+  case 119:
 
     { (yyval.string) = NULL; ;}
     break;
 
 
+/* Line 1267 of yacc.c.  */
 
       default: break;
     }
@@ -2045,6 +2092,7 @@ yyreduce:
 
   *++yyvsp = yyval;
 
+
   /* Now `shift' the result of the reduction.  Determine what state
      that goes to, based on the state we popped back to and the rule
      number reduced by.  */
@@ -2109,7 +2157,7 @@ yyerrlab:
 
   if (yyerrstatus == 3)
     {
-      /* If just tried and failed to reuse lookahead token after an
+      /* If just tried and failed to reuse look-ahead token after an
 	 error, discard it.  */
 
       if (yychar <= YYEOF)
@@ -2126,7 +2174,7 @@ yyerrlab:
 	}
     }
 
-  /* Else will try to reuse lookahead token after shifting the error
+  /* Else will try to reuse look-ahead token after shifting the error
      token.  */
   goto yyerrlab1;
 
@@ -2183,6 +2231,9 @@ yyerrlab1:
       YY_STACK_PRINT (yyss, yyssp);
     }
 
+  if (yyn == YYFINAL)
+    YYACCEPT;
+
   *++yyvsp = yylval;
 
 
@@ -2207,7 +2258,7 @@ yyabortlab:
   yyresult = 1;
   goto yyreturn;
 
-#if !defined(yyoverflow) || YYERROR_VERBOSE
+#ifndef yyoverflow
 /*-------------------------------------------------.
 | yyexhaustedlab -- memory exhaustion comes here.  |
 `-------------------------------------------------*/
@@ -2218,7 +2269,7 @@ yyexhaustedlab:
 #endif
 
 yyreturn:
-  if (yychar != YYEMPTY)
+  if (yychar != YYEOF && yychar != YYEMPTY)
      yydestruct ("Cleanup: discarding lookahead",
 		 yytoken, &yylval);
   /* Do not reclaim the symbols of the rule which action triggered
@@ -2278,8 +2329,10 @@ void conf_parse(const char *name)
 
 	menu_finalize(&rootmenu);
 	for_all_symbols(i, sym) {
-		if (sym_check_deps(sym))
+		if (sym_check_deps(sym)) {
+			fprintf(stderr, "Cannot check dependencies for %s\n", sym->name ? sym->name : "<null>");
 			zconfnerrs++;
+		}
         }
 	if (zconfnerrs)
 		exit(1);
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 864da07..4c39a73 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -19,7 +19,8 @@
 #define DEBUG_PARSE	0x0002
 
 int cdebug = PRINTD;
-
+int dosubsource = 0;
+ 
 extern int zconflex(void);
 static void zconfprint(const char *err, ...);
 static void zconf_error(const char *err, ...);
@@ -29,6 +30,8 @@ static bool zconf_endtoken(const struct kconf_id *id, int starttoken, int endtok
 struct symbol *symbol_hash[SYMBOL_HASHSIZE];
 
 static struct menu *current_menu, *current_entry;
+struct conf_level *current_conf_level = 0;
+struct conf_level *conf_levels = 0;
 
 %}
 %expect 30
@@ -47,6 +50,7 @@ static struct menu *current_menu, *current_entry;
 %token <id>T_MENU
 %token <id>T_ENDMENU
 %token <id>T_SOURCE
+%token <id>T_SUBSOURCE
 %token <id>T_CHOICE
 %token <id>T_ENDCHOICE
 %token <id>T_COMMENT
@@ -102,7 +106,7 @@ static struct menu *current_menu, *current_entry;
 %%
 input: nl start | start;
 
-start: mainmenu_stmt stmt_list | stmt_list;
+start: stmt_list;
 
 stmt_list:
 	  /* empty */
@@ -125,10 +129,12 @@ option_name:
 common_stmt:
 	  T_EOL
 	| if_stmt
+	| mainmenu_stmt 
 	| comment_stmt
 	| config_stmt
 	| menuconfig_stmt
 	| source_stmt
+	| subsource_stmt
 ;
 
 option_error:
@@ -384,6 +390,15 @@ source_stmt: T_SOURCE prompt T_EOL
 	zconf_nextfile($2);
 };
 
+/* subsource $2:"sub-kconfig" $3:"sub-chdir" $4:"sub-.config" $5:"Title" $6:"subdomainprefix" $7:"confprefix" */
+subsource_stmt: T_SUBSOURCE prompt prompt prompt prompt T_WORD word_opt T_EOL
+{
+	if (dosubsource) {
+		printd(DEBUG_PARSE, "%s:%d:subsource %s\n", zconf_curname(), zconf_lineno(), $2);
+		zconf_nextconf($2, $3, $4, $5, $6, $7);
+	}
+}
+
 /* comment entry */
 
 comment: T_COMMENT prompt T_EOL
@@ -515,8 +530,10 @@ void conf_parse(const char *name)
 
 	menu_finalize(&rootmenu);
 	for_all_symbols(i, sym) {
-		if (sym_check_deps(sym))
+		if (sym_check_deps(sym)) {
+			fprintf(stderr, "Cannot check dependencies for %s\n", sym->name ? sym->name : "<null>");
 			zconfnerrs++;
+		}
         }
 	if (zconfnerrs)
 		exit(1);
-- 
1.6.4.1

