Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab2DKVHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:07:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:45988 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761289Ab2DKVFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:05:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/13] tools: Add Makefile.include
Date: Wed, 11 Apr 2012 18:05:14 -0300
Message-Id: <1334178325-19148-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334178325-19148-1-git-send-email-acme@infradead.org>
References: <1334178325-19148-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Put generic enough build settings which could be reused by other tools
into a common Makefile.include file.

This commit reintroduces QUIET_SUBDIR{0,1} (see a3d1ee10d1bf) which are
going to be used in the following patches.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/1334162178-17152-2-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile            |   47 +--------------------------------
 tools/scripts/Makefile.include |   57 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 46 deletions(-)
 create mode 100644 tools/scripts/Makefile.include

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 820371f..4ca77cc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,18 +1,10 @@
-ifeq ("$(origin O)", "command line")
-	OUTPUT := $(O)/
-endif
+include ../scripts/Makefile.include
 
 # The default target of this Makefile is...
 all:
 
 include config/utilities.mak
 
-ifneq ($(OUTPUT),)
-# check that the output directory actually exists
-OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
-$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
-endif
-
 # Define V to have a more verbose compile.
 #
 # Define O to save output files in a separate directory.
@@ -84,31 +76,6 @@ ifneq ($(WERROR),0)
 	CFLAGS_WERROR := -Werror
 endif
 
-#
-# Include saner warnings here, which can catch bugs:
-#
-
-EXTRA_WARNINGS := -Wformat
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
-
 ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
@@ -679,18 +646,6 @@ else
 	endif
 endif
 
-ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
-	QUIET_CC       = @echo '   ' CC $@;
-	QUIET_AR       = @echo '   ' AR $@;
-	QUIET_LINK     = @echo '   ' LINK $@;
-	QUIET_MKDIR    = @echo '   ' MKDIR $@;
-	QUIET_GEN      = @echo '   ' GEN $@;
-	QUIET_FLEX     = @echo '   ' FLEX $@;
-	QUIET_BISON    = @echo '   ' BISON $@;
-endif
-endif
-
 ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
new file mode 100644
index 0000000..52348d3
--- /dev/null
+++ b/tools/scripts/Makefile.include
@@ -0,0 +1,57 @@
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+endif
+
+ifneq ($(OUTPUT),)
+# check that the output directory actually exists
+OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
+$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
+endif
+
+#
+# Include saner warnings here, which can catch bugs:
+#
+EXTRA_WARNINGS := -Wformat
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
+
+ifneq ($(findstring $(MAKEFLAGS), w),w)
+PRINT_DIR = --no-print-directory
+else
+NO_SUBDIR = :
+endif
+
+QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR1  =
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifndef V
+	QUIET_CC       = @echo '   ' CC $@;
+	QUIET_AR       = @echo '   ' AR $@;
+	QUIET_LINK     = @echo '   ' LINK $@;
+	QUIET_MKDIR    = @echo '   ' MKDIR $@;
+	QUIET_GEN      = @echo '   ' GEN $@;
+	QUIET_SUBDIR0  = +@subdir=
+	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+			 $(MAKE) $(PRINT_DIR) -C $$subdir
+	QUIET_FLEX     = @echo '   ' FLEX $@;
+	QUIET_BISON    = @echo '   ' BISON $@;
+endif
+endif
-- 
1.7.9.2.358.g22243

