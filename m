Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2FSSDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:03:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33392 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2FSSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/20] perf tools: Remove __event_name
Date: Tue, 19 Jun 2012 14:50:17 -0300
Message-Id: <1340128221-17348-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Not needed anymore, the parsing code can just leave evsel->name as NULL
and the first call to perf_evsel__name() will do exactly what was being
pre-cached using __event_name().

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cn2eiijcinnc97buod8cs34m@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   61 ++++------------------------------------
 tools/perf/util/parse-events.h |    1 -
 2 files changed, 6 insertions(+), 56 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 517e647..eacf932 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -161,24 +161,6 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	return NULL;
 }
 
-#define TP_PATH_LEN (MAX_EVENT_LENGTH * 2 + 1)
-static const char *tracepoint_id_to_name(u64 config)
-{
-	static char buf[TP_PATH_LEN];
-	struct tracepoint_path *path;
-
-	path = tracepoint_id_to_path(config);
-	if (path) {
-		snprintf(buf, TP_PATH_LEN, "%s:%s", path->system, path->name);
-		free(path->name);
-		free(path->system);
-		free(path);
-	} else
-		snprintf(buf, TP_PATH_LEN, "%s:%s", "unknown", "unknown");
-
-	return buf;
-}
-
 const char *event_type(int type)
 {
 	switch (type) {
@@ -201,36 +183,6 @@ const char *event_type(int type)
 	return "unknown";
 }
 
-const char *__event_name(int type, u64 config)
-{
-	static char buf[32];
-
-	if (type == PERF_TYPE_RAW) {
-		sprintf(buf, "raw 0x%" PRIx64, config);
-		return buf;
-	}
-
-	switch (type) {
-	case PERF_TYPE_HARDWARE:
-		return __perf_evsel__hw_name(config);
-
-	case PERF_TYPE_HW_CACHE:
-		__perf_evsel__hw_cache_name(config, buf, sizeof(buf));
-		return buf;
-
-	case PERF_TYPE_SOFTWARE:
-		return __perf_evsel__sw_name(config);
-
-	case PERF_TYPE_TRACEPOINT:
-		return tracepoint_id_to_name(config);
-
-	default:
-		break;
-	}
-
-	return "unknown";
-}
-
 static int add_event(struct list_head **_list, int *idx,
 		     struct perf_event_attr *attr, char *name)
 {
@@ -252,7 +204,8 @@ static int add_event(struct list_head **_list, int *idx,
 		return -ENOMEM;
 	}
 
-	evsel->name = strdup(name);
+	if (name)
+		evsel->name = strdup(name);
 	list_add_tail(&evsel->node, list);
 	*_list = list;
 	return 0;
@@ -545,8 +498,7 @@ int parse_events_add_numeric(struct list_head **list, int *idx,
 	    config_attr(&attr, head_config, 1))
 		return -EINVAL;
 
-	return add_event(list, idx, &attr,
-			 (char *) __event_name(type, config));
+	return add_event(list, idx, &attr, NULL);
 }
 
 static int parse_events__is_name_term(struct parse_events__term *term)
@@ -554,8 +506,7 @@ static int parse_events__is_name_term(struct parse_events__term *term)
 	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
 }
 
-static char *pmu_event_name(struct perf_event_attr *attr,
-			    struct list_head *head_terms)
+static char *pmu_event_name(struct list_head *head_terms)
 {
 	struct parse_events__term *term;
 
@@ -563,7 +514,7 @@ static char *pmu_event_name(struct perf_event_attr *attr,
 		if (parse_events__is_name_term(term))
 			return term->val.str;
 
-	return (char *) __event_name(PERF_TYPE_RAW, attr->config);
+	return NULL;
 }
 
 int parse_events_add_pmu(struct list_head **list, int *idx,
@@ -588,7 +539,7 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 		return -EINVAL;
 
 	return add_event(list, idx, &attr,
-			 pmu_event_name(&attr, head_config));
+			 pmu_event_name(head_config));
 }
 
 void parse_events_update_lists(struct list_head *list_event,
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index d7eb070..1784f06 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -26,7 +26,6 @@ extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern bool have_tracepoints(struct list_head *evlist);
 
 const char *event_type(int type);
-extern const char *__event_name(int type, u64 config);
 
 extern int parse_events_option(const struct option *opt, const char *str,
 			       int unset);
-- 
1.7.1

