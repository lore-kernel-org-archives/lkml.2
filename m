Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479Ab1FWUr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:47:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6999 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933925Ab1FWUrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:47:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Ew4aGI3joe090ssklNaSsP51VO8GJmnyLKZ1xpvprODK0f5dOayVhxFmUcC6jcgla
	eW6JSc789l0sHxQqXYmDQ==
From: Zhengyu He <zhengyuh@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Zhengyu He <zhengyuh@google.com>
Subject: [PATCH] perf: stat: add noise output for csv mode
Date: Thu, 23 Jun 2011 13:45:42 -0700
Message-Id: <1308861942-4945-1-git-send-email-zhengyuh@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, when you want perf-stat to output the statistics in csv
mode, no information of the noise will be printed out.

For example,

./perf stat -r3 -x, sleep 1
1.164789,task-clock
8,context-switches
0,CPU-migrations
219,page-faults
3337800,cycles

With this patch, the output will be appended with an additional entry of
the noise value:

./perf stat -r3 -x, sleep 1
1.164789,task-clock,3.75%
8,context-switches,75.00%
0,CPU-migrations,100.00%
219,page-faults,0.00%
3337800,cycles,3.36%

Signed-off-by: Zhengyu He <zhengyuh@google.com>
---
 tools/perf/builtin-stat.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a9f0671..3ca1caa 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -513,7 +513,10 @@ static void print_noise_pct(double total, double avg)
 	if (avg)
 		pct = 100.0*total/avg;
 
-	fprintf(stderr, "  ( +-%6.2f%% )", pct);
+        if (csv_output)
+	        fprintf(stderr, "%s%.2f%%", csv_sep, pct);
+        else
+	        fprintf(stderr, "  ( +-%6.2f%% )", pct);
 }
 
 static void print_noise(struct perf_evsel *evsel, double avg)
@@ -878,13 +881,13 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	else
 		abs_printout(-1, counter, avg);
 
+	print_noise(counter, avg);
+
 	if (csv_output) {
 		fputc('\n', stderr);
 		return;
 	}
 
-	print_noise(counter, avg);
-
 	if (scaled) {
 		double avg_enabled, avg_running;
 
-- 
1.7.3.1

