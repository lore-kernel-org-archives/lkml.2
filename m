Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2KROdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:33:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36585 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2KROaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/32] tools: Honour the O= flag when tool build called from a higher Makefile
Date: Sun, 18 Nov 2012 11:29:54 -0300
Message-Id: <1353248997-30763-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Honour the O= flag that was passed to a higher level Makefile and then passed
down as part of a tool build.

To make this work, the top-level Makefile passes the original O= flag and
subdir=tools to the tools/Makefile, and that in turn passes
subdir=$(O)/$(subdir)/foodir when building tool foo in directory
$(O)/$(subdir)/foodir (where the intervening slashes aren't added if an
element is missing).

For example, take perf.  This is found in tools/perf/.  Assume we're building
into directory ~/zebra/, so we pass O=~/zebra to make.  Dependening on where
we run the build from, we see:

	make run in dir		$(OUTPUT) dir
	=======================	==================
	linux			~/zebra/tools/perf/
	linux/tools		~/zebra/perf/
	linux/tools/perf	~/zebra/

and if O= is not set, we get:

	make run in dir		$(OUTPUT) dir
	=======================	==================
	linux			linux/tools/perf/
	linux/tools		linux/tools/perf/
	linux/tools/perf	linux/tools/perf/

The output directories are created by the descend function if they don't
already exist.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1378.1352379110@warthog.procyon.org.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Makefile                       |    6 ++++--
 tools/scripts/Makefile.include |   17 +++++++++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 14c93b3..08a31d8 100644
--- a/Makefile
+++ b/Makefile
@@ -1321,10 +1321,12 @@ kernelversion:
 
 # Clear a bunch of variables before executing the submake
 tools/: FORCE
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
+	$(Q)mkdir -p $(objtree)/tools
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/
 
 tools/%: FORCE
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
+	$(Q)mkdir -p $(objtree)/tools
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/ $*
 
 # Single targets
 # ---------------------------------------------------------------------------
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 4a9e317..87467b1 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,8 +1,11 @@
-ifeq ("$(origin O)", "command line")
+ifeq ($(origin O), command line)
 	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
 	ABSOLUTE_O := $(shell cd $(O) ; pwd)
-	OUTPUT := $(ABSOLUTE_O)/
+	OUTPUT := $(ABSOLUTE_O)/$(if $(subdir),$(subdir)/)
 	COMMAND_O := O=$(ABSOLUTE_O)
+ifeq ($(objtree),)
+	objtree := $(O)
+endif
 endif
 
 ifneq ($(OUTPUT),)
@@ -47,9 +50,10 @@ endif
 # Call by doing: $(call descend,directory[,target])
 #
 descend = \
-	$(QUIET_SUBDIR0)$(1) $(QUIET_SUBDIR1) $(2)
+	+mkdir -p $(OUTPUT)$(1) && \
+	$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1)
 
-QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
@@ -64,5 +68,10 @@ ifndef V
 			 $(MAKE) $(PRINT_DIR) -C $$subdir
 	QUIET_FLEX     = @echo '   ' FLEX $@;
 	QUIET_BISON    = @echo '   ' BISON $@;
+
+	descend = \
+		@echo '   ' DESCEND $(1); \
+		mkdir -p $(OUTPUT)$(1) && \
+		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1)
 endif
 endif
-- 
1.7.9.2.358.g22243

