Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2DMSLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:11:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2DMSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:11:12 -0400
Date: Fri, 13 Apr 2012 11:10:49 -0700
From: tip-bot for Ashay Rane <ashay.rane@tacc.utexas.edu>
Message-ID: <tip-h4nfjm8msedlk8gxkzivfh5y@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, ashay.rane@tacc.utexas.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, ashay.rane@tacc.utexas.edu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Correct display of samples and events in header
Git-Commit-ID: cc68628096b813010f30f69fcf7d1832d18fa767
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:10:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc68628096b813010f30f69fcf7d1832d18fa767
Gitweb:     http://git.kernel.org/tip/cc68628096b813010f30f69fcf7d1832d18fa767
Author:     Ashay Rane <ashay.rane@tacc.utexas.edu>
AuthorDate: Thu, 5 Apr 2012 21:01:01 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 7 Apr 2012 17:29:41 -0300

perf report: Correct display of samples and events in header

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
