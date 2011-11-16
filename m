Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1KPOwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:52:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:39887 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1KPOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:52:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf python: Fix undefined symbol problem
Date: Wed, 16 Nov 2011 12:51:38 -0200
Message-Id: <1321455099-7110-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1321455099-7110-1-git-send-email-acme@infradead.org>
References: <1321455099-7110-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Recently we made perf_evsel__init call hists__init, which broke the perf
python binding:

[root@emilia linux]# ./tools/perf/python/twatch.py
Traceback (most recent call last):
  File "./tools/perf/python/twatch.py", line 16, in <module>
    import perf
ImportError: /home/acme/git/build/perf/python/perf.so: undefined symbol: hists__init

Fix it by moving the hists__init function to its only caller, evsel.c.

This way we avoid dragging in other parts of tools/perf/util/ to the
perf python binding.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5nffmdt5mu6ozxgj54oi4qon@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |   10 ++++++++++
 tools/perf/util/hist.c  |   10 ----------
 tools/perf/util/hist.h  |    2 --
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e426264..d7915d4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -34,6 +34,16 @@ int __perf_evsel__sample_size(u64 sample_type)
 	return size;
 }
 
+static void hists__init(struct hists *hists)
+{
+	memset(hists, 0, sizeof(*hists));
+	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
+	hists->entries_in = &hists->entries_in_array[0];
+	hists->entries_collapsed = RB_ROOT;
+	hists->entries = RB_ROOT;
+	pthread_mutex_init(&hists->lock, NULL);
+}
+
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a36a3fa..abef270 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1211,13 +1211,3 @@ size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
 
 	return ret;
 }
-
-void hists__init(struct hists *hists)
-{
-	memset(hists, 0, sizeof(*hists));
-	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
-	hists->entries_in = &hists->entries_in_array[0];
-	hists->entries_collapsed = RB_ROOT;
-	hists->entries = RB_ROOT;
-	pthread_mutex_init(&hists->lock, NULL);
-}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c86c1d2..89289c8 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -63,8 +63,6 @@ struct hists {
 	struct callchain_cursor	callchain_cursor;
 };
 
-void hists__init(struct hists *hists);
-
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *parent, u64 period);
-- 
1.7.8.rc0.35.gee6df

