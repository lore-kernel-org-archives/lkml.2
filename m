Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1C3Cag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:30:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab1C3CaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:30:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf tools: Fix NO_NEWT=1 python build error
Date: Tue, 29 Mar 2011 23:29:51 -0300
Message-Id: <1301452191-906-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1301452191-906-1-git-send-email-acme@infradead.org>
References: <1301452191-906-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Fix the following build error:

     GEN python/perf.so
 In file included from util/evsel.h:10,
                  from util/python.c:6:
 util/hist.h:106:18: error: newt.h: No such file or directory
 error: command 'x86_64-pc-linux-gnu-gcc' failed with exit status 1
 make: *** [python/perf.so] Error 1

by passing BASIC_CFLAGS to setup.py. BASIC_CFLAGS variable contains
the -DNO_NEWT_SUPPORT switch which prevents building python c
extension with newt.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20110329180236.GA19366@erda.amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    8 ++++++--
 tools/perf/util/setup.py |    7 ++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 158c30e..207dee5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -165,8 +165,12 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	$(QUIET_GEN)python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
-						--build-temp='$(OUTPUT)python/temp'
+	$(QUIET_GEN)( \
+		export CFLAGS="$(BASIC_CFLAGS)"; \
+		python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
+			--build-temp='$(OUTPUT)python/temp' \
+	)
+
 #
 # No Perl scripts right now:
 #
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index e24ffad..bbc982f 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -1,13 +1,18 @@
 #!/usr/bin/python2
 
 from distutils.core import setup, Extension
+from os import getenv
+
+cflags = ['-fno-strict-aliasing', '-Wno-write-strings']
+cflags += getenv('CFLAGS', '').split()
 
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
 			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c'],
 		  include_dirs = ['util/include'],
-		  extra_compile_args = ['-fno-strict-aliasing', '-Wno-write-strings'])
+		  extra_compile_args = cflags,
+                 )
 
 setup(name='perf',
       version='0.1',
-- 
1.6.2.5

