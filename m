Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2III4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 04:56:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2III4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 04:56:47 -0400
Date: Sun, 9 Sep 2012 01:56:31 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-7e62ef44e89e7b7f2c48090a048f2a5dffa838c7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1346640790-17197-4-git-send-email-namhyung@kernel.org>
References: <1346640790-17197-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Use perf_hpp__format->
 width to calculate the column widths
Git-Commit-ID: 7e62ef44e89e7b7f2c48090a048f2a5dffa838c7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 09 Sep 2012 01:56:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e62ef44e89e7b7f2c48090a048f2a5dffa838c7
Gitweb:     http://git.kernel.org/tip/7e62ef44e89e7b7f2c48090a048f2a5dffa838c7
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 3 Sep 2012 11:53:08 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 8 Sep 2012 13:20:05 -0300

perf hists: Use perf_hpp__format->width to calculate the column widths

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346640790-17197-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c   |   27 +++++++++++++++++++++++++++
 tools/perf/util/hist.c |   33 ---------------------------------
 2 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 009adf20..031b349 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -360,3 +360,30 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 
 	return ret;
 }
+
+/*
+ * See hists__fprintf to match the column widths
+ */
+unsigned int hists__sort_list_width(struct hists *hists)
+{
+	struct sort_entry *se;
+	int i, ret = 0;
+
+	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+		if (!perf_hpp__format[i].cond)
+			continue;
+		if (i)
+			ret += 2;
+
+		ret += perf_hpp__format[i].width(NULL);
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		if (!se->elide)
+			ret += 2 + hists__col_len(hists, se->se_width_idx);
+
+	if (verbose) /* Addr + origin */
+		ret += 3 + BITS_PER_LONG / 4;
+
+	return ret;
+}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b1817f1..0ba65ad 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -563,39 +563,6 @@ void hists__output_resort_threaded(struct hists *hists)
 	return __hists__output_resort(hists, true);
 }
 
-/*
- * See hists__fprintf to match the column widths
- */
-unsigned int hists__sort_list_width(struct hists *hists)
-{
-	struct sort_entry *se;
-	int ret = 9; /* total % */
-
-	if (symbol_conf.show_cpu_utilization) {
-		ret += 7; /* count_sys % */
-		ret += 6; /* count_us % */
-		if (perf_guest) {
-			ret += 13; /* count_guest_sys % */
-			ret += 12; /* count_guest_us % */
-		}
-	}
-
-	if (symbol_conf.show_nr_samples)
-		ret += 11;
-
-	if (symbol_conf.show_total_period)
-		ret += 13;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list)
-		if (!se->elide)
-			ret += 2 + hists__col_len(hists, se->se_width_idx);
-
-	if (verbose) /* Addr + origin */
-		ret += 3 + BITS_PER_LONG / 4;
-
-	return ret;
-}
-
 static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h,
 				       enum hist_filter filter)
 {
