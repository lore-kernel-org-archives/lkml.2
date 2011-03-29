Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1C2SDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:03:15 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:32805
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab1C2SDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:03:14 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LITZGZ-02-HQP-02
X-M-MSG: 
Date: Tue, 29 Mar 2011 20:02:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: [PATCH] perf tools: Fix NO_NEWT=1 python build error
Message-ID: <20110329180236.GA19366@erda.amd.com>
References: <AANLkTimjSZSvz2zPEoc3SSJUBtWVJ_mza5ujpyaM0RVi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTimjSZSvz2zPEoc3SSJUBtWVJ_mza5ujpyaM0RVi@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.11 10:19:59, Stephane Eranian wrote:
> Looks like some define is missing during the generation of the python support.
> If you don't have newt then it fails to compile:
> 
> $ make
> Makefile:430: newt not found, disables TUI support. Please install
> newt-devel or libnewt-dev
> PERF_VERSION = 2.6.38
> Makefile:430: newt not found, disables TUI support. Please install
> newt-devel or libnewt-dev
> ...
> GEN perf-archive
> GEN python/perf.so
> In file included from util/evsel.h:10,
>                  from util/python.c:6:
> util/hist.h:105: fatal error: newt.h: No such file or directory
> compilation terminated.
> error: command 'gcc' failed with exit status 1


I encountered the same problem. See my fix below.

-Robert




>From 5a64703b924b67165ec20607f7cb057231edbeae Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Tue, 29 Mar 2011 18:16:27 +0200
Subject: [PATCH] perf tools: Fix NO_NEWT=1 python build error

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

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
1.7.3.4



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

