Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1C3HSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:18:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:47769 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab1C3HSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:18:12 -0400
Date: Wed, 30 Mar 2011 07:17:47 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110329180236.GA19366@erda.amd.com>
References: <20110329180236.GA19366@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix NO_NEWT=1 python build error
Message-ID: <tip-1b7155f7de119870f0d3fad89f125de2ff6c16be@git.kernel.org>
Git-Commit-ID: 1b7155f7de119870f0d3fad89f125de2ff6c16be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 30 Mar 2011 07:17:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b7155f7de119870f0d3fad89f125de2ff6c16be
Gitweb:     http://git.kernel.org/tip/1b7155f7de119870f0d3fad89f125de2ff6c16be
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 29 Mar 2011 20:02:57 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 Mar 2011 16:46:57 -0300

perf tools: Fix NO_NEWT=1 python build error

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
