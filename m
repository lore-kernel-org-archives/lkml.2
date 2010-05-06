Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab0EFQr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:47:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0EFQrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:47:24 -0400
Date: Thu, 6 May 2010 12:48:34 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, davej@redhat.com, kyle@redhat.com,
       vgoyal@redhat.com, arjan@linux.intel.com
Subject: [PATCH] kconfig: introduce nonint_oldconfig and
	loose_nonint_oldconfig (v3)
Message-ID: <20100506164834.GL20778@redhat.com>
References: <20100413194747.GX31193@redhat.com> <20100413130031.d4dec19b.randy.dunlap@oracle.com> <20100413201759.GY31193@redhat.com> <4BC4D310.6060705@oracle.com> <20100413210352.GA31193@redhat.com> <4BC5C190.3020501@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC5C190.3020501@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has been around for a long time in Fedora and Red Hat Enterprise
Linux kernels and it may be useful for others. The nonint_oldconfig target
will fail and print the unset config options while loose_nonint_oldconfig will
simply let the config option unset. They're useful in distro kernel packages
where the config files are built using a combination of smaller config files.

Arjan van de Ven wrote the initial nonint_config and Roland McGrath added the
loose_nonint_oldconfig.

v2:
- when -B and -b are used, return "2" so the reason can be distinguished from
  other errors
v3:
- help updated
- nonint_oldconfig won't update the config file if options are missing

Signed-off-by: Arjan van de Ven <arjan@redhat.com> [defunct email]
Whatevered-by: Kyle McMartin <kyle@redhat.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 scripts/kconfig/Makefile |   10 +++++++++
 scripts/kconfig/conf.c   |   52 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 9 deletions(-)

--- linus-2.6.orig/scripts/kconfig/Makefile	2010-04-15 14:12:59.000000000 -0400
+++ linus-2.6/scripts/kconfig/Makefile	2010-05-06 12:37:28.000000000 -0400
@@ -69,6 +69,12 @@ localyesconfig: $(obj)/streamline_config
 	fi
 	$(Q)rm -f .tmp.config
 
+nonint_oldconfig: $(obj)/conf
+	$< -b $(Kconfig)
+
+loose_nonint_oldconfig: $(obj)/conf
+	$< -B $(Kconfig)
+
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
@@ -132,6 +138,10 @@ help:
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
 	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
 	@echo  '  allnoconfig	  - New config where all options are answered with no'
+	@echo  '  nonint_oldconfig - Checks the current configuration and fails if an option is '
+	@echo  '                    not set'
+	@echo  '  loose_nonint_oldconfig - Same as nonint_oldconfig, but updates the config file with '
+	@echo  '                    missing config options as unset'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
--- linus-2.6.orig/scripts/kconfig/conf.c	2010-04-15 14:12:59.000000000 -0400
+++ linus-2.6/scripts/kconfig/conf.c	2010-05-06 12:45:34.000000000 -0400
@@ -16,6 +16,10 @@
 #define LKC_DIRECT_LINK
 #include "lkc.h"
 
+/* Return codes */
+#define EUNSETOPT	2	/* if -B and -b are used and unset config
+				 * options were found */
+
 static void conf(struct menu *menu);
 static void check_conf(struct menu *menu);
 
@@ -23,6 +27,8 @@ enum {
 	ask_all,
 	ask_new,
 	ask_silent,
+	dont_ask,
+	dont_ask_dont_tell,
 	set_default,
 	set_yes,
 	set_mod,
@@ -37,6 +43,7 @@ static int sync_kconfig;
 static int conf_cnt;
 static char line[128];
 static struct menu *rootEntry;
+static int unset_variables;
 
 static void print_help(struct menu *menu)
 {
@@ -360,7 +367,10 @@ static void conf(struct menu *menu)
 
 		switch (prop->type) {
 		case P_MENU:
-			if (input_mode == ask_silent && rootEntry != menu) {
+			if ((input_mode == ask_silent ||
+			     input_mode == dont_ask ||
+			     input_mode == dont_ask_dont_tell) &&
+			    rootEntry != menu) {
 				check_conf(menu);
 				return;
 			}
@@ -418,10 +428,22 @@ static void check_conf(struct menu *menu
 	if (sym && !sym_has_value(sym)) {
 		if (sym_is_changable(sym) ||
 		    (sym_is_choice(sym) && sym_get_tristate_value(sym) == yes)) {
-			if (!conf_cnt++)
-				printf(_("*\n* Restart config...\n*\n"));
-			rootEntry = menu_get_parent_menu(menu);
-			conf(rootEntry);
+			if (input_mode == dont_ask ||
+			    input_mode == dont_ask_dont_tell) {
+				if (input_mode == dont_ask &&
+				    sym->name && !sym_is_choice_value(sym)) {
+					if (!unset_variables)
+						fprintf(stderr, "The following"
+						  " variables are not set:\n");
+					fprintf(stderr,"CONFIG_%s\n",sym->name);
+					unset_variables++;
+				}
+			} else {
+				if (!conf_cnt++)
+					printf(_("*\n* Restart config...\n*\n"));
+				rootEntry = menu_get_parent_menu(menu);
+				conf(rootEntry);
+			}
 		}
 	}
 
@@ -439,7 +461,7 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
+ 	while ((opt = getopt(ac, av, "osbBdD:nmyrh")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_silent;
@@ -448,6 +470,12 @@ int main(int ac, char **av)
 			input_mode = ask_silent;
 			sync_kconfig = 1;
 			break;
+		case 'b':
+			input_mode = dont_ask;
+			break;
+		case 'B':
+			input_mode = dont_ask_dont_tell;
+			break;
 		case 'd':
 			input_mode = set_default;
 			break;
@@ -525,6 +553,8 @@ int main(int ac, char **av)
 	case ask_silent:
 	case ask_all:
 	case ask_new:
+	case dont_ask:
+	case dont_ask_dont_tell:
 		conf_read(NULL);
 		break;
 	case set_no:
@@ -586,12 +616,16 @@ int main(int ac, char **av)
 		conf(&rootmenu);
 		input_mode = ask_silent;
 		/* fall through */
+	case dont_ask:
+	case dont_ask_dont_tell:
 	case ask_silent:
 		/* Update until a loop caused no more changes */
 		do {
 			conf_cnt = 0;
 			check_conf(&rootmenu);
-		} while (conf_cnt);
+		} while (conf_cnt &&
+			 (input_mode != dont_ask &&
+			  input_mode != dont_ask_dont_tell));
 		break;
 	}
 
@@ -607,11 +641,11 @@ int main(int ac, char **av)
 			fprintf(stderr, _("\n*** Error during update of the kernel configuration.\n\n"));
 			return 1;
 		}
-	} else {
+	} else if (!unset_variables || input_mode != dont_ask) {
 		if (conf_write(NULL)) {
 			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 			exit(1);
 		}
 	}
-	return 0;
+	return unset_variables? EUNSETOPT : 0;
 }
