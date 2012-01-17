Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2AQCBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:01:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60595 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2AQCBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:01:35 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] perf: Fix broken build by rearranging some #includes
Date: Mon, 16 Jan 2012 18:01:25 -0800
Message-Id: <1326765685-7686-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
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

Since the #include situation is a little convoluted throughout perf, I
did the following:

1) Always include util/util.h before all other include files.

2) Remove all #define _GNU_SOURCE, as it is already done in util.h.

3) Remove all #undef _GNU_SOURCE, as they don't do what a naive person
   might expect (or much of anything for that matter) and clutter up
   the source.

4) #include ctype.h in util.h, so that ctype things have uniform
   definitions throughout perf.

5) Remove #define of _FILE_OFFSET_BITS where util/util.h is already
   providing it.

This gives me a clean build on x86_64 (fc12) and mips (Debian).

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Joerg Roedel <joerg.roedel@amd.com>
---
 tools/perf/builtin-annotate.c                      |    2 +-
 tools/perf/builtin-bench.c                         |    2 +-
 tools/perf/builtin-diff.c                          |    2 +-
 tools/perf/builtin-evlist.c                        |    3 +--
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-kvm.c                           |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-probe.c                         |    5 ++---
 tools/perf/builtin-record.c                        |    2 +-
 tools/perf/builtin-report.c                        |    3 +--
 tools/perf/builtin-sched.c                         |    2 +-
 tools/perf/builtin-script.c                        |    2 +-
 tools/perf/builtin-stat.c                          |    2 +-
 tools/perf/builtin-timechart.c                     |    3 +--
 tools/perf/builtin-top.c                           |    2 +-
 tools/perf/util/cache.h                            |    2 +-
 tools/perf/util/callchain.c                        |    2 +-
 tools/perf/util/debug.c                            |    2 +-
 tools/perf/util/dwarf-aux.c                        |    2 +-
 tools/perf/util/evlist.h                           |    2 +-
 tools/perf/util/evsel.c                            |    2 +-
 tools/perf/util/header.c                           |    2 --
 tools/perf/util/hist.c                             |    2 +-
 tools/perf/util/parse-events.c                     |    2 +-
 tools/perf/util/probe-event.c                      |    4 +---
 tools/perf/util/probe-finder.c                     |    2 +-
 tools/perf/util/probe-finder.h                     |    2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 tools/perf/util/session.c                          |    3 ++-
 tools/perf/util/sort.h                             |    5 +++--
 tools/perf/util/thread.c                           |    2 +-
 tools/perf/util/trace-event-parse.c                |    5 ++---
 tools/perf/util/trace-event-read.c                 |    3 +--
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/ui/browsers/hists.c                |    4 +---
 tools/perf/util/util.c                             |    2 +-
 tools/perf/util/util.h                             |    1 +
 tools/perf/util/values.c                           |    2 +-
 tools/perf/util/xyarray.c                          |    2 +-
 39 files changed, 43 insertions(+), 52 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 806e0a2..e9f4bd7 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -5,9 +5,9 @@
  * look up and read DSOs and symbol information and display
  * a histogram of results, along various sorting keys.
  */
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 
-#include "util/util.h"
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index fcb9626..3d8fbea 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -16,8 +16,8 @@
  *
  */
 
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "perf.h"
-#include "util/util.h"
 #include "util/parse-options.h"
 #include "builtin.h"
 #include "bench/bench.h"
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4f19513..a5692fe 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -4,6 +4,7 @@
  * Builtin diff command: Analyze two perf.data input files, look up and read
  * DSOs and symbol information, sort them and produce a diff.
  */
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 
 #include "util/debug.h"
@@ -14,7 +15,6 @@
 #include "util/tool.h"
 #include "util/sort.h"
 #include "util/symbol.h"
-#include "util/util.h"
 
 #include <stdlib.h>
 
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 2676032..ce78b37 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -2,10 +2,9 @@
  * Builtin evlist command: Show the list of event selectors present
  * in a perf.data file.
  */
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 
-#include "util/util.h"
-
 #include <linux/list.h>
 
 #include "perf.h"
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 39104c0..40e95bc 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -1,7 +1,7 @@
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 9fc6e0f..3557dd8 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1,7 +1,7 @@
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 2296c39..c490905 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1,7 +1,7 @@
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 59d43ab..f93710a 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -20,7 +20,8 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  */
-#define _GNU_SOURCE
+
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include <sys/utsname.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -31,10 +32,8 @@
 #include <stdlib.h>
 #include <string.h>
 
-#undef _GNU_SOURCE
 #include "perf.h"
 #include "builtin.h"
-#include "util/util.h"
 #include "util/strlist.h"
 #include "util/strfilter.h"
 #include "util/symbol.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0abfb18..dcf8159 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -5,8 +5,8 @@
  * (or a CPU, or a PID) into the perf.data output file - for
  * later analysis via perf report.
  */
