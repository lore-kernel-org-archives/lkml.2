Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0DMTrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:47:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab0DMTq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:46:59 -0400
Date: Tue, 13 Apr 2010 15:47:48 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: davej@redhat.com, kyle@redhat.com, vgoyal@redhat.com,
       arjan@linux.intel.com
Subject: [PATCH] kconfig: introduce nonint_oldconfig and
	loose_nonint_oldconfig
Message-ID: <20100413194747.GX31193@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has been around for a long time in Fedora and Red Hat Enterprise
Linux kernels and it may be useful for others. The nonint_oldconfig target
will fail and print the unset config options while loose_nonint_oldconfig will
simply let the config option unset. They're useful in distro kernel packages
where the config files are built using a combination of smaller config files.
The patch's author AFAIK is Arjan van de Ven. Arjan, please add a Signed-off-by
if you're the original author.

Signed-off-by: Aristeu Rozanski <aris@redhat.com> 

--- linus-2.6.orig/scripts/kconfig/Makefile	2010-04-13 15:15:10.000000000 -0400
+++ linus-2.6/scripts/kconfig/Makefile	2010-04-13 15:15:23.000000000 -0400
@@ -69,6 +69,11 @@ localyesconfig: $(obj)/streamline_config
 	fi
 	$(Q)rm -f .tmp.config
 
+nonint_oldconfig: $(obj)/conf
+	$< -b $(Kconfig)
+loose_nonint_oldconfig: $(obj)/conf
+	$< -B $(Kconfig)
+
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
--- linus-2.6.orig/scripts/kconfig/conf.c	2010-04-13 15:15:10.000000000 -0400
+++ linus-2.6/scripts/kconfig/conf.c	2010-04-13 15:15:54.000000000 -0400
@@ -23,6 +23,8 @@ enum {
 	ask_all,
 	ask_new,
 	ask_silent,
+	dont_ask,
+	dont_ask_dont_tell,
 	set_default,
 	set_yes,
 	set_mod,
@@ -360,7 +362,10 @@ static void conf(struct menu *menu)
 
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
@@ -406,6 +411,8 @@ conf_childs:
 		indent -= 2;
 }
 
+static int return_value;
+
 static void check_conf(struct menu *menu)
 {
 	struct symbol *sym;
@@ -418,10 +425,19 @@ static void check_conf(struct menu *menu
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
+					fprintf(stderr,"CONFIG_%s\n",sym->name);
+					++return_value;
+				}
+			} else {
+				if (!conf_cnt++)
+					printf(_("*\n* Restart config...\n*\n"));
+				rootEntry = menu_get_parent_menu(menu);
+				conf(rootEntry);
+			}
 		}
 	}
 
@@ -439,7 +455,7 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
+ 	while ((opt = getopt(ac, av, "osbBdD:nmyrh")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_silent;
@@ -448,6 +464,12 @@ int main(int ac, char **av)
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
@@ -525,6 +547,8 @@ int main(int ac, char **av)
 	case ask_silent:
 	case ask_all:
 	case ask_new:
+	case dont_ask:
+	case dont_ask_dont_tell:
 		conf_read(NULL);
 		break;
 	case set_no:
@@ -586,12 +610,16 @@ int main(int ac, char **av)
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
 
@@ -613,5 +641,5 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	}
-	return 0;
+	return return_value;
 }
