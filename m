Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab1COUGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:06:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250Ab1COUFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:05:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 12/12] perf evlist: New command to list the names of events present in a perf.data file
Date: Tue, 15 Mar 2011 17:05:01 -0300
Message-Id: <1300219501-15085-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300219501-15085-1-git-send-email-acme@infradead.org>
References: <1300219501-15085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[root@emilia ~]# perf record -a -e sched:* -e timer:timer* sleep 5
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.172 MB perf.data (~7530 samples) ]
[root@emilia ~]# perf evlist
sched:sched_kthread_stop
sched:sched_kthread_stop_ret
sched:sched_wakeup
sched:sched_wakeup_new
sched:sched_switch
sched:sched_migrate_task
sched:sched_process_free
sched:sched_process_exit
sched:sched_wait_task
sched:sched_process_wait
sched:sched_process_fork
sched:sched_stat_wait
sched:sched_stat_sleep
sched:sched_stat_iowait
sched:sched_stat_runtime
sched:sched_pi_setprio
timer:timer_init
timer:timer_start
timer:timer_expire_entry
timer:timer_expire_exit
timer:timer_cancel
[root@emilia ~]#

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-evlist.txt |   26 ++++++++++++++
 tools/perf/Makefile                      |    1 +
 tools/perf/builtin-evlist.c              |   54 ++++++++++++++++++++++++++++++
 tools/perf/builtin.h                     |    1 +
 tools/perf/command-list.txt              |    1 +
 tools/perf/perf.c                        |    1 +
 6 files changed, 84 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-evlist.txt
 create mode 100644 tools/perf/builtin-evlist.c

diff --git a/tools/perf/Documentation/perf-evlist.txt b/tools/perf/Documentation/perf-evlist.txt
new file mode 100644
index 0000000..0cada9e
--- /dev/null
+++ b/tools/perf/Documentation/perf-evlist.txt
@@ -0,0 +1,26 @@
+perf-evlist(1)
+==============
+
+NAME
+----
+perf-evlist - List the event names in a perf.data file
+
+SYNOPSIS
+--------
+[verse]
+'perf evlist <options>'
+
+DESCRIPTION
+-----------
+This command displays the names of events sampled in a perf.data file.
+
+OPTIONS
+-------
+-i::
+--input=::
+        Input file name. (default: perf.data)
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-list[1],
+linkperf:perf-report[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9b84218..158c30e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -338,6 +338,7 @@ endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
+BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
 BUILTIN_OBJS += $(OUTPUT)builtin-help.o
 BUILTIN_OBJS += $(OUTPUT)builtin-sched.o
 BUILTIN_OBJS += $(OUTPUT)builtin-buildid-list.o
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
new file mode 100644
index 0000000..4c5e9e0
--- /dev/null
+++ b/tools/perf/builtin-evlist.c
@@ -0,0 +1,54 @@
+/*
+ * Builtin evlist command: Show the list of event selectors present
+ * in a perf.data file.
+ */
+#include "builtin.h"
+
+#include "util/util.h"
+
+#include <linux/list.h>
+
+#include "perf.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
+#include "util/parse-events.h"
+#include "util/parse-options.h"
+#include "util/session.h"
+
+static char const *input_name = "perf.data";
+
+static int __cmd_evlist(void)
+{
+	struct perf_session *session;
+	struct perf_evsel *pos;
+
+	session = perf_session__new(input_name, O_RDONLY, 0, false, NULL);
+	if (session == NULL)
+		return -ENOMEM;
+
+	list_for_each_entry(pos, &session->evlist->entries, node)
+		printf("%s\n", event_name(pos));
+
+	perf_session__delete(session);
+	return 0;
+}
+
+static const char * const evlist_usage[] = {
+	"perf evlist [<options>]",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_END()
+};
+
+int cmd_evlist(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, options, evlist_usage, 0);
+	if (argc)
+		usage_with_options(evlist_usage, options);
+
+	return __cmd_evlist();
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index c7798c7..4702e24 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -19,6 +19,7 @@ extern int cmd_bench(int argc, const char **argv, const char *prefix);
 extern int cmd_buildid_cache(int argc, const char **argv, const char *prefix);
 extern int cmd_buildid_list(int argc, const char **argv, const char *prefix);
 extern int cmd_diff(int argc, const char **argv, const char *prefix);
+extern int cmd_evlist(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
 extern int cmd_sched(int argc, const char **argv, const char *prefix);
 extern int cmd_list(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 16b5088..d695fe4 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -8,6 +8,7 @@ perf-bench			mainporcelain common
 perf-buildid-cache		mainporcelain common
 perf-buildid-list		mainporcelain common
 perf-diff			mainporcelain common
+perf-evlist			mainporcelain common
 perf-inject			mainporcelain common
 perf-list			mainporcelain common
 perf-sched			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 595d0f4..ec635b7 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -313,6 +313,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "buildid-cache", cmd_buildid_cache, 0 },
 		{ "buildid-list", cmd_buildid_list, 0 },
 		{ "diff",	cmd_diff,	0 },
+		{ "evlist",	cmd_evlist,	0 },
 		{ "help",	cmd_help,	0 },
 		{ "list",	cmd_list,	0 },
 		{ "record",	cmd_record,	0 },
-- 
1.6.2.5

