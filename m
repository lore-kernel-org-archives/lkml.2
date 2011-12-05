Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab1LEMga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:36:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab1LEMg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:36:28 -0500
Date: Mon, 5 Dec 2011 04:34:59 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-5nffmdt5mu6ozxgj54oi4qon@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf python: Fix undefined symbol problem
Git-Commit-ID: 0e2a5f10fb550835e199a3b56a80ed88232188e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:35:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e2a5f10fb550835e199a3b56a80ed88232188e9
Gitweb:     http://git.kernel.org/tip/0e2a5f10fb550835e199a3b56a80ed88232188e9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 4 Nov 2011 08:16:58 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Nov 2011 10:02:26 -0200

perf python: Fix undefined symbol problem

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
