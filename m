Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0G2IQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:16:44 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44789 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab0G2IQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:16:40 -0400
Date: Thu, 29 Jul 2010 10:16:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Aristeu Rozanski <aris@redhat.com>
Subject: [PATCH 2/2] kconfig: change nonint_oldconfig to listnewconfig
Message-ID: <20100729081639.GB5157@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <20100729081316.GA4990@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729081316.GA4990@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7b28159d4367889157f6371cdd3dd34138be3699 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 29 Jul 2010 09:47:26 +0200
Subject: [PATCH 2/2] kconfig: change nonint_oldconfig to listnewconfig

Rename to a name that better match the other kconfig targets.

listnewconfig shall read as:

- list all new options compared to current configuration

Also change so we do one thing - which is to list new options.
The configuration is not updated.

New options are now written to stdout so one can redirect the output.

Finally drop the failure code. We list new options if there are any.
The failure code is dropped from both oldnoconfig and listnewconfig.

These are all feature changes compared to the original
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
index 6c71306..1290ac3 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -3,7 +3,7 @@
 # These targets are used from top-level makefile
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config \
-	localmodconfig localyesconfig oldnoconfig
+	localmodconfig localyesconfig oldnoconfig listnewconfig
 
 ifdef KBUILD_KCONFIG
 Kconfig := $(KBUILD_KCONFIG)
@@ -72,7 +72,7 @@ localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
 	fi
 	$(Q)rm -f .tmp.config
 
-nonit_oldconfig: $(obj)/conf
+listnewconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
 oldnoconfig: $(obj)/conf
@@ -136,8 +136,7 @@ help:
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
 	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
 	@echo  '  allnoconfig	  - New config where all options are answered with no'
-	@echo  '  nonint_oldconfig - Checks the current configuration and fails if an option is '
-	@echo  '                    not set'
+	@echo  '  listnewconfig   - List new options'
 	@echo  '  oldnoconfig     - Same as silentoldconfig but set new symbols to n (unset)'
 
 # lxdialog stuff
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 3c8f31b..b917778 100644
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
 
@@ -34,7 +30,7 @@ enum input_mode {
 	allrandconfig,
 	defconfig,
 	readdefconfig,
-	nonint_oldconfig,
+	listnewconfig,
 	oldnoconfig,
 } input_mode = oldaskconfig;
 
@@ -46,7 +42,6 @@ static int sync_kconfig;
 static int conf_cnt;
 static char line[128];
 static struct menu *rootEntry;
-static int unset_variables;
 
 static void print_help(struct menu *menu)
 {
@@ -367,7 +362,7 @@ static void conf(struct menu *menu)
 		switch (prop->type) {
 		case P_MENU:
 			if ((input_mode == silentoldconfig ||
-			     input_mode == nonint_oldconfig ||
+			     input_mode == listnewconfig ||
 			     input_mode == oldnoconfig) &&
 			    rootEntry != menu) {
 				check_conf(menu);
@@ -427,16 +422,9 @@ static void check_conf(struct menu *menu)
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
@@ -461,7 +449,7 @@ static struct option long_opts[] = {
 	{"allyesconfig",    no_argument,       NULL, allyesconfig},
 	{"allmodconfig",    no_argument,       NULL, allmodconfig},
 	{"allrandconfig",   no_argument,       NULL, allrandconfig},
-	{"nonint_oldconfig",       no_argument, NULL, nonint_oldconfig},
+	{"listnewconfig",   no_argument,       NULL, listnewconfig},
 	{"oldnoconfig",     no_argument,       NULL, oldnoconfig},
 	{NULL, 0, NULL, 0}
 };
@@ -542,7 +530,7 @@ int main(int ac, char **av)
 	case silentoldconfig:
 	case oldaskconfig:
 	case oldconfig:
-	case nonint_oldconfig:
+	case listnewconfig:
 	case oldnoconfig:
 		conf_read(NULL);
 		break;
@@ -606,7 +594,7 @@ int main(int ac, char **av)
 		conf(&rootmenu);
 		input_mode = silentoldconfig;
 		/* fall through */
-	case nonint_oldconfig:
+	case listnewconfig:
 	case oldnoconfig:
 	case silentoldconfig:
 		/* Update until a loop caused no more changes */
@@ -614,7 +602,7 @@ int main(int ac, char **av)
 			conf_cnt = 0;
 			check_conf(&rootmenu);
 		} while (conf_cnt &&
-			 (input_mode != nonint_oldconfig &&
+			 (input_mode != listnewconfig &&
 			  input_mode != oldnoconfig));
 		break;
 	}
@@ -631,11 +619,11 @@ int main(int ac, char **av)
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

