Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2KNHia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:38:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44266 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2KNHi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:38:29 -0500
Date: Tue, 13 Nov 2012 23:38:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-l9l9ieozqdhn9lieokd95okw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Introduce hists__link
Git-Commit-ID: 494d70a18137d18f0728fab7ad4f56aba29d1982
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:38:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  494d70a18137d18f0728fab7ad4f56aba29d1982
Gitweb:     http://git.kernel.org/tip/494d70a18137d18f0728fab7ad4f56aba29d1982
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 8 Nov 2012 18:03:09 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Nov 2012 18:08:15 -0300

perf hists: Introduce hists__link

That given two hists will find the hist_entries (buckets) in the second
hists that are for the same bucket in the first and link them, then it
will look for all buckets in the second that don't have a counterpart in
the first and will create a dummy counterpart that will then be linked
to the entry in the second.

For multiple events this will be done pairing the leader with all the
other events in the group, so that in the end the leader will have all
the buckets in all the hists in a group, dummy or not while the other
hists will be left untouched.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-l9l9ieozqdhn9lieokd95okw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h |    1 +
 2 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c1de3b0..7c6e73b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -717,6 +717,42 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 	++hists->stats.nr_events[type];
 }
 
+static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
+						 struct hist_entry *pair)
+{
+	struct rb_node **p = &hists->entries.rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *he;
+	int cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		he = rb_entry(parent, struct hist_entry, rb_node);
+
+		cmp = hist_entry__cmp(pair, he);
+
+		if (!cmp)
+			goto out;
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	he = hist_entry__new(pair);
+	if (he) {
+		he->stat.nr_events = 0;
+		he->stat.period    = 0;
+		he->hists	   = hists;
+		rb_link_node(&he->rb_node, parent, p);
+		rb_insert_color(&he->rb_node, &hists->entries);
+		hists__inc_nr_entries(hists, he);
+	}
+out:
+	return he;
+}
+
 static struct hist_entry *hists__find_entry(struct hists *hists,
 					    struct hist_entry *he)
 {
@@ -753,3 +789,27 @@ void hists__match(struct hists *leader, struct hists *other)
 			hist__entry_add_pair(pos, pair);
 	}
 }
+
+/*
+ * Look for entries in the other hists that are not present in the leader, if
+ * we find them, just add a dummy entry on the leader hists, with period=0,
+ * nr_events=0, to serve as the list header.
+ */
+int hists__link(struct hists *leader, struct hists *other)
+{
+	struct rb_node *nd;
+	struct hist_entry *pos, *pair;
+
+	for (nd = rb_first(&other->entries); nd; nd = rb_next(nd)) {
+		pos = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (!hist_entry__has_pairs(pos)) {
+			pair = hists__add_dummy_entry(leader, pos);
+			if (pair == NULL)
+				return -1;
+			hist__entry_add_pair(pair, pos);
+		}
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ff1c396..1278c2c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -116,6 +116,7 @@ void hists__reset_col_len(struct hists *hists);
 void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 
 void hists__match(struct hists *leader, struct hists *other);
+int hists__link(struct hists *leader, struct hists *other);
 
 struct perf_hpp {
 	char *buf;
