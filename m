Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2I0LMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:12:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab2I0LKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:10:34 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 14/14] perf diff: Display empty space for non paired samples
Date: Thu, 27 Sep 2012 13:09:35 +0200
Message-Id: <1348744175-11115-15-git-send-email-jolsa@redhat.com>
In-Reply-To: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in 'Baseline' and 'Period Base' columns zero values are
displayed in case no pair is found for the sample. This might be
confusing, using empty space instead.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/ui/hist.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 04e34f3..d74ecd2 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -179,7 +179,10 @@ static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = baseline_percent(he);
 
-	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
+	if (he->pair)
+		return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
+	else
+		return scnprintf(hpp->buf, hpp->size, "        ");
 }
 
 static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
@@ -246,8 +249,12 @@ static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *h
 	u64 period = pair ? pair->period : 0;
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, period);
+	if (pair)
+		return scnprintf(hpp->buf, hpp->size, fmt, period);
+	else
+		return scnprintf(hpp->buf, hpp->size, "            ");
 }
+
 static int hpp__header_delta(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
-- 
1.7.11.4

