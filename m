Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0FYKmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 06:42:52 -0400
Received: from mail2.picochip.com ([82.111.145.34]:52843 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754417Ab0FYKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 06:42:50 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2010 06:42:50 EDT
From: Jamie Iles <jamie.iles@picochip.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie.iles@picochip.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tools: allow cross compiling with DWARF support
Date: Fri, 25 Jun 2010 11:38:38 +0100
Message-Id: <1277462318-6516-1-git-send-email-jamie.iles@picochip.com>
X-Mailer: git-send-email 1.6.5.4
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 25 Jun 2010 11:36:50 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The path to elfutils was previously hardcoded as /usr/include/elfutils
which does not work with cross compilers. If CROSS_COMPILE is set, try
to set an include path from GCC's sysroot if GCC was built with sysroot
support, if sysroot support isn't enabled, don't specify a path for
elfutils allowing the user to set it with EXTRA_CFLAGS.

Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/Makefile |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6aa2fe3..6217839 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -503,8 +503,18 @@ PERFLIBS = $(LIB_FILE)
 -include config.mak.autogen
 -include config.mak
 
+ifndef CROSS_COMPILE
+ELFUTILS_INCLUDE = -I/usr/include/elfutils
+else
+# See if the compiler has been built with sysroot support
+SYSROOT_PATH = $(shell $(CC) -print-sysroot 2> /dev/null || echo "")
+ifneq ($(SYSROOT_PATH),)
+ELFUTILS_INCLUDE := -I$(SYSROOT_PATH)/usr/include/elfutils
+endif
+endif
+
 ifndef NO_DWARF
-FLAGS_DWARF=$(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
+FLAGS_DWARF=$(ALL_CFLAGS) $(ELFUTILS_INCLUDE) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
 ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
 	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
 	NO_DWARF := 1
@@ -551,7 +561,7 @@ ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
 else
-	BASIC_CFLAGS += -I/usr/include/elfutils -DDWARF_SUPPORT
+	BASIC_CFLAGS += $(ELFUTILS_INCLUDE) -DDWARF_SUPPORT
 	EXTLIBS += -lelf -ldw
 	LIB_OBJS += $(OUTPUT)util/probe-finder.o
 endif # PERF_HAVE_DWARF_REGS
-- 
1.6.5.4

