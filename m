Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab2K2GkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:40:18 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57376 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2K2GjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:15 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-e0-50b7030bb333
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 16/18] perf report: Show group description when event group is enabled
Date: Thu, 29 Nov 2012 15:38:44 +0900
Message-Id: <1354171126-14387-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
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
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    | 15 +++++++++++++++
 tools/perf/ui/browsers/hists.c | 25 +++++++++++++++++++++++++
 tools/perf/ui/gtk/browser.c    | 14 +++++++++++---
 tools/perf/util/evsel.c        | 25 +++++++++++++++++++++++++
 tools/perf/util/evsel.h        |  8 ++++++++
 5 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 87af38bd75a8..e5b53f6554f4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -299,6 +299,21 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	char unit;
 	unsigned long nr_samples = self->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = self->stats.total_period;
+	struct perf_evsel *evsel = hists_to_evsel(self);
+	char buf[512];
+	size_t size = sizeof(buf);
+
+	if (symbol_conf.event_group && evsel->nr_members > 1) {
+		struct perf_evsel *pos;
+
+		perf_evsel__group_desc(evsel, buf, size);
+		evname = buf;
+
+		for_each_group_member(pos, evsel) {
+			nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+			nr_events += pos->hists.stats.total_period;
+		}
+	}
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	ret = fprintf(fp, "# Samples: %lu%c", nr_samples, unit);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0d8b0143cd9b..3e31534fcc47 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1211,6 +1211,21 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	const struct thread *thread = hists->thread_filter;
 	unsigned long nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = hists->stats.total_period;
+	struct perf_evsel *evsel = hists_to_evsel(hists);
+	char buf[512];
+	size_t buflen = sizeof(buf);
+
+	if (symbol_conf.event_group && evsel->nr_members > 1) {
+		struct perf_evsel *pos;
+
+		perf_evsel__group_desc(evsel, buf, buflen);
+		ev_name = buf;
+
+		for_each_group_member(pos, evsel) {
+			nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+			nr_events += pos->hists.stats.total_period;
+		}
+	}
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	printed = scnprintf(bf, size,
@@ -1607,6 +1622,16 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
 						       HE_COLORSET_NORMAL);
 
+	if (symbol_conf.event_group && evsel->nr_members > 1) {
+		struct perf_evsel *pos;
+
+		ev_name = perf_evsel__group_name(evsel);
+
+		for_each_group_member(pos, evsel) {
+			nr_events += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+		}
+	}
+
 	nr_events = convert_unit(nr_events, &unit);
 	printed = scnprintf(bf, sizeof(bf), "%lu%c%s%s", nr_events,
 			   unit, unit == ' ' ? "" : " ", ev_name);
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 3b1642dc0e31..e7e11df829ed 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -324,10 +324,18 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
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
+			if (pos->nr_members > 1) {
+				perf_evsel__group_desc(pos, buf, size);
+				evname = buf;
+			}
+		}
 
 		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 73e6085a7294..a35e2547a7eb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -405,6 +405,31 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
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
 /*
  * The enable_on_exec/disabled value strategy:
  *
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 54a8efbd8dcb..d2d1870928df 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -113,6 +113,8 @@ extern const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX];
 int __perf_evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result,
 					    char *bf, size_t size);
 const char *perf_evsel__name(struct perf_evsel *evsel);
+const char *perf_evsel__group_name(struct perf_evsel *evsel);
+int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
@@ -238,4 +240,10 @@ static inline int perf_evsel__group_idx(struct perf_evsel *evsel)
 {
 	return evsel->idx - evsel->leader->idx;
 }
+
+#define for_each_group_member(_evsel, _leader) 					\
+for ((_evsel) = list_entry((_leader)->node.next, struct perf_evsel, node); 	\
+     (_evsel) && (_evsel)->leader == (_leader);					\
+     (_evsel) = list_entry((_evsel)->node.next, struct perf_evsel, node))
+
 #endif /* __PERF_EVSEL_H */
-- 
1.7.11.7

