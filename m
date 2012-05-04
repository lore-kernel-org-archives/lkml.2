Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2EDHlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:41:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:41686 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab2EDHll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:41:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96298507"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/2] Makefile: make sure KCFLAGS options are at the end
Date: Fri,  4 May 2012 10:42:34 +0300
Message-Id: <1336117355-21348-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

When I build the kernel like this:

$ make W=1 KCFLAGS="-Wno-sign-compare"

the "-Wno-sign-compare" option is ignore. The reason is that we append gcc
options associated with W=1 _after_ KCFLAGS, so W=1 overrides my KCFLAGS
options. This patch tries to fix the issue by moving the "W=[123]" stiff
from "scripts/Makefile.build" to the main Maikefile. This fixes the issue
as well as this should be a small improvent because "scripts/Makefile.build"
is parsed by make many times (I think for each file), bue we do not need
to re-assign all the warnings stuff so many times - it is enough to do it
only once.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 Makefile               |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/Makefile.build |   51 ------------------------------------------------
 2 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/Makefile b/Makefile
index afc868e..2cba5db 100644
--- a/Makefile
+++ b/Makefile
@@ -640,6 +640,57 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
+#
+# make W=... settings
+#
+# W=1 - warnings that may be relevant and does not occur too often
+# W=2 - warnings that occur quite often but may still be relevant
+# W=3 - the more obscure warnings, can most likely be ignored
+#
+# $(call cc-option, -W...) handles gcc -W.. options which
+# are not supported by all versions of the compiler
+ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
+warning-  := $(empty)
+
+warning-1 := -Wextra -Wunused -Wno-unused-parameter
+warning-1 += -Wmissing-declarations
+warning-1 += -Wmissing-format-attribute
+warning-1 += -Wmissing-prototypes
+warning-1 += -Wold-style-definition
+warning-1 += $(call cc-option, -Wmissing-include-dirs)
+warning-1 += $(call cc-option, -Wunused-but-set-variable)
+warning-1 += $(call cc-disable-warning, missing-field-initializers)
+
+warning-2 := -Waggregate-return
+warning-2 += -Wcast-align
+warning-2 += -Wdisabled-optimization
+warning-2 += -Wnested-externs
+warning-2 += -Wshadow
+warning-2 += $(call cc-option, -Wlogical-op)
+warning-2 += $(call cc-option, -Wmissing-field-initializers)
+
+warning-3 := -Wbad-function-cast
+warning-3 += -Wcast-qual
+warning-3 += -Wconversion
+warning-3 += -Wpacked
+warning-3 += -Wpadded
+warning-3 += -Wpointer-arith
+warning-3 += -Wredundant-decls
+warning-3 += -Wswitch-default
+warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
+warning-3 += $(call cc-option, -Wvla)
+
+warning := $(warning-$(findstring 1, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
+warning += $(warning-$(findstring 2, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
+warning += $(warning-$(findstring 3, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
+
+ifeq ("$(strip $(warning))","")
+        $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
+endif
+
+KBUILD_CFLAGS += $(warning)
+endif
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so
 warn-assign = \
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index ff1720d..f8681cc 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -50,57 +50,6 @@ ifeq ($(KBUILD_NOPEDANTIC),)
         endif
 endif
 
-#
-# make W=... settings
-#
-# W=1 - warnings that may be relevant and does not occur too often
-# W=2 - warnings that occur quite often but may still be relevant
-# W=3 - the more obscure warnings, can most likely be ignored
-#
-# $(call cc-option, -W...) handles gcc -W.. options which
-# are not supported by all versions of the compiler
-ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
-warning-  := $(empty)
-
-warning-1 := -Wextra -Wunused -Wno-unused-parameter
-warning-1 += -Wmissing-declarations
-warning-1 += -Wmissing-format-attribute
-warning-1 += -Wmissing-prototypes
-warning-1 += -Wold-style-definition
-warning-1 += $(call cc-option, -Wmissing-include-dirs)
-warning-1 += $(call cc-option, -Wunused-but-set-variable)
-warning-1 += $(call cc-disable-warning, missing-field-initializers)
-
-warning-2 := -Waggregate-return
-warning-2 += -Wcast-align
-warning-2 += -Wdisabled-optimization
-warning-2 += -Wnested-externs
-warning-2 += -Wshadow
-warning-2 += $(call cc-option, -Wlogical-op)
-warning-2 += $(call cc-option, -Wmissing-field-initializers)
-
-warning-3 := -Wbad-function-cast
-warning-3 += -Wcast-qual
-warning-3 += -Wconversion
-warning-3 += -Wpacked
-warning-3 += -Wpadded
-warning-3 += -Wpointer-arith
-warning-3 += -Wredundant-decls
-warning-3 += -Wswitch-default
-warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
-warning-3 += $(call cc-option, -Wvla)
-
-warning := $(warning-$(findstring 1, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
-warning += $(warning-$(findstring 2, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
-warning += $(warning-$(findstring 3, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
-
-ifeq ("$(strip $(warning))","")
-        $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
-endif
-
-KBUILD_CFLAGS += $(warning)
-endif
-
 include scripts/Makefile.lib
 
 ifdef host-progs
-- 
1.7.9.1

