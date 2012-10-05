Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2JEOpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:45:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab2JEOpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:45:32 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 8/8] perf diff: Display empty space for non paired samples
Date: Fri,  5 Oct 2012 16:44:47 +0200
Message-Id: <1349448287-18919-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349448287-18919-1-git-send-email-jolsa@redhat.com>
References: <1349448287-18919-1-git-send-email-jolsa@redhat.com>
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
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/ui/hist.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 305eb79..4f5f475 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -179,7 +179,10 @@ static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = baseline_percent(he);
 
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
+	if (he->pair)
+		return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
+	else
+		return scnprintf(hpp->buf, hpp->size, "        ");
 }
 
 static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
@@ -187,7 +190,10 @@ static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 	double percent = baseline_percent(he);
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	if (he->pair || symbol_conf.field_sep)
+		return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	else
+		return scnprintf(hpp->buf, hpp->size, "            ");
 }
 
 static int hpp__header_samples(struct perf_hpp *hpp)
-- 
1.7.11.4

