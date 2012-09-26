Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2IZH6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:58:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55720 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2IZH4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:09 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-49-5062b5168c89
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 09/16] perf hists: Maintain total periods of group members in the leader
Date: Wed, 26 Sep 2012 16:47:36 +0900
Message-Id: <1348645663-25303-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
References: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Like group_stats in hist_entry, total periods information also need to
be known to the leader.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 25 +++++++++++++++++++++++++
 tools/perf/util/hist.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 319822dee77b..8f01fc46ca88 100644
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
@@ -557,6 +579,9 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 			hists__apply_filters(hists, n);
 		}
 	}
+
+	if (symbol_conf.event_group)
+		hists__add_group_stat(hists);
 }
 
 void hists__collapse_resort(struct hists *hists)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f011ad4756e8..e13db91bc246 100644
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
1.7.11.4

