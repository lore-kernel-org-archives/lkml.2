Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1DVHiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 03:38:07 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39641 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1DVHiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 03:38:03 -0400
Date: Fri, 22 Apr 2011 09:38:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: [RFC PATCH v2] kbuild: implement several W= levels
Message-ID: <20110422073800.GA20603@merkur.ravnborg.org>
References: <20110421213903.GB9660@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421213903.GB9660@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7f1edfc13eadc1cf8c80d72ff850a121bf472e00 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 22 Apr 2011 08:22:25 +0200
Subject: [PATCH] kbuild: implement several W= levels

Building a kernel with "make W=1" produce far too much noise
to be usefull.

Divide the warning options in three groups:

    W=1 - warnings that may be relevant and does not occur too often
    W=2 - warnings that occur quite often but may still be relevant
    W=3 - the more obscure warnings, can most likely be ignored

When building init/ on my box the levels produces:

W=1 - 46 warnings
W=2 - 863 warnings
W=3 - 6496 warnings

Many warnings occur from .h files so fixing one file may have a nice
effect on the total number of warnings.

With these changes I am actually tempted to try W=1 now and then.
Previously there were just too much noise.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Jones <davej@redhat.com>
---
This is based on top of -linus to make it easy to test.
But I included fixes for older gcc as posted in a separate patch.

Changes since v1:
- updated help text
- updated grouping, less warnings in W=1
- reimplment selection of warnings for the individual levels
- added a comment describing the individual levels

	Sam


 Makefile               |    4 +-
 scripts/Makefile.build |   69 +++++++++++++++++++++++++++++------------------
 2 files changed, 44 insertions(+), 29 deletions(-)

diff --git a/Makefile b/Makefile
index b967b96..37a6062 100644
--- a/Makefile
+++ b/Makefile
@@ -103,7 +103,7 @@ ifeq ("$(origin O)", "command line")
 endif
 
 ifeq ("$(origin W)", "command line")
-  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := 1
+  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := $(W)
 endif
 
 # That's our default target when none is given on the command line
@@ -1267,7 +1267,7 @@ help:
 	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
-	@echo  '  make W=1   [targets] Enable extra gcc checks'
+	@echo  '  make W=n   [targets] Enable extra gcc checks, n=1,2,3'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..6874c3b 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -51,36 +51,51 @@ ifeq ($(KBUILD_NOPEDANTIC),)
 endif
 
 #
-# make W=1 settings
+# make W=... settings
 #
-# $(call cc-option... ) handles gcc -W.. options which
+# W=1 - warnings that may be relevant and does not occur too often
+# W=2 - warnings that occur quite often but may still be relevant
+# W=3 - the more obscure warnings, can most likely be ignored
+#
+# $(call cc-option, -W...) handles gcc -W.. options which
 # are not supported by all versions of the compiler
 ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
-KBUILD_EXTRA_WARNINGS := -Wextra
-KBUILD_EXTRA_WARNINGS += -Wunused -Wno-unused-parameter
-KBUILD_EXTRA_WARNINGS += -Waggregate-return
-KBUILD_EXTRA_WARNINGS += -Wbad-function-cast
-KBUILD_EXTRA_WARNINGS += -Wcast-qual
-KBUILD_EXTRA_WARNINGS += -Wcast-align
-KBUILD_EXTRA_WARNINGS += -Wconversion
-KBUILD_EXTRA_WARNINGS += -Wdisabled-optimization
-KBUILD_EXTRA_WARNINGS += -Wlogical-op
-KBUILD_EXTRA_WARNINGS += -Wmissing-declarations
-KBUILD_EXTRA_WARNINGS += -Wmissing-format-attribute
-KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wmissing-include-dirs,)
-KBUILD_EXTRA_WARNINGS += -Wmissing-prototypes
-KBUILD_EXTRA_WARNINGS += -Wnested-externs
-KBUILD_EXTRA_WARNINGS += -Wold-style-definition
-KBUILD_EXTRA_WARNINGS += $(call cc-option, -Woverlength-strings,)
-KBUILD_EXTRA_WARNINGS += -Wpacked
-KBUILD_EXTRA_WARNINGS += -Wpacked-bitfield-compat
-KBUILD_EXTRA_WARNINGS += -Wpadded
-KBUILD_EXTRA_WARNINGS += -Wpointer-arith
-KBUILD_EXTRA_WARNINGS += -Wredundant-decls
-KBUILD_EXTRA_WARNINGS += -Wshadow
-KBUILD_EXTRA_WARNINGS += -Wswitch-default
-KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wvla,)
-KBUILD_CFLAGS += $(KBUILD_EXTRA_WARNINGS)
+warning-1 := -Wextra
+warning-1 += -Wunused -Wno-unused-parameter
+warning-1 += -Wmissing-declarations
+warning-1 += -Wmissing-format-attribute
+warning-1 += -Wmissing-prototypes
+warning-1 += -Wnested-externs
+warning-1 += $(call cc-option, -Wmissing-include-dirs)
+
+warning-2 := $(warning-1)
+warning-2 += -Waggregate-return
+warning-2 += -Wbad-function-cast
+warning-2 += -Wcast-qual
+warning-2 += -Wcast-align
+warning-2 += -Wdisabled-optimization
+warning-2 += -Wold-style-definition
+warning-2 += -Wshadow
+warning-2 += $(call cc-option, -Wlogical-op)
+warning-2 += $(call cc-option, -Woverlength-strings)
+
+warning-3 := $(warning-2)
+warning-3 += -Wconversion
+warning-3 += -Wpacked
+warning-3 += -Wpadded
+warning-3 += -Wpointer-arith
+warning-3 += -Wredundant-decls
+warning-3 += -Wswitch-default
+warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
+warning-3 += $(call cc-option, -Wvla)
+
+warning := $(warning-$(KBUILD_ENABLE_EXTRA_GCC_CHECKS))
+
+ifeq ("$(warning)","")
+        $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
+endif
+
+KBUILD_CFLAGS += $(warning)
 endif
 
 include scripts/Makefile.lib
-- 
1.6.0.6

