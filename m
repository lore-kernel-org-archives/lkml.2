Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab0GaVhH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:37:07 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40620 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab0GaVfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:35:38 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 6/9] kconfig: add alldefconfig
Date: Sat, 31 Jul 2010 23:35:31 +0200
Message-Id: <1280612134-8220-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100731213429.GA8200@merkur.ravnborg.org>
References: <20100731213429.GA8200@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alldefconfig create a configuration with all values set
to their default value (form the Kconfig files).

This may be useful when we try to use more sensible default
values and may also be used in combination with
the minimal defconfigs.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/kconfig.txt |    2 +-
 scripts/kconfig/Makefile         |   13 +++++++------
 scripts/kconfig/conf.c           |    7 +++++++
 3 files changed, 15 insertions(+), 7 deletions(-)

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
index 2900d11..0bf1fb6 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -95,9 +95,9 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	$(Q)rm -f arch/um/Kconfig.arch
 	$(Q)rm -f $(obj)/config.pot
 
-PHONY += allnoconfig allyesconfig allmodconfig randconfig
+PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
 
-allnoconfig allyesconfig allmodconfig randconfig: $(obj)/conf
+allnoconfig allyesconfig allmodconfig alldefconfig randconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
 PHONY += listnewconfig oldnoconfig defconfig
@@ -127,11 +127,12 @@ help:
 	@echo  '  localmodconfig  - Update current config disabling modules not loaded'
 	@echo  '  localyesconfig  - Update current config converting local mods to core'
 	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
-	@echo  '  randconfig	  - New config with random answer to all options'
-	@echo  '  defconfig	  - New config with default answer to all options'
-	@echo  '  allmodconfig	  - New config selecting modules when possible'
-	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
+	@echo  '  defconfig	  - New config with default from ARCH supplied defconfig'
 	@echo  '  allnoconfig	  - New config where all options are answered with no'
+	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
+	@echo  '  allmodconfig	  - New config selecting modules when possible'
+	@echo  '  alldefconfig    - New config with all symbols set to default'
+	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  listnewconfig   - List new options'
 	@echo  '  oldnoconfig     - Same as silentoldconfig but set new symbols to n (unset)'
 
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index ff5c914..c8bd33c 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -27,6 +27,7 @@ enum input_mode {
 	allnoconfig,
 	allyesconfig,
 	allmodconfig,
+	alldefconfig,
 	randconfig,
 	defconfig,
 	listnewconfig,
@@ -446,6 +447,7 @@ static struct option long_opts[] = {
 	{"allnoconfig",     no_argument,       NULL, allnoconfig},
 	{"allyesconfig",    no_argument,       NULL, allyesconfig},
 	{"allmodconfig",    no_argument,       NULL, allmodconfig},
+	{"alldefconfig",    no_argument,       NULL, alldefconfig},
 	{"randconfig",      no_argument,       NULL, randconfig},
 	{"listnewconfig",   no_argument,       NULL, listnewconfig},
 	{"oldnoconfig",     no_argument,       NULL, oldnoconfig},
@@ -534,6 +536,7 @@ int main(int ac, char **av)
 	case allnoconfig:
 	case allyesconfig:
 	case allmodconfig:
+	case alldefconfig:
 	case randconfig:
 		name = getenv("KCONFIG_ALLCONFIG");
 		if (name && !stat(name, &tmpstat)) {
@@ -544,6 +547,7 @@ int main(int ac, char **av)
 		case allnoconfig:	name = "allno.config"; break;
 		case allyesconfig:	name = "allyes.config"; break;
 		case allmodconfig:	name = "allmod.config"; break;
+		case alldefconfig:	name = "alldef.config"; break;
 		case randconfig:	name = "allrandom.config"; break;
 		default: break;
 		}
@@ -578,6 +582,9 @@ int main(int ac, char **av)
 	case allmodconfig:
 		conf_set_all_new_symbols(def_mod);
 		break;
+	case alldefconfig:
+		conf_set_all_new_symbols(def_default);
+		break;
 	case randconfig:
 		conf_set_all_new_symbols(def_random);
 		break;
-- 
1.6.0.6

