Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0GYVjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:39:51 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54874 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0GYVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:39:49 -0400
Date: Sun, 25 Jul 2010 23:39:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/4] kconfig: add alldefconfig
Message-ID: <20100725213948.GC5834@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100725213808.GA5814@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e797380842b48477cc9d5e625420c3426caff6e2 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 24 Jul 2010 23:51:23 +0200
Subject: [PATCH 3/4] kconfig: add alldefconfig

alldefconfig create a configuration with all values set
to their default value (form the Kconfig files).

This may be usefull when we try to use more sensible default
values and may also be used in combination with
the minimal defconfigs.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/kconfig.txt |    2 +-
 scripts/kconfig/Makefile         |    8 ++++++--
 scripts/kconfig/conf.c           |   28 ++++++++++++++++++----------
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index b2cb16e..cca46b1 100644
--- a/Documentation/kbuild/kconfig.txt
+++ b/Documentation/kbuild/kconfig.txt
@@ -65,7 +65,7 @@ also use the environment variable KCONFIG_ALLCONFIG as a flag or a
 filename that contains config symbols that the user requires to be
 set to a specific value.  If KCONFIG_ALLCONFIG is used without a
 filename, "make *config" checks for a file named
-"all{yes/mod/no/random}.config" (corresponding to the *config command
+"all{yes/mod/no/def/random}.config" (corresponding to the *config command
 that was used) for symbol values that are to be forced.  If this file
 is not found, it checks for a file named "all.config" to contain forced
 values.
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 7ea649d..366711a 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -95,7 +95,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	$(Q)rm -f arch/um/Kconfig.arch
 	$(Q)rm -f $(obj)/config.pot
 
-PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig
+PHONY += randconfig allyesconfig allnoconfig allmodconfig alldefconfig defconfig
 
 randconfig: $(obj)/conf
 	$< -r $(Kconfig)
@@ -109,6 +109,9 @@ allnoconfig: $(obj)/conf
 allmodconfig: $(obj)/conf
 	$< -m $(Kconfig)
 
+alldefconfig: $(obj)/conf
+	$< -f $(Kconfig)
+
 defconfig: $(obj)/conf
 ifeq ($(KBUILD_DEFCONFIG),)
 	$< -d $(Kconfig)
@@ -132,7 +135,8 @@ help:
 	@echo  '  localyesconfig  - Update current config converting local mods to core'
 	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
 	@echo  '  randconfig	  - New config with random answer to all options'
-	@echo  '  defconfig	  - New config with default answer to all options'
+	@echo  '  defconfig	  - New config with default from ARCH supplied defconfig'
+	@echo  '  alldefconfig    - New config with all symbols set to default'
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
 	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
 	@echo  '  allnoconfig	  - New config where all options are answered with no'
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 9960d1c..2b4775e 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -23,10 +23,11 @@ enum {
 	ask_all,
 	ask_new,
 	ask_silent,
-	set_default,
+	read_default,
 	set_yes,
 	set_mod,
 	set_no,
+	set_default,
 	set_random
 } input_mode = ask_all;
 char *defconfig_file;
@@ -439,7 +440,7 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
+	while ((opt = getopt(ac, av, "osdD:nmyfrh")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_silent;
@@ -449,10 +450,10 @@ int main(int ac, char **av)
 			sync_kconfig = 1;
 			break;
 		case 'd':
-			input_mode = set_default;
+			input_mode = read_default;
 			break;
 		case 'D':
-			input_mode = set_default;
+			input_mode = read_default;
 			defconfig_file = optarg;
 			break;
 		case 'n':
@@ -464,6 +465,9 @@ int main(int ac, char **av)
 		case 'y':
 			input_mode = set_yes;
 			break;
+		case 'f':
+			input_mode = set_default;
+			break;
 		case 'r':
 		{
 			struct timeval now;
@@ -512,7 +516,7 @@ int main(int ac, char **av)
 	}
 
 	switch (input_mode) {
-	case set_default:
+	case read_default:
 		if (!defconfig_file)
 			defconfig_file = conf_get_default_confname();
 		if (conf_read(defconfig_file)) {
@@ -537,10 +541,11 @@ int main(int ac, char **av)
 			break;
 		}
 		switch (input_mode) {
-		case set_no:	 name = "allno.config"; break;
-		case set_mod:	 name = "allmod.config"; break;
-		case set_yes:	 name = "allyes.config"; break;
-		case set_random: name = "allrandom.config"; break;
+		case set_no:	  name = "allno.config"; break;
+		case set_mod:	  name = "allmod.config"; break;
+		case set_yes:	  name = "allyes.config"; break;
+		case set_default: name = "alldefault.config"; break;
+		case set_random:  name = "allrandom.config"; break;
 		default: break;
 		}
 		if (!stat(name, &tmpstat))
@@ -574,10 +579,13 @@ int main(int ac, char **av)
 	case set_mod:
 		conf_set_all_new_symbols(def_mod);
 		break;
+	case set_default:
+		conf_set_all_new_symbols(def_default);
+		break;
 	case set_random:
 		conf_set_all_new_symbols(def_random);
 		break;
-	case set_default:
+	case read_default:
 		conf_set_all_new_symbols(def_default);
 		break;
 	case ask_new:
-- 
1.6.0.6

