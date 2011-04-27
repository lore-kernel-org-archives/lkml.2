Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1D0UPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:15:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32816 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab1D0UPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:15:33 -0400
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Jones <davej@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3.2] kbuild: implement several W= levels
Date: Wed, 27 Apr 2011 22:15:27 +0200
Message-Id: <1303935327-5154-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.5.rc1.16.g9db1
In-Reply-To: <20110427113513.GB18112@eferding.osrc.amd.com>
References: <20110427113513.GB18112@eferding.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

Building a kernel with "make W=1" produces far too much noise to be
useful.

Divide the warning options in three groups:

    W=1 - warnings that may be relevant and does not occur too often
    W=2 - warnings that occur quite often but may still be relevant
    W=3 - the more obscure warnings, can most likely be ignored

When building the whole kernel, those levels produce:

W=1 - 4859 warnings
W=2 - 1394 warnings
W=3 - 86666 warnings

respectively. Warnings have been counted with Geert's script at

http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/linux-log-summary.pl

Many warnings occur from .h files so fixing one file may have a nice
effect on the total number of warnings.

With these changes I am actually tempted to try W=1 now and then.
Previously there was just too much noise.

Borislav:

- make the W= levels exclusive
- move very noisy and making little sense for the kernel warnings to W=3
- drop -Woverlength-strings due to useless warning message
- copy explanatory text for the different warning levels to 'make help'
- recount warnings per level

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Borislav Petkov <bp@alien8.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Makefile               |    8 ++++-
 scripts/Makefile.build |   65 ++++++++++++++++++++++++++++--------------------
 2 files changed, 44 insertions(+), 29 deletions(-)

diff --git a/Makefile b/Makefile
index 5a7a2e4..b2a6808 100644
--- a/Makefile
+++ b/Makefile
@@ -103,7 +103,7 @@ ifeq ("$(origin O)", "command line")
 endif
 
 ifeq ("$(origin W)", "command line")
-  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := 1
+  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := $(W)
 endif
 
 # That's our default target when none is given on the command line
@@ -1267,7 +1267,11 @@ help:
 	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
-	@echo  '  make W=1   [targets] Enable extra gcc checks'
+	@echo  '  make W=n   [targets] Enable extra gcc checks, n=1,2,3 where'
+	@echo  '		1: warnings which may be relevant and do not occur too often'
+	@echo  '		2: warnings which occur quite often but may still be relevant'
+	@echo  '		3: more obscure warnings, can most likely be ignored'
+
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..ffb383c 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -51,36 +51,47 @@ ifeq ($(KBUILD_NOPEDANTIC),)
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
+warning-1 := -Wextra -Wunused -Wno-unused-parameter
+warning-1 += -Wmissing-declarations
+warning-1 += -Wmissing-format-attribute
+warning-1 += -Wmissing-prototypes
+warning-1 += -Wold-style-definition
+warning-1 += $(call cc-option, -Wmissing-include-dirs)
+
+warning-2 := -Waggregate-return
+warning-2 += -Wcast-align
+warning-2 += -Wdisabled-optimization
+warning-2 += -Wnested-externs
+warning-2 += -Wshadow
+warning-2 += $(call cc-option, -Wlogical-op)
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
1.7.5.rc1.16.g9db1

