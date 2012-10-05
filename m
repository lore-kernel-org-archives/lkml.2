Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2JEIz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:55:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2JEIzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:55:55 -0400
Date: Fri, 5 Oct 2012 01:55:26 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-4e34d9588b46f44a4dba718606913133f15e4b21@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, irina.tirdea@intel.com,
        irina.tirdea@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, irina.tirdea@intel.com,
        irina.tirdea@gmail.com, tglx@linutronix.de
In-Reply-To: <1349109171-1942-1-git-send-email-namhyung@kernel.org>
References: <1349109171-1942-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Convert to BACKTRACE_SUPPORT
Git-Commit-ID: 4e34d9588b46f44a4dba718606913133f15e4b21
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:55:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e34d9588b46f44a4dba718606913133f15e4b21
Gitweb:     http://git.kernel.org/tip/4e34d9588b46f44a4dba718606913133f15e4b21
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 2 Oct 2012 01:32:51 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:45 -0300

perf tools: Convert to BACKTRACE_SUPPORT

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
