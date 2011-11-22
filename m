Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1KVOLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:11:39 -0500
Received: from mail176c2.megamailservers.com ([69.49.111.76]:57464 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab1KVOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:11:36 -0500
X-Authenticated-User: konrad.gaisler.com
From: Konrad Eisele <konrad@gaisler.com>
To: linux-kernel@vger.kernel.org
Cc: lacombar@gmail.com, mmarek@suse.cz, yann.morin.1998@anciens.enib.fr,
        linux-config@vger.kernel.org, konrad@gaisler.com
Subject: [PATCH 1/3] kconfig: Move global elements into struct, create root context
Date: Tue, 22 Nov 2011 15:03:44 +0100
Message-Id: <1321970626-12615-2-git-send-email-konrad@gaisler.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
References: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
X-CSC: 0
X-CHA: v=1.1 cv=vjffymXyDtjo34N5cbiAavWp8ckkCSHNaVzdIDazEXU= c=1 sm=1
		a=lT3H8TPJ4rMA:10 a=U62ajLuCel8A:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=ebG-ZW-8AAAA:8 a=usL8JYEc6VmhlQKdcVsA:9 a=0xqj8HX7LUbe9gYb104A:7
		a=cCYF7-FHeg4A:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move modules_sym, symbol_hash, sym_defconfig_list, sym_env_list into a
structure instead of beeing global. Create a root context called &rootlevel
to be used as default by the config frontends.

Signed-off-by: Konrad Eisele <konrad@gaisler.com>
---
 scripts/kconfig/conf.c      |   30 +++++-----
 scripts/kconfig/confdata.c  |  103 ++++++++++++++++++++------------
 scripts/kconfig/expr.h      |   23 ++++++-
 scripts/kconfig/gconf.c     |    8 +-
 scripts/kconfig/lkc.h       |   12 ++--
 scripts/kconfig/lkc_proto.h |   20 ++++---
 scripts/kconfig/mconf.c     |    8 +-
 scripts/kconfig/menu.c      |   10 ++--
 scripts/kconfig/nconf.c     |    8 +-
 scripts/kconfig/qconf.cc    |    6 +-
 scripts/kconfig/symbol.c    |  140 ++++++++++++++++++++++++++-----------------
 scripts/kconfig/util.c      |    8 +-
 scripts/kconfig/zconf.l     |    4 +-
 scripts/kconfig/zconf.y     |   49 ++++++++-------
 14 files changed, 255 insertions(+), 174 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index f208f90..4307427 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -553,7 +553,7 @@ int main(int ac, char **av)
 	case defconfig:
 		if (!defconfig_file)
 			defconfig_file = conf_get_default_confname();
-		if (conf_read(defconfig_file)) {
+		if (conf_read(defconfig_file, &rootlevel)) {
 			printf(_("***\n"
 				"*** Can't find default configuration \"%s\"!\n"
 				"***\n"), defconfig_file);
@@ -566,7 +566,7 @@ int main(int ac, char **av)
 	case oldconfig:
 	case listnewconfig:
 	case oldnoconfig:
-		conf_read(NULL);
+		conf_read(NULL, &rootlevel);
 		break;
 	case allnoconfig:
 	case allyesconfig:
@@ -575,7 +575,7 @@ int main(int ac, char **av)
 	case randconfig:
 		name = getenv("KCONFIG_ALLCONFIG");
 		if (name && !stat(name, &tmpstat)) {
-			conf_read_simple(name, S_DEF_USER);
+			conf_read_simple(name, S_DEF_USER, &rootlevel);
 			break;
 		}
 		switch (input_mode) {
@@ -587,9 +587,9 @@ int main(int ac, char **av)
 		default: break;
 		}
 		if (!stat(name, &tmpstat))
-			conf_read_simple(name, S_DEF_USER);
+			conf_read_simple(name, S_DEF_USER, &rootlevel);
 		else if (!stat("all.config", &tmpstat))
-			conf_read_simple("all.config", S_DEF_USER);
+			conf_read_simple("all.config", S_DEF_USER, &rootlevel);
 		break;
 	default:
 		break;
@@ -609,22 +609,22 @@ int main(int ac, char **av)
 
 	switch (input_mode) {
 	case allnoconfig:
-		conf_set_all_new_symbols(def_no);
+		conf_set_all_new_symbols(def_no, &rootlevel);
 		break;
 	case allyesconfig:
-		conf_set_all_new_symbols(def_yes);
+		conf_set_all_new_symbols(def_yes, &rootlevel);
 		break;
 	case allmodconfig:
-		conf_set_all_new_symbols(def_mod);
+		conf_set_all_new_symbols(def_mod, &rootlevel);
 		break;
 	case alldefconfig:
-		conf_set_all_new_symbols(def_default);
+		conf_set_all_new_symbols(def_default, &rootlevel);
 		break;
 	case randconfig:
-		conf_set_all_new_symbols(def_random);
+		conf_set_all_new_symbols(def_random, &rootlevel);
 		break;
 	case defconfig:
-		conf_set_all_new_symbols(def_default);
+		conf_set_all_new_symbols(def_default, &rootlevel);
 		break;
 	case savedefconfig:
 		break;
@@ -651,22 +651,22 @@ int main(int ac, char **av)
 		/* silentoldconfig is used during the build so we shall update autoconf.
 		 * All other commands are only used to generate a config.
 		 */
-		if (conf_get_changed() && conf_write(NULL)) {
+		if (conf_get_changed() && conf_write(NULL, &rootlevel)) {
 			fprintf(stderr, _("\n*** Error during writing of the configuration.\n\n"));
 			exit(1);
 		}
-		if (conf_write_autoconf()) {
+		if (conf_write_autoconf(&rootlevel)) {
 			fprintf(stderr, _("\n*** Error during update of the configuration.\n\n"));
 			return 1;
 		}
 	} else if (input_mode == savedefconfig) {
-		if (conf_write_defconfig(defconfig_file)) {
+		if (conf_write_defconfig(defconfig_file, &rootlevel)) {
 			fprintf(stderr, _("n*** Error while saving defconfig to: %s\n\n"),
 			        defconfig_file);
 			return 1;
 		}
 	} else if (input_mode != listnewconfig) {
-		if (conf_write(NULL)) {
+		if (conf_write(NULL, &rootlevel)) {
 			fprintf(stderr, _("\n*** Error during writing of the configuration.\n\n"));
 			exit(1);
 		}
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 5a58965..25c29c8 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -75,7 +75,7 @@ const char *conf_get_autoconfig_name(void)
 	return name ? name : "include/config/auto.conf";
 }
 
-static char *conf_expand_value(const char *in)
+static char *conf_expand_value(const char *in, struct conf_level *l)
 {
 	struct symbol *sym;
 	const char *src;
@@ -91,7 +91,7 @@ static char *conf_expand_value(const char *in)
 		while (isalnum(*src) || *src == '_')
 			*dst++ = *src++;
 		*dst = 0;
-		sym = sym_lookup(name, 0);
+		sym = sym_lookup(name, 0, l);
 		sym_calc_value(sym);
 		strcat(res_value, sym_get_string_value(sym));
 		in = src;
@@ -107,7 +107,7 @@ char *conf_get_default_confname(void)
 	static char fullname[PATH_MAX+1];
 	char *env, *name;
 
-	name = conf_expand_value(conf_defname);
+	name = conf_expand_value(conf_defname, &rootlevel);
 	env = getenv(SRCTREE);
 	if (env) {
 		sprintf(fullname, "%s/%s", env, name);
@@ -182,7 +182,7 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 	return 0;
 }
 
-int conf_read_simple(const char *name, int def)
+int conf_read_simple(const char *name, int def, struct conf_level *l)
 {
 	FILE *in = NULL;
 	char line[1024];
@@ -200,17 +200,17 @@ int conf_read_simple(const char *name, int def)
 		if (in)
 			goto load;
 		sym_add_change_count(1);
-		if (!sym_defconfig_list) {
-			if (modules_sym)
-				sym_calc_value(modules_sym);
+		if (!l->sym_defconfig_list) {
+			if (l->modules_sym)
+				sym_calc_value(l->modules_sym);
 			return 1;
 		}
 
-		for_all_defaults(sym_defconfig_list, prop) {
+		for_all_defaults(l->sym_defconfig_list, prop) {
 			if (expr_calc_value(prop->visible.expr) == no ||
 			    prop->expr->type != E_SYMBOL)
 				continue;
-			name = conf_expand_value(prop->expr->left.sym->name);
+			name = conf_expand_value(prop->expr->left.sym->name, l);
 			in = zconf_fopen(name);
 			if (in) {
 				conf_message(_("using defaults found in %s"),
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
+			if (memcmp(line + 2, l->conf_prefix, strlen(l->conf_prefix)))
 				continue;
 			p = strchr(line + 2 + strlen(CONFIG_), ' ');
 			if (!p)
@@ -260,13 +260,13 @@ load:
 			if (strncmp(p, "is not set", 10))
 				continue;
 			if (def == S_DEF_USER) {
-				sym = sym_find(line + 2 + strlen(CONFIG_));
+				sym = sym_find(line + 2 + strlen(l->conf_prefix), l);
 				if (!sym) {
 					sym_add_change_count(1);
 					goto setsym;
 				}
 			} else {
-				sym = sym_lookup(line + 2 + strlen(CONFIG_), 0);
+				sym = sym_lookup(line + 2 + strlen(l->conf_prefix), 0, l);
 				if (sym->type == S_UNKNOWN)
 					sym->type = S_BOOLEAN;
 			}
@@ -282,7 +282,7 @@ load:
 			default:
 				;
 			}
-		} else if (memcmp(line, CONFIG_, strlen(CONFIG_)) == 0) {
+		} else if (memcmp(line, l->conf_prefix, strlen(l->conf_prefix)) == 0) {
 			p = strchr(line + strlen(CONFIG_), '=');
 			if (!p)
 				continue;
@@ -294,13 +294,13 @@ load:
 					*p2 = 0;
 			}
 			if (def == S_DEF_USER) {
-				sym = sym_find(line + strlen(CONFIG_));
+				sym = sym_find(line + strlen(l->conf_prefix), l);
 				if (!sym) {
 					sym_add_change_count(1);
 					goto setsym;
 				}
 			} else {
-				sym = sym_lookup(line + strlen(CONFIG_), 0);
+				sym = sym_lookup(line + strlen(l->conf_prefix), 0, l);
 				if (sym->type == S_UNKNOWN)
 					sym->type = S_OTHER;
 			}
@@ -337,12 +337,12 @@ setsym:
 	}
 	fclose(in);
 
-	if (modules_sym)
-		sym_calc_value(modules_sym);
+	if (l->modules_sym)
+		sym_calc_value(l->modules_sym);
 	return 0;
 }
 
-int conf_read(const char *name)
+int conf_read(const char *name, struct conf_level *l)
 {
 	struct symbol *sym, *choice_sym;
 	struct property *prop;
@@ -351,10 +351,10 @@ int conf_read(const char *name)
 
 	sym_set_change_count(0);
 
-	if (conf_read_simple(name, S_DEF_USER))
+	if (conf_read_simple(name, S_DEF_USER, l))
 		return 1;
 
-	for_all_symbols(i, sym) {
+	for_all_symbols_level(i, sym, l) {
 		sym_calc_value(sym);
 		if (sym_is_choice(sym) || (sym->flags & SYMBOL_AUTO))
 			goto sym_ok;
@@ -392,7 +392,7 @@ int conf_read(const char *name)
 		sym->flags &= flags | ~SYMBOL_DEF_USER;
 	}
 
-	for_all_symbols(i, sym) {
+	for_all_symbols_level(i, sym, l) {
 		if (sym_has_value(sym) && !sym_is_choice_value(sym)) {
 			/* Reset values of generates values, so they'll appear
 			 * as new, if they should become visible, but that
@@ -422,6 +422,19 @@ int conf_read(const char *name)
 	return 0;
 }
 
+int conf_read_all(const char *name) {
+	int r = 0;
+	struct conf_level *l;
+	if ((l = conf_levels)
+	    && !(r = conf_read(name, l))) {
+		while ((l = l->n)) {
+			if ((r = conf_read(l->conf, l)))
+				break;
+		}
+	}
+	return r;
+}
+
 /*
  * Kconfig configuration printer
  *
@@ -640,7 +653,7 @@ conf_write_heading(FILE *fp, struct conf_printer *printer, void *printer_arg)
  * Write out a minimal config.
  * All values that has default values are skipped as this is redundant.
  */
-int conf_write_defconfig(const char *filename)
+int conf_write_defconfig(const char *filename, struct conf_level *l)
 {
 	struct symbol *sym;
 	struct menu *menu;
@@ -650,7 +663,7 @@ int conf_write_defconfig(const char *filename)
 	if (!out)
 		return 1;
 
-	sym_clear_all_valid();
+	sym_clear_all_valid(l);
 
 	/* Traverse all menus to find all relevant symbols */
 	menu = rootmenu.list;
@@ -713,7 +726,7 @@ next_menu:
 	return 0;
 }
 
-int conf_write(const char *name)
+int conf_write(const char *name, struct conf_level *l)
 {
 	FILE *out;
 	struct symbol *sym;
@@ -760,7 +773,7 @@ int conf_write(const char *name)
 	conf_write_heading(out, &kconfig_printer_cb, NULL);
 
 	if (!conf_get_changed())
-		sym_clear_all_valid();
+		sym_clear_all_valid(l);
 
 	menu = rootmenu.list;
 	while (menu) {
@@ -813,7 +826,21 @@ next:
 	return 0;
 }
 
-static int conf_split_config(void)
+int conf_write_all(const char *name) {
+	int r = 0;
+	struct conf_level *l;
+	if ((l = conf_levels)
+	    && !(r = conf_write(name, l))) {
+		while ((l = l->n)) {
+			if ((r = conf_write(l->conf, l)))
+				break;
+		}
+	}
+	return r;
+}
+
+
+static int conf_split_config(struct conf_level *l)
 {
 	const char *name;
 	char path[PATH_MAX+1];
@@ -823,13 +850,13 @@ static int conf_split_config(void)
 	int res, i, fd;
 
 	name = conf_get_autoconfig_name();
-	conf_read_simple(name, S_DEF_AUTO);
+	conf_read_simple(name, S_DEF_AUTO, l);
 
 	if (chdir("include/config"))
 		return 1;
 
 	res = 0;
-	for_all_symbols(i, sym) {
+	for_all_symbols_level(i, sym, l) {
 		sym_calc_value(sym);
 		if ((sym->flags & SYMBOL_AUTO) || !sym->name)
 			continue;
@@ -925,18 +952,18 @@ out:
 	return res;
 }
 
-int conf_write_autoconf(void)
+int conf_write_autoconf(struct conf_level *l)
 {
 	struct symbol *sym;
 	const char *name;
 	FILE *out, *tristate, *out_h;
 	int i;
 
-	sym_clear_all_valid();
+	sym_clear_all_valid(l);
 
-	file_write_dep("include/config/auto.conf.cmd");
+	file_write_dep("include/config/auto.conf.cmd", l);
 
-	if (conf_split_config())
+	if (conf_split_config(l))
 		return 1;
 
 	out = fopen(".tmpconfig", "w");
@@ -962,7 +989,7 @@ int conf_write_autoconf(void)
 
 	conf_write_heading(out_h, &header_printer_cb, NULL);
 
-	for_all_symbols(i, sym) {
+	for_all_symbols_level(i, sym, l) {
 		if (!sym->name)
 			continue;
 
@@ -1094,12 +1121,12 @@ static void set_all_choice_values(struct symbol *csym)
 	csym->flags &= ~(SYMBOL_VALID);
 }
 
-void conf_set_all_new_symbols(enum conf_def_mode mode)
+void conf_set_all_new_symbols(enum conf_def_mode mode, struct conf_level *l)
 {
 	struct symbol *sym, *csym;
 	int i, cnt;
 
-	for_all_symbols(i, sym) {
+	for_all_symbols_level(i, sym, l) {
 		if (sym_has_value(sym))
 			continue;
 		switch (sym_get_type(sym)) {
@@ -1131,7 +1158,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 
 	}
 
-	sym_clear_all_valid();
+	sym_clear_all_valid(l);
 
 	/*
 	 * We have different type of choice blocks.
@@ -1142,7 +1169,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 	 * selected in a choice block and we set it to yes,
 	 * and the rest to no.
 	 */
-	for_all_symbols(i, csym) {
+	for_all_symbols_level(i, csym, l) {
 		if (sym_has_value(csym) || !sym_is_choice(csym))
 			continue;
 
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 80fce57..12ac5bc 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -15,6 +15,10 @@ extern "C" {
 #include <stdbool.h>
 #endif
 
+struct conf_level;
+extern struct conf_level *conf_levels;
+extern struct conf_level *current_conf_level;
+
 struct file {
 	struct file *next;
 	struct file *parent;
@@ -81,9 +85,10 @@ struct symbol {
 	struct property *prop;
 	struct expr_value dir_dep;
 	struct expr_value rev_dep;
+	struct conf_level *level;
 };
 
-#define for_all_symbols(i, sym) for (i = 0; i < SYMBOL_HASHSIZE; i++) for (sym = symbol_hash[i]; sym; sym = sym->next) if (sym->type != S_OTHER)
+#define for_all_symbols_level(i, sym, l) for (i = 0; i < SYMBOL_HASHSIZE; i++) for (sym = l->symbol_hash[i]; sym; sym = sym->next) if (sym->type != S_OTHER)
 
 #define SYMBOL_CONST      0x0001  /* symbol is const */
 #define SYMBOL_CHECK      0x0008  /* used during dependency checking */
@@ -172,13 +177,25 @@ struct menu {
 #define MENU_CHANGED		0x0001
 #define MENU_ROOT		0x0002
 
+struct conf_level {
+        struct conf_level *n;
+	struct conf_level *parent;
+	char *conf;
+	char *conf_prefix;
+	char *cwd;
+	struct symbol *symbol_hash[SYMBOL_HASHSIZE];
+	struct symbol *modules_sym;
+	tristate modules_val;
+	struct symbol *sym_defconfig_list;
+	struct expr *sym_env_list;
+};
+extern struct conf_level rootlevel;
+
 extern struct file *file_list;
 extern struct file *current_file;
 struct file *lookup_file(const char *name);
 
 extern struct symbol symbol_yes, symbol_no, symbol_mod;
-extern struct symbol *modules_sym;
-extern struct symbol *sym_defconfig_list;
 extern int cdebug;
 struct expr *expr_alloc_symbol(struct symbol *sym);
 struct expr *expr_alloc_one(enum expr_type type, struct expr *ce);
diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 9f44380..39dd257 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -519,7 +519,7 @@ load_filename(GtkFileSelection * file_selector, gpointer user_data)
 	fn = gtk_file_selection_get_filename(GTK_FILE_SELECTION
 					     (user_data));
 
-	if (conf_read(fn))
+	if (conf_read(fn, &rootlevel))
 		text_insert_msg(_("Error"), _("Unable to load configuration !"));
 	else
 		display_tree(&rootmenu);
@@ -547,7 +547,7 @@ void on_load1_activate(GtkMenuItem * menuitem, gpointer user_data)
 
 void on_save_activate(GtkMenuItem * menuitem, gpointer user_data)
 {
-	if (conf_write(NULL))
+	if (conf_write(NULL, &rootlevel))
 		text_insert_msg(_("Error"), _("Unable to save configuration !"));
 }
 
@@ -560,7 +560,7 @@ store_filename(GtkFileSelection * file_selector, gpointer user_data)
 	fn = gtk_file_selection_get_filename(GTK_FILE_SELECTION
 					     (user_data));
 
-	if (conf_write(fn))
+	if (conf_write(fn, &rootlevel))
 		text_insert_msg(_("Error"), _("Unable to save configuration !"));
 
 	gtk_widget_destroy(GTK_WIDGET(user_data));
@@ -1512,7 +1512,7 @@ int main(int ac, char *av[])
 
 	conf_parse(name);
 	fixup_rootmenu(&rootmenu);
-	conf_read(NULL);
+	conf_read(NULL, &rootlevel);
 
 	/* Load the interface and connect signals */
 	init_main_window(glade_file);
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index b633bdb..689efd6 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -80,7 +80,7 @@ const char *conf_get_autoconfig_name(void);
 char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
-void conf_set_all_new_symbols(enum conf_def_mode mode);
+void conf_set_all_new_symbols(enum conf_def_mode mode, struct conf_level *l);
 
 struct conf_printer {
 	void (*print_symbol)(FILE *, struct symbol *, const char *, void *);
@@ -112,8 +112,8 @@ void menu_finalize(struct menu *parent);
 void menu_set_type(int type);
 
 /* util.c */
-struct file *file_lookup(const char *name);
-int file_write_dep(const char *name);
+struct file *file_lookup(const char *name, struct conf_level *l);
+int file_write_dep(const char *name, struct conf_level *l);
 
 struct gstr {
 	size_t len;
@@ -134,9 +134,9 @@ const char *str_get(struct gstr *gs);
 /* symbol.c */
 extern struct expr *sym_env_list;
 
-void sym_init(void);
-void sym_clear_all_valid(void);
-void sym_set_all_changed(void);
+void sym_init(struct conf_level *l);
+void sym_clear_all_valid(struct conf_level *l);
+void sym_set_all_changed(struct conf_level *l);
 void sym_set_changed(struct symbol *sym);
 struct symbol *sym_choice_default(struct symbol *sym);
 const char *sym_get_string_default(struct symbol *sym);
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 47fe9c3..749d78a 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -2,11 +2,13 @@
 
 /* confdata.c */
 P(conf_parse,void,(const char *name));
-P(conf_read,int,(const char *name));
-P(conf_read_simple,int,(const char *name, int));
-P(conf_write_defconfig,int,(const char *name));
-P(conf_write,int,(const char *name));
-P(conf_write_autoconf,int,(void));
+P(conf_read_all,int,(const char *name));
+P(conf_read,int,(const char *name,struct conf_level *l));
+P(conf_read_simple,int,(const char *name, int,struct conf_level *l));
+P(conf_write_defconfig,int,(const char *name, struct conf_level *l));
+P(conf_write,int,(const char *name, struct conf_level *l));
+P(conf_write_all,int,(const char *name));
+P(conf_write_autoconf,int,(struct conf_level *l));
 P(conf_get_changed,bool,(void));
 P(conf_set_changed_callback, void,(void (*fn)(void)));
 P(conf_set_message_callback, void,(void (*fn)(const char *fmt, va_list ap)));
@@ -28,9 +30,9 @@ P(menu_get_ext_help,void,(struct menu *menu, struct gstr *help));
 /* symbol.c */
 P(symbol_hash,struct symbol *,[SYMBOL_HASHSIZE]);
 
-P(sym_lookup,struct symbol *,(const char *name, int flags));
-P(sym_find,struct symbol *,(const char *name));
-P(sym_expand_string_value,const char *,(const char *in));
+P(sym_lookup,struct symbol *,(const char *name, int flags, struct conf_level *l));
+P(sym_find,struct symbol *,(const char *name, struct conf_level *l));
+P(sym_expand_string_value,const char *,(const char *in, struct conf_level *l));
 P(sym_escape_string_value, const char *,(const char *in));
 P(sym_re_search,struct symbol **,(const char *pattern));
 P(sym_type_name,const char *,(enum symbol_type type));
@@ -48,6 +50,8 @@ P(sym_get_default_prop,struct property *,(struct symbol *sym));
 P(sym_get_string_value,const char *,(struct symbol *sym));
 
 P(prop_get_type_name,const char *,(enum prop_type type));
+P(sym_level_open,void,(struct conf_level *l));
+P(sym_level_close,void,(struct conf_level *l));
 
 /* expr.c */
 P(expr_compare_type,int,(enum expr_type t1, enum expr_type t2));
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 19e200d..e6abbde 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -752,7 +752,7 @@ static void conf_load(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			if (!conf_read(dialog_input_result)) {
+			if (!conf_read(dialog_input_result, &rootlevel)) {
 				set_config_filename(dialog_input_result);
 				sym_set_change_count(1);
 				return;
@@ -779,7 +779,7 @@ static void conf_save(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			if (!conf_write(dialog_input_result)) {
+			if (!conf_write(dialog_input_result, &rootlevel)) {
 				set_config_filename(dialog_input_result);
 				return;
 			}
@@ -811,7 +811,7 @@ static int handle_exit(void)
 
 	switch (res) {
 	case 0:
-		if (conf_write(filename)) {
+		if (conf_write(filename, &rootlevel)) {
 			fprintf(stderr, _("\n\n"
 					  "Error while writing of the configuration.\n"
 					  "Your configuration changes were NOT saved."
@@ -852,7 +852,7 @@ int main(int ac, char **av)
 	signal(SIGINT, sig_handler);
 
 	conf_parse(av[1]);
-	conf_read(NULL);
+	conf_read(NULL, &rootlevel);
 
 	mode = getenv("MENUCONFIG_MODE");
 	if (mode) {
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 8c2a97e..9977819 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -96,7 +96,7 @@ static struct expr *menu_check_dep(struct expr *e)
 	case E_SYMBOL:
 		/* change 'm' into 'm' && MODULES */
 		if (e->left.sym == &symbol_mod)
-			return expr_alloc_and(e, expr_alloc_symbol(modules_sym));
+			return expr_alloc_and(e, expr_alloc_symbol(current_conf_level->modules_sym));
 		break;
 	default:
 		break;
@@ -188,13 +188,13 @@ void menu_add_option(int token, char *arg)
 
 	switch (token) {
 	case T_OPT_MODULES:
-		prop = prop_alloc(P_DEFAULT, modules_sym);
+		prop = prop_alloc(P_DEFAULT, current_conf_level->modules_sym);
 		prop->expr = expr_alloc_symbol(current_entry->sym);
 		break;
 	case T_OPT_DEFCONFIG_LIST:
-		if (!sym_defconfig_list)
-			sym_defconfig_list = current_entry->sym;
-		else if (sym_defconfig_list != current_entry->sym)
+		if (!current_conf_level->sym_defconfig_list)
+			current_conf_level->sym_defconfig_list = current_entry->sym;
+		else if (current_conf_level->sym_defconfig_list != current_entry->sym)
 			zconf_error("trying to redefine defconfig symbol");
 		break;
 	case T_OPT_ENV:
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 73070cb..d839bda 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -670,7 +670,7 @@ static int do_exit(void)
 	/* if we got here, the user really wants to exit */
 	switch (res) {
 	case 0:
-		res = conf_write(filename);
+		res = conf_write(filename, &rootlevel);
 		if (res)
 			btn_dialog(
 				main_window,
@@ -1402,7 +1402,7 @@ static void conf_load(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			if (!conf_read(dialog_input_result)) {
+			if (!conf_read(dialog_input_result, &rootlevel)) {
 				set_config_filename(dialog_input_result);
 				sym_set_change_count(1);
 				return;
@@ -1433,7 +1433,7 @@ static void conf_save(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			res = conf_write(dialog_input_result);
+			res = conf_write(dialog_input_result, &rootlevel);
 			if (!res) {
 				set_config_filename(dialog_input_result);
 				return;
@@ -1477,7 +1477,7 @@ int main(int ac, char **av)
 	textdomain(PACKAGE);
 
 	conf_parse(av[1]);
-	conf_read(NULL);
+	conf_read(NULL, &rootlevel);
 
 	mode = getenv("NCONFIG_MODE");
 	if (mode) {
diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index df274fe..e8e26c0 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1473,14 +1473,14 @@ void ConfigMainWindow::loadConfig(void)
 	QString s = Q3FileDialog::getOpenFileName(conf_get_configname(), NULL, this);
 	if (s.isNull())
 		return;
-	if (conf_read(QFile::encodeName(s)))
+	if (conf_read(QFile::encodeName(s), &rootlevel))
 		QMessageBox::information(this, "qconf", _("Unable to load configuration!"));
 	ConfigView::updateListAll();
 }
 
 bool ConfigMainWindow::saveConfig(void)
 {
-	if (conf_write(NULL)) {
+	if (conf_write(NULL, &rootlevel)) {
 		QMessageBox::information(this, "qconf", _("Unable to save configuration!"));
 		return false;
 	}
@@ -1768,7 +1768,7 @@ int main(int ac, char** av)
 
 	conf_parse(name);
 	fixup_rootmenu(&rootmenu);
-	conf_read(NULL);
+	conf_read(NULL, &rootlevel);
 	//zconfdump(stdout);
 
 	configSettings = new ConfigSettings();
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 071f00c..6999c8d 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -29,32 +29,23 @@ struct symbol symbol_yes = {
 	.flags = SYMBOL_VALID,
 };
 
-struct symbol *sym_defconfig_list;
-struct symbol *modules_sym;
 tristate modules_val;
-
-struct expr *sym_env_list;
+struct conf_level rootlevel;
 
 static void sym_add_default(struct symbol *sym, const char *def)
 {
 	struct property *prop = prop_alloc(P_DEFAULT, sym);
 
-	prop->expr = expr_alloc_symbol(sym_lookup(def, SYMBOL_CONST));
+	prop->expr = expr_alloc_symbol(sym_lookup(def, SYMBOL_CONST, sym->level));
 }
 
-void sym_init(void)
+void sym_init(struct conf_level *l)
 {
 	struct symbol *sym;
 	struct utsname uts;
-	static bool inited = false;
-
-	if (inited)
-		return;
-	inited = true;
-
 	uname(&uts);
 
-	sym = sym_lookup("UNAME_RELEASE", 0);
+	sym = sym_lookup("UNAME_RELEASE", 0, l);
 	sym->type = S_STRING;
 	sym->flags |= SYMBOL_AUTO;
 	sym_add_default(sym, uts.release);
@@ -397,9 +388,9 @@ void sym_calc_value(struct symbol *sym)
 
 	if (memcmp(&oldval, &sym->curr, sizeof(oldval))) {
 		sym_set_changed(sym);
-		if (modules_sym == sym) {
-			sym_set_all_changed();
-			modules_val = modules_sym->curr.tri;
+		if (sym->level && sym->level->modules_sym == sym) {
+			sym_set_all_changed(sym->level);
+			modules_val = sym->level->modules_sym->curr.tri;
 		}
 	}
 
@@ -420,16 +411,20 @@ void sym_calc_value(struct symbol *sym)
 		sym->flags &= ~SYMBOL_WRITE;
 }
 
-void sym_clear_all_valid(void)
+void sym_clear_all_valid(struct conf_level *l)
 {
 	struct symbol *sym;
 	int i;
 
-	for_all_symbols(i, sym)
+	for_all_symbols_level(i, sym, l)
 		sym->flags &= ~SYMBOL_VALID;
 	sym_add_change_count(1);
-	if (modules_sym)
-		sym_calc_value(modules_sym);
+	l = conf_levels;
+	while (l) {
+		if (l->modules_sym)
+			sym_calc_value(l->modules_sym);
+		l = l->n;
+	}
 }
 
 void sym_set_changed(struct symbol *sym)
@@ -443,12 +438,12 @@ void sym_set_changed(struct symbol *sym)
 	}
 }
 
-void sym_set_all_changed(void)
+void sym_set_all_changed(struct conf_level *l)
 {
 	struct symbol *sym;
 	int i;
 
-	for_all_symbols(i, sym)
+	for_all_symbols_level(i, sym, l)
 		sym_set_changed(sym);
 }
 
@@ -502,7 +497,7 @@ bool sym_set_tristate_value(struct symbol *sym, tristate val)
 
 	sym->def[S_DEF_USER].tri = val;
 	if (oldval != val)
-		sym_clear_all_valid();
+		sym_clear_all_valid(sym->level);
 
 	return true;
 }
@@ -659,7 +654,7 @@ bool sym_set_string_value(struct symbol *sym, const char *newval)
 
 	strcpy(val, newval);
 	free((void *)oldval);
-	sym_clear_all_valid();
+	sym_clear_all_valid(sym->level);
 
 	return true;
 }
@@ -679,7 +674,8 @@ const char *sym_get_string_default(struct symbol *sym)
 	tristate val;
 
 	sym_calc_visibility(sym);
-	sym_calc_value(modules_sym);
+	if (sym->level)
+		sym_calc_value(sym->level->modules_sym);
 	val = symbol_no.curr.tri;
 	str = symbol_empty.curr.val;
 
@@ -711,7 +707,7 @@ const char *sym_get_string_default(struct symbol *sym)
 
 	/* transpose mod to yes if modules are not enabled */
 	if (val == mod)
-		if (!sym_is_choice_value(sym) && modules_sym->curr.tri == no)
+		if (!sym_is_choice_value(sym) && sym->level->modules_sym->curr.tri == no)
 			val = yes;
 
 	/* transpose mod to yes if type is bool */
@@ -750,8 +746,8 @@ const char *sym_get_string_value(struct symbol *sym)
 		case no:
 			return "n";
 		case mod:
-			sym_calc_value(modules_sym);
-			return (modules_sym->curr.tri == no) ? "n" : "m";
+			sym_calc_value(sym->level->modules_sym);
+			return (sym->level->modules_sym->curr.tri == no) ? "n" : "m";
 		case yes:
 			return "y";
 		}
@@ -776,7 +772,7 @@ static unsigned strhash(const char *s)
 	return hash;
 }
 
-struct symbol *sym_lookup(const char *name, int flags)
+struct symbol *sym_lookup(const char *name, int flags, struct conf_level *l)
 {
 	struct symbol *symbol;
 	char *new_name;
@@ -792,7 +788,7 @@ struct symbol *sym_lookup(const char *name, int flags)
 		}
 		hash = strhash(name) % SYMBOL_HASHSIZE;
 
-		for (symbol = symbol_hash[hash]; symbol; symbol = symbol->next) {
+		for (symbol = l->symbol_hash[hash]; symbol; symbol = symbol->next) {
 			if (symbol->name &&
 			    !strcmp(symbol->name, name) &&
 			    (flags ? symbol->flags & flags
@@ -810,14 +806,15 @@ struct symbol *sym_lookup(const char *name, int flags)
 	symbol->name = new_name;
 	symbol->type = S_UNKNOWN;
 	symbol->flags |= flags;
+	symbol->level = l;
 
-	symbol->next = symbol_hash[hash];
-	symbol_hash[hash] = symbol;
+	symbol->next = l->symbol_hash[hash];
+	l->symbol_hash[hash] = symbol;
 
 	return symbol;
 }
 
-struct symbol *sym_find(const char *name)
+struct symbol *sym_find(const char *name, struct conf_level *l)
 {
 	struct symbol *symbol = NULL;
 	int hash = 0;
@@ -834,7 +831,7 @@ struct symbol *sym_find(const char *name)
 	}
 	hash = strhash(name) % SYMBOL_HASHSIZE;
 
-	for (symbol = symbol_hash[hash]; symbol; symbol = symbol->next) {
+	for (symbol = l->symbol_hash[hash]; symbol; symbol = symbol->next) {
 		if (symbol->name &&
 		    !strcmp(symbol->name, name) &&
 		    !(symbol->flags & SYMBOL_CONST))
@@ -849,7 +846,7 @@ struct symbol *sym_find(const char *name)
  * name to be expanded shall be prefixed by a '$'. Unknown symbol expands to
  * the empty string.
  */
-const char *sym_expand_string_value(const char *in)
+const char *sym_expand_string_value(const char *in, struct conf_level *l)
 {
 	const char *src;
 	char *res;
@@ -873,7 +870,7 @@ const char *sym_expand_string_value(const char *in)
 			*p++ = *src++;
 		*p = '\0';
 
-		sym = sym_find(name);
+		sym = sym_find(name, l);
 		if (sym != NULL) {
 			sym_calc_value(sym);
 			symval = sym_get_string_value(sym);
@@ -939,6 +936,7 @@ const char *sym_escape_string_value(const char *in)
 struct symbol **sym_re_search(const char *pattern)
 {
 	struct symbol *sym, **sym_arr = NULL;
+	struct conf_level *l;
 	int i, cnt, size;
 	regex_t re;
 
@@ -948,24 +946,29 @@ struct symbol **sym_re_search(const char *pattern)
 		return NULL;
 	if (regcomp(&re, pattern, REG_EXTENDED|REG_NOSUB|REG_ICASE))
 		return NULL;
-
-	for_all_symbols(i, sym) {
-		if (sym->flags & SYMBOL_CONST || !sym->name)
-			continue;
-		if (regexec(&re, sym->name, 0, NULL, 0))
-			continue;
-		if (cnt + 1 >= size) {
-			void *tmp = sym_arr;
-			size += 16;
-			sym_arr = realloc(sym_arr, size * sizeof(struct symbol *));
-			if (!sym_arr) {
-				free(tmp);
-				return NULL;
+	
+	l = conf_levels;
+	while(l) {
+		for_all_symbols_level(i, sym, l) {
+			if (sym->flags & SYMBOL_CONST || !sym->name)
+				continue;
+			if (regexec(&re, sym->name, 0, NULL, 0))
+				continue;
+			if (cnt + 1 >= size) {
+				void *tmp = sym_arr;
+				size += 16;
+				sym_arr = realloc(sym_arr, size * sizeof(struct symbol *));
+				if (!sym_arr) {
+					free(tmp);
+					return NULL;
+				}
 			}
+			sym_calc_value(sym);
+			sym_arr[cnt++] = sym;
 		}
-		sym_calc_value(sym);
-		sym_arr[cnt++] = sym;
+		l = l->n;
 	}
+	
 	if (sym_arr)
 		sym_arr[cnt] = NULL;
 	regfree(&re);
@@ -1277,6 +1280,7 @@ static void prop_add_env(const char *env)
 {
 	struct symbol *sym, *sym2;
 	struct property *prop;
+	struct conf_level *l = current_entry->sym->level;
 	char *p;
 
 	sym = current_entry->sym;
@@ -1290,10 +1294,10 @@ static void prop_add_env(const char *env)
 	}
 
 	prop = prop_alloc(P_ENV, sym);
-	prop->expr = expr_alloc_symbol(sym_lookup(env, SYMBOL_CONST));
+	prop->expr = expr_alloc_symbol(sym_lookup(env, SYMBOL_CONST, l));
 
-	sym_env_list = expr_alloc_one(E_LIST, sym_env_list);
-	sym_env_list->right.sym = sym;
+	l->sym_env_list = expr_alloc_one(E_LIST, l->sym_env_list);
+	l->sym_env_list->right.sym = sym;
 
 	p = getenv(env);
 	if (p)
@@ -1301,3 +1305,31 @@ static void prop_add_env(const char *env)
 	else
 		menu_warn(current_entry, "environment variable %s undefined", env);
 }
+
+void sym_level_open(struct conf_level *l)
+{
+	struct conf_level **lp;
+	memset(l, 0, sizeof(*l));
+
+	for (lp = &conf_levels; *lp; lp = &(*lp)->n) ;
+	*lp = l;
+	l->parent = current_conf_level;
+	current_conf_level = l;
+
+	l->modules_sym = sym_lookup(NULL, 0, current_conf_level);
+	l->modules_sym->type = S_BOOLEAN;
+	l->modules_sym->flags |= SYMBOL_AUTO;
+	l->conf_prefix = CONFIG_;
+
+	sym_init(current_conf_level);
+}
+
+void sym_level_close(struct conf_level *l)
+{
+	if (!l->modules_sym->prop) {
+		struct property *prop;
+		prop = prop_alloc(P_DEFAULT, l->modules_sym);
+		prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0, current_conf_level));
+	}
+	current_conf_level = l->parent;
+}
diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index d0b8b23..f1b53ae 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -11,10 +11,10 @@
 #include "lkc.h"
 
 /* file already present in list? If not add it */
-struct file *file_lookup(const char *name)
+struct file *file_lookup(const char *name, struct conf_level *l)
 {
 	struct file *file;
-	const char *file_name = sym_expand_string_value(name);
+	const char *file_name = sym_expand_string_value(name, l);
 
 	for (file = file_list; file; file = file->next) {
 		if (!strcmp(name, file->name)) {
@@ -32,7 +32,7 @@ struct file *file_lookup(const char *name)
 }
 
 /* write a dependency file as used by kbuild to track dependencies */
-int file_write_dep(const char *name)
+int file_write_dep(const char *name, struct conf_level *l)
 {
 	struct symbol *sym, *env_sym;
 	struct expr *e;
@@ -54,7 +54,7 @@ int file_write_dep(const char *name)
 	fprintf(out, "\n%s: \\\n"
 		     "\t$(deps_config)\n\n", conf_get_autoconfig_name());
 
-	expr_list_for_each_sym(sym_env_list, e, sym) {
+	expr_list_for_each_sym(l->sym_env_list, e, sym) {
 		struct property *prop;
 		const char *value;
 
diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
index 00f9d3a..cd863ad 100644
--- a/scripts/kconfig/zconf.l
+++ b/scripts/kconfig/zconf.l
@@ -291,14 +291,14 @@ void zconf_initscan(const char *name)
 	current_buf = malloc(sizeof(*current_buf));
 	memset(current_buf, 0, sizeof(*current_buf));
 
-	current_file = file_lookup(name);
+	current_file = file_lookup(name, current_conf_level);
 	current_file->lineno = 1;
 }
 
 void zconf_nextfile(const char *name)
 {
 	struct file *iter;
-	struct file *file = file_lookup(name);
+	struct file *file = file_lookup(name, current_conf_level);
 	struct buffer *buf = malloc(sizeof(*buf));
 	memset(buf, 0, sizeof(*buf));
 
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 864da07..c6e923f 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -26,9 +26,9 @@ static void zconf_error(const char *err, ...);
 static void zconferror(const char *err);
 static bool zconf_endtoken(const struct kconf_id *id, int starttoken, int endtoken);
 
-struct symbol *symbol_hash[SYMBOL_HASHSIZE];
-
 static struct menu *current_menu, *current_entry;
+struct conf_level *current_conf_level = 0;
+struct conf_level *conf_levels = 0;
 
 %}
 %expect 30
@@ -141,7 +141,7 @@ option_error:
 
 config_entry_start: T_CONFIG T_WORD T_EOL
 {
-	struct symbol *sym = sym_lookup($2, 0);
+	struct symbol *sym = sym_lookup($2, 0, current_conf_level);
 	sym->flags |= SYMBOL_OPTIONAL;
 	menu_add_entry(sym);
 	printd(DEBUG_PARSE, "%s:%d:config %s\n", zconf_curname(), zconf_lineno(), $2);
@@ -155,7 +155,7 @@ config_stmt: config_entry_start config_option_list
 
 menuconfig_entry_start: T_MENUCONFIG T_WORD T_EOL
 {
-	struct symbol *sym = sym_lookup($2, 0);
+	struct symbol *sym = sym_lookup($2, 0, current_conf_level);
 	sym->flags |= SYMBOL_OPTIONAL;
 	menu_add_entry(sym);
 	printd(DEBUG_PARSE, "%s:%d:menuconfig %s\n", zconf_curname(), zconf_lineno(), $2);
@@ -207,7 +207,7 @@ config_option: T_DEFAULT expr if_expr T_EOL
 
 config_option: T_SELECT T_WORD if_expr T_EOL
 {
-	menu_add_symbol(P_SELECT, sym_lookup($2, 0), $3);
+	menu_add_symbol(P_SELECT, sym_lookup($2, 0, current_conf_level), $3);
 	printd(DEBUG_PARSE, "%s:%d:select\n", zconf_curname(), zconf_lineno());
 };
 
@@ -241,7 +241,7 @@ symbol_option_arg:
 
 choice: T_CHOICE word_opt T_EOL
 {
-	struct symbol *sym = sym_lookup($2, SYMBOL_CHOICE);
+	struct symbol *sym = sym_lookup($2, SYMBOL_CHOICE, current_conf_level);
 	sym->flags |= SYMBOL_AUTO;
 	menu_add_entry(sym);
 	menu_add_expr(P_CHOICE, NULL, NULL);
@@ -299,7 +299,7 @@ choice_option: T_OPTIONAL T_EOL
 choice_option: T_DEFAULT T_WORD if_expr T_EOL
 {
 	if ($1->stype == S_UNKNOWN) {
-		menu_add_symbol(P_DEFAULT, sym_lookup($2, 0), $3);
+		menu_add_symbol(P_DEFAULT, sym_lookup($2, 0, current_conf_level), $3);
 		printd(DEBUG_PARSE, "%s:%d:default\n",
 			zconf_curname(), zconf_lineno());
 	} else
@@ -475,8 +475,8 @@ expr:	  symbol				{ $$ = expr_alloc_symbol($1); }
 	| expr T_AND expr			{ $$ = expr_alloc_two(E_AND, $1, $3); }
 ;
 
-symbol:	  T_WORD	{ $$ = sym_lookup($1, 0); free($1); }
-	| T_WORD_QUOTE	{ $$ = sym_lookup($1, SYMBOL_CONST); free($1); }
+symbol:	  T_WORD	{ $$ = sym_lookup($1, 0, current_conf_level); free($1); }
+	| T_WORD_QUOTE	{ $$ = sym_lookup($1, SYMBOL_CONST, current_conf_level); free($1); }
 ;
 
 word_opt: /* empty */			{ $$ = NULL; }
@@ -487,15 +487,14 @@ word_opt: /* empty */			{ $$ = NULL; }
 void conf_parse(const char *name)
 {
 	struct symbol *sym;
+	struct conf_level *l;
 	int i;
 
+	sym_level_open(&rootlevel);
+
 	zconf_initscan(name);
 
-	sym_init();
 	_menu_init();
-	modules_sym = sym_lookup(NULL, 0);
-	modules_sym->type = S_BOOLEAN;
-	modules_sym->flags |= SYMBOL_AUTO;
 	rootmenu.prompt = menu_add_prompt(P_MENU, "Linux Kernel Configuration", NULL);
 
 	if (getenv("ZCONF_DEBUG"))
@@ -503,24 +502,26 @@ void conf_parse(const char *name)
 	zconfparse();
 	if (zconfnerrs)
 		exit(1);
-	if (!modules_sym->prop) {
-		struct property *prop;
-
-		prop = prop_alloc(P_DEFAULT, modules_sym);
-		prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0));
-	}
 
 	rootmenu.prompt->text = _(rootmenu.prompt->text);
-	rootmenu.prompt->text = sym_expand_string_value(rootmenu.prompt->text);
+	rootmenu.prompt->text = sym_expand_string_value(rootmenu.prompt->text, current_conf_level);
 
 	menu_finalize(&rootmenu);
-	for_all_symbols(i, sym) {
-		if (sym_check_deps(sym))
-			zconfnerrs++;
-        }
+
+	l = conf_levels;
+	while (l) {
+		for_all_symbols_level(i, sym, current_conf_level) {
+			if (sym_check_deps(sym))
+				zconfnerrs++;
+		}
+		l = l->n;
+	}	
+
 	if (zconfnerrs)
 		exit(1);
 	sym_set_change_count(1);
+
+	sym_level_close(&rootlevel);
 }
 
 static const char *zconf_tokenname(int token)
-- 
1.6.4.1

