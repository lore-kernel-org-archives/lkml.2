Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2LQGjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:39:24 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45648 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2LQGjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:11 -0500
X-AuditID: 9c930179-b7becae000000e51-71-50cebe0d1faa
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 05/14] perf report: Make another loop for linking group hists
Date: Mon, 17 Dec 2012 15:38:56 +0900
Message-Id: <1355726345-29553-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now the event grouping viewing requires linking all member hists in a
group to the leader's.  Thus hists__output_resort should be called
after linking all events in evlist.

Introduce symbol_conf.event_group flag to determine whether the
feature is enabled or not.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 13 ++++++++++++-
 tools/perf/util/symbol.h    |  3 ++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fc251005dd3d..a7b4cbe429b0 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -416,8 +416,16 @@ static int __cmd_report(struct perf_report *rep)
 			hists->symbol_filter_str = rep->symbol_filter_str;
 
 		hists__collapse_resort(hists);
-		hists__output_resort(hists);
 		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
+
+		/* Non-group events are considered as leader */
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos)) {
+			struct hists *leader_hists = &pos->leader->hists;
+
+			hists__match(leader_hists, hists);
+			hists__link(leader_hists, hists);
+		}
 	}
 
 	if (nr_samples == 0) {
@@ -425,6 +433,9 @@ static int __cmd_report(struct perf_report *rep)
 		goto out_delete;
 	}
 
+	list_for_each_entry(pos, &session->evlist->entries, node)
+		hists__output_resort(&pos->hists);
+
 	if (use_browser > 0) {
 		if (use_browser == 1) {
 			perf_evlist__tui_browse_hists(session->evlist, help,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ec7b2405c377..9e2b0c44bed8 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -96,7 +96,8 @@ struct symbol_conf {
 			initialized,
 			kptr_restrict,
 			annotate_asm_raw,
-			annotate_src;
+			annotate_src,
+			event_group;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.7.11.7

