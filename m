Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2FSSC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:02:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:43337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2FSSAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/20] perf evsel: Handle all event types in perf_evsel__name
Date: Tue, 19 Jun 2012 14:50:13 -0300
Message-Id: <1340128221-17348-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now to convert all event_name users to perf_evsel__name.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-buuz0j0gynseglxa76r01rdn@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c        |   24 +++++++++++-------------
 tools/perf/util/parse-events.c |   21 +++------------------
 2 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2da0473..2ddc812 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -252,6 +252,11 @@ static int perf_evsel__hw_cache_name(struct perf_evsel *evsel, char *bf, size_t
 	return ret + perf_evsel__add_modifiers(evsel, bf + ret, size - ret);
 }
 
+static int perf_evsel__tracepoint_name(struct perf_evsel *evsel, char *bf, size_t size)
+{
+	return scnprintf(bf, size, "%s", evsel->name ?: "unknown tracepoint");
+}
+
 int perf_evsel__name(struct perf_evsel *evsel, char *bf, size_t size)
 {
 	int ret;
@@ -273,20 +278,13 @@ int perf_evsel__name(struct perf_evsel *evsel, char *bf, size_t size)
 		ret = perf_evsel__sw_name(evsel, bf, size);
 		break;
 
+	case PERF_TYPE_TRACEPOINT:
+		ret = perf_evsel__tracepoint_name(evsel, bf, size);
+		break;
+
 	default:
-		/*
-		 * FIXME
- 		 *
-		 * This is the minimal perf_evsel__name so that we can
-		 * reconstruct event names taking into account event modifiers.
-		 *
-		 * The old event_name uses it now for raw anr hw events, so that
-		 * we don't drag all the parsing stuff into the python binding.
-		 *
-		 * On the next devel cycle the rest of the event naming will be
-		 * brought here.
- 		 */
-		return 0;
+		ret = scnprintf(bf, size, "%s", "unknown attr type");
+		break;
 	}
 
 	return ret;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 641c4ac..d73690b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -203,24 +203,9 @@ const char *event_type(int type)
 
 const char *event_name(struct perf_evsel *evsel)
 {
-	u64 config = evsel->attr.config;
-	int type = evsel->attr.type;
-
-	if (type == PERF_TYPE_RAW || type == PERF_TYPE_HARDWARE ||
-	    type == PERF_TYPE_SOFTWARE || type == PERF_TYPE_HW_CACHE) {
-		/*
- 		 * XXX minimal fix, see comment on perf_evsen__name, this static buffer
- 		 * will go away together with event_name in the next devel cycle.
- 		 */
-		static char bf[128];
-		perf_evsel__name(evsel, bf, sizeof(bf));
-		return bf;
-	}
-
-	if (evsel->name)
-		return evsel->name;
-
-	return __event_name(type, config);
+	static char bf[128];
+	perf_evsel__name(evsel, bf, sizeof(bf));
+	return bf;
 }
 
 const char *__event_name(int type, u64 config)
-- 
1.7.1

