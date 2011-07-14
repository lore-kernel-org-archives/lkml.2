Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1GNJZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:25:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab1GNJZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:25:52 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/3] perf tools: De-opt the parse_events function
Date: Thu, 14 Jul 2011 11:25:32 +0200
Message-Id: <1310635534-4013-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1310635534-4013-1-git-send-email-jolsa@redhat.com>
References: <1310635534-4013-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving out the option parameter from parse_events function,
and adding new parse_events_option function instead.

The option parameter is used only to carry "struct perf_evlist"
pointer for chaining new events. Putting it away, enable us
to call parse_events from other places without using the
option parameter.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c    |    2 +-
 tools/perf/builtin-stat.c      |    2 +-
 tools/perf/builtin-top.c       |    2 +-
 tools/perf/util/parse-events.c |   26 ++++++++++++++++----------
 tools/perf/util/parse-events.h |    6 +++++-
 5 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8e2c857..80dc5b7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -740,7 +740,7 @@ static bool force, append_file;
 const struct option record_options[] = {
 	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
-		     parse_events),
+		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
 	OPT_INTEGER('p', "pid", &target_pid,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1d08c80..1ad04ce 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1032,7 +1032,7 @@ static int stat__set_big_num(const struct option *opt __used,
 static const struct option options[] = {
 	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
-		     parse_events),
+		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f2f3f49..a43433f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -990,7 +990,7 @@ static const char * const top_usage[] = {
 static const struct option options[] = {
 	OPT_CALLBACK('e', "event", &top.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
-		     parse_events),
+		     parse_events_option),
 	OPT_INTEGER('c', "count", &default_interval,
 		    "event period to sample"),
 	OPT_INTEGER('p', "pid", &top.target_pid,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c0e21ae..4ea7e19 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -478,7 +478,7 @@ parse_single_tracepoint_event(char *sys_name,
 /* sys + ':' + event + ':' + flags*/
 #define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
 static enum event_result
-parse_multiple_tracepoint_event(const struct option *opt, char *sys_name,
+parse_multiple_tracepoint_event(struct perf_evlist *evlist, char *sys_name,
 				const char *evt_exp, char *flags)
 {
 	char evt_path[MAXPATHLEN];
@@ -512,7 +512,7 @@ parse_multiple_tracepoint_event(const struct option *opt, char *sys_name,
 		if (len < 0)
 			return EVT_FAILED;
 
-		if (parse_events(opt, event_opt, 0))
+		if (parse_events(evlist, event_opt, 0))
 			return EVT_FAILED;
 	}
 
@@ -520,7 +520,7 @@ parse_multiple_tracepoint_event(const struct option *opt, char *sys_name,
 }
 
 static enum event_result
-parse_tracepoint_event(const struct option *opt, const char **strp,
+parse_tracepoint_event(struct perf_evlist *evlist, const char **strp,
 		       struct perf_event_attr *attr)
 {
 	const char *evt_name;
@@ -560,8 +560,8 @@ parse_tracepoint_event(const struct option *opt, const char **strp,
 		return EVT_FAILED;
 	if (strpbrk(evt_name, "*?")) {
 		*strp += strlen(sys_name) + evt_length + 1; /* 1 == the ':' */
-		return parse_multiple_tracepoint_event(opt, sys_name, evt_name,
-						       flags);
+		return parse_multiple_tracepoint_event(evlist, sys_name,
+						       evt_name, flags);
 	} else {
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, attr, strp);
@@ -781,12 +781,12 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
  * Symbolic names are (almost) exactly matched.
  */
 static enum event_result
-parse_event_symbols(const struct option *opt, const char **str,
+parse_event_symbols(struct perf_evlist *evlist, const char **str,
 		    struct perf_event_attr *attr)
 {
 	enum event_result ret;
 
-	ret = parse_tracepoint_event(opt, str, attr);
+	ret = parse_tracepoint_event(evlist, str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
 
@@ -825,9 +825,8 @@ modifier:
 	return ret;
 }
 
-int parse_events(const struct option *opt, const char *str, int unset __used)
+int parse_events(struct perf_evlist *evlist , const char *str, int unset __used)
 {
-	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
 	struct perf_event_attr attr;
 	enum event_result ret;
 	const char *ostr;
@@ -835,7 +834,7 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 	for (;;) {
 		ostr = str;
 		memset(&attr, 0, sizeof(attr));
-		ret = parse_event_symbols(opt, &str, &attr);
+		ret = parse_event_symbols(evlist, &str, &attr);
 		if (ret == EVT_FAILED)
 			return -1;
 
@@ -866,6 +865,13 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 	return 0;
 }
 
+int parse_events_option(const struct option *opt, const char *str,
+			int unset __used)
+{
+	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
+	return parse_events(evlist, str, unset);
+}
+
 int parse_filter(const struct option *opt, const char *str,
 		 int unset __used)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 746d3fc..2f8e375 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -8,6 +8,7 @@
 
 struct list_head;
 struct perf_evsel;
+struct perf_evlist;
 
 struct option;
 
@@ -24,7 +25,10 @@ const char *event_type(int type);
 const char *event_name(struct perf_evsel *event);
 extern const char *__event_name(int type, u64 config);
 
-extern int parse_events(const struct option *opt, const char *str, int unset);
+extern int parse_events_option(const struct option *opt, const char *str,
+			       int unset);
+extern int parse_events(struct perf_evlist *evlist, const char *str,
+			int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
-- 
1.7.4

