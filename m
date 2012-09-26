Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2IZH7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:59:42 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55720 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2IZH4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:08 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-40-5062b51595b1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 06/16] perf evlist: Add perf_evlist__recalc_nr_groups
Date: Wed, 26 Sep 2012 16:47:33 +0900
Message-Id: <1348645663-25303-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
References: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

During the event parsing, perf_evlist can have leader-only groups
which has nr_members as 1.  Since they has no difference than a normal
non-group event don't count them as a event group.

Add perf_evlist__recalc_nr_groups to count actual group numbers.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c |  3 +++
 tools/perf/util/evlist.c    | 16 ++++++++++++++++
 tools/perf/util/evlist.h    |  1 +
 3 files changed, 20 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2cb74343de3e..99ad5234e6ff 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -212,6 +212,9 @@ static int perf_record__open(struct perf_record *rec)
 	if (opts->group)
 		perf_evlist__set_leader(evlist);
 
+	if (evlist->nr_groups)
+		perf_evlist__recalc_nr_groups(evlist);
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
 		/*
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 199b6f1c3b22..0dcc443716b7 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -133,6 +133,22 @@ void perf_evlist__set_leader(struct perf_evlist *evlist)
 	}
 }
 
+void perf_evlist__recalc_nr_groups(struct perf_evlist *evlist)
+{
+	int count = 0;
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		/*
+		 * Don't count leader-only groups for simplicity.
+		 */
+		if (perf_evsel__is_group_leader(evsel) &&
+		    evsel->nr_members > 0)
+			count++;
+	}
+	evlist->nr_groups = count;
+}
+
 int perf_evlist__add_default(struct perf_evlist *evlist)
 {
 	struct perf_event_attr attr = {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 946a6ada817b..439b1375c4ea 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -120,6 +120,7 @@ int perf_evlist__set_filters(struct perf_evlist *evlist);
 
 void __perf_evlist__set_leader(struct list_head *list);
 void perf_evlist__set_leader(struct perf_evlist *evlist);
+void perf_evlist__recalc_nr_groups(struct perf_evlist *evlist);
 
 u64 perf_evlist__sample_type(struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(struct perf_evlist *evlist);
-- 
1.7.11.4

