Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2BGTi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:38:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2BGTi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:38:57 -0500
Date: Tue, 7 Feb 2012 11:38:36 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-5fde2523bddb71d96f12b6ee8d2a9a43cb99da96@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1328514285-26232-1-git-send-email-namhyung.kim@lge.com>
References: <1328514285-26232-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Adjust print unit
Git-Commit-ID: 5fde2523bddb71d96f12b6ee8d2a9a43cb99da96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:38:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5fde2523bddb71d96f12b6ee8d2a9a43cb99da96
Gitweb:     http://git.kernel.org/tip/5fde2523bddb71d96f12b6ee8d2a9a43cb99da96
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 6 Feb 2012 16:44:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Feb 2012 19:17:11 -0200

perf stat: Adjust print unit

The default 'M/sec' unit is not useful if the result is small enough.

Adjust it dynamically according to the value.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328514285-26232-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 459b862..32d930e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -844,12 +844,18 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 		fprintf(output, " # %8.3f GHz                    ", ratio);
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
+		char unit = 'M';
+
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
 		if (total)
 			ratio = 1000.0 * avg / total;
+		if (ratio < 0.001) {
+			ratio *= 1000;
+			unit = 'K';
+		}
 
-		fprintf(output, " # %8.3f M/sec                  ", ratio);
+		fprintf(output, " # %8.3f %c/sec                  ", ratio, unit);
 	} else {
 		fprintf(output, "                                   ");
 	}
