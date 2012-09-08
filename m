Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2IHLoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:44:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39583 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab2IHLoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:44:23 -0400
Date: Sat, 8 Sep 2012 04:41:46 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-863e451f69ddf255e877567e325298edd3b21519@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1346946426-13496-2-git-send-email-jolsa@redhat.com>
References: <1346946426-13496-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Make diff command work with evsel hists
Git-Commit-ID: 863e451f69ddf255e877567e325298edd3b21519
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:41:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  863e451f69ddf255e877567e325298edd3b21519
Gitweb:     http://git.kernel.org/tip/863e451f69ddf255e877567e325298edd3b21519
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 6 Sep 2012 17:46:55 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 21:44:02 -0300

perf diff: Make diff command work with evsel hists

Putting 'perf diff' command back on track with the 'latest'
evsel hists changes. Each evsel has its own 'hists' object
gathering stats for the particular event.

While currently counts are accumulated for the whole session
regardless of the events diversification within compared
sessions.

The 'perf diff' command now outputs all matching events within
compared sessions (with event name specified). The per event
diff output stays the same.

  $ ./perf diff
  # Event 'cycles'
  #
  # Baseline  Delta          Shared Object                          Symbol
  # ........ ..........  .................  ..............................
  #
       0.00%    +15.14%  [kernel.kallsyms]  [k] __wake_up
       0.00%    +13.38%  [kernel.kallsyms]  [k] ext4fs_dirhash

... SNIP

       0.00%     +0.42%  [kernel.kallsyms]  [k] local_clock
       0.17%     -0.05%  [kernel.kallsyms]  [k] native_write_msr_safe

  # Event 'faults'
  #
  # Baseline  Delta          Shared Object                          Symbol
  # ........ ..........  .................  ..............................
  #
       0.00%    +79.12%  ld-2.15.so         [.] _dl_relocate_object
       0.00%    +11.62%  ld-2.15.so         [.] openaux

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346946426-13496-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |    3 +
 tools/perf/builtin-diff.c              |   93 +++++++++++++++++++++-----------
 tools/perf/util/evsel.h                |    7 +++
 tools/perf/util/session.h              |    4 +-
 4 files changed, 72 insertions(+), 35 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 74d7481..ab7f667 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -17,6 +17,9 @@ captured via perf record.
 
 If no parameters are passed it will assume perf.data.old and perf.data.
 
+The differential profile is displayed only for events matching both
+specified perf.data files.
+
 OPTIONS
 -------
 -M::
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d29d350..e9933fd 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -10,6 +10,7 @@
 #include "util/event.h"
 #include "util/hist.h"
 #include "util/evsel.h"
+#include "util/evlist.h"
 #include "util/session.h"
 #include "util/tool.h"
 #include "util/sort.h"
@@ -24,11 +25,6 @@ static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
 
