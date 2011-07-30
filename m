Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1G3MeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 08:34:17 -0400
Received: from flawless.hostnac.com ([67.23.244.186]:42693 "EHLO
	flawless.hostnac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1G3MeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 08:34:12 -0400
X-Greylist: delayed 1489 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jul 2011 08:34:12 EDT
From: =?UTF-8?q?Rados=C5=82aw=20Smogura?= <mail@smogura.eu>
To: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org
Cc: =?UTF-8?q?Rados=C5=82aw=20Smogura?= <mail@smogura.eu>
Subject: [PATCH] Allows Kernel developer to change optimization options making code more debug friendly.
Date: Sat, 30 Jul 2011 14:33:54 +0200
Message-Id: <1312029234-14997-1-git-send-email-mail@smogura.eu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1312027749-10520-1-git-send-email-mail@smogura.eu>
References: <1312027749-10520-1-git-send-email-mail@smogura.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - flawless.hostnac.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - smogura.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New menu under kernel hacking allows to force "-01" optimization
and gives ability to discard additional optimizations (passed
with -O1). Options are added as "-f-no-..." to GCC invoke line.
This make cause to produce additional warnings, but makes compiled
code more debug friendly.

Included new Makefile and new KConfig has been automaticly generated
by simple bash script scripts/debug/make_config_optim.sh, which
is included to simple add or remove new options.

Some options are sepcific to GCC version.

Signed-off-by: Radosław Smogura <mail@smogura.eu>
---
 Makefile                           |   11 ++
 lib/Kconfig.debug                  |    2 +
 lib/Kconfig.debug.optim            |  214 ++++++++++++++++++++++++++++++++++++
 scripts/Makefile.optim.inc         |   55 +++++++++
 scripts/debug/make_config_optim.sh |   92 +++++++++++++++
 5 files changed, 374 insertions(+), 0 deletions(-)
 create mode 100644 lib/Kconfig.debug.optim
 create mode 100644 scripts/Makefile.optim.inc
 create mode 100644 scripts/debug/make_config_optim.sh

diff --git a/Makefile b/Makefile
index f676d15..1de2a79 100644
--- a/Makefile
+++ b/Makefile
@@ -558,12 +558,23 @@ endif # $(dot-config)
 # Defaults to vmlinux, but the arch makefile usually adds further targets
 all: vmlinux
 
+ifdef CONFIG_HACK_OPTIM_FORCE_O1_LEVEL
+KBUILD_CFLAGS += -O1
+else
+
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 KBUILD_CFLAGS	+= -Os
 else
 KBUILD_CFLAGS	+= -O2
 endif
 
+endif
+
+# Include makefile for optimization override
+ifdef CONFIG_HACK_OPTIM
+include $(srctree)/scripts/Makefile.optim.inc
+endif
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifneq ($(CONFIG_FRAME_WARN),0)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c0cb9c4..37976e4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1262,5 +1262,7 @@ source "lib/Kconfig.kgdb"
 
 source "lib/Kconfig.kmemcheck"
 
+source "lib/Kconfig.debug.optim"
+
 config TEST_KSTRTOX
 	tristate "Test kstrto*() family of functions at runtime"
diff --git a/lib/Kconfig.debug.optim b/lib/Kconfig.debug.optim
new file mode 100644
index 0000000..b5c8795
--- /dev/null
+++ b/lib/Kconfig.debug.optim
@@ -0,0 +1,214 @@
+# This file was auto generated. It's utility configuration
+# Distributed under GPL v2 License
+
+menuconfig HACK_OPTIM
+	bool "Allows overriding GCC optimizations"
+	depends on DEBUG_KERNEL && EXPERIMENTAL
+	help
+	  If you say Y here you will be able to override
+	  how GCC optimizes kernel code. This creates
+	  more debug-friendly code, but does not guarantee
+	  the same running code like a production kernel.
+
+	  If you say Y here probably you will want to say
+	  Y for all suboptions
+
+if HACK_OPTIM
+
+config HACK_OPTIM_FORCE_O1_LEVEL
+	bool "Forces -O1 optimization level"
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_inline_functions_called_once
+	bool "Adds -fno-inline-functions-called-once parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_combine_stack_adjustments
+	bool "Adds -fno-combine-stack-adjustments parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_tree_dce
+	bool "Adds -fno-tree-dce parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_tree_dominator_opts
+	bool "Adds -fno-tree-dominator-opts parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_dse
+	bool "Adds -fno-dse parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_dce
+	bool "Adds -fno-dce parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_auto_inc_dec
+	bool "Adds -fno-auto-inc-dec parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_inline_small_functions
+	bool "Adds -fno-inline-small-functions parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_if_conversion
+	bool "Adds -fno-if-conversion parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_if_conversion2
+	bool "Adds -fno-if-conversion2 parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_tree_fre
+	bool "Adds -fno-tree-fre parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_tree_dse
+	bool "Adds -fno-tree-dse parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+config HACK_OPTIM__fno_tree_sra
+	bool "Adds -fno-tree-sra parameter to gcc invoke line."
+	---help---
+	  This changes how GCC optimizes code. Code
+	  may be slower and larger but will be more debug
+	  "friendly".
+
+	  In some cases there is a low chance that the kernel
+	  will run differently than normal, reporting or not
+	  reporting some bugs or errors.
+	  Refer to GCC manual for more details.
+
+	  You SHOULD say N here.
+
+endif #HACK_OPTIM
diff --git a/scripts/Makefile.optim.inc b/scripts/Makefile.optim.inc
new file mode 100644
index 0000000..6e17d53
--- /dev/null
+++ b/scripts/Makefile.optim.inc
@@ -0,0 +1,55 @@
+# This file was auto generated. It's utility configuration
+# Distributed under GPL v2 License
+
+ifdef CONFIG_HACK_OPTIM__fno_inline_functions_called_once
+	KBUILD_CFLAGS += -fno-inline-functions-called-once
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_combine_stack_adjustments
+	KBUILD_CFLAGS += -fno-combine-stack-adjustments
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_tree_dce
+	KBUILD_CFLAGS += -fno-tree-dce
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_tree_dominator_opts
+	KBUILD_CFLAGS += -fno-tree-dominator-opts
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_dse
+	KBUILD_CFLAGS += -fno-dse
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_dce
+	KBUILD_CFLAGS += -fno-dce
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_auto_inc_dec
+	KBUILD_CFLAGS += -fno-auto-inc-dec
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_inline_small_functions
+	KBUILD_CFLAGS += -fno-inline-small-functions
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_if_conversion
+	KBUILD_CFLAGS += -fno-if-conversion
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_if_conversion2
+	KBUILD_CFLAGS += -fno-if-conversion2
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_tree_fre
+	KBUILD_CFLAGS += -fno-tree-fre
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_tree_dse
+	KBUILD_CFLAGS += -fno-tree-dse
+endif
+
+ifdef CONFIG_HACK_OPTIM__fno_tree_sra
+	KBUILD_CFLAGS += -fno-tree-sra
+endif
+
diff --git a/scripts/debug/make_config_optim.sh b/scripts/debug/make_config_optim.sh
new file mode 100644
index 0000000..44736d7
--- /dev/null
+++ b/scripts/debug/make_config_optim.sh
@@ -0,0 +1,92 @@
+#!/bin/sh
+
+## Utility script for generating optimization override options
+## for kernel compilation.
+##
+## Distributed under GPL v2 license
+## (c) Radosław Smogura, 2011
+
+# Prefix added for variable
+CFG_PREFIX="HACK_OPTIM"
+
+KCFG="Kconfig.debug.optim"
+MKFI="Makefile.optim.inc"
+
+OPTIMIZATIONS_PARAMS="-fno-inline-functions-called-once \
+ -fno-combine-stack-adjustments \
+ -fno-tree-dce \
+ -fno-tree-dominator-opts \
+ -fno-dse \
+ -fno-dce \
+ -fno-auto-inc-dec \
+ -fno-inline-small-functions \
+ -fno-if-conversion \
+ -fno-if-conversion2 \
+ -fno-tree-fre \
+ -fno-tree-dse \
+ -fno-tree-sra
+"
+
+function printStandardHelp() {
+    echo -e "\t  This changes how GCC optimizes code. Code"           >> $KCFG
+    echo -e "\t  may be slower and larger but will be more debug"     >> $KCFG
+    echo -e "\t  \"friendly\"."                                       >> $KCFG
+    echo                                                              >> $KCFG
+    echo -e "\t  In some cases there is a low chance that the kernel" >> $KCFG
+    echo -e "\t  will run differently than normal, reporting or not"  >> $KCFG
+    echo -e "\t  reporting some bugs or errors."                      >> $KCFG
+    echo -e "\t  Refer to GCC manual for more details."               >> $KCFG
+    echo                                                              >> $KCFG
+    echo -e "\t  You SHOULD say N here."                              >> $KCFG
+}
+
+echo "# This file was auto generated. It's utility configuration" > $KCFG
+echo "# Distributed under GPL v2 License" >> $KCFG
+echo >> $KCFG
+echo "menuconfig ${CFG_PREFIX}"                                >> $KCFG
+echo -e "\tbool \"Allows overriding GCC optimizations\""       >> $KCFG
+echo -e "\tdepends on DEBUG_KERNEL && EXPERIMENTAL"            >> $KCFG
+echo -e "\thelp"                                               >> $KCFG
+echo -e "\t  If you say Y here you will be able to override"   >> $KCFG
+echo -e "\t  how GCC optimizes kernel code. This creates"      >> $KCFG
+echo -e "\t  more debug-friendly code, but does not guarantee" >> $KCFG
+echo -e "\t  the same running code like a production kernel."  >> $KCFG
+echo                                                           >> $KCFG
+echo -e "\t  If you say Y here probably you will want to say"  >> $KCFG
+echo -e "\t  Y for all suboptions"                             >> $KCFG
+echo >> $KCFG
+echo "if ${CFG_PREFIX}" >> $KCFG
+echo >> $KCFG
+
+echo "# This file was auto generated. It's utility configuration" > $MKFI
+echo "# Distributed under GPL v2 License" >> $MKFI
+echo >> $MKFI
+
+# Insert standard override optimization level
+# This is exception, and this value will not be included
+# in auto generated makefile. Support for this value
+# is hard coded in main Makefile.
+echo -e "config ${CFG_PREFIX}_FORCE_O1_LEVEL" >> $KCFG
+echo -e "\tbool \"Forces -O1 optimization level\"" >> $KCFG
+echo -e "\t---help---" >> $KCFG
+printStandardHelp;
+echo >> $KCFG
+
+for o in $OPTIMIZATIONS_PARAMS ; do
+	cfg_o="${CFG_PREFIX}_${o//-/_}";
+	echo "Processing param ${o} config variable will be $cfg_o";
+
+	# Generate kconfig entry
+	echo -e "config ${cfg_o}" >> $KCFG
+	echo -e "\tbool \"Adds $o parameter to gcc invoke line.\"" >> $KCFG
+	echo -e "\t---help---" >> $KCFG
+	printStandardHelp;
+	echo >> $KCFG
+
+	#Generate Make for include
+	echo "ifdef CONFIG_${cfg_o}" >> $MKFI
+	echo -e "\tKBUILD_CFLAGS += $o" >> $MKFI
+	echo "endif" >> $MKFI
+	echo  >> $MKFI
+done;
+echo "endif #${CFG_PREFIX}" >> $KCFG
-- 
1.7.3.4

