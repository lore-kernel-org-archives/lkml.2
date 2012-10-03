Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2JCLWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:22:22 -0400
Received: from mout.web.de ([212.227.15.3]:55188 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab2JCLWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:11 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 01/13] scripts/gdb: Add infrastructure
Date: Wed,  3 Oct 2012 13:21:32 +0200
Message-Id: <2b3ac2a0c24a33d9b9d1ff66eb842c64d369afa5.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:ey8dD8pA6Pa9pJWyHwP/KIt+G4TotFTUjxwEUJ43r4l
 52DyB3RspH6tLNtEbqWWLzBqFuXwOHEfEdUpfovNAJ+TxpHx69
 zT1JYzScdvOev/yPee7hZc5eCLhwnl6e5Is0Azt8ZvQnBiKGMC
 3T+nUkBrVVrTP4p2L1PB97DWnvxUKdqxjqJgVeYKkL2kIH/wvV
 X9tUOHB9t1U9sMH3ZCSPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This provides the basic infrastructure to load kernel-specific python
helper scripts when debugging the kernel in gdb.

The loading mechanism is based on gdb loading for <objfile>-gdb.py when
opening <objfile>. Therefore, this places a corresponding link to the
main helper script into the output directory that contains vmlinux.

The main scripts will pull in submodules containing Linux specific gdb
commands and functions. To avoid polluting the source directory with
compiled python modules, we link to them from the object directory.

Due to gdb.parse_and_eval, we depend on gdb >= 7.1.

This feature depends on CONFIG_DEBUG_INFO.

CC: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 Makefile                   |    6 +++++-
 scripts/Makefile           |    3 ++-
 scripts/gdb/Makefile       |    9 +++++++++
 scripts/gdb/vmlinux-gdb.py |   20 ++++++++++++++++++++
 4 files changed, 36 insertions(+), 2 deletions(-)
 create mode 100644 scripts/gdb/Makefile
 create mode 100644 scripts/gdb/vmlinux-gdb.py

diff --git a/Makefile b/Makefile
index a3c11d5..a382927 100644
--- a/Makefile
+++ b/Makefile
@@ -758,6 +758,9 @@ endif
 ifdef CONFIG_BUILD_DOCSRC
 	$(Q)$(MAKE) $(build)=Documentation
 endif
+ifdef CONFIG_DEBUG_INFO
+	$(Q)ln -fsn $(srctree)/scripts/gdb/vmlinux-gdb.py
+endif
 	+$(call if_changed,link-vmlinux)
 
 # The actual objects are generated when descending, 
@@ -995,7 +998,8 @@ MRPROPER_DIRS  += include/config usr/include include/generated          \
                   arch/*/include/generated
 MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/version.h                               \
-		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
+		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
+		  vmlinux-gdb.py
 
 # clean - Delete most, but leave enough to build external modules
 #
diff --git a/scripts/Makefile b/scripts/Makefile
index a55b006..47f3d51 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -35,6 +35,7 @@ subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_DTC)         += dtc
+subdir-$(CONFIG_DEBUG_INFO)  += gdb
 
 # Let clean descend into subdirs
-subdir-	+= basic kconfig package selinux
+subdir-	+= basic kconfig package selinux gdb
diff --git a/scripts/gdb/Makefile b/scripts/gdb/Makefile
new file mode 100644
index 0000000..34ccd06
--- /dev/null
+++ b/scripts/gdb/Makefile
@@ -0,0 +1,9 @@
+always := gdb-scripts
+
+$(obj)/gdb-scripts:
+ifneq ($(KBUILD_SRC),)
+	$(Q)ln -fsn $(srctree)/$(obj)/*.py $(objtree)/$(obj)
+endif
+	@:
+
+clean-files := *.pyc $(if $(KBUILD_SRC),*.py)
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
new file mode 100644
index 0000000..00df617
--- /dev/null
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -0,0 +1,20 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  loader module
+#
+# Copyright (c) 2012 Siemens AG
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import os
+
+sys.path = [ os.path.dirname(__file__) + "/scripts/gdb" ] + sys.path
+
+if not gdb.VERSION >= "7.1":
+	print "NOTE: gdb 7.1 or later required for Linux helper scripts " \
+	      "to work."
-- 
1.7.3.4

