Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0GaVb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:31:59 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:32980 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab0GaVbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:31:53 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kconfig: use long options in conf
Date: Sat, 31 Jul 2010 23:31:42 +0200
Message-Id: <1280611910-8155-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100731212907.GA7554@merkur.ravnborg.org>
References: <20100731212907.GA7554@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list of options supported by conf is growing
and their abbreviation did not resemble anything usefull.

So drop the single letter options in favour of long options.

The long options are named equal to what we know from
the make target.
The internal implmentation was changed to match this,
resulting in much more readable code.

Support for short options is dropped - no one is supposed
to call this program direct anyway.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/Makefile |   70 +++++++++-----------
 scripts/kconfig/conf.c   |  161 +++++++++++++++++++++------------------------
 2 files changed, 105 insertions(+), 126 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 0a34335..b712bdb 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -21,17 +21,17 @@ menuconfig: $(obj)/mconf
 	$< $(Kconfig)
 
 config: $(obj)/conf
-	$< $(Kconfig)
+	$< --oldaskconfig $(Kconfig)
 
 nconfig: $(obj)/nconf
 	$< $(Kconfig)
 
 oldconfig: $(obj)/conf
-	$< -o $(Kconfig)
+	$< --$@ $(Kconfig)
 
 silentoldconfig: $(obj)/conf
 	$(Q)mkdir -p include/generated
-	$< -s $(Kconfig)
+	$< --$@ $(Kconfig)
 
 # if no path is given, then use src directory to find file
 ifdef LSMOD
@@ -44,15 +44,15 @@ endif
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)mkdir -p include/generated
 	$(Q)perl $< $(srctree) $(Kconfig) $(LSMOD_F) > .tmp.config
-	$(Q)if [ -f .config ]; then 				\
-			cmp -s .tmp.config .config ||		\
-			(mv -f .config .config.old.1;		\
-			 mv -f .tmp.config .config;		\
-			 $(obj)/conf -s $(Kconfig);		\
-			 mv -f .config.old.1 .config.old)	\
-	else							\
-			mv -f .tmp.config .config;		\
-			$(obj)/conf -s $(Kconfig);		\
+	$(Q)if [ -f .config ]; then					\
+			cmp -s .tmp.config .config ||			\
+			(mv -f .config .config.old.1;			\
+			 mv -f .tmp.config .config;			\
+			 $(obj)/conf --silentoldconfig $(Kconfig);	\
+			 mv -f .config.old.1 .config.old)		\
+	else								\
+			mv -f .tmp.config .config;			\
+			$(obj)/conf --silentoldconfig $(Kconfig);	\
 	fi
 	$(Q)rm -f .tmp.config
 
@@ -60,24 +60,18 @@ localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)mkdir -p include/generated
 	$(Q)perl $< $(srctree) $(Kconfig) $(LSMOD_F) > .tmp.config
 	$(Q)sed -i s/=m/=y/ .tmp.config
-	$(Q)if [ -f .config ]; then 				\
-			cmp -s .tmp.config .config ||		\
-			(mv -f .config .config.old.1;		\
-			 mv -f .tmp.config .config;		\
-			 $(obj)/conf -s $(Kconfig);		\
-			 mv -f .config.old.1 .config.old)	\
-	else							\
-			mv -f .tmp.config .config;		\
-			$(obj)/conf -s $(Kconfig);		\
+	$(Q)if [ -f .config ]; then					\
+			cmp -s .tmp.config .config ||			\
+			(mv -f .config .config.old.1;			\
+			 mv -f .tmp.config .config;			\
+			 $(obj)/conf --silentoldconfig $(Kconfig);	\
+			 mv -f .config.old.1 .config.old)		\
+	else								\
+			mv -f .tmp.config .config;			\
+			$(obj)/conf --silentoldconfig $(Kconfig);	\
 	fi
 	$(Q)rm -f .tmp.config
 
-nonint_oldconfig: $(obj)/conf
-	$< -b $(Kconfig)
-
-loose_nonint_oldconfig: $(obj)/conf
-	$< -B $(Kconfig)
-
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
@@ -101,30 +95,26 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	$(Q)rm -f arch/um/Kconfig.arch
 	$(Q)rm -f $(obj)/config.pot
 
-PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig
-
-randconfig: $(obj)/conf
-	$< -r $(Kconfig)
+PHONY += allnoconfig allyesconfig allmodconfig randconfig
 
-allyesconfig: $(obj)/conf
-	$< -y $(Kconfig)
+allnoconfig allyesconfig allmodconfig randconfig: $(obj)/conf
+	$< --$@ $(Kconfig)
 
-allnoconfig: $(obj)/conf
-	$< -n $(Kconfig)
+PHONY += nonint_oldconfig loose_nonint_oldconfig defconfig
 
-allmodconfig: $(obj)/conf
-	$< -m $(Kconfig)
+nonint_oldconfig loose_nonint_oldconfig: $(obj)/conf
+	$< --$@ $(Kconfig)
 
 defconfig: $(obj)/conf
 ifeq ($(KBUILD_DEFCONFIG),)
