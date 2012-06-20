Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab2FTQzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:55:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2FTQzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:55:02 -0400
Date: Wed, 20 Jun 2012 09:54:43 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-buuz0j0gynseglxa76r01rdn@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Handle all event types in perf_evsel__name
Git-Commit-ID: a446083604fe2bafe0f46b1e95b22f7b06e3a63f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:54:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a446083604fe2bafe0f46b1e95b22f7b06e3a63f
Gitweb:     http://git.kernel.org/tip/a446083604fe2bafe0f46b1e95b22f7b06e3a63f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 12 Jun 2012 10:29:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:20 -0300

perf evsel: Handle all event types in perf_evsel__name

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
