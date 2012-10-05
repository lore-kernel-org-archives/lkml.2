Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2JEJIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:08:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2JEJID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:08:03 -0400
Date: Fri, 5 Oct 2012 02:07:42 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-139c0815903de1a7865fe1d6beac5e995fefdf46@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1349354994-17853-10-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-10-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists: Add more helpers for hist entry stat
Git-Commit-ID: 139c0815903de1a7865fe1d6beac5e995fefdf46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 02:07:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  139c0815903de1a7865fe1d6beac5e995fefdf46
Gitweb:     http://git.kernel.org/tip/139c0815903de1a7865fe1d6beac5e995fefdf46
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 4 Oct 2012 21:49:43 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 4 Oct 2012 13:36:18 -0300

perf hists: Add more helpers for hist entry stat

Add and use he_stat__add_{period,stat} for calculating hist entry's
stat.  It will be used for accumulated stats later as well.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1349354994-17853-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 02476cb..277947a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -151,6 +151,22 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 	}
 }
 
+static void he_stat__add_period(struct he_stat *he_stat, u64 period)
+{
+	he_stat->period		+= period;
+	he_stat->nr_events	+= 1;
+}
+
+static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
+{
+	dest->period		+= src->period;
+	dest->period_sys	+= src->period_sys;
+	dest->period_us		+= src->period_us;
+	dest->period_guest_sys	+= src->period_guest_sys;
+	dest->period_guest_us	+= src->period_guest_us;
+	dest->nr_events		+= src->nr_events;
+}
+
 static void hist_entry__decay(struct hist_entry *he)
 {
 	he->stat.period = (he->stat.period * 7) / 8;
@@ -270,8 +286,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(entry, he);
 
 		if (!cmp) {
-			he->stat.period += period;
-			++he->stat.nr_events;
+			he_stat__add_period(&he->stat, period);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -418,12 +433,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		cmp = hist_entry__collapse(iter, he);
 
 		if (!cmp) {
-			iter->stat.period		+= he->stat.period;
-			iter->stat.period_sys		+= he->stat.period_sys;
-			iter->stat.period_us		+= he->stat.period_us;
-			iter->stat.period_guest_sys	+= he->stat.period_guest_sys;
-			iter->stat.period_guest_us	+= he->stat.period_guest_us;
-			iter->stat.nr_events		+= he->stat.nr_events;
+			he_stat__add_stat(&iter->stat, &he->stat);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