-#define _FILE_OFFSET_BITS 64
 
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 
 #include "perf.h"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25d34d4..886fd79 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -5,10 +5,9 @@
  * look up and read DSOs and symbol information and display
  * a histogram of results, along various sorting keys.
  */
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 
-#include "util/util.h"
-
 #include "util/annotate.h"
 #include "util/color.h"
 #include <linux/list.h>
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index fb8b5f8..9189852 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1,7 +1,7 @@
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
 #include "util/evlist.h"
 #include "util/cache.h"
 #include "util/evsel.h"
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index bb68ddf..98204e6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1,3 +1,4 @@
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 
 #include "perf.h"
@@ -11,7 +12,6 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/trace-event.h"
-#include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
 #include <linux/bitmap.h>
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f5d2a63..8f8b53f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -41,9 +41,9 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "perf.h"
 #include "builtin.h"
-#include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/event.h"
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 3b75b2e..88e1a46 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -12,10 +12,9 @@
  * of the License.
  */
 
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 
-#include "util/util.h"
-
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8f80df8..37acc74 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -17,6 +17,7 @@
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
+#include "util/util.h" /* Include first, it forces things in features.h */
 #include "builtin.h"
 
 #include "perf.h"
@@ -31,7 +32,6 @@
 #include "util/thread.h"
 #include "util/thread_map.h"
 #include "util/top.h"
-#include "util/util.h"
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index fc5e5a0..bdcfa57 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -1,8 +1,8 @@
 #ifndef __PERF_CACHE_H
 #define __PERF_CACHE_H
 
+#include "util.h" /* Include first, it forces things in features.h */
 #include <stdbool.h>
-#include "util.h"
 #include "strbuf.h"
 #include "../perf.h"
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 9f7106a..adb2d84 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -9,13 +9,13 @@
  *
  */
 
+#include "util.h" /* Include first, it forces things in features.h */
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdbool.h>
 #include <errno.h>
 #include <math.h>
 
