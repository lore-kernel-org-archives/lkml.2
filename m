Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1FBUr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 16:47:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:16846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1FBUr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 16:47:58 -0400
X-ExtLoop1: 1
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Bruce Ashfield <bruce.ashfield@windriver.com>
Subject: [PATCH] perf: fix gcc4.6 build failure with unused-but-set warning
Date: Thu,  2 Jun 2011 13:47:48 -0700
Message-Id: <8a0acb368eef010fd2eb2e889e2c62d91bd8a918.1307047668.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into the following build failure with gcc 4.6:

	bench/sched-pipe.c: In function 'bench_sched_pipe':
	bench/sched-pipe.c:58:6: error: variable 'ret' set but not used
	[-Werror=unused-but-set-variable]
	cc1: all warnings being treated as errors

As the main kernel Makefile has added -Wno-unused-but-set-variable
and sched-pipe.c claims:

	/*
	 * why does "ret" exist?
	 * discarding returned value of read(), write()
	 * causes error in building environment for perf
	 */

This patch creates a new perf/Makefile variable, LESS_WARNINGS and
adds -Wno-unused-but-set-variable. The new variable helps distinguish
between the added warnings in EXTRA_WARNINGS versus those we want to
remove, including the existing -Wno-system-headers which I moved to
LESS_WARNINGS.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Bruce Ashfield <bruce.ashfield@windriver.com>
---
 tools/perf/Makefile |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 032ba63..fdb35dc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -74,7 +74,6 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
@@ -85,6 +84,13 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
+#
+# Disable warnings that cause build problems or needlessly polute output:
+#
+
+LESS_WARNINGS := -Wno-system-headers
+LESS_WARNINGS := $(LESS_WARNINGS) -Wno-unused-but-set-variable
+
 ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
@@ -92,7 +98,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(LESS_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
-- 
1.7.1

