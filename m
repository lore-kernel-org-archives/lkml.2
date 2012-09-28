Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab2I1JnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:43:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60959 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2I1JkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:20 -0400
X-AuditID: 9c930197-b7b6dae000000e70-63-506570820597
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 01/12] perf tools: Move libdw availability check before arch Makefile
Date: Fri, 28 Sep 2012 18:31:57 +0900
Message-Id: <1348824728-14025-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since NO_DWARF is used in arch/$(ARCH)/Makefiles, it should be checked
before including those files.  It was moved by mistake during libelf
dependency removal work by me, sorry.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e5e71e7d95a0..834f09fa5c62 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -486,7 +486,13 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 		NO_DWARF := 1
 		NO_DEMANGLE := 1
 	endif
-endif
+else
+	FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
+	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
+		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+		NO_DWARF := 1
+	endif # Dwarf support
+endif # SOURCE_LIBELF
 endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
@@ -532,12 +538,6 @@ ifneq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
 	BASIC_CFLAGS += -DLIBELF_NO_MMAP
 endif
 
-FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
-	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-	NO_DWARF := 1
-endif # Dwarf support
-
 ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-- 
1.7.11.4

