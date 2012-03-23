Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2CWIcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:32:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45812 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2CWIcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:32:03 -0400
Date: Fri, 23 Mar 2012 01:31:19 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-4bf9ce1b5ecffffeb8b9d7e925bac3e6b10109aa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20120322133726.GB1601@m.brq.redhat.com>
References: <20120322133726.GB1601@m.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf diff: Fix to work with new hists design
Git-Commit-ID: 4bf9ce1b5ecffffeb8b9d7e925bac3e6b10109aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 01:31:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bf9ce1b5ecffffeb8b9d7e925bac3e6b10109aa
Gitweb:     http://git.kernel.org/tip/4bf9ce1b5ecffffeb8b9d7e925bac3e6b10109aa
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 22 Mar 2012 14:37:26 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Mar 2012 15:12:09 -0300

perf diff: Fix to work with new hists design

The perf diff command is broken since:
  perf hists: Threaded addition and sorting of entries
  commit 1980c2ebd7020d82c024b8c4046849b38e78e7da

Several places were broken:
  - hists data need to be collected into opened sessions instead
    of into events
  - session's hists data need to be initialized properly when the
    session is created
  - hist_entry__pcnt_snprintf: the percentage and displacement
    buffer preparation must not use 'ret' because it's used
    as a pointer to the final buffer

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120322133726.GB1601@m.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |   60 ++++++++++++++++++++++++++------------------
 tools/perf/util/evsel.c   |    2 +-
 tools/perf/util/evsel.h   |    2 +
 tools/perf/util/hist.c    |    8 +++---
 tools/perf/util/session.c |    1 +
 5 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4f19513..d29d350 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -24,6 +24,11 @@ static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
 
+struct perf_diff {
+	struct perf_tool tool;
+	struct perf_session *session;
+};
+
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
 {
@@ -32,12 +37,14 @@ static int hists__add_entry(struct hists *self,
 	return -ENOMEM;
 }
 
-static int diff__process_sample_event(struct perf_tool *tool __used,
+static int diff__process_sample_event(struct perf_tool *tool,
 				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel __used,
 				      struct machine *machine)
 {
+	struct perf_diff *_diff = container_of(tool, struct perf_diff, tool);
+	struct perf_session *session = _diff->session;
 	struct addr_location al;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample, NULL) < 0) {
@@ -49,24 +56,26 @@ static int diff__process_sample_event(struct perf_tool *tool __used,
 	if (al.filtered || al.sym == NULL)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period)) {
+	if (hists__add_entry(&session->hists, &al, sample->period)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
-	evsel->hists.stats.total_period += sample->period;
+	session->hists.stats.total_period += sample->period;
 	return 0;
 }
 
-static struct perf_tool perf_diff = {
-	.sample	= diff__process_sample_event,
-	.mmap	= perf_event__process_mmap,
-	.comm	= perf_event__process_comm,
-	.exit	= perf_event__process_task,
-	.fork	= perf_event__process_task,
-	.lost	= perf_event__process_lost,
-	.ordered_samples = true,
-	.ordering_requires_timestamps = true,
+static struct perf_diff diff = {
+	.tool = {
+		.sample	= diff__process_sample_event,
+		.mmap	= perf_event__process_mmap,
+		.comm	= perf_event__process_comm,
+		.exit	= perf_event__process_task,
+		.fork	= perf_event__process_task,
+		.lost	= perf_event__process_lost,
+		.ordered_samples = true,
+		.ordering_requires_timestamps = true,
+	},
 };
 
 static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
@@ -107,12 +116,6 @@ static void hists__resort_entries(struct hists *self)
 	self->entries = tmp;
 }
 
-static void hists__set_positions(struct hists *self)
-{
-	hists__output_resort(self);
-	hists__resort_entries(self);
-}
-
 static struct hist_entry *hists__find_entry(struct hists *self,
 					    struct hist_entry *he)
 {
@@ -146,30 +149,37 @@ static void hists__match(struct hists *older, struct hists *newer)
 static int __cmd_diff(void)
 {
 	int ret, i;
+#define older (session[0])
+#define newer (session[1])
 	struct perf_session *session[2];
 
-	session[0] = perf_session__new(input_old, O_RDONLY, force, false, &perf_diff);
-	session[1] = perf_session__new(input_new, O_RDONLY, force, false, &perf_diff);
+	older = perf_session__new(input_old, O_RDONLY, force, false,
+				  &diff.tool);
+	newer = perf_session__new(input_new, O_RDONLY, force, false,
+				  &diff.tool);
 	if (session[0] == NULL || session[1] == NULL)
 		return -ENOMEM;
 
 	for (i = 0; i < 2; ++i) {
-		ret = perf_session__process_events(session[i], &perf_diff);
+		diff.session = session[i];
+		ret = perf_session__process_events(session[i], &diff.tool);
 		if (ret)
 			goto out_delete;
+		hists__output_resort(&session[i]->hists);
 	}
 
-	hists__output_resort(&session[1]->hists);
 	if (show_displacement)
-		hists__set_positions(&session[0]->hists);
+		hists__resort_entries(&older->hists);
 
-	hists__match(&session[0]->hists, &session[1]->hists);
-	hists__fprintf(&session[1]->hists, &session[0]->hists,
+	hists__match(&older->hists, &newer->hists);
+	hists__fprintf(&newer->hists, &older->hists,
 		       show_displacement, true, 0, 0, stdout);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
 	return ret;
+#undef older
+#undef newer
 }
 
 static const char * const diff_usage[] = {
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0221700..d9da62a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -34,7 +34,7 @@ int __perf_evsel__sample_size(u64 sample_type)
 	return size;
 }
 
-static void hists__init(struct hists *hists)
+void hists__init(struct hists *hists)
 {
 	memset(hists, 0, sizeof(*hists));
 	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3158ca3..3d6b3e4 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -170,4 +170,6 @@ static inline int perf_evsel__sample_size(struct perf_evsel *evsel)
 	return __perf_evsel__sample_size(evsel->attr.sample_type);
 }
 
+void hists__init(struct hists *hists);
+
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5fb1901..c61235f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -891,9 +891,9 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 		diff = new_percent - old_percent;
 
 		if (fabs(diff) >= 0.01)
-			ret += scnprintf(bf, sizeof(bf), "%+4.2F%%", diff);
+			scnprintf(bf, sizeof(bf), "%+4.2F%%", diff);
 		else
-			ret += scnprintf(bf, sizeof(bf), " ");
+			scnprintf(bf, sizeof(bf), " ");
 
 		if (sep)
 			ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
@@ -902,9 +902,9 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 
 		if (show_displacement) {
 			if (displacement)
-				ret += scnprintf(bf, sizeof(bf), "%+4ld", displacement);
+				scnprintf(bf, sizeof(bf), "%+4ld", displacement);
 			else
-				ret += scnprintf(bf, sizeof(bf), " ");
+				scnprintf(bf, sizeof(bf), " ");
 
 			if (sep)
 				ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 002ebbf..9412e3b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -140,6 +140,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	INIT_LIST_HEAD(&self->ordered_samples.sample_cache);
 	INIT_LIST_HEAD(&self->ordered_samples.to_free);
 	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
+	hists__init(&self->hists);
 
 	if (mode == O_RDONLY) {
 		if (perf_session__open(self, force) < 0)
