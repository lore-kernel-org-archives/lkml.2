Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab1K1XT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:19:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48693 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab1K1XOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/25] perf evlist: Introduce add_tracepoints method
Date: Mon, 28 Nov 2011 21:14:05 -0200
Message-Id: <1322522066-21879-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Convenient way of asking for tracepoint events to be added to an
existing evlist.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0ylj4wrg54791u0baqb9swbb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |   57 +++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/evlist.h |    5 ++++
 tools/perf/util/setup.py |    3 +-
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 58aa1e0..3bc5a28 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -6,12 +6,13 @@
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
+#include "util.h"
+#include "debugfs.h"
 #include <poll.h>
 #include "cpumap.h"
 #include "thread_map.h"
 #include "evlist.h"
 #include "evsel.h"
-#include "util.h"
 
 #include "parse-events.h"
 
@@ -134,6 +135,60 @@ out_delete_partial_list:
 	return -1;
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
+				 const char *tracepoints[],
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
+	        attrs[i].sample_type   = (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME |
+					  PERF_SAMPLE_CPU);
+		attrs[i].sample_period = 1;
+	}
+
+	err = perf_evlist__add_attrs(evlist, attrs, nr_tracepoints);
+out_free_attrs:
+	free(attrs);
+	return err;
+}
+
 void perf_evlist__disable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 57d91ff..ec71c82 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -43,10 +43,15 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 int perf_evlist__add_attrs(struct perf_evlist *evlist,
 			   struct perf_event_attr *attrs, size_t nr_attrs);
+int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
+				 const char *tracepoints[], size_t nr_tracepoints);
 
 #define perf_evlist__add_attrs_array(evlist, array) \
 	perf_evlist__add_attrs(evlist, array, ARRAY_SIZE(array))
 
+#define perf_evlist__add_tracepoints_array(evlist, array) \
+	perf_evlist__add_tracepoints(evlist, array, ARRAY_SIZE(array))
+
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 95d3700..36d4c56 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -27,7 +27,8 @@ build_tmp = getenv('PYTHON_EXTBUILD_TMP')
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
-			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c'],
+			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c',
+			     'util/debugfs.c'],
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
                  )
-- 
1.7.8.rc0.35.gee6df

