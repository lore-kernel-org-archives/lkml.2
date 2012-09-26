Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2IZH5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:57:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55720 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab2IZH4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:13 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-61-5062b517e3ba
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 15/16] perf report: Show group description when event group is enabled
Date: Wed, 26 Sep 2012 16:47:42 +0900
Message-Id: <1348645663-25303-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
References: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When using event group viewer, it's better to show the group
description rather than the leader information alone.

If a leader did not contain any member, it's a non-group event.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    | 18 ++++++++++++++++++
 tools/perf/ui/browsers/hists.c | 31 +++++++++++++++++++++++++++++++
 tools/perf/ui/gtk/browser.c    | 14 +++++++++++---
 tools/perf/util/evsel.c        | 25 +++++++++++++++++++++++++
 tools/perf/util/evsel.h        |  8 ++++++++
 5 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 52803a9d3e3e..3a4bd13340db 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -299,6 +299,24 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	char unit;
 	unsigned long nr_samples = self->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = self->stats.total_period;
+	struct perf_evsel *evsel = hists_2_evsel(self);
+	char buf[512];
+	size_t size = sizeof(buf);
+
+	if (symbol_conf.event_group && evsel->nr_members) {
+		int i;
+		struct events_stats *stats;
+
+		perf_evsel__group_desc(evsel, buf, size);
+		evname = buf;
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			stats = &self->group_stats[i];
+
+			nr_samples += stats->nr_events[PERF_RECORD_SAMPLE];
+			nr_events += stats->total_period;
+		}
+	}
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	ret = fprintf(fp, "# Samples: %lu%c", nr_samples, unit);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 82d59be3c230..7903b98913c5 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1121,6 +1121,24 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	const struct thread *thread = hists->thread_filter;
 	unsigned long nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = hists->stats.total_period;
+	struct perf_evsel *evsel = hists_2_evsel(hists);
+	char buf[512];
+	size_t buflen = sizeof(buf);
+
+	if (symbol_conf.event_group && evsel->nr_members) {
+		int i;
+		struct events_stats *stats;
+
+		perf_evsel__group_desc(evsel, buf, buflen);
+		ev_name = buf;
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			stats = &hists->group_stats[i];
+
+			nr_samples += stats->nr_events[PERF_RECORD_SAMPLE];
+			nr_events += stats->total_period;
+		}
+	}
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	printed = scnprintf(bf, size,
@@ -1467,6 +1485,19 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
 						       HE_COLORSET_NORMAL);
 
+	if (symbol_conf.event_group && evsel->nr_members) {
+		int i;
+		struct events_stats *stats;
+
+		ev_name = perf_evsel__group_name(evsel);
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			stats = &evsel->hists.group_stats[i];
+
+			nr_events += stats->nr_events[PERF_RECORD_SAMPLE];
+		}
+	}
+
 	nr_events = convert_unit(nr_events, &unit);
 	printed = scnprintf(bf, sizeof(bf), "%lu%c%s%s", nr_events,
 			   unit, unit == ' ' ? "" : " ", ev_name);
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 01bfa43db8e2..cb6241e7f9a5 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -305,10 +305,18 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 		const char *evname = perf_evsel__name(pos);
 		GtkWidget *scrolled_window;
 		GtkWidget *tab_label;
+		char buf[512];
+		size_t size = sizeof(buf);
 
-		if (symbol_conf.event_group &&
-		    !perf_evsel__is_group_leader(pos))
-			continue;
+		if (symbol_conf.event_group) {
+			if (!perf_evsel__is_group_leader(pos))
+				continue;
+
+			if (pos->nr_members) {
+				perf_evsel__group_desc(pos, buf, size);
+				evname = buf;
+			}
+		}
 
 		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 00936ad29ff2..50fa1b4c0d8b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -397,6 +397,31 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 	return evsel->name ?: "unknown";
 }
 
+const char *perf_evsel__group_name(struct perf_evsel *evsel)
+{
+	return evsel->group_name ?: "anon group";
+}
+
+int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
+{
+	int ret;
+	struct perf_evsel *pos;
+	const char *group_name = perf_evsel__group_name(evsel);
+
+	ret = scnprintf(buf, size, "%s", group_name);
+
+	ret += scnprintf(buf + ret, size - ret, " { %s",
+			 perf_evsel__name(evsel));
+
+	for_each_group_member(pos, evsel)
+		ret += scnprintf(buf + ret, size - ret, ", %s",
+				 perf_evsel__name(pos));
+
+	ret += scnprintf(buf + ret, size - ret, " }");
+
+	return ret;
+}
+
 void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 			struct perf_evsel *first)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 95f0bf17e79c..1fa79a0d9eb2 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -110,6 +110,8 @@ extern const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX];
 int __perf_evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result,
 					    char *bf, size_t size);
 const char *perf_evsel__name(struct perf_evsel *evsel);
+const char *perf_evsel__group_name(struct perf_evsel *evsel);
+int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
@@ -226,4 +228,10 @@ static inline struct perf_evsel *hists_2_evsel(struct hists *hists)
 {
 	return container_of(hists, struct perf_evsel, hists);
 }
+
+#define for_each_group_member(_evsel, _leader) 					\
+for ((_evsel) = list_entry((_leader)->node.next, struct perf_evsel, node); 	\
+     (_evsel) && (_evsel)->leader == (_leader);					\
+     (_evsel) = list_entry((_evsel)->node.next, struct perf_evsel, node))
+
 #endif /* __PERF_EVSEL_H */
-- 
1.7.11.4

