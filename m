Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab1I2WsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:48:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60119 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab1I2WsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/16] perf stat: Fix +- nan% in --no-aggr runs
Date: Thu, 29 Sep 2011 19:48:02 -0300
Message-Id: <1317336490-19437-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Without this patch, running:

$ sudo ./perf stat -r20 --no-aggr -a perl -e '$i++ for 1..100000'

I get computations like this:

CPU0             12.488247 task-clock                #    1.224 CPUs utilized            ( +-  -nan% )
CPU1             12.488909 task-clock                #    1.225 CPUs utilized            ( +-  -nan% )
CPU2             12.500221 task-clock                #    1.226 CPUs utilized            ( +-  -nan% )
CPU3             12.481713 task-clock                #    1.224 CPUs utilized            ( +-  -nan% )

but with patch, I get:

CPU0              8.233682 task-clock                #    0.754 CPUs utilized            ( +-  0.00% )
CPU1              8.226318 task-clock                #    0.754 CPUs utilized            ( +-  0.00% )
CPU2              8.210737 task-clock                #    0.752 CPUs utilized            ( +-  0.00% )
CPU3              8.201691 task-clock                #    0.751 CPUs utilized            ( +-  0.00% )

Note that without --no-aggr, I get non-0 statistics both before and after patch:

        231.986022 task-clock                #    4.030 CPUs utilized            ( +-  0.97% )
               212 context-switches          #    0.001 M/sec                    ( +- 12.07% )
                 9 CPU-migrations            #    0.000 M/sec                    ( +- 25.80% )
               466 page-faults               #    0.002 M/sec                    ( +-  3.23% )
       174,318,593 cycles                    #    0.751 GHz                      ( +-  1.06% )

I couldnt see anything wrong in the caller, so fixed it in
stddev_stats().  ISTM that 0.00 is better than nan, since perf stat was
passed -A (--no-aggr) so no standard deviation should be expected, and
nan is suggestive of a deeper error.

When running with --no-aggr, perhaps we should suppress the statistics
printing entirely, or do so when they are 0.00.

Link: http://lkml.kernel.org/r/1315437244-3788-3-git-send-email-jim.cromie@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a43c680..af0d65b 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -254,8 +254,13 @@ static double avg_stats(struct stats *stats)
  */
 static double stddev_stats(struct stats *stats)
 {
-	double variance = stats->M2 / (stats->n - 1);
-	double variance_mean = variance / stats->n;
+	double variance, variance_mean;
+
+	if (!stats->n)
+		return 0.0;
+
+	variance = stats->M2 / (stats->n - 1);
+	variance_mean = variance / stats->n;
 
 	return sqrt(variance_mean);
 }
-- 
1.6.2.5

