Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1KRSjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:39:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64415 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1KRSjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:39:53 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, fweisbec@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf script: Add comm filtering option
Date: Fri, 18 Nov 2011 11:39:45 -0700
Message-Id: <1321641585-5643-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows collecting events system wide and then pulling out events
for a specific task name(s). e.g,

    perf script -c gnome-shell,gnome-terminal

Applies on top of:
    https://lkml.org/lkml/2011/11/13/74

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-script.txt |    4 ++++
 tools/perf/builtin-script.c              |   11 +++++++++++
 tools/perf/util/strlist.c                |   15 +++++++++++++++
 tools/perf/util/strlist.h                |    2 ++
 tools/perf/util/symbol.c                 |   14 --------------
 5 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 3613b0a..e7a9378 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -188,6 +188,10 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+-c::
+--comms=::
+    Comma separated list of comms. Only events for these comms are shown.
+
 -I::
 --show-info::
 	Display extended information about the perf.data file. This adds
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 01329ca..6b867ba 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -13,6 +13,7 @@
 #include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
+#include "util/strlist.h"
 #include <linux/bitmap.h>
 
 static char const		*script_name;
@@ -24,6 +25,8 @@ extern const struct option	record_options[];
 static bool			no_callchain;
 static bool			show_full_info;
 static const char		*cpu_list;
+static const char      *comm_list_str;
+struct strlist         *comm_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
 enum perf_output_field {
@@ -461,6 +464,9 @@ static int process_sample_event(union perf_event *event,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
+	if (comm_list && !strlist__has_entry(comm_list, thread->comm))
+		return 0;
+
 	scripting_ops->process_event(event, sample, evsel, session, thread);
 
 	session->hists.stats.total_period += sample->period;
@@ -1084,6 +1090,8 @@ static const struct option options[] = {
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('c', "comms", &comm_list_str, "comm[,comm...]",
+		   "only display events for these comms"),
 	OPT_BOOLEAN('I', "show-info", &show_full_info,
 		    "display extended information from perf.data file"),
 	OPT_END()
@@ -1256,6 +1264,9 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		exit(-1);
 	}
 
+	if (setup_list(&comm_list, comm_list_str, "comm") < 0)
+		return -1;
+
 	if (symbol__init() < 0)
 		return -1;
 	if (!script_name)
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 6783a20..145749d 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -198,3 +198,18 @@ struct str_node *strlist__entry(const struct strlist *self, unsigned int idx)
 
 	return NULL;
 }
+
+int setup_list(struct strlist **list, const char *list_str,
+	       const char *list_name)
+{
+	if (list_str == NULL)
+		return 0;
+
+	*list = strlist__new(true, list_str);
+	if (!*list) {
+		pr_err("problems parsing %s list\n", list_name);
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 3ba8390..695bd4c 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -24,6 +24,8 @@ int strlist__add(struct strlist *self, const char *str);
 
 struct str_node *strlist__entry(const struct strlist *self, unsigned int idx);
 struct str_node *strlist__find(struct strlist *self, const char *entry);
+int setup_list(struct strlist **list, const char *list_str,
+	       const char *list_name);
 
 static inline bool strlist__has_entry(struct strlist *self, const char *entry)
 {
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 632b50c..48969d2 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2525,20 +2525,6 @@ size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp)
 	return printed;
 }
 
-static int setup_list(struct strlist **list, const char *list_str,
-		      const char *list_name)
-{
-	if (list_str == NULL)
-		return 0;
-
-	*list = strlist__new(true, list_str);
-	if (!*list) {
-		pr_err("problems parsing %s list\n", list_name);
-		return -1;
-	}
-	return 0;
-}
-
 static bool symbol__read_kptr_restrict(void)
 {
 	bool value = false;
-- 
1.7.7.1