-#include "util.h"
 #include "callchain.h"
 
 bool ip_callchain__valid(struct ip_callchain *chain,
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 26817da..c15f342 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -1,5 +1,6 @@
 /* For general debugging purposes */
 
+#include "util.h" /* Include first, it forces things in features.h */
 #include "../perf.h"
 
 #include <string.h>
@@ -10,7 +11,6 @@
 #include "color.h"
 #include "event.h"
 #include "debug.h"
-#include "util.h"
 
 int verbose;
 bool dump_trace = false, quiet = false;
diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index ee51e9b..0edf62f 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -17,8 +17,8 @@
  *
  */
 
+#include "util.h" /* Include first, it forces things in features.h */
 #include <stdbool.h>
-#include "util.h"
 #include "debug.h"
 #include "dwarf-aux.h"
 
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 8922aee..b9f80c0 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -1,11 +1,11 @@
 #ifndef __PERF_EVLIST_H
 #define __PERF_EVLIST_H 1
 
+#include "util.h" /* Include first, it forces things in features.h */
 #include <linux/list.h>
 #include <stdio.h>
 #include "../perf.h"
 #include "event.h"
-#include "util.h"
 #include <unistd.h>
 
 struct pollfd;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 667f3b7..a63c302 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -7,11 +7,11 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 
+#include "util.h" /* Include first, it forces things in features.h */
 #include <byteswap.h>
 #include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
-#include "util.h"
 #include "cpumap.h"
 #include "thread_map.h"
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3e7e0b0..c555656 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,5 +1,3 @@
-#define _FILE_OFFSET_BITS 64
-
 #include "util.h"
 #include <sys/types.h>
 #include <byteswap.h>
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6f505d1..0ef4829 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,5 +1,5 @@
+#include "util.h" /* Include first, it forces things in features.h */
 #include "annotate.h"
-#include "util.h"
 #include "build-id.h"
 #include "hist.h"
 #include "session.h"
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b029296..7ead31a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,5 +1,5 @@
+#include "util.h" /* Include first, it forces things in features.h */
 #include "../../../include/linux/hw_breakpoint.h"
-#include "util.h"
 #include "../perf.h"
 #include "evlist.h"
 #include "evsel.h"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index eb25900..492fa41 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -18,8 +18,8 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  */
+#include "util.h" /* Include first, as it forces things in features.h */
 
-#define _GNU_SOURCE
 #include <sys/utsname.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -33,8 +33,6 @@
 #include <limits.h>
 #include <elf.h>
 
-#undef _GNU_SOURCE
-#include "util.h"
 #include "event.h"
 #include "string.h"
 #include "strlist.h"
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5d73262..4bd79e4 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -20,6 +20,7 @@
  */
 
 #include <sys/utsname.h>
+#include "util.h" /* Include first, it forces things in features.h */
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -36,7 +37,6 @@
 #include <linux/bitops.h>
 #include "event.h"
 #include "debug.h"
-#include "util.h"
 #include "symbol.h"
 #include "probe-finder.h"
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 17e94d0..c0a7c1b 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -1,8 +1,8 @@
 #ifndef _PROBE_FINDER_H
 #define _PROBE_FINDER_H
 
+#include "util.h" /* Include first, it forces things in features.h */
 #include <stdbool.h>
-#include "util.h"
 #include "probe-event.h"
 
 #define MAX_PROBE_BUFFER	1024
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index e30749e..605d20c 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include "../util.h" /* Include first, it forces things in features.h */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -26,7 +27,6 @@
 #include <errno.h>
 
 #include "../../perf.h"
-#include "../util.h"
 #include "../thread.h"
 #include "../event.h"
 #include "../trace-event.h"
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b5ca255..c3a25df 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,4 +1,5 @@
-#define _FILE_OFFSET_BITS 64
+
+#include "util.h" /* Include first, it forces things in features.h */
 
 #include <linux/kernel.h>
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 3f67ae3..4ba8f11 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -1,8 +1,9 @@
 #ifndef __PERF_SORT_H
 #define __PERF_SORT_H
-#include "../builtin.h"
 
-#include "util.h"
+#include "util.h" /* Include first, it forces things in features.h */
+
+#include "../builtin.h"
 
 #include "color.h"
 #include <linux/list.h>
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fb4b7ea..e550a4a 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -1,10 +1,10 @@
+#include "util.h" /* Include first, it forces things in features.h */
 #include "../perf.h"
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include "session.h"
 #include "thread.h"
-#include "util.h"
 #include "debug.h"
 
 static struct thread *thread__new(pid_t pid)
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 6c164dc..e80e1fd 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -21,16 +21,15 @@
  *  The parts for function graph printing was taken and modified from the
  *  Linux Kernel that were written by Frederic Weisbecker.
  */
-#define _GNU_SOURCE
+#include "util.h" /* Include first, it forces things in features.h */
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <ctype.h>
 #include <errno.h>
 
-#undef _GNU_SOURCE
 #include "../perf.h"
-#include "util.h"
 #include "trace-event.h"
 
 int header_page_ts_offset;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index f55cc3a..035ebff 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -18,7 +18,7 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#define _FILE_OFFSET_BITS 64
+#include "util.h" /* Include first, it forces things in features.h */
 
 #include <dirent.h>
 #include <stdio.h>
@@ -37,7 +37,6 @@
 #include <errno.h>
 
 #include "../perf.h"
-#include "util.h"
 #include "trace-event.h"
 
 static int input_fd;
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index a3fdf55..26e1e6d 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include "util.h" /* Include first, it forces things in features.h */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -26,7 +27,6 @@
 #include <errno.h>
 
 #include "../perf.h"
-#include "util.h"
 #include "trace-event.h"
 
 struct scripting_context *scripting_context;
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 1212a38..b85c3c6 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -1,6 +1,5 @@
-#define _GNU_SOURCE
+#include "../../util.h" /* Include first, it forces things in features.h */
 #include <stdio.h>
-#undef _GNU_SOURCE
 #include "../libslang.h"
 #include <stdlib.h>
 #include <string.h>
@@ -12,7 +11,6 @@
 #include "../../hist.h"
 #include "../../pstack.h"
 #include "../../sort.h"
-#include "../../util.h"
 
 #include "../browser.h"
 #include "../helpline.h"
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8131410..b35089f 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,5 +1,5 @@
+#include "util.h" /* Include first, it forces things in features.h */
 #include "../perf.h"
-#include "util.h"
 #include <sys/mman.h>
 
 /*
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b9c530c..8e64cab 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -80,6 +80,7 @@
 #include "../../../include/linux/magic.h"
 #include "types.h"
 #include <sys/ttydefaults.h>
+#include <ctype.h>
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index 697c8b4e..5e4183d 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -1,6 +1,6 @@
+#include "util.h" /* Include first, it forces things in features.h */
 #include <stdlib.h>
 
-#include "util.h"
 #include "values.h"
 
 void perf_read_values_init(struct perf_read_values *values)
diff --git a/tools/perf/util/xyarray.c b/tools/perf/util/xyarray.c
index 22afbf6..fa7af9f 100644
--- a/tools/perf/util/xyarray.c
+++ b/tools/perf/util/xyarray.c
@@ -1,5 +1,5 @@
+#include "util.h" /* Include first, it forces things in features.h */
 #include "xyarray.h"
-#include "util.h"
 
 struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size)
 {
-- 
1.7.2.3

