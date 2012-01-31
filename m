Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2AaNYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:24:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2AaNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:24:38 -0500
Date: Tue, 31 Jan 2012 05:24:05 -0800
From: tip-bot for David Daney <david.daney@cavium.com>
Message-ID: <tip-0a84f007f97ce6fc7c07a481a5b9808b187a0193@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        joerg.roedel@amd.com, namhyung.kim@lge.com, david.daney@cavium.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, joerg.roedel@amd.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, david.daney@cavium.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1326836461-11952-1-git-send-email-ddaney.cavm@gmail.com>
References: <1326836461-11952-1-git-send-email-ddaney.cavm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix broken build by defining _GNU_SOURCE in Makefile
Git-Commit-ID: 0a84f007f97ce6fc7c07a481a5b9808b187a0193
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:24:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a84f007f97ce6fc7c07a481a5b9808b187a0193
Gitweb:     http://git.kernel.org/tip/0a84f007f97ce6fc7c07a481a5b9808b187a0193
Author:     David Daney <david.daney@cavium.com>
AuthorDate: Tue, 17 Jan 2012 13:41:01 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 22:19:54 -0200

perf tools: Fix broken build by defining _GNU_SOURCE in Makefile

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
index ac86d67..7c12650 100644
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
index 1212a38..e81aef1 100644
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
index b9c530c..ecf9898 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -40,7 +40,6 @@
 #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
 
 #define _ALL_SOURCE 1
-#define _GNU_SOURCE 1
 #define _BSD_SOURCE 1
 #define HAS_BOOL
 
