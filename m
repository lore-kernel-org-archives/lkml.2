Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2FTQyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:54:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2FTQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:54:10 -0400
Date: Wed, 20 Jun 2012 09:53:50 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-97ltkmj7v23kyhflltf6iz5n@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Reconstruct sw event with modifiers from perf_event_attr
Git-Commit-ID: 335c2f5d25319b208fb8b444e6f3099a806a33bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:53:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  335c2f5d25319b208fb8b444e6f3099a806a33bf
Gitweb:     http://git.kernel.org/tip/335c2f5d25319b208fb8b444e6f3099a806a33bf
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 11 Jun 2012 14:36:20 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:20 -0300

perf tools: Reconstruct sw event with modifiers from perf_event_attr

  [root@sandy ~]# perf record -e task-clock:u -a usleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.482 MB perf.data (~21073 samples) ]
  [root@sandy ~]#

Before:

  [root@sandy ~]# perf evlist
  task-clock
  [root@sandy ~]#

After:

  [root@sandy ~]# perf evlist
  task-clock:u
  [root@sandy ~]#

Ditto for other tools.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-97ltkmj7v23kyhflltf6iz5n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c        |   29 +++++++++++++++++++++++++++++
 tools/perf/util/evsel.h        |    2 ++
 tools/perf/util/parse-events.c |   19 +++----------------
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 47f1fe2..2da0473 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -128,6 +128,31 @@ static int perf_evsel__hw_name(struct perf_evsel *evsel, char *bf, size_t size)
 	return r + perf_evsel__add_modifiers(evsel, bf + r, size - r);
 }
 
+static const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX] = {
+	"cpu-clock",
+	"task-clock",
+	"page-faults",
+	"context-switches",
+	"CPU-migrations",
+	"minor-faults",
+	"major-faults",
+	"alignment-faults",
+	"emulation-faults",
+};
+
+const char *__perf_evsel__sw_name(u64 config)
+{
+	if (config < PERF_COUNT_SW_MAX && perf_evsel__sw_names[config])
+		return perf_evsel__sw_names[config];
+	return "unknown-software";
+}
+
+static int perf_evsel__sw_name(struct perf_evsel *evsel, char *bf, size_t size)
+{
+	int r = scnprintf(bf, size, "%s", __perf_evsel__sw_name(evsel->attr.config));
+	return r + perf_evsel__add_modifiers(evsel, bf + r, size - r);
+}
+
 const char *perf_evsel__hw_cache[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_EVSEL__MAX_ALIASES] = {
  { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
@@ -244,6 +269,10 @@ int perf_evsel__name(struct perf_evsel *evsel, char *bf, size_t size)
 		ret = perf_evsel__hw_cache_name(evsel, bf, size);
 		break;
 
+	case PERF_TYPE_SOFTWARE:
+		ret = perf_evsel__sw_name(evsel, bf, size);
+		break;
+
 	default:
 		/*
 		 * FIXME
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 5bf946a..9ae64d9 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -98,6 +98,8 @@ int __perf_evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result,
 int __perf_evsel__hw_cache_name(u64 config, char *bf, size_t size);
 
 const char *__perf_evsel__hw_name(u64 config);
+const char *__perf_evsel__sw_name(u64 config);
+
 int perf_evsel__name(struct perf_evsel *evsel, char *bf, size_t size);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c8f8cf4..641c4ac 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -62,18 +62,6 @@ static struct event_symbol event_symbols[] = {
 #define PERF_EVENT_TYPE(config)		__PERF_EVENT_FIELD(config, TYPE)
 #define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
 
-static const char *sw_event_names[PERF_COUNT_SW_MAX] = {
-	"cpu-clock",
-	"task-clock",
-	"page-faults",
-	"context-switches",
-	"CPU-migrations",
-	"minor-faults",
-	"major-faults",
-	"alignment-faults",
-	"emulation-faults",
-};
-
 #define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
 	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
 	if (sys_dirent.d_type == DT_DIR &&				       \
@@ -218,7 +206,8 @@ const char *event_name(struct perf_evsel *evsel)
 	u64 config = evsel->attr.config;
 	int type = evsel->attr.type;
 
-	if (type == PERF_TYPE_RAW || type == PERF_TYPE_HARDWARE || type == PERF_TYPE_HW_CACHE) {
+	if (type == PERF_TYPE_RAW || type == PERF_TYPE_HARDWARE ||
+	    type == PERF_TYPE_SOFTWARE || type == PERF_TYPE_HW_CACHE) {
 		/*
  		 * XXX minimal fix, see comment on perf_evsen__name, this static buffer
  		 * will go away together with event_name in the next devel cycle.
@@ -252,9 +241,7 @@ const char *__event_name(int type, u64 config)
 		return buf;
 
 	case PERF_TYPE_SOFTWARE:
-		if (config < PERF_COUNT_SW_MAX && sw_event_names[config])
-			return sw_event_names[config];
-		return "unknown-software";
+		return __perf_evsel__sw_name(config);
 
 	case PERF_TYPE_TRACEPOINT:
 		return tracepoint_id_to_name(config);
