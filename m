Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1LEMqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:46:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56719 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1LEMqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:46:34 -0500
Date: Mon, 5 Dec 2011 04:45:29 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-1btwadnf2tds2g07hsccsdse@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Introduce perf_evlist__add_attrs
Git-Commit-ID: 50d08e47bc04eb05502f5c86b70bbd19ef1c2778
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:45:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50d08e47bc04eb05502f5c86b70bbd19ef1c2778
Gitweb:     http://git.kernel.org/tip/50d08e47bc04eb05502f5c86b70bbd19ef1c2778
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 4 Nov 2011 09:10:59 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:24:43 -0200

perf evlist: Introduce perf_evlist__add_attrs

Replacing the open coded equivalents in 'perf stat'.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1btwadnf2tds2g07hsccsdse@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |   40 +++++++---------------------------------
 tools/perf/util/evlist.c  |   34 ++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h  |    7 +++++++
 3 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7d98676..227befb 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1107,22 +1107,13 @@ static const struct option options[] = {
  */
 static int add_default_attributes(void)
 {
-	struct perf_evsel *pos;
-	size_t attr_nr = 0;
-	size_t c;
-
 	/* Set attrs if no event is selected and !null_run: */
 	if (null_run)
 		return 0;
 
 	if (!evsel_list->nr_entries) {
-		for (c = 0; c < ARRAY_SIZE(default_attrs); c++) {
-			pos = perf_evsel__new(default_attrs + c, c + attr_nr);
-			if (pos == NULL)
-				return -1;
-			perf_evlist__add(evsel_list, pos);
-		}
-		attr_nr += c;
+		if (perf_evlist__add_attrs_array(evsel_list, default_attrs) < 0)
+			return -1;
 	}
 
 	/* Detailed events get appended to the event list: */
@@ -1131,38 +1122,21 @@ static int add_default_attributes(void)
 		return 0;
 
 	/* Append detailed run extra attributes: */
-	for (c = 0; c < ARRAY_SIZE(detailed_attrs); c++) {
-		pos = perf_evsel__new(detailed_attrs + c, c + attr_nr);
-		if (pos == NULL)
-			return -1;
-		perf_evlist__add(evsel_list, pos);
-	}
-	attr_nr += c;
+	if (perf_evlist__add_attrs_array(evsel_list, detailed_attrs) < 0)
+		return -1;
 
 	if (detailed_run < 2)
 		return 0;
 
 	/* Append very detailed run extra attributes: */
-	for (c = 0; c < ARRAY_SIZE(very_detailed_attrs); c++) {
-		pos = perf_evsel__new(very_detailed_attrs + c, c + attr_nr);
-		if (pos == NULL)
-			return -1;
-		perf_evlist__add(evsel_list, pos);
-	}
+	if (perf_evlist__add_attrs_array(evsel_list, very_detailed_attrs) < 0)
+		return -1;
 
 	if (detailed_run < 3)
 		return 0;
 
 	/* Append very, very detailed run extra attributes: */
-	for (c = 0; c < ARRAY_SIZE(very_very_detailed_attrs); c++) {
-		pos = perf_evsel__new(very_very_detailed_attrs + c, c + attr_nr);
-		if (pos == NULL)
-			return -1;
-		perf_evlist__add(evsel_list, pos);
-	}
-
-
-	return 0;
+	return perf_evlist__add_attrs_array(evsel_list, very_very_detailed_attrs);
 }
 
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index fbb4b4a..58aa1e0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -13,6 +13,8 @@
 #include "evsel.h"
 #include "util.h"
 
+#include "parse-events.h"
+
 #include <sys/mman.h>
 
 #include <linux/bitops.h>
@@ -76,6 +78,14 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
 	++evlist->nr_entries;
 }
 
+static void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
+					  struct list_head *list,
+					  int nr_entries)
+{
+	list_splice_tail(list, &evlist->entries);
+	evlist->nr_entries += nr_entries;
+}
+
 int perf_evlist__add_default(struct perf_evlist *evlist)
 {
 	struct perf_event_attr attr = {
@@ -100,6 +110,30 @@ error:
 	return -ENOMEM;
 }
 
+int perf_evlist__add_attrs(struct perf_evlist *evlist,
+			   struct perf_event_attr *attrs, size_t nr_attrs)
+{
+	struct perf_evsel *evsel, *n;
+	LIST_HEAD(head);
+	size_t i;
+
+	for (i = 0; i < nr_attrs; i++) {
+		evsel = perf_evsel__new(attrs + i, evlist->nr_entries + i);
+		if (evsel == NULL)
+			goto out_delete_partial_list;
+		list_add_tail(&evsel->node, &head);
+	}
+
+	perf_evlist__splice_list_tail(evlist, &head, nr_attrs);
+
+	return 0;
+
+out_delete_partial_list:
+	list_for_each_entry_safe(evsel, n, &head, node)
+		perf_evsel__delete(evsel);
+	return -1;
+}
+
 void perf_evlist__disable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 1779ffe..57d91ff 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -2,8 +2,10 @@
 #define __PERF_EVLIST_H 1
 
 #include <linux/list.h>
+#include <stdio.h>
 #include "../perf.h"
 #include "event.h"
+#include "util.h"
 
 struct pollfd;
 struct thread_map;
@@ -39,6 +41,11 @@ void perf_evlist__delete(struct perf_evlist *evlist);
 
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
+int perf_evlist__add_attrs(struct perf_evlist *evlist,
+			   struct perf_event_attr *attrs, size_t nr_attrs);
+
+#define perf_evlist__add_attrs_array(evlist, array) \
+	perf_evlist__add_attrs(evlist, array, ARRAY_SIZE(array))
 
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