-	$< -d $(Kconfig)
+	$< --defconfig $(Kconfig)
 else
 	@echo "*** Default configuration is based on '$(KBUILD_DEFCONFIG)'"
-	$(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
+	$(Q)$< --defconfig=arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
 endif
 
 %_defconfig: $(obj)/conf
-	$(Q)$< -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
+	$(Q)$< --defconfig=arch/$(SRCARCH)/configs/$@ $(Kconfig)
 
 # Help text used by make help
 help:
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index bde01b4..2dec584 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <time.h>
 #include <unistd.h>
+#include <getopt.h>
 #include <sys/stat.h>
 #include <sys/time.h>
 
@@ -23,18 +24,19 @@
 static void conf(struct menu *menu);
 static void check_conf(struct menu *menu);
 
-enum {
-	ask_all,
-	ask_new,
-	ask_silent,
-	dont_ask,
-	dont_ask_dont_tell,
-	set_default,
-	set_yes,
-	set_mod,
-	set_no,
-	set_random
-} input_mode = ask_all;
+enum input_mode {
+	oldaskconfig,
+	silentoldconfig,
+	oldconfig,
+	allnoconfig,
+	allyesconfig,
+	allmodconfig,
+	randconfig,
+	defconfig,
+	nonint_oldconfig,
+	loose_nonint_oldconfig,
+} input_mode = oldaskconfig;
+
 char *defconfig_file;
 
 static int indent = 1;
@@ -100,14 +102,14 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	}
 
 	switch (input_mode) {
-	case ask_new:
-	case ask_silent:
+	case oldconfig:
+	case silentoldconfig:
 		if (sym_has_value(sym)) {
 			printf("%s\n", def);
 			return 0;
 		}
 		check_stdin();
-	case ask_all:
+	case oldaskconfig:
 		fflush(stdout);
 		fgets(line, 128, stdin);
 		return 1;
@@ -297,15 +299,15 @@ static int conf_choice(struct menu *menu)
 			printf("?");
 		printf("]: ");
 		switch (input_mode) {
-		case ask_new:
-		case ask_silent:
+		case oldconfig:
+		case silentoldconfig:
 			if (!is_new) {
 				cnt = def;
 				printf("%d\n", cnt);
 				break;
 			}
 			check_stdin();
-		case ask_all:
+		case oldaskconfig:
 			fflush(stdout);
 			fgets(line, 128, stdin);
 			strip(line);
@@ -363,9 +365,9 @@ static void conf(struct menu *menu)
 
 		switch (prop->type) {
 		case P_MENU:
-			if ((input_mode == ask_silent ||
-			     input_mode == dont_ask ||
-			     input_mode == dont_ask_dont_tell) &&
+			if ((input_mode == silentoldconfig ||
+			     input_mode == nonint_oldconfig ||
+			     input_mode == loose_nonint_oldconfig) &&
 			    rootEntry != menu) {
 				check_conf(menu);
 				return;
@@ -424,9 +426,9 @@ static void check_conf(struct menu *menu)
 	if (sym && !sym_has_value(sym)) {
 		if (sym_is_changable(sym) ||
 		    (sym_is_choice(sym) && sym_get_tristate_value(sym) == yes)) {
-			if (input_mode == dont_ask ||
-			    input_mode == dont_ask_dont_tell) {
-				if (input_mode == dont_ask &&
+			if (input_mode == nonint_oldconfig ||
+			    input_mode == loose_nonint_oldconfig) {
+				if (input_mode == nonint_oldconfig &&
 				    sym->name && !sym_is_choice_value(sym)) {
 					if (!unset_variables)
 						fprintf(stderr, "The following"
@@ -448,6 +450,20 @@ static void check_conf(struct menu *menu)
 		check_conf(child);
 }
 
+static struct option long_opts[] = {
+	{"oldaskconfig",    no_argument,       NULL, oldaskconfig},
+	{"oldconfig",       no_argument,       NULL, oldconfig},
+	{"silentoldconfig", no_argument,       NULL, silentoldconfig},
+	{"defconfig",       optional_argument, NULL, defconfig},
+	{"allnoconfig",     no_argument,       NULL, allnoconfig},
+	{"allyesconfig",    no_argument,       NULL, allyesconfig},
+	{"allmodconfig",    no_argument,       NULL, allmodconfig},
+	{"randconfig",      no_argument,       NULL, randconfig},
+	{"nonint_oldconfig",       no_argument, NULL, nonint_oldconfig},
+	{"loose_nonint_oldconfig", no_argument, NULL, loose_nonint_oldconfig},
+	{NULL, 0, NULL, 0}
+};
+
 int main(int ac, char **av)
 {
 	int opt;
@@ -458,38 +474,16 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osbBdD:nmyrh")) != -1) {
+	while ((opt = getopt_long_only(ac, av, "", long_opts, NULL)) != -1) {
+		input_mode = (enum input_mode)opt;
 		switch (opt) {
-		case 'o':
-			input_mode = ask_silent;
-			break;
-		case 's':
-			input_mode = ask_silent;
+		case silentoldconfig:
 			sync_kconfig = 1;
 			break;
-		case 'b':
-			input_mode = dont_ask;
-			break;
-		case 'B':
-			input_mode = dont_ask_dont_tell;
-			break;
-		case 'd':
-			input_mode = set_default;
-			break;
-		case 'D':
-			input_mode = set_default;
+		case defconfig:
 			defconfig_file = optarg;
 			break;
-		case 'n':
-			input_mode = set_no;
-			break;
-		case 'm':
-			input_mode = set_mod;
-			break;
-		case 'y':
-			input_mode = set_yes;
-			break;
-		case 'r':
+		case randconfig:
 		{
 			struct timeval now;
 			unsigned int seed;
@@ -502,17 +496,12 @@ int main(int ac, char **av)
 
 			seed = (unsigned int)((now.tv_sec + 1) * (now.tv_usec + 1));
 			srand(seed);
-
-			input_mode = set_random;
 			break;
 		}
-		case 'h':
-			printf(_("See README for usage info\n"));
-			exit(0);
-			break;
-		default:
+		case '?':
 			fprintf(stderr, _("See README for usage info\n"));
 			exit(1);
+			break;
 		}
 	}
 	if (ac == optind) {
@@ -537,7 +526,7 @@ int main(int ac, char **av)
 	}
 
 	switch (input_mode) {
-	case set_default:
+	case defconfig:
 		if (!defconfig_file)
 			defconfig_file = conf_get_default_confname();
 		if (conf_read(defconfig_file)) {
@@ -547,27 +536,27 @@ int main(int ac, char **av)
 			exit(1);
 		}
 		break;
-	case ask_silent:
-	case ask_all:
-	case ask_new:
-	case dont_ask:
-	case dont_ask_dont_tell:
+	case silentoldconfig:
+	case oldaskconfig:
+	case oldconfig:
+	case nonint_oldconfig:
+	case loose_nonint_oldconfig:
 		conf_read(NULL);
 		break;
-	case set_no:
-	case set_mod:
-	case set_yes:
-	case set_random:
+	case allnoconfig:
+	case allyesconfig:
+	case allmodconfig:
+	case randconfig:
 		name = getenv("KCONFIG_ALLCONFIG");
 		if (name && !stat(name, &tmpstat)) {
 			conf_read_simple(name, S_DEF_USER);
 			break;
 		}
 		switch (input_mode) {
-		case set_no:	 name = "allno.config"; break;
-		case set_mod:	 name = "allmod.config"; break;
-		case set_yes:	 name = "allyes.config"; break;
-		case set_random: name = "allrandom.config"; break;
+		case allnoconfig:	name = "allno.config"; break;
+		case allyesconfig:	name = "allyes.config"; break;
+		case allmodconfig:	name = "allmod.config"; break;
+		case randconfig:	name = "allrandom.config"; break;
 		default: break;
 		}
 		if (!stat(name, &tmpstat))
@@ -592,37 +581,37 @@ int main(int ac, char **av)
 	}
 
 	switch (input_mode) {
-	case set_no:
+	case allnoconfig:
 		conf_set_all_new_symbols(def_no);
 		break;
-	case set_yes:
+	case allyesconfig:
 		conf_set_all_new_symbols(def_yes);
 		break;
-	case set_mod:
+	case allmodconfig:
 		conf_set_all_new_symbols(def_mod);
 		break;
-	case set_random:
+	case randconfig:
 		conf_set_all_new_symbols(def_random);
 		break;
-	case set_default:
+	case defconfig:
 		conf_set_all_new_symbols(def_default);
 		break;
-	case ask_new:
-	case ask_all:
+	case oldconfig:
+	case oldaskconfig:
 		rootEntry = &rootmenu;
 		conf(&rootmenu);
-		input_mode = ask_silent;
+		input_mode = silentoldconfig;
 		/* fall through */
-	case dont_ask:
-	case dont_ask_dont_tell:
-	case ask_silent:
+	case nonint_oldconfig:
+	case loose_nonint_oldconfig:
+	case silentoldconfig:
 		/* Update until a loop caused no more changes */
 		do {
 			conf_cnt = 0;
 			check_conf(&rootmenu);
 		} while (conf_cnt &&
-			 (input_mode != dont_ask &&
-			  input_mode != dont_ask_dont_tell));
+			 (input_mode != nonint_oldconfig &&
+			  input_mode != loose_nonint_oldconfig));
 		break;
 	}
 
@@ -638,7 +627,7 @@ int main(int ac, char **av)
 			fprintf(stderr, _("\n*** Error during update of the kernel configuration.\n\n"));
 			return 1;
 		}
-	} else if (!unset_variables || input_mode != dont_ask) {
+	} else if (!unset_variables || input_mode != nonint_oldconfig) {
 		if (conf_write(NULL)) {
 			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 			exit(1);
-- 
1.6.0.6

