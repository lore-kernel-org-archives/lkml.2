Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab0GaVfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:35:40 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40604 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab0GaVfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:35:36 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Aristeu Rozanski <aris@redhat.com>
Subject: [PATCH 3/9] kconfig: change nonint_oldconfig to listnewconfig
Date: Sat, 31 Jul 2010 23:35:28 +0200
Message-Id: <1280612134-8220-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100731213429.GA8200@merkur.ravnborg.org>
References: <20100731213429.GA8200@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename to a name that better match the other kconfig targets.

listnewconfig shall read as:

- list new options compared to current configuration

New options are now written to stdout so one can redirect the output.

Do not exit with an error code if there is new options.

These are feature changes compared to the original
nonint_oldconfig - but as this feature has not yet been in a
released kernel it should not matter.

It is still possible to do:

make listnewconfig
lookup new config options in Kconfig*
edit .config

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Aristeu Rozanski <aris@redhat.com>
---
 scripts/kconfig/Makefile |    7 +++----
 scripts/kconfig/conf.c   |   34 +++++++++++-----------------------
 2 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 0e3c670..2900d11 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -100,9 +100,9 @@ PHONY += allnoconfig allyesconfig allmodconfig randconfig
 allnoconfig allyesconfig allmodconfig randconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
-PHONY += nonint_oldconfig oldnoconfig defconfig
+PHONY += listnewconfig oldnoconfig defconfig
 
-nonint_oldconfig oldnoconfig: $(obj)/conf
+listnewconfig oldnoconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
 defconfig: $(obj)/conf
@@ -132,8 +132,7 @@ help:
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
 	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
 	@echo  '  allnoconfig	  - New config where all options are answered with no'
-	@echo  '  nonint_oldconfig - Checks the current configuration and fails if an option is '
-	@echo  '                    not set'
+	@echo  '  listnewconfig   - List new options'
 	@echo  '  oldnoconfig     - Same as silentoldconfig but set new symbols to n (unset)'
 
 # lxdialog stuff
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 1f86fca..ff5c914 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -17,10 +17,6 @@
 #define LKC_DIRECT_LINK
 #include "lkc.h"
 
-/* Return codes */
-#define EUNSETOPT	2	/* if -B and -b are used and unset config
-				 * options were found */
-
 static void conf(struct menu *menu);
 static void check_conf(struct menu *menu);
 
@@ -33,7 +29,7 @@ enum input_mode {
 	allmodconfig,
 	randconfig,
 	defconfig,
-	nonint_oldconfig,
+	listnewconfig,
 	oldnoconfig,
 } input_mode = oldaskconfig;
 
@@ -45,7 +41,6 @@ static int sync_kconfig;
 static int conf_cnt;
 static char line[128];
 static struct menu *rootEntry;
-static int unset_variables;
 
 static void print_help(struct menu *menu)
 {
@@ -366,7 +361,7 @@ static void conf(struct menu *menu)
 		switch (prop->type) {
 		case P_MENU:
 			if ((input_mode == silentoldconfig ||
-			     input_mode == nonint_oldconfig ||
+			     input_mode == listnewconfig ||
 			     input_mode == oldnoconfig) &&
 			    rootEntry != menu) {
 				check_conf(menu);
@@ -426,16 +421,9 @@ static void check_conf(struct menu *menu)
 	if (sym && !sym_has_value(sym)) {
 		if (sym_is_changable(sym) ||
 		    (sym_is_choice(sym) && sym_get_tristate_value(sym) == yes)) {
-			if (input_mode == nonint_oldconfig ||
-			    input_mode == oldnoconfig) {
-				if (input_mode == nonint_oldconfig &&
-				    sym->name && !sym_is_choice_value(sym)) {
-					if (!unset_variables)
-						fprintf(stderr, "The following"
-						  " variables are not set:\n");
-					fprintf(stderr, "CONFIG_%s\n",
-							sym->name);
-					unset_variables++;
+			if (input_mode == listnewconfig) {
+				if (sym->name && !sym_is_choice_value(sym)) {
+					printf("CONFIG_%s\n", sym->name);
 				}
 			} else {
 				if (!conf_cnt++)
@@ -459,7 +447,7 @@ static struct option long_opts[] = {
 	{"allyesconfig",    no_argument,       NULL, allyesconfig},
 	{"allmodconfig",    no_argument,       NULL, allmodconfig},
 	{"randconfig",      no_argument,       NULL, randconfig},
-	{"nonint_oldconfig",       no_argument, NULL, nonint_oldconfig},
+	{"listnewconfig",   no_argument,       NULL, listnewconfig},
 	{"oldnoconfig",     no_argument,       NULL, oldnoconfig},
 	{NULL, 0, NULL, 0}
 };
@@ -539,7 +527,7 @@ int main(int ac, char **av)
 	case silentoldconfig:
 	case oldaskconfig:
 	case oldconfig:
-	case nonint_oldconfig:
+	case listnewconfig:
 	case oldnoconfig:
 		conf_read(NULL);
 		break;
@@ -602,7 +590,7 @@ int main(int ac, char **av)
 		conf(&rootmenu);
 		input_mode = silentoldconfig;
 		/* fall through */
-	case nonint_oldconfig:
+	case listnewconfig:
 	case oldnoconfig:
 	case silentoldconfig:
 		/* Update until a loop caused no more changes */
@@ -610,7 +598,7 @@ int main(int ac, char **av)
 			conf_cnt = 0;
 			check_conf(&rootmenu);
 		} while (conf_cnt &&
-			 (input_mode != nonint_oldconfig &&
+			 (input_mode != listnewconfig &&
 			  input_mode != oldnoconfig));
 		break;
 	}
@@ -627,11 +615,11 @@ int main(int ac, char **av)
 			fprintf(stderr, _("\n*** Error during update of the kernel configuration.\n\n"));
 			return 1;
 		}
-	} else if (!unset_variables || input_mode != nonint_oldconfig) {
+	} else if (input_mode != listnewconfig) {
 		if (conf_write(NULL)) {
 			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 			exit(1);
 		}
 	}
-	return unset_variables ? EUNSETOPT : 0;
+	return 0;
 }
-- 
1.6.0.6

