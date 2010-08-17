Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab0HQVxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:53:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:33825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0HQVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:52:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Bernd Petrovitsch <bernd@sysprog.at>,
        Ingo Molnar <mingo@elte.hu>, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf tools: Fix build on POSIX shells
Date: Tue, 17 Aug 2010 18:52:38 -0300
Message-Id: <1282081958-22323-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1282081958-22323-1-git-send-email-acme@infradead.org>
References: <1282081958-22323-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Petrovitsch <bernd@sysprog.at>

POSIX sh does not specify the brace expansion, so fix it by replacing the
global $(shell ...) lines quite at the top creating the output directories with
real rules.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1282046280.5822.4.camel@thorin>
Signed-off-by: Bernd Petrovitsch <bernd@sysprog.at>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 41abb90..dcb9700 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -157,10 +157,6 @@ all::
 #
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 
-$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
-$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)
-$(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
-
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 -include $(OUTPUT)PERF-VERSION-FILE
@@ -186,8 +182,6 @@ ifeq ($(ARCH),x86_64)
         ARCH := x86
 endif
 
-$(shell sh -c 'mkdir -p $(OUTPUT)arch/$(ARCH)/util/' 2> /dev/null)
-
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 #
@@ -268,6 +262,7 @@ export prefix bindir sharedir sysconfdir
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 RM = rm -f
+MKDIR = mkdir
 TAR = tar
 FIND = find
 INSTALL = install
@@ -838,6 +833,7 @@ ifndef V
 	QUIET_CC       = @echo '   ' CC $@;
 	QUIET_AR       = @echo '   ' AR $@;
 	QUIET_LINK     = @echo '   ' LINK $@;
+	QUIET_MKDIR    = @echo '   ' MKDIR $@;
 	QUIET_BUILT_IN = @echo '   ' BUILTIN $@;
 	QUIET_GEN      = @echo '   ' GEN $@;
 	QUIET_SUBDIR0  = +@subdir=
@@ -1012,6 +1008,14 @@ $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%$X,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 builtin-revert.o wt-status.o: wt-status.h
 
+# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
+# we depend the various files onto their directories.
+DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
+$(DIRECTORY_DEPS): $(sort $(dir $(DIRECTORY_DEPS)))
+# In the second step, we make a rule to actually create these directories
+$(sort $(dir $(DIRECTORY_DEPS))):
+	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
+
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
-- 
1.6.2.5

