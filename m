Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2LMNLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:11:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab2LMNJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:09:41 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 05/14] perf diff: Introducing diff_data object to hold files
Date: Thu, 13 Dec 2012 14:09:03 +0100
Message-Id: <1355404152-16523-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing struct diff_data to hold data file specifics.
It will be handy when dealing with more than 2 data files.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 143 ++++++++++++++++++++++++++++++----------------
 1 file changed, 95 insertions(+), 48 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 1f0a22d..d488ee9 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -19,10 +19,24 @@
 
 #include <stdlib.h>
 
-static char const *input_old = "perf.data.old",
-		  *input_new = "perf.data";
-static char	  diff__default_sort_order[] = "dso,symbol";
-static bool  force;
+struct data__file {
+	struct perf_session	*session;
+	const char		*file;
+	int			 idx;
+};
+
+static struct data__file *data__files;
+static int data__files_cnt;
+
+#define data__for_each_file_start(i, d, s)	\
+	for (i = s, d = &data__files[s];	\
+	     i < data__files_cnt;		\
+	     i++, d = &data__files[i])
+
+#define data__for_each_file(i, d) data__for_each_file_start(i, d, 0)
+
+static char diff__default_sort_order[] = "dso,symbol";
+static bool force;
 static bool show_period;
 static bool show_formula;
 static bool show_baseline_only;
@@ -468,56 +482,62 @@ static void hists__process(struct hists *old, struct hists *new)
 	hists__fprintf(new, true, 0, 0, stdout);
 }
 
-static int __cmd_diff(void)
+static void data_process(void)
 {
-	int ret, i;
-#define older (session[0])
-#define newer (session[1])
-	struct perf_session *session[2];
-	struct perf_evlist *evlist_new, *evlist_old;
-	struct perf_evsel *evsel;
+	struct perf_evlist *evlist_old = data__files[0].session->evlist;
+	struct perf_evlist *evlist_new = data__files[1].session->evlist;
+	struct perf_evsel *evsel_old;
 	bool first = true;
 
-	older = perf_session__new(input_old, O_RDONLY, force, false,
-				  &tool);
-	newer = perf_session__new(input_new, O_RDONLY, force, false,
-				  &tool);
-	if (session[0] == NULL || session[1] == NULL)
-		return -ENOMEM;
+	list_for_each_entry(evsel_old, &evlist_old->entries, node) {
+		struct perf_evsel *evsel_new;
 
-	for (i = 0; i < 2; ++i) {
-		ret = perf_session__process_events(session[i], &tool);
-		if (ret)
-			goto out_delete;
-	}
+		evsel_new = evsel_match(evsel_old, evlist_new);
+		if (!evsel_new)
+			continue;
 
-	evlist_old = older->evlist;
-	evlist_new = newer->evlist;
+		fprintf(stdout, "%s# Event '%s'\n#\n", first ? "" : "\n",
+			perf_evsel__name(evsel_old));
 
-	perf_evlist__collapse_resort(evlist_old);
-	perf_evlist__collapse_resort(evlist_new);
+		first = false;
 
-	list_for_each_entry(evsel, &evlist_new->entries, node) {
-		struct perf_evsel *evsel_old;
+		hists__process(&evsel_old->hists, &evsel_new->hists);
+	}
+}
 
-		evsel_old = evsel_match(evsel, evlist_old);
-		if (!evsel_old)
-			continue;
+static int __cmd_diff(void)
+{
+	struct data__file *d;
+	int ret = -EINVAL, i;
+
+	data__for_each_file(i, d) {
+		d->session = perf_session__new(d->file, O_RDONLY, force,
+					       false, &tool);
+		if (!d->session) {
+			pr_err("Failed to open %s\n", d->file);
+			ret = -ENOMEM;
+			goto out_delete;
+		}
 
-		fprintf(stdout, "%s# Event '%s'\n#\n", first ? "" : "\n",
-			perf_evsel__name(evsel));
+		ret = perf_session__process_events(d->session, &tool);
+		if (ret) {
+			pr_err("Failed to process %s\n", d->file);
+			goto out_delete;
+		}
 
-		first = false;
+		perf_evlist__collapse_resort(d->session->evlist);
+	}
+
+	data_process();
 
-		hists__process(&evsel_old->hists, &evsel->hists);
+ out_delete:
+	data__for_each_file(i, d) {
+		if (d->session)
+			perf_session__delete(d->session);
 	}
 
-out_delete:
-	for (i = 0; i < 2; ++i)
-		perf_session__delete(session[i]);
+	free(data__files);
 	return ret;
-#undef older
-#undef newer
 }
 
 static const char * const diff_usage[] = {
@@ -590,28 +610,55 @@ static void ui_init(void)
 	}
 }
 
-int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
+static int data_init(int argc, const char **argv)
 {
-	sort_order = diff__default_sort_order;
-	argc = parse_options(argc, argv, options, diff_usage, 0);
+	struct data__file *d;
+	static const char *defaults[] = {
+		"perf.data.old",
+		"perf.data",
+	};
+	int i;
+
+	data__files_cnt = 2;
+
 	if (argc) {
 		if (argc > 2)
 			usage_with_options(diff_usage, options);
 		if (argc == 2) {
-			input_old = argv[0];
-			input_new = argv[1];
+			defaults[0] = argv[0];
+			defaults[1] = argv[1];
 		} else
-			input_new = argv[0];
+			defaults[1] = argv[0];
 	} else if (symbol_conf.default_guest_vmlinux_name ||
 		   symbol_conf.default_guest_kallsyms) {
-		input_old = "perf.data.host";
-		input_new = "perf.data.guest";
+		defaults[0] = "perf.data.host";
+		defaults[1] = "perf.data.guest";
 	}
 
+	data__files = zalloc(sizeof(*data__files) * data__files_cnt);
+	if (!data__files)
+		return -ENOMEM;
+
+	data__for_each_file(i, d) {
+		d->file = defaults[i];
+		d->idx  = i;
+	}
+
+	return 0;
+}
+
+int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	sort_order = diff__default_sort_order;
+	argc = parse_options(argc, argv, options, diff_usage, 0);
+
 	symbol_conf.exclude_other = false;
 	if (symbol__init() < 0)
 		return -1;
 
+	if (data_init(argc, argv) < 0)
+		return -1;
+
 	ui_init();
 
 	setup_sorting(diff_usage, options);
-- 
1.7.11.7

