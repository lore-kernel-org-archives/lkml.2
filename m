Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab1D0P7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:59:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:59965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab1D0P7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:59:42 -0400
Date: Wed, 27 Apr 2011 15:59:25 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-fd6x8r1cpyb6zhlrc4ix8m45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Print stalled cycles percentage
Git-Commit-ID: 11ba2b85f506306c8dfc9fe144aa4ddc43242855
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:59:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11ba2b85f506306c8dfc9fe144aa4ddc43242855
Gitweb:     http://git.kernel.org/tip/11ba2b85f506306c8dfc9fe144aa4ddc43242855
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 24 Apr 2011 15:05:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:54 +0200

perf stat: Print stalled cycles percentage

Print:

           611,527 cycles
           400,553 instructions             # (  0.71 instructions per cycle )
            77,809 stalled-cycles           # ( 12.71% of all cycles )

        0.000610987  seconds time elapsed

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/n/tip-fd6x8r1cpyb6zhlrc4ix8m45@git.kernel.org
---
 tools/perf/builtin-stat.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 03f0e45..3a29041 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -442,7 +442,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg / total;
 
-		fprintf(stderr, " # %10.3f IPC  ", ratio);
+		fprintf(stderr, " # ( %4.2f instructions per cycle )", ratio);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
 			runtime_branches_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_branches_stats[cpu]);
@@ -450,7 +450,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg * 100 / total;
 
-		fprintf(stderr, " # %10.3f %%    ", ratio);
+		fprintf(stderr, " # %10.3f %%", ratio);
 
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
@@ -459,6 +459,13 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 			ratio = 1000.0 * avg / total;
 
 		fprintf(stderr, " # %10.3f M/sec", ratio);
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES)) {
+		total = avg_stats(&runtime_cycles_stats[cpu]);
+
+		if (total)
+			ratio = avg / total * 100.0;
+
+		fprintf(stderr, " # (%5.2f%% of all cycles )", ratio);
 	}
 }
 
