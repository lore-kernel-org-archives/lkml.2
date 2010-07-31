Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab0GaVdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:33:03 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33009 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab0GaVby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:31:54 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kconfig: add savedefconfig
Date: Sat, 31 Jul 2010 23:31:50 +0200
Message-Id: <1280611910-8155-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100731212907.GA7554@merkur.ravnborg.org>
References: <20100731212907.GA7554@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

savedefconfig will save a minimal config to a file
named "defconfig".

The config symbols are saved in the same order as
they appear in the menu structure so it should
be possible to map them to the relevant menus
if desired.

The implementation was tested against several minimal
configs for arm which was created using brute-force.

There was one regression related to default numbers
which had their valid range further limited by another symbol.

Sample:

config FOO
	int "foo"
	default 4

config BAR
	int "bar"
	range 0 FOO

If FOO is set to 3 then BAR cannot take a value higher than 3.
But the current implementation will set BAR equal to 4.

This is seldomly used and the final configuration is OK,
and the fix was non-trivial.
So it was documented in the code and left as is.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/Makefile    |    6 +++-
 scripts/kconfig/conf.c      |   14 ++++++++
 scripts/kconfig/confdata.c  |   76 +++++++++++++++++++++++++++++++++++++++++++
 scripts/kconfig/lkc.h       |    1 +
 scripts/kconfig/lkc_proto.h |    1 +
 scripts/kconfig/symbol.c    |   74 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 171 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 0bf1fb6..647dd5a 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -100,11 +100,14 @@ PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
 allnoconfig allyesconfig allmodconfig alldefconfig randconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
-PHONY += listnewconfig oldnoconfig defconfig
+PHONY += listnewconfig oldnoconfig savedefconfig defconfig
 
 listnewconfig oldnoconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
+savedefconfig: $(obj)/conf
+	$< --$@=defconfig $(Kconfig)
+
 defconfig: $(obj)/conf
 ifeq ($(KBUILD_DEFCONFIG),)
 	$< --defconfig $(Kconfig)
@@ -128,6 +131,7 @@ help:
 	@echo  '  localyesconfig  - Update current config converting local mods to core'
 	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
 	@echo  '  defconfig	  - New config with default from ARCH supplied defconfig'
+	@echo  '  savedefconfig   - Save current config as ./defconfig (minimal config)'
 	@echo  '  allnoconfig	  - New config where all options are answered with no'
 	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index c8bd33c..010600e 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -30,6 +30,7 @@ enum input_mode {
 	alldefconfig,
 	randconfig,
 	defconfig,
+	savedefconfig,
 	listnewconfig,
 	oldnoconfig,
 } input_mode = oldaskconfig;
@@ -444,6 +445,7 @@ static struct option long_opts[] = {
 	{"oldconfig",       no_argument,       NULL, oldconfig},
 	{"silentoldconfig", no_argument,       NULL, silentoldconfig},
 	{"defconfig",       optional_argument, NULL, defconfig},
+	{"savedefconfig",   required_argument, NULL, savedefconfig},
 	{"allnoconfig",     no_argument,       NULL, allnoconfig},
 	{"allyesconfig",    no_argument,       NULL, allyesconfig},
 	{"allmodconfig",    no_argument,       NULL, allmodconfig},
@@ -471,6 +473,7 @@ int main(int ac, char **av)
 			sync_kconfig = 1;
 			break;
 		case defconfig:
+		case savedefconfig:
 			defconfig_file = optarg;
 			break;
 		case randconfig:
@@ -526,6 +529,9 @@ int main(int ac, char **av)
 			exit(1);
 		}
 		break;
+	case savedefconfig:
+		conf_read(NULL);
+		break;
 	case silentoldconfig:
 	case oldaskconfig:
 	case oldconfig:
@@ -591,6 +597,8 @@ int main(int ac, char **av)
 	case defconfig:
 		conf_set_all_new_symbols(def_default);
 		break;
+	case savedefconfig:
+		break;
 	case oldconfig:
 	case oldaskconfig:
 		rootEntry = &rootmenu;
@@ -622,6 +630,12 @@ int main(int ac, char **av)
 			fprintf(stderr, _("\n*** Error during update of the kernel configuration.\n\n"));
 			return 1;
 		}
