Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1FCQLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:11:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:40944 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab1FCQLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:11:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,315,1304319600"; 
   d="scan'208";a="11437587"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf: add support for disabling -Werror via WERROR=0
Date: Fri,  3 Jun 2011 09:10:42 -0700
Message-Id: <c751b9c5897b61cb99b167f0463e4ce663547b34.1307117442.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC often introduces new warnings with lots of false positives - breaking
-Werror builds. WERROR=0 allows one to build perf without much fuss - while
still encouraging people to send patches to avoid the fuss of having to type
WERROR=0.

Bisecting back to commits that produce a (mostly harmless) warning on some
compilers is more difficult. With WERROR=0 one could bisect without worrying
about harmless warnings.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 032ba63..e76dfbb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -30,6 +30,8 @@ endif
 # Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
 #
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
+#
+# Define WERROR=0 to disable treating any warnings as errors.
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
@@ -60,6 +62,11 @@ ifeq ($(ARCH),x86_64)
 	endif
 endif
 
+# Treat warnings as errors unless directed not to
+ifneq ($(WERROR),0)
+	CFLAGS_WERROR := -Werror
+endif
+
 #
 # Include saner warnings here, which can catch bugs:
 #
@@ -92,7 +99,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
-- 
1.7.1

