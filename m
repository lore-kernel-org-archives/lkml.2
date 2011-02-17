Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab1BQUmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:42:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab1BQUlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:41:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Arun Sharma <arun@sharma-home.net>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf: make perf stat print user provided full event names
Date: Thu, 17 Feb 2011 18:41:28 -0200
Message-Id: <1297975291-12792-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297975291-12792-1-git-send-email-acme@infradead.org>
References: <1297975291-12792-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch changes the way perf stat prints event names at the end of a
run. Until now, it was trying to reconstruct the event name from its
encoding. The problem is that it would only print generic events without
their modifiers (u, k, pp).

This patch saves the event name as passed by the user in the evsel
struct and uses it to print the final event name.

This would also work in case perf is linked with a library (such as
libpfm4) which provides full PMU event tables.

$ perf stat -e cycles:u,cycles:k date
Wed Feb 16 14:58:52 CET 2011

 Performance counter stats for 'date':

            568600 cycles:u
           2779715 cycles:k

        0.001908182  seconds time elapsed

Cc: Arun Sharma <arun@sharma-home.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@gmail.com>
LPU-Reference: <4d5bdc64.98a1df0a.7aa3.06c2@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
[ committer note: Fixed a merge problem with 023695d "Add cgroup support" ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c        |    1 +
 tools/perf/util/evsel.h        |    7 +++++++
 tools/perf/util/parse-events.c |   10 ++++++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c974e08..63cadaf 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -86,6 +86,7 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	perf_evsel__exit(evsel);
 	close_cgroup(evsel->cgrp);
+	free(evsel->name);
 	free(evsel);
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 1d3d5a3..f6fc8f6 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -37,6 +37,12 @@ struct perf_sample_id {
 	struct perf_evsel	*evsel;
 };
 
+/** struct perf_evsel - event selector
+ *
+ * @name - Can be set to retain the original event name passed by the user,
+ *         so that when showing results in tools such as 'perf stat', we
+ *         show the name used, not some alias.
+ */
 struct perf_evsel {
 	struct list_head	node;
 	struct perf_event_attr	attr;
@@ -45,6 +51,7 @@ struct perf_evsel {
 	struct xyarray		*id;
 	struct perf_counts	*counts;
 	int			idx;
+	char			*name;
 	void			*priv;
 	struct cgroup_sel	*cgrp;
 };
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index cf082da..80a3dd5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -268,6 +268,9 @@ const char *event_name(struct perf_evsel *evsel)
 	u64 config = evsel->attr.config;
 	int type = evsel->attr.type;
 
+	if (evsel->name)
+		return evsel->name;
+
 	return __event_name(type, config);
 }
 
@@ -782,8 +785,10 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
 	struct perf_event_attr attr;
 	enum event_result ret;
+	const char *ostr;
 
 	for (;;) {
+		ostr = str;
 		memset(&attr, 0, sizeof(attr));
 		ret = parse_event_symbols(opt, &str, &attr);
 		if (ret == EVT_FAILED)
@@ -798,6 +803,11 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 			if (evsel == NULL)
 				return -1;
 			perf_evlist__add(evlist, evsel);
+
+			evsel->name = calloc(str - ostr + 1, 1);
+			if (!evsel->name)
+				return -1;
+			strncpy(evsel->name, ostr, str - ostr);
 		}
 
 		if (*str == 0)
-- 
1.6.2.5