+	} else if (input_mode == savedefconfig) {
+		if (conf_write_defconfig(defconfig_file)) {
+			fprintf(stderr, _("n*** Error while saving defconfig to: %s\n\n"),
+			        defconfig_file);
+			return 1;
+		}
 	} else if (input_mode != listnewconfig) {
 		if (conf_write(NULL)) {
 			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index d4fd55e..8de6f51 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -454,6 +454,82 @@ static void conf_write_symbol(struct symbol *sym, enum symbol_type type,
 	}
 }
 
+/*
+ * Write out a minimal config.
+ * All values that has default values are skipped as this is redundant.
+ */
+int conf_write_defconfig(const char *filename)
+{
+	struct symbol *sym;
+	struct menu *menu;
+	FILE *out;
+
+	out = fopen(filename, "w");
+	if (!out)
+		return 1;
+
+	sym_clear_all_valid();
+
+	/* Traverse all menus to find all relevant symbols */
+	menu = rootmenu.list;
+
+	while (menu != NULL)
+	{
+		sym = menu->sym;
+		if (sym == NULL) {
+			if (!menu_is_visible(menu))
+				goto next_menu;
+		} else if (!sym_is_choice(sym)) {
+			sym_calc_value(sym);
+			if (!(sym->flags & SYMBOL_WRITE))
+				goto next_menu;
+			sym->flags &= ~SYMBOL_WRITE;
+			/* If we cannot change the symbol - skip */
+			if (!sym_is_changable(sym))
+				goto next_menu;
+			/* If symbol equals to default value - skip */
+			if (strcmp(sym_get_string_value(sym), sym_get_string_default(sym)) == 0)
+				goto next_menu;
+
+			/*
+			 * If symbol is a choice value and equals to the
+			 * default for a choice - skip.
+			 * But only if value equal to "y".
+			 */
+			if (sym_is_choice_value(sym)) {
+				struct symbol *cs;
+				struct symbol *ds;
+
+				cs = prop_get_symbol(sym_get_choice_prop(sym));
+				ds = sym_choice_default(cs);
+				if (sym == ds) {
+					if ((sym->type == S_BOOLEAN ||
+					sym->type == S_TRISTATE) &&
+					sym_get_tristate_value(sym) == yes)
+						goto next_menu;
+				}
+			}
+			conf_write_symbol(sym, sym->type, out, true);
+		}
+next_menu:
+		if (menu->list != NULL) {
+			menu = menu->list;
+		}
+		else if (menu->next != NULL) {
+			menu = menu->next;
+		} else {
+			while ((menu = menu->parent)) {
+				if (menu->next != NULL) {
+					menu = menu->next;
+					break;
+				}
+			}
+		}
+	}
+	fclose(out);
+	return 0;
+}
+
 int conf_write(const char *name)
 {
 	FILE *out;
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 755b819..76db065 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -127,6 +127,7 @@ void sym_clear_all_valid(void);
 void sym_set_all_changed(void);
 void sym_set_changed(struct symbol *sym);
 struct symbol *sym_choice_default(struct symbol *sym);
+const char *sym_get_string_default(struct symbol *sym);
 struct symbol *sym_check_deps(struct symbol *sym);
 struct property *prop_alloc(enum prop_type type, struct symbol *sym);
 struct symbol *prop_get_symbol(struct property *prop);
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 7cadcad..9a948c9 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -3,6 +3,7 @@
 P(conf_parse,void,(const char *name));
 P(conf_read,int,(const char *name));
 P(conf_read_simple,int,(const char *name, int));
+P(conf_write_defconfig,int,(const char *name));
 P(conf_write,int,(const char *name));
 P(conf_write_autoconf,int,(void));
 P(conf_get_changed,bool,(void));
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 0a013ab..e95718f 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -661,6 +661,80 @@ bool sym_set_string_value(struct symbol *sym, const char *newval)
 	return true;
 }
 
+/*
+ * Find the default value associated to a symbol.
+ * For tristate symbol handle the modules=n case
+ * in which case "m" becomes "y".
+ * If the symbol does not have any default then fallback
+ * to the fixed default values.
+ */
+const char *sym_get_string_default(struct symbol *sym)
+{
+	struct property *prop;
+	struct symbol *ds;
+	const char *str;
+	tristate val;
+
+	sym_calc_visibility(sym);
+	sym_calc_value(modules_sym);
+	val = symbol_no.curr.tri;
+	str = symbol_empty.curr.val;
+
+	/* If symbol has a default value look it up */
+	prop = sym_get_default_prop(sym);
+	if (prop != NULL) {
+		switch (sym->type) {
+		case S_BOOLEAN:
+		case S_TRISTATE:
+			/* The visibility imay limit the value from yes => mod */
+			val = EXPR_AND(expr_calc_value(prop->expr), prop->visible.tri);
+			break;
+		default:
+			/*
+			 * The following fails to handle the situation
+			 * where a default value is further limited by
+			 * the valid range.
+			 */
+			ds = prop_get_symbol(prop);
+			if (ds != NULL) {
+				sym_calc_value(ds);
+				str = (const char *)ds->curr.val;
+			}
+		}
+	}
+
+	/* Handle select statements */
+	val = EXPR_OR(val, sym->rev_dep.tri);
+
+	/* transpose mod to yes if modules are not enabled */
+	if (val == mod)
+		if (!sym_is_choice_value(sym) && modules_sym->curr.tri == no)
+			val = yes;
+
+	/* transpose mod to yes if type is bool */
+	if (sym->type == S_BOOLEAN && val == mod)
+		val = yes;
+
+	switch (sym->type) {
+	case S_BOOLEAN:
+	case S_TRISTATE:
+		switch (val) {
+		case no: return "n";
+		case mod: return "m";
+		case yes: return "y";
+		}
+	case S_INT:
+	case S_HEX:
+		return str;
+	case S_STRING:
+		return str;
+	case S_OTHER:
+	case S_UNKNOWN:
+		break;
+	}
+	return "";
+}
+
 const char *sym_get_string_value(struct symbol *sym)
 {
 	tristate val;
-- 
1.6.0.6

