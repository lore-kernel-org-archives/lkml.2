Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2EEITy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:19:54 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:29979 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2EEISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:18:50 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH 7/8] kbuild: move W=... stuff to Kbuild.arch
Date: Sat,  5 May 2012 10:18:45 +0200
Message-Id: <1336205926-13946-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20120505080640.GA13773@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent that we eveluate cc-option multiple times for the same
option by moving the definitions to Kbuild.arch.
The file is included once only, thus gcc is not invoked once per directory.

Another side-effect of this patch is that KCFLAGS are appended last
to the list of options. This allows us to better control the options.
Artem Bityutskiy <dedekind1@gmail.com> noticed this.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
---
 scripts/Kbuild.arch    |   51 +++++++++++++++++++++++++++++++++++++++++++++++-
 scripts/Makefile.build |   51 ------------------------------------------------
 2 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/scripts/Kbuild.arch b/scripts/Kbuild.arch
index 230050f..6ff27c6 100644
--- a/scripts/Kbuild.arch
+++ b/scripts/Kbuild.arch
@@ -76,6 +76,56 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
         KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
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
@@ -103,4 +153,3 @@ LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
 ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
         LDFLAGS_vmlinux += $(call ld-option, -X,)
 endif
-
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
1.6.0.6

