Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2HGM4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:56:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:30634 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab2HGM4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:56:09 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 4/4] perf: mark a dso if it's used
Date: Tue,  7 Aug 2012 16:56:05 +0400
Message-Id: <1344344165-369636-5-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344344165-369636-1-git-send-email-avagin@openvz.org>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise they will be not written in an output file.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/builtin-inject.c |   10 ++++++++--
 tools/perf/util/build-id.c  |    2 +-
 tools/perf/util/build-id.h  |    5 +++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 9b3393a..be2edae 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -15,6 +15,7 @@
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
+#include "util/build-id.h"
 
 static const char	*input_name	= "-";
 static const char	*output_name	= "-";
@@ -282,10 +283,12 @@ static int perf_event__sched_stat(struct perf_tool *tool,
 		sample_sw.time = sample->time;
 		perf_evsel__synthesize_sample(evsel, event_sw, &sample_sw, false);
 
+		build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
 		perf_event__repipe(tool, event_sw, &sample_sw, machine);
 		return 0;
 	}
 
+	build_id__mark_dso_hit(tool, event, sample, evsel, machine);
 	perf_event__repipe(tool, event, sample, machine);
 
 	return 0;
@@ -320,11 +323,14 @@ static int __cmd_inject(void)
 
 	signal(SIGINT, sig_handler);
 
-	if (inject_build_ids) {
-		perf_inject.sample	 = perf_event__inject_buildid;
+	if (inject_build_ids | inject_sched_stat) {
 		perf_inject.mmap	 = perf_event__repipe_mmap;
 		perf_inject.fork	 = perf_event__repipe_task;
 		perf_inject.tracing_data = perf_event__repipe_tracing_data;
+	}
+
+	if (inject_build_ids) {
+		perf_inject.sample	 = perf_event__inject_buildid;
 	} else if (inject_sched_stat) {
 		perf_inject.sample	 = perf_event__sched_stat;
 		perf_inject.ordered_samples = true;
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

