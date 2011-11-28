Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1K1XRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:17:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:34304 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1K1XOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/25] perf tools: Use evsel->attr.sample_type instead of session->sample_type
Date: Mon, 28 Nov 2011 21:14:17 -0200
Message-Id: <1322522066-21879-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Eventually session->sample_type will go away as we want to support
multiple sample types per session, so use it from the evsel which is a
step in that direction.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0vwdpjcwbjezw459lw5n3ew1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c     |    5 +++--
 tools/perf/builtin-timechart.c |    9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 5177964..d51af0b 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3,6 +3,7 @@
 
 #include "util/util.h"
 #include "util/cache.h"
+#include "util/evsel.h"
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/header.h"
@@ -1603,12 +1604,12 @@ static void process_raw_event(union perf_event *raw_event __used,
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
-				struct perf_evsel *evsel __used,
+				struct perf_evsel *evsel,
 				struct perf_session *session)
 {
 	struct thread *thread;
 
-	if (!(session->sample_type & PERF_SAMPLE_RAW))
+	if (!(evsel->attr.sample_type & PERF_SAMPLE_RAW))
 		return 0;
 
 	thread = perf_session__findnew(session, sample->pid);
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index aa26f4d..3fc52b1 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -19,6 +19,7 @@
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
+#include "util/evsel.h"
 #include <linux/rbtree.h>
 #include "util/symbol.h"
 #include "util/callchain.h"
@@ -488,12 +489,12 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 
 static int process_sample_event(union perf_event *event __used,
 				struct perf_sample *sample,
-				struct perf_evsel *evsel __used,
-				struct perf_session *session)
+				struct perf_evsel *evsel,
+				struct perf_session *session __used)
 {
 	struct trace_entry *te;
 
-	if (session->sample_type & PERF_SAMPLE_TIME) {
+	if (evsel->attr.sample_type & PERF_SAMPLE_TIME) {
 		if (!first_time || first_time > sample->time)
 			first_time = sample->time;
 		if (last_time < sample->time)
@@ -501,7 +502,7 @@ static int process_sample_event(union perf_event *event __used,
 	}
 
 	te = (void *)sample->raw_data;
-	if (session->sample_type & PERF_SAMPLE_RAW && sample->raw_size > 0) {
+	if ((evsel->attr.sample_type & PERF_SAMPLE_RAW) && sample->raw_size > 0) {
 		char *event_str;
 #ifdef SUPPORT_OLD_POWER_EVENTS
 		struct power_entry_old *peo;
-- 
1.7.8.rc0.35.gee6df

