Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2JAQdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:33:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51580 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2JAQdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:33:03 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Irina Tirdea <irina.tirdea@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 11/12] perf tools: Convert to BACKTRACE_SUPPORT
Date: Tue,  2 Oct 2012 01:32:51 +0900
Message-Id: <1349109171-1942-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20121001142443.GA9829@ghostprotocols.net>
References: <20121001142443.GA9829@ghostprotocols.net>
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
 tools/perf/Makefile    |   10 +++++-----
 tools/perf/util/util.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index dd5b9a0507c7..6b3ed863023b 100644
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
@@ -750,11 +752,9 @@ else
 	endif
 endif
 
-ifdef NO_BACKTRACE
-       BASIC_CFLAGS += -DNO_BACKTRACE
-else
-       ifneq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
-               BASIC_CFLAGS += -DNO_BACKTRACE
+ifndef NO_BACKTRACE
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
1.7.9.2