-struct perf_diff {
-	struct perf_tool tool;
-	struct perf_session *session;
-};
-
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
 {
@@ -37,14 +33,12 @@ static int hists__add_entry(struct hists *self,
 	return -ENOMEM;
 }
 
-static int diff__process_sample_event(struct perf_tool *tool,
+static int diff__process_sample_event(struct perf_tool *tool __used,
 				      union perf_event *event,
 				      struct perf_sample *sample,
-				      struct perf_evsel *evsel __used,
+				      struct perf_evsel *evsel,
 				      struct machine *machine)
 {
-	struct perf_diff *_diff = container_of(tool, struct perf_diff, tool);
-	struct perf_session *session = _diff->session;
 	struct addr_location al;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample, NULL) < 0) {
@@ -56,26 +50,24 @@ static int diff__process_sample_event(struct perf_tool *tool,
 	if (al.filtered || al.sym == NULL)
 		return 0;
 
-	if (hists__add_entry(&session->hists, &al, sample->period)) {
+	if (hists__add_entry(&evsel->hists, &al, sample->period)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
-	session->hists.stats.total_period += sample->period;
+	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
 
-static struct perf_diff diff = {
-	.tool = {
-		.sample	= diff__process_sample_event,
-		.mmap	= perf_event__process_mmap,
-		.comm	= perf_event__process_comm,
-		.exit	= perf_event__process_task,
-		.fork	= perf_event__process_task,
-		.lost	= perf_event__process_lost,
-		.ordered_samples = true,
-		.ordering_requires_timestamps = true,
-	},
+static struct perf_tool tool = {
+	.sample	= diff__process_sample_event,
+	.mmap	= perf_event__process_mmap,
+	.comm	= perf_event__process_comm,
+	.exit	= perf_event__process_task,
+	.fork	= perf_event__process_task,
+	.lost	= perf_event__process_lost,
+	.ordered_samples = true,
+	.ordering_requires_timestamps = true,
 };
 
 static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
@@ -146,34 +138,71 @@ static void hists__match(struct hists *older, struct hists *newer)
 	}
 }
 
+static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
+				      struct perf_evlist *evlist)
+{
+	struct perf_evsel *e;
+
+	list_for_each_entry(e, &evlist->entries, node)
+		if (perf_evsel__match2(evsel, e))
+			return e;
+
+	return NULL;
+}
+
 static int __cmd_diff(void)
 {
 	int ret, i;
 #define older (session[0])
 #define newer (session[1])
 	struct perf_session *session[2];
+	struct perf_evlist *evlist_new, *evlist_old;
+	struct perf_evsel *evsel;
+	bool first = true;
 
 	older = perf_session__new(input_old, O_RDONLY, force, false,
-				  &diff.tool);
+				  &tool);
 	newer = perf_session__new(input_new, O_RDONLY, force, false,
-				  &diff.tool);
+				  &tool);
 	if (session[0] == NULL || session[1] == NULL)
 		return -ENOMEM;
 
 	for (i = 0; i < 2; ++i) {
-		diff.session = session[i];
-		ret = perf_session__process_events(session[i], &diff.tool);
+		ret = perf_session__process_events(session[i], &tool);
 		if (ret)
 			goto out_delete;
-		hists__output_resort(&session[i]->hists);
 	}
 
-	if (show_displacement)
-		hists__resort_entries(&older->hists);
+	evlist_old = older->evlist;
+	evlist_new = newer->evlist;
+
+	list_for_each_entry(evsel, &evlist_new->entries, node)
+		hists__output_resort(&evsel->hists);
+
+	list_for_each_entry(evsel, &evlist_old->entries, node) {
+		hists__output_resort(&evsel->hists);
+
+		if (show_displacement)
+			hists__resort_entries(&evsel->hists);
+	}
+
+	list_for_each_entry(evsel, &evlist_new->entries, node) {
+		struct perf_evsel *evsel_old;
+
+		evsel_old = evsel_match(evsel, evlist_old);
+		if (!evsel_old)
+			continue;
+
+		fprintf(stdout, "%s# Event '%s'\n#\n", first ? "" : "\n",
+			perf_evsel__name(evsel));
+
+		first = false;
+
+		hists__match(&evsel_old->hists, &evsel->hists);
+		hists__fprintf(&evsel->hists, &evsel_old->hists,
+			       show_displacement, true, 0, 0, stdout);
+	}
 
-	hists__match(&older->hists, &newer->hists);
-	hists__fprintf(&newer->hists, &older->hists,
-		       show_displacement, true, 0, 0, stdout);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a3f562c..390690e 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -124,6 +124,13 @@ void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
 	(evsel->attr.type == PERF_TYPE_##t &&	\
 	 evsel->attr.config == PERF_COUNT_##c)
 
+static inline bool perf_evsel__match2(struct perf_evsel *e1,
+				      struct perf_evsel *e2)
+{
+	return (e1->attr.type == e2->attr.type) &&
+	       (e1->attr.config == e2->attr.config);
+}
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale);
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 176a609..aab414f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -36,9 +36,7 @@ struct perf_session {
 	struct pevent		*pevent;
 	/*
 	 * FIXME: Need to split this up further, we need global
-	 *	  stats + per event stats. 'perf diff' also needs
-	 *	  to properly support multiple events in a single
-	 *	  perf.data file.
+	 *	  stats + per event stats.
 	 */
 	struct hists		hists;
 	int			fd;
