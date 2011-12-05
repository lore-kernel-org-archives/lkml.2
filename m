Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab1LEM4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:56:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1LEM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:56:18 -0500
Date: Mon, 5 Dec 2011 04:55:24 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-0vwdpjcwbjezw459lw5n3ew1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use evsel->attr.sample_type instead of session->sample_type
Git-Commit-ID: e3f42609628a20da92ecbc2d81053cc82c90a071
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:55:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3f42609628a20da92ecbc2d81053cc82c90a071
Gitweb:     http://git.kernel.org/tip/e3f42609628a20da92ecbc2d81053cc82c90a071
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 16 Nov 2011 17:02:54 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:38:14 -0200

perf tools: Use evsel->attr.sample_type instead of session->sample_type

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
