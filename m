Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab1JFRWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:22:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50006 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754Ab1JFRWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/15] perf report: Add option to show total period
Date: Thu,  6 Oct 2011 14:22:26 -0300
Message-Id: <1317921758-4154-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like --show-nr-samples, to help in diagnosing problems in the
tools.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1lr7ejdjfvy2uwy2wkmatcpq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    2 ++
 tools/perf/builtin-report.c              |    2 ++
 tools/perf/util/hist.c                   |   19 +++++++++++++++++++
 tools/perf/util/symbol.h                 |    1 +
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 6349b6c..4e82c19 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -137,6 +137,8 @@ OPTIONS
 -M::
 --disassembler-style=:: Set disassembler style for objdump.
 
+--show-total-period:: Show a column with the sum of periods.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b125742..c1cc7ab 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -486,6 +486,8 @@ static const struct option options[] = {
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
+	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
+		    "Show a column with the sum of periods"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 24cca0a..32c9086 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -664,6 +664,13 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 			ret += snprintf(s + ret, size - ret, "%11" PRIu64, nr_events);
 	}
 
+	if (symbol_conf.show_total_period) {
+		if (sep)
+			ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
+		else
+			ret += snprintf(s + ret, size - ret, " %12" PRIu64, period);
+	}
+
 	if (pair_hists) {
 		char bf[32];
 		double old_percent = 0, new_percent = 0, diff;
@@ -770,6 +777,13 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 			fputs("  Samples  ", fp);
 	}
 
+	if (symbol_conf.show_total_period) {
+		if (sep)
+			ret += fprintf(fp, "%cPeriod", *sep);
+		else
+			ret += fprintf(fp, "   Period    ");
+	}
+
 	if (symbol_conf.show_cpu_utilization) {
 		if (sep) {
 			ret += fprintf(fp, "%csys", *sep);
@@ -834,6 +848,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	fprintf(fp, "# ........");
 	if (symbol_conf.show_nr_samples)
 		fprintf(fp, " ..........");
+	if (symbol_conf.show_total_period)
+		fprintf(fp, " ............");
 	if (pair) {
 		fprintf(fp, " ..........");
 		if (show_displacement)
@@ -917,6 +933,9 @@ unsigned int hists__sort_list_width(struct hists *hists)
 	if (symbol_conf.show_nr_samples)
 		ret += 11;
 
+	if (symbol_conf.show_total_period)
+		ret += 13;
+
 	list_for_each_entry(se, &hist_entry__sort_list, list)
 		if (!se->elide)
 			ret += 2 + hists__col_len(hists, se->se_width_idx);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 7733f0b..29f8d74 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -72,6 +72,7 @@ struct symbol_conf {
 			use_modules,
 			sort_by_name,
 			show_nr_samples,
+			show_total_period,
 			use_callchain,
 			exclude_other,
 			show_cpu_utilization,
-- 
1.6.2.5

