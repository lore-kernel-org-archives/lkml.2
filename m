Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2FTQ6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:58:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2FTQ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:58:32 -0400
Date: Wed, 20 Jun 2012 09:58:13 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-cn2eiijcinnc97buod8cs34m@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove __event_name
Git-Commit-ID: 9db1763c72b1548626ae9d634015de4f07ef624f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:58:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9db1763c72b1548626ae9d634015de4f07ef624f
Gitweb:     http://git.kernel.org/tip/9db1763c72b1548626ae9d634015de4f07ef624f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 12 Jun 2012 13:45:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:21 -0300

perf tools: Remove __event_name

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
