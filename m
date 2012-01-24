Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2AXXJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:09:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59179 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab2AXXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/9] perf tools: Fix broken build by defining _GNU_SOURCE in Makefile
Date: Tue, 24 Jan 2012 21:07:59 -0200
Message-Id: <1327446481-5505-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

When building on my Debian/mips system, util/util.c fails to build
because commit 1aed2671738785e8f5aea663a6fda91aa7ef59b5 (perf kvm: Do
guest-only counting by default) indirectly includes stdio.h before the
feature selection in util.h is done.  This prevents _GNU_SOURCE in
util.h from enabling the declaration of getline(), from now second
inclusion of stdio.h, and the build is broken.

There is another breakage in util/evsel.c caused by include ordering,
but I didn't fully track down the commit that caused it.

The root cause of all this is an inconsistent definition of _GNU_SOURCE,
so I move the definition into the Makefile so that it is passed to all
invocations of the compiler and used uniformly for all system header
files.  All other #define and #undef of _GNU_SOURCE are removed as they
cause conflicts with the definition passed to the compiler.

All the features.h definitions (_LARGEFILE64_SOURCE _FILE_OFFSET_BITS=64
and _GNU_SOURCE) are needed by the python glue code too, so they are
moved to BASIC_CFLAGS, and the misleading comments about BASIC_CFLAGS
are removed.

This gives me a clean build on x86_64 (fc12) and mips (Debian).

Cc: David Daney <david.daney@cavium.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1326836461-11952-1-git-send-email-ddaney.cavm@gmail.com
Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |    7 ++-----
 tools/perf/builtin-probe.c          |    2 --
 tools/perf/util/probe-event.c       |    2 --
 tools/perf/util/symbol.c            |    1 -
 tools/perf/util/trace-event-parse.c |    3 +--
 tools/perf/util/ui/browsers/hists.c |    2 --
 tools/perf/util/ui/helpline.c       |    1 -
 tools/perf/util/util.h              |    1 -
 8 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 599031a..d64f581 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -104,7 +104,7 @@ endif
 
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
-ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
 
@@ -168,10 +168,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-# Those must not be GNU-specific; they are shared with perl/ which may
-# be built by a different compiler. (Note that this is an artifact now
-# but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 59d43ab..fb85661 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -20,7 +20,6 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  */
-#define _GNU_SOURCE
 #include <sys/utsname.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -31,7 +30,6 @@
 #include <stdlib.h>
 #include <string.h>
 
-#undef _GNU_SOURCE
 #include "perf.h"
 #include "builtin.h"
 #include "util/util.h"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index eb25900..29cb654 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -19,7 +19,6 @@
  *
  */
 
-#define _GNU_SOURCE
 #include <sys/utsname.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -33,7 +32,6 @@
 #include <limits.h>
 #include <elf.h>
 
-#undef _GNU_SOURCE
 #include "util.h"
 #include "event.h"
 #include "string.h"
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 215d50f..0975438 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,4 +1,3 @@
-#define _GNU_SOURCE
 #include <ctype.h>
 #include <dirent.h>
 #include <errno.h>
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 6c164dc..1a8d4dc 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -21,14 +21,13 @@
  *  The parts for function graph printing was taken and modified from the
  *  Linux Kernel that were written by Frederic Weisbecker.
  */
-#define _GNU_SOURCE
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <ctype.h>
 #include <errno.h>
 
-#undef _GNU_SOURCE
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 7b6669d..bfba049 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -1,6 +1,4 @@
-#define _GNU_SOURCE
 #include <stdio.h>
-#undef _GNU_SOURCE
 #include "../libslang.h"
 #include <stdlib.h>
 #include <string.h>
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index 6ef3c56..4f48f59 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -1,4 +1,3 @@
-#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 061dbf8..232d17e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -40,7 +40,6 @@
 #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
 
 #define _ALL_SOURCE 1
-#define _GNU_SOURCE 1
 #define _BSD_SOURCE 1
 #define HAS_BOOL
 
-- 
1.7.9.rc2.1.g69204

