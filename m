Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2JVVA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:00:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60690 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab2JVVA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:00:28 -0400
Date: Mon, 22 Oct 2012 23:00:25 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jolsa@redhat.com, peterz@infradead.org, mingo@elte.hu,
        dsahern@gmail.com, namhyung@gmail.com
Subject: [PATCH] perf report: fix broken perf report -n on 32-bit systems
Message-ID: <20121022210025.GA10548@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 32-bit systems, using perf report -n would yield garbage
for the Samples column. This is because the hpp code was
assuming the hist_entry.stat.nr_events was u64 when in
reality it was u32.

This patch fixes the problem by defining nr_events
to be u64. u32 is too small anyway.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index ef2f93c..616757e 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -992,7 +992,7 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 	printed += fprintf(fp, " %5.2f%%", percent);
 
 	if (symbol_conf.show_nr_samples)
-		printed += fprintf(fp, " %11u", he->stat.nr_events);
+		printed += fprintf(fp, " %11"PRIu64, he->stat.nr_events);
 
 	if (symbol_conf.show_total_period)
 		printed += fprintf(fp, " %12" PRIu64, he->stat.period);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 13761d8..ecda054 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,7 +49,7 @@ struct he_stat {
 	u64			period_us;
 	u64			period_guest_sys;
 	u64			period_guest_us;
-	u32			nr_events;
+	u64			nr_events;
 };
 
 struct hist_entry_diff {
