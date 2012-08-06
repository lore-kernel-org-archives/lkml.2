Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab2HFKCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:02:09 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19524 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab2HFKCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:02:07 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 3/3] perf: mark a dso if it's used
Date: Mon,  6 Aug 2012 14:01:59 +0400
Message-Id: <1344247319-304069-4-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344247319-304069-1-git-send-email-avagin@openvz.org>
References: <1344247319-304069-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise they will be not written in an output file.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/builtin-inject.c |   11 +++++++++--
 tools/perf/util/build-id.c  |    2 +-
 tools/perf/util/build-id.h  |    5 +++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 247f41c..cb2fd77 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -14,6 +14,7 @@
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
+#include "util/build-id.h"
 
 
 static char		const *input_name	= "-";
@@ -281,13 +282,17 @@ static int perf_event__sched_stat(struct perf_tool *tool,
 
 		event_sw = &ent->event[0];
 		perf_session__parse_sample(session, event_sw, &sample_sw);
+
 		sample_sw.period = sample->period;
 		sample_sw.time = sample->time;
 		perf_session__synthesize_sample(session, event_sw, &sample_sw);
+
+		build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
 		perf_event__repipe(tool, event_sw, &sample_sw, machine);
 		return 0;
 	}
 
+	build_id__mark_dso_hit(tool, event, sample, evsel, machine);
 	perf_event__repipe(tool, event, sample, machine);
 
 	return 0;
@@ -321,12 +326,14 @@ static int __cmd_inject(void)
 
 	signal(SIGINT, sig_handler);
 
-	if (inject_build_ids) {
+	if (inject_build_ids || inject_sched_stat) {
 		perf_inject.sample	 = perf_event__inject_buildid;
 		perf_inject.mmap	 = perf_event__repipe_mmap;
 		perf_inject.fork	 = perf_event__repipe_task;
 		perf_inject.tracing_data = perf_event__repipe_tracing_data;
-	} else if (inject_sched_stat) {
+	}
+
+	if (inject_sched_stat) {
 		perf_inject.sample	= perf_event__sched_stat;
 		perf_inject.ordered_samples = true;
 	}
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index fd9a594..9ce0e11 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -16,7 +16,7 @@
 #include "session.h"
 #include "tool.h"
 
-static int build_id__mark_dso_hit(struct perf_tool *tool __used,
+int build_id__mark_dso_hit(struct perf_tool *tool __used,
 				  union perf_event *event,
 				  struct perf_sample *sample __used,
 				  struct perf_evsel *evsel __used,
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index a993ba8..032a968 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -7,4 +7,9 @@ extern struct perf_tool build_id__mark_dso_hit_ops;
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
 
+int build_id__mark_dso_hit(struct perf_tool *tool __used,
+				  union perf_event *event,
+				  struct perf_sample *sample __used,
+				  struct perf_evsel *evsel __used,
+				  struct machine *machine);
 #endif
-- 
1.7.1

