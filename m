Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0DNWcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab0DNWcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:32:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/6] perf probe: Fix to use correct debugfs path finder
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 14 Apr 2010 18:39:28 -0400
Message-ID: <20100414223928.14630.38326.stgit@localhost6.localdomain6>
In-Reply-To: <20100414223921.14630.62353.stgit@localhost6.localdomain6>
References: <20100414223921.14630.62353.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using debugfs_path, use debugfs_find_mountpoint()
to find actual debugfs path.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 tools/perf/builtin-probe.c    |    4 ----
 tools/perf/util/probe-event.c |   12 ++++++++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 5259c5a..4b6dd84 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -40,7 +40,6 @@
 #include "util/debug.h"
 #include "util/debugfs.h"
 #include "util/parse-options.h"
-#include "util/parse-events.h"	/* For debugfs_path */
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
 
@@ -205,9 +204,6 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	     !params.show_lines))
 		usage_with_options(probe_usage, options);
 
-	if (debugfs_valid_mountpoint(debugfs_path) < 0)
-		die("Failed to find debugfs path.");
-
 	if (params.list_events) {
 		if (params.nevents != 0 || params.dellist) {
 			pr_err("  Error: Don't use --list with --add/--del.\n");
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index ca108b2..1c4a20a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -42,8 +42,8 @@
 #include "color.h"
 #include "symbol.h"
 #include "thread.h"
+#include "debugfs.h"
 #include "trace-event.h"	/* For __unused */
-#include "parse-events.h"	/* For debugfs_path */
 #include "probe-event.h"
 #include "probe-finder.h"
 
@@ -1075,10 +1075,18 @@ void clear_kprobe_trace_event(struct kprobe_trace_event *tev)
 static int open_kprobe_events(bool readwrite)
 {
 	char buf[PATH_MAX];
+	const char *__debugfs;
 	int ret;
 
-	ret = e_snprintf(buf, PATH_MAX, "%s/../kprobe_events", debugfs_path);
+	__debugfs = debugfs_find_mountpoint();
+	if (__debugfs == NULL) {
+		pr_warning("Debugfs is not mounted.\n");
+		return -ENOENT;
+	}
+
+	ret = e_snprintf(buf, PATH_MAX, "%stracing/kprobe_events", __debugfs);
 	if (ret >= 0) {
+		pr_debug("Opening %s write=%d\n", buf, readwrite);
 		if (readwrite && !probe_event_dry_run)
 			ret = open(buf, O_RDWR, O_APPEND);
 		else


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
