Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2JDSOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:14:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:39815 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2JDSJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Irina Tirdea <irina.tirdea@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/42] perf tools: Convert to BACKTRACE_SUPPORT
Date: Thu,  4 Oct 2012 15:08:29 -0300
Message-Id: <1349374122-27806-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without stack backtrace debug, we can set
NO_BACKTRACE=1 as a argument of make.  It then defines NO_BACKTRACE
macro for C code to do the proper handling.  However it usually used in
a negative semantics - e.g. #ifndef - so we saw double negations which
can be misleading.  Convert it to a positive form to make it more
readable and add _SUPPORT suffix for consistency.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349109171-1942-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile    |   10 +++++-----
 tools/perf/util/util.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5216ade..f9126f8 100644
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
@@ -749,11 +751,9 @@ ifndef NO_STRLCPY
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
index 2055cf3..9966459 100644
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
1.7.1

