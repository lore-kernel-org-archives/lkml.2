Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0KKQPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:15:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55097 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0KKQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:15:33 -0500
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] perf: Add support for extra parameters for raw events
Date: Thu, 11 Nov 2010 17:15:16 +0100
Message-Id: <1289492117-18066-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support to the perf tool to specify extra values for raw events
and pass them to the kernel.

The new format is -e rXXXX[,YYYY]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-list.txt |    6 ++++++
 tools/perf/builtin-report.c            |    7 ++++---
 tools/perf/util/parse-events.c         |   26 ++++++++++++++++++++------
 tools/perf/util/parse-events.h         |    2 +-
 tools/perf/util/ui/browsers/hists.c    |    3 ++-
 5 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 399751b..c398390 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -61,6 +61,12 @@ raw encoding of 0x1A8 can be used:
 You should refer to the processor specific documentation for getting these
 details. Some of them are referenced in the SEE ALSO section below.
 
+Some special events like the Intel OFFCORE_RESPONSE events require
+extra parameters.  These can be specified by appending a command and
+the extra parameter as a hex number. Since the bitmasks can be
+complicated to compute it is recommended to use a suitable mapping file
+with --event-map.
+
 OPTIONS
 -------
 None
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5de405d..7f6bcfb 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -187,7 +187,8 @@ static int process_read_event(event_t *event, struct perf_session *session __use
 	attr = perf_header__find_attr(event->read.id, &session->header);
 
 	if (show_threads) {
-		const char *name = attr ? __event_name(attr->type, attr->config)
+		const char *name = attr ? __event_name(attr->type, attr->config,
+						       0)
 				   : "unknown";
 		perf_read_values_add_value(&show_threads_values,
 					   event->read.pid, event->read.tid,
@@ -197,7 +198,7 @@ static int process_read_event(event_t *event, struct perf_session *session __use
 	}
 
 	dump_printf(": %d %d %s %Lu\n", event->read.pid, event->read.tid,
-		    attr ? __event_name(attr->type, attr->config) : "FAIL",
+		    attr ? __event_name(attr->type, attr->config, 0) : "FAIL",
 		    event->read.value);
 
 	return 0;
@@ -275,7 +276,7 @@ static int hists__tty_browse_tree(struct rb_root *tree, const char *help)
 		const char *evname = NULL;
 
 		if (rb_first(&hists->entries) != rb_last(&hists->entries))
-			evname = __event_name(hists->type, hists->config);
+			evname = __event_name(hists->type, hists->config, 0);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, NULL, false, stdout);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2cc7b3d..0fd3b8f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -279,15 +279,18 @@ const char *event_name(int counter)
 	u64 config = attrs[counter].config;
 	int type = attrs[counter].type;
 
-	return __event_name(type, config);
+	return __event_name(type, config, attrs[counter].event_extra);
 }
 
-const char *__event_name(int type, u64 config)
+const char *__event_name(int type, u64 config, u64 extra)
 {
-	static char buf[32];
+	static char buf[64];
+	int n;
 
 	if (type == PERF_TYPE_RAW) {
-		sprintf(buf, "raw 0x%llx", config);
+		n = sprintf(buf, "raw 0x%llx", config);
+		if (extra)
+			sprintf(buf + n, ",%#llx", extra);
 		return buf;
 	}
 
@@ -669,9 +672,20 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
-		*strp = str + n + 1;
+		str += n + 1;
+		*strp = str;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
+
+		if (*str++ == ',') {
+			n = hex2u64(str + 1, &config);
+			if (n > 0) {
+				attr->event_extra = config;
+				str += n + 1;
+				*strp = str;
+			}
+		}
+
 		return EVT_HANDLED;
 	}
 	return EVT_FAILED;
@@ -983,7 +997,7 @@ void print_events(void)
 
 	printf("\n");
 	printf("  %-42s [%s]\n",
-		"rNNN (see 'perf list --help' on how to encode it)",
+		"rNNN[,EEE] (see 'perf list --help' on how to encode it)",
 	       event_type_descriptors[PERF_TYPE_RAW]);
 	printf("\n");
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 1d6df9c..a4e20ed 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -21,7 +21,7 @@ extern struct perf_event_attr attrs[MAX_COUNTERS];
 extern char *filters[MAX_COUNTERS];
 
 extern const char *event_name(int ctr);
-extern const char *__event_name(int type, u64 config);
+extern const char *__event_name(int type, u64 config, u64 extra);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index ebda8c3..fdbdfe1 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -991,7 +991,8 @@ int hists__tui_browse_tree(struct rb_root *self, const char *help)
 
 	while (nd) {
 		struct hists *hists = rb_entry(nd, struct hists, rb_node);
-		const char *ev_name = __event_name(hists->type, hists->config);
+		const char *ev_name = __event_name(hists->type, hists->config,
+						   0);
 
 		key = hists__browse(hists, help, ev_name);
 		switch (key) {
-- 
1.7.1

