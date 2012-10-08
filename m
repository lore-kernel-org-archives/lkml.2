Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2JHRSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:18:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49381 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab2JHRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:10 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 01/12] perf evlist: restore some methods removed in an earlier cleanup
Date: Mon,  8 Oct 2012 11:17:25 -0600
Message-Id: <1349716656-48165-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e60fc847 removed the perf_evlist__add_tracepoints and helpers, but
they are useful for kvm's upcoming live mode.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/evlist.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |    3 +++
 2 files changed, 57 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a41dc4a..a409b25 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -189,6 +189,60 @@ int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 	return perf_evlist__add_attrs(evlist, attrs, nr_attrs);
 }
 
+static int trace_event__id(const char *evname)
+{
+	char *filename, *colon;
+	int err = -1, fd;
+
+	if (asprintf(&filename, "%s/%s/id", tracing_events_path, evname) < 0)
+		return -1;
+
+	colon = strrchr(filename, ':');
+	if (colon != NULL)
+		*colon = '/';
+
+	fd = open(filename, O_RDONLY);
+	if (fd >= 0) {
+		char id[16];
+		if (read(fd, id, sizeof(id)) > 0)
+			err = atoi(id);
+		close(fd);
+	}
+
+	free(filename);
+	return err;
+}
+
+int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
+				 const char * const tracepoints[],
+				 size_t nr_tracepoints)
+{
+	int err;
+	size_t i;
+	struct perf_event_attr *attrs = zalloc(nr_tracepoints * sizeof(*attrs));
+
+	if (attrs == NULL)
+		return -1;
+
+	for (i = 0; i < nr_tracepoints; i++) {
+		err = trace_event__id(tracepoints[i]);
+
+		if (err < 0)
+			goto out_free_attrs;
+
+		attrs[i].type	       = PERF_TYPE_TRACEPOINT;
+		attrs[i].config	       = err;
+		attrs[i].sample_type   = (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME |
+					  PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD);
+		attrs[i].sample_period = 1;
+	}
+
+	err = perf_evlist__add_attrs(evlist, attrs, nr_tracepoints);
+out_free_attrs:
+	free(attrs);
+	return err;
+}
+
 struct perf_evsel *
 perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
 {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 56003f7..be85147 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -53,6 +53,9 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 				     struct perf_event_attr *attrs, size_t nr_attrs);
+int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
+				 const char * const tracepoints[],
+				 size_t nr_tracepoints);
 
 #define perf_evlist__add_default_attrs(evlist, array) \
 	__perf_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
-- 
1.7.10.1

