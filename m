Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2DGUyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 16:54:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51986 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2DGUyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 16:54:18 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ashay Rane <ashay.rane@tacc.utexas.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/8] perf report: Correct display of samples and events in header
Date: Sat,  7 Apr 2012 17:54:08 -0300
Message-Id: <1333832049-2399-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333832049-2399-1-git-send-email-acme@infradead.org>
References: <1333832049-2399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashay Rane <ashay.rane@tacc.utexas.edu>

This patch prints the number of samples and the count of performance
events separately.

This allows comparing performance of different applications with each
other.

Previously, the sample count was displayed against an 'Events:' heading.
With this patch, the header now reads (for example):

Samples: 5K of event 'instructions'
Event count (approx.): 2993026545

The patch covers both the stdio and the browser interface.

Signed-off-by: Ashay Rane <ashay.rane@tacc.utexas.edu>
[ committer note: Fixed wrt e7f01d1 ]
Link: http://lkml.kernel.org/n/tip-h4nfjm8msedlk8gxkzivfh5y@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c         |   11 +++++++----
 tools/perf/util/ui/browsers/hists.c |   10 +++++++---
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2e31743..cec2b8c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -296,12 +296,15 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 {
 	size_t ret;
 	char unit;
-	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
+	unsigned long nr_samples = self->stats.nr_events[PERF_RECORD_SAMPLE];
+	u64 nr_events = self->stats.total_period;
 
-	nr_events = convert_unit(nr_events, &unit);
-	ret = fprintf(fp, "# Events: %lu%c", nr_events, unit);
+	nr_samples = convert_unit(nr_samples, &unit);
+	ret = fprintf(fp, "# Samples: %lu%c", nr_samples, unit);
 	if (evname != NULL)
-		ret += fprintf(fp, " %s", evname);
+		ret += fprintf(fp, " of event '%s'", evname);
+
+	ret += fprintf(fp, "\n# Event count (approx.): %lu", nr_events);
 	return ret + fprintf(fp, "\n#\n");
 }
 
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 2f83e5d..1b820ed 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -840,10 +840,14 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 	int printed;
 	const struct dso *dso = self->dso_filter;
 	const struct thread *thread = self->thread_filter;
-	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
+	unsigned long nr_samples = self->stats.nr_events[PERF_RECORD_SAMPLE];
+	u64 nr_events = self->stats.total_period;
+
+	nr_samples = convert_unit(nr_samples, &unit);
+	printed = scnprintf(bf, size,
+			   "Samples: %lu%c of event '%s', Event count (approx.): %lu",
+			   nr_samples, unit, ev_name, nr_events);
 
-	nr_events = convert_unit(nr_events, &unit);
-	printed = scnprintf(bf, size, "Events: %lu%c %s", nr_events, unit, ev_name);
 
 	if (self->uid_filter_str)
 		printed += snprintf(bf + printed, size - printed,
-- 
1.7.9.2.358.g22243

