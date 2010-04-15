Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0DOHbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:31:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:38241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446Ab0DOHbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:31:07 -0400
Date: Thu, 15 Apr 2010 07:30:42 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulus@samba.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100414223928.14630.38326.stgit@localhost6.localdomain6>
References: <20100414223928.14630.38326.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix to use correct debugfs path finder
Message-ID: <tip-7ca5989dd065cbc48a958666c273794686ea7525@git.kernel.org>
Git-Commit-ID: 7ca5989dd065cbc48a958666c273794686ea7525
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:30:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ca5989dd065cbc48a958666c273794686ea7525
Gitweb:     http://git.kernel.org/tip/7ca5989dd065cbc48a958666c273794686ea7525
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 14 Apr 2010 18:39:28 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:41:06 -0300

perf probe: Fix to use correct debugfs path finder

Instead of using debugfs_path, use debugfs_find_mountpoint()
to find actual debugfs path.

LKML-Reference: <20100414223928.14630.38326.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c    |    4 ----
 tools/perf/util/probe-event.c |   12 ++++++++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 64bc11a..c1e5403 100644
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
