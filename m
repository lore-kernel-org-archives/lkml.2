Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0CPV6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:58:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0CPV6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:58:00 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 07/10] perf probe: Add --dry-run option
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 16 Mar 2010 18:06:05 -0400
Message-ID: <20100316220605.32050.6571.stgit@localhost6.localdomain6>
In-Reply-To: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --dry-run option for debugging and testing.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 tools/perf/Documentation/perf-probe.txt |    5 +++++
 tools/perf/builtin-probe.c              |    1 +
 tools/perf/util/probe-event.c           |   24 ++++++++++++++++--------
 tools/perf/util/probe-event.h           |    2 ++
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 34202b1..0f944b3 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -57,6 +57,11 @@ OPTIONS
 --force::
 	Forcibly add events with existing name.
 
+-n::
+--dry-run::
+	Dry run. With this option, --add and --del doesn't execute actual
+	adding and removal operations.
+
 PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index f577e14..a1a2891 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -175,6 +175,7 @@ static const struct option options[] = {
 		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
 		     "Show source code lines.", opt_show_lines),
 #endif
+	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1e60a65..ac41578 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -49,6 +49,8 @@
 #define MAX_PROBE_ARGS 128
 #define PERFPROBE_GROUP "probe"
 
+bool probe_event_dry_run;	/* Dry run flag */
+
 #define semantic_error(msg ...) die("Semantic error :" msg)
 
 /* If there is no space to write, returns -E2BIG. */
@@ -430,7 +432,7 @@ error:
 	return ret;
 }
 
-static int open_kprobe_events(int flags, int mode)
+static int open_kprobe_events(bool readwrite)
 {
 	char buf[PATH_MAX];
 	int ret;
@@ -439,7 +441,11 @@ static int open_kprobe_events(int flags, int mode)
 	if (ret < 0)
 		die("Failed to make kprobe_events path.");
 
-	ret = open(buf, flags, mode);
+	if (readwrite && !probe_event_dry_run)
+		ret = open(buf, O_RDWR, O_APPEND);
+	else
+		ret = open(buf, O_RDONLY, 0);
+
 	if (ret < 0) {
 		if (errno == ENOENT)
 			die("kprobe_events file does not exist -"
@@ -535,7 +541,7 @@ void show_perf_probe_events(void)
 	setup_pager();
 	memset(&pp, 0, sizeof(pp));
 
-	fd = open_kprobe_events(O_RDONLY, 0);
+	fd = open_kprobe_events(false);
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 	close(fd);
 
@@ -585,9 +591,11 @@ static void write_trace_kprobe_event(int fd, const char *buf)
 	int ret;
 
 	pr_debug("Writing event: %s\n", buf);
-	ret = write(fd, buf, strlen(buf));
-	if (ret <= 0)
-		die("Failed to write event: %s", strerror(errno));
+	if (!probe_event_dry_run) {
+		ret = write(fd, buf, strlen(buf));
+		if (ret <= 0)
+			die("Failed to write event: %s", strerror(errno));
+	}
 }
 
 static void get_new_event_name(char *buf, size_t len, const char *base,
@@ -630,7 +638,7 @@ static void __add_trace_kprobe_events(struct probe_point *probes,
 	struct strlist *namelist;
 	bool allow_suffix;
 
-	fd = open_kprobe_events(O_RDWR, O_APPEND);
+	fd = open_kprobe_events(true);
 	/* Get current event names */
 	namelist = get_perf_event_names(fd, false);
 
@@ -814,7 +822,7 @@ void del_trace_kprobe_events(struct strlist *dellist)
 	struct str_node *ent;
 	struct strlist *namelist;
 
-	fd = open_kprobe_events(O_RDWR, O_APPEND);
+	fd = open_kprobe_events(true);
 	/* Get current event names */
 	namelist = get_perf_event_names(fd, true);
 
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 3865e16..703b887 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -5,6 +5,8 @@
 #include "probe-finder.h"
 #include "strlist.h"
 
+extern bool probe_event_dry_run;
+
 extern void parse_line_range_desc(const char *arg, struct line_range *lr);
 extern void parse_perf_probe_event(const char *str, struct probe_point *pp,
 				   bool *need_dwarf);


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
