Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1CAQsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:48:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:47598 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856Ab1CAQsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:48:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,248,1297065600"; 
   d="scan'208";a="607825653"
Subject: [PATCH v2 3/4] perf: Add support to the perf tool to specify extra
 values
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 00:48:18 +0800
Message-Id: <1298998098.2170.67.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Change logs:
- Use ":" to specify extra value since "," was already used for multiple
events.

Add support to the perf tool to specify extra values for raw events and
pass them to the kernel.
The new format is -e rXXXX[:YYYY]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com> 
---
 tools/perf/builtin-report.c         |    7 ++++---
 tools/perf/util/parse-events.c      |   24 +++++++++++++++++++-----
 tools/perf/util/parse-events.h      |    2 +-
 tools/perf/util/ui/browsers/hists.c |    3 ++-
 4 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index dddcc7e..724f65b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -201,7 +201,8 @@ static int process_read_event(union perf_event *event,
 	attr = perf_header__find_attr(event->read.id, &session->header);
 
 	if (show_threads) {
-		const char *name = attr ? __event_name(attr->type, attr->config)
+		const char *name = attr ? __event_name(attr->type, attr->config,
+						       0)
 				   : "unknown";
 		perf_read_values_add_value(&show_threads_values,
 					   event->read.pid, event->read.tid,
@@ -211,7 +212,7 @@ static int process_read_event(union perf_event *event,
 	}
 
 	dump_printf(": %d %d %s %" PRIu64 "\n", event->read.pid, event->read.tid,
-		    attr ? __event_name(attr->type, attr->config) : "FAIL",
+		    attr ? __event_name(attr->type, attr->config, 0) : "FAIL",
 		    event->read.value);
 
 	return 0;
@@ -291,7 +292,7 @@ static int hists__tty_browse_tree(struct rb_root *tree, const char *help)
 		const char *evname = NULL;
 
 		if (rb_first(&hists->entries) != rb_last(&hists->entries))
-			evname = __event_name(hists->type, hists->config);
+			evname = __event_name(hists->type, hists->config, 0);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, NULL, false, stdout);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 54a7e26..7838dfb 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -271,15 +271,18 @@ const char *event_name(struct perf_evsel *evsel)
 	if (evsel->name)
 		return evsel->name;
 
-	return __event_name(type, config);
+	return __event_name(type, config, evsel->attr.config1);
 }
 
-const char *__event_name(int type, u64 config)
+const char *__event_name(int type, u64 config, u64 extra)
 {
 	static char buf[32];
+	int n;
 
 	if (type == PERF_TYPE_RAW) {
-		sprintf(buf, "raw 0x%" PRIx64, config);
+		n = sprintf(buf, "raw 0x%" PRIx64, config);
+		if (extra)
+			sprintf(buf + n, ":%#" PRIx64, extra);
 		return buf;
 	}
 
@@ -666,9 +669,20 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
-		*strp = str + n + 1;
+		str += n + 1;
+		*strp = str;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
+
+		if (*str++ == ':') {
+			n = hex2u64(str + 1, &config);
+			if (n > 0) {
+				attr->config1 = config;
+				str += n + 1;
+				*strp = str;
+			}
+		}
+
 		return EVT_HANDLED;
 	}
 	return EVT_FAILED;
@@ -1035,7 +1049,7 @@ void print_events(const char *event_glob)
 
 	printf("\n");
 	printf("  %-42s [%s]\n",
-		"rNNN (see 'perf list --help' on how to encode it)",
+		"rNNN[:EEE] (see 'perf list --help' on how to encode it)",
 	       event_type_descriptors[PERF_TYPE_RAW]);
 	printf("\n");
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 212f88e..0fe700c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -21,7 +21,7 @@ extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern bool have_tracepoints(struct list_head *evlist);
 
 const char *event_name(struct perf_evsel *event);
-extern const char *__event_name(int type, u64 config);
+extern const char *__event_name(int type, u64 config, u64 extra);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 497b3c4..f780bc7 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -984,7 +984,8 @@ int hists__tui_browse_tree(struct rb_root *self, const char *help, int evidx)
 
 	while (nd) {
 		struct hists *hists = rb_entry(nd, struct hists, rb_node);
-		const char *ev_name = __event_name(hists->type, hists->config);
+		const char *ev_name = __event_name(hists->type, hists->config,
+						   0);
 
 		key = hists__browse(hists, help, ev_name, evidx);
 		switch (key) {
-- 
1.7.3







