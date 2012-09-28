Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab2I1Jko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:40:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59302 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab2I1JkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:24 -0400
X-AuditID: 9c930197-b7b6dae000000e70-76-50657083843d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 11/12] perf tools: Convert to BACKTRACE_SUPPORT
Date: Fri, 28 Sep 2012 18:32:07 +0900
Message-Id: <1348824728-14025-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without stack backtrace debug, we can set
NO_BACKTRACE=1 as a argument of make.  It then defines NO_BACKTRACE
macro for C code to do the proper handling.  However it usually used
in a negative semantics - e.g. #ifndef - so we saw double negations
which can be misleading.  Convert it to a positive form to make it
more readable and add _SUPPORT suffix for consistency.

Cc: Irina Tirdea <irina.tirdea@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile    | 8 ++++----
 tools/perf/util/util.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index dd5b9a0507c7..1cef38262bea 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -45,6 +45,8 @@ include config/utilities.mak
 #
 # Define NO_LIBUNWIND if you do not want libunwind dependency for dwarf
 # backtrace post unwind.
+#
+# Define NO_BACKTRACE if you do not want stack backtrace debug feature
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
@@ -751,10 +753,8 @@ else
 endif
 
 ifdef NO_BACKTRACE
-       BASIC_CFLAGS += -DNO_BACKTRACE
-else
-       ifneq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
-               BASIC_CFLAGS += -DNO_BACKTRACE
+       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
+               BASIC_CFLAGS += -DBACKTRACE_SUPPORT
        endif
 endif
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 2055cf38041c..99664598bc1a 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,7 +1,7 @@
 #include "../perf.h"
 #include "util.h"
 #include <sys/mman.h>
-#ifndef NO_BACKTRACE
+#ifdef BACKTRACE_SUPPORT
 #include <execinfo.h>
 #endif
 #include <stdio.h>
@@ -165,7 +165,7 @@ size_t hex_width(u64 v)
 }
 
 /* Obtain a backtrace and print it to stdout. */
-#ifndef NO_BACKTRACE
+#ifdef BACKTRACE_SUPPORT
 void dump_stack(void)
 {
 	void *array[16];
-- 
1.7.11.4

