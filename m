Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab1D0QCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:02:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:59560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310Ab1D0QCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:02:50 -0400
Date: Wed, 27 Apr 2011 16:02:37 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-z89h2v1bk1mikcbsf7e6v34q@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Fix -nan% output in perf stat noise printouts
Git-Commit-ID: f99844cb76b7d347711c22cdcb94266b7214141f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:02:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f99844cb76b7d347711c22cdcb94266b7214141f
Gitweb:     http://git.kernel.org/tip/f99844cb76b7d347711c22cdcb94266b7214141f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 05:35:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:57 +0200

perf stat: Fix -nan% output in perf stat noise printouts

Before:

                 0 CPU-migrations           #    0.000 M/sec                    ( +-  -nan% )

After:

                 0 CPU-migrations           #    0.000 M/sec                    ( +-  0.00% )

Also factor out the noise printing function.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-z89h2v1bk1mikcbsf7e6v34q@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 924d18c..845ded8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -382,6 +382,16 @@ static int run_perf_stat(int argc __used, const char **argv)
 	return WEXITSTATUS(status);
 }
 
+static void print_noise_pct(double total, double avg)
+{
+	double pct = 0.0;
+
+	if (avg)
+		pct = 100.0*total/avg;
+
+	fprintf(stderr, "  ( +-%6.2f%% )", pct);
+}
+
 static void print_noise(struct perf_evsel *evsel, double avg)
 {
 	struct perf_stat *ps;
@@ -390,8 +400,7 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 		return;
 
 	ps = evsel->priv;
-	fprintf(stderr, "   ( +- %7.3f%% )",
-			100 * stddev_stats(&ps->res_stats[0]) / avg);
+	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
 }
 
 static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
@@ -635,9 +644,8 @@ static void print_stat(int argc, const char **argv)
 		fprintf(stderr, " %18.9f  seconds time elapsed",
 				avg_stats(&walltime_nsecs_stats)/1e9);
 		if (run_count > 1) {
-			fprintf(stderr, "   ( +-%5.2f%% )",
-				100*stddev_stats(&walltime_nsecs_stats) /
-				avg_stats(&walltime_nsecs_stats));
+			print_noise_pct(stddev_stats(&walltime_nsecs_stats),
+					avg_stats(&walltime_nsecs_stats));
 		}
 		fprintf(stderr, "\n\n");
 	}
