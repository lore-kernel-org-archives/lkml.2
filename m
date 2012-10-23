Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2JWHrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:47:51 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46570 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab2JWHok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:44:40 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-4b-50864ae6b8ca
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/12] perf hists: Maintain total periods of group members in the leader
Date: Tue, 23 Oct 2012 16:43:58 +0900
Message-Id: <1350978246-3686-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350978246-3686-1-git-send-email-namhyung@kernel.org>
References: <1350978246-3686-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Like group_stats in hist_entry, total periods information also need to
be known to the leader.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 25 +++++++++++++++++++++++++
 tools/perf/util/hist.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 95415716c708..48488057c3da 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -194,6 +194,28 @@ static void hist_entry__add_group_stat(struct hist_entry *he_dest,
 		he_stat__add_stat(&he_dest->group_stats[evsel->group_idx], src);
 }
 
+static void hists__add_group_stat(struct hists *hists)
+{
+	struct perf_evsel *evsel = hists_2_evsel(hists);
+	struct perf_evsel *leader = evsel->leader;
+	struct hists *leader_hists;
+
+	if (perf_evsel__is_group_leader(evsel))
+		return;
+
+	leader_hists = &leader->hists;
+
+	if (!leader_hists->group_stats) {
+		leader_hists->group_stats = calloc(leader->nr_members,
+						   sizeof(struct events_stats));
+		if (!leader_hists->group_stats)
+			return;
+	}
+
+	memcpy(&leader_hists->group_stats[evsel->group_idx],
+	       &hists->stats, sizeof(struct events_stats));
+}
+
 static void hist_entry__decay(struct hist_entry *he)
 {
 	he->stat.period = (he->stat.period * 7) / 8;
@@ -561,6 +583,9 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 			hists__apply_filters(hists, n);
 		}
 	}
+
+	if (symbol_conf.event_group)
+		hists__add_group_stat(hists);
 }
 
 void hists__collapse_resort(struct hists *hists)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c751624d4153..8d89dd23f20f 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -66,6 +66,7 @@ struct hists {
 	const char		*symbol_filter_str;
 	pthread_mutex_t		lock;
 	struct events_stats	stats;
+	struct events_stats	*group_stats;
 	u64			event_stream;
 	u16			col_len[HISTC_NR_COLS];
 };
-- 
1.7.11.7

