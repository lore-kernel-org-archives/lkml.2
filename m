Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2JIRXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:23:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60842 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2JIRXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:23:37 -0400
Date: Tue, 9 Oct 2012 10:22:11 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-a06d143e7cfaa10626f3ad0127a9b9169f900add@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1349448287-18919-2-git-send-email-jolsa@redhat.com>
References: <1349448287-18919-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Add -b option for perf diff to display paired entries only
Git-Commit-ID: a06d143e7cfaa10626f3ad0127a9b9169f900add
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:22:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a06d143e7cfaa10626f3ad0127a9b9169f900add
Gitweb:     http://git.kernel.org/tip/a06d143e7cfaa10626f3ad0127a9b9169f900add
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 5 Oct 2012 16:44:40 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 5 Oct 2012 14:05:14 -0300

perf diff: Add -b option for perf diff to display paired entries only

Adding -b option to perf diff command to display only entries with match
in the baseline.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349448287-18919-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |    4 ++++
 tools/perf/builtin-diff.c              |   31 +++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index ab7f667..6ce9585 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -72,6 +72,10 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
+-b::
+--baseline-only::
+        Show only items with match in baseline.
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a0b531c..1063c31 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -24,6 +24,7 @@ static char const *input_old = "perf.data.old",
 static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
+static bool show_baseline_only;
 
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
@@ -172,6 +173,31 @@ static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)
 	}
 }
 
+static void hists__baseline_only(struct hists *hists)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+
+	while (next != NULL) {
+		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+
+		next = rb_next(&he->rb_node);
+		if (!he->pair) {
+			rb_erase(&he->rb_node, &hists->entries);
+			hist_entry__free(he);
+		}
+	}
+}
+
+static void hists__process(struct hists *old, struct hists *new)
+{
+	hists__match(old, new);
+
+	if (show_baseline_only)
+		hists__baseline_only(new);
+
+	hists__fprintf(new, true, 0, 0, stdout);
+}
+
 static int __cmd_diff(void)
 {
 	int ret, i;
@@ -213,8 +239,7 @@ static int __cmd_diff(void)
 
 		first = false;
 
-		hists__match(&evsel_old->hists, &evsel->hists);
-		hists__fprintf(&evsel->hists, true, 0, 0, stdout);
+		hists__process(&evsel_old->hists, &evsel->hists);
 	}
 
 out_delete:
@@ -235,6 +260,8 @@ static const struct option options[] = {
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('M', "displacement", &show_displacement,
 		    "Show position displacement relative to baseline"),
+	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
+		    "Show only items with match in baseline"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
