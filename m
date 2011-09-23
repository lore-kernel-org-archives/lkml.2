Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1IWU1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:27:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35458 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab1IWU04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:26:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/12] perf tools: Add support for disabling -Werror via WERROR=0
Date: Fri, 23 Sep 2011 17:26:26 -0300
Message-Id: <1316809586-28529-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1316809586-28529-1-git-send-email-acme@infradead.org>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>

GCC often introduces new warnings with lots of false positives -
breaking -Werror builds. WERROR=0 allows one to build perf without much
fuss - while still encouraging people to send patches to avoid the fuss
of having to type WERROR=0.

Bisecting back to commits that produce a (mostly harmless) warning on
some compilers is more difficult. With WERROR=0 one could bisect without
worrying about harmless warnings.

Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/eac06c7cc4920e5d4830417d466161fb26c7359c.1315514559.git.dvhart@linux.intel.com
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3b8f7b8..e9d5c27 100644
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
@@ -63,6 +65,11 @@ ifeq ($(ARCH),x86_64)
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
@@ -95,7 +102,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
-- 
1.6.2.5

