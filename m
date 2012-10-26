Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab2JZPLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:11:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54945 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:11:37 -0400
Date: Fri, 26 Oct 2012 08:11:21 -0700
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-54a3cf59b53b3f01989a28344ecf4cb68217a6f6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, avagin@openvz.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, avagin@openvz.org
In-Reply-To: <1344344165-369636-5-git-send-email-avagin@openvz.org>
References: <1344344165-369636-5-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf inject: Mark a dso if it's used
Git-Commit-ID: 54a3cf59b53b3f01989a28344ecf4cb68217a6f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 08:11:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54a3cf59b53b3f01989a28344ecf4cb68217a6f6
Gitweb:     http://git.kernel.org/tip/54a3cf59b53b3f01989a28344ecf4cb68217a6f6
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Tue, 7 Aug 2012 16:56:05 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Oct 2012 11:22:25 -0200

perf inject: Mark a dso if it's used

Otherwise they will be not written in an output file.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344344165-369636-5-git-send-email-avagin@openvz.org
[ committer note: Fixed up wrt changes made in the immediate previous patches ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c |   11 ++++++++---
 tools/perf/util/build-id.c  |   10 +++++-----
 tools/perf/util/build-id.h  |    4 ++++
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index a4a3072..84ad6ab 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -14,6 +14,7 @@
 #include "util/session.h"
 #include "util/tool.h"
 #include "util/debug.h"
+#include "util/build-id.h"
 
 #include "util/parse-options.h"
 
@@ -116,6 +117,8 @@ static int perf_event__repipe_sample(struct perf_tool *tool,
 		return f(tool, event, sample, evsel, machine);
 	}
 
+	build_id__mark_dso_hit(tool, event, sample, evsel, machine);
+
 	return perf_event__repipe_synth(tool, event, machine);
 }
 
@@ -310,6 +313,7 @@ found:
 	sample_sw.time	 = sample->time;
 	perf_event__synthesize_sample(event_sw, evsel->attr.sample_type,
 				      &sample_sw, false);
+	build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
 	return perf_event__repipe(tool, event_sw, &sample_sw, machine);
 }
 
@@ -342,8 +346,7 @@ static int __cmd_inject(struct perf_inject *inject)
 
 	signal(SIGINT, sig_handler);
 
-	if (inject->build_ids) {
-		inject->tool.sample	  = perf_event__inject_buildid;
+	if (inject->build_ids || inject->sched_stat) {
 		inject->tool.mmap	  = perf_event__repipe_mmap;
 		inject->tool.fork	  = perf_event__repipe_fork;
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
@@ -353,7 +356,9 @@ static int __cmd_inject(struct perf_inject *inject)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (inject->sched_stat) {
+	if (inject->build_ids) {
+		inject->tool.sample = perf_event__inject_buildid;
+	} else if (inject->sched_stat) {
 		struct perf_evsel *evsel;
 
 		inject->tool.ordered_samples = true;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 6a63999..94ca117 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -16,11 +16,11 @@
 #include "session.h"
 #include "tool.h"
 
-static int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
-				  union perf_event *event,
-				  struct perf_sample *sample __maybe_unused,
-				  struct perf_evsel *evsel __maybe_unused,
-				  struct machine *machine)
+int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
+			   union perf_event *event,
+			   struct perf_sample *sample __maybe_unused,
+			   struct perf_evsel *evsel __maybe_unused,
+			   struct machine *machine)
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index a993ba8..45c500b 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -7,4 +7,8 @@ extern struct perf_tool build_id__mark_dso_hit_ops;
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
 
+int build_id__mark_dso_hit(struct perf_tool *tool, union perf_event *event,
+			   struct perf_sample *sample, struct perf_evsel *evsel,
+			   struct machine *machine);
+
 #endif
